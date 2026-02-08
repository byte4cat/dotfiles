-- lua/neil/plugins/formatting.lua
return {
	{
		"stevearc/conform.nvim",
		config = function()
			-- add mason bin path for nvim
			vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH

			require("conform").setup({
				formatters_by_ft = {
					cpp = { "clang-format" },
					c = { "clang-format" },
					lua = { "stylua" },
					-- Go
					go = { "goimports", "gofumpt" },
					-- Python
					python = { "isort", "black", "autoflake" },
					-- Web (TS, JS, JSX, Vue, CSS, HTML)
					javascript = { "prettierd" },
					typescript = { "prettierd" },
					javascriptreact = { "prettierd" },
					typescriptreact = { "prettierd" },
					vue = { "prettierd" },
					css = { "prettierd" },
					html = { "prettierd" },
					-- Others
					rust = { "rustfmt" },
					proto = { "buf" },
					templ = { "templ" },
					sh = { "shfmt" },
					sql = { "sql_formatter" },
					-- Normal
					["*"] = { "codespell" },
					["_"] = { "trim_whitespace" },
				},

				format_on_save = {
					lsp_fallback = true,
					async = false,
					timeout_ms = 1000,
				},

				log_level = vim.log.levels.ERROR,
				notify_on_error = true,
			})
		end,
	},
}
