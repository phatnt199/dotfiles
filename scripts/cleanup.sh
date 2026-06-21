#!/bin/sh
# Remove the symlinks created by configure.sh.
# Safe: these are all symlinks, so removing them never touches the repo or the
# files they point at.
# ------------------------------------------------------------------

rm -rf "$HOME/.zshrc"
rm -rf "$HOME/.tmux.conf"
rm -rf "$HOME/.config/alacritty/alacritty.toml"
rm -rf "$HOME/.config/alacritty/themes"
rm -rf "$HOME/.config/nvim"

echo "Successfully cleaning up!"
