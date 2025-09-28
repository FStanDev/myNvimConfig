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

-- Enable LSP servers using the new vim.lsp.enable API
vim.lsp.enable("pyright")
vim.lsp.enable("lua_ls")

-- Configure rust-analyzer with custom settings
vim.lsp.config("rust_analyzer", {
	settings = {
		["rust-analyzer"] = {
			cargo = {
				allFeatures = true,
			},
		},
	},
})
vim.lsp.enable("rust_analyzer")

vim.lsp.enable("ts_ls")
vim.lsp.enable("svelte")

if vim.fn.has("unix") == 1 then
	local esp_idf_path = os.getenv("IDF_PATH")
	if esp_idf_path then
		-- for esp-idf
		vim.lsp.config("clangd", {
			cmd = {
				"/Users/stan/.espressif/tools/esp-clang/esp-17.0.1_20240419/esp-clang/bin/clangd",
				"--background-index",
				"--query-driver=**",
			},
			root_dir = function()
				-- leave empty to stop nvim from cd'ing into ~/ due to global .clangd file
			end,
		})
	end
	vim.lsp.enable("clangd")
	vim.lsp.enable("zls")
end

vim.lsp.enable("astro")

-- Configure omnisharp with custom settings
vim.lsp.config("omnisharp", {
	cmd = { "omnisharp" },
	enable_roslyn_analyzers = true,
	organize_imports_on_format = true,
	enable_import_completion = true,
})
vim.lsp.enable("omnisharp")