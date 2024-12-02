#!/usr/bin/env lua

local settings = require("settings")
local colors = require("colors")
local icons = require("icons")

--
-- UI
--

local disk = Sbar.add("graph", "disk", 60, {
  update_freq = 2,
  position = "right",
  graph = { color = colors.blue },
  background = {
    height = 22,
    color = { alpha = 0 },
    border_color = { alpha = 0 },
    drawing = true,
  },
  icon = {
    string = icons.stats.disk,
    drawing = not settings.slim,
  },
  label = {
    string = "disk ??%",
    font = {
      size = 12.0,
      style = settings.font.style_map["Bold"],
    },
    align = "right",
    padding_right = 3,
    width = 0,
    y_offset = 4,
  },
})

-- Background around the disk item
Sbar.add("bracket", "widgets.disk.bracket", { disk.name }, {
  background = { color = colors.bg1 },
})

-- Background around the disk item
Sbar.add("item", "widgets.disk.padding", {
  position = "right",
  width = settings.group_paddings,
})

--
-- Events
--

disk:subscribe({
  "routine",
  "forced",
  "system_woke",
}, function()
  Sbar.exec("df -H | grep -E '^(/dev/disk3s1s1 ).' | awk '{ printf (\"%s\\n\", $5) }'", function(diskUsage)
    ADD_MEASURE(disk, "disk ", diskUsage)
  end)
end)

disk:subscribe("mouse.clicked", function(env)
  local handled = SLIM_CLICK_HANDLER(disk, env, "icon")
  if handled then
    return
  end

  Sbar.exec("open -a 'Activity Monitor'")
end)

return disk
