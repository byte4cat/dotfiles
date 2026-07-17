return {
	{
		"nvim-treesitter/nvim-treesitter",
		lazy = false,
		build = ":TSUpdate",
		config = function()
			local ts = require("nvim-treesitter")

			ts.setup({
				install_dir = vim.fn.stdpath("data") .. "/site",
			})

			ts.install({
				"bash",
				"c",
				"cpp",
				"css",
				"csv",
				"c_sharp",
				"diff",
				"dockerfile",
				"gitignore",
				"go",
				"gomod",
				"gosum",
				"html",
				"glimmer",
				"hurl",
				"java",
				"javascript",
				"jq",
				"json",
				"lua",
				"make",
				"markdown",
				"markdown_inline",
				"latex",
				"proto",
				"python",
				"query",
				"regex",
				"rust",
				"sql",
				"ssh_config",
				"scss",
				"tmux",
				"toml",
				"typescript",
				"vim",
				"vimdoc",
				"vue",
				"xml",
				"yaml",
			})
		end,
	},
}
