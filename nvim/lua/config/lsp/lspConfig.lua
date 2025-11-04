
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


vim.lsp.config.clangd = {
	cmd = { 'clangd', "--log=verbose" },
	filetypes = { 'c', 'cpp', 'h' },
	capabilities = require('blink.cmp').get_lsp_capabilities(),
	root_markers = { '.clangd', '.clang-tidy', '.clang-format', 'compile_commands.json', 'compile_flags.txt',
		'configure.ac', '.git' },
	on_attach = function()
		vim.keymap.set('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', {buffer = true})
		vim.keymap.set('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', {buffer = true})
		vim.keymap.set('n', 'gs', '<cmd>lua vim.lsp.buf.signature_help()<cr>', {buffer = true})
		vim.api.nvim_buf_create_user_command(0, 'ClangdSwitchSourceHeader', function()
			local methodName = 'textDocument/switchSourceHeader'
			local client = vim.lsp.get_clients({bufnr = 0, name = 'clangd'})[1]
			local bufNr = vim.api.nvim_get_current_buf()

			if not client then
				return vim.notify(('method %s is not supported by any active servers'):format(methodName))
			end

			client.request(methodName, vim.lsp.util.make_text_document_params(bufNr), function(err, result)

				if err then
					error(tostring(err))
				end
				if not result then
					vim.notify('corresponding file cannot be determined')
					return
				end
				vim.cmd.edit(vim.uri_to_fname(result))
			end, bufNr)
		end, {desc = 'Switch between source/header'})
	end,
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
