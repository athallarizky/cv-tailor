#!/usr/bin/env bash
# ============================================================================
# cv-tailor setup — one-time installation of a local LaTeX PDF engine.
#
# Installs Tectonic (single static binary, no sudo, cross-platform).
# If any supported engine is already present, this script is a no-op.
#
# Usage: ./scripts/setup.sh
# ============================================================================
set -euo pipefail

ENGINES=(tectonic pdflatex xelatex latexmk)

have() { command -v "$1" >/dev/null 2>&1; }

# --- Skip if any engine is already available -------------------------------
for e in "${ENGINES[@]}"; do
  if have "$e"; then
    echo "OK: '$e' is already installed. No setup needed."
    exit 0
  fi
done

OS="$(uname -s)"

case "$OS" in
  Darwin)
    if ! have brew; then
      echo "ERROR: Homebrew not found. Install it from https://brew.sh then re-run: ./scripts/setup.sh" >&2
      exit 1
    fi
    echo "Installing Tectonic via Homebrew (one-time, ~30MB)..."
    brew install tectonic
    ;;

  Linux)
    ARCH="$(uname -m)"
    case "$ARCH" in
      x86_64)          TARCH="x86_64-unknown-linux-musl" ;;
      aarch64|arm64)   TARCH="aarch64-unknown-linux-musl" ;;
      *) echo "ERROR: unsupported architecture: $ARCH" >&2; exit 1 ;;
    esac
    VER="0.15.0"
    URL="https://github.com/tectonic-typesetting/tectonic/releases/download/tectonic%40${VER}/tectonic-${VER}-${TARCH}.tar.gz"
    DEST="${HOME}/.local/bin"
    mkdir -p "$DEST"
    echo "Downloading Tectonic ${VER} (${TARCH}) to ${DEST}..."
    curl -fsSL "$URL" | tar -xz -C "$DEST" tectonic
    case ":$PATH:" in
      *":$DEST:"*) ;;
      *) echo "NOTE: add to your PATH:  export PATH=\"${DEST}:\$PATH\"" ;;
    esac
    ;;

  MINGW*|MSYS*|CYGWIN*)
    echo "Windows detected. Run one of:" >&2
    echo "  winget install Tectonic.Tectonic" >&2
    echo "  scoop install tectonic" >&2
    exit 1
    ;;

  *)
    echo "ERROR: unsupported OS: $OS" >&2
    exit 1
    ;;
esac

if have tectonic; then
  echo "Setup complete: $(tectonic --version 2>&1 | head -1)"
else
  echo "Install finished, but 'tectonic' is not on PATH yet. Open a new shell, then verify with: tectonic --version" >&2
  exit 1
fi
