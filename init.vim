syntax on
set filetype
set tabstop=4
set showmatch
set ruler
set smarttab
set shiftwidth=4
set number
let mapleader=(' ') "
:tnoremap <A-h> <C-\><C-N><C-w>h
:tnoremap <A-j> <C-\><C-N><C-w>j
:tnoremap <A-k> <C-\><C-N><C-w>k
:tnoremap <A-l> <C-\><C-N><C-w>l
:inoremap <A-h> <C-\><C-N><C-w>h
:inoremap <A-j> <C-\><C-N><C-w>j
:inoremap <A-k> <C-\><C-N><C-w>k
:inoremap <A-l> <C-\><C-N><C-w>l
:nnoremap <A-h> <C-w>h
:nnoremap <A-j> <C-w>j
:nnoremap <A-k> <C-w>k
:nnoremap <A-l> <C-w>l
:nnoremap <leader>to :tabnew<CR>
:nnoremap <leader>tc :tabclose<CR> 
:nnoremap <leader>tn :tabnext<CR> 
:nnoremap <leader>tp :tabprevious<CR>

