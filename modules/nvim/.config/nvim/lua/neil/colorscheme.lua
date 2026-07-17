local M = {}

-- 狀態變數
local is_starting = true
local is_manual_select = false
local theme_cache = vim.fn.stdpath("state") .. "/last_theme"
local default_theme = "nightfox"
local matugen_path = os.getenv("HOME") .. "/.config/nvim/lua/neil/colors/matugen.lua"

-- 解除開機狀態鎖定 (延遲 2 秒後，允許接收 matugen 的變色訊號)
vim.defer_fn(function()
	is_starting = false
end, 2000)

-- 讀取主題
function M.get_last_theme()
	local f = io.open(theme_cache, "r")
	if not f then
		return default_theme
	end
	local content = f:read("*all")
	f:close()
	local theme = content:match("([%w%-]+)")
	return (theme and theme ~= "") and theme or default_theme
end

-- 寫入主題
local function save_theme(theme)
	local f = io.open(theme_cache, "w")
	if f then
		f:write(theme)
		f:close()
	end
end

-- 透明化
local function apply_transparency()
	local groups = { "Normal", "NormalFloat", "NormalNC", "SignColumn", "EndOfBuffer" }
	for _, group in ipairs(groups) do
		vim.api.nvim_set_hl(0, group, { bg = "none", ctermbg = "none" })
	end
end

-- 設定主題
function M.set_theme(name)
	if not name or name == "" then
		return
	end
	vim.g.neil_theme_locked = true

	if name == "matugen" then
		if vim.fn.filereadable(matugen_path) == 1 then
			dofile(matugen_path)
			vim.g.colors_name = "matugen"
			vim.cmd("let g:colors_name = 'matugen'")
		end
	else
		pcall(vim.cmd.colorscheme, name)
	end

	apply_transparency()
	vim.cmd("redraw")
	vim.defer_fn(function()
		vim.g.neil_theme_locked = false
	end, 500)
end

-- 初始化監聽
vim.schedule(function()
	-- 啟動自動化監聽
	vim.api.nvim_create_autocmd("Signal", {
		pattern = "SIGUSR1",
		callback = function()
			if vim.g.colors_name ~= "matugen" or is_starting or is_manual_select then
				return
			end
			M.set_theme("matugen")
			save_theme("matugen")
		end,
	})

	local w = vim.loop.new_fs_event()
	if vim.fn.filereadable(matugen_path) == 1 then
		w:start(
			matugen_path,
			{},
			vim.schedule_wrap(function(err, fname, events)
				if err or is_starting or is_manual_select or vim.g.colors_name ~= "matugen" then
					return
				end
				M.set_theme("matugen")
			end)
		)
	end
end)

-- 鍵位綁定
vim.keymap.set("n", "<leader>th", function()
	local builtin = require("telescope.builtin")
	local actions = require("telescope.actions")
	local action_state = require("telescope.actions.state")

	builtin.colorscheme({
		enable_preview = true,
		previewer = true,
		theme = "dropdown",
		attach_mappings = function(prompt_bufnr, map)
			-- 當選擇改變時，觸發預覽或切換
			map({ "i", "n" }, "<Down>", function()
				actions.move_selection_next(prompt_bufnr)
				local name = action_state.get_selected_entry().value
				M.set_theme(name)
			end)
			map({ "i", "n" }, "<Up>", function()
				actions.move_selection_prev(prompt_bufnr)
				local name = action_state.get_selected_entry().value
				M.set_theme(name)
			end)

			actions.select_default:replace(function()
				local selection = action_state.get_selected_entry()
				actions.close(prompt_bufnr)
				if selection then
					is_manual_select = true
					M.set_theme(selection.value)
					save_theme(selection.value)
					vim.defer_fn(function()
						is_manual_select = false
					end, 2000)
				end
			end)
			return true
		end,
	})
end)

return M
