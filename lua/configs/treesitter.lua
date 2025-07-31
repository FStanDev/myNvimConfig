local configs = require("nvim-treesitter.configs")

-- Base languages for all platforms
local base_languages = {
	"vim",
	"lua",
	"vimdoc",
	"html",
	"css",
	"javascript",
	"typescript",
	"tsx",
	"python",
	"yaml",
}

-- Unix-only languages (require compilation tools)
local unix_languages = { "c", "cpp", "zig", "rust", "svelte", "astro" }

-- Combine languages based on platform
local ensure_installed = base_languages
if vim.fn.has("unix") == 1 then
	vim.list_extend(ensure_installed, unix_languages)
end

configs.setup({
	ensure_installed = ensure_installed,
	sync_install = false,
	highlight = { enable = true },
	indent = { enable = true },
})
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"