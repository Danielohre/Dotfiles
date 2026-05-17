vim.lsp.config.lua_ls = {
	-- Command and arguments to start the server.
	cmd = { 'lua-language-server' },

	filetypes = { 'lua' },
	root_markers = {
		'.luarc.json',
		'.luarc.jsonc',
		'.luacheckrc',
		'.stylua.toml',
		'stylua.toml',
		'selene.toml',
		'selene.yml',
		'.git',
	},
	settings = {

		Lua = {
			runtime = {
				version = "Lua 5.4",
			},
			completion = {
				enable = true,
			},
			diagnostics = {
				enable = true,
				globals = { "vim" },
			},
			workspace = {
				library = { vim.env.VIMRUNTIME },

				checkThirdParty = false,
			},

		},
	},
}
vim.lsp.enable('lua_ls')


require('config.lsp.clangdConfig')



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

vim.lsp.config("ra", {
	cmd = { "rust-analyzer" },
	filetypes = { 'rs' },
	settings = {
		["rust-analyzer"] = {
			files = { watcher = "server" },
			cargo = { targetDir = true },
			check = { command = "clippy" },
			inlayHints = {
				bindingModeHints = { enabled = true },
				closureCaptureHints = { enabled = true },
				closureReturnTypeHints = { enable = "always" },
				maxLength = 100,
			},
			rustc = { source = "discover" },
		},
	},
	root_markers = { { "Config.toml" }, ".git" }
})
vim.lsp.enable('ra')
