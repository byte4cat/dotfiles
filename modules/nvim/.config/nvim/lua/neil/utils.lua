-- Highlight on yank
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.hl.on_yank()
	end,
	group = highlight_group,
	pattern = "*",
})

-- Automatically open the quickfix window after search commands
vim.api.nvim_create_autocmd("QuickFixCmdPost", {
	pattern = "[^l]*",
	command = "cwindow",
})

-- vim.api.nvim_create_autocmd({ "BufReadPre", "BufNewFile" }, {
-- 	callback = function()
-- 		-- 檢查檔案大小（例如大於 1MB 就視為大檔案）
-- 		local max_filesize = 1024 * 1024 -- 1MB
-- 		local filename = vim.api.nvim_buf_get_name(0)
-- 		if filename ~= "" then
-- 			local ok, stats = pcall(vim.loop.fs_stat, filename)
-- 			if ok and stats and stats.size > max_filesize then
-- 				-- 關閉 Treesitter 語法高亮
-- 				pcall(vim.treesitter.stop)
-- 				-- 改回傳統的 regex 高亮（速度較快）
-- 				vim.bo.syntax = "on"
-- 				-- 關閉行號（選用，有時能提升一點捲動速度）
-- 				-- vim.wo.number = false
-- 				vim.wo.relativenumber = false
-- 				-- 關閉 LSP 自動附加
-- 				vim.diagnostic.enable(false)
-- 				-- 關閉 render-markdown 渲染
-- 				pcall(function()
-- 					require("render-markdown").disable()
-- 				end)
-- 				vim.notify(
-- 					"Large file detected: Treesitter and LSP have been automatically disabled for smooth performance.",
-- 					vim.log.levels.WARN
-- 				)
-- 			end
-- 		end
-- 	end,
-- })
