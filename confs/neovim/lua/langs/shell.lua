-- Bash / Shell (bash-language-server, shfmt).

return {
  lsp = {
    bashls = {}
,
  },
  formatters = {
    sh = { "shfmt" },
  },
  parsers = { "bash" },
}
