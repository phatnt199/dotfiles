# Bun
export BUN_INSTALL="$HOME/.bun"
prepend_path "$BUN_INSTALL/bin"
[ -s "$BUN_INSTALL/_bun" ] && source "$BUN_INSTALL/_bun"
