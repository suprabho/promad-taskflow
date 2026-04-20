/**
 * Backfill script — assigns `project` to existing tasks by matching name
 * against the Notion CSV exports.
 *
 * Usage:
 *   node supabase/backfill-projects.mjs
 *
 * Output:
 *   supabase/backfill-projects.sql  (run this in your Supabase SQL Editor)
 *
 * Requires the `project` column to exist (see migration-phase5.sql).
 */

import { readFileSync, writeFileSync } from "fs";
import { parse } from "csv-parse/sync";
import { resolve, dirname } from "path";
import { fileURLToPath } from "url";

const __dirname = dirname(fileURLToPath(import.meta.url));

function cleanProject(raw) {
  if (!raw) return null;
  // "Merkle Science Product (https://www.notion.so/...)" → "Merkle Science Product"
  const withoutUrls = raw.replace(/\s*\(https?:\/\/[^)]+\)/g, "");
  // Notion multi-select exports as "Project A, Project B" — take the first
  const first = withoutUrls.split(",")[0].trim();
  return first || null;
}

function esc(str) {
  if (str === null || str === undefined) return "NULL";
  return "'" + String(str).replace(/'/g, "''") + "'";
}

const csvAllPath = resolve(
  __dirname,
  "../../Private & Shared/Tasks Tracker 1b48cd8658a980259c07fc680e1ff3f8_all.csv"
);
const csvActivePath = resolve(
  __dirname,
  "../../Private & Shared/Tasks Tracker 1b48cd8658a980259c07fc680e1ff3f8.csv"
);

const allRows = parse(readFileSync(csvAllPath), {
  columns: true,
  skip_empty_lines: true,
  bom: true,
});
const activeRows = parse(readFileSync(csvActivePath), {
  columns: true,
  skip_empty_lines: true,
  bom: true,
});

// Map<taskName, project> — active CSV wins over _all if both have a value
const projectByName = new Map();
for (const row of allRows) {
  const name = (row["Task name"] || "").trim();
  const project = cleanProject(row["Projects"]);
  if (name && project) projectByName.set(name, project);
}
for (const row of activeRows) {
  const name = (row["Task name"] || "").trim();
  const project = cleanProject(row["Projects"]);
  if (name && project) projectByName.set(name, project);
}

let sql = `-- =============================================
-- Taskflow — Backfill project field from Notion CSVs
-- Generated: ${new Date().toISOString()}
-- Matches: ${projectByName.size} tasks with a project
-- =============================================

`;

for (const [name, project] of projectByName) {
  sql += `UPDATE public.tasks SET project = ${esc(project)} WHERE workspace_id = 'ws-1' AND name = ${esc(name)};\n`;
}

// Summary
const byProject = {};
for (const project of projectByName.values()) {
  byProject[project] = (byProject[project] || 0) + 1;
}
sql += `\n-- Summary:\n`;
for (const [project, count] of Object.entries(byProject).sort(
  (a, b) => b[1] - a[1]
)) {
  sql += `--   ${project}: ${count}\n`;
}

const outPath = resolve(__dirname, "backfill-projects.sql");
writeFileSync(outPath, sql, "utf-8");
console.log(`Generated ${outPath}`);
console.log(`  ${projectByName.size} task → project mappings`);
for (const [p, c] of Object.entries(byProject).sort((a, b) => b[1] - a[1])) {
  console.log(`    ${p}: ${c}`);
}
console.log("\nRun this in your Supabase SQL Editor to apply.");
