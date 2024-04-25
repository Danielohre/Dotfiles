
vim.api.nvim_create_autocmd({"FocusGained","BufEnter","CursorHold","CursorHoldI"}, {
	pattern = "*",
	command = 'if mode()!= \'c\' | checktime| endif',
				
})

vim.api.nvim_create_augroup('ClangdFormat', {clear = true})
vim.api.nvim_create_autocmd({"BufWrite"}, {
	pattern = {"*.cpp", "*.c", "*.h", "*.hpp"},
	callback = function()
		vim.cmd[[
			if executable('clang-format') && !empty(findfile('.clang-format', expand('%:p:h') . ';')) 
				let cursor_pos = getpos('.')
				:%!clang-format
				call setpos('.', cursor_pos)
			else
				echom "clang-format not available OR no .clang-format file available"
			endif
		]]
	end,
	group = 'ClangdFormat'
})

vim.api.nvim_create_augroup('BlackFormat', {clear = true})
vim.api.nvim_create_autocmd({"BufWritePost"}, {
	pattern = {"*.py"},
	command = "silent !black %",
	group = 'BlackFormat'
})

vim.api.nvim_create_autocmd({"WinEnter", "BufEnter"}, {
	pattern = {"*"},
	command = "hi StatusLine guibg=#1b272e guifg=#FFFFFF",

})

vim.api.nvim_create_augroup('CursorLine', {clear = true})
vim.api.nvim_create_autocmd({"BufEnter", "VimEnter", "WinEnter"}, {
	pattern = {"*"},
	command = "setlocal cursorline",
	group = 'CursorLine'
})
vim.api.nvim_create_autocmd({"WinLeave"}, {
	pattern = {"*"},
	command = "setlocal nocursorline",
	group = 'CursorLine'
})

vim.api.nvim_create_autocmd({'VimEnter'}, {
	pattern = "*",
	callback = function ()
		if next(vim.fn.argv()) == nil then
			require('plugins.bpp').ToggleProjectsView()
		end
	end


})
vim.api.nvim_create_augroup('DirChangedGroup', {
	clear = true
})
vim.api.nvim_create_autocmd({'User'}, {
	pattern = 'ProjectsDirChanged',
	group = 'DirChangedGroup',
	callback = function(opts)
		require('plugins.put').ChangeDir(opts.data)
		require('nvim-tree.api').tree.change_root(opts.data)
		require('nvim-tree.api').tree.open()
	end,
})
vim.api.nvim_create_autocmd({'User'}, {
	pattern = 'NvimTreeChangedRoot',
	group = 'DirChangedGroup',
	callback = function(opts)
		vim.cmd('cd ' .. opts.data)
		require('plugins.put').ChangeDir(opts.data)
	end,
})

