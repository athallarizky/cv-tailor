#!/usr/bin/env bash
# ============================================================================
# cv-tailor compile — compile a resume .tex into .pdf, engine-agnostic.
#
# Engine resolution order: tectonic -> pdflatex -> xelatex -> latexmk
# Run scripts/setup.sh once if no engine is installed.
#
# Usage:  scripts/compile.sh path/to/cv_athalla-rizky_2026-09-23.tex
# Output: <same-dir>/<same-name>.pdf   (aux files cleaned up)
# ============================================================================
set -euo pipefail

TEX="${1:?usage: scripts/compile.sh <file.tex>}"
[ -f "$TEX" ] || { echo "ERROR: file not found: $TEX" >&2; exit 1; }

DIR="$(cd "$(dirname "$TEX")" && pwd)"
NAME="$(basename "$TEX" .tex)"
PDF="$DIR/$NAME.pdf"
LOG="$DIR/$NAME.log"

have() { command -v "$1" >/dev/null 2>&1; }

cd "$DIR"

# --- Compile with the first available engine -------------------------------
STATUS=0
if have tectonic; then
  echo ">> engine: tectonic"
  tectonic --keep-logs "$NAME.tex" || STATUS=$?
elif have pdflatex; then
  echo ">> engine: pdflatex (2 passes for hyperref/refs)"
  pdflatex -interaction=nonstopmode -halt-on-error "$NAME.tex" >/dev/null || STATUS=$?
  if [ "$STATUS" -eq 0 ]; then
    pdflatex -interaction=nonstopmode -halt-on-error "$NAME.tex" >/dev/null || STATUS=$?
  fi
elif have xelatex; then
  echo ">> engine: xelatex (2 passes for hyperref/refs)"
  xelatex -interaction=nonstopmode -halt-on-error "$NAME.tex" >/dev/null || STATUS=$?
  if [ "$STATUS" -eq 0 ]; then
    xelatex -interaction=nonstopmode -halt-on-error "$NAME.tex" >/dev/null || STATUS=$?
  fi
elif have latexmk; then
  echo ">> engine: latexmk"
  latexmk -pdf -interaction=nonstopmode "$NAME.tex" >/dev/null || STATUS=$?
else
  echo "ERROR: no LaTeX engine found. Run once:  ./scripts/setup.sh" >&2
  exit 127
fi

if [ "$STATUS" -ne 0 ]; then
  echo "ERROR: compilation failed (exit $STATUS). Last log lines:" >&2
  [ -f "$LOG" ] && tail -20 "$LOG" >&2
  exit 1
fi

[ -f "$PDF" ] || { echo "ERROR: compiler reported success but no PDF at $PDF" >&2; exit 2; }

# --- Verify page count ------------------------------------------------------
PAGES=""
if [ -f "$LOG" ]; then
  # LaTeX logs: "Output written on <file> (N pages, M bytes)." Works for both
  # pdfTeX (.pdf) and Tectonic (.xdv) — captures N only, never filename digits.
  PAGES="$(sed -nE 's/.*\(([0-9]+) pages?, .*/\1/p' "$LOG" | head -1 || true)"
fi
if [ -n "${PAGES:-}" ]; then
  echo ">> pages: $PAGES"
  if [ "$PAGES" -gt 2 ]; then
    echo "WARN: CV is $PAGES pages — ATS recruiters expect 1-2. Trim lower-priority bullets and recompile." >&2
  fi
fi

# --- Clean aux artifacts (keep .tex and .pdf only) --------------------------
rm -f "$NAME.aux" "$NAME.log" "$NAME.out" "$NAME.bbl" "$NAME.blg" "$NAME.fls" "$NAME.fdb_latexmk"

echo "OK: $PDF"
