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
			local keymap = require("neil.lsp-keybindings")

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
				"emmet_language_server",
				"html",
				"cssls",
				"tailwindcss",
				"pyright",
				"jsonls",
				"dockerls",
				"docker_compose_language_service",
				-- "markdown_oxide",
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
				-- "codespell",
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

			local skip_servers = {
				"rust_analyzer",
				"emmet_language_server",
				"tailwindcss",
				"vue_ls",
				"ts_ls",
				"clangd",
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

			-- apply_lsp_config("clangd", {
			-- 	capabilities = capabilities,
			-- 	on_attach = function(client, bufnr)
			-- 		-- 呼叫你原本通用的 on_attach (處理快速鍵等)
			-- 		if on_attach then
			-- 			on_attach(client, bufnr)
			-- 		end
			--
			-- 		-- 設定 C 檔案存檔時自動呼叫 LSP 格式化
			-- 		vim.api.nvim_create_autocmd("BufWritePre", {
			-- 			buffer = bufnr,
			-- 			callback = function()
			-- 				vim.lsp.buf.format({
			-- 					bufnr = bufnr,
			-- 					async = false, -- 同步執行確保存檔前完成
			-- 					-- 這裡強迫只用 clangd 格式化，避免跟 conform 撞車
			-- 					filter = function(c)
			-- 						return c.name == "clangd"
			-- 					end,
			-- 				})
			-- 			end,
			-- 		})
			-- 	end,
			-- 	-- 設定啟動參數
			-- 	cmd = {
			-- 		"clangd",
			-- 		"--background-index",
			-- 		"--clang-tidy",
			-- 		"--header-insertion=iwyu",
			-- 		"--completion-style=detailed",
			-- 		"--function-arg-placeholders",
			-- 		"--fallback-style=llvm", -- 如果找不到 .clang-format 才用這個
			-- 	},
			-- })

			apply_lsp_config("tailwindcss", {
				capabilities = capabilities,
				on_attach = on_attach,
				filetypes = { "html", "css", "javascriptreact", "typescriptreact", "vue", "svelte" },
			})

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
					"htmlangular",
					"htmldjango",
					"javascriptreact",
					"typescriptreact",
				},
			})

			-- apply_lsp_config("markdown_oxide", {
			-- 	filetypes = { "markdown" },
			-- })
			--
			-- apply_lsp_config("htmx", {
			-- 	filetypes = { "html", "templ", "handlebars" },
			-- })

			apply_lsp_config("vue_ls", {
				capabilities = capabilities,
				on_attach = on_attach,
				-- Hybrid Mode, just like Volar's Take Over Mode but without the need of Volar
			})

			local mason_path = vim.fn.stdpath("data") .. "/mason"

			local vue_plugin_rel_path = "/packages/vue-language-server/node_modules/@vue/typescript-plugin"
			local vue_ts_plugin_location = mason_path .. vue_plugin_rel_path

			local is_vue_project = function()
				local f = io.open(vim.fn.getcwd() .. "/package.json", "r")
				if f then
					local content = f:read("*all")
					f:close()
					return content:find("vue") ~= nil
				end
				return false
			end

			local ts_plugins = {}
			if is_vue_project() then
				table.insert(ts_plugins, {
					name = "@vue/typescript-plugin",
					location = vue_ts_plugin_location,
					languages = { "vue" },
				})
			end

			apply_lsp_config("ts_ls", {
				capabilities = capabilities,
				on_attach = on_attach,
				init_options = {
					plugins = ts_plugins,
				},
				filetypes = {
					"javascript",
					"javascriptreact",
					"javascript.jsx",
					"typescript",
					"typescriptreact",
					"typescript.tsx",
					"vue",
				},
			})

			apply_lsp_config("eslint", {
				capabilities = capabilities,
				settings = {
					workingDirectory = { mode = "auto" },
					nodePath = vim.fn.getcwd() .. "/node_modules",
				},
				on_attach = function(client, bufnr)
					on_attach(client, bufnr)
					-- ESLint 儲存時自動修復
					vim.api.nvim_create_autocmd("BufWritePre", {
						buffer = bufnr,
						command = "EslintFixAll",
					})
				end,
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
