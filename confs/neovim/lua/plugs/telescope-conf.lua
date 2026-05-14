local mod = {
  "nvim-telescope/telescope.nvim",
  branch = "master",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-media-files.nvim",
  },
  config = function()
    local ts = require("telescope")

    ts.load_extension("media_files")
    ts.setup({
      defaults = {
        preview = {
          treesitter = { enable = false },
        },
      },
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
