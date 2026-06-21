#!/bin/sh
# Install the core CLI dependencies the dotfiles rely on at runtime.
# Idempotent — apt skips anything already installed. Run this once on a fresh
# machine BEFORE ./configure.sh. Needs sudo (it installs system packages).
#
# Not covered here (by design):
#   - Neovim / Alacritty / tmux / zsh — version-sensitive, install separately.
#   - Language servers & formatters — self-managed under $WORKSPACE_ENV.
# ------------------------------------------------------------------
set -e

if ! command -v apt-get > /dev/null 2>&1; then
  echo "This installer targets apt-based distros (Debian/Ubuntu)."
  echo "Install these manually with your package manager instead:"
  echo "  ripgrep, fzf, build-essential (gcc+make), curl, git, unzip,"
  echo "  and a clipboard tool (wl-clipboard on Wayland, or xclip/xsel on X11)."
  exit 1
fi

# Universal deps, independent of display server:
#   ripgrep         -> Telescope live grep
#   fzf             -> zsh fzf plugin + telescope-fzf-native
#   build-essential -> gcc/make to build telescope-fzf-native
#   curl, git       -> lazy.nvim bootstrap & general use
#   unzip           -> extracting language servers / tools
PACKAGES="ripgrep fzf build-essential curl git unzip"

# Clipboard tool depends on the display server.
if [ -n "$WAYLAND_DISPLAY" ] || [ "$XDG_SESSION_TYPE" = "wayland" ]; then
  echo "Detected Wayland session -> using wl-clipboard."
  PACKAGES="$PACKAGES wl-clipboard"
else
  echo "Detected X11 (or unknown) session -> using xclip."
  PACKAGES="$PACKAGES xclip"
fi

echo "Updating package lists..."
sudo apt-get update

echo "Installing: $PACKAGES"
# shellcheck disable=SC2086  # word splitting is intended for the package list
sudo apt-get install -y $PACKAGES

echo "Successfully installed core dependencies!"
echo "Next step: ./configure.sh"
exit 0
