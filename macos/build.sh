#!/usr/bin/env bash
#
# Build the Taskflow macOS app from the command line.
# Run this on a Mac with Xcode (or the Command Line Tools + Xcode) installed.
#
# Usage:
#   ./build.sh                 # Debug build into ./build
#   ./build.sh release         # Release build into ./build
#   TASKFLOW_URL=https://...    ./build.sh   # bake a different site URL at build time
#
set -euo pipefail
cd "$(dirname "$0")"

CONFIG="Debug"
if [[ "${1:-}" == "release" ]]; then CONFIG="Release"; fi

DERIVED="build"

echo "▶ Building Taskflow ($CONFIG)…"
xcodebuild \
  -project Taskflow.xcodeproj \
  -scheme Taskflow \
  -configuration "$CONFIG" \
  -derivedDataPath "$DERIVED" \
  CODE_SIGN_IDENTITY="-" \
  CODE_SIGNING_REQUIRED=NO \
  CODE_SIGNING_ALLOWED=NO \
  build

APP_PATH="$DERIVED/Build/Products/$CONFIG/Taskflow.app"
echo ""
echo "✅ Built: $APP_PATH"
echo "   Open it with:  open \"$APP_PATH\""
