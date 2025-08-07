local mod = {
	"nvim-treesitter/nvim-treesitter-context",
	opts = {
		enable = true,
		multiwindow = false,
		max_lines = 5,
		min_window_height = 0,
		line_numbers = true,
		multiline_threshold = 20,
		trim_scope = "outer",
		mode = "cursor",
		-- Separator between context and content. Should be a single character string, like '-'.
		-- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
		separator = nil,
		zindex = 20, -- The Z-index of the context window
		on_attach = nil, -- (fun(buf: integer): boolean) return false to disable attaching
	},
}

return mod
