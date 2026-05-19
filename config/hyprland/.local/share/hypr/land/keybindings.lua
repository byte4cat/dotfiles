---------------------
---- KEYBINDINGS ----
---------------------

local mainMod = myEnv.mainMod
local altMod = myEnv.altMod

-- 如果按鍵本身就不需要 mainMod（例如多媒體鍵），我們額外提供一個純綁定函數
local function bind_raw(keys, action, opts)
	hl.bind(keys, action, opts)
end

local function bind(keys, action, opts)
	local clean_keys = keys:gsub("%s+", ""):gsub("^%+", "")
	hl.bind(mainMod .. "+" .. clean_keys, action, opts)
end

local function binde(keys, action, opts)
	local o = opts or {}
	o.repeating = true
	local clean_keys = keys:gsub("%s+", ""):gsub("^%+", "")
	hl.bind(mainMod .. "+" .. clean_keys, action, o)
end

local function exec(cmd)
	return function()
		hl.dsp.exec_cmd(cmd)
	end
end

-- 應用程式與視窗操作
bind("RETURN", exec(myEnv.terminal))
bind("Q", function()
	hl.dsp.window.close()
end)
bind("M", exec("byte4work-walker-power-menu"))
bind("B", exec(myEnv.browser))
bind("SHIFT+E", exec(myEnv.fileManager))
bind("E", exec(myEnv.terminalFileManager))
bind("SHIFT+F", function()
	hl.dsp.window.float({ action = "toggle" })
end)
bind("F", function()
	hl.dsp.window.fullscreen()
end)
bind("D", exec(myEnv.menu))
bind("P", function()
	hl.dsp.window.pseudo()
end)
bind("T", exec("byte4work-switch-waybar-theme"))
bind("N", function()
	hl.dsp.window.next()
end)
bind("SHIFT+N", exec("swaync-client -t"))
bind("C", exec("byte4work-walker-quick-menu"))
bind("W", exec("byte4work-waypaper-selector"))
bind("SHIFT+B", exec(myEnv.babycam))
bind("SHIFT+P", exec("byte4work-hyprland-toggle-pin"))

-- Clipboard
bind("ALT+C", exec(myEnv.menu .. " -m clipboard"))

-- 重啟 Waybar 組合包
bind("SHIFT+R", exec("pkill glint; pkill swayosd-server; byte4work-launch-waybar & swayosd-server & glint &"))

-- 視窗調整 (Resize)
binde("CONTROL+SHIFT+H", function()
	hl.dsp.window.resize({ x = -30, y = 0 })
end)
binde("CONTROL+SHIFT+J", function()
	hl.dsp.window.resize({ x = 0, y = 30 })
end)
binde("CONTROL+SHIFT+K", function()
	hl.dsp.window.resize({ x = 0, y = -30 })
end)
binde("CONTROL+SHIFT+L", function()
	hl.dsp.window.resize({ x = 30, y = 0 })
end)

-- 移動視窗 (Move window)
bind("SHIFT+H", function()
	hl.dsp.window.move({ direction = "left" })
end)
bind("SHIFT+J", function()
	hl.dsp.window.move({ direction = "down" })
end)
bind("SHIFT+K", function()
	hl.dsp.window.move({ direction = "up" })
end)
bind("SHIFT+L", function()
	hl.dsp.window.move({ direction = "right" })
end)

-- 移動焦點 (Focus) - Vim Style
bind("H", function()
	hl.dsp.focus({ direction = "left" })
end)
bind("L", function()
	hl.dsp.focus({ direction = "right" })
end)
bind("K", function()
	hl.dsp.focus({ direction = "up" })
end)
bind("J", function()
	hl.dsp.focus({ direction = "down" })
end)

-- 工作區切換 (1-10)
for i = 1, 10 do
	local key = i % 10
	bind(tostring(key), function()
		hl.dsp.focus({ workspace = i })
	end)
	bind("SHIFT+" .. key, function()
		hl.dsp.window.move({ workspace = i })
	end)
end

