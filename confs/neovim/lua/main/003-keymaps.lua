-- Global keymaps. LSP buffer-local maps live in 002-autocmds.lua (LspAttach).
local keymaps = {
  { mode = "i", shortcut = "jk",          fn = "<Esc>",                                   desc = "Exit insert mode" },
  { mode = "n", shortcut = "<C-s>",       fn = ":w<CR>",                                  desc = "Save file" },

  { mode = "n", shortcut = "<A-k>",       fn = "<C-y>",                                   desc = "Scroll up one line" },
  { mode = "n", shortcut = "<A-j>",       fn = "<C-e>",                                   desc = "Scroll down one line" },
  { mode = "n", shortcut = "<A-h>",       fn = "zh",                                      desc = "Scroll left" },
  { mode = "n", shortcut = "<A-l>",       fn = "zl",                                      desc = "Scroll right" },

  { mode = "n", shortcut = "<S-u>",       fn = ":redo<CR>",                               desc = "Redo" },

  { mode = "n", shortcut = "<C-Up>",      fn = ":resize -2<CR>",                          desc = "Decrease window height" },
  { mode = "n", shortcut = "<C-Down>",    fn = ":resize +2<CR>",                          desc = "Increase window height" },
  { mode = "n", shortcut = "<leader>rf",  fn = ":luafile %<CR>",                          desc = "Source current Lua file" },

  { mode = "n", shortcut = "<leader>tn",  fn = ":tabnew<CR>",                             desc = "New tab" },
  { mode = "n", shortcut = "<leader>tx",  fn = ":tabclose<CR>",                           desc = "Close tab" },

  { mode = "v", shortcut = "<A-S-j>",     fn = ":m '>+1<CR>gv=gv",                        desc = "Move selection down" },
  { mode = "v", shortcut = "<A-S-k>",     fn = ":m '<-2<CR>gv=gv",                        desc = "Move selection up" },

  { mode = "x", shortcut = "<leader>p",   fn = '"_dP',                                    desc = "Paste without yanking" },
  { mode = "n", shortcut = "<leader>y",   fn = '"+y',                                     desc = "Yank to system clipboard" },
  { mode = "v", shortcut = "<leader>y",   fn = '"+y',                                     desc = "Yank to system clipboard" },
  { mode = "n", shortcut = "<leader>Y",   fn = '"+Y',                                     desc = "Yank line to system clipboard" },

  { mode = "n", shortcut = "]q",          fn = ":cnext<CR>",                              desc = "Next quickfix item" },
  { mode = "n", shortcut = "[q",          fn = ":cprevious<CR>",                          desc = "Previous quickfix item" },

  -- Diagnostics (work without an attached LSP, so kept global).
  { mode = "n", shortcut = "<space>e",    fn = function() vim.diagnostic.open_float() end,                desc = "Show diagnostic float" },
  { mode = "n", shortcut = "]d",          fn = function() vim.diagnostic.jump({ count = 1, float = true }) end,   desc = "Next diagnostic" },
  { mode = "n", shortcut = "[d",          fn = function() vim.diagnostic.jump({ count = -1, float = true }) end,  desc = "Previous diagnostic" },
  { mode = "n", shortcut = "<space>q",    fn = function() vim.diagnostic.setloclist() end,                desc = "Diagnostics to loclist" },
  {
    mode = "n",
    shortcut = "<leader>dl",
    fn = function()
      local enabled = vim.diagnostic.config().virtual_lines
      vim.diagnostic.config({ virtual_lines = enabled and false or { current_line = true } })
    end,
    desc = "Toggle inline diagnostics (virtual_lines)",
  },

  ----------------------------------------------------------------------------------------
  -- telescope
  { mode = "n", shortcut = "<leader>ts",  fn = ":Telescope<CR>",                          desc = "Telescope" },
  { mode = "n", shortcut = "<C-f>",       fn = ":Telescope current_buffer_fuzzy_find<CR>", desc = "Fuzzy find in buffer" },
  { mode = "n", shortcut = "<C-p>",       fn = ":Telescope git_files<CR>",                desc = "Find git files" },
  { mode = "n", shortcut = "<C-r>",       fn = ":Telescope find_files<CR>",               desc = "Find files" },
  { mode = "n", shortcut = "<leader>ff",  fn = ":Telescope live_grep<CR>",                desc = "Live grep" },
  { mode = "n", shortcut = "<leader>fs",  fn = ":Telescope lsp_document_symbols<CR>",     desc = "Document symbols" },
  { mode = "n", shortcut = "<leader>gc",  fn = ":Telescope git_commits<CR>",              desc = "Git commits" },
  { mode = "n", shortcut = "<leader>gst", fn = ":Telescope git_status<CR>",               desc = "Git status" },
  { mode = "n", shortcut = "<leader>gbr", fn = ":Telescope git_branches<CR>",             desc = "Git branches" },

  ----------------------------------------------------------------------------------------
  -- diffview
  { mode = "n", shortcut = "<leader>gd",  fn = ":DiffviewOpen<CR>",                       desc = "Diffview open" },
  { mode = "n", shortcut = "<leader>gq",  fn = ":DiffviewClose<CR>",                      desc = "Diffview close" },
  { mode = "n", shortcut = "<leader>gh",  fn = ":DiffviewFileHistory %<CR>",              desc = "File history (current)" },
  { mode = "n", shortcut = "<leader>gH",  fn = ":DiffviewFileHistory<CR>",                desc = "File history (repo)" },

  ----------------------------------------------------------------------------------------
  -- gitsigns
  { mode = "n", shortcut = "]c",          fn = ":Gitsigns next_hunk<CR>",                 desc = "Next hunk" },
  { mode = "n", shortcut = "[c",          fn = ":Gitsigns prev_hunk<CR>",                 desc = "Previous hunk" },
  { mode = "n", shortcut = "<leader>gp",  fn = ":Gitsigns preview_hunk<CR>",              desc = "Preview hunk" },
  { mode = "n", shortcut = "<leader>gs",  fn = ":Gitsigns stage_hunk<CR>",                desc = "Stage hunk" },
  { mode = "n", shortcut = "<leader>gu",  fn = ":Gitsigns undo_stage_hunk<CR>",           desc = "Undo stage hunk" },
  { mode = "n", shortcut = "<leader>gr",  fn = ":Gitsigns reset_hunk<CR>",                desc = "Reset hunk" },
  { mode = "n", shortcut = "<leader>gbl", fn = ":Gitsigns blame_line<CR>",                desc = "Blame line" },

  ----------------------------------------------------------------------------------------
  -- nvim-tree
  { mode = "n", shortcut = "<leader>nv",  fn = ":NvimTreeToggle<CR>",                     desc = "Toggle file tree" },
  { mode = "n", shortcut = "<leader>nr",  fn = ":NvimTreeRefresh<CR>",                    desc = "Refresh file tree" },
  { mode = "n", shortcut = "nf",          fn = ":NvimTreeFocus<CR>",                      desc = "Focus file tree" },

  ----------------------------------------------------------------------------------------
  -- conform
  { mode = "n", shortcut = "ff",          fn = ":ConformFormat<CR>",                      desc = "Format buffer" },

  ----------------------------------------------------------------------------------------
  -- markview
  { mode = "n", shortcut = "<leader>msp", fn = ":Markview splitToggle<CR>",               desc = "Markview split toggle" },
}

for index in ipairs(keymaps) do
  local keymap = keymaps[index]
  vim.keymap.set(keymap.mode, keymap.shortcut, keymap.fn, { silent = true, desc = keymap.desc })
end
