local mod = {
  "nvim-tree/nvim-tree.lua",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    disable_netrw = true,
    hijack_netrw = true,
    tab = {
      sync = {
        open = false,
        close = false,
      },
    },
    update_focused_file = {
      enable = true,
      update_root = {
        enable = false,
        ignore_list = {},
      },
    },
    renderer = {
      highlight_git = "name",
      icons = {
        web_devicons = {
          file = {
            enable = true,
            color = true,
          },
        },
        git_placement = "after",
        show = {
          git = false,
        },
      },
    },
    filters = {
      git_ignored = false,
    },
    git = {
      enable = true,
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
