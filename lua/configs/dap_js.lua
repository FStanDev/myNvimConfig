return {
	debugger_path = vim.fn.stdpath("data") .. "/lazy/vscode-js-debug",
	adapters = {
		"chrome",
		"pwa-node",
		"pwa-chrome",
		"pwa-msedge",
		"node-terminal",
		"pwa-extensionHost",
		"node",
		"chrome",
	},
}
