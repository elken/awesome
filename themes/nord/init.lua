local globals = require("globals")
local dpi = require("beautiful.xresources").apply_dpi

local font_name = "Iosevka Nerd Font "
local default_font_size = dpi(11)
local interface_font = "Overpass "

return {
  font_name = font_name,
  default_font_size = default_font_size,
  font = font_name .. default_font_size,
  interface_font = interface_font,
  icon_theme = "ePapirus-Dark",
  wallpaper = globals.theme.dir .. "/wallpaper.png",
  useless_gap = dpi(4),
  gap_single_client = true,
  universalsize = dpi(24),
  spacing = dpi(10),
  bg_normal = "#2A303B",
  bg_accent1 = "#2A303B",
  bg_accent2 = "#323845",
  bg_accent3 = "#232935",
  transparent = "#00000000",
  bg_focus = "#4C566A",
  bg_urgent = "#000000",
  bg_systray = "#2A303B",
  fg_normal = "#DDEEFF",
  fg_urgent = "#FF0000",
  fg_focus = "#DDEEFF",
  fg_minimize = "#DDEEFF",
  border_width = dpi(1),
  border_normal = "#353B47",
  border_focus = "#5F6677",
  border_marked = "2C3040",
  notif_bg = "#2A303B",
  notification_max_width = 480,
  notification_max_height = 960,
  notification_icon_size = 96,
  notification_opacity = 0.95,
  notification_font = interface_font .. default_font_size,
  layout_tile = globals.theme.dir .. "/icons/tile.png",
  layout_fairh = globals.theme.dir .. "/icons/fairh.png",
  layout_fairv = globals.theme.dir .. "/icons/fairv.png",
  layout_floating = globals.theme.dir .. "/icons/floating.png",
  layout_magnifier = globals.theme.dir .. "/icons/magnifier.png",
  layout_max = globals.theme.dir .. "/icons/max.png",
  layout_fullscreen = globals.theme.dir .. "/icons/fullscreen.png",
  layout_tilebottom = globals.theme.dir .. "/icons/tilebottom.png",
  layout_tileleft = globals.theme.dir .. "/icons/tileleft.png",
  layout_tiletop = globals.theme.dir .. "/icons/tiletop.png",
  layout_spiral = globals.theme.dir .. "/icons/spiral.png",
  layout_dwindle = globals.theme.dir .. "/icons/dwindle.png",
  awesome_icon = globals.theme.dir .. "/icons/awesome.png",
}
