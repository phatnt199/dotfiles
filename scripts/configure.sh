#!/bin/sh
# Symlink all dotfiles into place. Idempotent — safe to re-run. An existing real file or folder
# is moved to <name>.dotfiles-bak, never deleted (cleanup.sh puts it back).
# ------------------------------------------------------------------
set -e

# Resolve the repo root from the script's own location (this script lives in
# scripts/, so the repo root is one level up), independent of the caller's cwd.
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
BASE_FOLDER=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
echo "Base folder: $BASE_FOLDER"

. "$SCRIPT_DIR/lib.sh"

# ------------------------------------------------------------------
echo "Configuring ZSH..."
link "$BASE_FOLDER/confs/zsh/.zshrc" "$HOME/.zshrc"

echo "Configuring TMUX..."
link "$BASE_FOLDER/confs/tmux/.tmux.conf" "$HOME/.tmux.conf"

# ------------------------------------------------------------------
echo "Configuring NEOVIM..."
if ! command -v nvim > /dev/null 2>&1; then
  echo "NEOVIM is not installed | Required version >= 0.11 — skipping."
else
  echo "NEOVIM is installed | Start configuring..."
  link "$BASE_FOLDER/confs/neovim" "$HOME/.config/nvim"
  # lazy.nvim bootstraps itself and installs every plugin on first launch.
  # Do it once now, headlessly; never fatal (plugins also install on next open).
  nvim --headless "+Lazy! sync" +qa || \
    echo "  (lazy sync skipped/failed — plugins will install on first launch)"
fi

# ------------------------------------------------------------------
echo "Configuring ALACRITTY..."
if ! command -v alacritty > /dev/null 2>&1; then
  echo "ALACRITTY is not installed — skipping."
else
  echo "ALACRITTY is installed | Start configuring..."
  link "$BASE_FOLDER/confs/alacritty/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"
  # alacritty.toml imports its palette from this directory, so link it too.
  link "$BASE_FOLDER/confs/alacritty/themes" "$HOME/.config/alacritty/themes"
fi

# ------------------------------------------------------------------
echo "Successfully configure all dotfiles!"
exit 0
