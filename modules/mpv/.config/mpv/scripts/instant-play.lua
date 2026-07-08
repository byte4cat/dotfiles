local msg = require("mp.msg")

-- Initialization Logs
msg.info("--- Instant Play Mode Initialized ---")
msg.info("--- Monitoring playlist updates ---")

-- Observe changes in the playlist count
mp.observe_property("playlist-count", "number", function(_, count)
	-- If count is greater than 1, a new file was recently appended
	if count and count > 1 then
		msg.info("New file detected in playlist. Forcing jump to latest entry.")

		-- Calculate the index of the last item (mpv uses 0-based indexing)
		local last_index = count - 1

		-- Force jump to the last item in the playlist
		mp.set_property_number("playlist-pos", last_index)

		-- On-Screen Display (OSD) feedback
		mp.osd_message("Instant Play: Jumping to new file", 2)
	end
end)
