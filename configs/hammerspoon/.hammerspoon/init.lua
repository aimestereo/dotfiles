hs.console.clearConsole()

local spoons = require("spoons")
spoons.init({ install = true })

-- LSP annotations for Hammerspoon
hs.loadSpoon("EmmyLua")

-- Hyper mode: "f18" (CapsLock→F18 via hidutil) or "quad" (CapsLock→Cmd+Ctrl+Alt+Shift via Karabiner)
local HYPER_MODE = "quad"

if HYPER_MODE == "f18" then
  local hyper = require("hyper")
  require("hyper.mapping")

  local sheet = hs.loadSpoon("KSheet")
  hyper.bindShiftKey("/", hs.fnutils.partial(sheet.toggle, sheet))

  local menusearch = require("menusearch")
  hyper.bindKey("/", menusearch.toggle)

  local keyboard = require("keyboard")
  hyper.bindKey("w", keyboard.windows.toggle)

  local drawonscreen = require("drawonscreen")
  hyper.bindKey("i", drawonscreen.start)
else
  require("quad-mapping")

  local HYPER = { "cmd", "ctrl", "alt", "shift" }

  local menusearch = require("menusearch")
  hs.hotkey.bind(HYPER, "/", menusearch.toggle)
end

-- End
local alert_sound = hs.sound.getByName("Tink")
alert_sound:play()
hs.notify.new({ title = "Hammerspoon", informativeText = "Ready to rock 🤘" }):send()
