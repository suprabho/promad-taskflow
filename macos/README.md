# Taskflow for macOS

A native macOS app for Taskflow with three surfaces:

1. **Main window** — your existing Taskflow web UI in a `WKWebView` (dock icon,
   native window/toolbar, persistent login).
2. **Menu-bar popover** — click the status-bar checklist icon for a
   **Today & Upcoming** list grouped by Client/Project, with tap-to-check and
   per-task snooze.
3. **Widget** — a Notification-Center / desktop widget showing the same
   Today & Upcoming checklist, with interactive check-off and snooze.

The window reuses your web front-end. The menu bar and widget read your task
data **directly from Supabase** (your RLS allows anon read + update), so they
work without the webview and can refresh on their own.

## Requirements

- **macOS 14 (Sonoma)** or newer — interactive widgets need it.
- **Xcode 15+**.
- A signing **Team** (a free Apple ID works for local runs). The widget
  extension + App Group must be code-signed; fully-unsigned builds won't work.

## Quick start

```bash
cd macos
open Taskflow.xcodeproj
```

In Xcode, **once**:

1. Select the **Taskflow** target → *Signing & Capabilities* → choose your Team.
2. Select the **TaskflowWidgetExtension** target → choose the **same** Team.
   (Both already declare the `group.design.promad.taskflow` App Group; Xcode
   provisions it automatically.)
3. Press **⌘R**.

Then connect your data:

4. Click the **checklist icon** in the menu bar → **Connect to Supabase…**
5. Paste your **Project URL** and **anon key** (the same public values your web
   app uses — `NEXT_PUBLIC_SUPABASE_URL` / `NEXT_PUBLIC_SUPABASE_ANON_KEY`),
   confirm the **Workspace ID** (`ws-1` by default), and Save.

The popover fills with today's + overdue tasks grouped by project. To add the
widget: right-click the desktop → *Edit Widgets* (or Notification Center →
*Edit Widgets*), find **Taskflow**, and drop it in.

### Command line (optional)

```bash
DEVELOPMENT_TEAM=ABCDE12345 ./run.sh            # build (Debug) + launch
DEVELOPMENT_TEAM=ABCDE12345 ./build.sh release  # release build
```

Find your Team ID in Xcode → Settings → Accounts (10-char ID in parentheses).

## How it works

| Surface | Data source | Writes |
|---|---|---|
| Main window | Your hosted web app (`TaskflowURL`) | via the web app |
| Menu-bar popover | Supabase REST (`fetchDayTasks`) | check off → `PATCH status=done` |
| Widget | Supabase REST + a cached snapshot in the App Group | check off → `ToggleTaskIntent` |

- **Today & Upcoming** = tasks with status `todo` or `in_progress` whose
  `due_date` is **today or later** (overdue and undated tasks are not shown), in
  the configured workspace. Grouping/sorting lives in `Shared/TaskModels.swift`
  (`DayPlanner`) so the popover and widget always agree.
- **Snooze** hides a task for the rest of the day. It's stored locally in the
  App Group (`activeSnoozedIDs`), **not** in Supabase — it's a personal "not
  today" toggle, so it never touches your shared data. Snoozes auto-clear at
  local midnight. In the popover, hover a row and click the moon button; in the
  widget, tap the moon (powered by `SnoozeTaskIntent`).
- Credentials + a task snapshot are stored in the **App Group**
  (`group.design.promad.taskflow`), shared between the app and the widget.
- Checking a task off does an optimistic UI update, then a Supabase `PATCH`, and
  reloads the widget timelines.

> Note: there are no subtasks in your schema yet, so the native views show
> Project → Tasks. Grouping is by the `project` text field.

## Pointing the window at your site

Separate from Supabase, the **window** loads a web URL, resolved in this order:
`TASKFLOW_URL` env → in-app override (⌘L) → `TaskflowURL` in
`Taskflow/Info.plist` → `defaultURL` in `Taskflow/AppConfig.swift`. Edit
`Info.plist` for a permanent default. For local dev: `./run.sh http://localhost:3000`.

## Project layout

```
macos/
├── Taskflow.xcodeproj/          # 2 targets: Taskflow (app) + TaskflowWidgetExtension
├── Shared/                      # compiled into BOTH targets
│   ├── TaskModels.swift         # TaskItem, ProjectGroup, DayPlanner (filter/group)
│   ├── SupabaseService.swift    # PostgREST read/update client
│   ├── AppGroupStore.swift      # shared config + task snapshot
│   └── ToggleTaskIntent.swift   # App Intent powering widget check-offs
├── Taskflow/                    # app target
│   ├── TaskflowApp.swift        # WindowGroup + MenuBarExtra + commands
│   ├── ContentView.swift / WebView.swift / AppConfig.swift   # web window
│   ├── DayStore.swift           # popover view-model
│   ├── MenuBarView.swift        # the popover UI
│   ├── ConnectSupabaseForm.swift
│   ├── Info.plist / Taskflow.entitlements (app group + network)
│   └── Assets.xcassets/
├── TaskflowWidget/              # widget extension target
│   ├── TaskflowWidgetBundle.swift / TaskflowWidget.swift
│   ├── Info.plist (WidgetKit) / TaskflowWidget.entitlements
├── build.sh / run.sh
```

## Troubleshooting

- **"Couldn't load tasks" in the popover** — check the URL/anon key via
  *Connect to Supabase…*. The anon key is the long `eyJ…` JWT, not the service
  key. Make sure the Workspace ID matches your data (`ws-1` for the seed data).
- **Widget shows "Connect Taskflow"** — the App Group isn't shared yet. Confirm
  both targets use the same Team and the same App Group, then launch the app
  once and connect.
- **Signing errors on the extension** — the extension's bundle id must stay a
  child of the app's (`design.promad.taskflow.TaskflowWidget`). Pick the same
  Team for both targets.
- **Nothing in the list** — you may simply have nothing due today/overdue. The
  popover header shows the open count; "All clear" means you're caught up.
```
