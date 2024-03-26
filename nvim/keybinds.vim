:tnoremap <Esc> <C-\><C-n>
:tnoremap <A-h> <C-\><C-N><C-w>h
:tnoremap <A-j> <C-\><C-N><C-w>j
:tnoremap <A-k> <C-\><C-N><C-w>k
:tnoremap <A-l> <C-\><C-N><C-w>l

:inoremap <A-h> <C-\><C-N><C-w>h
:inoremap <A-j> <C-\><C-N><C-w>j
:inoremap <A-k> <C-\><C-N><C-w>k
:inoremap <A-l> <C-\><C-N><C-w>l
:inoremap <C-q> <home>
:inoremap <C-e> <End>
inoremap " ""<left>
inoremap ' ''<left>
inoremap ( ()<left>
inoremap [ []<left>
inoremap { {}<left>
inoremap {<CR> {<CR>}<ESC>O
inoremap {;<CR> {<CR>};<ESC>O


:nnoremap <C-q> <home>
:nnoremap <C-e> <end>
:nnoremap <A-h> <C-w>h
:nnoremap <A-j> <C-w>j
:nnoremap <A-k> <C-w>k
:nnoremap <A-l> <C-w>l
:nnoremap <leader>to :tabnew<CR>
:nnoremap <leader>tc :tabclose<CR> 
:nnoremap <leader>tn :tabnext<CR> 
:nnoremap <leader>tp :tabprevious<CR>
:nnoremap <leader>q :Ntree<CR>
:nnoremap <leader>ff <cmd>Telescope find_files<cr>
:nnoremap <leader>fg <cmd>Telescope live_grep<cr>
:nnoremap <leader>fb <cmd>Telescope buffers<cr>
:nnoremap <leader>fh <cmd>Telescope help_tags<cr>
:nnoremap <leader>s :call FormatBuffer()<cr> \| :w<cr>
