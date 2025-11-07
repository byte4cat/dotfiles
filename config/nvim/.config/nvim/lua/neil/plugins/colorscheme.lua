local themes = {
	{
		"rebelot/kanagawa.nvim",
		name = "kanagawa",
		priority = 1000,
		config = function()
			require("kanagawa").setup({
				transparent = true,
				background = {
					dark = "wave",
					light = "lotus",
				},
				colors = {
					theme = { all = { ui = { bg_gutter = "none" } } },
				},
			})
			-- vim.cmd("colorscheme kanagawa")
		end,
	},

	{
		"olimorris/onedarkpro.nvim",
		priority = 1000,
		config = function()
			require("onedarkpro").setup({
				colors = {},
				options = {
					transparency = true,
					terminal_colors = true,
					cursorline = true,
				},
			})
			-- vim.cmd("colorscheme onedark")
		end,
	},

	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 1000,
		config = function()
			require("catppuccin").setup({
				flavour = "mocha",
				transparent_background = true,
			})
			-- vim.cmd("colorscheme catppuccin")
		end,
	},

	{
		"sainnhe/gruvbox-material",
		name = "gruvbox-material",
		priority = 1000,
		config = function()
			vim.g.gruvbox_material_transparent_background = 1
			-- vim.cmd("colorscheme gruvbox-material")
		end,
	},

	{
		"shaunsingh/nord.nvim",
		name = "nord",
		priority = 1000,
		config = function()
			vim.g.nord_disable_background = true
			-- vim.cmd("colorscheme nord")
		end,
	},

	{
		"folke/tokyonight.nvim",
		name = "tokyonight",
		priority = 1000,
		config = function()
			require("tokyonight").setup({
				transparent = true,
				styles = {
					sidebars = "transparent",
					floats = "transparent",
				},
			})
			-- vim.cmd("colorscheme tokyonight")
		end,
	},

	{
		"sainnhe/everforest",
		name = "everforest",
		priority = 1000,
		config = function()
			vim.g.everforest_transparent_background = 1
			-- vim.cmd("colorscheme everforest")
		end,
	},

	{
		"savq/melange-nvim",
		name = "melange",
		priority = 1000,
		config = function()
			-- vim.cmd("colorscheme melange")
		end,
	},

	{
		"nyoom-engineering/oxocarbon.nvim",
		name = "oxocarbon",
		priority = 1000,
		config = function()
			vim.opt.background = "dark"
			-- vim.cmd("colorscheme oxocarbon")
		end,
	},

	{
		"EdenEast/nightfox.nvim",
		name = "nightfox",
		priority = 1000,
		config = function()
			require("nightfox").setup({
				options = {
					transparent = true,
					styles = {
						comments = "italic",
						keywords = "bold",
						types = "italic,bold",
					},
				},
			})
			vim.cmd("colorscheme nightfox")
		end,
	},

	{
		"rose-pine/neovim",
		name = "rose-pine",
		priority = 1000,
		config = function()
			require("rose-pine").setup({
				variant = "moon", -- "main", "moon", "dawn"
				styles = {
					transparency = true,
				},
			})
			-- vim.cmd("colorscheme rose-pine")
		end,
	},
}

return {
	themes,
}
