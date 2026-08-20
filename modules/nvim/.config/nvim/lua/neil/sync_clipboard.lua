local is_ssh = os.getenv("SSH_TTY") ~= nil or os.getenv("SSH_CONNECTION") ~= nil
local session_type = os.getenv("XDG_SESSION_TYPE")

if is_ssh or os.getenv("TMUX") then
	-- ==========================================
	-- 遠端 / Tmux 環境：透過 client_tty 強制寫入 OSC 52
	-- ==========================================
	vim.schedule(function()
		vim.opt.clipboard = "unnamedplus"
	end)

	local function osc52_copy(lines, _)
		local text = table.concat(lines, "\n")
		local encoded = vim.base64.encode(text)
		local tty = vim.fn.system('tmux display -p "#{client_tty}"'):gsub("%s+", "")
		if tty ~= "" then
			local fd = io.open(tty, "w")
			if fd then
				fd:write(string.format("\027]52;c;%s\027\\", encoded))
				fd:close()
			end
		end
	end

	vim.g.clipboard = {
		name = "OSC 52 (client_tty)",
		copy = {
			["+"] = osc52_copy,
			["*"] = osc52_copy,
		},
		paste = {
			["+"] = function()
				return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
			end,
			["*"] = function()
				return { vim.fn.split(vim.fn.getreg(""), "\n"), vim.fn.getregtype("") }
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
	vim.opt.clipboard = "unnamedplus"
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
	vim.opt.clipboard = "unnamedplus"
end
