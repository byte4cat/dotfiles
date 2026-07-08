-- return {
-- 	"norcalli/nvim-colorizer.lua",
-- 	config = function()
-- 		require("colorizer").setup({
-- 			"*",
-- 		})
-- 		-- default settings
-- 		-- RGB = true, -- #RGB hex codes
-- 		-- RRGGBB = true, -- #RRGGBB hex codes
-- 		-- names = true, -- "Name" codes like Blue
-- 		-- RRGGBBAA = false, -- #RRGGBBAA hex codes
-- 		-- rgb_fn = false, -- CSS rgb() and rgba() functions
-- 		-- hsl_fn = false, -- CSS hsl() and hsla() functions
-- 		-- css = false, -- Enable all CSS features: rgb_fn, hsl_fn, names, RGB, RRGGBB
-- 		-- css_fn = false, -- Enable all CSS *functions*: rgb_fn, hsl_fn
-- 		-- -- Available modes: foreground, background
-- 		-- mode = "background", -- Set the display mode.)
-- 	end,
-- }

-- latest version of nvim-colorizer.lua is on May 10, 2024, and it using deprecated api, so I switch to catgoose/nvim-colorizer.lua which is a fork of norcalli's and is actively maintained.
return {
	"catgoose/nvim-colorizer.lua",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		filetypes = { "*" },
		user_commands = true,
		options = {
			parsers = {
				css = true,
				tailwind = { enable = true, lsp = true },
			},
			display = {
				mode = "background",
			},
		},
	},
}
