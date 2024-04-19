local M = {}

local terminalWindow 
local terminalBuffer
local window_opts
function M.toggle()
	if vim.fn.getbufinfo(terminalBuffer)[1].hidden == 1 then
		terminalWindow = vim.api.nvim_open_win(terminalBuffer, 1, window_opts)
	else
		vim.api.nvim_win_hide(terminalWindow)
	end

end
function M.ChangeDir(path)
	M.toggle()
	vim.api.nvim_win_call(terminalWindow, function ()
		print('cd' .. path)
		vim.api.nvim_chan_send(terminalBuffer, 'cd ' .. path .. '\n')
		vim.api.nvim_chan_send(terminalBuffer, 'clear\n')
		M.toggle()

	end)
end
function M.Highlights()
	vim.cmd('hi TerminalNormal guifg=#ffffff guibg=#191a1c')
end
function M.setup(opts)
	opts = opts or {
		width_scale = 0.8,
		height_scale = 0.8,
	}
	M.Highlights()
	local TerminalMode = function()
		vim.cmd('terminal')
	end
	vim.cmd('highlight TerminalTitle guifg=#0dbdba')
	local ui = vim.api.nvim_list_uis()[1]
	local width = math.floor((ui.width * opts.width_scale) + 0.5) 
	local height = math.floor((ui.height * opts.height_scale) + 0.5)
	window_opts = {
		relative = 'editor',
		width = width,
		height = height,
		col = (ui.width/2) - (width/2),
		row = (ui.height/2) - (height/2),
		anchor = 'NW',
		style = 'minimal',
		border = 'single',
		title = {{'Terminal', 'TerminalTitle'}},
		title_pos = 'center'
	}
	terminalBuffer = vim.api.nvim_create_buf(true, false)
	terminalWindow = vim.api.nvim_open_win(terminalBuffer, 1, window_opts)
	vim.api.nvim_win_set_option(terminalWindow, 'winhighlight', 'Normal:TerminalNormal')
	vim.api.nvim_win_call(terminalWindow, TerminalMode)
	vim.api.nvim_win_hide(terminalWindow)
	vim.api.nvim_create_user_command('ToggleTerminal',  M.toggle, {bang= true})
end

return M
