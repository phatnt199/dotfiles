local mod = {
  "sindrets/diffview.nvim",
  cmd = { "DiffviewOpen", "DiffviewClose", "DiffviewFileHistory" },
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = {
    use_icons = true,
  },
}

return mod
