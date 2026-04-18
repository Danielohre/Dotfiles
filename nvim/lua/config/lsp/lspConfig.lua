vim.lsp.config.lua_ls = {
	-- Command and arguments to start the server.
	cmd = { 'lua-language-server' },

	-- Filetypes to automatically attach to.
	filetypes = { 'lua' },

	-- Sets the "root directory" to the parent directory of the file in the
	-- current buffer that contains either a ".luarc.json" or a
	-- ".luarc.jsonc" file. Files that share a root directory will reuse
	-- the connection to the same LSP server.
	-- Nested lists indicate equal priority, see |vim.lsp.Config|.
	root_markers = { { '.luarc.json', '.luarc.jsonc' }, '.git' },

	-- Specific settings to send to the server. The schema for this is
	-- defined by the server. For example the schema for lua-language-server
	-- can be found here https://raw.githubusercontent.com/LuaLS/vscode-lua/master/setting/schema.json
	settings = {
		Lua = {
			runtime = {
				version = 'LuaJIT',
			},
			diagnostics = {
				-- Get the language server to recognize the `vim` global
				globals = { 'vim' },
			},
		}
	}
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
