#!/usr/bin/env lua

local settings = require("settings")
local colors = require("colors")
local icons = require("icons")

--
-- UI
--

local memory = Sbar.add("graph", "widget.memory", 55, {
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
    string = icons.stats.memory,
    color = colors.text,
    drawing = not settings.slim,
  },
  label = {
    string = "mem ??%",
    color = colors.text,
    font = {
      size = 12.0,
      style = settings.font.style_map["Bold"],
    },
    align = "right",
    padding_right = 0,
    width = 0,
    y_offset = 4,
  },
  padding_right = settings.paddings + 3,
})

-- Background around the memory item
Sbar.add("bracket", "widgets.memory.bracket", { memory.name }, {
  background = { color = colors.bg1 },
})

-- Background around the memory item
Sbar.add("item", "widgets.memory.padding", {
  position = "right",
  width = settings.group_paddings,
})

--
-- Events
--

memory:subscribe({
  "routine",
  "forced",
  "system_woke",
}, function()
  Sbar.exec(
    "memory_pressure | grep 'System-wide memory free percentage:' | awk '{ printf(\"%02.0f\\n\", 100-$5\"%\") }'",
    function(memoryUsage)
      ADD_MEASURE(memory, "mem ", memoryUsage)
    end
  )
end)

memory:subscribe("mouse.clicked", function(env)
  local handled = SLIM_CLICK_HANDLER(memory, env, "icon")
  if handled then
    return
  end

  Sbar.exec("open -a 'Activity Monitor'")
end)

return memory
