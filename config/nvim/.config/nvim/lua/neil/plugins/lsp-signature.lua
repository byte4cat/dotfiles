return {
	"ray-x/lsp_signature.nvim",
	event = "InsertEnter",
	opts = {
		bind = true,
		handler_opts = {
			border = "rounded", -- 圓角邊框
		},

		-- 避免跟補全選單重疊的關鍵設定
		floating_window = true, -- 顯示浮動視窗
		floating_window_above_cur_line = true, -- 盡量顯示在游標上方，避免擋住下方的 cmp 選單
		zindex = 45, -- 設定比 cmp (預設 50) 稍微低一點，避免遮擋

		-- 提示視覺化
		hint_enable = true, -- 啟用行尾虛擬文字提醒
		hint_prefix = "💡 ", -- 提示圖示
		hi_parameter = "LspSignatureActiveParameter", -- 當前參數高亮

		-- 自動觸發與關閉
		always_trigger = false, -- 設為 false 避免在不必要的時刻亂跳
		auto_close_after = nil, -- 不會自動關閉，直到你輸入完括號
		extra_trigger_chars = { "(", "," }, -- 輸入左括號或逗號時觸發
	},
	config = function(_, opts)
		require("lsp_signature").setup(opts)
	end,
}
