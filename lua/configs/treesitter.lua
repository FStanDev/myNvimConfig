-- configs/treesitter.lua
-- Main branch configuration for nvim-treesitter

-- 1. Configure nvim-treesitter (minimal setup)
require("nvim-treesitter").setup({
    -- Optional: specify parser installation directory
    install_dir = vim.fn.stdpath('data') .. '/site',
})

-- 2. Define languages to install
local base_languages = {
    "vim",
    "lua",
    "vimdoc",
    "query",     -- Required for treesitter query debugging
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

-- Unix-only languages (require compilation)
local unix_languages = {
    "c",
    "cpp",
    "zig",
    "rust",
    "svelte",
    "astro"
}

local languages_to_install = base_languages
if vim.fn.has("unix") == 1 then
    -- Extend in place (modifies languages_to_install)
    vim.list_extend(languages_to_install, unix_languages)
end

-- 3. Install parsers (call this once at startup)
-- This runs asynchronously, so it won't block Neovim startup
require('nvim-treesitter').install(languages_to_install)

-- 4. Enable treesitter-based features using Neovim's APIs

-- 4a. Highlighting (enabled by default in Neovim 0.11+)
-- If you need manual control:
-- vim.api.nvim_create_autocmd('FileType', {
--   pattern = base_languages,
--   callback = function()
--     vim.treesitter.start()
--   end,
-- })

-- 4b. Indentation (optional, per-filetype)
vim.api.nvim_create_autocmd('FileType', {
    pattern = {'python', 'lua', 'rust', 'javascript', 'typescript', 'tsx'},
    callback = function()
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})

-- 4c. Folding (treesitter-based)
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldenable = false  -- Start with folds open
vim.opt.foldlevel = 99

-- 5. Auto-install missing parsers on FileType (optional)
-- This replicates the old `auto_install` behavior
local function ensure_parser_installed(lang)
    local parsers = require('nvim-treesitter.parsers')
    if not parsers[lang] then
        vim.notify("Installing parser for " .. lang, vim.log.levels.INFO)
        require('nvim-treesitter').install({lang})
    end
end

vim.api.nvim_create_autocmd('FileType', {
    callback = function(args)
        local lang = vim.treesitter.language.get_lang(args.match)
        if lang then
            ensure_parser_installed(lang)
        end
    end,
})