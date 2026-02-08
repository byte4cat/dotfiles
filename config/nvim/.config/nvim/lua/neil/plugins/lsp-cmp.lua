return {
	"hrsh7th/nvim-cmp",
	event = "InsertEnter",
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"onsails/lspkind.nvim", -- 圖標
		"roobert/tailwindcss-colorizer-cmp.nvim", -- Tailwind 顏色
	},
	config = function()
		local cmp = require("cmp")
		local tailwindcss_colorizer = require("tailwindcss-colorizer-cmp")
		require("tailwindcss-colorizer-cmp").setup({
			color_square_width = 2,
		})

		local lspkind = require("lspkind")
		local cmp_select = { behavior = cmp.SelectBehavior.Select }

		cmp.setup({
			window = {
				completion = {
					border = { "", "─", "╮", "│", "╯", "─", "╰", "│" },
					winhighlight = "Normal:Pmenu,FloatBorder:CmpFloatBorder,CursorLine:PmenuSel,Search:None",
				},
				documentation = {
					border = { "╭", "─", "", "│", "╯", "─", "╰", "│" },
					winhighlight = "Normal:NormalFloat,FloatBorder:DocFloatBorder",
				},
			},
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},
			mapping = cmp.mapping.preset.insert({
				["<C-k>"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-j>"] = cmp.mapping.select_next_item(cmp_select),

				-- 你原本的 S-Tab 邏輯：有選單就確認（或選下一個），沒選單就 fallback
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
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
			}, {
				{ name = "buffer" },
				{ name = "path" },
			}),
			formatting = {
				expandable_indicators = { "", "", "" },
				format = lspkind.cmp_format({
					mode = "symbol_text", -- 同時顯示圖標與文字
					maxwidth = 50,
					ellipsis_char = "...",
					before = tailwindcss_colorizer.formatter,
				}),
			},
		})
	end,
}
