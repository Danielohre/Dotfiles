local M = {}

local options = {}
local default_options = {
	style = {title = 'fg', list = 'fg', normal = 'bg', end_of_buffer = 'fg'},
	file_path = vim.fn.stdpath("config") .. '/lua/plugins/bpp/',
	instructions_data = {},
	recents_data = {}
}

local projectfile = ""
local api = vim.api
local namespace_id

local projectsBuffer = nil
local mainWindow = nil

local recentsWindow = nil
local recentsBuffer = nil

local instructionsWindow = nil
local instructionsBuffer = nil

local mainWindow_opts = {}
local recentsWindow_opts = {}
local instructionsWindow_opts = {}

local buffers_loaded = {projects = false, instructions = false, recents = false}


local function file_exists(name)
	local f= io.open(name,'r')
	if f~=nil then
		io.close(f)
		return true
	else
		return false
	end
end


local function loadProjectsBuffer()
	if buffers_loaded.projects then api.nvim_buf_set_option(projectsBuffer, 'modifiable', true) api.nvim_buf_set_lines(projectsBuffer, 0, api.nvim_buf_line_count(projectsBuffer),false, {""}) end
	local projectPaths = M.fetchProjects()
	local cols = api.nvim_win_get_width(mainWindow)
	local rows = 50
	for i = 0, rows, 1 do api.nvim_buf_set_lines(projectsBuffer, i, i, true, {""}) end
	local header_lines = {
		string.rep(' ', cols/2 - 36/2) .. ' ____            _           _',
		string.rep(' ', cols/2 - 36/2) ..'|    \\_____ ___ (_) ___  ___| |_ ___',
		string.rep(' ', cols/2 - 36/2) ..'| |_) |  __/ _ \\| |/ _ \\/ __| __/ __|',
		string.rep(' ', cols/2 - 36/2) ..'|  __/| | | (_) | |  __/ (__| |_\\__ \\',
		string.rep(' ', cols/2 - 36/2) ..'|_|   |_|  \\___// |\\___|\\___|\\__|___/ ',
		string.rep(' ', cols/2 - 36/2) ..'              |__/ '

	}
	local line = 0;
	for index, header_line in ipairs(header_lines) do
	api.nvim_buf_set_lines(projectsBuffer, index-1, index-1, true, {header_line})
	api.nvim_buf_add_highlight(projectsBuffer, namespace_id , 'ProjectsTitle', index-1, 0, -1)
	line = index
	end
	for name, path in pairs(projectPaths) do
		api.nvim_buf_set_lines(projectsBuffer, line, line, true, {string.rep(" ", cols/4) .. name})
		api.nvim_buf_add_highlight(projectsBuffer, namespace_id , 'ProjectsList', line, 0, -1)
		line = line + 1
	end
	api.nvim_buf_set_option(projectsBuffer, 'modifiable', false)
	buffers_loaded.projects = true
end

local function loadInstructionsBuffer()
	if buffers_loaded.instructions then api.nvim_buf_set_lines(instructionsBuffer, 0, api.nvim_buf_line_count(instructionsBuffer), true, {}) end
	local cols = api.nvim_win_get_width(instructionsWindow)
	for i = 0, 50, 1 do api.nvim_buf_set_lines(instructionsBuffer, i, i, true, {""}) end
	local title = string.rep(' ', cols/2 - 12/2) .. "INSTRUCTIONS"
	api.nvim_buf_set_lines(instructionsBuffer, 0, 0, true, {title})

	local indent = 15
	local instructions = {
		string.rep(' ', indent) .. ' <CR> : CD To Project Under Cursor',
		string.rep(' ', indent) .. '  A   : Add Existing Project To List',
		string.rep(' ', indent) .. '<S-D> : Remove Project Under Cursor From List',
		string.rep(' ', indent) .. '  Q   : Closes Window',
		string.rep(' ', indent) .. '  C   : Create Folder For Project And Add To List'
	}
	for _,text in ipairs(instructions) do
		api.nvim_buf_set_lines(instructionsBuffer, _ + 10,_ + 10, true, {text})
	end
	local user_text = {}
	for _, text in ipairs(options.instructions_data) do
		table.insert(user_text, string.rep(" ", indent) .. text)
		table.insert(user_text, '')
	end
	api.nvim_buf_set_lines(instructionsBuffer, 30,30, true, user_text)
	for i = 0, 80, 1 do api.nvim_buf_add_highlight(instructionsBuffer, namespace_id , 'ProjectsTitle', i, 0, -1) end
	buffers_loaded.instructions = true
end

local function loadRecentsBuffer()
	api.nvim_buf_set_lines(recentsBuffer, 0,0, false, options.recents_data)
	buffers_loaded.recents = true
end

local function loadBuffers()
	loadProjectsBuffer()
	loadInstructionsBuffer()
	loadRecentsBuffer()
