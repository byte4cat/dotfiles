---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = (myEnv and myEnv.mainMod) or "SUPER"
local secMod = (myEnv and myEnv.secMod) or "ALT"

-- 輔助函數, 簡化 exec 呼叫 (確保指令傳遞給 shell)
local function sh_exec(cmd)
	return hl.dsp.exec_cmd("sh -c '" .. cmd .. "'")
end

-- ===================
-- 應用程式與視窗操作
-- ===================
hl.bind(mainMod .. " + RETURN", hl.dsp.exec_cmd(myEnv.terminal))
hl.bind(mainMod .. " + Q", hl.dsp.window.close())
hl.bind(mainMod .. " + M", hl.dsp.exec_cmd("byte4work-walker-power-menu"))
hl.bind(mainMod .. " + B", hl.dsp.exec_cmd(myEnv.browser))
hl.bind(mainMod .. " + SHIFT + E", hl.dsp.exec_cmd(myEnv.fileManager))
hl.bind(mainMod .. " + E", hl.dsp.exec_cmd(myEnv.terminalFileManager))

-- =============
-- 視窗狀態操作
-- =============
hl.bind(mainMod .. " + SHIFT + F", hl.dsp.window.float({ action = "toggle" }))
hl.bind(mainMod .. " + F", hl.dsp.window.fullscreen())
hl.bind(mainMod .. " + D", hl.dsp.exec_cmd(myEnv.menu))
hl.bind(mainMod .. " + P", hl.dsp.window.pseudo())
hl.bind(mainMod .. " + T", hl.dsp.exec_cmd("byte4work-switch-waybar-theme"))

-- 切換下一個視窗
hl.bind(mainMod .. " + N", hl.dsp.window.cycle_next({}))

hl.bind(mainMod .. " + SHIFT + N", hl.dsp.exec_cmd("swaync-client -t"))
hl.bind(mainMod .. " + C", hl.dsp.exec_cmd("byte4work-walker-quick-menu"))
hl.bind(mainMod .. " + W", hl.dsp.exec_cmd("byte4work-waypaper-selector"))
hl.bind(mainMod .. " + SHIFT + B", hl.dsp.exec_cmd(myEnv.babycam))
hl.bind(mainMod .. " + SHIFT + P", hl.dsp.window.pin({})) -- set window float first?

-- 剪貼簿
hl.bind(mainMod .. " + " .. secMod .. " + C", hl.dsp.exec_cmd(myEnv.menu .. " -m clipboard"))

-- 重啟 Waybar 組合包
hl.bind(
	mainMod .. " + SHIFT + R",
	hl.dsp.exec_cmd("pkill glint; pkill swayosd-server; byte4work-launch-waybar & swayosd-server & glint &")
)

-- =================
-- 視窗Resize與移動
-- =================
hl.bind(
	mainMod .. " + " .. "CONTROL + SHIFT + H",
	hl.dsp.window.resize({ x = -30, y = 0, relative = true }),
	{ repeating = true }
)
hl.bind(
	mainMod .. " + " .. "CONTROL + SHIFT + J",
	hl.dsp.window.resize({ x = 0, y = 30, relative = true }),
	{ repeating = true }
)
hl.bind(
	mainMod .. " + " .. "CONTROL + SHIFT + K",
	hl.dsp.window.resize({ x = 0, y = -30, relative = true }),
	{ repeating = true }
)
hl.bind(
	mainMod .. " + " .. "CONTROL + SHIFT + L",
	hl.dsp.window.resize({ x = 30, y = 0, relative = true }),
	{ repeating = true }
)

-- 移動視窗 (Move window)
hl.bind(mainMod .. " + SHIFT + H", hl.dsp.window.move({ direction = "left" }))
hl.bind(mainMod .. " + SHIFT + J", hl.dsp.window.move({ direction = "down" }))
hl.bind(mainMod .. " + SHIFT + K", hl.dsp.window.move({ direction = "up" }))
hl.bind(mainMod .. " + SHIFT + L", hl.dsp.window.move({ direction = "right" }))

-- 移動焦點 (Focus) - Vim Style
hl.bind(mainMod .. " + H", hl.dsp.focus({ direction = "left" }))
hl.bind(mainMod .. " + L", hl.dsp.focus({ direction = "right" }))
hl.bind(mainMod .. " + K", hl.dsp.focus({ direction = "up" }))
hl.bind(mainMod .. " + J", hl.dsp.focus({ direction = "down" }))

