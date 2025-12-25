--Basic settings

vim.g.mapleader = " "

vim.wo.relativenumber = true
vim.wo.number = true
--GENERAL Mappings
vim.keymap.set("n", "<leader>vs", vim.cmd.vsplit)
vim.keymap.set("n", "<leader>e", vim.cmd.NvimTreeFocus)
vim.keymap.set("n", "<C-n>", vim.cmd.NvimTreeToggle)
vim.keymap.set("n", "<leader>1", vim.cmd.bfirst)
vim.keymap.set("n", "<leader>0", vim.cmd.blast)
vim.keymap.set("n", "<Tab>", vim.cmd.bnext)
vim.keymap.set("n", "<S-Tab>", vim.cmd.bprevious)
vim.keymap.set("n", "<leader>b", vim.cmd.DapToggleBreakpoint)
vim.keymap.set("n", "<leader>ds", vim.cmd.DapSidebar)
vim.keymap.set("n", "<leader>dn", vim.cmd.DapStepOver)
vim.keymap.set("n", "<leader>dx", vim.cmd.DapTerminate)
vim.keymap.set("n", "<leader>du", function()
	require("dapui").toggle()
end, { desc = "Toggle DAP UI" })
vim.keymap.set("n", "<leader>dp", function()
	require("dap-python").test_method()
end)
-- Jump to next/previous breakpoint
vim.keymap.set("n", "]b", function()
	local breakpoints = require("dap.breakpoints").get()
	if not breakpoints or vim.tbl_isempty(breakpoints) then
		vim.notify("No breakpoints set", vim.log.levels.WARN)
		return
	end

	local current_buf = vim.api.nvim_get_current_buf()
	local current_line = vim.api.nvim_win_get_cursor(0)[1]
	local buf_breakpoints = breakpoints[current_buf] or {}

	-- Find next breakpoint in current buffer
	local next_bp = nil
	for _, bp in ipairs(buf_breakpoints) do
		if bp.line > current_line then
			next_bp = bp.line
			break
		end
	end

	-- If found, jump to it
	if next_bp then
		vim.api.nvim_win_set_cursor(0, { next_bp, 0 })
		vim.notify("Jumped to breakpoint at line " .. next_bp, vim.log.levels.INFO)
	else
		-- Try to find first breakpoint in any other buffer
		for buf, bps in pairs(breakpoints) do
			if buf ~= current_buf and #bps > 0 then
				vim.api.nvim_set_current_buf(buf)
				vim.api.nvim_win_set_cursor(0, { bps[1].line, 0 })
				vim.notify("Jumped to breakpoint in another buffer at line " .. bps[1].line, vim.log.levels.INFO)
				return
			end
		end
		vim.notify("No next breakpoint found", vim.log.levels.WARN)
	end
end, { desc = "Jump to next breakpoint" })

vim.keymap.set("n", "[b", function()
	local breakpoints = require("dap.breakpoints").get()
	if not breakpoints or vim.tbl_isempty(breakpoints) then
		vim.notify("No breakpoints set", vim.log.levels.WARN)
		return
	end

	local current_buf = vim.api.nvim_get_current_buf()
	local current_line = vim.api.nvim_win_get_cursor(0)[1]
	local buf_breakpoints = breakpoints[current_buf] or {}

	-- Find previous breakpoint in current buffer (search backwards)
	local prev_bp = nil
	for i = #buf_breakpoints, 1, -1 do
		if buf_breakpoints[i].line < current_line then
			prev_bp = buf_breakpoints[i].line
			break
		end
	end

	-- If found, jump to it
	if prev_bp then
		vim.api.nvim_win_set_cursor(0, { prev_bp, 0 })
		vim.notify("Jumped to breakpoint at line " .. prev_bp, vim.log.levels.INFO)
	else
		vim.notify("No previous breakpoint found", vim.log.levels.WARN)
	end
end, { desc = "Jump to previous breakpoint" })
vim.keymap.set("n", "<leader>o", "o<Esc>k")
vim.keymap.set("n", "<leader>x", vim.cmd.bdelete)
vim.keymap.set("v", "<leader>y", '"+yy', { noremap = true })
vim.keymap.set("n", "<leader> dy", "3<cmd>lua vim.diagnostic.open_float()<CR>", { noremap = true })
vim.keymap.set("n", "<leader>fi", "/", { noremap = true })
-- Map leader + a to select entire document
vim.keymap.set("n", "<leader>a", "ggVG", { noremap = true })
--vim.o.timeoutlen=200
vim.opt.foldmethod = "syntax"
vim.opt.foldlevelstart = 99
-- Toggle Tailwind class concealment
vim.keymap.set("n", "<leader>tc", "<cmd>TailwindConcealToggle<CR>", { desc = "Toggle Tailwind conceal" })

-- Sort Tailwind classes in the current buffer
vim.keymap.set("n", "<leader>ts", "<cmd>TailwindSort<CR>", { desc = "Sort Tailwind classes" })

-- Sort Tailwind classes in visual selection
vim.keymap.set("v", "<leader>ts", "<cmd>TailwindSortSelection<CR>", { desc = "Sort Tailwind classes in selection" })
-- Lazy requirement
require("base.plugins.lazy")
