local mod = {
  "nvim-telescope/telescope.nvim",
  branch = "master",
  -- cmd for the explicit pickers; VeryLazy so the ui-select override is active
  -- for code actions / rename without affecting cold-start time.
  cmd = "Telescope",
  event = "VeryLazy",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-telescope/telescope-media-files.nvim",
    "nvim-telescope/telescope-ui-select.nvim",
    -- Compiled fuzzy sorter: much faster filtering on large result sets.
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
  },
  config = function()
    local ts = require("telescope")

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
        ["ui-select"] = {
          require("telescope.themes").get_dropdown({}),
        },
        fzf = {
          fuzzy = true,
          override_generic_sorter = true,
          override_file_sorter = true,
          case_mode = "smart_case",
        },
      },
    })

    -- Load extensions after setup (fzf must load to override the sorters).
    ts.load_extension("fzf")
    ts.load_extension("media_files")
    ts.load_extension("ui-select")
  end,
}

return mod
