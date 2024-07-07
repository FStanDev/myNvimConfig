--Basic settings

vim.g.mapleader = " "

vim.wo.relativenumber = true
vim.wo.number = true
--Mappings
vim.keymap.set("n", "<leader>e", vim.cmd.NvimTreeFocus)
vim.keymap.set("n", "<C-n>", vim.cmd.NvimTreeToggle)
vim.keymap.set("n", "<leader>1", vim.cmd.bfirst)
vim.keymap.set("n", "<leader>0", vim.cmd.blast)
vim.keymap.set("n", "<Tab>", vim.cmd.bnext)
vim.keymap.set("n", "<S-Tab>", vim.cmd.bprevious)
vim.keymap.set("n", "<leader>b", vim.cmd.DapToggleBreakpoint)
vim.keymap.set("n", "<leader>ds", vim.cmd.DapSidebar)
vim.keymap.set("n", "<leader>dp", function()
	require("dap-python").test_method()
end)
vim.keymap.set("n", "<leader>o", "o<Esc>k")
vim.keymap.set("n", "<leader>x", vim.cmd.bdelete)
--vim.o.timeoutlen=200
-- Lazy requirement
require("base.plugins.lazy")
