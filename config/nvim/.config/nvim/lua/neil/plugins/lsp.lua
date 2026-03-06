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

			local function apply_lsp_config(name, user_config)
				local final_config = vim.tbl_deep_extend("force", {
					capabilities = capabilities,
					on_attach = on_attach,
				}, user_config or {})

				-- 自動過濾該 Server 不被 Neovim 識別的 filetypes
				local ok, lsp_config = pcall(require, "lspconfig.configs." .. name)
				if ok and lsp_config.default_config.filetypes then
					local filtered_ft = {}
					for _, ft in ipairs(lsp_config.default_config.filetypes) do
						if vim.fn.getcompletion(ft, "filetype")[1] ~= "" then
							table.insert(filtered_ft, ft)
						end
					end
					-- 如果使用者沒手動指定 filetypes，才用過濾後的
					final_config.filetypes = user_config.filetypes or filtered_ft
				end

				vim.lsp.config(name, final_config)
				vim.lsp.enable(name)
			end

			local base_config = {
				capabilities = capabilities,
				on_attach = on_attach,
			}

			local skip_servers = { "rust_analyzer", "tailwindcss" }

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

			apply_lsp_config("rust_analyzer", {
				capabilities = capabilities,
				on_attach = on_attach,
				settings = {
					["rust-analyzer"] = {
						procMacro = { enable = true },
						checkOnSave = true,
						cargo = { allFeatures = true },
					},
				},
			})

			apply_lsp_config("tailwindcss", {
				capabilities = capabilities,
				on_attach = on_attach,
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
