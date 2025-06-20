local SwitchToHeader = function()
	vim.cmd[[
		if &filetype == "cpp" || &filetype == "c" || &filetype == "h" || &filetype == "hpp"
			ClangdSwitchSourceHeader
		endif
	]]
end



vim.g.mapleader = " "
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])

vim.keymap.set('i', '(', '()<left>')
vim.keymap.set('i', '[', '[]<left>')
vim.keymap.set('i', '{', '{}<left>')
vim.keymap.set('i', '{<CR>', '{<CR>}<ESC>O')
vim.keymap.set('i', '{;<CR>', '{<CR>};<ESC>O')

vim.keymap.set('n', '<A-h>', '<C-w>h')
vim.keymap.set('n', '<A-j>', '<C-w>j')
vim.keymap.set('n', '<A-k>', '<C-w>k')
vim.keymap.set('n', '<A-l>', '<C-w>l')
vim.keymap.set('n', '<leader>to', '<cmd>tabnew<cr>')
vim.keymap.set('n', '<leader>tn', '<cmd>tabnext<cr>')
vim.keymap.set('n', '<leader>tp', '<cmd>tabprevious<cr>')
vim.keymap.set('n', '<leader>q', '<cmd>NvimTreeFocus<cr>')
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>')
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>')
vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<cr>')
vim.keymap.set('n', '<leader>fh', '<cmd>Telescope help_tags<cr>')
vim.keymap.set('n', '<leader>s', ':w<cr>')
vim.keymap.set('n', '<leader>h', function() SwitchToHeader() end)
vim.keymap.set('n', '<leader>m', '<cmd>ToggleTerminal<cr>')

vim.keymap.set('n', '<ESC>>', ':vertical res +1^M<cr>', {remap = true, silent = true})
vim.keymap.set('n', '<ESC><', ':vertical res -1^M<cr>', {remap = true, silent = true})
vim.keymap.set('n', '<ESC>+', ':res +1^M<cr>', {noremap = true, silent = true})
vim.keymap.set('n', '<ESC>-', ':res -1^M<cr>', {noremap = true, silent = true})

--vim.keymap.set('i', '<C-Space>', '<C-x><C-o>', {remap = true, silent = true})
--vim.keymap.set('i', '<C-@>', '<C-Space>', {remap = true, silent = true})
vim.keymap.set('n', '<C-Space>', '<C-x><C-o>', {noremap = true, silent = true})
vim.keymap.set('n', '<C-@>', '<C-Space>', {noremap = true, silent = true})


