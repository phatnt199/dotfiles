-- Rust (rust-analyzer)
return {
  settings = {
    ["rust_analyzer"] = {
      checkOnSave = {
        overrideCommand = {
          "cargo",
          "clippy",
          "--workspace",
          "--message-format=json",
          "--all-targets",
          "--all-features",
        },
      },
    },
  },
}
