local ls = require("luasnip")
local s = ls.snippet
local t = ls.text_node
local i = ls.insert_node
local c = ls.choice_node
local f = ls.function_node

return {
	-- anyhow main (amain)
	-- 快速生成你最常用的 anyhow 入口
	s("amain", {
		t({ "#[tokio::main]", "async fn main() -> anyhow::Result<()> {", "\t" }),
		i(0),
		t({ "", "", "\tOk(())", "}" }),
	}),

	-- 異步函數 (afn)
	-- 生成 async fn，預設回傳 anyhow::Result
	s("afn", {
		t("async fn "),
		i(1, "name"),
		t("("),
		i(2),
		t(") -> "),
		i(3, "anyhow::Result<()>"),
		t({ " {", "\t" }),
		i(0),
		t({ "", "}" }),
	}),

	-- 測試模組 (tmod)
	-- 快速生成 Rust 的測試 Boilerplate
	s("tmod", {
		t({ "#[cfg(test)]", "mod tests {", "\tuse super::*;", "", "\t#[tokio::test]", "\tasync fn test_" }),
		i(1, "works"),
		t({ "() -> anyhow::Result<()> {", "\t\t" }),
		i(0),
		t({ "", "\t\tOk(())", "\t}", "}" }),
	}),

	-- Serde 屬性 (sder)
	-- 常用於結構體欄位，處理 JSON 序列化
	s("sder", {
		t('#[serde(rename = "'),
		i(1),
		t('")]'),
	}),

	-- 打印調試 (pd)
	-- 快速打出 {:?} 調試
	s("pd", {
		t('println!("{:?}", '),
		i(1),
		t(");"),
	}),

	-- 基礎 tracing info (tri)
	-- 輸入 tri -> Enter -> 輸入訊息 -> Tab -> 輸入變數
	s("tri", {
		t('tracing::info!("'),
		i(1, "message"),
		t('", '),
		i(2, "key"),
		t(" = ?"),
		i(3, "val"),
		t(");"),
	}),

	-- 帶有 Debug 格式的訊息 (trd)
	-- 使用 ? 語法自動調用 {:?}
	s("trd", {
		t('tracing::debug!("'),
		i(1, "message"),
		t('", '),
		f(function(args)
			return args[1][1]
		end, { 2 }),
		t(" = ?"),
		i(2, "var"),
		t(");"),
	}),

	-- 錯誤紀錄 (tre)
	-- 常用於 anyhow 的錯誤捕捉
	s("tre", {
		t("tracing::error!(error = ?"),
		i(1, "err"),
		t(', "'),
		i(2, "failed to execute"),
		t('");'),
	}),

	-- 函數追蹤儀器 (inst)
	-- 放在函數頂部，自動紀錄進入該函數的所有參數
	s("inst", {
		t("#[tracing::instrument(skip("),
		i(1, "self"),
		t("), fields("),
		i(2, "id"),
		t(" = ?"),
		f(function(args)
			return args[1][1]
		end, { 2 }),
		t("))]"),
	}),

	-- Match Result (mres)
	-- 快速處理 Result 的分支
	s("mres", {
		t("match "),
		i(1, "result"),
		t({ " {", "\tOk(" }),
		i(2, "val"),
		t({ ") => " }),
		i(3, "todo!()"),
		t(","),
		t({ "", "\tErr(e) => return Err(e.into()),", "}" }),
	}),
}
