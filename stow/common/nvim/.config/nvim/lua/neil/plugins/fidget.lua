return {
	{
		"j-hui/fidget.nvim",
		config = function()
			-- vim.api.nvim_set_hl(0, "FidgetTransparent", { fg = "#a89984", bg = "NONE" }) -- or use NormalFloat
			vim.api.nvim_set_hl(0, "FidgetTransparent", { bg = "NONE" })

			require("fidget").setup({
				notification = {
					window = {
						normal_hl = "FidgetTransparent",
						winblend = 0,
						border = "none",
					},
				},
				progress = {
					display = {
						progress_icon = { "meter" }, -- 進度條的圖示
						icon_style = "Special", -- 或 "Question"、"WarningMsg" 看你喜歡什麼顏色
					},
				},
				integration = {
					["nvim-tree"] = {
						enable = true, -- Integrate with nvim-tree/nvim-tree.lua (if installed)
					},
				},
			})
		end,
	},
}
