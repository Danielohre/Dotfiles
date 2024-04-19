local nvim_tree = require("nvim-tree")

local function my_on_attach(bufnr)
	local api = require("nvim-tree.api")

	local function opts(desc)
		return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true}
	end
	api.config.mappings.default_on_attach(bufnr)

	vim.keymap.set('n', '<C-d>', 
	function()
		local node = api.tree.get_node_under_cursor()
		api.tree.change_root_to_node(node)
		vim.api.nvim_exec_autocmds("User", {pattern = 'NvimTreeChangedRoot', data = node.absolute_path})
	end,
	opts('CD'))
	vim.keymap.set('n', '<M-v>', api.node.open.vertical, opts('Open: Vertical Split'))
	vim.keymap.set('n', '<M-s>', api.node.open.horizontal, opts('Open: Horizontal Split'))
	vim.keymap.set('n', '?', api.tree.toggle_help, opts('Help'))
end

nvim_tree.setup {
	on_attach = my_on_attach, 
	--sync_root_with_cwd = true,
	git = {
		enable = false,
	},
	view = {
		width = 30,
		side = "left",

		float = {
			enable = true,
			quit_on_focus_loss = true,
			open_win_config = {
				relative = "win",
				border = "rounded",
				width = 30,
				row = 1,
				col = 1,
			},
		},
	},
	renderer = {
		group_empty = true,
	},
	sort = {
		sorter = "name",
		folders_first = true,
		files_first = false,
	}
}


