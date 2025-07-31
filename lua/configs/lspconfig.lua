local lspconfig = require("lspconfig")

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set("n", "<space>d", vim.diagnostic.open_float)
vim.keymap.set("n", "[d", vim.diagnostic.goto_prev)
vim.keymap.set("n", "]d", vim.diagnostic.goto_next)
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- Enable completion triggered by <c-x><c-o>
		vim.bo[ev.buf].omnifunc = "v:lua.vim.lsp.omnifunc"

		-- Buffer local mappings.
		-- See `:help vim.lsp.*` for documentation on any of the below functions
		local opts = { buffer = ev.buf }
		vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
		vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
		vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
		vim.keymap.set("n", "<C-k>", vim.lsp.buf.signature_help, opts)
		vim.keymap.set("n", "<space>wa", vim.lsp.buf.add_workspace_folder, opts)
		vim.keymap.set("n", "<space>wr", vim.lsp.buf.remove_workspace_folder, opts)
		vim.keymap.set("n", "<space>wl", function()
			print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
		end, opts)
		vim.keymap.set("n", "<space>D", vim.lsp.buf.type_definition, opts)
		vim.keymap.set("n", "<space>rn", vim.lsp.buf.rename, opts)
		vim.keymap.set({ "n", "v" }, "<space>ca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "<space>f", function()
			vim.lsp.buf.format({ async = true })
		end, opts)
	end,
})

lspconfig.pyright.setup({})
lspconfig.lua_ls.setup({})
lspconfig.rust_analyzer.setup({
	settings = {
		["rust-analyzer"] = {
			cargo = {
				allFeatures = true,
			},
		},
	},
})
lspconfig.ts_ls.setup({})
lspconfig.svelte.setup({})
if vim.fn.has("unix") == 1 then
	local esp_idf_path = os.getenv("IDF_PATH")
	if esp_idf_path then
		-- for esp-idf
		require("lspconfig").clangd.setup({
			-- handlers = handlers,
			cmd = {
				"/Users/stan/.espressif/tools/esp-clang/esp-17.0.1_20240419/esp-clang/bin/clangd",
				"--background-index",
				"--query-driver=**",
			},
			root_dir = function()
				-- leave empty to stop nvim from cd'ing into ~/ due to global .clangd file
			end,
		})
	else
		-- clangd config
		require("lspconfig").clangd.setup({})
	end
	lspconfig.zls.setup({})
end

lspconfig.astro.setup({})
lspconfig.omnisharp.setup({
	cmd = { "omnisharp" },
	enable_roslyn_analyzers = true,
	organize_imports_on_format = true,
	enable_import_completion = true,
})
