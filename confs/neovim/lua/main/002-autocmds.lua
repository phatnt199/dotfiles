local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- Briefly highlight yanked text.
autocmd("TextYankPost", {
  group = augroup("highlight_yank", { clear = true }),
  callback = function()
    vim.hl.on_yank({ timeout = 150 })
  end,
})

-- Restore the last cursor position when reopening a file.
autocmd("BufReadPost", {
  group = augroup("restore_cursor", { clear = true }),
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local line_count = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= line_count then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Big-file guard: on very large or minified files, turn off the expensive
-- features (treesitter, syntax, folding, etc.) so the editor stays responsive.
autocmd("BufReadPre", {
  group = augroup("big_file_guard", { clear = true }),
  callback = function(args)
    local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(args.buf))
    local max_bytes = 1.5 * 1024 * 1024 -- 1.5 MB
    if not (ok and stats and stats.size > max_bytes) then
      return
    end
    vim.b[args.buf].big_file = true
    -- Disable treesitter highlight/indent for this buffer (see treesitter FileType autocmd).
    vim.schedule(function()
      if vim.api.nvim_buf_is_valid(args.buf) then
        pcall(vim.treesitter.stop, args.buf)
        vim.bo[args.buf].syntax = "off"
      end
    end)
    vim.opt_local.foldmethod = "manual"
    vim.opt_local.spell = false
    vim.opt_local.wrap = false
  end,
})

-- Remove Neovim 0.11+ default global `gr*` mappings (`grn`, `gra`, `grr`, `gri`, `grt`, `grx`)
-- so buffer-local `gr` (goto references) fires immediately with zero `timeoutlen` delay.
for _, lhs in ipairs({ "grn", "gra", "grr", "gri", "grt", "grx" }) do
  pcall(vim.keymap.del, { "n", "x" }, lhs)
  pcall(vim.keymap.del, "n", lhs)
end

local function organize_imports()
  vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" }, diagnostics = {} }, apply = true })
end

-- { lhs, handler, description, mode }
local LSP_KEYMAPS = {
  { "gD", vim.lsp.buf.declaration, "Goto declaration" },
  { "gd", vim.lsp.buf.definition, "Goto definition" },
  { "gi", vim.lsp.buf.implementation, "Goto implementation" },
  { "gr", vim.lsp.buf.references, "References" },
  { "K", vim.lsp.buf.hover, "Hover docs" },
  { "<C-k>", vim.lsp.buf.signature_help, "Signature help" },
  { "<leader>D", vim.lsp.buf.type_definition, "Type definition" },
  { "<leader>rn", vim.lsp.buf.rename, "Rename symbol" },
  { "<leader>ac", vim.lsp.buf.code_action, "Code action", { "n", "x" } },
  { "<leader>cl", vim.lsp.codelens.run, "Run CodeLens" },
  { "<leader>oi", organize_imports, "Organize imports" },
}

-- Buffer-local LSP keymaps, attached only when a server is active on the buffer.
autocmd("LspAttach", {
  group = augroup("lsp_attach_keymaps", { clear = true }),
  callback = function(event)
    for _, keymap in ipairs(LSP_KEYMAPS) do
      local lhs, handler, desc, mode = unpack(keymap)
      vim.keymap.set(mode or "n", lhs, handler, { buffer = event.buf, silent = true, desc = "LSP: " .. desc })
    end
  end,
})
