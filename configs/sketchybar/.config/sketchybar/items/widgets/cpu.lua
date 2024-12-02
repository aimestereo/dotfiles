local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- Execute the event provider binary which provides the event "cpu_update" for
-- the cpu load data, which is fired every 2.0 seconds.
Sbar.exec("killall cpu_load >/dev/null; $CONFIG_DIR/helpers/event_providers/cpu_load/bin/cpu_load cpu_update 2.0")

--
-- UI
--

local cpu = Sbar.add("graph", "widgets.cpu", 55, {
  position = "right",
  graph = { color = colors.blue },
  background = {
    height = 22,
    color = { alpha = 0 },
    border_color = { alpha = 0 },
    drawing = true,
  },
  icon = {
    string = icons.stats.cpu,
    drawing = not settings.slim,
  },
  label = {
    string = "cpu ??%",
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

-- Background around the cpu item
Sbar.add("bracket", "widgets.cpu.bracket", { cpu.name }, {
  background = { color = colors.bg1 },
})

-- Background around the cpu item
Sbar.add("item", "widgets.cpu.padding", {
  position = "right",
  width = settings.group_paddings,
})

--
-- Events
--

cpu:subscribe("cpu_update", function(env)
  -- Also available: env.user_load, env.sys_load
  ADD_MEASURE(cpu, "cpu ", env.total_load)
end)

cpu:subscribe("mouse.clicked", function(env)
  local handled = SLIM_CLICK_HANDLER(cpu, env, "icon")
  if handled then
    return
  end

  Sbar.exec("open -a 'Activity Monitor'")
end)

return cpu
