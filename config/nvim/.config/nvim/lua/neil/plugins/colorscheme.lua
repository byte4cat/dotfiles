local theme_cache = vim.fn.stdpath("state") .. "/last_theme"

local function get_last_theme()
	local f = io.open(theme_cache, "r")
	if f then
		local theme = f:read("*all"):gsub("%s+", "")
		f:close()
		return (theme ~= "" and theme) and theme or "nightfox"
	end
	return "nightfox"
end

local function save_theme(theme)
	local f = io.open(theme_cache, "w")
	if f then
		f:write(theme)
		f:close()
	end
end

local function apply_transparency()
	local groups = { "Normal", "NormalFloat", "NormalNC", "SignColumn", "EndOfBuffer" }
	for _, group in ipairs(groups) do
		vim.api.nvim_set_hl(0, group, { bg = "none", ctermbg = "none" })
	end
end

-- 主題清單
local themes = {
	{ "rebelot/kanagawa.nvim", name = "kanagawa", lazy = true, opts = { transparent = true } },
	{ "catppuccin/nvim", name = "catppuccin", lazy = true, opts = { transparent_background = true } },
	{ "folke/tokyonight.nvim", name = "tokyonight", lazy = true, opts = { transparent = true } },
	{ "rose-pine/neovim", name = "rose-pine", lazy = true, opts = { styles = { transparency = true } } },
	{ "olimorris/onedarkpro.nvim", name = "onedarkpro", lazy = true, opts = { options = { transparency = true } } },
	{
		"sainnhe/gruvbox-material",
		name = "gruvbox-material",
		lazy = true,
		config = function()
			vim.g.gruvbox_material_transparent_background = 1
		end,
	},
	{
		"sainnhe/everforest",
		name = "everforest",
		lazy = true,
		config = function()
			vim.g.everforest_transparent_background = 1
		end,
	},
	{ "EdenEast/nightfox.nvim", name = "nightfox", lazy = true, opts = { options = { transparent = true } } },
	{
		"shaunsingh/nord.nvim",
		name = "nord",
		lazy = true,
		config = function()
			vim.g.nord_disable_background = true
		end,
	},
	{ "savq/melange-nvim", name = "melange", lazy = true },
	{ "nyoom-engineering/oxocarbon.nvim", name = "oxocarbon", lazy = true },
	{ "scottmckendry/cyberdream.nvim", name = "cyberdream", lazy = true, opts = { transparent = true } },
	{ "AlexvZyl/nordic.nvim", name = "nordic", lazy = true, opts = { transparent_bg = true } },
	{ "eldritch-theme/eldritch.nvim", name = "eldritch", lazy = true, opts = { transparent = true } },
}

-- 啟動與快捷鍵邏輯
vim.schedule(function()
	-- 啟動時讀取
	local last = get_last_theme()
	pcall(function()
		vim.cmd.colorscheme(last)
		apply_transparency()
	end)

	-- 設定快捷鍵
	vim.keymap.set("n", "<leader>th", function()
		local actions = require("telescope.actions")
		local action_state = require("telescope.actions.state")

		require("telescope.builtin").colorscheme({
			enable_preview = true,
			attach_mappings = function(prompt_bufnr, map)
				-- 監聽按下 Enter 的動作
				actions.select_default:replace(function()
					local selection = action_state.get_selected_entry()
					actions.close(prompt_bufnr)
					if selection then
						local name = selection.value
						vim.cmd.colorscheme(name)
						save_theme(name) -- 成功記憶的核心
						vim.defer_fn(apply_transparency, 10)
					end
				end)
				return true
			end,
		})
	end, { desc = "Theme Picker (Save on Enter)" })
end)

return themes
