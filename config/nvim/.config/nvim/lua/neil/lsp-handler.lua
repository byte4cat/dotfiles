-- local lsp = require("lspconfig")
local cmp_lsp = require("cmp_nvim_lsp")

local capabilities =
	vim.tbl_deep_extend("force", {}, vim.lsp.protocol.make_client_capabilities(), cmp_lsp.default_capabilities())

-- Setup LSP handlers
vim.filetype.add({ extension = { templ = "templ" } })

vim.lsp.config("rust_analyzer", {
	-- Server-specific settings. See `:help lsp-quickstart`
	capabilities = capabilities,
	settings = {
		-- ["rust-analyzer"] = {},
	},
})

-- lsp.gopls.setup({
-- 	cmd = { "gopls", "-remote=auto" },
-- 	capabilities = capabilities,
-- 	settings = {
-- 		gopls = {
-- 			analyses = { unusedparams = true },
-- 			staticcheck = true,
-- 			completeUnimported = true,
-- 		},
-- 	},
-- })

-- lsp.lua_ls.setup({
-- 	settings = {
-- 		lua = {
-- 			diagnostics = {
-- 				globals = { "vim" },
-- 			},
-- 		},
-- 	},
-- })
--
-- lsp.templ.setup({})
--
-- lsp.tailwindcss.setup({})
--
-- lsp.clangd.setup({
-- 	cmd = {
-- 		"clangd",
-- 		-- This is a workaround to the limitations of copilot language server
-- 		-- which only works with utf-16
-- 		-- https://www.reddit.com/r/neovim/comments/12qbcua/multiple_different_client_offset_encodings/
-- 		"--offset-encoding=utf-16",
-- 	},
-- 	filetypes = { "c", "cpp" },
-- 	sigle_file_support = true,
-- })
--
-- lsp.htmx.setup({})
--
-- lsp.html.setup({})
--
-- lsp.jsonls.setup({})
--
-- lsp.cssls.setup({})
--
-- lsp.dockerls.setup({})
--
-- lsp.bashls.setup({})
--
-- lsp.vimls.setup({})
--
-- lsp.yamlls.setup({})
--
-- lsp.eslint.setup({})
--
-- lsp.pyright.setup({})

-- see: https://github.com/williamboman/mason-lspconfig.nvim/issues/371#issuecomment-2188015156
-- and: https://github.com/neovim/nvim-lspconfig/blob/master/doc/configs.md#vue_ls
-- lsp.vuels.setup({
-- 	-- add filetypes for typescript, javascript and vue
-- 	filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
-- 	init_options = {
-- 		vue = {
-- 			hybridMode = false,
-- 		},
-- 	},
-- })
-- you must remove "ts_ls" config
-- vim.lsp.config['ts_ls'] = {}

-- see: https://github.com/williamboman/mason-lspconfig.nvim/issues/371#issuecomment-2188015156
-- 	local mason_packages = vim.fn.stdpath("data") .. "/mason/packages"
-- 	local vue_ls_path = mason_packages .. "/vue-language-server/node_modules/@vue/language-server"
-- 	lsp.tsserver.setup({
-- 		-- NOTE: To enable Hybrid Mode, change hybrideMode to true above and uncomment the following filetypes block.
-- 		-- WARN: THIS MAY CAUSE HIGHLIGHTING ISSUES WITHIN THE TEMPLATE SCOPE WHEN TSSERVER ATTACHES TO VUE FILES

-- 		-- filetypes = { "typescript", "javascript", "javascriptreact", "typescriptreact", "vue" },
-- 		init_options = {
-- 			plugins = {
-- 				{
-- 					name = "@vue/typescript-plugin",
-- 					location = vue_ls_path,
-- 					languages = { "vue" },
-- 				},
-- 			},
-- 		},
-- 	})
--
-- lsp.omnisharp.setup({})
