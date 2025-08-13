return {
	{
		"williamboman/mason.nvim",
		dependencies = {
			"williamboman/mason-lspconfig.nvim",
			"neovim/nvim-lspconfig",
			"hrsh7th/cmp-nvim-lsp",
		},
		config = function()
			require("mason").setup()
			require("mason-lspconfig").setup({
				automatic_installation = true,
				ensure_installed = {
					"clangd",
					"cmake",
					"cssls",
					"dockerls",
					"docker_compose_language_service",
					"eslint",
					"gopls",
					"html",
					"htmx",
					"jsonls",
					"lua_ls",
					"markdown_oxide",
					"nginx_language_server",
					"pyright",
					"rust_analyzer",
					"sqls",
					"tailwindcss",
					"taplo",
					"templ",
					"terraformls",
					"vimls",
					"vuels",
					"yamlls",
					"zls",
				},
			})
		end,
	},
}
