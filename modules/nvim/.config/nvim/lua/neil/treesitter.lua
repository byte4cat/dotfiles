vim.treesitter.language.register("html", "handlebars")

vim.api.nvim_create_autocmd("FileType", {
	pattern = "*",
	callback = function()
		local ft = vim.bo.filetype
		if ft and ft ~= "" and vim.treesitter.query.get(ft, "highlights") then
			vim.treesitter.start()
		end

		vim.wo.foldmethod = "expr"
		vim.wo.foldexpr = "v:lua.vim.treesitter.foldexpr()"
	end,
})
