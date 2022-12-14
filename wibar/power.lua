-------------------------------------------------
-- Logout Menu Widget for Awesome Window Manager
-- More details could be found here:
-- https://github.com/streetturtle/awesome-wm-widgets/tree/master/logout-menu-widget

-- @author Pavel Makhov
-- @copyright 2020 Pavel Makhov
-------------------------------------------------

local awful = require("awful")
local wibox = require("wibox")
local gears = require("gears")
local theme = require("beautiful")
local globals = require("globals")

local theme_dir = string.format("%s/icons/", globals.theme.dir)

local logout_menu_widget = wibox.widget({
	{
		{
			image = theme_dir .. "power_w.svg",
			resize = true,
			widget = wibox.widget.imagebox,
		},
		margins = 4,
		layout = wibox.container.margin,
	},
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, 4)
	end,
	widget = wibox.container.background,
})

local popup = awful.popup({
	ontop = true,
	visible = false,
	shape = function(cr, width, height)
		gears.shape.rounded_rect(cr, width, height, 4)
	end,
	border_width = 1,
	border_color = theme.bg_focus,
	maximum_width = 400,
	offset = { y = 5 },
	widget = {},
})

local function worker(user_args)
	local rows = { layout = wibox.layout.fixed.vertical }

	local args = user_args or {}

	local font = args.font or theme.font

	local onlogout = args.onlogout or function()
		awesome.quit()
	end
	local onlock = args.onlock or function()
		awful.spawn.with_shell(globals.tools.lock)
	end
	local onreboot = args.onreboot or function()
		awful.spawn.with_shell(globals.tools.reboot)
	end
	local onsuspend = args.onsuspend or function()
		awful.spawn.with_shell(globals.tools.suspend)
	end
	local onpoweroff = args.onpoweroff or function()
		awful.spawn.with_shell(globals.tools.poweroff)
	end

	local menu_items = {
		{ name = "Log out", icon_name = "log-out.svg", command = onlogout },
		{ name = "Lock", icon_name = "lock.svg", command = onlock },
		{ name = "Reboot", icon_name = "refresh-cw.svg", command = onreboot },
		{ name = "Suspend", icon_name = "moon.svg", command = onsuspend },
		{ name = "Power off", icon_name = "power.svg", command = onpoweroff },
	}

	for _, item in ipairs(menu_items) do
		local row = wibox.widget({
			{
				{
					{
						image = theme_dir .. item.icon_name,
						resize = false,
						widget = wibox.widget.imagebox,
					},
					{
						text = item.name,
						font = font,
						widget = wibox.widget.textbox,
					},
					spacing = 12,
					layout = wibox.layout.fixed.horizontal,
				},
				margins = 8,
				layout = wibox.container.margin,
			},
			bg = theme.bg_normal,
			widget = wibox.container.background,
		})

		row:connect_signal("mouse::enter", function(c)
			c:set_bg(theme.bg_focus)
		end)
		row:connect_signal("mouse::leave", function(c)
			c:set_bg(theme.bg_normal)
		end)

		local old_cursor, old_wibox
		row:connect_signal("mouse::enter", function()
			local wb = mouse.current_wibox
			old_cursor, old_wibox = wb.cursor, wb
			wb.cursor = "hand1"
		end)
		row:connect_signal("mouse::leave", function()
			if old_wibox then
				old_wibox.cursor = old_cursor
				old_wibox = nil
			end
		end)

		row:buttons(awful.util.table.join(awful.button({}, 1, function()
			popup.visible = not popup.visible
			logout_menu_widget:set_bg(theme.transparent)
			item.command()
		end)))

		table.insert(rows, row)
	end
	popup:setup(rows)

	logout_menu_widget:buttons(awful.util.table.join(awful.button({}, 1, function()
		if popup.visible then
			popup.visible = not popup.visible
			logout_menu_widget:set_bg(theme.transparent)
		else
			popup:move_next_to(mouse.current_widget_geometry)
			logout_menu_widget:set_bg(theme.bg_focus)
		end
	end)))

	return logout_menu_widget
end

return worker
