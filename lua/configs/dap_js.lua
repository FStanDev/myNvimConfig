-- JavaScript / TypeScript debugging.
--
-- This uses microsoft/vscode-js-debug directly — the same debugger VS Code
-- ships — installed through Mason as `js-debug-adapter`. No wrapper plugin is
-- involved: nvim-dap talks to the adapter's `dapDebugServer.js` over a socket,
-- the same way the codelldb adapter is wired up in configs/lazy.lua.
--
-- On the "pwa-" prefix: it has nothing to do with Progressive Web Apps. It is a
-- legacy name from when this debugger shipped as a preview ("JavaScript
-- Debugger (Nightly)") and was kept for backwards compatibility.
--   pwa-node   -> Node processes (dev server, SSR, API routes, scripts, tests)
--   pwa-chrome -> the app running in the browser

local M = {}

local function debug_server()
	return vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js"
end

-- Filetypes that should get the JS/TS debug configurations.
local filetypes = {
	"javascript",
	"typescript",
	"javascriptreact",
	"typescriptreact",
	"svelte",
	"astro",
}

function M.setup()
	local dap = require("dap")

	if vim.fn.filereadable(debug_server()) == 0 then
		vim.notify(
			"js-debug-adapter not found. Run :MasonInstall js-debug-adapter",
			vim.log.levels.WARN
		)
		return
	end

	-- One server executable backs every js-debug type.
	-- `initialize_timeout_sec` defaults to 4 in nvim-dap, which is not enough
	-- for a cold Chrome launch — it produces a spurious "Debug adapter didn't
	-- respond" warning before the session connects normally.
	local function adapter(timeout_sec)
		return {
			type = "server",
			host = "127.0.0.1",
			port = "${port}",
			executable = {
				command = "node",
				args = { debug_server(), "${port}", "127.0.0.1" },
			},
			options = {
				initialize_timeout_sec = timeout_sec,
			},
		}
	end

	dap.adapters["pwa-node"] = adapter(10)
	dap.adapters["pwa-chrome"] = adapter(20)

	for _, ft in ipairs(filetypes) do
		dap.configurations[ft] = {
			-- ── Node side ────────────────────────────────────────────────
			{
				type = "pwa-node",
				request = "launch",
				name = "Node: launch current file",
				program = "${file}",
				cwd = "${workspaceFolder}",
				sourceMaps = true,
				-- Don't step into dependencies or Node internals.
				skipFiles = { "<node_internals>/**", "${workspaceFolder}/node_modules/**" },
			},
			{
				type = "pwa-node",
				request = "attach",
				name = "Node: attach to process",
				processId = require("dap.utils").pick_process,
				cwd = "${workspaceFolder}",
				sourceMaps = true,
				skipFiles = { "<node_internals>/**", "${workspaceFolder}/node_modules/**" },
			},
			{
				-- For a dev server started with --inspect (vite, astro dev,
				-- sveltekit, nodemon, ...). Node's default inspector port.
				type = "pwa-node",
				request = "attach",
				name = "Node: attach to port 9229",
				address = "localhost",
				port = 9229,
				cwd = "${workspaceFolder}",
				sourceMaps = true,
				skipFiles = { "<node_internals>/**", "${workspaceFolder}/node_modules/**" },
			},

			-- ── Browser side ─────────────────────────────────────────────
			{
				-- Launches Chrome against a dev server you already have running.
				-- `webRoot` is what maps the sources Chrome reports back onto
				-- files on disk — adjust per project if breakpoints go unbound.
				type = "pwa-chrome",
				request = "launch",
				name = "Chrome: launch against dev server",
				url = function()
					local default = "http://localhost:5173" -- vite / sveltekit / astro
					return vim.fn.input("Dev server URL: ", default)
				end,
				webRoot = "${workspaceFolder}",
				sourceMaps = true,
				-- Use a scratch profile so this never touches your real Chrome
				-- session, and so launching doesn't reuse an existing window.
				userDataDir = vim.fn.stdpath("cache") .. "/dap-chrome-profile",
				skipFiles = { "<node_internals>/**", "${workspaceFolder}/node_modules/**" },
				-- Framework sources are served under /@fs or /src by vite; these
				-- overrides cover the common Svelte/Astro/vite layouts.
				sourceMapPathOverrides = {
					["webpack:///./~/*"] = "${workspaceFolder}/node_modules/*",
					["webpack:///./*"] = "${workspaceFolder}/*",
					["webpack:///*"] = "*",
					["/@fs/*"] = "*",
					["/./*"] = "${workspaceFolder}/*",
					["/src/*"] = "${workspaceFolder}/src/*",
				},
			},
			{
				-- Attaches to a Chrome already started with
				--   --remote-debugging-port=9222
				type = "pwa-chrome",
				request = "attach",
				name = "Chrome: attach on port 9222",
				port = 9222,
				webRoot = "${workspaceFolder}",
				sourceMaps = true,
				skipFiles = { "<node_internals>/**", "${workspaceFolder}/node_modules/**" },
			},
		}
	end
end

return M
