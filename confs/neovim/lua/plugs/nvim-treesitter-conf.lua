local ensure_installed = {
  "c",
  "cpp",
  "css",
  "dart",
  "dockerfile",
  "dot",
  "html",
  "http",
  "java",
  "javascript",
  "json",
  "json5",
  "lua",
  "markdown",
  "markdown_inline",
  "rust",
  "tsx",
  "typescript",
  "vim",
  "vimdoc",
  "yaml",
  "sql",
  "zig",
  "proto",
  "toml",
  "git_config",
  "gitcommit",
  "gitignore",
  "query",
}

local mod = {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  dependencies = { "OXY2DEV/markview.nvim" },
  lazy = false,
  build = ":TSUpdate",
  config = function()
    require("nvim-treesitter").install(ensure_installed)

    -- main branch does not enable highlighting itself; start it per buffer
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        local buf = args.buf
        local lang = vim.treesitter.language.get_lang(vim.bo[buf].filetype)
        if not lang then
          return
        end
        if pcall(vim.treesitter.start, buf, lang) then
          vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
        end
      end,
    })
  end,
}

return mod
