-- Lua (lua-language-server)
return {
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
}
