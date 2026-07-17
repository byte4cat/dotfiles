return {
	{ "rebelot/kanagawa.nvim", name = "kanagawa", lazy = true, opts = { transparent = true } },
	{ "catppuccin/nvim", name = "catppuccin", lazy = true, opts = { transparent_background = true } },
	{ "folke/tokyonight.nvim", name = "tokyonight", lazy = true, opts = { transparent = true } },
	{ "rose-pine/neovim", name = "rose-pine", lazy = true, opts = { styles = { transparency = true } } },
	{ "olimorris/onedarkpro.nvim", name = "onedarkpro", lazy = true, opts = { options = { transparency = true } } },
	{
		"sainnhe/gruvbox-material",
		name = "gruvbox-material",
		lazy = true,
		config = function()
			vim.g.gruvbox_material_transparent_background = 1
		end,
	},
	{
		"sainnhe/everforest",
		name = "everforest",
		lazy = true,
		config = function()
			vim.g.everforest_transparent_background = 1
		end,
	},
	{ "EdenEast/nightfox.nvim", name = "nightfox", lazy = true, opts = { options = { transparent = true } } },
	{
		"shaunsingh/nord.nvim",
		name = "nord",
		lazy = true,
		config = function()
			vim.g.nord_disable_background = true
		end,
	},
	{ "savq/melange-nvim", name = "melange", lazy = true },
	{ "nyoom-engineering/oxocarbon.nvim", name = "oxocarbon", lazy = true },
	{ "scottmckendry/cyberdream.nvim", name = "cyberdream", lazy = true, opts = { transparent = true } },
	{ "AlexvZyl/nordic.nvim", name = "nordic", lazy = true, opts = { transparent = { bg = false, float = false } } },
	{ "eldritch-theme/eldritch.nvim", name = "eldritch", lazy = true, opts = { transparent = true } },
	{ "projekt0n/github-nvim-theme", name = "github-theme", lazy = true, opts = { transparent = true } },
	{ "akinsho/horizon.nvim", name = "horizon", lazy = true },
	{ "phha/zenburn.nvim", name = "zenburn", lazy = true },
}
