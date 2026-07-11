return {
	{
		"nvimdev/lspsaga.nvim",
		dependencies = {
			"nvim-treesitter/nvim-treesitter", -- optional
			"nvim-tree/nvim-web-devicons", -- optional
		},
		event = "LspAttach",
		config = function()
			require("lspsaga").setup({
				ui = {
					code_action = "💡",
				},
				lightbulb = {
					enabled = false,
					sign = false,
					sign_priority = 40,
					virtual_text = true,
				},
				outline = {
					win_width = 40,
					auto_preview = false,
				},
				symbol_in_winbar = {
					enabled = true,
				},
			})
		end,
	},
}
