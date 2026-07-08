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
		"L3MON4D3/LuaSnip",
	},
	config = function()
		local ls = require("luasnip")
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
				-- 上下移動選單
				["<C-k>"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-j>"] = cmp.mapping.select_next_item(cmp_select),

				-- 只有 Enter 負責確認補全
				["<CR>"] = cmp.mapping.confirm({
					behavior = cmp.ConfirmBehavior.Replace,
					select = true,
				}),

				-- Alt-Tab 專門用於：展開 Snippet 或 跳到下一個輸入塊
				["<A-Tab>"] = cmp.mapping(function(fallback)
					if ls.expand_or_locally_jumpable() then
						-- 如果選單開著，先把它關掉，避免干擾跳轉
						if cmp.visible() then
							cmp.close()
						end
						ls.expand_or_jump()
					else
						fallback() -- 正常的 Tab 功能（縮排）
					end
				end, { "i", "s" }),

				-- Shift-Tab 專門用於：跳回上一個輸入塊
				["<A-S-Tab>"] = cmp.mapping(function(fallback)
					if ls.locally_jumpable(-1) then
						if cmp.visible() then
							cmp.close()
						end
						ls.jump(-1)
					else
						fallback()
					end
				end, { "i", "s" }),

				["<C-Space>"] = cmp.mapping.complete(),
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
