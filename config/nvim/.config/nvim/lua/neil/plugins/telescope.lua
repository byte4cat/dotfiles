return {
	"nvim-telescope/telescope.nvim",
	tag = "0.1.8",
	dependencies = {
		"nvim-lua/plenary.nvim",
		"nvim-telescope/telescope-fzf-native.nvim",
		build = "make",
	},
	config = function()
		local telescope = require("telescope")
		telescope.setup({
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
					"--trim",
				},
				preview = {
					msg_bg_fillchar = " ",
					timeout = 200, -- 超過 200ms 就跳過該預覽
					filesize_limit = 0.5, -- 超過 0.5MB 的檔案不預覽，避免卡住
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
					"mocks/",
					"dist/",
					"%.git/",
					"%.vim/",
					"%.vscode/",
					"%.idea/",
					"node_modules/",
					"%.history/",
					"package-lock.json",
					"yarn.lock",
					".nuxt/", -- nuxt
					".output/", -- nuxt3
					"%.pb%.go", -- pb go
					"target/", -- rust output folder
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
					find_command = { "rg", "--files", "--hidden", "--glob", "!**/.git/*" },
				},
			},
			exextensions = {
				fzf = {
					fuzzy = true,
					override_generic_sorter = true,
					override_file_sorter = true,
					case_mode = "smart_case",
				},
			},
		})
		telescope.load_extension("fzf")
	end,
}
