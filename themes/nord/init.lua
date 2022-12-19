local globals = require("globals")
local gears = require("gears")
local dpi = require("beautiful.xresources").apply_dpi

local font_name = "Iosevka Nerd Font "
local default_font_size = dpi(11)

local theme = {}
local colors = {
	"#2e3440", -- 1
	"#3b4252", -- 2
	"#434c5e", -- 3
	"#4c566a", -- 4
	"#d8dee9", -- 5
	"#e5e9f0", -- 6
	"#eceff4", -- 7
	"#8fbcbb", -- 8
	"#88c0d0", -- 9
	"#81a1c1", -- 10
	"#5e81ac", -- 11
	"#bf616a", -- 12
	"#d08770", -- 13
	"#ebcb8b", -- 14
	"#a3be8c", -- 15
	"#b48ead", -- 16
}

-- Default variables
theme.colors = colors
theme.useless_gap = dpi(4)
theme.font = font_name .. default_font_size
theme.font_name = font_name
theme.default_font_size = default_font_size
theme.bg_normal = colors[2]
theme.bg_focus = colors[3]
theme.bg_urgent = colors[12]
theme.bg_minimize = colors[1]
theme.fg_normal = colors[7]
theme.fg_focus = colors[6]
theme.fg_urgent = colors[5]
theme.fg_minimize = colors[4]
theme.wallpaper = globals.theme.dir .. "/wallpaper.png"
theme.bg_systray = theme.bg_normal
theme.border_color_active = colors[11]
theme.border_color_normal = colors[2]
theme.border_color_urgent = colors[12]
theme.border_width = dpi(1)
theme.transparent = "#00000000"

-- awesome
theme.awesome_icon = globals.theme.dir .. "/icons/awesome.png"

-- fullscreen
theme.fullscreen_hide_border = true

-- gap
theme.gap_single_client = true

-- hotkeys
theme.hotkeys_bg = colors[1]
theme.hotkeys_fg = colors[7]
theme.hotkeys_shape = gears.shape.rounded_rect
theme.hotkeys_label_fg = colors[2]
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
theme.taglist_bg_focus = colors[10]

-- tasklist
theme.tasklist_bg_focus = colors[3]
theme.tasklist_bg_normal = colors[1]
theme.tasklist_disable_icon = true

-- wibar
theme.wibar_shape = gears.shape.rounded_rect

return theme
