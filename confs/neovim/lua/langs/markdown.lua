-- Markdown (formatted by bun fmt).

return {
  formatters = {
    markdown = { "bun_fmt" },
    mdx = { "bun_fmt" },
  },
  parsers = { "markdown", "markdown_inline" },
}
