local hotkeys_popup = require("awful.hotkeys_popup")
local awful = require("awful")
local fun = require("fun")
local globals = require("globals")

local map_mods = function(mods)
	local modifiers = {
		super = globals.modkey,
		shift = "Shift",
		meta = "Mod1",
		ctrl = "Control",
	}
	return fun.totable(fun.map(function(mod)
		return modifiers[mod]
	end, mods))
end

local define_key = function(mods, key, action, desc, group)
	return awful.key(map_mods(mods), key, action, { description = desc, group = group })
end

local define_cmd = function(mods, key, cmd, name, group)
	return define_key(mods, key, function()
		awful.spawn(cmd)
	end, name or string.format("Spawn %s", cmd:gsub("^%l", string.upper)), group or "Applications")
end

awful.keyboard.append_global_keybindings({
	awful.key({
		modifiers = { globals.modkey },
		keygroup = "numrow",
		description = "Select tag",
		group = "Tag Navigation",
		on_press = function(idx)
			local tag = awful.screen.focused().tags[idx]
			if tag then
				tag:view_only()
			end
		end,
	}),
	awful.key({
		modifiers = { "super", "ctrl" },
		keygroup = "numrow",
		description = "Toggle tag",
		group = "Tag Navigation",
		on_press = function(idx)
			local tag = awful.screen.focused().tags[idx]
			if tag then
				awful.tag.viewtoggle(tag)
			end
		end,
	}),
	awful.key({
		modifiers = { "super", "shift" },
		keygroup = "numrow",
		description = "Move focused client to tag",
		group = "Tag Navigation",
		on_press = function(idx)
			if client.focus then
				local tag = client.focus.screen.tags[idx]
				if tag then
					client.focus:move_to_tag(tag)
				end
			end
		end,
	}),
	awful.key({
		modifiers = { "ctrl", "super", "shift" },
		keygroup = "numrow",
		description = "Toggle focused client on tag",
		group = "Tag Navigation",
		on_press = function(idx)
			if client.focus then
				local tag = client.focus.screen.tags[idx]
				if tag then
					client.focus:toggle_tag(tag)
				end
			end
		end,
	}),
	awful.key({
		modifiers = { "ctrl", "super", "meta" },
		keygroup = "numrow",
		description = "Move focused client to tag on next screen",
		group = "Client Navigation",
		on_press = function(idx)
			if client.focus then
				client.focus:move_to_screen()
				local tag = client.focus.screen.tags[idx]
				if tag then
					client.focus:move_to_tag(tag)
					tag:view_only()
				end
			end
		end,
	}),
})

awful.keyboard.append_global_keybindings({
	-- Awesome
	define_key({ "super" }, "F1", hotkeys_popup.show_help, "Show this help", "Awesome"),
	define_key({ "ctrl", "super" }, "r", awesome.restart, "Restart", "Awesome"),
	-- Tag Navigation
	define_key({ "super" }, "Tab", awful.tag.viewnext, "View next tag", "Tag Navigation"),
	define_key({ "super", "shift" }, "Tab", awful.tag.viewprev, "View previous tag", "Tag Navigation"),
	-- Client Navigation
	define_key({ "super" }, "j", function()
		awful.client.focus.byidx(1)
	end, "Focus next client", "Client Navigation"),
	define_key({ "super" }, "k", function()
		awful.client.focus.byidx(-1)
	end, "Focus previous client", "Client Navigation"),
	-- Tag Layouts
	define_key({ "super" }, "space", function()
		awful.layout.inc(1)
	end, "Cycle next layout", "Tag Layouts"),
	define_key({ "super", "shift" }, "space", function()
		awful.layout.inc(-1)
	end, "Cycle previous layout", "Tag Layouts"),
	-- Screen Navigation
	define_key({ "ctrl", "super" }, "k", function()
		awful.screen.focus_relative(1)
	end, "Focus next screen", "Screen Navigation"),
	define_key({ "ctrl", "super" }, "j", function()
		awful.screen.focus_relative(-1)
	end, "Focus previous screen", "Screen Navigation"),
	-- Applications
	define_cmd({ "super" }, "Return", globals.tools.term),
	define_cmd({ "super" }, "b", globals.tools.browser),
	define_cmd({ "super" }, "r", globals.tools.launcher, "Spawn Rofi"),
	define_cmd({ "super" }, "e", globals.tools.editor, "Spawn Emacs"),
	define_cmd({ "super" }, "l", globals.tools.suspend, "Lock screen"),
	define_cmd({}, "Print", globals.tools.screenshot, "Take Screenshot", "Awesome"),
	define_cmd({}, "XF86AudioPlay", globals.tools.media.toggle, "Play/pause media item", "Media"),
	define_cmd({}, "XF86AudioNext", globals.tools.media.next, "Next media item", "Media"),
	define_cmd({}, "XF86AudioPrev", globals.tools.media.prev, "Previous media item", "Media"),
})

client.connect_signal("request::default_keybindings", function()
	awful.keyboard.append_client_keybindings({
		define_key({ "super" }, "o", function(c)
			c:move_to_screen()
		end, "Move client to other screen", "Clients"),

		define_key({ "super" }, "q", function(c)
			c:kill()
		end, "Kill focused client", "Clients"),

		define_key({ "super", "ctrl" }, "Return", function(c)
			if c then
				c:swap(awful.client.getmaster())
			end
		end, "Move to master", "Clients"),

		define_key({ "super" }, "f", function(c)
			c.maximized = not c.maximized
			c.fullscreen = not c.fullscreen
			c:raise()
		end, "Toggle fullscreen", "Clients"),
	})
end)
