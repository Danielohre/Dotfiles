lua require('config.options')
lua require('config.mappings')
lua require('plugins.vim-plug')

"Higlight Acitve StatusBar"
autocmd WinEnter * hi StatusLine guibg=#425a7d guifg=#FFFFFF

"Update buffer on external change"
set autoread
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif
"Format on save"
augroup ClangFormat
	autocmd!
	autocmd BufWrite *.cpp,*.c,*.h,*.hpp call FormatBufferWithClangd()
augroup END

augroup BlackFormat
	autocmd!
	autocmd BufWritePost *.py silent !black %
augroup END

function! FormatBufferWithClangd()
	"For Clangd, find .clang-format file"
	if executable('clang-format') && !empty(findfile('.clang-format', expand('%:p:h') . ';')) 
		let cursor_pos = getpos('.')
		:%!clang-format
		call setpos('.', cursor_pos)
	else
		echom "clang-format not available OR no .clang-format file available"
	endif
endfunction

function! SwitchToHeader()
	if exists('ClangdSwitchSourceHeader')
		ClangdSwitchSourceHeader
	endif
endfunction

:colorscheme nightfly
