return {
	{
		"stevearc/oil.nvim",
		cmd = "Oil",
		keys = {
			{ "-", "<CMD>Oil<CR>", desc = "Open parent directory" }, -- 按 - 觸發
		},
		dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
		config = function()
			require("oil").setup({
				columns = {
					"icon",
					-- "permissions",
					"size",
					-- "mtime",
				},
				view_options = {
					show_hidden = true,
				},
			})
		end,
	},
}
