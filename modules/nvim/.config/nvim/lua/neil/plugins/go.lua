return {
	{
		"ray-x/go.nvim",
		dependencies = {
			"ray-x/guihua.lua", -- recommended if need floating window support
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
		},
		ft = { "go", "gomod" },
		config = function()
			require("go").setup({
				lsp_conf = true,
			})
		end,
	},
}
