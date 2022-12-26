-- If LuaRocks is installed, make sure that packages installed through it are
-- found (e.g. lgi). If LuaRocks is not installed, do nothing.
pcall(require, "luarocks.loader")

local gears = require("gears")
local awful = require("awful")
local theme = require("beautiful")
local naughty = require("naughty")
local wibox = require("wibox")
local ruled = require("ruled")
local globals = require("globals")

require("awful.hotkeys_popup.keys")
require("awful.autofocus")
require("awful.remote")

-- Handle startup errors
naughty.connect_signal("request::display_error", function(message, startup)
	naughty.notification({
		urgency = "critical",
		title = "Oops, an error happened" .. (startup and " during startup!" or "!"),
		message = message,
	})
end)
if awesome.startup_errors then
	naughty.notify({
		preset = naughty.config.presets.critical,
		title = "Startup errors found",
		text = awesome.startup_errors,
	})
end

-- Attempt to load the theme
if require("lfs").attributes(globals.theme.path, "mode") then
	theme.init(globals.theme.path)
else
	naughty.notify({
		title = "Oops, an error happened!",
		text = string.format(
			"Error loading theme %s. Please check the path %s exists",
			globals.theme.name,
			globals.theme.path
		),
	})
end

-- Wallpaper
local function set_wallpaper(s)
	if theme.wallpaper then
		awful.wallpaper({
			screen = s,
			widget = {
				{
					image = theme.wallpaper,
					upscale = true,
					downscale = true,
					widget = wibox.widget.imagebox,
				},
				valign = "center",
				halign = "center",
				tiled = false,
				widget = wibox.container.tile,
			},
		})
	end
end

-- Re-set wallpaper when a screen's geometry changes (e.g. different resolution)
screen.connect_signal("request::wallpaper", set_wallpaper)
screen.connect_signal("property::geometry", set_wallpaper)

-- Load the list of layouts
tag.connect_signal("request::default_layouts", function()
	awful.layout.append_default_layouts(globals.layouts)
end)

-- Use our preferred terminal emulator where possible
require("menubar").utils.terminal = globals.tools.term

-- Screen setup
screen.connect_signal("request::desktop_decoration", function(s)
	-- Each screen has its own tag table.
	awful.tag({ "1", "2", "3", "4", "5", "6", "7", "8", "9" }, s, awful.layout.layouts[1])
	require("wibar.wibar")(s)

	-- If there's a saved tag in tmp, load it for this screen
	local f = io.open("/tmp/awesome-screen-" .. tostring(s.index), "r")
	if f ~= nil then
		local tag_idx = tonumber(f:read("*line"))
		f:close()
		local t = s.tags[tag_idx]
		if t then
			t:view_only()
		else
			s.tags[1]:view_only()
		end
	else
		s.tags[1]:view_only()
	end
end)

-- Signal function to execute when a new client appears.
client.connect_signal("manage", function(c)
	-- Set the windows at the slave,
	-- i.e. put it at the end of others instead of setting it master.
	if not awesome.startup then
		awful.client.setslave(c)
	end

	if awesome.startup and not c.size_hints.user_position and not c.size_hints.program_position then
		-- Prevent clients from being unreachable after screen count changes.
		awful.placement.no_offscreen(c)
	end
end)

-- Proper fullscreen
client.connect_signal("property::fullscreen", function(c)
	if c.fullscreen then
		gears.timer.delayed_call(function()
			if c.valid then
				c:geometry(c.screen.geometry)
			end
		end)
	end
end)

client.connect_signal("mouse::enter", function(c)
	if awful.layout.get(c.screen) ~= awful.layout.suit.magnifier and awful.client.focus.filter(c) then
		client.focus = c
	end
end)

-- client.connect_signal("focus", function(c)
-- 	c.border_color = theme.border_color_active
-- end)

-- client.connect_signal("unfocus", function(c)
-- 	c.border_color = theme.bg_normal
-- end)

-- client.connect_signal("property::size", function(c)
-- 	c.border_width = theme.border_width
-- end)

awesome.connect_signal("exit", function(_)
	-- Persist last tags through exit/restart
	for s in screen do
		local f = assert(io.open("/tmp/awesome-screen-" .. tostring(s.index), "w+"))
		local t = s.selected_tag
		if f ~= nil then
			if t then
				f:write(t.index, "\n")
			end
			f:close()
		end
	end

	local f = assert(io.open("/tmp/awesome-focused", "w+"))
	if f ~= nil then
		f:write(awful.screen.focused().index, "\n")
		f:close()
	end
end)

for s in screen do
	screen[s]:connect_signal("arrange", function()
		local clients = awful.client.visible(s)
		local layout = awful.layout.getname(awful.layout.get(s))

		for _, c in pairs(clients) do
			c.ontop = false
			-- No titlebar with only one humanly visible client
			if c.maximized then
				c.border_width = 0
			elseif c.floating or layout == "floating" then
				c.border_width = theme.border_width
				c.ontop = true
			elseif layout == "max" or layout == "fullscreen" then
				c.border_width = 0
			else
				local tiled = awful.client.tiled(c.screen)
				if #tiled == 1 then -- and c == tiled[1] then
					c.border_width = 0
				else
					c.border_width = theme.border_width
				end
			end
		end
	end)
end

-- Setup keybindings
require("keys")

-- Load client rules
ruled.client.connect_signal("request::rules", require("rules")())

awful.mouse.append_global_mousebindings({
	awful.button({}, 4, awful.tag.viewprev),
	awful.button({}, 5, awful.tag.viewnext),
})

naughty.connect_signal("request::display", function(n)
	naughty.layout.box({ notification = n })
end)

-- Autorun
local xresources_name = "awesome.started"
local xresources = awful.util.pread("xrdb -query")
if not xresources:match(xresources_name) then
	awful.util.spawn_with_shell("xrdb -merge <<< " .. "'" .. xresources_name .. ":true'")
	-- Execute once for X server
	os.execute("dex --environment Awesome --autostart --search-paths $XDG_CONFIG_HOME/autostart")
	awful.spawn.with_shell("~/.config/awesome/autorun.sh")
end

-- Handle tags on screens that get removed
tag.connect_signal("request::screen", function(t)
	for s in screen do
		if s ~= t.screen then
			local t2 = awful.tag.find_by_name(s, t.name)
			if t2 then
				t:swap(t2)
			else
				t.screen = s
			end
			return
		end
	end
end)
