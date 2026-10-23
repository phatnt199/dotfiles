# Entry point: loads every file in conf.d/ (next to the real file behind the ~/.zshrc symlink) in
# name order, then the machine-private ~/.zshrc.local if it exists. Edit the files in conf.d/.
_zsh_conf_dir=${${(%):-%x}:A:h}/conf.d

for _zsh_conf in "$_zsh_conf_dir"/*.zsh(N); do
  source "$_zsh_conf"
done
unset _zsh_conf _zsh_conf_dir

# Machine-private overrides (accounts, gateways, keys): not tracked by git. Skipped when absent.
if [[ -r "$HOME/.zshrc.local" ]]; then
  source "$HOME/.zshrc.local"
fi
