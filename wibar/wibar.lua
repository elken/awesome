local wibox = require("wibox")
local awful = require("awful")
local theme = require("beautiful")
local gears = require("gears")
local globals = require("globals")

local fancy_taglist = require("wibar.tags")

-- Create a wibox for each screen and add it
local taglist_buttons = gears.table.join(
	awful.button({}, 1, function(t)
		t:view_only()
	end),
	awful.button({ globals.modkey }, 1, function(t)
		if client.focus then
			client.focus:move_to_tag(t)
		end
	end),
	awful.button({}, 3, awful.tag.viewtoggle),
	awful.button({ globals.modkey }, 3, function(t)
		if client.focus then
			client.focus:toggle_tag(t)
		end
	end),
	awful.button({}, 4, function(t)
		awful.tag.viewnext(t.screen)
	end),
	awful.button({}, 5, function(t)
		awful.tag.viewprev(t.screen)
	end)
)

local tasklist_buttons = gears.table.join(
	awful.button({}, 1, function(c)
		if c == client.focus then
			c.minimized = true
		else
			c:emit_signal("request::activate", "tasklist", { raise = true })
		end
	end),
	awful.button({}, 3, function()
		awful.menu.client_list({ theme = { width = 250 } })
	end),
	awful.button({}, 4, function()
		awful.client.focus.byidx(1)
	end),
	awful.button({}, 5, function()
		awful.client.focus.byidx(-1)
	end)
)

return function(screen)
	screen.wibox = awful.wibar({
		position = "top",
		screen = screen,
		height = theme.universalsize,
		bg = theme.transparent,
	})

	screen.wibox:setup({
		{
			layout = wibox.layout.align.horizontal,
			{
				-- Left
				layout = wibox.layout.fixed.horizontal,
				{
					awful.widget.layoutbox(screen),
					bg = theme.bg_accent3,
					widget = wibox.container.background,
				},
				{
					fancy_taglist.new({
						screen = screen,
						taglist_buttons = taglist_buttons,
						tasklist_buttons = tasklist_buttons,
					}),
					bg = theme.bg_accent2,
					widget = wibox.container.background,
				},
			},
			{
				-- Middle
				layout = wibox.layout.flex.horizontal,
				{
					awful.widget.tasklist({
						screen = screen,
						filter = awful.widget.tasklist.filter.focused,
						buttons = tasklist_buttons,
						style = {
							font = theme.interface_font .. theme.default_font_size,
							tasklist_disable_icon = true,
						},
					}),
					bg = theme.bg_accent2,
					widget = wibox.container.background,
				},
			},
			{
				-- Right
				layout = wibox.layout.fixed.horizontal,
				{
					require("wibar.battery"),
					bg = theme.bg_accent3,
					widget = wibox.container.background,
				},
				{
					require("wibar.playerctl"),
					bg = theme.bg_accent3,
					widget = wibox.container.background,
				},
				{
					wibox.widget.systray(),
					bottom = theme.universalsize / 6,
					top = theme.universalsize / 6,
					left = theme.universalsize * (2 / 3),
					right = theme.universalsize * (2 / 3),
					bg = theme.bg_accent1,
					widget = wibox.container.background,
				},
				{
					wibox.widget.textclock(string.format('<span color="%s" font="%s"> %s </span>', theme.fg_normal,
						theme.interface_font .. theme.default_font_size, "%a %d/%m/%y %H:%M")),
					bg = theme.bg_accent1,
					widget = wibox.container.background,
				},
				{
					require("wibar.power")({
						font = theme.interface_font .. tostring(theme.universalsize / 2),
					}),
					bg = theme.bg_accent3,
					widget = wibox.container.background,
				},
			},
		},
		left = theme.useless_gap * 2,
		right = theme.useless_gap * 2,
		widget = wibox.container.margin,
	})
end
