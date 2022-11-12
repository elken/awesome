local awful = require("awful")
local gears = require("gears")
local theme = require("beautiful")
local keys = require("keys")
local fun = require("fun")

local mouse_buttons = {
	"LEFT",
	"MIDDLE",
	"RIGHT",
	"UP",
	"DOWN",
}

local define_button = function(mods, btn, action, desc, group)
	return awful.button(
		keys.map_mods(mods),
		fun.index(btn, mouse_buttons),
		action,
		{ description = desc, group = group }
	)
end

local click = function(c)
	c:emit_signal("request::activate", "mouse_click", { raise = true })
end

local client_buttons = gears.table.join(
	define_button({}, "LEFT", function(c)
		click(c)
	end, "Focus client", "Clients"),
	define_button({ "super" }, "LEFT", function(c)
		click(c)
		awful.mouse.client.move(c)
	end, "Move client", "Clients"),
	define_button({ "super" }, "RIGHT", function(c)
		click(c)
		awful.mouse.client.resize(c)
	end, "Resize client", "Clients")
)

return {
	-- All clients will match this rule.
	{
		rule = {},
		properties = {
			border_width = theme.border_width,
			border_color = theme.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			keys = keys.client_keys,
			buttons = client_buttons,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap + awful.placement.no_offscreen,
			maximized_vertical = false,
			maximized_horizontal = false,
		},
	},

	-- Floating clients.
	{
		rule_any = {
			instance = {
				"DTA", -- Firefox addon DownThemAll.
				"copyq", -- Includes session name in class.
				"pinentry",
			},
			class = {
				"Arandr",
				"Blueman-manager",
				"Gpick",
				"Kruler",
				"MessageWin", -- kalarm.
				"Sxiv",
				"Tor Browser", -- Needs a fixed window size to avoid fingerprinting by screen size.
				"Wpa_gui",
				"veromix",
				"xtightvncviewer",
			},

			-- Note that the name property shown in xprop might be set slightly after creation of the client
			-- and the name shown there might not match defined rules here.
			name = {
				"Event Tester", -- xev.
			},
			role = {
				"AlarmWindow", -- Thunderbird's calendar.
				"ConfigManager", -- Thunderbird's about:config.
				"pop-up", -- e.g. Google Chrome's (detached) Developer Tools.
			},
		},
		properties = { floating = true },
	},

	-- Add titlebars to normal clients and dialogs
	{ rule_any = { type = { "normal", "dialog" } }, properties = { titlebars_enabled = true } },

	-- Set Firefox to always map on the tag named "2" on screen 1.
	{ rule = { class = "Firefox" }, properties = { screen = 1, tag = "2" } },

	{ rule = { class = "Steam" }, properties = { screen = 1, tag = "3" } },

	-- Make Emacs fill properly
	{ rule = { class = "Emacs" }, properties = { size_hints_honor = false } },

	-- Fullscreen games
	{
		rules = {
			class = {
				"lor.exe",
				"Legends of Runeterra",
			},
			{ fullscreen = true },
			{ ontop = true },
		},
	},
}
