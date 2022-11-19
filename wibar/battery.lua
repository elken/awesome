local wibox = require("wibox")
local gears = require("gears")
local awful = require("awful")
local theme = require("beautiful")

local function to_time_ago(seconds)
	local days = seconds / 86400
	if days > 1 then
		days = math.floor(days + 0.5)
		return days .. (days == 1 and " day" or " days")
	end

	local hours = (seconds % 86400) / 3600
	if hours > 1 then
		hours = math.floor(hours + 0.5)
		return hours .. (hours == 1 and " hour" or " hours")
	end

	local minutes = ((seconds % 86400) % 3600) / 60
	if minutes > 1 then
		minutes = math.floor(minutes + 0.5)
		return minutes .. (minutes == 1 and " minute" or " minutes")
	end
end

local battery_bar = wibox.widget({
	max_value = 1,
	value = 0.5,
	forced_width = 100,
	paddings = 1,
	shape = gears.shape.rounded_bar,
	widget = wibox.widget.progressbar,
})

local battery_text = wibox.widget({
	text = " N/A",
	widget = wibox.widget.textbox,
})

local battery_widget = wibox.widget({
	battery_bar,
	battery_text,
	layout = wibox.layout.stack,
})

awful.widget.watch("cat /sys/class/power_supply/BAT0/uevent", 5, function(_, stdout)
	local battery = {}
	for line in stdout:gmatch("[^\r\n]+") do
		for k, v in line:gmatch("(.+)=(.+)") do
			battery[k] = v
		end
	end

	local capacity = tonumber(battery.POWER_SUPPLY_CAPACITY)
	local seconds_left = (battery.POWER_SUPPLY_CHARGE_NOW / battery.POWER_SUPPLY_CURRENT_NOW) * 3600
	local time_left = os.date("*t", math.floor(seconds_left))

	local color = "#008800"

	if capacity == 100 then
		color = "#008800"
	elseif capacity < 80 then
		color = "#AB7300"
	else
		color = "#880000"
	end

	battery_bar.color = color
	battery_bar.background_color = color

	battery_bar:set_value(capacity / 100)
	if battery.POWER_SUPPLY_STATUS == "Charging" then
		battery_text:set_text(" ")
	elseif battery.POWER_SUPPLY_STATUS == "Full" then
		battery_widget.visible = false
	else
		battery_text:set_text(string.format(" %02d:%02d:%02d", time_left.hour, time_left.min, time_left.sec))
	end
end)

return battery_widget
