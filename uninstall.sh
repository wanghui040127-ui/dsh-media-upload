#!/usr/bin/env bash
#
# uninstall.sh — restore the original DeepSeek Harness module files that were
# replaced by install.sh. Removes the *.bak restore files afterwards.
#
# Usage:
#   ./uninstall.sh [APP_PATH]
#
#   APP_PATH  Path to the DeepSeek Harness .app bundle
#             (default: $HOME/Desktop/DeepSeek-Harness-极简版/DeepSeek Harness.app)

set -euo pipefail

APP="${1:-$HOME/Desktop/DeepSeek-Harness-极简版/DeepSeek Harness.app}"
HOST_NM="$APP/Contents/Resources/runtime/host/node_modules/@deepseek-ai"

PATCHES=(
  "dsh-host-apiproxy/lib/index.js"
  "dsh-attachment-local/lib/index.js"
  "dsh-llm-deepseek/lib/index.js"
  "dsh-client-ui-conversation/lib/client.js"
)

if [ ! -d "$HOST_NM" ]; then
  echo "error: app bundle not found: $HOST_NM" >&2
  exit 1
fi

for rel in "${PATCHES[@]}"; do
  target="$HOST_NM/$rel"
  if [ -f "$target.bak" ]; then
    cp "$target.bak" "$target"
    rm "$target.bak"
    echo "  restored $rel"
  else
    echo "  no backup for $rel (skipped)"
  fi
done

echo
echo "Done. Quit and relaunch DeepSeek Harness to revert to the original behavior."