# Taskflow for macOS

A native macOS app that wraps the Taskflow web UI in a `WKWebView`. You get a
real `.app` — dock icon, menu bar, native window/toolbar, persistent login —
while reusing the existing Next.js front-end. One codebase, no rewrite.

> Built as a thin native shell. The UI inside the window is the same Taskflow
> web app, loaded from your deployed site.

## What you get

- Native window with **Back / Forward / Reload** toolbar buttons.
- Menu commands + shortcuts: Reload (`⌘R`), Home (`⇧⌘H`), Back (`⌘[`),
  Forward (`⌘]`), **Set Server URL…** (`⌘L`).
- **Persistent session** — the Supabase login cookie survives quit/relaunch
  (uses the default persistent `WKWebsiteDataStore`).
- **Auth that works** — email/password and *Continue with Google* both complete
  inside the app. Google normally blocks embedded webviews; the app presents a
  desktop-Safari user agent so the consent screen loads.
- External (third-party) links open in your real browser, not inside the app.
- App icon + accent color baked in.

## Requirements

- macOS 13 (Ventura) or newer.
- **Xcode 15+** (or the matching Command Line Tools) — needed to compile Swift.
  This project can only be *built on a Mac*; the sources here are ready to go.

## Quick start

```bash
cd macos

# Option A — Xcode UI
open Taskflow.xcodeproj      # then press ⌘R to build & run

# Option B — command line
./run.sh                      # build (Debug) + launch
./run.sh https://taskflow.yourdomain.com   # one-off URL override
```

If you only want the built app:

```bash
./build.sh release
open build/Build/Products/Release/Taskflow.app
```

## Pointing it at your site

The app resolves the URL to load in this order (first non-empty wins):

1. **`TASKFLOW_URL` environment variable** — great for `./run.sh <url>` or an
   Xcode scheme env var. Build-independent.
2. **Runtime override** — press `⌘L` in the app, type a URL, Save. Stored in
   `UserDefaults`, persists across launches.
3. **`TaskflowURL` key in `Taskflow/Info.plist`** — the value baked into the
   build. **This is the one to edit for a permanent default.**
4. Hardcoded fallback in `Taskflow/AppConfig.swift` (`defaultURL`).

Currently the baked-in default is `https://taskflow.promad.design`. Change it in
**`Taskflow/Info.plist`** (the `TaskflowURL` string) and/or
`Taskflow/AppConfig.swift`.

### Local development against `next dev`

Run the web app (`npm run dev` → `http://localhost:3000`) and launch the Mac app
pointing at it:

```bash
./run.sh http://localhost:3000
```

The entitlements + `NSAllowsLocalNetworking` already permit plain-http
`localhost`, so no extra config is needed.

## Code signing & distribution

- **Run on your own Mac:** nothing to do — `build.sh` builds unsigned/ad-hoc and
  Gatekeeper allows locally built apps you launch yourself.
- **Share with others / notarize:** open the project in Xcode, select the
  *Taskflow* target → *Signing & Capabilities*, pick your Team, then
  *Product → Archive* and distribute. The bundle id is `design.promad.taskflow`
  (change it if you don't own that identifier).

## Project layout

```
macos/
├── Taskflow.xcodeproj/          # Xcode project (+ shared scheme)
├── Taskflow/
│   ├── TaskflowApp.swift        # @main App + menu commands
│   ├── ContentView.swift        # SwiftUI chrome, toolbar, error + URL sheet
│   ├── WebView.swift            # WKWebView bridge + navigation policy
│   ├── AppConfig.swift          # URL resolution, user agent, auth-host rules
│   ├── Info.plist               # TaskflowURL default + ATS
│   ├── Taskflow.entitlements    # sandbox + outbound network
│   └── Assets.xcassets/         # AppIcon + AccentColor
├── build.sh                     # xcodebuild → ./build
└── run.sh                       # build + open
```

## Notes / limitations

- This is a *web wrapper*, so it needs your Taskflow site to be reachable
  (hosted, or `next dev` running locally). It is not an offline native rewrite.
- The app icon is generated programmatically (indigo→violet checklist motif).
  Drop your own PNGs into `Assets.xcassets/AppIcon.appiconset/` to replace it.
- Native desktop notifications for task activity aren't wired up yet — the web
  app's in-page notification bell still works inside the window. Ask if you want
  true macOS notifications via `UNUserNotificationCenter`.
```
