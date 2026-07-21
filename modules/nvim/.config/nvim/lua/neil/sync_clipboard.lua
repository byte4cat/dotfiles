local is_ssh = os.getenv("SSH_TTY") ~= nil or os.getenv("SSH_CONNECTION") ~= nil
local session_type = os.getenv("XDG_SESSION_TYPE")

if is_ssh then
	-- ==========================================
	-- 遠端環境：使用 OSC 52 (支援 Tmux 穿透)
	-- ==========================================
	local function osc52_copy(lines, _)
		local content = table.concat(lines, "\n")
		local b64 = vim.base64.encode(content)
		local osc52 = string.format("\27]52;c;%s\7", b64)

		-- 處理 Tmux 穿透
		if os.getenv("TMUX") then
			osc52 = "\27Ptmux;\27" .. osc52:gsub("\27", "\27\27") .. "\27\\"
		end

		io.stdout:write(osc52)
		io.stdout:flush()
	end

	vim.g.clipboard = {
		name = "OSC52-SSH",
		copy = { ["+"] = osc52_copy, ["*"] = osc52_copy },
		paste = {
			["+"] = function()
				return require("vim.ui.clipboard.osc52").paste("+")()
			end,
			["*"] = function()
				return require("vim.ui.clipboard.osc52").paste("*")()
			end,
		},
	}
elseif session_type == "wayland" then
	-- 本地 Wayland
	vim.g.clipboard = {
		name = "Wayland-Local",
		copy = {
			["+"] = "wl-copy",
			["*"] = "wl-copy",
		},
		paste = {
			["+"] = "wl-paste --no-newline",
			["*"] = "wl-paste --no-newline",
		},
		cache_enabled = 1,
	}
elseif session_type == "x11" then
	-- 本地 X11
	vim.g.clipboard = {
		name = "X11-Local",
		copy = {
			["+"] = "xclip -selection clipboard",
			["*"] = "xclip -selection primary",
		},
		paste = {
			["+"] = "xclip -selection clipboard -o",
			["*"] = "xclip -selection primary -o",
		},
		cache_enabled = 1,
	}
end

-- 啟動同步
vim.opt.clipboard = "unnamedplus"