end
local function HandleInput()
	local line = string.gsub(api.nvim_get_current_line(), "%s+", "")
	if line ~= "" and line ~= "Projects" then
		for name, path in pairs(M.fetchProjects()) do
			if name == line then
				api.nvim_command('cd ' .. path)
				api.nvim_exec_autocmds("User", {pattern = 'ProjectsDirChanged', data = path})
				M.ToggleProjectsView()
			end
		end
	end
end

function M.ToggleProjectsView()
	if vim.fn.getbufinfo(projectsBuffer)[1].hidden == 1 then
		local common_highlight_opts = 'Normal:Normal,EndOfBuffer:ProjectEndOfBuffer'
		recentsWindow = api.nvim_open_win(recentsBuffer, 1, recentsWindow_opts)
		api.nvim_win_set_option(recentsWindow, 'cursorline', false)
		api.nvim_win_set_option(recentsWindow, 'winhighlight', common_highlight_opts)
		api.nvim_win_set_option(recentsWindow, 'number', false)
		api.nvim_win_set_option(recentsWindow, 'rnu', false)

		instructionsWindow = api.nvim_open_win(instructionsBuffer, 0, instructionsWindow_opts)
		api.nvim_win_set_option(instructionsWindow, 'cursorline', false)
		api.nvim_win_set_option(instructionsWindow, 'winhighlight', common_highlight_opts)
		api.nvim_win_set_option(instructionsWindow, 'number', false)
		api.nvim_win_set_option(instructionsWindow, 'rnu', false)


		mainWindow = api.nvim_open_win(projectsBuffer, 1, mainWindow_opts)
		api.nvim_win_set_option(mainWindow, 'cursorline', true)
		api.nvim_win_set_option(mainWindow, 'winhighlight', common_highlight_opts)
		api.nvim_win_set_option(mainWindow, 'number', false)
		api.nvim_win_set_option(mainWindow, 'rnu', false)
		api.nvim_set_current_win(mainWindow)

		if buffers_loaded.projects then api.nvim_win_set_cursor(mainWindow, {1, 0}) api.nvim_win_set_cursor(mainWindow, {7, 0}) end

	else
		if api.nvim_win_is_valid(recentsWindow) then api.nvim_win_hide(recentsWindow) end
		if api.nvim_win_is_valid(instructionsWindow) then api.nvim_win_hide(instructionsWindow) end
		if api.nvim_win_is_valid(mainWindow) then api.nvim_win_hide(mainWindow) end
	end
end


function M.createProject()
	local dir = os.getenv('HOME')
	local project_path = nil
	local project_name = nil
	vim.ui.input({prompt = 'Project-Name: '}, function (input) project_name = input end)
	vim.ui.input({prompt = 'Project-Location: ', default = dir, completion = 'dir'}, function (input) project_path = input end)
	if project_name == nil or project_path == nil then return end
	api.nvim_command(string.format('call mkdir("%s")', project_path))
	local file = io.open(projectfile, 'a')
	if file ~=nil then
		file:write(string.format('Entry{project_name = "%s", project_path = "%s"}\n', project_name, project_path))
		file:close()
		loadProjectsBuffer()
	end
end


function M.addProject(args)

	local dir = os.getenv('HOME')

	local path = nil
	vim.ui.input({prompt = 'Project-Path: ', default = dir ,completion='dir'}, function(input) path = input end)

	if path == nil then return end

	local file = io.open(projectfile, 'a')
	if file ~= nil then
		file:write(string.format('Entry{project_name = "%s", project_path = "%s"}\n', args.fargs[1], path))
		file:close()
		loadProjectsBuffer()
	end
end


