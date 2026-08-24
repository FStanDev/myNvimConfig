-- https://www.josean.com/posts/neovim-linting-and-formatting

-- Manual format keymap.
-- This used to sit *inside* the returned options table, where it ran as a side
-- effect of building the table and its callback referenced an undefined global
-- `conform` — pressing <leader>mp raised "attempt to index a nil value".
-- It is a statement now, and it requires conform properly.
vim.keymap.set({ "n", "v" }, "<leader>mp", function()
	require("conform").format({
		async = false,
		timeout_ms = 1500,
		lsp_format = "fallback",
	})
end, { desc = "Format file or range (in visual mode)" })

return {
	formatters_by_ft = {
		javascript = { "prettier" },
		typescript = { "prettier" },
		javascriptreact = { "prettier" },
		typescriptreact = { "prettier" },
		svelte = { "prettier" },
		css = { "prettier" },
		html = { "prettier" },
		astro = { "prettier" },
		json = { "prettier" },
		yaml = { "prettier" },
		markdown = { "prettier" },
		graphql = { "prettier" },
		lua = { "stylua" },
		python = { "isort", "black" },
		rust = { "rustfmt" },
		go = { "gofumpt", "goimports" },
	},
	format_on_save = {
		async = false,
		timeout_ms = 1500,
		-- `lsp_fallback` is conform's deprecated spelling; `lsp_format` is the
		-- current option name and the only one honoured by format_on_save.
		lsp_format = "fallback",
	},
}
