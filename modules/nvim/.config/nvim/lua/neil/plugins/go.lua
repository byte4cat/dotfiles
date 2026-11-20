return {
	"ray-x/go.nvim",
	dependencies = {
		"ray-x/guihua.lua", -- recommended if need floating window support
		"neovim/nvim-lspconfig",
		"nvim-treesitter/nvim-treesitter",
	},
	ft = { "go", "gomod" },
	config = function()
		-- gopls is started by plugins/lsp.lua; lsp_cfg = true here would start a second one.
		require("go").setup({})
	end,
}
