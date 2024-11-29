#!/usr/bin/env lua

local settings = require("settings")
local utils = require("items.control_center.battery.utils")

--
-- UI
--

local battery = Sbar.add("item", "battery", {
  position = "right",
  icon = {
    font = {
      family = settings.font.nerd_family,
      style = "Regular",
      size = 19.0,
    },
  },
  label = { drawing = false },
  update_freq = 30,
  popup = { align = "center" },
})

battery.details = Sbar.add("item", "battery.details", {
  position = "popup." .. battery.name,
  icon = { drawing = false },
  label = {
    string = "??% - ??:??h",
    width = 150,
    align = "center",
    font = { style = "Bold", size = 16.0 },
  },
})

--
-- Update
--

battery:subscribe({
  "routine",
  "forced",
  "power_source_change",
  "system_woke",
}, function(_)
  Sbar.exec("pmset -g batt", function(batt_info)
    local percent, icon = utils.parse_battery_info(batt_info)

    if percent < 50 then
      battery:set({
        icon = icon,
        label = { string = percent .. "%", drawing = true },
      })
    else
      battery:set({
        icon = icon,
        label = { string = percent .. "%", drawing = false },
      })
    end
  end)
end)

--
-- Hide/Show Popup
--

local function show_battery_popup()
  Sbar.exec("pmset -g batt", function(batt_info)
    local percent = utils.parse_battery_percent(batt_info)
    local remaining = utils.parse_battery_remaining(batt_info)

    -- battery:set({ label = { drawing = true } })
    battery.details:set({
      label = percent .. "% - " .. remaining,
    })
  end)
end

local function hide_battery_popup()
  battery:set({ popup = { drawing = false } })
end

battery:subscribe({
  "mouse.exited",
  "mouse.exited.global",
}, function(_)
  hide_battery_popup()
end)

battery:subscribe({
  "mouse.entered",
}, function(_)
  battery:set({ popup = { drawing = true } })
  show_battery_popup()
end)

battery:subscribe("mouse.clicked", function(_)
  local drawing = battery:query().popup.drawing
  battery:set({ popup = { drawing = "toggle" } })

  if drawing == "off" then
    show_battery_popup()
  else
    hide_battery_popup()
  end
end)

return battery
