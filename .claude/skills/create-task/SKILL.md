---
name: create-task
description: Create a new task in the Taskflow Supabase database from a natural-language prompt. Use when the user says things like "create a task to...", "add a task for...", "/create-task <description>", or otherwise asks to file a new task in this project.
---

# Create Task

Create a row in the `tasks` table of the Taskflow Supabase database based on the user's prompt.

## Inputs

The user's free-form description of the task. Parse it into these fields:

| Field | Type | Default | Notes |
|---|---|---|---|
| `name` | string | required | Short title (< 80 chars). Derive from the prompt. |
| `details` | string | `""` | Longer description. Use the prompt if it has multiple sentences; otherwise leave empty. |
| `status` | enum | `"todo"` | One of: `todo`, `in_progress`, `review`, `done`, `paused` |
| `priority` | enum | `"medium"` | One of: `low`, `medium`, `high`, `urgent`. Infer from words like "urgent", "asap", "low-pri", etc. |
| `task_type` | enum | `"product_design"` | One of: `product_design`, `ui_component`, `wireframe`, `branding`, `viz`, `video`, `frontend`, `bug`, `polish`, `iconography`, `social_media`, `print`, `docs`, `chore`. Pick the best fit from the prompt (e.g. "fix crash" → `bug`, "write docs" → `docs`, "new button component" → `ui_component`). |
| `due_date` | date `YYYY-MM-DD` or null | `null` | Parse relative dates ("tomorrow", "next Friday") against today's date. |
| `assignees` | uuid[] | `[]` | Leave empty unless the user names a person. Do not fabricate UUIDs. |

Do not ask clarifying questions for fields that have reasonable defaults. Only ask if the prompt is too vague to derive a `name`.

## Steps

1. Parse the prompt into the fields above.
2. Read `NEXT_PUBLIC_SUPABASE_URL` and `NEXT_PUBLIC_SUPABASE_ANON_KEY` from `.env.local` in the project root.
3. POST to the Supabase REST endpoint. The DB fills in `id`, `created_at`, `updated_at`, `workspace_id`, and server-side defaults.

Run this as a single Bash command (substitute `<URL>`, `<KEY>`, and the JSON body):

```bash
set -a && . .env.local && set +a && curl -sS -X POST \
  "$NEXT_PUBLIC_SUPABASE_URL/rest/v1/tasks" \
  -H "apikey: $NEXT_PUBLIC_SUPABASE_ANON_KEY" \
  -H "Authorization: Bearer $NEXT_PUBLIC_SUPABASE_ANON_KEY" \
  -H "Content-Type: application/json" \
  -H "Prefer: return=representation" \
  -d '{"name":"...","details":"...","status":"todo","priority":"medium","task_type":"product_design","due_date":null}'
```

4. If the response is a JSON array with a task object, report the `id` and `name` of the created task. If the response contains an `error` or `message` field, surface it to the user and do not claim success.

## Output

One line: `Created <name> (<id>)` — or the Supabase error if insert failed. Do not summarize the fields you chose unless the user asks.
