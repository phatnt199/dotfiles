local set = vim.opt
local g = vim.g

set.encoding = "utf-8"
set.fileencoding = "utf-8"

set.expandtab = true
set.smarttab = true
set.tabstop = 2
set.softtabstop = 2
set.shiftwidth = 2
set.laststatus = 3

set.cmdheight = 1
set.updatetime = 250

set.smartindent = true
set.autoindent = true
set.showmatch = true

set.hlsearch = true
set.incsearch = true
set.ignorecase = true
set.smartcase = true

set.splitbelow = true
set.splitright = true
set.wrap = false

set.cursorline = true
set.cursorlineopt = "both"
set.backup = false
set.writebackup = false
set.relativenumber = true
set.number = true

-- Persistent undo: keep undo history across sessions.
set.undofile = true
set.undodir = vim.fn.stdpath("state") .. "/undo"
set.undolevels = 10000

set.hidden = true
set.secure = true

set.scrolloff = 8
set.signcolumn = "yes"
set.termguicolors = true
set.background = "dark"
set.fillchars = "vert:│"
set.clipboard = "unnamedplus"

set.completeopt = { "menuone", "noselect", "noinsert" }

set.shortmess:append({ c = true })

local disabled_providers = { "node", "python3", "perl", "ruby" }
for index in ipairs(disabled_providers) do
  g[string.format("loaded_%s_provider", disabled_providers[index])] = 0
end

-- Compatibility shim: silence only the `vim.validate{<table>}` deprecation.
-- diffview.nvim (pinned to its latest upstream commit) still calls the old
-- table-form of vim.validate, which works fine until Nvim 1.0. We drop just
-- that one message so :checkhealth stays clean; every other deprecation
-- warning still passes through untouched.
local _deprecate = vim.deprecate
vim.deprecate = function(name, ...)
  if name == "vim.validate{<table>}" then
    return
  end
  return _deprecate(name, ...)
end
