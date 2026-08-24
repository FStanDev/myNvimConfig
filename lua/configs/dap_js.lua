-- NOTE: this adapter is currently inert. `debugger_path` points at a
-- `vscode-js-debug` checkout that is not in the plugin spec and is not
-- installed, so nvim-dap-vscode-js has nothing to launch. Upstream
-- (mxsdev/nvim-dap-vscode-js) is also archived. Either add vscode-js-debug as
-- a built plugin spec, or drop the JS debug adapter — see update_log.md.
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
