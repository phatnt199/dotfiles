local Plug = vim.fn['plug#']

vim.call('plug#begin', '~/.config/nvim/plugged')

-- Plugin Utilities
Plug('nvim-lua/plenary.nvim')

-- LSP
Plug('neovim/nvim-lspconfig')

-- CMP
Plug('hrsh7th/cmp-nvim-lsp')
Plug('hrsh7th/cmp-buffer')
Plug('hrsh7th/cmp-path')
Plug('hrsh7th/cmp-cmdline')
Plug('hrsh7th/cmp-vsnip')
Plug('hrsh7th/vim-vsnip')
Plug('hrsh7th/nvim-cmp')

-- Explorer
Plug('nvim-tree/nvim-web-devicons')
Plug('nvim-tree/nvim-tree.lua')

-- Finder
Plug('nvim-telescope/telescope.nvim', { branch = '0.1.x' })
Plug('nvim-telescope/telescope-media-files.nvim')

-- Status
Plug('nvim-lualine/lualine.nvim')

-- Formatter
-- Plug ('mhartington/formatter.nvim')
Plug('stevearc/conform.nvim')

-- Comment
Plug('JoosepAlviste/nvim-ts-context-commentstring')
Plug('numToStr/Comment.nvim')

-- Pairs
Plug('windwp/nvim-autopairs')

-- Git
Plug('tpope/vim-fugitive')

-- Syntax Highlight
Plug('nvim-treesitter/nvim-treesitter', { run = ':TSUpdate' })
Plug('OXY2DEV/markview.nvim')

-- Color Scheme
Plug('lilydjwg/colorizer')
Plug('phatnt199/devglow')

vim.call('plug#end')
