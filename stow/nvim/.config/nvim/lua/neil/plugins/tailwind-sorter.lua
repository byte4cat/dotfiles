return {
	{
		"laytan/tailwind-sorter.nvim",
		dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-lua/plenary.nvim" },
		build = "cd formatter && npm ci && npm run build",
		config = function()
			require("tailwind-sorter").setup({
				on_save_enabled = false, -- If `true`, automatically enables on save sorting.
				on_save_pattern = {
					--	"*.vue", -- currently not supports vue files, see https://github.com/laytan/tailwind-sorter.nvim/issues/101
					-- "*.html", -- disabled because of golang html template support is missing
					"*.js",
					"*.jsx",
					"*.tsx",
					"*.twig",
					"*.hbs",
					"*.php",
					"*.heex",
					"*.astro",
				}, -- The file patterns to watch and sort.
				node_path = "node",
			})
		end,
	},
}
