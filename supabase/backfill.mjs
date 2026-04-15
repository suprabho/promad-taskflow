/**
 * Backfill script — reads Notion CSV exports and generates SQL INSERT statements.
 *
 * Usage:
 *   node supabase/backfill.mjs
 *
 * Output:
 *   supabase/backfill.sql  (run this in your Supabase SQL Editor)
 */

import { readFileSync, writeFileSync } from "fs";
import { parse } from "csv-parse/sync";
import { randomUUID } from "crypto";
import { resolve, dirname } from "path";
import { fileURLToPath } from "url";

const __dirname = dirname(fileURLToPath(import.meta.url));

// ---------------------------------------------------------------------------
// Config
// ---------------------------------------------------------------------------

const USER_MAP = {
  "Suprabho Dhenki": "00000000-0000-0000-0000-000000000001",
  "Vanshika Garg": "00000000-0000-0000-0000-000000000002",
};

const DEFAULT_USER = "00000000-0000-0000-0000-000000000001";

// Status mapping: Notion → Taskflow
const STATUS_MAP = {
  "Not started": "todo",
  "In progress": "in_progress",
  "Waiting for review": "review",
  "Done": "done",
  "Paused": "paused",
};

// Priority mapping: Notion → Taskflow
const PRIORITY_MAP = {
  "Low": "low",
  "Medium": "medium",
  "High": "high",
};

// Task type mapping: Notion label → Taskflow type
// The first match in a multi-value field wins
const TASK_TYPE_MAP = {
  "Product Design - Feature request": "product_design",
  "💬 Product Design - Feature request": "product_design",
  "Product Design - Wireframes": "wireframe",
  "UI - Component": "ui_component",
  "Brand Guidelines": "branding",
  "Viz": "viz",
  "Animated Video - First Draft": "video",
  "Animated Videos": "video",
  "Video Edit": "video",
  "FrontEnd": "frontend",
  "Bug": "bug",
  "🐞 Bug": "bug",
  "Polish": "polish",
  "💅 Polish": "polish",
  "Iconography": "iconography",
  "Mascot Design": "viz",
  "Design Library": "ui_component",
  "NoCode Website": "frontend",
  "Website Asset": "viz",
  "Print Banner": "print",
  "Booklets Catalogs Brochure": "print",
  "Social Media Calendar": "social_media",
  "Course Design": "viz",
  "Comms": "chore",
  "Rive": "frontend",
  "Internal Product": "product_design",
};

// ---------------------------------------------------------------------------
// Helpers
// ---------------------------------------------------------------------------

function cleanProject(raw) {
  if (!raw) return null;
  // "Merkle Science Product (https://www.notion.so/...)" → "Merkle Science Product"
  return raw.replace(/\s*\(https?:\/\/[^)]+\)/g, "").trim() || null;
}

function parseAssignees(raw) {
  if (!raw) return [];
  return raw
    .split(",")
    .map((s) => s.trim())
    .map((name) => USER_MAP[name])
    .filter(Boolean);
}

function mapStatus(raw) {
  return STATUS_MAP[raw?.trim()] || "todo";
}

function mapPriority(raw) {
  return PRIORITY_MAP[raw?.trim()] || "medium";
}

function mapTaskType(raw) {
  if (!raw) return "chore";
  // May be comma-separated multi-value, e.g. "UI - Component, 💬 Product Design - Feature request"
  const parts = raw.split(",").map((s) => s.trim());
  for (const part of parts) {
    if (TASK_TYPE_MAP[part]) return TASK_TYPE_MAP[part];
  }
  // Fallback: try substring match
  const lower = raw.toLowerCase();
  if (lower.includes("product design")) return "product_design";
  if (lower.includes("wireframe")) return "wireframe";
  if (lower.includes("ui")) return "ui_component";
  if (lower.includes("brand")) return "branding";
  if (lower.includes("viz")) return "viz";
  if (lower.includes("video") || lower.includes("animated")) return "video";
  if (lower.includes("front") || lower.includes("website") || lower.includes("nocode")) return "frontend";
  if (lower.includes("bug")) return "bug";
  if (lower.includes("polish")) return "polish";
  if (lower.includes("icon")) return "iconography";
  if (lower.includes("social")) return "social_media";
  if (lower.includes("print") || lower.includes("brochure") || lower.includes("booklet")) return "print";
  return "chore";
}

function parseDueDate(raw) {
  // DD/MM/YYYY → YYYY-MM-DD
  // Also handles "DD/MM/YYYY HH:MM AM (GMT+5:30)" by stripping time portion
  if (!raw) return null;
  const cleaned = raw.trim().split(/\s/)[0]; // take only "DD/MM/YYYY" before any space
  const parts = cleaned.split("/");
  if (parts.length !== 3) return null;
  const [d, m, y] = parts;
  if (!y || !m || !d || y.length !== 4) return null;
  return `${y}-${m.padStart(2, "0")}-${d.padStart(2, "0")}`;
}

