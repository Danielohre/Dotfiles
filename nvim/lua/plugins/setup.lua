vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == 'nvim-treesitter' and kind == 'update' then
			if not ev.data.active then vim.cmd.packadd('nvim-treesitter') end
			vim.cmd('TSUpdate')
		end
	end

})

vim.pack.add({
	'https://github.com/OXY2DEV/markview.nvim',
	'https://github.com/nvim-tree/nvim-tree.lua',
	'https://github.com/nvim-tree/nvim-web-devicons',
	'https://github.com/nvim-treesitter/nvim-treesitter',
	'https://github.com/bluz71/vim-nightfly-colors',
	'https://github.com/saghen/blink.cmp',
	'https://github.com/rafamadriz/friendly-snippets',
	'https://github.com/williamboman/mason.nvim',
	'https://github.com/ibhagwan/fzf-lua.git',
	'https://github.com/peterhoeg/vim-qml'
})

require('plugins.markview_conf')
require('plugins.blink_cmp')
require('plugins.treesitter_conf')
require('plugins.mason_conf')
require('plugins.nvim-tree-config')
require('plugins.fzf-lua_conf')
