local colors = {
	bg = "none",
	fg = "{{colors.on_surface.default.hex}}",
	primary = "{{colors.primary.default.hex}}",
	secondary = "{{colors.secondary.default.hex}}",
	tertiary = "{{colors.tertiary.default.hex}}",
	error = "{{colors.error.default.hex}}",
}

-- 核心 UI
vim.api.nvim_set_hl(0, "Normal", { bg = colors.bg, fg = colors.fg })
vim.api.nvim_set_hl(0, "NormalNC", { bg = colors.bg, fg = colors.fg })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = colors.bg, fg = colors.fg })
vim.api.nvim_set_hl(0, "SignColumn", { bg = colors.bg })

-- 語法高亮 (這些就是你需要補上的，讓程式碼變色的關鍵)
vim.api.nvim_set_hl(0, "Comment", { fg = colors.secondary, italic = true })
vim.api.nvim_set_hl(0, "String", { fg = colors.tertiary }) -- 字串顏色
vim.api.nvim_set_hl(0, "Character", { fg = colors.tertiary })
vim.api.nvim_set_hl(0, "Number", { fg = colors.primary })
vim.api.nvim_set_hl(0, "Boolean", { fg = colors.primary })
vim.api.nvim_set_hl(0, "Float", { fg = colors.primary })
vim.api.nvim_set_hl(0, "Function", { fg = colors.secondary, bold = true }) -- 函數名
vim.api.nvim_set_hl(0, "Identifier", { fg = colors.fg })
vim.api.nvim_set_hl(0, "Keyword", { fg = colors.primary, bold = true }) -- if, else, for
vim.api.nvim_set_hl(0, "Statement", { fg = colors.primary, bold = true })
vim.api.nvim_set_hl(0, "Type", { fg = colors.primary }) -- int, char, class
vim.api.nvim_set_hl(0, "PreProc", { fg = colors.tertiary }) -- import, #include
vim.api.nvim_set_hl(0, "Special", { fg = colors.tertiary })

-- 設置終端機顏色
vim.g.terminal_color_0 = "#1f1f25"
vim.g.terminal_color_1 = colors.error
vim.g.terminal_color_2 = colors.primary
vim.g.terminal_color_4 = colors.tertiary
