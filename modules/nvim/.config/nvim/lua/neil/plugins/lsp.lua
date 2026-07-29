return {
	{
		"neovim/nvim-lspconfig",
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"WhoIsSethDaniel/mason-tool-installer.nvim",
			{ "saghen/blink.cmp", version = "1.*" },
		},
		event = { "BufReadPre", "BufNewFile" },
		config = function()
			local mason = require("mason")
			mason.setup()

			vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH

			local mason_lspconfig = require("mason-lspconfig")
			local mason_tool_installer = require("mason-tool-installer")
			local keymap = require("neil.lsp-keybindings")

			local capabilities = require("blink.cmp").get_lsp_capabilities()
			capabilities.general = capabilities.general or {}
			capabilities.general.positionEncodings = { "utf-8", "utf-16" }

			vim.treesitter.language.register("html", "handlebars")

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
				"emmet_language_server",
				"html",
				"ember",
				"cssls",
				"tailwindcss",
				"pyright",
				"jsonls",
				"dockerls",
				"docker_compose_language_service",
				"sqls",
				"taplo",
				-- "typos_lsp",
				"yamlls",
				"zls",
				"qmlls",
			}

			-- Formatters & Linters
			local formatters_and_linters = {
				"stylua",
				"goimports",
				"gofumpt",
				"golines",
				"golangci-lint",
				"black",
				"isort",
				"autoflake",
				"prettierd",
				"clang-format",
				"shfmt",
				"sql-formatter",
			}

			local on_attach = function(client, bufnr)
				keymap.setup(bufnr)
			end

			local function apply_lsp_config(name, user_config)
				local final_config = vim.tbl_deep_extend("force", {
					capabilities = capabilities,
					on_attach = on_attach,
				}, user_config or {})

				vim.lsp.config(name, final_config)
				if not vim.lsp.is_enabled({ name = name }) then
					vim.lsp.enable(name)
				end
			end

			local skip_servers = {
				"rust_analyzer",
				"emmet_language_server",
				"tailwindcss",
				"vue_ls",
				"ts_ls",
				"clangd",
				-- "typos_lsp",
				"html",
				"ember",
			}

			for _, server in ipairs(servers) do
				local skip = false
				for _, s in ipairs(skip_servers) do
					if s == server then
						skip = true
						break
					end
				end
				if not skip then
					apply_lsp_config(server, {})
				end
			end

			-- =======================
			-- Custom Configurations
			-- =======================

			apply_lsp_config("html", {
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "html", "handlebars" },
				init_options = {
					configurationSection = { "html", "css", "javascript" },
					embeddedLanguages = { css = true, javascript = true },
					autoClosingTags = false,
				},
			})

			apply_lsp_config("ember", {
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "handlebars" },
			})

			-- Tailwind CSS
			apply_lsp_config("tailwindcss", {
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "html", "css", "javascriptreact", "typescriptreact", "vue", "svelte", "handlebars" },
			})

			-- Emmet
			apply_lsp_config("emmet_language_server", {
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = {
					"css",
					"sass",
					"scss",
					"less",
					"templ",
					"astro",
					"svelte",
					"eruby",
					"html",
					"javascriptreact",
					"typescriptreact",
					"handlebars",
				},
			})

			-- TypeScript
			apply_lsp_config("ts_ls", {
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
			})

			-- Rust Analyzer
			apply_lsp_config("rust_analyzer", {
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					["rust-analyzer"] = {
						procMacro = { enable = true },
						cargo = { allFeatures = true },
						check = { command = "clippy" },
					},
				},
			})

			-- ESLint
			apply_lsp_config("eslint", {
				capabilities = capabilities,
				settings = {
					workingDirectory = { mode = "auto" },
					nodePath = vim.fn.getcwd() .. "/node_modules",
				},
				on_attach = function(client, bufnr)
					on_attach(client, bufnr)
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = bufnr,
						command = "EslintFixAll",
					})
				end,
			})

			-- Clangd
			apply_lsp_config("clangd", {
				capabilities = capabilities,
				on_attach = on_attach,
			})

			-- Typos
			-- apply_lsp_config("typos_lsp", {
			-- 	capabilities = capabilities,
			-- 	on_attach = on_attach,
			-- })

			-- Mason
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
