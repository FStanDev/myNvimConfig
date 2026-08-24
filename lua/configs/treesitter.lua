-- ============================================================================
--  I´m doing all this changes becuase the main branch now relays on nvim itself for more of past functions
-- ============================================================================

require("nvim-treesitter").setup({
	-- This directory is prepended to runtimepath to have priority
	install_dir = vim.fn.stdpath("data") .. "/site",
})

local base_languages = {
	"vim",
	"lua",
	"vimdoc",
	"query", -- Required for treesitter debugging (e.g., :InspectTree)
	"markdown",
	"markdown_inline",
	"html",
	"css",
	"javascript",
	"typescript",
	"tsx",
	"python",
	"yaml",
	"json",
	"bash",
}

-- Unix-only languages (require compilation tools)
-- These need a C compiler to build
local unix_languages = {
	"c",
	"cpp",
	"zig",
	"rust",
	"go",
	"svelte",
	"astro",
}

-- Combine languages based on platform.
-- NOTE: copy the base list first — `vim.list_extend` mutates its first argument,
-- so assigning it directly would also grow `base_languages`.
local languages_to_install = vim.list_extend({}, base_languages)
if vim.fn.has("unix") == 1 then
	vim.list_extend(languages_to_install, unix_languages)
end

-- No more ensure installed :(
require("nvim-treesitter").install(languages_to_install)

-- Enable treesitter-based highlighting.
-- This replaces: highlight = { enable = true } from master branch.
--
-- Neovim's own runtime only starts treesitter for a handful of bundled filetypes
-- (lua, markdown, help, query), so without this autocmd every other language
-- silently falls back to the old regex syntax engine even when its parser is
-- installed. `vim.treesitter.start()` throws when no parser is available, hence
-- the pcall — filetypes we have no parser for just keep regex highlighting.
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("UserTreesitterHighlight", { clear = true }),
	callback = function()
		pcall(vim.treesitter.start)
	end,
})

-- Enable treesitter-based indentation for specific filetypes
-- This replaces: indent = { enable = true } from master branch

vim.api.nvim_create_autocmd("FileType", {
	pattern = {
		"python",
		"lua",
		"rust",
		"go",
		"javascript",
		"typescript",
		"tsx",
		"jsx",
		"c",
		"cpp",
		"html",
		"css",
		"svelte",
		"astro",
	},
	callback = function()
		vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
	end,
})

-- Enable treesitter-based folding
-- This replaces the fold module from master branch

vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"

-- Optional folding settings
vim.opt.foldenable = false -- Start with folds open
vim.opt.foldlevel = 99 -- High foldlevel to keep most folds open
vim.opt.foldlevelstart = 99 -- Start editing with all folds open
vim.opt.foldnestmax = 4 -- Limit fold nesting

-- This replicates the old `auto_install = true` behavior
-- When you open a file, if the parser is missing, it will be installed

local available_parsers -- lazily filled, `get_available()` is not cheap

local function ensure_parser_installed(lang)
	-- `nvim-treesitter.config.get_installed("parsers")` is the installed set.
	-- (The `nvim-treesitter.parsers` module is the catalog of *available*
	-- parser definitions, so checking it told us nothing about what we have.)
	local installed = require("nvim-treesitter").get_installed("parsers")
	if vim.tbl_contains(installed, lang) then
		return
	end

	-- Don't try to install a language upstream doesn't ship a parser for.
	available_parsers = available_parsers or require("nvim-treesitter").get_available()
	if not vim.tbl_contains(available_parsers, lang) then
		return
	end

	vim.notify("Installing treesitter parser for: " .. lang, vim.log.levels.INFO)
	require("nvim-treesitter").install({ lang })
end

-- Auto-install parser when opening a file
vim.api.nvim_create_autocmd("FileType", {
	group = vim.api.nvim_create_augroup("UserTreesitterAutoInstall", { clear = true }),
	callback = function(args)
		-- Get the treesitter language for this filetype
		local lang = vim.treesitter.language.get_lang(args.match)

		if lang then
			ensure_parser_installed(lang)
		end
	end,
})

-- ============================================================================
-- USEFUL COMMANDS AND KEYMAPS
-- ============================================================================

-- Command to manually install a parser
vim.api.nvim_create_user_command("TSInstallLanguage", function(opts)
	local lang = opts.args
	if lang and lang ~= "" then
		require("nvim-treesitter").install({ lang })
	else
		vim.notify("Usage: :TSInstallLanguage <language>", vim.log.levels.ERROR)
	end
end, {
	nargs = 1,
	complete = function()
		return require("nvim-treesitter").get_available()
	end,
})

-- ============================================================================
-- COMPATIBILITY NOTES
-- ============================================================================
--[[
REMOVED FEATURES FROM MASTER BRANCH:
- ❌ ensure_installed option
- ❌ auto_install option
- ❌ highlight = { enable = true }
- ❌ indent = { enable = true }
- ❌ incremental_selection module
- ❌ textobjects module (now separate plugin on main branch)
- ❌ playground module
- ❌ rainbow module

MIGRATION NOTES:
- For textobjects: Use nvim-treesitter/nvim-treesitter-textobjects (main branch)
- For incremental selection: Use native Neovim features or create your own
- For playground: Use :InspectTree (built into Neovim)

REQUIREMENTS:
- Neovim 0.11.0+ (0.12+ recommended)
- tree-sitter-cli 0.25.0+
- C compiler (gcc/clang/msvc)
- tar and curl for downloading parsers
]]
--
