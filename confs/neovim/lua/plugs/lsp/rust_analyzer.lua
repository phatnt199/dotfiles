-- Rust (rust-analyzer)
return {
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
}
