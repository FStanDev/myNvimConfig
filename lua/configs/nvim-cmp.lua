   local cmp = require("cmp")
   local luasnip = require("luasnip")
   require("luasnip.loaders.from_vscode").lazy_load()

   cmp.setup({
	completion = {
		completeopt= "menu,menuone,preview,noselect",
	},
	snippet = { -- configure how nvim-mp interacts with snippet engine
		expand = function (args)
			luasnip.lsp_expand (args.body)
		end,
   	},
	mapping = cmp.mapping.preset. insert({
		["<C-K>"]= cmp.mapping.select_prev_item(), --previous suggestion
		["<C-j>"]= cmp.mapping.select_next_item(), -- next suggestion
		["<C-b>"]= cmp.mapping.scroll_docs (-4),
		["<C-f>"]= cmp.mapping.scroll_docs (4),
		["<C-Space>"] = cmp.mapping. complete(), -- show completion suggestions
		["<C-e>"] = cmp.mapping.abort(), -- close completion window
		["<CR>"] = cmp.mapping.confirm({select = false }),
	}),
	sources = cmp.config.sources({
		{name = "luasnip"},
		{name = "buffer"},
		{name = "path"},
	}),

})
