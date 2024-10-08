-- Diagnostic
vim.cmd [[
  sign define DiagnosticSignHint  text=⚉  texthl=DiagnosticSignHint   linehl=   numhl=DiagnosticLineNrHint
  sign define DiagnosticSignInfo  text=  texthl=DiagnosticSignInfo   linehl=   numhl=DiagnosticLineNrInfo
  sign define DiagnosticSignWarn  text=◼  texthl=DiagnosticSignWarn   linehl=   numhl=DiagnosticLineNrWarn
  sign define DiagnosticSignError text=  texthl=DiagnosticSignError  linehl=   numhl=DiagnosticLineNrError
]]

-- ColorScheme
vim.cmd('colorscheme devglow')
