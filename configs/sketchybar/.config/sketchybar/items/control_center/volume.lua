#!/usr/bin/env lua

local colors = require("colors")
local icons = require("icons")
local settings = require("settings")

-- Unload the macOS on screen indicator overlay for volume change
Sbar.exec("launchctl unload -F /System/Library/LaunchAgents/com.apple.OSDUIHelper.plist >/dev/null 2>&1 &")

local volume = {}
local popup_width = 250

volume.icon = Sbar.add("item", "volume.icon", {
  position = "right",
  icon = {
    string = icons.volume._100,
    width = 25,
    align = "left",
    font = {
      style = settings.font.style_map["Bold"],
      size = 15.0,
    },
  },
  label = {
    drawing = not settings.slim,
    width = 30,
    align = "left",
  },
  popup = { align = "center" },
})

volume.slider = Sbar.add("slider", "volume.slider", 100, {
  position = "popup." .. volume.icon.name,
  updates = true,
  slider = {
    highlight_color = colors.blue,
    width = popup_width,
    background = {
      height = 6,
      corner_radius = 3,
      color = colors.bg2,
    },
    knob = {
      string = "􀀁",
      drawing = false,
    },
  },
})

volume.slider:subscribe("mouse.clicked", function(env)
  Sbar.exec("osascript -e 'set volume output volume " .. env["PERCENTAGE"] .. "'")
end)

volume.slider:subscribe("volume_change", function(env)
  local new_volume = tonumber(env.INFO)
  local icon = icons.volume._0

  if new_volume > 60 then
    icon = icons.volume._100
  elseif new_volume > 30 then
    icon = icons.volume._66
  elseif new_volume > 10 then
    icon = icons.volume._33
  elseif new_volume > 0 then
    icon = icons.volume._10
  end

  volume.icon:set({ icon = icon })
  volume.icon:set({ label = new_volume .. "%" })
  volume.slider:set({ slider = { percentage = new_volume } })
end)

local function volume_collapse_details()
  local drawing = volume.icon:query().popup.drawing == "on"
  if not drawing then
    return
  end
  volume.icon:set({ popup = { drawing = false } })
  Sbar.remove("/volume.device\\.*/")
end

local current_audio_device = "None"
local function volume_toggle_details(env)
  local handled = SLIM_CLICK_HANDLER(volume.icon, env)
  if handled then
    return
  end

  if env.BUTTON == "right" then
    Sbar.exec("open /System/Library/PreferencePanes/Sound.prefpane")
    return
  end

  local should_draw = volume.icon:query().popup.drawing == "off"
  if should_draw then
    volume.icon:set({ popup = { drawing = true } })
    Sbar.exec("SwitchAudioSource -t output -c", function(result)
      current_audio_device = result:sub(1, -2)
      Sbar.exec("SwitchAudioSource -a -t output", function(available)
        local current = current_audio_device
        local counter = 0

        for device in string.gmatch(available, "[^\r\n]+") do
          local color = colors.grey
          if current == device then
            color = colors.white
          end
          Sbar.add("item", "volume.device." .. counter, {
            position = "popup." .. volume.icon.name,
            width = popup_width,
            align = "center",
            label = { string = device, color = color },
            click_script = 'SwitchAudioSource -s "'
              .. device
              .. '" && sketchybar --set /volume.device\\.*/ label.color='
              .. colors.grey
              .. " --set $NAME label.color="
              .. colors.white,
          })
          counter = counter + 1
        end
      end)
    end)
  else
    volume_collapse_details()
  end
end

local function volume_scroll(env)
  local delta = env.INFO.delta
  if not (env.INFO.modifier == "ctrl") then
    delta = delta * 10.0
  end

  Sbar.exec('osascript -e "set volume output volume (output volume of (get volume settings) + ' .. delta .. ')"')
end

volume.icon:subscribe("mouse.clicked", volume_toggle_details)

volume.icon:subscribe("mouse.scrolled", volume_scroll)
volume.slider:subscribe("mouse.scrolled", volume_scroll)

volume.icon:subscribe("mouse.exited.global", volume_collapse_details)

return volume
