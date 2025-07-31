return {
	ensure_installed = vim.list_extend({
		"lua-language-server",
		"stylua",
		"pyright",
		"prettier",
		"black",
		"isort",
		"typescript-language-server",
		"tailwindcss-language-server",
		"svelte-language-server",
		"astro-language-server",
		--"omnisharp", Only if required, not on my MacOS setup
	}, vim.fn.has("unix") == 1 and {
		"clangd",
		"codelldb",
		"zls",
		"rust-analyzer",
		"debugpy",
	} or {}),
	max_concurrent_installers = 10,
}
