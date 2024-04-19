local M = {}
local projectfile = ""
local api = vim.api
local projectsBuffer = nil
local namespace_id
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
	local rows = 70
	for i = 0, rows, 1 do api.nvim_buf_set_lines(projectsBuffer, i, i, true, {""}) end
	local header_lines = {
		string.rep(' ', cols/2 - 31/2) .. ' ____            _           _',
		string.rep(' ', cols/2 - 31/2) ..'|    \\_____ ___ (_) ___  ___| |_ ___',
		string.rep(' ', cols/2 - 31/2) ..'| |_) |  __/ _ \\| |/ _ \\/ __| __/ __|',
		string.rep(' ', cols/2 - 31/2) ..'|  __/| | | (_) | |  __/ (__| |_\\__ \\',
		string.rep(' ', cols/2 - 31/2) ..'|_|   |_|  \\___// |\\___|\\___|\\__|___/ ',
		string.rep(' ', cols/2 - 31/2) ..'              |__/ '

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
	local cols = api.nvim_win_get_width(instructionsWindow)
	for i = 0, 70, 1 do api.nvim_buf_set_lines(instructionsBuffer, i, i, true, {""}) end
	local title = string.rep(' ', cols/2 - 12/2) .. "INSTRUCTIONS"
	api.nvim_buf_set_lines(instructionsBuffer, 0, 0, true, {title})

	local indent = 35
	local instructions = {
		string.rep(' ', indent) .. ' <CR> : CD To Project Under Cursor',
		string.rep(' ', indent) .. '  A   : Add Existing Project To List',
		string.rep(' ', indent) .. '<S-D> : Remove Project Under Cursor From List',
		string.rep(' ', indent) .. '  Q   : Closes Window',
		string.rep(' ', indent) .. '  C   : Folder For Project And Add To List'
	}
	for _,text in ipairs(instructions) do
		api.nvim_buf_set_lines(instructionsBuffer, _+10,_+10, true, {text})
	end
	local mappings = {
		string.rep(" ", indent) .. '     <C-m> : Toggle Terminal',
		'',
		string.rep(" ", indent) .. '<leader>ff : Find File in CWD',
		'',
		string.rep(" ", indent) .. '<leader>fg : LiveGrep In CWD',
	}
	api.nvim_buf_set_lines(instructionsBuffer, 60,60, true, mappings)
	for i = 0, 80, 1 do api.nvim_buf_add_highlight(instructionsBuffer, namespace_id , 'ProjectsTitle', i, 0, -1) end

end

local function loadRecentsBuffer()
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

		instructionsWindow = api.nvim_open_win(instructionsBuffer, 0, instructionsWindow_opts)
		api.nvim_win_set_option(instructionsWindow, 'cursorline', false)
		api.nvim_win_set_option(instructionsWindow, 'winhighlight', common_highlight_opts)
		api.nvim_win_set_option(instructionsWindow, 'number', false)


		mainWindow = api.nvim_open_win(projectsBuffer, 1, mainWindow_opts)
		api.nvim_win_set_option(mainWindow, 'cursorline', true)
		api.nvim_win_set_option(mainWindow, 'winhighlight', common_highlight_opts)
		api.nvim_win_set_option(mainWindow, 'number', false)

		if buffers_loaded.projects then api.nvim_win_set_cursor(mainWindow, {7, 0}) end

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
	vim.cmd('highlight ProjectsTitle guifg=#0dbdba')
	vim.cmd('highlight ProjectsList guifg=#14b333')
	vim.cmd('highlight ProjectNormal guifg=#ffffff guibg=#061430 ')
	vim.cmd('highlight ProjectEndOfBuffer guifg=bg')
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
	api.nvim_buf_set_keymap(projectsBuffer, 'n', '<ESC>', '<cmm>q<CR>', {})
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
function M.setup(opts)
	projectfile = createProjectsFile(opts.file_path)
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
		col = winWidth*2
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
end
return M
