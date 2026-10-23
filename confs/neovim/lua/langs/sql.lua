-- SQL (sql-language-server, pg_format).

return {
  lsp = {
    sqlls = {
      root_markers = { ".sqllsrc.json", ".git" },
    },
  },
  formatters = {
    sql = { "pg_format" },
  },
  parsers = { "sql" },
}
