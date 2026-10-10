#!/usr/bin/env bash
# ============================================================================
# cv-tailor publish — archive a finished output folder to iCloud Drive.
#
# Copies only final artifacts (*.pdf *.tex *.md *.json); aux/log files never
# sync. The company folder is copied as-is (never flattened) so every
# application stays identifiable. Re-running overwrites in place, so
# re-publishing after a recompile is safe.
#
# Usage:   scripts/publish-icloud.sh output/growmodo_2026-09-23_14-56/
# Target:  ~/Library/Mobile Documents/com~apple~CloudDocs/iDocument/Generated-CV/<folder>/
#          (override the iCloud root with CV_ICLOUD_DIR)
# ============================================================================
set -euo pipefail

SRC="${1:?usage: scripts/publish-icloud.sh <output-dir>}"
[ -d "$SRC" ] || { echo "ERROR: directory not found: $SRC" >&2; exit 1; }

ICLOUD_ROOT="${CV_ICLOUD_DIR:-$HOME/Library/Mobile Documents/com~apple~CloudDocs}"
[ -d "$ICLOUD_ROOT" ] || { echo "ERROR: iCloud Drive not found at: $ICLOUD_ROOT" >&2; exit 1; }
DEST_ROOT="$ICLOUD_ROOT/iDocument/Generated-CV"

NAME="$(basename "${SRC%/}")"
DEST="$DEST_ROOT/$NAME"
mkdir -p "$DEST"

if ! ls "$SRC"/*.pdf >/dev/null 2>&1; then
  echo "WARN: no PDF in $SRC — did compile.sh run?" >&2
fi

copied=0
for f in "$SRC"/*.pdf "$SRC"/*.tex "$SRC"/*.md "$SRC"/*.json; do
  [ -e "$f" ] || continue
  cp -p "$f" "$DEST/"
  echo ">> $(basename "$f")"
  copied=$((copied + 1))
done

[ "$copied" -gt 0 ] || { echo "ERROR: nothing to publish in $SRC (no pdf/tex/md/json found)" >&2; exit 1; }

echo "OK: $copied file(s) -> $DEST"
