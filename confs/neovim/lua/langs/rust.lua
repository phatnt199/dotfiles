-- Rust (rust-analyzer, rustfmt).

return {
  lsp = {
    rust_analyzer = {
      settings = {
        ["rust-analyzer"] = {
          cargo = {
            allFeatures = true,
            loadOutDirsFromCheck = true,
            buildScripts = {
              enable = true,
            },
          },
          checkOnSave = true,
          check = {
            command = "clippy",
            extraArgs = {
              "--all-targets",
            },
          },
          procMacro = {
            enable = true,
          },
        },
      },
    },
  },
  formatters = {
    rust = { "rustfmt" },
  },
  parsers = { "rust" },
}
