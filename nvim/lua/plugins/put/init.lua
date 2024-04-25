--PopUpTerminal
local M = {}

local terminalWindow
local terminalBuffer
local window_opts
local width_scale
local height_scale
local default_options = {
	width_scale = 0.8,
	height_scale = 0.8,
	terminal_fg = "#ffffff",
	terminal_bg = "bg"
}
local options = {}

function M.toggle()
	if vim.fn.getbufinfo(terminalBuffer)[1].hidden == 1 then
		local ui = vim.api.nvim_list_uis()[1]
		local width = math.floor((ui.width * width_scale) + 0.5)
		local height = math.floor((ui.height * height_scale) + 0.5)
		window_opts.width = width
		window_opts.height = height
		window_opts.col = (ui.width/2) - (width/2)
		window_opts.row = (ui.height/2) - (height/2)
		terminalWindow = vim.api.nvim_open_win(terminalBuffer, 1, window_opts)
	else
		vim.api.nvim_win_hide(terminalWindow)
	end

end
function M.ChangeDir(path)
	M.toggle()
	vim.api.nvim_win_call(terminalWindow, function ()
		vim.api.nvim_chan_send(terminalBuffer, 'cd ' .. path .. '\n')
		vim.api.nvim_chan_send(terminalBuffer, 'clear\n')
		M.toggle()

	end)
end
function M.Highlights()
	vim.cmd('hi TerminalNormal guifg=#ffffff guibg=#191a1c')
end
local function MergeOptions(user_opts)
	for key, val in pairs(default_options) do 
		if user_opts[key] ~= nil then
			options[key] = user_opts[key]
		else
			options[key] = val
		end
	end
end
function M.setup(opts)
	opts = opts or {
		width_scale = 0.8,
		height_scale = 0.8,
	}
	MergeOptions(opts)
	M.Highlights()
	local TerminalMode = function()
		vim.cmd('terminal')
	end
	vim.cmd('highlight TerminalTitle guifg=#0dbdba')
	width_scale = opts.width_scale
	height_scale = opts.height_scale
	window_opts = {
		relative = 'editor',
		anchor = 'NW',
		style = 'minimal',
		border = 'single',
		title = {{'Terminal', 'TerminalTitle'}},
		title_pos = 'center'
	}
	terminalBuffer = vim.api.nvim_create_buf(true, false)
	M.toggle()
	vim.api.nvim_win_set_option(terminalWindow, 'winhighlight', 'Normal:TerminalNormal')
	vim.api.nvim_win_call(terminalWindow, TerminalMode)
	vim.api.nvim_win_hide(terminalWindow)
	vim.api.nvim_create_user_command('ToggleTerminal',  M.toggle, {bang = true})

	vim.api.nvim_buf_set_keymap(terminalBuffer, 'n', '<ESC>', '<cmd>q<CR>', {})
end

return M
