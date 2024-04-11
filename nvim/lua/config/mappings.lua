local SwitchToHeader = function()
	vim.cmd[[
		if &filetype == "cpp" || &filetype == "c" || &filetype == "h" || &filetype == "hpp"
			ClangdSwitchSourceHeader
		endif
	]]
end

terminalWindow = nil
terminalBuffer = nil
local TerminalMode = function()
	vim.cmd('terminal')
end
local OpenFloatingTerminal = function()
	local ui = vim.api.nvim_list_uis()[1]
	local width = math.floor((ui.width * 0.8) + 0.5) 
	local height = math.floor((ui.height * 0.8) + 0.5)
	local opts = {
		relative = 'editor',
		width = width,
		height = height,
		col = (ui.width/2) - (width/2),
		row = (ui.height/2) - (height/2),
		anchor = 'NW',
		style = 'minimal',
	}
	if terminalWindow == nil then
		terminalBuffer = vim.api.nvim_create_buf(true, false)
		terminalWindow = vim.api.nvim_open_win(terminalBuffer, 1, opts)
		vim.api.nvim_win_call(terminalWindow, TerminalMode)
	else
		if vim.fn.getbufinfo(terminalBuffer)[1].hidden == 1 then
			terminalWindow = vim.api.nvim_open_win(terminalBuffer, 1, opts)
		else
			vim.api.nvim_win_hide(terminalWindow)
		end
	end
end


vim.g.mapleader = " "
vim.keymap.set('t', '<Esc>', [[<C-\><C-n>]])

vim.keymap.set('i', '(', '()<left>')
vim.keymap.set('i', '[', '[]<left>')
vim.keymap.set('i', '{', '{}<left>')
vim.keymap.set('i', '{<CR>', '{<CR>}<ESC>O')
vim.keymap.set('i', '{;<CR>', '{<CR>};<ESC>O')
vim.keymap.set('i', '\'', '\'\'<left>')
vim.keymap.set('i', '"', '""<left>')

vim.keymap.set('n', '<A-h>', '<C-w>h')
vim.keymap.set('n', '<A-j>', '<C-w>j')
vim.keymap.set('n', '<A-k>', '<C-w>k')
vim.keymap.set('n', '<A-l>', '<C-w>l')
vim.keymap.set('n', '<leader>to', ':tabnew<cr>')
vim.keymap.set('n', '<leader>tn', ':tabnext<cr>')
vim.keymap.set('n', '<leader>tp', ':tabprevious<cr>')
vim.keymap.set('n', '<leader>q', ':NvimTreeFocus<cr>')
vim.keymap.set('n', '<leader>ff', '<cmd>Telescope find_files<cr>')
vim.keymap.set('n', '<leader>fg', '<cmd>Telescope live_grep<cr>')
vim.keymap.set('n', '<leader>fb', '<cmd>Telescope buffers<cr>')
vim.keymap.set('n', '<leader>fh', '<cmd>Telescope help_tags<cr>')
vim.keymap.set('n', '<leader>s', ':w<cr>')
vim.keymap.set('n', '<leader>h', function() SwitchToHeader() end)
vim.keymap.set('n', '<leader>m', function() OpenFloatingTerminal() end)

vim.keymap.set('n', '<ESC>>', ':vertical res +1^M<cr>', {noremap = true, silent = true})
vim.keymap.set('n', '<ESC><', ':vertical res -1^M<cr>', {noremap = true, silent = true})
vim.keymap.set('n', '<ESC>+', ':res +1^M<cr>', {noremap = true, silent = true})
vim.keymap.set('n', '<ESC>-', ':res -1^M<cr>', {noremap = true, silent = true})

