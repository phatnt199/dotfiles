-- Fast Lua color highlighter (replaces the old VimL lilydjwg/colorizer).
local mod = {
  "catgoose/nvim-colorizer.lua",
  event = { "BufReadPost", "BufNewFile" },
  opts = {},
}

return mod
