return {
{
    'nvim-telescope/telescope.nvim', tag = '0.1.6',
    dependencies = { 'nvim-lua/plenary.nvim' },
    opts = function()
      return require "configs.telescope"
    end
    --function(_,opts)
--	    require("telescope").setup(opts)
  --  end
},
{
  "oxfist/night-owl.nvim",
  lazy = false, -- make sure we load this during startup if it is your main colorscheme
  priority = 1000, -- make sure to load this before all the other start plugins
  config = function()
    -- load the colorscheme here
    vim.cmd.colorscheme("night-owl")
  end,
},
{
    "williamboman/mason.nvim",
    cmd = { "Mason", "MasonInstall", "MasonInstallAll", "MasonUpdate","MasonUninstallAll" },
    opts = function()
      return require "configs.mason"
    end,
    config = function(_,opts)
	    require("mason").setup(opts)
	    vim.api.nvim_create_user_command("MasonInstallAll", function()
        if opts.ensure_installed and #opts.ensure_installed > 0 then
          vim.cmd("MasonInstall " .. table.concat(opts.ensure_installed, " "))
        end
      end, {})
    vim.g.mason_binaries_list = opts.ensure_installed
    end
},
{"williamboman/mason-lspconfig.nvim"},
{
    "neovim/nvim-lspconfig",
    dependencies={
   	 {"williamboman/mason.nvim"}, 
         {"williamboman/mason-lspconfig.nvim"},
    },
    config = function()
      require("configs.lspconfig")
    end,
},
{
  "nvim-tree/nvim-tree.lua",
  version = "*",
  lazy = false,
  dependencies = {
    "nvim-tree/nvim-web-devicons",
  },
  opts = function()
	return require "configs.nvimtree"
  end,
  config = function(_,opts)
    require("nvim-tree").setup(opts) 
  end,
}
}
