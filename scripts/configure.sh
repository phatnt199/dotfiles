#!/bin/sh
# Symlink all dotfiles into place. Idempotent — safe to re-run.
# ------------------------------------------------------------------
set -e

# Resolve the repo root from the script's own location (this script lives in
# scripts/, so the repo root is one level up), independent of the caller's cwd.
SCRIPT_DIR=$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)
BASE_FOLDER=$(CDPATH= cd -- "$SCRIPT_DIR/.." && pwd)
echo "Base folder: $BASE_FOLDER"

# ------------------------------------------------------------------
echo "Configuring ZSH..."
rm -rf "$HOME/.zshrc"
ln -s "$BASE_FOLDER/confs/zsh/.zshrc" "$HOME/.zshrc"

echo "Configuring TMUX..."
rm -rf "$HOME/.tmux.conf"
ln -s "$BASE_FOLDER/confs/tmux/.tmux.conf" "$HOME/.tmux.conf"

# ------------------------------------------------------------------
echo "Configuring NEOVIM..."
if ! command -v nvim > /dev/null 2>&1; then
  echo "NEOVIM is not installed | Required version >= 0.11 — skipping."
else
  echo "NEOVIM is installed | Start configuring..."
  rm -rf "$HOME/.config/nvim"
  mkdir -p "$HOME/.config"
  ln -s "$BASE_FOLDER/confs/neovim" "$HOME/.config/nvim"
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
  mkdir -p "$HOME/.config/alacritty"
  rm -rf "$HOME/.config/alacritty/alacritty.toml"
  ln -s "$BASE_FOLDER/confs/alacritty/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"
  # alacritty.toml imports its palette from this directory, so link it too.
  rm -rf "$HOME/.config/alacritty/themes"
  ln -s "$BASE_FOLDER/confs/alacritty/themes" "$HOME/.config/alacritty/themes"
fi

# ------------------------------------------------------------------
echo "Successfully configure all dotfiles!"
exit 0
