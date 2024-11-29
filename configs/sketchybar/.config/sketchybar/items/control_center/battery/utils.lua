local colors = require("colors")
local thresholds = require("items.control_center.battery.thresholds")

local This = {}

This.parse_battery_percent = function(batt_info)
  local percent = 0
  local found, _, charge = batt_info:find("(%d+)%%")
  if found then
    percent = tonumber(charge)
  end
  return percent
end

This.parse_battery_remaining = function(batt_info)
  local found, _, remaining = batt_info:find(" (%d+:%d+) remaining")
  local label = found and remaining .. "h" or "No estimate"
  return label
end

This.parse_battery_info = function(batt_info)
  local icon = "!"
  local color = colors.green
  local charging = string.find(batt_info, "AC Power")
  local percent = This.parse_battery_percent(batt_info)

  for _, threshold in ipairs(thresholds) do
    if percent >= threshold.percent then
      icon = charging and threshold.charging_icon or threshold.non_charging_icon
      color = threshold.color
      return percent, { string = icon, color = color }
    end
  end

  error("bettery percent doesn't match any threshold, percent=" .. percent)
end

return This
