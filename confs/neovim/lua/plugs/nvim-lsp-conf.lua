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

    -- Apply shared capabilities to all servers via Neovim 0.11+ wildcard config.
    -- Note: legacy `flags.debounce_text_changes` is intentionally omitted so incremental
    -- sync reaches servers immediately without a 250ms artificial client-side delay.
    vim.lsp.config("*", {
      capabilities = capabilities,
    })

    local enabled = {}
    for name, conf in pairs(require("plugs.lsp.servers")) do
      if next(conf) ~= nil then
        vim.lsp.config(name, conf)
      end
      table.insert(enabled, name)
    end
    vim.lsp.enable(enabled)
  end,
}

return mod
