
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

