local mod = {
  "OXY2DEV/markview.nvim",
  ft = { "markdown", "quarto", "rmd", "typst" },
  cmd = "Markview",
  dependencies = {
    "saghen/blink.cmp",
  },
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