function M.removeProject()
	api.nvim_buf_set_option(projectsBuffer, 'modifiable', true)
	local line = string.gsub(api.nvim_get_current_line(), "%s", "")
	local file_content = {}
	if not file_exists(projectfile) then return end

	local file = assert(io.open(projectfile, "r"), "File failed to open file for read")
	for f_line in file:lines("l") do
		if string.find(f_line, line) ==nil then
			file_content[#file_content+1] = f_line
		end
	end

	file:close()
	file = assert(io.open(projectfile, 'w+'), "Failed to open file for write")

	for i, f_line in ipairs(file_content) do
		file:write(f_line, "\n")
	end
	file:close()

	vim.fn.deletebufline(projectsBuffer, api.nvim_win_get_cursor(0)[1])
	api.nvim_buf_set_option(projectsBuffer, 'modifiable', false)
end

function M.fetchProjects()
	local projects = {}
	local count = 1
	function Entry (item)
		projects[item.project_name] = item.project_path
		count = count + 1
	end
	dofile(projectfile)
	return projects
end

function M.highlights()
	local title_hl = 'highlight ProjectsTitle guifg=' .. options.style.title
	vim.cmd(title_hl)

	vim.cmd('highlight ProjectsList guifg='..options.style.list)
	vim.cmd('highlight ProjectNormal guifg=#ffffff guibg='.. options.style.normal)
	vim.cmd('highlight ProjectEndOfBuffer guifg='..options.style.end_of_buffer)
	namespace_id = api.nvim_create_namespace('ProjectsHighlightNS')
end

---@param path string
---@return string #Absolute path to file
local function createProjectsFile(path)
	local file_name = path .. "available_projects.lua"
	if not file_exists(projectfile) then
		local file = io.open(projectfile, "w")
		if file ~= nil then file:write("")file:close() end
	end
	return file_name
end

function M.LoadMappings()
	api.nvim_buf_set_keymap(projectsBuffer, 'n', 'q', '<cmd>q<CR>', {})
	api.nvim_buf_set_keymap(projectsBuffer, 'n', '<ESC>', '<cmd>q<CR>', {})
	api.nvim_buf_set_keymap(projectsBuffer, 'n', '<CR>', '', {callback = HandleInput})
	api.nvim_buf_set_keymap(projectsBuffer, 'n', 'D', '', {callback = M.removeProject})
	api.nvim_buf_set_keymap(projectsBuffer, 'n', 'a', '', {
		callback = function ()
			local project_name = nil
			vim.ui.input({prompt = 'Enter project name: '}, function(input) project_name = input end)
			if project_name == nil then return end
			M.addProject({fargs = {project_name}})
	end})
	api.nvim_buf_set_keymap(projectsBuffer, 'n', 'n', '', {callback = M.createProject})
end

function M.LoadUserCommands()
	api.nvim_create_user_command('FetchProjects', M.fetchProjects, {bang = true})
	api.nvim_create_user_command('AddProject', M.addProject,{nargs = 1, bang = true})
	api.nvim_create_user_command('ToggleProjectsView', M.ToggleProjectsView, {nargs = 0, bang = true})

end
local function MergeOptions(user_opts)
	if(user_opts == nil) then return default_options end
	local opts = {}
	for key, val in pairs(default_options) do
		if user_opts[key] ~= nil then
			if type(user_opts[key]) == "table" then
				opts[key] = val
				for t_key, t_val in pairs(user_opts[key]) do
					opts[key][t_key] = t_val
				end
			else
				opts[key] = user_opts[key]
			end
		else
			opts[key] = val
		end
	end
	return opts
end
---@param opts table|nil
function M.setup(opts)
	options = MergeOptions(opts)
	projectfile = createProjectsFile(options.file_path)
	M.highlights()

	projectsBuffer = api.nvim_create_buf(false, true)
	recentsBuffer = api.nvim_create_buf(false, true)
	instructionsBuffer = api.nvim_create_buf(false, true)

	M.LoadMappings()
	M.LoadUserCommands()

	local winWidth = math.floor(api.nvim_list_uis()[1].width/3)
	local winHeight = math.floor(api.nvim_list_uis()[1].height)
	recentsWindow_opts = {
		relative = 'editor',
		anchor = "NW",
		width = winWidth,
		height = winHeight,
		row = 0,
		col = 0
	}
	mainWindow_opts = {
		relative = 'editor',
		anchor = "NW",
		width = winWidth,
		height = winHeight,
		row = 0,
		col = winWidth
	}
	instructionsWindow_opts = {
		relative = 'editor',
		anchor = "NW",
		width = winWidth,
		height = winHeight,
		row = 0,
		col = (winWidth)*2
	}

	M.ToggleProjectsView()
	loadBuffers()
	M.ToggleProjectsView()

	api.nvim_create_augroup('Projects', {clear = true})
	api.nvim_create_autocmd({'BufLeave','WinLeave'},{
		buffer = projectsBuffer,
		callback = function ()
			M.ToggleProjectsView()
		end,
		group = 'Projects'
	})
	api.nvim_create_autocmd({'WinResized'}, {
		pattern = '*',
		callback = function ()
			if not api.nvim_win_is_valid(mainWindow) then return end
			local newWinWidth = math.floor(api.nvim_list_uis()[1].width/3)
			local newWinHeight = math.floor(api.nvim_list_uis()[1].height)
			recentsWindow_opts.width = newWinWidth
			recentsWindow_opts.height = newWinHeight

			mainWindow_opts.width = newWinWidth
			mainWindow_opts.height = newWinHeight
			mainWindow_opts.col = newWinWidth

			instructionsWindow_opts.width = newWinWidth
			instructionsWindow_opts.height = newWinHeight
			instructionsWindow_opts.col = newWinWidth*2

			loadBuffers()
			M.ToggleProjectsView()
			M.ToggleProjectsView()

		end,
		group = 'Projects'
	})
end
return M
