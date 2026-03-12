local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local f = ls.function_node

return {
	-- 經典的 if err != nil (ie)
	-- 輸入 ie -> Enter 展開 -> 輸入變數名 (預設 err) -> Tab 跳到 return
	s("ie", {
		t("if "),
		i(1, "err"),
		t(" != nil {"),
		t({ "", "\treturn " }),
		i(0),
		t({ "", "}" }),
	}),

	-- HTTP Handler 模板 (hh)
	-- 適合標準庫或 Gin 類似的架構
	s("hh", {
		t("func "),
		i(1, "HandlerName"),
		t("(w http.ResponseWriter, r *http.Request) {"),
		t({ "", "\tctx := r.Context()", "\t" }),
		i(0),
		t({ "", "}" }),
	}),

	-- JSON Tag 快速生成 (jt)
	-- 在結構體欄位後面輸入 jt -> Enter -> 自動生成 `json:"fieldName"`
	s("jt", {
		t('`json:"'),
		i(1, "field_name"),
		t('"`'),
	}),

	-- 打印調試 (pf)
	-- 快速生成 fmt.Printf 並把光標定位在變數位置
	s("pf", {
		t('fmt.Printf("DEBUG: '),
		i(1, "value"),
		t(': %v\\n", '),
		f(function(args)
			return args[1][1]
		end, { 1 }),
		t(")"),
	}),

	s("sld", {
		t('slog.Debug("'),
		i(1, "message"),
		t('", "'),
		f(function(args)
			return args[1][1]
		end, { 1 }),
		t('", '),
		i(2, "val"),
		t(")"),
	}),

	-- Context 帶超時 (ctxc)
	-- 後端調用資料庫或外部 API 必備
	s("ctxc", {
		t({ "ctx, cancel := context.WithTimeout(context.Background(), " }),
		i(1, "5"),
		t("*time.Second)"),
		t({ "", "defer cancel()", "" }),
		i(0),
	}),
}
