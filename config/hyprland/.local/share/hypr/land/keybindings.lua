---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = myEnv.mainMod
local altMod = myEnv.altMod

local function bind(keys, action, opts)
	hl.bind(mainMod .. " " .. keys, action, opts)
end

local function binde(keys, action, opts)
	local o = opts or {}
	o.repeating = true
	hl.bind(mainMod .. " " .. keys, action, o)
end

local function exec(cmd)
	return hl.dsp.exec_cmd(cmd)
end

-- 應用程式與視窗操作
bind("+ RETURN", exec(myEnv.terminal))
bind("+ Q", hl.dsp.window.close()) -- 關閉活動視窗
bind("+ M", exec("byte4work-walker-power-menu"))
bind("+ B", exec(myEnv.browser))
bind("+ SHIFT + E", exec(myEnv.fileManager))
bind("+ E", exec(myEnv.terminalFileManager))
bind("+ SHIFT + F", hl.dsp.window.float({ action = "toggle" }))
bind("+ F", hl.dsp.window.fullscreen())
bind("+ D", exec(myEnv.menu))
bind("+ P", hl.dsp.window.pseudo()) -- dwindle
bind("+ T", exec("byte4work-switch-waybar-theme"))
bind("+ N", hl.dsp.focus({ direction = "next" })) -- cyclenext
bind("+ SHIFT + N", exec("swaync-client -t"))
bind("+ C", exec("byte4work-walker-quick-menu"))
bind("+ W", exec("byte4work-waypaper-selector"))
bind("+ SHIFT + B", exec(myEnv.babycam))
bind("+ SHIFT + P", exec("byte4work-hyprland-toggle-pin"))

-- Clipboard
hl.bind(mainMod .. " " .. altMod .. " + C", exec(myEnv.menu .. " -m clipboard"))

-- 重啟 Waybar 組合包 (SHIFT + R)
bind("+ SHIFT + R", exec("pkill glint; pkill swayosd-server; byte4work-launch-waybar & swayosd-server & glint &"))

-- 視窗調整 (Resize) - 使用 binde (repeating = true)
binde("+ CONTROL + SHIFT + H", hl.dsp.window.resize({ size = "-30 0" }))
binde("+ CONTROL + SHIFT + J", hl.dsp.window.resize({ size = "0 30" }))
binde("+ CONTROL + SHIFT + K", hl.dsp.window.resize({ size = "0 -30" }))
binde("+ CONTROL + SHIFT + L", hl.dsp.window.resize({ size = "30 0" }))

-- 移動視窗 (Move window)
bind("+ SHIFT + H", hl.dsp.window.move({ direction = "left" }))
bind("+ SHIFT + J", hl.dsp.window.move({ direction = "down" }))
bind("+ SHIFT + K", hl.dsp.window.move({ direction = "up" }))
bind("+ SHIFT + L", hl.dsp.window.move({ direction = "right" }))

-- 移動焦點 (Focus) - Vim Style
bind("+ H", hl.dsp.focus({ direction = "left" }))
bind("+ L", hl.dsp.focus({ direction = "right" }))
bind("+ K", hl.dsp.focus({ direction = "up" }))
bind("+ J", hl.dsp.focus({ direction = "down" }))

-- 工作區切換 (1-10)
for i = 1, 10 do
	local key = i % 10
	bind("+ " .. key, hl.dsp.focus({ workspace = i }))
	bind("+ SHIFT + " .. key, hl.dsp.window.move({ workspace = i }))
end

-- 快速切換工作區 (方向鍵)
bind("+ RIGHT", hl.dsp.focus({ workspace = "+1" }))
bind("+ LEFT", hl.dsp.focus({ workspace = "-1" }))

-- Tab 切換前一個工作區 (需要 allow_workspace_cycles = true)
hl.config({ binds = { allow_workspace_cycles = true } })
bind("+ TAB", hl.dsp.focus({ workspace = "previous" }))

-- 滑鼠綁定 (Move/Resize)
hl.bind(mainMod .. " + mouse:272", hl.dsp.window.drag(), { mouse = true })
hl.bind(mainMod .. " + mouse:273", hl.dsp.window.resize(), { mouse = true })

--------------------
---- SCREENSHOT ----
--------------------

