local awful = require("awful")

local theme_name = "nord"
local modkey = "Mod4"
local theme_dir = string.format("%s%s/%s", awful.util.getdir("config"), "themes", theme_name)
local terminal = "alacritty"
local editor = "emacs"
local editor_cmd = terminal .. " -e " .. (os.getenv("EDITOR") or "emacs")

return {
	theme = {
		name = theme_name,
		dir = theme_dir,
		path = string.format("%s/init.lua", theme_dir),
	},
	tools = {
		term = terminal,
		launcher = awful.util.get_xdg_config_home() .. "rofi/scripts/launcher_t1",
		browser = "firefox",
		file_manager = "nautilus",
		editor = editor,
		editor_cmd = editor_cmd,
		lock = "/home/elken/bin/lock",
		suspend = "systemctl suspend",
		reboot = "reboot",
		poweroff = "shutdown now",
		screenshot = "flameshot gui",
		media = {
			toggle = "playerctl -p spotify,mpd play-pause",
			["next"] = "playerctl -p spotify,mpd next",
			prev = "playerctl -p spotify,mpd previous",
		},
	},
	modkey = modkey,
	layouts = {
		awful.layout.suit.tile,
		awful.layout.suit.floating,
		awful.layout.suit.tile.left,
		awful.layout.suit.tile.bottom,
		awful.layout.suit.tile.top,
		awful.layout.suit.fair,
		awful.layout.suit.fair.horizontal,
		awful.layout.suit.spiral,
		awful.layout.suit.spiral.dwindle,
		awful.layout.suit.max,
		awful.layout.suit.max.fullscreen,
		awful.layout.suit.magnifier,
		awful.layout.suit.corner.nw,
	},
}
