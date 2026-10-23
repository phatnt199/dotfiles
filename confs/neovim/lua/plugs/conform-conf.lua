-- Which formatter handles which filetype is declared per language in lua/langs/. Web and data files
-- (js/ts, json, css, html, markdown, yaml, ...) all go to `bun fmt`, defined below. It reads the
-- project's own config ([fmt] in bunfig.toml, or an existing prettier/oxfmt config), so it runs from
-- the project root. LSP formatting is never used (see ConformFormat).
local PROJECT_ROOT_MARKERS = { { "bunfig.toml" }, { "package.json", ".git" } }

local mod = {
  "stevearc/conform.nvim",
  cmd = "ConformFormat",
  config = function()
    local conform = require("conform")

    conform.setup({
      formatters_by_ft = require("langs").formatters_by_ft,
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
