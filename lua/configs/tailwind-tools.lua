return {
	-- Server settings for the Tailwind CSS Language Server
	server = {
		-- You can override server capabilities here if needed
		override = true,
		settings = {},
		-- Configure on_attach to set up keymaps when LSP attaches
		on_attach = function(client, bufnr)
			-- You can add custom keymaps here specific to Tailwind buffers
		end,
	},

	-- Document colors configuration (inline color previews)
	document_color = {
		enabled = true, -- Enable color previews for Tailwind color classes
		kind = "inline", -- Can be "inline" or "foreground" or "background"
		inline_symbol = "󰝤 ", -- Symbol to show before the color
		debounce = 200, -- Debounce time in milliseconds
	},

	-- Conceal configuration - This is what you're looking for!
	conceal = {
		enabled = true, -- Enable concealing of long class strings
		symbol = "…", -- Symbol to show when classes are concealed
		-- Controls when to trigger concealment based on class string length
		highlight = {
			-- Highlight group for the concealed symbol
			fg = "#38BDF8", -- Tailwind blue color
		},
	},

	-- Custom CSS class patterns (if you use custom prefixes or suffixes)
	custom_filetypes = {},

	-- Extension configuration
	extension = {
		queries = {}, -- Custom treesitter queries
		patterns = {
			-- Custom patterns for detecting Tailwind classes
			-- Useful if you have custom attribute names
		},
	},
}
