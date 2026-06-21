#!/bin/sh
# One-shot installer: install core dependencies, then symlink every config.
# Run this on a fresh machine. Individual steps live in scripts/.
# ------------------------------------------------------------------
set -e

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

echo "==> [1/2] Installing core dependencies..."
sh "$ROOT/scripts/install-deps.sh"

echo "==> [2/2] Linking dotfiles into place..."
sh "$ROOT/scripts/configure.sh"

echo "==> All done. Open a new shell (or 'source ~/.zshrc') to start using it."
exit 0
