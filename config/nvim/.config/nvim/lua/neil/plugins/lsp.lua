return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			"hrsh7th/nvim-cmp",
			"hrsh7th/cmp-nvim-lsp",
		},
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH

			local lspconfig = require("lspconfig")
			local mason = require("mason")
			local mason_lspconfig = require("mason-lspconfig")
			local mason_tool_installer = require("mason-tool-installer")
			local cmp_lsp = require("cmp_nvim_lsp")
			local keymap = require("neil.lsp-key-mapping")

			local capabilities = vim.lsp.protocol.make_client_capabilities()
			capabilities = cmp_lsp.default_capabilities(capabilities)

			-- LSP Servers 列表
			local servers = {
				"lua_ls",
				"gopls",
				"rust_analyzer",
				"templ",
				"clangd",
				"cmake",
				"ts_ls",
				"eslint",
				"html",
				"cssls",
				"tailwindcss",
				"pyright",
				"jsonls",
				"dockerls",
				"docker_compose_language_service",
				"markdown_oxide",
				"sqls",
				"taplo",
				"yamlls",
				"zls",
				-- "volar",
			}

			-- Formatters & Linters
			local formatters_and_linters = {
				"stylua",
				"goimports",
				"gofumpt",
				"golines",
				"golangci-lint",
				"rustfmt",
				"black",
				"isort",
				"autoflake",
				"prettierd",
				"clang-format",
				"shfmt",
				"codespell",
				"sql-formatter",
			}

			-- 建立共用的 on_attach
			local on_attach = function(client, bufnr)
				keymap.setup(bufnr)
			end

			vim.filetype.add({
				extension = {
					templ = "templ",
					astro = "astro",
					ignore = "ignore",
					gotmpl = "gotmpl",
					gowork = "gowork",
					tsx = "typescriptreact",
					jsx = "javascriptreact",
				},
				filename = {
					["docker-compose.yaml"] = "yaml.docker-compose",
					["docker-compose.yml"] = "yaml.docker-compose",
					["compose.yaml"] = "yaml.docker-compose",
					["compose.yml"] = "yaml.docker-compose",
				},
			})

			for _, server in ipairs(servers) do
				vim.lsp.config(server, {
					capabilities = capabilities,
					on_attach = on_attach,
				})
			end

			-- vim.lsp.config("volar", {
			-- 	capabilities = capabilities,
			-- 	on_attach = on_attach,
			-- 	init_options = {
			-- 		vue = { hybridMode = true },
			-- 	},
			-- })

			vim.lsp.config("tailwindcss", {
				filetypes = { "html", "css", "javascriptreact", "typescriptreact", "vue", "svelte" },
			})

			mason.setup()

			mason_lspconfig.setup({
				ensure_installed = servers,
				automatic_installation = true,
			})

			mason_tool_installer.setup({
				ensure_installed = formatters_and_linters,
				run_on_start = true,
			})
		end,
	},
}
