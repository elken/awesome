local awful = require("awful")
local theme = require("beautiful")
local ruled = require("ruled")

local function screen_tag(screen_idx, tag_idx)
	if screen:count() == 1 then
		screen_idx = 1
	end

	return { screen = screen_idx, tag = screen[screen_idx].tags[tag_idx].name }
end

return function()
	-- All clients will match this rule.
	ruled.client.append_rule({
		id = "global",
		rule = {},
		properties = {
			border_width = theme.border_width,
			border_color = theme.border_normal,
			focus = awful.client.focus.filter,
			raise = true,
			screen = awful.screen.preferred,
			placement = awful.placement.no_overlap + awful.placement.no_offscreen,
			maximized_vertical = false,
			maximized_horizontal = false,
		},
	})

	-- Floating clients.
	ruled.client.append_rule({
		id = "floating",
		rule_any = {
			instance = { "copyq", "pinentry" },
			class = {
				"Arandr",
				"Blueman-manager",
				"Gpick",
				"Kruler",
				"Sxiv",
				"Tor Browser",
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
	})

	-- Set Firefox to always map on the tag named "2" on screen 1.
	ruled.client.append_rule({
		rule = { class = "Firefox" },
		properties = screen_tag(2, 2),
	})

	ruled.client.append_rule({
		rule = { class = "Slack" },
		properties = screen_tag(3, 3),
	})
	ruled.client.append_rule({
		rule = { class = "thunderbird" },
		properties = screen_tag(2, 3),
	})
	ruled.client.append_rule({
		rule = { class = "Spotify" },
		properties = screen_tag(1, 3),
	})

	-- All notifications will match this rule.
	ruled.notification.append_rule({
		rule = {},
		properties = {
			screen = awful.screen.preferred,
			implicit_timeout = 5,
		},
	})
end