-- ==================
-- 工作區切換 (1-10)
-- ==================
for i = 1, 10 do
	local key = i % 10
	-- 切換工作區
	hl.bind(mainMod .. " + " .. key, hl.dsp.focus({ workspace = i }))
	-- 移動視窗到工作區
	hl.bind(mainMod .. " + SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- Group
hl.bind(mainMod .. " + G", function()
	hl.dispatch(hl.dsp.group.toggle())
end)
hl.bind(mainMod .. " + TAB", function()
	hl.dispatch(hl.dsp.group.next())
end)
hl.bind(mainMod .. " + SHIFT + TAB", function()
	hl.dispatch(hl.dsp.group.prev())
end)
-- 工作區管理修正
hl.bind(mainMod .. " + GRAVE", function()
	hl.dispatch(hl.dsp.workspace.focus("previous"))
end)

-- =========
-- 滑鼠綁定
-- =========
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

-- ===========
-- SCREENSHOT
-- ===========

-- NOTE: OLD WAY
--
-- hl.bind(mainMod .. " + CONTROL + 1", hl.dsp.exec_cmd("hyprshot -m output --clipboard-only"))
-- hl.bind(mainMod .. " + CONTROL + 2", hl.dsp.exec_cmd("hyprshot -m window --clipboard-only"))
-- hl.bind(mainMod .. " + CONTROL + 3", hl.dsp.exec_cmd("hyprshot -m region --clipboard-only"))
--
-- hl.bind(mainMod .. " + CONTROL + SHIFT + 1", hl.dsp.exec_cmd("hyprshot -m output --raw | satty --filename -"))
-- hl.bind(mainMod .. " + CONTROL + SHIFT + 2", hl.dsp.exec_cmd("hyprshot -m window --raw | satty --filename -"))
-- hl.bind(mainMod .. " + CONTROL + SHIFT + 3", hl.dsp.exec_cmd("hyprshot -m region --raw | satty --filename -"))

-- TODO: NEW WAY, NOT test YET:
-- 定義存放路徑
local screenshot_dir = os.getenv("HOME") .. "/Pictures/Screenshots"

-- 截圖指令定義
local cmd_full = "grim - | tee "
	.. screenshot_dir
	.. "/$(date +'%Y%m%d-%H%M%S').png | wl-copy && notify-send 'Screenshot saved & copied'"
local cmd_slurp = 'grim -g "$(slurp)" - | tee '
	.. screenshot_dir
	.. "/$(date +'%Y%m%d-%H%M%S').png | wl-copy && notify-send 'Screenshot saved & copied'"

-- 普通截圖
hl.bind(mainMod .. " + CONTROL + 1", sh_exec(cmd_full))
hl.bind(mainMod .. " + CONTROL + 2", sh_exec(cmd_slurp))
hl.bind(mainMod .. " + CONTROL + 3", sh_exec(cmd_slurp))

-- Satty 編輯
local satty_full = "grim - | satty --filename - --fullscreen --output-filename "
	.. screenshot_dir
	.. "/$(date +'%Y%m%d-%H%M%S').png"
local satty_slurp = 'grim -g "$(slurp)" - | satty --filename - --output-filename '
	.. screenshot_dir
	.. "/$(date +'%Y%m%d-%H%M%S').png"

hl.bind(mainMod .. " + CONTROL + SHIFT + 1", sh_exec(satty_full))
hl.bind(mainMod .. " + CONTROL + SHIFT + 2", sh_exec(satty_slurp))
hl.bind(mainMod .. " + CONTROL + SHIFT + 3", sh_exec(satty_slurp))

-- =====
-- ZOOM
-- =====
local zoom_in_cmd =
	"hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | jq '.float * 1.1')"
hl.bind(mainMod .. " + equal", hl.dsp.exec_cmd(zoom_in_cmd), { repeating = true })
hl.bind(mainMod .. " + KP_ADD", hl.dsp.exec_cmd(zoom_in_cmd), { repeating = true })

local zoom_out_cmd =
	"hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | jq '(.float * 0.9) | if . < 1 then 1 else . end')"
hl.bind(mainMod .. " + minus", hl.dsp.exec_cmd(zoom_out_cmd), { repeating = true })
hl.bind(mainMod .. " + KP_SUBTRACT", hl.dsp.exec_cmd(zoom_out_cmd), { repeating = true })

local zoom_reset_cmd = "hyprctl -q keyword cursor:zoom_factor 1"
hl.bind(mainMod .. " + SHIFT + minus", hl.dsp.exec_cmd(zoom_reset_cmd))
hl.bind(mainMod .. " + SHIFT + KP_SUBTRACT", hl.dsp.exec_cmd(zoom_reset_cmd))

-- =====================
-- MULTIMEDIA & SWAYOSD
-- =====================
local get_mon = myEnv.primaryMonitor
local function swayosd_cmd(base_cmd)
	return 'bash -c "' .. base_cmd .. " --monitor " .. get_mon .. '"'
end

-- 音量控制
local vol_up_base = swayosd_cmd("wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+; swayosd-client --output-volume raise")
local vol_down_base = swayosd_cmd("wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-; swayosd-client --output-volume lower")
local vol_mute_base = swayosd_cmd("swayosd-client --output-volume mute-toggle")

hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(vol_up_base), { locked = true, repeating = true })
hl.bind(mainMod .. " + bracketright", hl.dsp.exec_cmd(vol_up_base), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(vol_down_base), { locked = true, repeating = true })
hl.bind(mainMod .. " + bracketleft", hl.dsp.exec_cmd(vol_down_base), { locked = true, repeating = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(vol_mute_base), { locked = true, repeating = true })
hl.bind(mainMod .. " + backslash", hl.dsp.exec_cmd(vol_mute_base), { locked = true, repeating = true })

-- 亮度控制
local br_up_base = swayosd_cmd("brightnessctl -e4 -n2 set 5%+; swayosd-client --brightness up")
local br_down_base = swayosd_cmd("brightnessctl -e4 -n2 set 5%-; swayosd-client --brightness down")

hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(br_up_base), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(br_down_base), { locked = true, repeating = true })

-- 多媒體播放控制 (Playerctl)
hl.bind("XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), { locked = true })
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
hl.bind("XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), { locked = true })
