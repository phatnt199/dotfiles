local utilities = require("utilities.index")

-- oxfmt reads `.configs/oxfmt.config.mts` only when told to: a project that keeps it there runs
-- oxfmt from the folder's parent with `-c`. A project with a root config (`.oxfmtrc.json`,
-- `oxfmt.config.ts`) runs oxfmt as conform ships it; any other project falls back to prettier.
local OXFMT_CONFIG_FILE = "oxfmt.config.mts"
local OXFMT_ROOT_CONFIGS = { ".oxfmtrc.json", ".oxfmtrc.jsonc", "oxfmt.config.ts" }

local function oxfmt_dot_configs_root(ctx)
  return utilities.dot_configs_root(ctx.filename, OXFMT_CONFIG_FILE)
end

local JS_FORMATTERS = { "oxfmt", "prettier", stop_after_first = true }

local mod = {
  "stevearc/conform.nvim",
  cmd = "ConformFormat",
  config = function()
    local mod = require("conform")

    mod.setup({
      formatters_by_ft = {
        lua = { "stylua" },
        rust = { "rustfmt" },
        dart = { "dart_format" },

        javascript = JS_FORMATTERS,
        javascriptreact = JS_FORMATTERS,
        typescript = JS_FORMATTERS,
        typescriptreact = JS_FORMATTERS,
        markdown = { "prettier" },
        html = { "prettier" },

        -- java = { "clang-format" },  -- Use LSP (jdtls) formatter instead via lsp_format fallback
        python = { "ruff_fix", "ruff_format" },
        sh = { "shfmt" },
        sql = { "pg_format" },
        toml = { "taplo" },

        json = { "yq", "prettier", stop_after_first = true },
        yaml = { "yq", "prettier", stop_after_first = true },
      },

      formatters = {
        oxfmt = {
          condition = function(_, ctx)
            return oxfmt_dot_configs_root(ctx) ~= nil
              or vim.fs.root(ctx.filename, OXFMT_ROOT_CONFIGS) ~= nil
          end,
          cwd = function(self, ctx)
            return oxfmt_dot_configs_root(ctx)
              or require("conform.util").root_file(OXFMT_ROOT_CONFIGS)(self, ctx)
          end,
          prepend_args = function(_, ctx)
            if oxfmt_dot_configs_root(ctx) then
              return { "-c", ".configs/" .. OXFMT_CONFIG_FILE }
            end
            return {}
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

      mod.format({ async = true, lsp_format = "fallback", range = range })
    end, { range = true })
  end,
}

return mod
