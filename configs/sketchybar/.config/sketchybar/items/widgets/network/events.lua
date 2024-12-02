local icons = require("icons")
local colors = require("colors")

local This = require("items.widgets.network.ui")

-- Execute the event provider binary which provides the event "network_update"
-- for the network interface "en0", which is fired every 2.0 seconds.
Sbar.exec(
  "killall network_load >/dev/null; $CONFIG_DIR/helpers/event_providers/network_load/bin/network_load en0 network_update 2.0"
)

local SHORT_UNITS = {
  Bps = "B",
  KBps = "K",
  MBps = "M",
  GBps = "G",
}

function shorten_measure(s)
  local speed = s:gsub("%D+", "")
  local units = s:gsub("%A+", "")
  return speed .. " " .. (SHORT_UNITS[units] or units)
end

This.up:subscribe("network_update", function(env)
  local up_color = (env.upload == "000 Bps") and colors.grey or colors.red
  local down_color = (env.download == "000 Bps") and colors.grey or colors.blue
  This.up:set({
    icon = { color = up_color },
    label = {
      string = shorten_measure(env.upload),
      color = up_color,
    },
  })
  This.down:set({
    icon = { color = down_color },
    label = {
      string = shorten_measure(env.download),
      color = down_color,
    },
  })
end)

This.icon:subscribe({ "wifi_change", "system_woke" }, function(env)
  Sbar.exec("ipconfig getifaddr en0", function(ip)
    local connected = not (ip == "")
    This.icon:set({
      icon = {
        string = connected and icons.wifi.on or icons.wifi.off,
        color = connected and colors.white or colors.red,
      },
    })
  end)
end)

local items = { This.up, This.down, This.icon }
for _, it in ipairs(items) do
  it:subscribe("mouse.clicked", function(env)
    local handled = SLIM_CLICK_HANDLER(This.icon, env, "icon")
    if handled then
      return
    end

    This.popup.toggle_popup()
  end)
  it:subscribe("mouse.exited", This.popup.hide_popup)
end
