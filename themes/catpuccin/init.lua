local globals = require("globals")
local gears = require("gears")
local dpi = require("beautiful.xresources").apply_dpi

local font_name = "Iosevka Nerd Font "
local default_font_size = dpi(11)

local theme = {}
local colors = {
	"#f5e0dc", -- 1 Rosewater
	"#f2cdcd", -- 2 Flamingo
	"#f5c2e7", -- 2 Pink
	"#cba6f7", -- 3 Mauve
	"#f38ba8", -- 4 Red
	"#eba0ac", -- 5 Maroon
	"#fab387", -- 6 Peach
	"#f9e2af", -- 7 Yellow
	"#a6e3a1", -- 8 Green
	"#94e2d5", -- 9 Teal
	"#89dceb", -- 10 Sky
	"#74c7ec", -- 11 Sapphire
	"#89b4fa", -- 12 Blue
	"#b4befe", -- 13 Lavender
	"#cdd6f4", -- 14 Text
	"#bac2de", -- 15 Subtext3
	"#a6adc8", -- 16 Subtext2
	"#9399b2", -- 17 Overlay4
	"#7f849c", -- 18 Overlay3
	"#6c7086", -- 19 Overlay2
	"#585b70", -- 20 Surface4
	"#45475a", -- 21 Surface3
	"#313244", -- 22 Surface2
	"#1e1e2e", -- 23 Base
	"#181825", -- 24 Mantle
	"#11111b", -- 25 Crust
}

-- Global setup
theme.colors = colors
theme.primary_colour = colors[5]

-- Default variables
theme.useless_gap = dpi(4)
theme.font = font_name .. default_font_size
theme.font_name = font_name
theme.default_font_size = default_font_size
theme.bg_normal = colors[23]
theme.bg_focus = theme.primary_colour
theme.bg_urgent = colors[4]
theme.fg_normal = colors[15]
theme.fg_focus = colors[25]
theme.fg_urgent = colors[1]
theme.wallpaper = globals.theme.dir .. "/wallpaper.png"
theme.bg_systray = theme.bg_normal
theme.border_color_active = theme.primary_colour
theme.border_color_normal = colors[23]
theme.border_color_urgent = colors[4]
theme.border_width = dpi(1)
theme.transparent = "#00000000"

-- awesome
theme.awesome_icon = globals.theme.dir .. "/icons/awesome.png"

-- fullscreen
theme.fullscreen_hide_border = true

-- gap
theme.gap_single_client = true

-- hotkeys
theme.hotkeys_bg = colors[25]
theme.hotkeys_fg = colors[14]
theme.hotkeys_shape = gears.shape.rounded_rect
theme.hotkeys_label_fg = colors[23]
theme.hotkeys_modifiers_fg = colors[6]

-- icon
theme.icon_theme = "ePapirus-Dark"

-- layout
local layouts = {
	"cornernw",
	"cornerne",
	"cornersw",
	"cornerse",
	"fairh",
	"fairv",
	"floating",
	"magnifier",
	"max",
	"fullscreen",
	"spiral",
	"dwindle",
	"tile",
	"tiletop",
	"tilebottom",
	"tileleft",
}

for _, name in ipairs(layouts) do
	theme["layout_" .. name] = globals.theme.dir .. "/icons/" .. name .. ".png"
end

-- maximized
theme.maximized_hide_border = true

-- notification
-- theme.notification_max_width = nil
-- theme.notification_position = nil
-- theme.notification_action_underline_normal = nil
-- theme.notification_action_underline_selected = nil
-- theme.notification_action_icon_only = nil
-- theme.notification_action_label_only = nil
-- theme.notification_action_shape_normal = nil
-- theme.notification_action_shape_selected = nil
-- theme.notification_action_shape_border_color_normal = nil
-- theme.notification_action_shape_border_color_selected = nil
-- theme.notification_action_shape_border_width_normal = nil
-- theme.notification_action_shape_border_width_selected = nil
-- theme.notification_action_icon_size_normal = nil
-- theme.notification_action_icon_size_selected = nil
-- theme.notification_action_bg_normal = nil
-- theme.notification_action_bg_selected = nil
-- theme.notification_action_fg_normal = nil
-- theme.notification_action_fg_selected = nil
-- theme.notification_action_bgimage_normal = nil
-- theme.notification_action_bgimage_selected = nil
-- theme.notification_shape_normal = nil
-- theme.notification_shape_selected = nil
-- theme.notification_shape_border_color_normal = nil
-- theme.notification_shape_border_color_selected = nil
-- theme.notification_shape_border_width_normal = nil
-- theme.notification_shape_border_width_selected = nil
-- theme.notification_icon_size_normal = nil
-- theme.notification_icon_size_selected = nil
-- theme.notification_bg_normal = nil
-- theme.notification_bg_selected = nil
-- theme.notification_fg_normal = nil
-- theme.notification_fg_selected = nil
-- theme.notification_bgimage_normal = nil
-- theme.notification_bgimage_selected = nil
-- theme.notification_font = nil
-- theme.notification_bg = nil
-- theme.notification_fg = nil
-- theme.notification_border_width = nil
-- theme.notification_border_color = nil
-- theme.notification_shape = nil
-- theme.notification_opacity = nil
-- theme.notification_margin = nil
-- theme.notification_width = nil
-- theme.notification_height = nil
-- theme.notification_spacing = nil
-- theme.notification_icon_resize_strategy = nil
-- theme.notification_icon_size = nil

-- systray
theme.systray_icon_spacing = dpi(1)

-- taglist
theme.taglist_bg_focus = theme.primary_colour

-- tasklist
theme.tasklist_bg_focus = theme.bg_focus
theme.tasklist_fg_focus = theme.fg_focus
theme.tasklist_disable_icon = true

-- wibar
theme.wibar_shape = gears.shape.rounded_rect

return theme
