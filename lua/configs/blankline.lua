return {
	-- These are the default settings
	indent = {
		char = "│", -- This is the character used for the vertical line
		tab_char = "│", -- Character for tab indentation
	},
	scope = {
		enabled = true, -- Highlight the scope/context of the current cursor position
		show_start = true, -- Show a line at the start of the current scope
		show_end = false, -- Show a line at the end of the current scope
		highlight = { "Function", "Label", "Conditional", "Repeat" }, -- Highlight groups to use
	},
	exclude = {
		filetypes = {
			"help",
			"alpha",
			"dashboard",
			"neo-tree",
			"Trouble",
			"lazy",
			"mason",
			"notify",
			"toggleterm",
			"lazyterm",
		},
		buftypes = {
			"terminal",
			"nofile",
			"quickfix",
			"prompt",
		},
	},
}