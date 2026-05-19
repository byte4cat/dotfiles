-------------------
---- AUTOSTART ----
-------------------

-- See https://wiki.hypr.land/Configuring/Basics/Autostart/

local function exec(cmd)
	hl.exec_cmd(cmd)
end

hl.on("hyprland.start", function()
	-- DBus/Systemd
	exec(
		"dbus-update-activation-environment --systemd WAYLAND_DISPLAY XDG_CURRENT_DESKTOP HYPRLAND_INSTANCE_SIGNATURE GPG_TTY"
	)
	exec("gpg-connect-agent updatestartuptty /bye")
	exec("gpg-connect-agent /bye")
	exec("systemctl --user import-environment WAYLAND_DISPLAY XDG_RUNTIME_DIR HYPRLAND_INSTANCE_SIGNATURE")

	-- Daemons
	exec("sleep 1 && hypridle")
	exec("awww-daemon")
	exec("/usr/lib/polkit-kde-authentication-agent-1")
	exec("gnome-keyring-daemon --start --components=secrets,pkcs11,ssh")

	-- UI 相關應用 (使用 uwsm 確保與 Wayland 會話同步)
	exec("sleep 1.5 && byte4work-launch-waybar")
	exec("uwsm-app -- swaync")
	exec("uwsm-app -- fcitx5 -d")
	exec("uwsm-app -- elephant")
	exec("uwsm-app -- walker --gapplication-service")
	exec("uwsm-app -- swayosd-server")
	exec("uwsm-app -- glint")

	-- 剪貼簿管理
	exec("wl-paste --type text --watch cliphist store")

	-- 系統主題與外觀設定
	exec("gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'")
	exec("gsettings set org.gnome.desktop.interface gtk-theme 'adw-gtk3-dark'")
	exec("gsettings set org.gnome.desktop.interface font-name 'sans-serif 11'")

	-- 外掛與自動化腳本
	exec("hyprshade auto")
	-- exec("hyprpm reload")
	exec("byte4work-watch-dots")

	-- 特定 Workspace 預載應用
	exec("sleep 3")
	-- 終端機與 tmux
	exec(
		"[workspace special:scratchpadterm] "
			.. myEnv.terminal
			.. ' -e bash -c "tmux new-session -A -s scratchpad; exec bash"'
	)

	-- 通訊與多媒體 (silent 啟動)
	exec("[workspace special:work-msg silent] " .. myEnv.workMsg)
	exec("[workspace special:personal-msg silent] " .. myEnv.personalMsg)
	exec("[workspace special:music silent] " .. myEnv.music)

	-- 預設開啟的主工作區
	exec("[workspace 1 silent] " .. myEnv.terminal)
	exec("[workspace 2 silent] " .. myEnv.browser)
end)
