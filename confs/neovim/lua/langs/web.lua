-- CSS / HTML and component formats (formatted by bun fmt).

return {
  formatters = {
    css = { "bun_fmt" },
    scss = { "bun_fmt" },
    less = { "bun_fmt" },
    html = { "bun_fmt" },
    vue = { "bun_fmt" },
    svelte = { "bun_fmt" },
  },
  parsers = { "css", "html" },
}
