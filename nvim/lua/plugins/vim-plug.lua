local Plug = vim.fn['plug#']

vim.call('plug#begin')

Plug 'nvim-tree/nvim-tree.lua'
Plug('nvim-treesitter/nvim-treesitter', {['do'] = vim.fn['TSUpdate']})
Plug 'bluz71/vim-nightfly-colors'
Plug 'neovim/nvim-lspconfig'
Plug 'hrsh7th/cmp-nvim-lsp'
Plug 'hrsh7th/cmp-buffer'
Plug 'hrsh7th/cmp-path'
Plug 'hrsh7th/cmp-cmdline'
Plug 'hrsh7th/nvim-cmp'
Plug 'hrsh7th/cmp-vsnip'
Plug 'hrsh7th/vim-vsnip'
Plug 'williamboman/mason.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug('nvim-telescope/telescope.nvim', {branch = '0.1.x'})
Plug 'peterhoeg/vim-qml'

vim.call('plug#end')

require('plugins.nvim_cmp_conf')
require('plugins.treesitter_conf')
require('plugins.telescope_conf')
require('plugins.mason_conf')

