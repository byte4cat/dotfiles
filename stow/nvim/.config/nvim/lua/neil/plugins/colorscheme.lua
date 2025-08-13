-- return {
-- 	{
-- 		"rebelot/kanagawa.nvim",
-- 		name = "kanagawa",
-- 		priority = 1000,
-- 		config = function()
-- 			require("kanagawa").setup({
-- 				transparent = true, -- Enable transparency
-- 				background = { -- Set background styles
-- 					dark = "wave", -- Options: "wave", "dragon", "lotus"
-- 					light = "lotus",
-- 				},
-- 				colors = {
-- 					theme = { all = { ui = { bg_gutter = "none" } } },
-- 				},
-- 			})
-- 			vim.cmd("colorscheme kanagawa")
-- 		end,
-- 	},
-- }

-- return {
-- 	{
-- 		"olimorris/onedarkpro.nvim",
-- 		priority = 1000, -- 確保主題優先載入
-- 		config = function()
-- 			require("onedarkpro").setup({
-- 				colors = {}, -- 你可以在這裡自訂顏色
-- 				options = {
-- 					transparency = true, -- 設定背景透明
-- 					terminal_colors = true, -- 啟用終端機顏色
-- 					cursorline = true, -- 高亮當前行
-- 				},
-- 			})
-- 			vim.cmd("colorscheme onedark") -- 設定主題
-- 		end,
-- 	},
-- }

-- return {
-- 	{
-- 		"catppuccin/nvim",
-- 		name = "catppuccin",
-- 		priority = 1000,
-- 		config = function()
-- 			require("catppuccin").setup({
-- 				flavour = "mocha",
-- 				transparent_background = true, -- Enable transparency
-- 			})
-- 			vim.cmd("colorscheme catppuccin")
-- 		end,
-- 	},
-- }

return {
	{
		"sainnhe/gruvbox-material",
		name = "gruvbox-material",
		priority = 1000,
		config = function()
			vim.g.gruvbox_material_transparent_background = 1
			vim.cmd("colorscheme gruvbox-material")
		end,
	},
}

-- bad
-- return {
-- 	{
-- 		"shaunsingh/nord.nvim",
-- 		name = "nord",
-- 		priority = 1000,
-- 		config = function()
-- 			vim.g.nord_disable_background = true
-- 			vim.cmd("colorscheme nord")
-- 		end,
-- 	},
-- }

-- return {
-- 	{
-- 		"folke/tokyonight.nvim",
-- 		name = "tokyonight",
-- 		priority = 1000,
-- 		config = function()
-- 			require("tokyonight").setup({
-- 				transparent = true, -- Enable transparency
-- 				styles = {
-- 					sidebars = "transparent",
-- 					floats = "transparent",
-- 				},
-- 			})
-- 			vim.cmd("colorscheme tokyonight")
-- 		end,
-- 	},
-- }

-- return {
-- 	{
-- 		"sainnhe/everforest",
-- 		name = "everforest",
-- 		priority = 1000,
-- 		config = function()
-- 			vim.g.everforest_transparent_background = 1
-- 			vim.cmd("colorscheme everforest")
-- 		end,
-- 	},
-- }
