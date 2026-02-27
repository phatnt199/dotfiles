local mod = {
	"nvim-tree/nvim-tree.lua",
	version = "*",
	lazy = false,
	dependencies = {
		"nvim-tree/nvim-web-devicons",
	},
	opts = {
		disable_netrw = true,
		hijack_netrw = true,
		open_on_tab = false,
		update_focused_file = {
			enable = true,
			update_cwd = false,
			ignore_list = {},
		},
		renderer = {
			highlight_git = "name",
			icons = {
				webdev_colors = true,
				git_placement = "after",
				show = {
					git = false,
				},
			},
		},
		git = {
			enable = true,
			ignore = false,
			timeout = 400,
		},
		view = {
			cursorline = true,
		},
		diagnostics = {
			enable = true,
			show_on_dirs = false,
			show_on_open_dirs = false,
			debounce_delay = 20,
			icons = {
				hint = "⚉",
				info = "",
				warning = "◼",
				error = "",
			},
		},
	},
}

return mod
