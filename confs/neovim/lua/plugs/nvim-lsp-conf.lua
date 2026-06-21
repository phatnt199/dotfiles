local mod = {
  "neovim/nvim-lspconfig",
  event = { "BufReadPre", "BufNewFile" },
  dependencies = {
    "saghen/blink.cmp",
  },
  config = function()
    -- Advertise blink.cmp's completion capabilities to every server.
    local ok_blink, blink = pcall(require, "blink.cmp")
    local capabilities = ok_blink and blink.get_lsp_capabilities()
        or vim.lsp.protocol.make_client_capabilities()

    require("plugs.lsp.diagnostics").setup()

    -- Per-language configs live in plugs/lsp/*.lua, aggregated by servers.lua.
    -- capabilities + flags are applied uniformly here so each language module
    -- only needs to declare its own settings.
    local defaults = {
      capabilities = capabilities,
      flags = { debounce_text_changes = 250 },
    }

    local servers = pairs(require("plugs.lsp.servers"))
    for name, conf in servers do
      vim.lsp.config(name, vim.tbl_deep_extend("force", defaults, conf))
      vim.lsp.enable(name)
    end
  end,
}

return mod
