local settings = require("settings")
local colors = require("colors")

local layout_query =
  'defaults read ~/Library/Preferences/com.apple.HIToolbox.plist AppleSelectedInputSources | grep "KeyboardLayout Name" | cut -c 33- | rev | cut -c 2- | rev'

local layouts_labels = {
  ABC = "US",
  Russian = "RU",
}

local keyboard = sbar.add("item", "widgets.keyboard", {
  position = "right",
  icon = { drawing = false },
  label = {
    string = "??",
    font = { family = settings.font.numbers },
  },
})

sbar.add("bracket", "widgets.keyboard.bracket", {
  keyboard.name,
}, {
  background = { color = colors.bg1 },
})

sbar.add("item", "widgets.keyboard.padding", {
  position = "right",
  width = settings.group_paddings,
})

sbar.add("event", "keyboard_change", "AppleSelectedInputSourcesChangedNotification")

local function update_keyboard_label()
  sbar.exec(layout_query, function(output)
    local layout = string.gsub(output, "%s+", "")
    local label = layouts_labels[layout]
    keyboard:set({ label = label })
  end)
end

keyboard:subscribe("keyboard_change", function(env)
  update_keyboard_label()
end)

-- Init
update_keyboard_label()
