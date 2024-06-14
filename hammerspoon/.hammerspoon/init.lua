hs.console.clearConsole()

local installSpoonsFlag = false

--
-- Spoons
--

local installSpoons = function()
  hs.loadSpoon("SpoonInstall")
  local Install = spoon.SpoonInstall
  Install.use_syncinstall = true
  Install:updateRepo("default")

  Install:installSpoonFromRepo("EmmyLua")
  Install:installSpoonFromRepo("KSheet")
end

if installSpoonsFlag then
  installSpoons()
end

-- LSP annotations for Hammerspoon
hs.loadSpoon("EmmyLua")

local hyper = require("hyper")
require("hyper.mapping")

-- Hotkey cheatsheet for any app.
local sheet = hs.loadSpoon("KSheet")
hyper.bindShiftKey("/", hs.fnutils.partial(sheet.toggle, sheet))

-- Super Duper mode (hold s and d), Ah Fudge mode (hold a and f). Hold 5 seconds for help.
require("keyboard") -- Load Hammerspoon bits from https://github.com/jasonrudolph/keyboard


local alert_sound = hs.sound.getByName("Tink")
alert_sound:play()
hs.notify.new({ title = "Hammerspoon", informativeText = "Ready to rock 🤘" }):send()
