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
