require("neil")

local function source_matugen()
	local matugen_path = os.getenv("HOME") .. "/.config/nvim/generated.lua"
	local file = io.open(matugen_path, "r")
	if file then
		dofile(matugen_path)
		file:close()
	end
end

-- 初次載入
source_matugen()

-- 註冊監聽 SIGUSR1 訊號
vim.api.nvim_create_autocmd("Signal", {
	pattern = "SIGUSR1",
	callback = function()
		source_matugen()
		-- 如果有其他需要手動觸發刷新的 plugin 可以在此加入
	end,
})
