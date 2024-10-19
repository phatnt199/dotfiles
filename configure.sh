#!/bin/sh
# ------------------------------------------------------------------
BASE_FOLDER=$(pwd)
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
is_neovim_available=$(command -v nvim > /dev/null)

if ! $is_neovim_available; then
  echo "NEOVIM is not installed | Required version >= 0.9"
  exit 1
else
  echo "NEOVIM is installed | Start configuring..."
  rm -rf "$HOME/.config/nvim"
  ln -s "$BASE_FOLDER/confs/neovim" "$HOME/.config/nvim"
  nvim +PlugInstall +qa
fi

# ------------------------------------------------------------------
echo "Configuring ALACRITTY..."
is_alacritty_available=$(command -v alacritty > /dev/null)

if ! $is_alacritty_available; then
  echo "ALACRITTY is not installed"
  exit 1
else
  mkdir -p "$HOME/.config/alacritty"
  echo "ALACRITTY is installed | Start configuring..."
  rm -rf "$HOME/.config/alacritty/alacritty.toml"
  ln -s "$BASE_FOLDER/confs/alacritty/alacritty.toml" "$HOME/.config/alacritty/alacritty.toml"
fi

echo "Successfully configure all dotfiles!"
exit 0
