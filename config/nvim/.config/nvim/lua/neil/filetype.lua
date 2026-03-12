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
