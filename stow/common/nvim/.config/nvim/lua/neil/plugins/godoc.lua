return {
	{
		"fredrikaverpil/godoc.nvim",
		version = "*",
		dependencies = {
			-- { "folke/snacks.nvim" }, -- optional
			{ "nvim-telescope/telescope.nvim" },
		},
		build = "go install github.com/lotusirous/gostdsym/stdsym@latest", -- optional
		cmd = { "GoDoc" },
		opts = {
			picker = {
				type = "telescope",
			},
			window = {
				type = "vsplit", -- split | vsplit
			},
		},
	},
}
