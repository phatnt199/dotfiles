-- Python (pyright)
return {
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
}
