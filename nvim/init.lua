require('plugins.vim-plug')
vim.cmd 'colorscheme nightfly'
require('config.options')
require('config.mappings')
require('plugins.put').setup({width_scale = 0.8, height_scale = 0.8})
require('plugins.bpp').setup(
{
	style = {title='#805514' ,list='#048c12' ,end_of_buffer='bg'},
	instructions_data = {
		'<C-m>      : Toggle Terminal',
		'<leader>ff : Find File in CWD',
		'<leader>fg : LiveGrep In CWD',
		'<leader>fb : Buffer Search',
		'<leader>q  : Open File Tree'
	},
	recents_data = {}

}
)
require('config.autocommands')