-- Tab 切換前一個工作區
hl.config({ binds = { allow_workspace_cycles = true } })
bind("TAB", function()
	hl.dsp.focus({ workspace = "previous" })
end)

-- 滑鼠綁定 (Move/Resize)
bind("mouse:272", function()
	hl.dsp.window.drag()
end, { mouse = true })
bind("mouse:273", function()
	hl.dsp.window.resize()
end, { mouse = true })

--------------------
---- SCREENSHOT ----
--------------------

bind("CONTROL+1", exec("hyprshot -m output --clipboard-only"))
bind("CONTROL+2", exec("hyprshot -m window --clipboard-only"))
bind("CONTROL+3", exec("hyprshot -m region --clipboard-only"))

bind("CONTROL+SHIFT+1", exec("hyprshot -m output --raw | satty --filename -"))
bind("CONTROL+SHIFT+2", exec("hyprshot -m window --raw | satty --filename -"))
bind("CONTROL+SHIFT+3", exec("hyprshot -m region --raw | satty --filename -"))

--------------
---- ZOOM ----
--------------

local zoom_in_cmd =
	"hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | jq '.float * 1.1')"
binde("equal", exec(zoom_in_cmd))
binde("KP_ADD", exec(zoom_in_cmd))

local zoom_out_cmd =
	"hyprctl -q keyword cursor:zoom_factor $(hyprctl getoption cursor:zoom_factor -j | jq '(.float * 0.9) | if . < 1 then 1 else . end')"
binde("minus", exec(zoom_out_cmd))
binde("KP_SUBTRACT", exec(zoom_out_cmd))

local zoom_reset_cmd = "hyprctl -q keyword cursor:zoom_factor 1"
bind("SHIFT+minus", exec(zoom_reset_cmd))
bind("SHIFT+KP_SUBTRACT", exec(zoom_reset_cmd))
bind("SHIFT+0", exec(zoom_reset_cmd))

------------------------------
---- MULTIMEDIA & SWAYOSD ----
------------------------------

local function swayosd_exec(cmd)
	local get_mon = myEnv.primaryMonitor
	return function()
		hl.dsp.exec_cmd('bash -c "' .. cmd .. " --monitor " .. get_mon .. '"')
	end
end

local vol_opts = { locked = true, repeating = true }

-- Raise Volume
local vol_up_base = "wpctl set-volume -l 1 @DEFAULT_AUDIO_SINK@ 5%+; swayosd-client --output-volume raise"
bind_raw("XF86AudioRaiseVolume", swayosd_exec(vol_up_base), vol_opts)
bind("bracketright", swayosd_exec(vol_up_base), vol_opts)

-- Lower Volume
local vol_down_base = "wpctl set-volume @DEFAULT_AUDIO_SINK@ 5%-; swayosd-client --output-volume lower"
bind_raw("XF86AudioLowerVolume", swayosd_exec(vol_down_base), vol_opts)
bind("bracketleft", swayosd_exec(vol_down_base), vol_opts)

-- Mute
local vol_mute_base = "swayosd-client --output-volume mute-toggle"
bind_raw("XF86AudioMute", swayosd_exec(vol_mute_base), vol_opts)
bind("backslash", swayosd_exec(vol_mute_base), vol_opts)

-- 亮度控制
local br_up_base = "brightnessctl -e4 -n2 set 5%+; swayosd-client --brightness up"
local br_down_base = "brightnessctl -e4 -n2 set 5%-; swayosd-client --brightness down"
bind_raw("XF86MonBrightnessUp", swayosd_exec(br_up_base), vol_opts)
bind_raw("XF86MonBrightnessDown", swayosd_exec(br_down_base), vol_opts)

-- Playerctl
local player_opts = { locked = true }
bind_raw("XF86AudioNext", exec("playerctl next"), player_opts)
bind_raw("XF86AudioPrev", exec("playerctl previous"), player_opts)
bind_raw("XF86AudioPlay", exec("playerctl play-pause"), player_opts)
bind_raw("XF86AudioPause", exec("playerctl play-pause"), player_opts)
