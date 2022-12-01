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

return function(s)
	s.wibox = awful.wibar({
		position = "top",
		screen = s,
		height = theme.universalsize,
		margins = theme.wibar_margins,
		bg = theme.wibar_bg,
		border_color = theme.wibar_border_color,
		border_width = theme.wibar_border_width,
	})

	s.wibox:setup({
		{
			layout = wibox.layout.align.horizontal,
			{
				-- Left
				layout = wibox.layout.fixed.horizontal,
				awful.widget.layoutbox(s),
				awful.widget.taglist({
					screen = s,
					filter = awful.widget.taglist.filter.all,
				}),
				-- fancy_taglist.new({
				-- 	screen = s,
				-- 	taglist_buttons = taglist_buttons,
				-- 	tasklist_buttons = tasklist_buttons,
				-- }),
			},
			{
				-- Middle
				layout = wibox.layout.flex.horizontal,
				awful.widget.tasklist({
					screen = s,
					filter = awful.widget.tasklist.filter.focused,
					buttons = tasklist_buttons,
				}),
			},
			{
				-- Right
				layout = wibox.layout.fixed.horizontal,
				require("wibar.battery"),
				require("wibar.playerctl"),
				wibox.widget.systray(),
				wibox.widget.textclock(
					string.format('<span color="%s"> %s </span>', theme.fg_normal, "%a %d/%m/%y %H:%M")
				),
				require("wibar.power")(),
			},
		},
		margins = 2,
		widget = wibox.container.margin,
	})
end
