-- ~/.config/nvim/lua/neil/plugins/wordcount.lua

local function strip_yaml_frontmatter(lines)
	if #lines < 2 or lines[1] ~= "---" then
		return lines
	end
	for i = 2, #lines do
		if lines[i] == "---" then
			return vim.list_slice(lines, i + 1)
		end
	end
	return lines
end

local function get_buf_text()
	local lines = vim.api.nvim_buf_get_lines(0, 0, -1, false)
	if vim.bo.filetype == "markdown" then
		lines = strip_yaml_frontmatter(lines)
	end
	return lines
end

local function count_words_and_chars(text)
	local chinese_count = 0
	local english_count = 0
	for _ in text:gmatch("[\228-\233][\128-\191][\128-\191]") do
		chinese_count = chinese_count + 1
	end
	for _ in text:gmatch("[%w_-]+") do
		english_count = english_count + 1
	end
	return chinese_count, english_count
end

-- 根據 cmdheight 動態決定使用 notify 還是 print
local function smart_output(title, msg_list)
	-- msg_list 傳入一個陣列，方便針對 notify (多行) 與 print (單行) 做格式優化
	if vim.o.cmdheight == 0 then
		-- 使用 notify 時，保留換行
		local formatted_msg = table.concat(msg_list, "\n")
		vim.notify(formatted_msg, vim.log.levels.INFO, { title = title, timeout = 5000 })
	else
		-- 使用 print 時，將換行合併為單行，避免擠壓編輯器視窗
		local formatted_msg = table.concat(msg_list, " | ")
		print(string.format("[%s] %s", title, formatted_msg))
	end
end

local function do_count()
	vim.schedule(function()
		local lines = get_buf_text()
		local text = table.concat(lines, "\n")
		local lines_count = #lines
		local bytes_count = #text
		local zh_cnt, en_cnt = count_words_and_chars(text)
		local total_words = zh_cnt + en_cnt

		smart_output("WordCount", {
			string.format("%d lines", lines_count),
			string.format("%d words (ZH: %d, EN: %d)", total_words, zh_cnt, en_cnt),
			string.format("%d bytes", bytes_count),
		})
	end)
end

return {
	"wordcount",
	dir = vim.fn.stdpath("config") .. "/lua/neil/plugins",
	lazy = true,
	init = function()
		vim.api.nvim_create_user_command("WordCount", function()
			do_count()
		end, { desc = "Count words in buffer (supports CJK, smart output)" })
	end,
}
