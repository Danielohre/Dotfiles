require('plugins.vim-plug')
vim.cmd 'colorscheme nightfly'
require('config.options')
require('config.mappings')
require('plugins.toggle-terminal').setup({width_scale = 0.8, height_scale = 0.8})
require('plugins.bpp').setup({
	file_path = '/home/daoh/.config/nvim/lua/plugins/bpp/'

})
require('config.autocommands')
