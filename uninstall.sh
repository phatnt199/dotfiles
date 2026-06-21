#!/bin/sh
# One-shot uninstaller: remove every symlink the dotfiles created.
#
# This does NOT remove the system packages installed by install-deps.sh
# (ripgrep, git, build-essential, ...) — those are shared system tools and
# uninstalling them could break unrelated software. Remove them manually with
# `sudo apt-get remove <pkg>` if you really want to.
# ------------------------------------------------------------------
set -e

ROOT=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)

echo "==> Removing dotfile symlinks..."
sh "$ROOT/scripts/cleanup.sh"

echo "==> Uninstall complete."
exit 0
