local ts_mod = require("nvim-treesitter.configs")

---@diagnostic disable-next-line: missing-fields
ts_mod.setup({
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

		--[[ disable = function(_lang, buf)
      local max_filesize = 100 * 1024 -- 100 KB
      local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
      if ok and stats and stats.size > max_filesize then
        return true
      end
    end, ]]

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

--------------------------------------------------------------------------------------
local ts_context = require("treesitter-context")
ts_context.setup({
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
})
