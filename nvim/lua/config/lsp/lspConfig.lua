
vim.lsp.config.clangd = {
	cmd = { 'clangd', "--log=verbose"},
	filetypes = {'c', 'cpp', 'h' },
	capabilities = require('blink.cmp').get_lsp_capabilities(),
	root_markers = { '.clangd', '.clang-tidy', '.clang-format', 'compile_commands.json', 'compile_flags.txt',
						'configure.ac', '.git'}
}
vim.lsp.enable('clangd')


vim.lsp.config('pylsp', {
	cmd = { 'pylsp' },
	filetypes = { 'python' },
	root_markers = {
		'pyproject.toml',
		'setup.py',
		'setup.cfg',
		'requirements.txt',
		'Pipfile',
		'.git',
	},
})

vim.lsp.enable('pylsp')
