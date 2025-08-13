return {
	{
		"stevearc/conform.nvim",
		config = function()
			require("conform").setup({
				-- Map of filetype to formatters
				formatters_by_ft = {
					cpp = { "clang-format" },
					c = { "clang-format" },
					lua = { "stylua" },
					-- Conform will run multiple formatters sequentially
					go = { "goimports", "gofmt" },
					-- Use a sub-list to run only the first available formatter
					javascript = { "prettierd", "prettier" },
					typescript = { "prettierd", "prettier" },
					proto = { "buf" },
					-- You can use a function here to determine the formatters dynamically
					python = { "autoflake" },
					-- vue = { "prettierd", "prettier" },
					templ = { "templ" },
					sh = { "shfmt" },
					sql = { "sql_formatter" },
					css = { "prettierd", "prettier" },
					html = { "prettierd", "prettier" },
					rust = { "rustfmt" },

					-- Use the "*" filetype to run formatters on all filetypes.
					["*"] = { "codespell" },
					-- Use the "_" filetype to run formatters on filetypes that don't
					-- have other formatters configured.
					["_"] = { "trim_whitespace" },
				},
				-- If this is set, Conform will run the formatter on save.
				-- It will pass the table to conform.format().
				-- This can also be a function that returns the table.
				format_on_save = {
					-- I recommend these options. See :help conform.format for details.
					lsp_fallback = true,
					timeout_ms = 1000,
				},
				-- If this is set, Conform will run the formatter asynchronously after save.
				-- It will pass the table to conform.format().
				-- This can also be a function that returns the table.
				format_after_save = {
					lsp_fallback = true,
				},
				-- Set the log level. Use `:ConformInfo` to see the location of the log file.
				log_level = vim.log.levels.TRACE,
				-- Conform will notify you when a formatter errors
				notify_on_error = true,
			})

			-- Format on save
			vim.api.nvim_create_autocmd("BufWritePre", {
				pattern = "*",
				callback = function(args)
					require("conform").format({ bufnr = args.buf })
				end,
			})
		end,
	},
}
