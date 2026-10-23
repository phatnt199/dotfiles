-- Lua (lua-language-server, stylua), plus the treesitter parsers Neovim itself needs.

return {
  lsp = {
    lua_ls = {
      settings = {
        Lua = {
          runtime = {
            version = "LuaJIT",
            path = { "lua/?.lua", "lua/?/init.lua" },
          },
          diagnostics = {
            globals = { "vim" },
          },
          workspace = {
            checkThirdParty = false,
            library = {
              vim.env.VIMRUNTIME,
            },
          },
          codeLens = { enable = true },
          hint = { enable = true, semicolon = "Disable" },
        },
      },
    },
  },
  formatters = {
    lua = { "stylua" },
  },
  parsers = { "lua", "vim", "vimdoc", "query" },
}
