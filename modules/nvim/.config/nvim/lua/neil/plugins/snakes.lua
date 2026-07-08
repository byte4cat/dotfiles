return {
	"folke/snacks.nvim",
	priority = 1000,
	lazy = false,
	opts = {
		-- replace telescope
		picker = {
			sources = {
				files = {
					-- 顯示隱藏檔案
					hidden = true,
					-- 包含未被 git 追蹤的檔案
					untracked = true,
					-- 跟隨符號連結
					follow = true,
					-- 排除圖片
					exclude = {
						"**/*.jpg",
						"**/*.jpeg",
						"**/*.png",
						"**/*.webp",
						"**/*.gif",
					},
				},
			},
			prompt = "🔭 ",
			layout = {
				preset = function()
					return vim.o.columns >= 120 and "default" or "vertical"
				end,
			},
		},

		-- (replace nvim-notify)
		notifier = { enabled = true, timeout = 1500 },

		scroll = { enabled = true },

		indent = {
			enabled = true,
			scope = { enabled = true }, -- 高亮當前作用域的線
		},

		-- focus
		zen = { enabled = true },
		dim = { enabled = true },

		-- open git repo in browser
		gitbrowse = { enabled = true },

		-- cmd input
		input = { enabled = true },

		-- rename file
		rename = { enabled = true },

		statuscolumn = { enabled = true },

		image = { enabled = false },
	},
	keys = {
		-- Zen Mode & Dim
		{
			"<leader>zz",
			function()
				Snacks.zen()
			end,
			desc = "Toggle Zen Mode",
		},
		{
			"<leader>zd",
			function()
				Snacks.dim()
			end,
			desc = "Toggle Dim Background",
		},
		-- Git Browse
		{
			"<leader>gB",
			function()
				Snacks.gitbrowse()
			end,
			desc = "Open in Browser",
		},
		-- Rename
		{
			"<leader>rn",
			function()
				Snacks.rename.rename_file()
			end,
			desc = "Rename File",
		},
		-- Notification History
		{
			"<leader>nh",
			function()
				Snacks.notifier.show_history()
			end,
			desc = "Notification History",
		},
		-- Picker
		{
			"<leader>pf",
			function()
				Snacks.picker.files()
			end,
			desc = "Find Files (Snacks)",
		},
		-- {
		-- 	"<leader>ps",
		-- 	function()
		-- 		Snacks.picker.grep()
		-- 	end,
		-- 	desc = "Grep (Snacks)",
		-- },
		{
			"<leader>ff",
			function()
				Snacks.picker.buffers()
			end,
			desc = "Buffers (Snacks)",
		},
		{
			"<leader>pm",
			function()
				Snacks.picker.man()
			end,
			desc = "Search Man Page",
		},

		{
			"<leader>ph",
			function()
				Snacks.picker.help()
			end,
			desc = "Help Tags (Snacks)",
		},
		{
			"<leader>pg",
			function()
				Snacks.picker.git_status()
			end,
			desc = "Git Status (Snacks)",
		},
		{
			"<leader>pc",
			function()
				Snacks.picker.git_log_file()
			end,
			desc = "Git Buffer Commits (Snacks)",
		},
		{
			"<leader>pl",
			function()
				Snacks.picker.git_log()
			end,
			desc = "Git Log",
		},
	},
	config = function(_, opts)
		-- only enabled image in markdown file
		vim.api.nvim_create_autocmd("FileType", {
			pattern = "markdown",
			callback = function()
				opts.image.enabled = true
				require("snacks.image").setup(opts.image)
			end,
		})

		require("snacks").setup(opts)
	end,
}
