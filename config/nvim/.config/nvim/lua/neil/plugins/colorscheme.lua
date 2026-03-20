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

local function set_theme(name)
	if name and name ~= "" then
		local ok, err = pcall(vim.cmd.colorscheme, name)
		if not ok then
			vim.notify("Theme switch error: " .. name, vim.log.levels.DEBUG)
		end
		-- apply_transparency 會由 ColorScheme Autocmd 自動觸發
	end
end

local function save_theme(theme)
	local f = io.open(theme_cache, "w")
	if f then
		f:write(theme)
		f:close()
	end
end

local function apply_transparency()
	pcall(function()
		local groups = { "Normal", "NormalFloat", "NormalNC", "SignColumn", "EndOfBuffer" }
		for _, group in ipairs(groups) do
			vim.api.nvim_set_hl(0, group, { bg = "none", ctermbg = "none" })
		end
	end)
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
	set_theme(last)
	apply_transparency()

	vim.api.nvim_create_autocmd("ColorScheme", {
		pattern = "*",
		callback = function()
			apply_transparency()
		end,
	})

	local w = vim.loop.new_fs_event()
	w:start(
		theme_cache,
		{},
		vim.schedule_wrap(function(err, fname, events)
			if err then
				return
			end
			local new_theme = get_last_theme()
			-- 只有當檔案內容真的變了，且跟目前主題不同時才切換，避免無窮迴圈
			if new_theme ~= vim.g.colors_name then
				set_theme(new_theme)
			end
		end)
	)

	-- 設定快捷鍵
	vim.keymap.set("n", "<leader>th", function()
		local actions = require("telescope.actions")
		local action_state = require("telescope.actions.state")
		local builtin = require("telescope.builtin")

		builtin.colorscheme({
			enable_preview = true,
			-- 在預覽切換時暫時關閉所有 Autocmd
			attach_mappings = function(prompt_bufnr, map)
				-- 這裡攔截 Telescope 的預覽行為
				-- Telescope 預覽主題時會呼叫 colorscheme，我們讓它在 eventignore 下執行
				vim.api.nvim_create_autocmd("ColorSchemePre", {
					buffer = prompt_bufnr,
					callback = function()
						vim.opt.eventignore:append("ColorScheme")
					end,
				})

				-- 改完後恢復
				vim.api.nvim_create_autocmd("ColorScheme", {
					buffer = prompt_bufnr,
					callback = function()
						vim.opt.eventignore:remove("ColorScheme")
					end,
				})

				actions.select_default:replace(function()
					local selection = action_state.get_selected_entry()
					actions.close(prompt_bufnr)
					if selection then
						local name = selection.value
						set_theme(name)
						save_theme(name)
					end
				end)
				return true
			end,
		})
	end, { desc = "Theme Picker (Silenced Preview)" })
end)

return themes
