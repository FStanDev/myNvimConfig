-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set("n", "<space>d", vim.diagnostic.open_float, { desc = "Show diagnostic under cursor" })
-- `vim.diagnostic.goto_prev/goto_next` are deprecated and scheduled for removal
-- in Neovim 0.13. `vim.diagnostic.jump()` is the replacement; `float = true`
-- keeps the old behaviour of popping the diagnostic open after jumping.
vim.keymap.set("n", "[d", function()
	vim.diagnostic.jump({ count = -1, float = true })
end, { desc = "Previous diagnostic" })
vim.keymap.set("n", "]d", function()
	vim.diagnostic.jump({ count = 1, float = true })
end, { desc = "Next diagnostic" })
vim.keymap.set("n", "<space>q", vim.diagnostic.setloclist, { desc = "Diagnostics to loclist" })

-- Advertise the completion capabilities nvim-cmp adds on top of Neovim's
-- defaults (snippet support, additionalTextEdits resolve, ...) to every server.
-- `vim.lsp.config('*', ...)` is the 0.11+ way to set defaults shared by all
-- configs; without this, cmp-nvim-lsp is installed but never actually wired in.
local ok_cmp_lsp, cmp_nvim_lsp = pcall(require, "cmp_nvim_lsp")
if ok_cmp_lsp then
	vim.lsp.config("*", {
		capabilities = cmp_nvim_lsp.default_capabilities(),
	})
end

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("UserLspConfig", {}),
	callback = function(ev)
		-- NOTE: `omnifunc` is set automatically by Neovim on attach since 0.8,
		-- so the manual assignment that used to live here was removed.

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
			-- Under `vim.lsp.config` the signature is `function(bufnr, on_dir)` and
			-- the server only starts once `on_dir` is called. The old 0-argument
			-- version returned nothing and silently prevented clangd from ever
			-- starting. Pin the root to the cwd so a stray global ~/.clangd can't
			-- pull the workspace up to $HOME.
			root_dir = function(_, on_dir)
				on_dir(vim.fn.getcwd())
			end,
		})
	end
	vim.lsp.enable("clangd")
	vim.lsp.enable("zls")
end

vim.lsp.enable("astro")

vim.lsp.enable("gopls")

-- Configure omnisharp with custom settings.
-- The old top-level `enable_roslyn_analyzers` / `organize_imports_on_format` /
-- `enable_import_completion` keys came from the nvim-lspconfig omnisharp
-- extension and are ignored by `vim.lsp.config`; these are the equivalent
-- omnisharp-roslyn server settings.
vim.lsp.config("omnisharp", {
	cmd = { "omnisharp" },
	settings = {
		FormattingOptions = {
			OrganizeImports = true,
		},
		RoslynExtensionsOptions = {
			EnableAnalyzersSupport = true,
			EnableImportCompletion = true,
		},
	},
})
vim.lsp.enable("omnisharp")
