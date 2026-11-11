vim.treesitter.language.register("html", "handlebars")
vim.treesitter.language.register("markdown", "vimwiki")

vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		local ft = vim.bo.filetype
		local lang = ft and ft ~= "" and vim.treesitter.language.get_lang(ft)
		if lang and vim.treesitter.query.get(lang, "highlights") then
			vim.treesitter.start()
		end

		vim.wo.foldmethod = "expr"
		vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
	end,
})
