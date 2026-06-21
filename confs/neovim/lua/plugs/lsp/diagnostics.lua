-- Global diagnostic display configuration (not language-specific).

local M = {}

function M.setup()
  vim.diagnostic.config({
    virtual_text = false,
    -- No inline messages by default; use <space>e to peek the current line
    -- in a float, or <leader>dl to toggle inline virtual_lines on/off.
    virtual_lines = false,
    underline = true,
    update_in_insert = false,
    float = { focusable = false },
    signs = {
      text = {
        [vim.diagnostic.severity.ERROR] = "󰅙",
        [vim.diagnostic.severity.WARN] = "◼",
        [vim.diagnostic.severity.INFO] = "",
        [vim.diagnostic.severity.HINT] = "󰌶",
      },
      texthl = {
        [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
        [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
        [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
        [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
      },
      numhl = {
        [vim.diagnostic.severity.ERROR] = "DiagnosticSignError",
        [vim.diagnostic.severity.WARN] = "DiagnosticSignWarn",
        [vim.diagnostic.severity.INFO] = "DiagnosticSignInfo",
        [vim.diagnostic.severity.HINT] = "DiagnosticSignHint",
      },
    },
  })
end

return M
