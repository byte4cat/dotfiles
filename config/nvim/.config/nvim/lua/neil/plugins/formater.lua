return {
	{
		"stevearc/conform.nvim",
		config = function()
			-- add mason bin path for nvim
			vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH

			local conform = require("conform")

			conform.setup({
				formatters_by_ft = {
					cpp = { "clang-format" },
					c = { "clang-format" },
					-- cpp = { "clang_format_linux_kernel_style" },
					-- c = { "clang_format_linux_kernel_style" },
					cs = { "csharpier" },
					lua = { "stylua" },
					-- Go
					go = { "goimports", "gofumpt" },
					-- Python
					python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
					-- Web (TS, JS, JSX, Vue, CSS, HTML)
					javascript = { "prettierd" },
					typescript = { "prettierd" },
					javascriptreact = { "prettierd" },
					typescriptreact = { "prettierd" },
					vue = { "prettierd" },
					css = { "prettierd" },
					html = { "prettierd" },
					-- Others
					rust = { "trim_whitespace", "rustfmt" },
					-- proto = { "buf" },
					templ = { "templ" },
					sh = { "shfmt" },
					sql = { "sql_formatter" },
					-- Normal
					-- ["*"] = { "codespell" },
					-- ["_"] = { "trim_whitespace" },
					json = { "prettierd" },
				},

				format_on_save = {
					lsp_fallback = false,
					async = false,
					timeout_ms = 1000,
				},

				log_level = vim.log.levels.ERROR,
				notify_on_error = true,
			})

			conform.formatters.clang_format_linux_kernel_style = {
				command = "clang-format",
				prepend_args = function(self, bufnr)
					return {
						"--style={"
							.. "BasedOnStyle: LLVM, " -- 以 LLVM 為基底
							.. "UseTab: Always, " -- 內核強制使用 Tab
							.. "IndentWidth: 8, " -- 縮排 8 格
							.. "TabWidth: 8, " -- Tab 寬度 8
							.. "BreakBeforeBraces: Linux, " -- 大括號換行符合 Linux 標準
							.. "AllowShortIfStatementsOnASingleLine: false, "
							.. "IndentCaseLabels: false, "
							.. "AlignConsecutiveAssignments: true, " -- 你的等號對齊
							.. "AlignConsecutiveDeclarations: true, " -- 你的變數宣告對齊
							.. "AlignConsecutiveMacros: true," -- 【重點】宏對齊
							.. "AlignEscapedNewlines: Left ," -- 宏後面的反斜線靠左對齊
							.. "PointerAlignment: Right, " -- 指標 * 靠右 (int *ptr)
							.. "ColumnLimit: 80, ", -- 內核 80 字元限制
						"}",
					}
				end,
			}
		end,
	},
}
