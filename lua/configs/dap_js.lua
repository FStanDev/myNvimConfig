-- NOTE: this adapter is currently inert. `debugger_path` points at a
-- `vscode-js-debug` checkout that is not in the plugin spec and is not
-- installed, so nvim-dap-vscode-js has nothing to launch.
--
-- mxsdev/nvim-dap-vscode-js is NOT archived, but its last commit was
-- 2023-03-06 with 42 open issues — unmaintained in practice.
--
-- The modern replacement needs no wrapper plugin at all: install
-- `js-debug-adapter` via Mason and configure a `pwa-node` adapter directly in
-- nvim-dap, exactly the way codelldb is configured in configs/lazy.lua.
-- See update_log.md.
return {
	debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
	adapters = {
		-- "chrome" was listed twice here.
		"chrome",
		"pwa-node",
		"pwa-chrome",
		"pwa-msedge",
		"node-terminal",
		"pwa-extensionHost",
		"node",
	},
}
