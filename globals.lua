local awful = require("awful")

local theme_name = "nord"
local modkey = "Mod4"
local theme_dir = string.format("%s%s/%s", awful.util.getdir("config"), "themes", theme_name)
local terminal = "alacritty"
local editor = os.getenv("VISUAL") or "emacs"
local editor_cmd = terminal .. " -e " .. (os.getenv("EDITOR") or "emacs")

return {
	theme = {
		name = "nord",
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
		lock = "i3lock",
		screenshot = "flameshot gui",
		media = {
			toggle = "playerctl -p mpd,spotify play-pause",
			["next"] = "playerctl -p mpd,spotify next",
			prev = "playerctl -p mpd,spotify prev",
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
