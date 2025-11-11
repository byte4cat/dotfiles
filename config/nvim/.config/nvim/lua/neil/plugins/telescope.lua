return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = {
		require("telescope").setup({
			defaults = {
				vimgrep_arguments = {
					"rg",
					-- "--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					"--hidden",
				},

				prompt_prefix = "🔭 ",
				selection_caret = " ",
				sorting_strategy = "descending",
				layout_strategy = "horizontal",
				layout_config = {
					horizontal = {
						mirror = false,
						preview_width = 0.5,
					},
					vertical = {
						mirror = false,
					},
				},
				-- Telescope (find_files)
				file_ignore_patterns = {
					".DS_Store",
					"mocks/.*",
					"dist/.*",
					"%.git/.*",
					"%.vim/.*",
					"%.vscode/.*",
					"%.idea/.*",
					"node_modules/.*",
					"%.history/.*",
					"package-lock.json",
					"yarn.lock",
					".nuxt/.*", -- nuxt
					".output/.*", -- nuxt3
					"%.pb%.go", -- pb go
				},
				mappings = {
					i = {
						["<C-k>"] = "move_selection_previous",
						["<C-j>"] = "move_selection_next",
						["<C-s>"] = "select_vertical",
						["<C-a>"] = "select_tab",
					},
					n = {
						["<C-k>"] = "move_selection_previous",
						["<C-j>"] = "move_selection_next",
						["<C-s>"] = "select_vertical",
						["<C-a>"] = "select_tab",
					},
				},
			},
			pickers = {
				find_files = {
					find_command = { "rg", "--files", "--no-ignore", "--hidden", "--glob", "!**/.git/*" },
				},
			},
		}),
	},
}
