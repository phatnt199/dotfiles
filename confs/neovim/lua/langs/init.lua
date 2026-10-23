-- Every language Neovim is set up for lives in its own file next to this one. A language file returns
--   lsp        = { <server name> = <vim.lsp.config table> }
--   formatters = { <filetype> = { <conform formatter>, ... } }
--   parsers    = { <treesitter parser>, ... }
-- All three are optional. Add a language by creating its file and listing it below.
local LANGUAGES = {
  "typescript",
  "json",
  "web",
  "markdown",
  "yaml",
  "lua",
  "python",
  "rust",
  "java",
  "dart",
  "shell",
  "sql",
  "toml",
  "misc",
}

local module = { servers = {}, formatters_by_ft = {}, parsers = {} }

for _, name in ipairs(LANGUAGES) do
  local language = require("langs." .. name)
  module.servers = vim.tbl_extend("error", module.servers, language.lsp or {})
  module.formatters_by_ft = vim.tbl_extend("error", module.formatters_by_ft, language.formatters or {})
  vim.list_extend(module.parsers, language.parsers or {})
end

return module
