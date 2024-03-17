local mod = require('null-ls')

mod.setup({
  sources = {
    mod.builtins.formatting.prettier,
    mod.builtins.formatting.stylelint,
    mod.builtins.formatting.mdformat,
    mod.builtins.formatting.sqlformat,
    mod.builtins.formatting.dart_format,
    mod.builtins.formatting.eslint,
    mod.builtins.formatting.fixjson,

    mod.builtins.diagnostics.eslint.with({
      diagnostic_config = {
        virtual_text = false,
      }
    }),
  }
})
