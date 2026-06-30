#!/usr/bin/env bash
#
# Build the Taskflow macOS app (+ widget extension) from the command line.
# Run this on a Mac with Xcode 15+ installed.
#
# The app now embeds a WidgetKit extension and uses an App Group, so the build
# must be SIGNED with your Apple Developer Team (a free Apple ID works for
# local runs). Pass it via DEVELOPMENT_TEAM:
#
#   DEVELOPMENT_TEAM=ABCDE12345 ./build.sh            # Debug
#   DEVELOPMENT_TEAM=ABCDE12345 ./build.sh release    # Release
#   TASKFLOW_URL=https://...  DEVELOPMENT_TEAM=...  ./build.sh
#
# Find your Team ID: Xcode → Settings → Accounts → (your account) → the 10-char
# ID in parentheses, or run:  security find-identity -p codesigning -v
#
# Easiest path overall: open Taskflow.xcodeproj in Xcode, pick your Team under
# Signing & Capabilities for BOTH targets, and press ⌘R.
#
set -euo pipefail
cd "$(dirname "$0")"

CONFIG="Debug"
if [[ "${1:-}" == "release" ]]; then CONFIG="Release"; fi
DERIVED="build"

EXTRA=()
if [[ -n "${DEVELOPMENT_TEAM:-}" ]]; then
  EXTRA+=("DEVELOPMENT_TEAM=${DEVELOPMENT_TEAM}")
else
  echo "⚠️  DEVELOPMENT_TEAM is not set. Signing an app with an extension +"
  echo "    App Group requires a team. If this build fails, set DEVELOPMENT_TEAM"
  echo "    (see the header of this script) or build in Xcode instead."
fi

echo "▶ Building Taskflow ($CONFIG)…"
xcodebuild \
  -project Taskflow.xcodeproj \
  -scheme Taskflow \
  -configuration "$CONFIG" \
  -derivedDataPath "$DERIVED" \
  "${EXTRA[@]}" \
  build

APP_PATH="$DERIVED/Build/Products/$CONFIG/Taskflow.app"
echo ""
echo "✅ Built: $APP_PATH"
echo "   Open it with:  open \"$APP_PATH\""
