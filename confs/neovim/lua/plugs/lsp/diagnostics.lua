-- Global diagnostic display configuration (not language-specific).

local M = {}

-- Severity -> highlight group ("DiagnosticSignError", ...), shared by the sign and its line number.
local SIGN_HIGHLIGHTS = {}
for _, name in ipairs({ "Error", "Warn", "Info", "Hint" }) do
  SIGN_HIGHLIGHTS[vim.diagnostic.severity[name:upper()]] = "DiagnosticSign" .. name
end

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
      texthl = SIGN_HIGHLIGHTS,
      numhl = SIGN_HIGHLIGHTS,
    },
  })
end

return M
