local set = vim.opt
local g = vim.g

set.encoding = "utf-8"
set.fileencoding = "utf-8"

set.expandtab = true
set.smarttab = true
set.tabstop = 2
set.softtabstop = 2
set.shiftwidth = 2
set.laststatus = 2

set.cmdheight = 1

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
set.lazyredraw = true
set.relativenumber = true
set.number = true

set.hidden = true
set.secure = true

set.scrolloff = 8
set.signcolumn = "yes"
set.termguicolors = true
set.background = "dark"
set.fillchars = "vert:│"
set.clipboard = "unnamedplus"

set.completeopt = {
	"menuone",
	"noselect",
	"noinsert",
}

set.shortmess:append({ c = true })

local diabled_providers = {
	"neovim",
	"node",
	"python3",
	"perl",
	"ruby",
}
for index in ipairs(diabled_providers) do
	g[string.format("loaded_%s_provider", diabled_providers[index])] = 0
end
