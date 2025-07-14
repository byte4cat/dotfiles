return {
	{
		"ray-x/go.nvim",
		dependencies = {
			"ray-x/guihua.lua", -- recommended if need floating window support
			"neovim/nvim-lspconfig",
			"nvim-treesitter/nvim-treesitter",
		},
		config = function()
			require("go").setup({
				remap_commands = { GoDoc = false }, -- 禁用 :GoDoc 命令
			})
		end,
	},
}
