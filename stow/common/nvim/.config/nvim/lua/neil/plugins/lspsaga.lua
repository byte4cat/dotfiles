return {
	{
		"nvimdev/lspsaga.nvim",
		dependencies = { "nvim-lspconfig" },
		config = function()
			require("lspsaga").setup({
				ui = {
					code_action = "💡",
				},
				lightbulb = {
					enabled = true,
					sign = false,
					sign_priority = 40,
					virtual_text = true,
				},
				outline = {
					win_width = 40,
					auto_preview = false,
				},
			})
		end,
	},
}
