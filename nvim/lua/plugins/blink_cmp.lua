local blink = require('blink.cmp')

blink.setup {
		keymap = {
			preset = 'default',
		},

		appearance = {
		  -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
		  -- Adjusts spacing to ensure icons are aligned
		  nerd_font_variant = 'mono'
		},

		-- (Default) Only show the documentation popup when manually triggered
		completion = {
			documentation = { auto_show = false },
			trigger = {
				prefetch_on_insert = true,
				show_in_snippet = true,
				show_on_keyword = true,
				show_on_trigger_character = true,
			},
			list = {
				selection = {
					preselect = false,
					auto_insert = false,
				},
				cycle = 
				{
					from_bottom = true,
					from_top = true,
				}
			},
			menu = {
				auto_show = true
			}

		},

		sources = {
		  default = { 'lsp', 'path', 'snippets', 'buffer' },
		},

		fuzzy = { implementation = "lua" },
		signature = {
			enabled = true 
		},
		cmdline = {
			keymap = {
				preset = 'inherit'
			},
			completion = {
				menu = {
					auto_show = true
				},
			},
		},
}


