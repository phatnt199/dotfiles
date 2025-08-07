---@diagnostic disable-next-line: missing-fields
local mod = {
	"nvim-treesitter/nvim-treesitter",
	branch = "master",
	dependencies = { "OXY2DEV/markview.nvim" },
	lazy = false,
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter.configs").setup({
			ensure_installed = {
				"c",
				"cpp",
				"css",
				"dart",
				"dockerfile",
				"dot",
				"html",
				"http",
				"java",
				"javascript",
				"json",
				"json5",
				"lua",
				"markdown",
				"markdown_inline",
				"rust",
				"tsx",
				"typescript",
				"vim",
				"vimdoc",
				"yaml",
				"sql",
				"zig",
				"proto",
				"toml",
				"git_config",
				"gitcommit",
				"gitignore",
				"query",
			},
			sync_install = false,
			auto_install = true,
			highlight = {
				enable = true,
				additional_vim_regex_highlighting = false,
			},
			indent = {
				enable = true,
			},
			incremental_selection = {
				enable = true,
			},
			rainbow = {
				enable = true,
				extended_mode = true,
				max_file_lines = nil,
			},
		})
	end,
}

return mod
