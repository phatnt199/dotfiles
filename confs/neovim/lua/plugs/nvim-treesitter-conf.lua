local ensure_installed = {
  "bash",
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
  "latex",
  "lua",
  "markdown",
  "markdown_inline",
  "python",
  "rust",
  "tsx",
  "typescript",
  "typst",
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
  lazy = false,
  build = ":TSUpdate",
  config = function()
    local missing = {}
    for _, lang in ipairs(ensure_installed) do
      if #vim.api.nvim_get_runtime_file("parser/" .. lang .. ".so", false) == 0 then
        table.insert(missing, lang)
      end
    end
    if #missing > 0 then
      require("nvim-treesitter").install(missing)
    end
    -- main branch does not enable highlighting itself; start it per buffer
    vim.api.nvim_create_autocmd("FileType", {
      callback = function(args)
        local buf = args.buf
        if vim.b[buf].big_file then
          return
        end
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
