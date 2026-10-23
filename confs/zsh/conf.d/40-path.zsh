# Keep PATH entries unique automatically across nested shells, tmux panes, and reloads.
typeset -U path PATH

append_path () {
  [ -d "$1" ] && export PATH="$PATH:$1"
}

prepend_path () {
  [ -d "$1" ] && export PATH="$1:$PATH"
}

append_path "$HOME/.local/bin"
