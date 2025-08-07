local mod = {
	"nvim-telescope/telescope.nvim",
	branch = "0.1.x",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-media-files.nvim",
	},
	config = function()
		local ts = require("telescope")

		ts.load_extension("media_files")
		ts.setup({
			extensions = {
				media_files = {
					file_types = { "png", "jpg", "jpeg", "webp", "pdf" },
					find_cmd = "rg",
				},
			},
		})
	end,
}

return mod
