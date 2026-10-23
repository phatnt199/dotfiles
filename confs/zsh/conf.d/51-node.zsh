# Node: fast PATH wire-up + on-demand lazy load for the `nvm` CLI.
export NVM_DIR="$HOME/.nvm"
for _node_dir in "$NVM_DIR"/versions/node/v*; do
  [ -d "$_node_dir/bin" ] && _latest_node="$_node_dir/bin"
done
[ -n "$_latest_node" ] && prepend_path "$_latest_node"
unset _node_dir _latest_node

nvm () {
  unfunction nvm
  [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
  [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"
  nvm "$@"
}