function parseUpdatedAt(raw) {
  // "March 17, 2025 8:44 AM" → ISO timestamp
  if (!raw) return new Date().toISOString();
  const d = new Date(raw);
  return isNaN(d.getTime()) ? new Date().toISOString() : d.toISOString();
}

function esc(str) {
  if (str === null || str === undefined) return "NULL";
  return "'" + String(str).replace(/'/g, "''") + "'";
}

// ---------------------------------------------------------------------------
// Read and parse CSVs
// ---------------------------------------------------------------------------

const csvAllPath = resolve(
  __dirname,
  "../../Private & Shared/Tasks Tracker 1b48cd8658a980259c07fc680e1ff3f8_all.csv"
);
const csvActivePath = resolve(
  __dirname,
  "../../Private & Shared/Tasks Tracker 1b48cd8658a980259c07fc680e1ff3f8.csv"
);

console.log("Reading _all CSV...");
const allBuf = readFileSync(csvAllPath);
const allRows = parse(allBuf, { columns: true, skip_empty_lines: true, bom: true });
console.log(`  → ${allRows.length} rows`);

console.log("Reading active CSV...");
const activeBuf = readFileSync(csvActivePath);
const activeRows = parse(activeBuf, { columns: true, skip_empty_lines: true, bom: true });
console.log(`  → ${activeRows.length} rows`);

// Build a set of active task names for status override
const activeStatusMap = new Map();
for (const row of activeRows) {
  const name = row["Task name"]?.trim();
  if (name) activeStatusMap.set(name, row["Status"]?.trim());
}

// ---------------------------------------------------------------------------
// Build tasks from _all CSV (deduplicate by name)
// ---------------------------------------------------------------------------

const seen = new Set();
const tasks = [];

for (const row of allRows) {
  const name = (row["Task name"] || "").trim();
  if (!name || seen.has(name)) continue;
  seen.add(name);

  // Use active CSV status if available (more current)
  const statusRaw = activeStatusMap.get(name) || row["Status"];
  const assignees = parseAssignees(row["Assignee"]);

  tasks.push({
    id: randomUUID(),
    name,
    details: (row["Summary"] || "").trim(),
    status: mapStatus(statusRaw),
    due_date: parseDueDate(row["Due date"]),
    priority: mapPriority(row["Priority"]),
    task_type: mapTaskType(row["Task type"]),
    assignees,
    workspace_id: "ws-1",
    created_by: assignees[0] || DEFAULT_USER,
    updated_at: parseUpdatedAt(row["Updated at"]),
  });
}

// Also add any tasks in the active CSV that weren't in _all
for (const row of activeRows) {
  const name = (row["Task name"] || "").trim();
  if (!name || seen.has(name)) continue;
  seen.add(name);

  const assignees = parseAssignees(row["Assignee"]);

  tasks.push({
    id: randomUUID(),
    name,
    details: (row["Summary"] || "").trim(),
    status: mapStatus(row["Status"]),
    due_date: parseDueDate(row["Due date"]),
    priority: mapPriority(row["Priority"]),
    task_type: mapTaskType(row["Task type"]),
    assignees,
    workspace_id: "ws-1",
    created_by: assignees[0] || DEFAULT_USER,
    updated_at: parseUpdatedAt(row["Updated at"]),
  });
}

// ---------------------------------------------------------------------------
// Generate SQL
// ---------------------------------------------------------------------------

let sql = `-- =============================================
-- Taskflow — Backfill from Notion export
-- Generated: ${new Date().toISOString()}
-- Total tasks: ${tasks.length}
-- =============================================

-- Clear existing tasks (safe for initial backfill)
DELETE FROM public.tasks WHERE workspace_id = 'ws-1';

`;

for (const t of tasks) {
  const assigneeSql =
    t.assignees.length > 0
      ? `ARRAY[${t.assignees.map((a) => `'${a}'`).join(",")}]::uuid[]`
      : "'{}'::uuid[]";

  sql += `INSERT INTO public.tasks (id, name, details, status, due_date, priority, task_type, assignees, workspace_id, created_by, created_at, updated_at)
VALUES (
  '${t.id}',
  ${esc(t.name)},
  ${esc(t.details)},
  ${esc(t.status)},
  ${t.due_date ? esc(t.due_date) : "NULL"},
  ${esc(t.priority)},
  ${esc(t.task_type)},
  ${assigneeSql},
  'ws-1',
  '${t.created_by}',
  ${esc(t.updated_at)},
  ${esc(t.updated_at)}
);
`;
}

// Summary
const byStatus = {};
for (const t of tasks) {
  byStatus[t.status] = (byStatus[t.status] || 0) + 1;
}

sql += `\n-- Summary:\n`;
for (const [status, count] of Object.entries(byStatus)) {
  sql += `--   ${status}: ${count}\n`;
}

const outPath = resolve(__dirname, "backfill.sql");
writeFileSync(outPath, sql, "utf-8");
console.log(`\nGenerated ${outPath}`);
console.log(`  ${tasks.length} tasks total`);
for (const [s, c] of Object.entries(byStatus)) {
  console.log(`    ${s}: ${c}`);
}
console.log("\nRun this in your Supabase SQL Editor to backfill.");
