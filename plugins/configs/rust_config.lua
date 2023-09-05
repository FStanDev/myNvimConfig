local options = require("rust-tools")

options.setup({
  server = {
    on_attach = function(_, bufnr)
      -- Hover actions
--      vim.keymap.set("n", "<C-space>", options.hover_actions.hover_actions, { buffer = bufnr })
      -- Code action groups
--      vim.keymap.set("n", "<Leader>a", options.code_action_group.code_action_group, { buffer = bufnr })
    end,
  },

  tools = {
    hover_actions = {
    auto_focus = true,
      },
  },
})
return options
