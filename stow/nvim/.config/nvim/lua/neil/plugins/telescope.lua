return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	dependencies = { "nvim-lua/plenary.nvim" },
	config = {
		require("telescope").setup({
			defaults = {
				vimgrep_arguments = {
					"rg",
					"--color=never",
					"--no-heading",
					"--with-filename",
					"--line-number",
					"--column",
					"--smart-case",
					"--glob",
					"!**/node_modules/*", -- Ignore node_modules
					"--glob",
					"!package-lock.json", -- Ignore package-lock.json
					"--glob",
					"!yarn-lock", -- Ignore package-lock.json
					"--glob",
					"!go.sum", -- Ignore package-lock.json
					"--glob",
					"!**/dist/*", -- Ignore dist directory
					"--glob",
					"!.DS_Store", -- Ignore DS_Store files
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
				file_ignore_patterns = {
					".DS_Store",
					"mocks/.*",
					"dist/.*",
					"%.git/.*",
					"%.vim/.*",
					"node_modules/.*",
					"%.idea/.*",
					"%.vscode/.*",
					"%.history/.*",
					"package-lock.json",
					"yarn.lock",
					".nuxt/.*",
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
					find_command = { "rg", "--files", "--hidden", "--glob", "!.git" },
				},
			},
		}),
	},
}
