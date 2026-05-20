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
	"looknfeel.lua",
	"cursor.lua",
	"input.lua",
	"permission.lua",
	"wnw.lua",
	"keybindings.lua",
	"autostart.lua",
	"transparent.lua",
}

for _, file in ipairs(modules) do
	load_if_exists(config_path .. file)
end

load_if_exists(private_config)
