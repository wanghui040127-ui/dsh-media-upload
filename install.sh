#!/usr/bin/env bash
#
# install.sh — install the dsh-media-upload patch into a DeepSeek Harness app.
#
# This patch enables uploading images and PDF files in DeepSeek Harness by
# replacing 4 host module files inside the app bundle:
#
#   @deepseek-ai/dsh-host-apiproxy/lib/index.js           (upload type validation)
#   @deepseek-ai/dsh-attachment-local/lib/index.js        (media type limits)
#   @deepseek-ai/dsh-llm-deepseek/lib/index.js            (attachment -> text placeholder)
#   @deepseek-ai/dsh-client-ui-conversation/lib/client.js (client-side attachment mapping)
#
# Usage:
#   ./install.sh [APP_PATH]
#
#   APP_PATH  Path to the DeepSeek Harness .app bundle
#             (default: $HOME/Desktop/DeepSeek-Harness-极简版/DeepSeek Harness.app)
#
# What it does:
#   1. Locates the target module files inside the app bundle.
#   2. Backs up each original file once (as <file>.bak) before overwriting.
#   3. Copies the patched files from packages/ into place.
#   4. Prints the next step (restart the app).
#
# Idempotent: re-running is safe and refreshes the patched files; backups are
# kept so you can restore the originals with uninstall.sh.
#
# Requires: the app must be closed (or writeable) to allow overwriting.

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
APP="${1:-$HOME/Desktop/DeepSeek-Harness-极简版/DeepSeek Harness.app}"
HOST_NM="$APP/Contents/Resources/runtime/host/node_modules/@deepseek-ai"

PATCHES=(
  "dsh-host-apiproxy/lib/index.js"
  "dsh-attachment-local/lib/index.js"
  "dsh-llm-deepseek/lib/index.js"
  "dsh-client-ui-conversation/lib/client.js"
)

if [ ! -d "$HOST_NM" ]; then
  echo "error: app bundle not found or node_modules missing: $HOST_NM" >&2
  echo "usage: ./install.sh /path/to/DeepSeek Harness.app" >&2
  exit 1
fi

echo "Installing dsh-media-upload patch into: $APP"
echo

for rel in "${PATCHES[@]}"; do
  target="$HOST_NM/$rel"
  src="$SCRIPT_DIR/packages/$rel"
  if [ ! -f "$src" ]; then
    echo "  error: patch file missing: $src" >&2
    exit 1
  fi
  if [ ! -f "$target" ]; then
    echo "  error: target module file missing: $target" >&2
    exit 1
  fi

  # Backup once (never clobber an existing backup).
  if [ ! -f "$target.bak" ]; then
    cp "$target" "$target.bak"
  fi

  cp "$src" "$target"
  echo "  patched  $rel"
done

echo
echo "Done. Quit and relaunch DeepSeek Harness, then upload an image or PDF in a chat."
echo "Original files are backed up as *.bak next to each patched file."
echo "To restore, run: ./uninstall.sh \"$APP\""