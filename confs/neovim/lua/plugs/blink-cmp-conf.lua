local mod = {
	"saghen/blink.cmp",
	dependencies = {
		"rafamadriz/friendly-snippets",
	},
	version = "1.*",
	opts = {
		keymap = {
			preset = "enter",
			["<Tab>"] = { "select_next", "fallback" },
			["<S-Tab>"] = { "select_prev", "fallback" },

			["<C-e>"] = { "cancel", "fallback" },
			["CR"] = { "select_and_accept", "fallback" },
			["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },

			["<C-k>"] = {
				function(cmp)
					cmp.scroll_documentation_up(2)
				end,
			},
			["<C-j>"] = {
				function(cmp)
					cmp.scroll_documentation_down(2)
				end,
			},
		},

		appearance = {
			nerd_font_variant = "mono",
		},

		completion = {
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 150,
				window = { border = "rounded" },
			},
			menu = {
				border = "rounded",
				draw = {
					treesitter = { "lsp" },
				},
			},
		},

		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
		},

		fuzzy = { implementation = "prefer_rust" },
	},
	opts_extend = { "sources.default" },
}

return mod