-- 僅存入剪貼簿 (SUPER + CTRL + 1/2/3)
bind("CONTROL + 1", exec("hyprshot -m output --clipboard-only"))
bind("CONTROL + 2", exec("hyprshot -m window --clipboard-only"))
bind("CONTROL + 3", exec("hyprshot -m region --clipboard-only"))

-- 截圖後用 Satty 編輯 (SUPER + CTRL + SHIFT + 1/2/3)
bind("CONTROL + SHIFT + 1", exec("hyprshot -m output --raw | satty --filename -"))
bind("CONTROL + SHIFT + 2", exec("hyprshot -m window --raw | satty --filename -"))
bind("CONTROL + SHIFT + 3", exec("hyprshot -m region --raw | satty --filename -"))

-- 滑鼠滾輪縮放
-- hl.bind(mainMod .. ", mouse_down", exec(zoom_in_cmd))
-- hl.bind(mainMod .. ", mouse_up", exec(zoom_out_cmd))

--------------
---- ZOOM ----
--------------

-- 放大：每次增加 10%
local zoom_in_cmd =
	"hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | jq '.float * 1.1')"
binde("+ equal", exec(zoom_in_cmd))
binde("+ KP_ADD", exec(zoom_in_cmd))

-- 縮小：每次減少 10%，最低不小於 1
local zoom_out_cmd =
	"hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | jq '(.float * 0.9) | if . < 1 then 1 else . end')"
binde("+ minus", exec(zoom_out_cmd))
binde("+ KP_SUBTRACT", exec(zoom_out_cmd))

-- 重設縮放 (Reset to 1)
local zoom_reset_cmd = "hyprctl -q keyword cursor:zoom_factor 1"
bind("SHIFT + minus", exec(zoom_reset_cmd))
bind("SHIFT + KP_SUBTRACT", exec(zoom_reset_cmd))
bind("SHIFT + 0", exec(zoom_reset_cmd))

------------------------------
---- MULTIMEDIA & SWAYOSD ----
------------------------------

-- Helper: 使用 bash -c 封裝，確保 $(...) 子 shell 能正確執行並動態偵測聚焦螢幕
local function swayosd_exec(cmd)
	-- local get_mon = "$(hyprctl monitors -j | jq -r '.[] | select(.focused == true).name')"
	local get_mon = myEnv.primaryMonitor
	return hl.dsp.exec_cmd('bash -c "' .. cmd .. " --monitor " .. get_mon .. '"')
end

-- 音量控制 (包含 HHKB 模式)
local vol_opts = { locked = true, repeating = true }

-- Raise Volume (使用 swayosd_exec 自動附加 --monitor)
local vol_up_base = "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+; swayosd-client --output-volume raise"
hl.bind(", XF86AudioRaiseVolume", swayosd_exec(vol_up_base), vol_opts)
bind("+ bracketright", swayosd_exec(vol_up_base), vol_opts) -- SUPER + ]

-- Lower Volume
local vol_down_base = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-; swayosd-client --output-volume lower"
hl.bind(", XF86AudioLowerVolume", swayosd_exec(vol_down_base), vol_opts)
bind("+ bracketleft", swayosd_exec(vol_down_base), vol_opts) -- SUPER + [

-- Mute
local vol_mute_base = "swayosd-client --output-volume mute-toggle"
hl.bind(", XF86AudioMute", swayosd_exec(vol_mute_base), vol_opts)
bind("+ backslash", swayosd_exec(vol_mute_base), vol_opts) -- SUPER + \

-- 亮度控制
local br_up_base = "brightnessctl -e4 -n2 set 5%+; swayosd-client --brightness up"
local br_down_base = "brightnessctl -e4 -n2 set 5%-; swayosd-client --brightness down"
hl.bind(", XF86MonBrightnessUp", swayosd_exec(br_up_base), vol_opts)
hl.bind(", XF86MonBrightnessDown", swayosd_exec(br_down_base), vol_opts)

-- Playerctl (不需要 SwayOSD OSD，直接用 exec 即可)
local player_opts = { locked = true }
hl.bind(", XF86AudioNext", hl.dsp.exec_cmd("playerctl next"), player_opts)
hl.bind(", XF86AudioPrev", hl.dsp.exec_cmd("playerctl previous"), player_opts)
hl.bind(", XF86AudioPlay", hl.dsp.exec_cmd("playerctl play-pause"), player_opts)
hl.bind(", XF86AudioPause", hl.dsp.exec_cmd("playerctl play-pause"), player_opts)
