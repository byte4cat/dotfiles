local M = {}

function M.setup(bufnr)
	local opts = { buffer = bufnr, remap = false }

	-- vim.keymap.set("n", "gD", vim.lsp.buf.declaration, opts)
	vim.keymap.set("n", "gd", function()
		vim.lsp.buf.definition()
		vim.cmd("normal! zz")
	end, opts)
	vim.keymap.set("n", "gi", vim.lsp.buf.implementation, opts)
	-- vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
	vim.keymap.set("i", "<C-s>", vim.lsp.buf.signature_help, opts)
	vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
	-- vim.keymap.set("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", opts)

	vim.keymap.set("n", "<C-d>", "<cmd>Lspsaga peek_definition<CR>", opts)
	vim.keymap.set("n", "<leader>l", "<cmd>Lspsaga outline<CR>", opts)
	vim.keymap.set("n", "gr", "<cmd>Lspsaga finder<CR>", opts)
	vim.keymap.set("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", opts)
	vim.keymap.set("n", "<leader>ci", "<cmd>Lspsaga incoming_calls<CR>", opts)
	vim.keymap.set("n", "<leader>co", "<cmd>Lspsaga outcoming_calls<CR>", opts)
	vim.keymap.set("n", "<leader>cr", "<cmd>Lspsaga rename<CR>", opts)
end

return M
