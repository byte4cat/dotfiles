return {
	"windwp/nvim-ts-autotag",
	event = { "BufReadPre", "BufNewFile" },
	opts = {
		opts = {
			-- Defaults
			enable_close = true, -- Auto-close tags (e.g. <div> -> <div></div>)
			enable_rename = true, -- Auto-rename paired tags (e.g. edit <div> to <span>)
			enable_close_on_slash = false, -- Auto-close on trailing </
		},
		-- Filetypes to enable
		filetypes = { "html", "javascript", "typescript", "javascriptreact", "typescriptreact", "svelte", "vue", "xml" },
	},
}
