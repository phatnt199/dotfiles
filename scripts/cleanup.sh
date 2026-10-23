#!/bin/sh
# Remove the symlinks created by configure.sh, and put back any file it moved aside.
# Only symlinks that point into this repo are removed; real files and foreign links are left alone.
# ------------------------------------------------------------------
set -e

SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
BASE_FOLDER=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)

. "$SCRIPT_DIR/lib.sh"

unlink_ours "$BASE_FOLDER" "$HOME/.zshrc"
unlink_ours "$BASE_FOLDER" "$HOME/.tmux.conf"
unlink_ours "$BASE_FOLDER" "$HOME/.config/alacritty/alacritty.toml"
unlink_ours "$BASE_FOLDER" "$HOME/.config/alacritty/themes"
unlink_ours "$BASE_FOLDER" "$HOME/.config/nvim"

echo "Successfully cleaned up!"
exit 0
