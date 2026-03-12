if _G.FONG_GOU_LOCKED then
	return
end
_G.FONG_GOU_LOCKED = true

local msg = require("mp.msg")
msg.info("--- 瘋狗強行播放模式 (Singleton) 啟動 ---")

local msg = require("mp.msg")
msg.info("--- 瘋狗強行播放模式啟動 ---")

-- 監聽播放清單數量的變化
mp.observe_property("playlist-count", "number", function(name, count)
	-- 如果清單裡有超過一個檔案（代表剛被丟進去一個新的）
	if count and count > 1 then
		msg.info("偵測到新檔案加入清單，強行跳轉播放！")

		-- 取得最後一個檔案的索引（mpv 索引從 0 開始）
		local last_index = count - 1

		-- 強制跳到最後一個檔案播放
		mp.set_property_number("playlist-pos", last_index)

		-- 在畫面上噴一個瘋狗提示
		mp.osd_message("🚀 瘋狗跳轉：播放新檔案", 2)
	end
end)
