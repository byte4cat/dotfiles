return {
	{
		"nvim-treesitter/nvim-treesitter",
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
		config = function()
			---@diagnostic disable-next-line: missing-fields
			local status_ok, configs = pcall(require, "nvim-treesitter.configs")
			if not status_ok then
				return
			end
			configs.setup({
				-- A list of parser names, or "all"
				ensure_installed = {
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
				},

				-- Install parsers synchronously (only applied to `ensure_installed`)
				sync_install = true,

				-- Automatically install missing parsers when entering buffer
				-- Recommendation: set to false if you don't have `tree-sitter` CLI installed locally
				auto_install = true,

				highlight = {
					-- `false` will disable the whole extension
					enable = true,

					-- Setting this to true will run `:h syntax` and tree-sitter at the same time.
					-- Set this to `true` if you depend on 'syntax' being enabled (like for indentation).
					-- Using this option may slow down your editor, and you may see some duplicate highlights.
					-- Instead of true it can also be a list of languages
					additional_vim_regex_highlighting = false,
				},

				indent = { enable = true },
			})
		end,
	},
}
