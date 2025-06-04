-- https://www.josean.com/posts/neovim-linting-and-formatting
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
	},
	format_on_save = {
		async = false,
		timeout_ms = 1500,
		lsp_fallback = true,
	},

	vim.keymap.set({ "n", "v" }, "<leader>mp", function()
		conform.format({
			async = false,
			timeout_ms = 1500,
			lsp_fallback = true,
		})
	end, { desc = "Format file or range (in visual mode)" }),
}
