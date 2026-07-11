local M = {}

M.toggle_pin_float = function()
	local win = hl.get_active_window()
	if win == nil then
		return
	end

	if win.pinned then
		hl.dispatch(hl.dsp.window.pin())
		if win.floating then
			hl.dispatch(hl.dsp.window.togglefloating())
		end
	else
		if not win.floating then
			hl.dispatch(hl.dsp.window.togglefloating())
		end
		hl.dispatch(hl.dsp.window.pin())
	end
end

return M
