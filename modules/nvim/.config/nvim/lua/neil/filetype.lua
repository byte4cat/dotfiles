vim.filetype.add({
	extension = {
		templ = "templ",
		gowork = "gowork",
		gotmpl = "gotmpl",
		astro = "astro",
		ignore = "ignore",
		tsx = "typescriptreact",
		jsx = "javascriptreact",
		["terraform-vars"] = "terraform-vars",
	},
	pattern = {
		["docker-compose%.ya?ml"] = "yaml.docker-compose",
		["gitlab-ci%.ya?ml"] = "yaml.gitlab",
		["helm%-values%.ya?ml"] = "yaml.helm-values",
		["compose.yaml"] = "yaml.docker-compose",
		["compose.yml"] = "yaml.docker-compose",
	},
})

vim.filetype.add({
	extension = {
		hurl = "hurl",
	},
})

vim.api.nvim_create_autocmd("FileType", {
	pattern = "markdown",
	callback = function()
		vim.opt_local.wrap = true
		vim.opt_local.linebreak = true
		vim.opt_local.breakindent = true
	end,
})

vim.filetype.add({
	extension = {
		hbs = "handlebars",
	},
})

-- auto remove alt filename suffix and let tresitter and lsp cook
vim.filetype.add({
	pattern = {
		[".*##.*"] = function(path, buf)
			-- example：monitor.lua##hostname.9950x -> monitor.lua
			-- example：.zshrc##os.Linux           -> .zshrc
			local clean_path = path:gsub("##.*$", "")
			return vim.filetype.match({ filename = clean_path })
		end,
	},
})
