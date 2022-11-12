local awful = require("awful")
local gears = require("gears")
local theme = require("beautiful")
local wibox = require("wibox")
local bling = require("bling")
local playerctl = bling.signal.playerctl.lib({
	ignore = "firefox",
	player = { "mpd", "%any" },
})

local prev = ""
local play = " "
local pause = " "
local next = ""

local size = theme.universalsize * 1.5
local font = theme.interface_font .. tostring(theme.universalsize / 2)
local font_controls = theme.font_name .. tostring(theme.universalsize / 2)

local name_widget = wibox.widget({
	markup = "No players",
	align = "center",
	valign = "center",
	widget = wibox.widget.textbox,
})

local song_widget = wibox.widget({
	markup = "",
	font = font,
	align = "center",
	valign = "center",
	widget = wibox.widget.textbox,
})

local play_pause_widget = wibox.widget({
	markup = "",
	font = font_controls,
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
	local song_text = string.format("%s - %s", artist, title)

	if song_text ~= nil then
		local max_width = size - 5
		if string.len(song_text) > max_width then
			song_text = " " .. string.sub(song_text, 0, max_width) .. "... "
		else
			song_text = string.format(string.format("%%-%ds", max_width), string.sub(song_text, 1, max_width))
		end

		song_widget:set_markup_silently(song_text)
	end
end)

playerctl:connect_signal("playback_status", function(_, is_playing)
	play_pause_widget:set_markup_silently(is_playing and pause or play)
end)

return wibox.widget({
	{
		{
			song_widget,
			{
				id = "prev",
				font = font_controls,
				text = prev,
				widget = wibox.widget.textbox,
				buttons = gears.table.join(awful.button({}, 1, nil, function()
					playerctl:previous()
				end)),
			},
			play_pause_widget,
			{
				id = "next",
				font = font_controls,
				text = next,
				widget = wibox.widget.textbox,
				buttons = gears.table.join(awful.button({}, 1, nil, function()
					playerctl:next()
				end)),
			},
			layout = wibox.layout.fixed.horizontal,
		},
		left = theme.universalsize / 2,
		right = theme.universalsize / 2,
		widget = wibox.container.margin,
	},
	layout = wibox.layout.fixed.horizontal,
})
