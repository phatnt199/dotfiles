-- JSON (formatted by bun fmt).

return {
  formatters = {
    json = { "bun_fmt" },
    jsonc = { "bun_fmt" },
    json5 = { "bun_fmt" },
  },
  parsers = { "json", "json5" },
}
