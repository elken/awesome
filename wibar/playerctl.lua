local awful = require("awful")
local gears = require("gears")
local dpi = require("beautiful.xresources").apply_dpi
local wibox = require("wibox")
local bling = require("bling")
local playerctl = bling.signal.playerctl.lib({
	ignore = "firefox",
	player = { "mpd", "spotify", "%any" },
})

local prev = ""
local play = " "
local pause = " "
local next = ""

--- A step function that scrolls the widget to its end and zips to its
-- beginning. The speed is null at the ends and maximal in the middle. At both
-- ends the widget stands still for a moment.
-- @callback scroll_to_end_and_back
local function scroll_to_end_and_zip_back(elapsed, size, visible_size, speed)
	local state = ((elapsed * speed) % (2 * size)) / size
	local negate = false
	if state > 1 then
		negate = true
		state = state - 1
	end
	if state < 1 / 5 or state > 4 / 5 then
		-- One fifth of time, nothing moves
		state = state < 1 / 5 and 0 or 1
	else
		state = (state - 1 / 5) * 5 / 3
		if state < 1 / 3 then
			-- In the first 1/3rd of time, do a quadratic increase in speed
			state = 2 * state * state
		elseif state < 2 / 3 then
			-- In the center, do a linear increase. That means we need:
			-- If state is 1/3, result is 2/9 = 2 * 1/3 * 1/3
			-- If state is 2/3, result is 7/9 = 1 - 2 * (1 - 2/3) * (1 - 2/3)
			state = 5 / 3 * state - 3 / 9
		else
			-- In the last 1/3rd of time, do a quadratic decrease in speed
			state = 1 - 2 * (1 - state) * (1 - state)
		end
	end
	if negate then
		state = 0
	end
	return (size - visible_size) * state
end

local name_widget = wibox.widget({
	markup = "No players",
	align = "center",
	valign = "center",
	widget = wibox.widget.textbox,
})

local song_widget = wibox.widget({
	{
		markup = "",
		align = "center",
		valign = "center",
		widget = wibox.widget.textbox,
	},
	speed = 25,
	max_size = dpi(350),
	step_function = scroll_to_end_and_zip_back,
	layout = wibox.container.scroll.horizontal,
})

local play_pause_widget = wibox.widget({
	markup = "",
	widget = wibox.widget.textbox,
	buttons = gears.table.join(awful.button({}, 1, nil, function()
		playerctl:play_pause()
	end)),
})

-- Get Song Info
playerctl:connect_signal("metadata", function(_, title, artist, album_path, album, new, player_name)
	-- Set art widget
	-- art:set_image(gears.surface.load_uncached(album_path))

	-- Set player name, title and artist widgets
	name_widget:set_markup_silently(player_name)
	song_widget.widget:set_markup_silently(string.format("%s - %s  ", artist, title))
end)

playerctl:connect_signal("playback_status", function(_, is_playing)
	if is_playing then
		play_pause_widget:set_markup_silently(pause)
		song_widget.layout = wibox.container.scroll.horizontal
		song_widget:continue()
	else
		play_pause_widget:set_markup_silently(play)
		song_widget.layout = wibox.layout.fixed.horizontal
		song_widget:pause()
	end
end)

return wibox.widget({
	{
		{
			song_widget,
			{
				id = "prev",
				text = prev,
				widget = wibox.widget.textbox,
				buttons = gears.table.join(awful.button({}, 1, nil, function()
					playerctl:previous()
				end)),
			},
			play_pause_widget,
			{
				id = "next",
				text = next,
				widget = wibox.widget.textbox,
				buttons = gears.table.join(awful.button({}, 1, nil, function()
					playerctl:next()
				end)),
			},
			layout = wibox.layout.fixed.horizontal,
		},
		left = dpi(6),
		right = dpi(6),
		widget = wibox.container.margin,
	},
	layout = wibox.layout.fixed.horizontal,
})
