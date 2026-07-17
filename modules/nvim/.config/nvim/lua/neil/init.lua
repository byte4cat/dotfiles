require("neil.sync_clipboard")
require("neil.vim")
require("neil.filetype")
require("neil.treesitter")
require("neil.lazy")
vim.api.nvim_create_autocmd("User", {
	pattern = "LazyVimStarted",
	once = true,
	callback = function()
		local colors = require("neil.colorscheme")
		local last = colors.get_last_theme()
		colors.set_theme(last)
	end,
})
require("neil.utils")
require("neil.keybindings")
require("neil.lsp-keybindings")
