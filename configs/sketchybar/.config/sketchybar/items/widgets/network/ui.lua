local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

-- utils
require("items.widgets.network.popup")

local This = {}

This.up = Sbar.add("item", "widgets.network.up", {
  position = "right",
  padding_left = -2,
  width = 0,
  icon = {
    padding_right = 0,
    font = {
      style = settings.font.style_map["Bold"],
      size = 12.0,
    },
    string = icons.wifi.upload,
  },
  label = {
    font = {
      family = settings.font.nerd_family,
      style = settings.font.style_map["Heavy"],
      size = 12.0,
    },
    color = colors.red,
    string = "??? Bps",
  },
  y_offset = 7,
})

This.down = Sbar.add("item", "widgets.network.down", {
  position = "right",
  padding_left = -2,
  icon = {
    padding_right = 0,
    font = {
      style = settings.font.style_map["Bold"],
      size = 12.0,
    },
    string = icons.wifi.download,
  },
  label = {
    font = {
      family = settings.font.nerd_family,
      style = settings.font.style_map["Heavy"],
      size = 12.0,
    },
    color = colors.blue,
    string = "??? Bps",
  },
  y_offset = -7,
})

This.icon = Sbar.add("item", "widgets.network.icon", {
  position = "right",
  label = { drawing = false },
  icon = { drawing = not settings.slim, string = "?" },
})

-- Background around the item
This.bracket = Sbar.add("bracket", "widgets.network.bracket", {
  This.icon.name,
  This.up.name,
  This.down.name,
}, {
  background = { color = colors.bg1 },
  popup = { align = "center", height = 30 },
})

This.popup = ATTACH_POPUP(This.bracket)

Sbar.add("item", { position = "right", width = settings.group_paddings })

function This:set(arg)
  self.bracket:set(arg)
  self.icon:set(arg)
  self.up:set(arg)
  self.down:set(arg)
end

return This
