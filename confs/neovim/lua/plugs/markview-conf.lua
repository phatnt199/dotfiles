local mod = {
	"OXY2DEV/markview.nvim",
	lazy = true,
	priority = 49,
	--[[ dependencies = {
		"saghen/blink.cmp",
	}, ]]
	opts = {
		hybrid_mode = { "n" },

    preview = {
      autostart = false,
      enable = false,
		  filetypes = { "markdown", "quarto", "rmd", "typst" },
    }
	},
}

return mod
