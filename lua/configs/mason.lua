return {
	ensure_installed = vim.list_extend({
		"lua-language-server",
		"stylua",
		"rust-analyzer",
		"pyright",
		"prettier",
		"black",
		"isort",
		"typescript-language-server",
		"svelte-language-server",
		"debugpy",
		"astro-language-server",
	}, vim.fn.has("unix") == 1 and {
		"clangd",
		"codelldb",
		"zls",
		"clang-language-server",
	} or {}),
	max_concurrent_installers = 10,
}
