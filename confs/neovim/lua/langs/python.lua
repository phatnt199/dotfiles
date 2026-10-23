-- Python (pyright, ruff).

return {
  lsp = {
    pyright = {
      settings = {
        python = {
          analysis = {
            autoSearchPaths = true,
            diagnosticMode = "openFilesOnly",
            useLibraryCodeForTypes = true,
            autoImportCompletions = true,
            typeCheckingMode = "standard",
          },
        },
      },
    },
  },
  formatters = {
    python = { "ruff_fix", "ruff_format" },
  },
  parsers = { "python" },
}
