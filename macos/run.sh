#!/usr/bin/env bash
#
# Build (Debug) and launch the Taskflow macOS app.
#   ./run.sh                            # uses the configured URL
#   ./run.sh https://taskflow.you.dev   # one-off: load this URL
#
set -euo pipefail
cd "$(dirname "$0")"

if [[ -n "${1:-}" ]]; then export TASKFLOW_URL="$1"; fi

./build.sh
APP_PATH="build/Build/Products/Debug/Taskflow.app"

# Pass TASKFLOW_URL into the running app (AppConfig reads it first).
if [[ -n "${TASKFLOW_URL:-}" ]]; then
  open "$APP_PATH" --env TASKFLOW_URL="$TASKFLOW_URL"
else
  open "$APP_PATH"
fi
