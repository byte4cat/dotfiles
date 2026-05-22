local config_path = os.getenv("HOME") .. "/.local/share/hypr/land/"
local private_config = os.getenv("HOME") .. "/.local/private/hypr/hyprland.lua"

local function load_if_exists(path)
	local f = io.open(path, "r")
	if f then
		f:close()
		return dofile(path)
	else
		print("Config file not found: " .. path)
		return nil
	end
end

-- 載入環境設定
_G.myEnv = load_if_exists(config_path .. "env.lua") or {}

-- 順序載入模組
local modules = {
	"monitor.lua",
	"autostart.lua",
	"looknfeel.lua",
	"cursor.lua",
	"input.lua",
	"permission.lua",
	"wnw.lua",
	"keybindings.lua",
	"transparent.lua",
}

for _, file in ipairs(modules) do
	load_if_exists(config_path .. file)
end

load_if_exists(private_config)

--------------------------------------------------------------------------------
-- NOTE: WORKAROUND FOR HARDWARE HOTPLUG & EXPLICIT SYNC CRASH
--
-- [Issue]
--   Hyprland (v0.55.2) crashed with Signal 6 (ABRT) during monitor hotplug / sleep resume.
--   CLI `hyprland --systeminfo` also triggered SIGSEGV at `Helpers::SystemInfo::getSystemInfo`.
--
-- [Root Cause]
--   1. Under Linux Kernel 7.0.x and AMD Granite Ridge Graphics, changes in sysfs/DRM
--      structures caused unexpected pointer failures during hardware topology detection.
--   2. The new rendering backend (Aquamarine) failed to negotiate Explicit Sync fences
--      on hotplug events, throwing:
--      "ERR [EGL] Command eglDupNativeFenceFDANDROID errored out with EGL_BAD_PARAMETER".
--
-- [Workaround]
--   Disable explicit synchronization and direct scanout to fall back to stable implicit
--   sync rendering, preventing EGL/DRM race conditions during CRTC reconfiguration.
--------------------------------------------------------------------------------

-- 關閉明確同步，改走隱式同步，防止 EGL 柵欄參數出錯 (EGL_BAD_PARAMETER)
--hl.render.explicit_sync = 0

-- 關閉直接掃描輸出，避免熱插拔時雙螢幕 CRTC 重新配置導致 Aquamarine 炸開
-- hl.render.direct_scanout = 0

hl.render = {
	explicit_sync = 0,
	direct_scanout = 0,
}
