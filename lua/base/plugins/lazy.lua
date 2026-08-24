local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
-- `vim.loop` is the deprecated alias for `vim.uv` (libuv bindings).
if not vim.uv.fs_stat(lazypath) then
	vim.fn.system({
		"git",
		"clone",
		"--filter=blob:none",
		"https://github.com/folke/lazy.nvim.git",
		"--branch=stable", -- latest stable release
		lazypath,
	})
end
vim.opt.rtp:prepend(lazypath)
-- `local`: this used to leak a global `plugins`.
local plugins = require("configs.lazy")

require("lazy").setup(plugins)
