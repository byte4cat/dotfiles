return {
	"saghen/blink.cmp",
	-- optional: provides snippets for the snippet source
	-- dependencies = { "rafamadriz/friendly-snippets" },
	dependencies = {
		"L3MON4D3/LuaSnip",
		"nvim-tree/nvim-web-devicons",
		"onsails/lspkind.nvim",
		"uga-rosa/cmp-dictionary",
		"saghen/blink.compat",
	},
	version = "1.*",

	---@module 'blink.cmp'
	---@type blink.cmp.Config
	opts = {
		-- See :h blink-cmp-config-keymap for defining your own keymap
		-- keymap = { preset = "default" },
		keymap = {
			preset = "none",
			["<C-k>"] = { "select_prev", "fallback" },
			["<C-j>"] = { "select_next", "fallback" },
			["<CR>"] = { "accept", "fallback" },
			["<C-Space>"] = { "show", "show_documentation", "hide_documentation" },
			["<C-e>"] = { "hide" },
		},

		appearance = {
			-- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
			-- Adjusts spacing to ensure icons are aligned
			nerd_font_variant = "mono",
		},

		signature = {
			enabled = true,
			window = {
				border = "rounded",
				winblend = 0,
			},
		},

		snippets = {
			preset = "luasnip",
		},

		-- (Default) Only show the documentation popup when manually triggered
		completion = {
			trigger = {
				show_on_keyword = true,
				show_on_trigger_character = true,
				-- 當游標緊鄰這些字元時，不要自動跳出補全選單
				show_on_blocked_trigger_characters = { ">", "<", "/", " ", "\n", "\t" },
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 200,
				window = {
					border = "rounded",
				},
			},
			ghost_text = { enabled = false },
			menu = {
				border = "rounded", -- "single", "double", "rounded", "solid", "shadow"
				winblend = 0, -- no transparent
				draw = {
					components = {
						kind_icon = {
							text = function(ctx)
								local icon = ctx.kind_icon
								if vim.tbl_contains({ "Path" }, ctx.source_name) then
									local dev_icon, _ = require("nvim-web-devicons").get_icon(ctx.label)
									if dev_icon then
										icon = dev_icon
									end
								else
									icon = require("lspkind").symbol_map[ctx.kind] or ""
								end

								return icon .. ctx.icon_gap
							end,

							-- Optionally, use the highlight groups from nvim-web-devicons
							-- You can also add the same function for `kind.highlight` if you want to
							-- keep the highlight groups in sync with the icons.
							highlight = function(ctx)
								local hl = ctx.kind_hl
								if vim.tbl_contains({ "Path" }, ctx.source_name) then
									local dev_icon, dev_hl = require("nvim-web-devicons").get_icon(ctx.label)
									if dev_icon then
										hl = dev_hl
									end
								end
								return hl
							end,
						},
					},
				},
			},
		},

		-- Default list of enabled providers defined so that you can extend it
		-- elsewhere in your config, without redefining it, due to `opts_extend`
		sources = {
			default = { "lsp", "path", "snippets", "buffer" },
			providers = {
				lsp = {
					min_keyword_length = 1, -- Only suggest after typing at least 1 character
				},
				buffer = {
					min_keyword_length = 2, -- Require 2 characters for buffer completions
				},
				snippets = {
					min_keyword_length = 1, -- Only suggest snippets after typing at least 1 character
				},
			},
		},

		-- (Default) Rust fuzzy matcher for typo resistance and significantly better performance
		-- You may use a lua implementation instead by using `implementation = "lua"` or fallback to the lua implementation,
		-- when the Rust fuzzy matcher is not available, by using `implementation = "prefer_rust"`
		--
		-- See the fuzzy documentation for more information
		fuzzy = { implementation = "prefer_rust_with_warning" },
	},
	opts_extend = { "sources.default" },
	config = function(_, opts)
		require("cmp_dictionary").setup({
			paths = { "/usr/share/dict/words" },
			exact_length = 2,
		})

		opts.sources = {
			default = { "lsp", "path", "snippets", "buffer", "dictionary" },
			providers = {
				dictionary = {
					name = "dictionary",
					module = "blink.compat.source",
					score_offset = -10, -- 權重稍微調低，不干擾程式碼
					min_keyword_length = 2, -- 打 2 個字母才觸發
					enabled = function()
						-- 僅在 markdown 和 vimwiki 下啟用
						return vim.bo.filetype == "markdown" or vim.bo.filetype == "vimwiki"
					end,
				},
			},
		}

		require("blink-cmp").setup(opts)
	end,
}
