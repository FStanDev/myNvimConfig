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
