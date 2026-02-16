local keymaps = {
	{ mode = "i", shortcut = "jk", fn = "<Esc>" },
	{ mode = "n", shortcut = "<C-s>", fn = ":w<CR>" },

	{ mode = "n", shortcut = "<A-k>", fn = "<C-y>" },
	{ mode = "n", shortcut = "<A-j>", fn = "<C-e>" },
	{ mode = "n", shortcut = "<A-h>", fn = "zh" },
	{ mode = "n", shortcut = "<A-l>", fn = "zl" },

	-- { mode = "n", shortcut = "<C-z>", fn = ":undo<CR>" },
	{ mode = "n", shortcut = "<S-u>", fn = ":redo<CR>" },

	{ mode = "n", shortcut = "<C-Up>", fn = ":resize -2<CR>" },
	{ mode = "n", shortcut = "<C-Down>", fn = ":resize +2<CR>" },
	{ mode = "n", shortcut = "<leader>rf", fn = ":luafile %<CR>" },

	{ mode = "n", shortcut = "<leader>tn", fn = ":tabnew<CR>" },
	{ mode = "n", shortcut = "<leader>tx", fn = ":tabclose<CR>" },

	{ mode = "v", shortcut = "<A-S-j>", fn = ":m '>+1<CR>gv=gv" },
	{ mode = "v", shortcut = "<A-S-k>", fn = ":m '<-2<CR>gv=gv" },

	{ mode = "x", shortcut = "<leader>p", fn = '"_dP' },
	{ mode = "n", shortcut = "<leader>y", fn = '"+y' },
	{ mode = "v", shortcut = "<leader>y", fn = '"+y' },
	{ mode = "n", shortcut = "<leader>Y", fn = '"+Y' },

	{ mode = "n", shortcut = "]q", fn = ":cnext<CR>" },
	{ mode = "n", shortcut = "[q", fn = ":cprevious<CR>" },

	{
		mode = "n",
		shortcut = "<space>e",
		fn = function()
			vim.diagnostic.open_float()
		end,
	},
	{
		mode = "n",
		shortcut = "]d",
		fn = function()
			vim.diagnostic.jump({ count = 1, float = true })
		end,
	},
	{
		mode = "n",
		shortcut = "[d",
		fn = function()
			vim.diagnostic.jump({ count = -1, float = true })
		end,
	},
	{
		mode = "n",
		shortcut = "<space>q",
		fn = function()
			vim.diagnostic.setloclist()
		end,
	},
	{
		mode = "n",
		shortcut = "gD",
		fn = function()
			vim.lsp.buf.declaration()
		end,
	},
	{
		mode = "n",
		shortcut = "gd",
		fn = function()
			vim.lsp.buf.definition()
		end,
	},
	{
		mode = "n",
		shortcut = "K",
		fn = function()
			vim.lsp.buf.hover()
		end,
	},
	{
		mode = "n",
		shortcut = "gi",
		fn = function()
			vim.lsp.buf.implementation()
		end,
	},
	{
		mode = "n",
		shortcut = "<C-k>",
		fn = function()
			vim.lsp.buf.signature_help()
		end,
	},
	{
		mode = "n",
		shortcut = "<leader>D",
		fn = function()
			vim.lsp.buf.type_definition()
		end,
	},
	{
		mode = "n",
		shortcut = "<leader>rn",
		fn = function()
			vim.lsp.buf.rename()
		end,
	},
	{
		mode = "n",
		shortcut = "<leader>ac",
		fn = function()
			vim.lsp.buf.code_action()
		end,
	},
	{
		mode = "n",
		shortcut = "<leader>oi",
		fn = function()
			vim.lsp.buf.code_action({ context = { only = { "source.organizeImports" } }, apply = true })
		end,
	},
	{
		mode = "n",
		shortcut = "gr",
		fn = function()
			vim.lsp.buf.references()
		end,
	},

	----------------------------------------------------------------------------------------
	{ mode = "n", shortcut = "<leader>ts", fn = ":Telescope<CR>" },
	{ mode = "n", shortcut = "<C-f>", fn = ":Telescope current_buffer_fuzzy_find<CR>" },
	{ mode = "n", shortcut = "<C-p>", fn = ":Telescope git_files<CR>" },
	{ mode = "n", shortcut = "<C-r>", fn = ":Telescope find_files<CR>" },
	{ mode = "n", shortcut = "<leader>ff", fn = ":Telescope live_grep<CR>" },
	{ mode = "n", shortcut = "<leader>fs", fn = ":Telescope lsp_document_symbols<CR>" },
	{ mode = "n", shortcut = "<leader>gc", fn = ":Telescope git_commits<CR>" },
	{ mode = "n", shortcut = "<leader>gst", fn = ":Telescope git_status<CR>" },
	{ mode = "n", shortcut = "<leader>gbr", fn = ":Telescope git_branches<CR>" },

	----------------------------------------------------------------------------------------
	-- diffview
	{ mode = "n", shortcut = "<leader>gd", fn = ":DiffviewOpen<CR>" },
	{ mode = "n", shortcut = "<leader>gq", fn = ":DiffviewClose<CR>" },
	{ mode = "n", shortcut = "<leader>gh", fn = ":DiffviewFileHistory %<CR>" },
	{ mode = "n", shortcut = "<leader>gH", fn = ":DiffviewFileHistory<CR>" },

	----------------------------------------------------------------------------------------
	-- gitsigns
	{ mode = "n", shortcut = "]c", fn = ":Gitsigns next_hunk<CR>" },
	{ mode = "n", shortcut = "[c", fn = ":Gitsigns prev_hunk<CR>" },
	{ mode = "n", shortcut = "<leader>gp", fn = ":Gitsigns preview_hunk<CR>" },
	{ mode = "n", shortcut = "<leader>gs", fn = ":Gitsigns stage_hunk<CR>" },
	{ mode = "n", shortcut = "<leader>gu", fn = ":Gitsigns undo_stage_hunk<CR>" },
	{ mode = "n", shortcut = "<leader>gr", fn = ":Gitsigns reset_hunk<CR>" },
	{ mode = "n", shortcut = "<leader>gbl", fn = ":Gitsigns blame_line<CR>" },

	----------------------------------------------------------------------------------------
	{ mode = "n", shortcut = "<leader>nv", fn = ":NvimTreeToggle<CR>" },
	{ mode = "n", shortcut = "<leader>nr", fn = ":NvimTreeRefresh<CR>" },
	{ mode = "n", shortcut = "nf", fn = ":NvimTreeFocus<CR>" },

	----------------------------------------------------------------------------------------
	{ mode = "n", shortcut = "ff", fn = ":ConformFormat<CR>" },

	----------------------------------------------------------------------------------------
	{ mode = "n", shortcut = "<leader>msp", fn = ":Markview splitToggle<CR>" },
}

for index in ipairs(keymaps) do
	local keymap = keymaps[index]
	vim.keymap.set(keymap.mode, keymap.shortcut, keymap.fn)
end
