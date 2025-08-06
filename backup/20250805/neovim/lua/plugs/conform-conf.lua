local mod = require('conform')

mod.setup({
  formatters_by_ft = {
    lua = { 'stylua' },
    rust = { 'rustfmt' },
    dart = { 'dart_format' },

    javascript = { 'prettier' },
    javascriptreact = { 'prettier' },
    typescript = { 'prettier' },
    typescriptreact = { 'prettier' },
    markdown = { 'prettier' },
    html = { 'prettier' },

    java = { 'clang-format' },
    python = { 'autopep8' },
    sh = { 'shfmt' },
    sql = { 'pg_format' },
    toml = { 'taplo' },

    json = { 'yq' },
    yaml = { 'yq' },
  }
})

vim.api.nvim_create_user_command("ConformFormat",
  function(args)
    local range = nil

    if args.count ~= -1 then
      local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]

      range = {
        start = { args.line1, 0, },
        ["end"] = { args.line2, end_line:len() },
      }
    end

    mod.format({ async = true, lsp_format = "fallback", range = range })
  end,
  { range = true }
)
