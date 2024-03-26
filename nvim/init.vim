
source ~/.config/nvim/plugins.vim
syntax on
set filetype
set tabstop=4
set showmatch
set ruler
set smarttab
set shiftwidth=4
set number

"Update buffer on external change"
set autoread
autocmd FocusGained,BufEnter,CursorHold,CursorHoldI * if mode() != 'c' | checktime | endif

"Format on save"
function! ClangdFileType()
	if &filetype == 'cpp' || &filetype == 'c' || &filetype == 'h' || &filetype == 'hpp'
		return 1
	return 0
	endif
endfunction

function! FormatBuffer()
	"Check Filetype"
	if ClangdFileType()
		"For Clangd, find .clang-format file"
		if !empty(findfile('.clang-format', expand('%:p:h') . ';')) 
			let cursor_pos = getpos('.')
			:%!clang-format
			call setpos('.', cursor_pos)
		endif
	endif
endfunction


let mapleader=(' ') 
:colorscheme nightfly
source ~/.config/nvim/keybinds.vim
