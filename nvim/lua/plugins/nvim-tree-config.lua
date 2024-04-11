nvim_tree = require("nvim-tree")

local function my_on_attach(bufnr)
	local api = require("nvim-tree.api")

	local function opts(desc)
		return { desc = 'nvim-tree: ' .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true}
	end
	api.config.mappings.default_on_attach(bufnr)

	vim.keymap.set('n', '<C-d>', api.tree.change_root_to_node, opts('CD'))
	vim.keymap.set('n', '<M-v>', api.node.open.vertical, opts('Open: Vertical Split'))
	vim.keymap.set('n', '<M-s>', api.node.open.horizontal, opts('Open: Horizontal Split'))
end

nvim_tree.setup {
	on_attach = my_on_attach, 
	git = {
		enable = false,
	},
	view = {
		width = 30,
		side = "left",
	}
}


