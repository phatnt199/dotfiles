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

-- Buffer-local LSP keymaps, attached only when a server is active on the buffer.
autocmd("LspAttach", {
  group = augroup("lsp_attach_keymaps", { clear = true }),
  callback = function(event)
    local buf = event.buf
    local function map(lhs, fn, desc)
      vim.keymap.set("n", lhs, fn, { buffer = buf, silent = true, desc = "LSP: " .. desc })
    end

    map("gD", vim.lsp.buf.declaration, "Goto declaration")
    map("gd", vim.lsp.buf.definition, "Goto definition")
    map("gi", vim.lsp.buf.implementation, "Goto implementation")
    map("gr", vim.lsp.buf.references, "References")
    map("K", vim.lsp.buf.hover, "Hover docs")
    map("<C-k>", vim.lsp.buf.signature_help, "Signature help")
    map("<leader>D", vim.lsp.buf.type_definition, "Type definition")
    map("<leader>rn", vim.lsp.buf.rename, "Rename symbol")
    map("<leader>ac", vim.lsp.buf.code_action, "Code action")
    map("<leader>oi", function()
      vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })
    end, "Organize imports")
  end,
})
