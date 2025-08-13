return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"hrsh7th/cmp-nvim-lsp",
			"hrsh7th/cmp-buffer",
			"hrsh7th/cmp-path",
			"hrsh7th/cmp-cmdline",
			"hrsh7th/nvim-cmp",
			"saadparwaiz1/cmp_luasnip",
			"stevearc/conform.nvim",

			"L3MON4D3/LuaSnip",
			-- vscode like cmp autocompletion
			"onsails/lspkind-nvim",
			-- Tailwind CSS
			"roobert/tailwindcss-colorizer-cmp.nvim",
		},
		config = function()
			local cmp = require("cmp")
			local cmp_select = { behavior = cmp.SelectBehavior.Select }

			-- local types = require("luasnip.util.types")

			-- require("luasnip").setup({
			-- 	history = true,
			-- 	delete_check_events = "TextChanged",
			-- 	-- Display a cursor-like placeholder in unvisited nodes
			-- 	-- of the snippet.
			-- 	ext_opts = {
			-- 		[types.insertNode] = {
			-- 			unvisited = {
			-- 				virt_text = { { "|", "Conceal" } },
			-- 				virt_text_pos = "inline",
			-- 			},
			-- 		},
			-- 	},
			-- })

			require("luasnip.loaders.from_vscode").lazy_load()

			local tailwindcss_colorizer = require("tailwindcss-colorizer-cmp")
			local lspkind = require("lspkind")

			-- custom colors for cmp autocompletion and lsp documentation
			vim.cmd([[
                highlight CmpFloatBorder guibg=#1e1e1e guifg=#87ceeb
                highlight DocFloatBorder guibg=#1e1e1e guifg=#d89a1f
                highlight Pmenu guibg=#1e1e1e guifg=#cfcfcf
                highlight PmenuSel guibg=#555555 guifg=NONE
                highlight NormalFloat guibg=#1e1e1e guifg=#cfcfcf
            ]])

			cmp.setup({
				window = {
					completion = {
						-- border = "rounded",
						border = { "", "─", "╮", "│", "╯", "─", "╰", "│" },

						-- custom colors
						winhighlight = "Normal:Pmenu,FloatBorder:CmpFloatBorder,CursorLine:PmenuSel,Search:None",
					},
					documentation = {
						-- border = "rounded",
						border = { "╭", "─", "", "│", "╯", "─", "╰", "│" },
						-- custom colors
						winhighlight = "Normal:NormalFloat,FloatBorder:DocFloatBorder",
					},
				},
				snippet = {
					expand = function(args)
						require("luasnip").lsp_expand(args.body) -- For `luasnip` users.
					end,
				},
				mapping = cmp.mapping.preset.insert({
					["<C-k>"] = cmp.mapping.select_prev_item(cmp_select),
					["<C-j>"] = cmp.mapping.select_next_item(cmp_select),

					-- select on seleted item, if not seleted, check next one
					["<S-Tab>"] = cmp.mapping(function(fallback)
						if cmp.visible() then
							local selected_entry = cmp.get_selected_entry()
							if not selected_entry then
								cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
							else
								cmp.confirm({ select = true })
							end
						else
							fallback()
						end
					end, { "i", "s" }),

					["<Tab>"] = nil,
					["<C-Space>"] = cmp.mapping.complete(),
					["<CR>"] = cmp.mapping.confirm({
						behavior = cmp.ConfirmBehavior.Replace,
						select = true,
					}),
				}),
				sources = cmp.config.sources({
					{ name = "nvim_lsp" }, -- lsp
					{ name = "luasnip" }, -- luasnip
				}, {
					{ name = "buffer" }, -- buffer
					{ name = "path" }, -- path
				}),
				formatting = {
					expandable_indicators = {
						"",
						"",
						"",
					},
					-- vscode like icons for cmp autocompletion
					format = lspkind.cmp_format({
						maxwidth = 50,
						ellipsis_char = "...",
						-- prepend tailwindcss-colorizer
						-- add this line to apply color for tailwindcss cmp. if set :highlight PmenuSel will not working on current seleted item
						before = tailwindcss_colorizer.formatter,
					}),
				},
			})

			-- Global mappings
			vim.keymap.set("n", "[d", vim.diagnostic.goto_next, { noremap = true, silent = true })
			vim.keymap.set("n", "]d", vim.diagnostic.goto_prev, { noremap = true, silent = true })
			vim.keymap.set("n", "E", vim.diagnostic.open_float, { noremap = true, silent = true })

			-- Use LspAttach autocommand to only map the following keys
			-- after the language server attaches to the current buffer
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("UserLspConfig", {}),

				callback = function(ev)
					local opts = { buffer = ev.buffer, remap = false }

					vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
					vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
					vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
					-- vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
					vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help, opts)
					vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
					vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)

					vim.keymap.set("n", "<C-d>", "<cmd>Lspsaga peek_definition<CR>", opts)
					vim.keymap.set("n", "<leader>l", "<cmd>Lspsaga outline<CR>", opts)
					vim.keymap.set("n", "gr", "<cmd>Lspsaga finder<CR>", opts)
					vim.keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts)
					vim.keymap.set("n", "<leader>ci", "<cmd>Lspsaga incoming_calls<CR>", opts)
					vim.keymap.set("n", "<leader>co", "<cmd>Lspsaga outcoming_calls<CR>", opts)
					vim.keymap.set("n", "<F2>", "<cmd>Lspsaga rename<CR>", opts)
				end,
			})

			-- Setup LSP diagnostics
			vim.diagnostic.config({
				-- update_in_insert = true,
				float = {
					focusable = false,
					style = "minimal",
					border = "rounded",
					source = true,
					header = "",
					prefix = "",
				},
			})

			-- diagnostic icons
			vim.fn.sign_define("DiagnosticSignError", { text = "", texthl = "DiagnosticSignError" })
			vim.fn.sign_define("DiagnosticSignWarn", { text = "", texthl = "DiagnosticSignWarn" })
			vim.fn.sign_define("DiagnosticSignInfo", { text = "", texthl = "DiagnosticSignInfo" })
			vim.fn.sign_define("DiagnosticSignHint", { text = "", texthl = "DiagnosticSignHint" })

			-- setup LSP diagnostics border
			-- see: https://neovim.io/doc/user/lsp.html#lsp-handlers
			vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, {
				-- Use a sharp border with `FloatBorder` highlights
				border = "rounded",
				-- add the title in hover float window
				title = "Hover",
			})

			vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, {
				-- Use a sharp border with `FloatBorder` highlights
				border = "rounded",
				title = "Signature Help",
			})
		end,
	},
}
