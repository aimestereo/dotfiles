local icons = require("icons")
local colors = require("colors")
local settings = require("settings")

local popup_width = 250

function ATTACH_POPUP(item)
  local popup = {}

  popup.popup_ssid = Sbar.add("item", {
    position = "popup." .. item.name,
    icon = {
      font = {
        style = settings.font.style_map["Bold"],
      },
      string = icons.wifi.router,
    },
    width = popup_width,
    align = "center",
    label = {
      font = {
        size = 15,
        style = settings.font.style_map["Bold"],
      },
      max_chars = 18,
      string = "????????????",
    },
    background = {
      height = 2,
      color = colors.grey,
      y_offset = -15,
    },
  })

  popup.popup_hostname = Sbar.add("item", {
    position = "popup." .. item.name,
    icon = {
      align = "left",
      string = "Hostname:",
      width = popup_width / 2,
    },
    label = {
      max_chars = 20,
      string = "????????????",
      width = popup_width / 2,
      align = "right",
    },
  })

  popup.popup_ip = Sbar.add("item", {
    position = "popup." .. item.name,
    icon = {
      align = "left",
      string = "IP:",
      width = popup_width / 2,
    },
    label = {
      string = "???.???.???.???",
      width = popup_width / 2,
      align = "right",
    },
  })

  popup.popup_mask = Sbar.add("item", {
    position = "popup." .. item.name,
    icon = {
      align = "left",
      string = "Subnet mask:",
      width = popup_width / 2,
    },
    label = {
      string = "???.???.???.???",
      width = popup_width / 2,
      align = "right",
    },
  })

  popup.popup_router = Sbar.add("item", {
    position = "popup." .. item.name,
    icon = {
      align = "left",
      string = "Router:",
      width = popup_width / 2,
    },
    label = {
      string = "???.???.???.???",
      width = popup_width / 2,
      align = "right",
    },
  })

  popup.hide_popup = function()
    item:set({ popup = { drawing = false } })
  end

  popup.toggle_popup = function()
    local should_draw = item:query().popup.drawing == "off"
    if should_draw then
      item:set({ popup = { drawing = true } })
      Sbar.exec("networksetup -getcomputername", function(result)
        popup.popup_hostname:set({ label = result })
      end)
      Sbar.exec("ipconfig getifaddr en0", function(result)
        popup.popup_ip:set({ label = result })
      end)
      Sbar.exec("ipconfig getsummary en0 | awk -F ' SSID : '  '/ SSID : / {print $2}'", function(result)
        popup.popup_ssid:set({ label = result })
      end)
      Sbar.exec("networksetup -getinfo Wi-Fi | awk -F 'Subnet mask: ' '/^Subnet mask: / {print $2}'", function(result)
        popup.popup_mask:set({ label = result })
      end)
      Sbar.exec("networksetup -getinfo Wi-Fi | awk -F 'Router: ' '/^Router: / {print $2}'", function(result)
        popup.popup_router:set({ label = result })
      end)
    else
      popup.hide_popup()
    end
  end

  -- Copy value on click

  popup.copy_label_to_clipboard = function(env)
    local label = Sbar.query(env.NAME).label.value
    Sbar.exec('echo "' .. label .. '" | pbcopy')
    Sbar.set(env.NAME, { label = { string = icons.clipboard, align = "center" } })
    Sbar.delay(1, function()
      Sbar.set(env.NAME, { label = { string = label, align = "right" } })
    end)
  end

  popup.popup_ssid:subscribe("mouse.clicked", popup.copy_label_to_clipboard)
  popup.popup_hostname:subscribe("mouse.clicked", popup.copy_label_to_clipboard)
  popup.popup_ip:subscribe("mouse.clicked", popup.copy_label_to_clipboard)
  popup.popup_mask:subscribe("mouse.clicked", popup.copy_label_to_clipboard)
  popup.popup_router:subscribe("mouse.clicked", popup.copy_label_to_clipboard)

  return popup
end
