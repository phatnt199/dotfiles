-- Web and data files (js/ts, json, css, html, markdown, yaml, ...) are all formatted by `bun fmt`.
-- It reads the project's own config ([fmt] in bunfig.toml, or an existing prettier/oxfmt config),
-- so it runs from the project root. LSP formatting is never used (see ConformFormat).
local BUN_FMT_FILETYPES = {
  "javascript",
  "javascriptreact",
  "typescript",
  "typescriptreact",
  "json",
  "jsonc",
  "json5",
  "css",
  "scss",
  "less",
  "html",
  "vue",
  "svelte",
  "markdown",
  "mdx",
  "yaml",
}

local PROJECT_ROOT_MARKERS = { { "bunfig.toml" }, { "package.json", ".git" } }

local mod = {
  "stevearc/conform.nvim",
  cmd = "ConformFormat",
  config = function()
    local conform = require("conform")

    local formatters_by_ft = {
      lua = { "stylua" },
      rust = { "rustfmt" },
      dart = { "dart_format" },

      -- java = { "clang-format" },  -- Use LSP (jdtls) formatter instead via lsp_format fallback
      python = { "ruff_fix", "ruff_format" },
      sh = { "shfmt" },
      sql = { "pg_format" },
      toml = { "taplo" },
    }
    for _, filetype in ipairs(BUN_FMT_FILETYPES) do
      formatters_by_ft[filetype] = { "bun_fmt" }
    end

    conform.setup({
      formatters_by_ft = formatters_by_ft,
      formatters = {
        bun_fmt = {
          command = "bun",
          args = { "fmt", "--no-script", "--stdin-filepath", "$FILENAME" },
          stdin = true,
          cwd = function(_, ctx)
            return vim.fs.root(ctx.filename, PROJECT_ROOT_MARKERS) or vim.fs.dirname(ctx.filename)
          end,
        },
      },
    })

    vim.api.nvim_create_user_command("ConformFormat", function(args)
      local range = nil

      if args.count ~= -1 then
        local end_line = vim.api.nvim_buf_get_lines(0, args.line2 - 1, args.line2, true)[1]

        range = {
          start = { args.line1, 0 },
          ["end"] = { args.line2, end_line:len() },
        }
      end

      conform.format({ async = true, lsp_format = "never", range = range })
    end, { range = true })
  end,
}

return mod
