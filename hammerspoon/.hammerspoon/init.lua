hs.console.clearConsole()

local nohyper = { "alt" }
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

-- Hotkey cheatsheet for any app.
local sheet = hs.loadSpoon("KSheet")
sheet:bindHotkeys({ toggle = { nohyper, "/" } })

-- Super Duper mode (hold s and d), Ah Fudge mode (hold a and f). Hold 5 seconds for help.
require("keyboard") -- Load Hammerspoon bits from https://github.com/jasonrudolph/keyboard

--
-- Hyper key
--

-- Load and install the Hyper key extension. Binding to F18
local hyper = require("hyper")

hyper.install("F18")

-- Quick Reloading of Hammerspoon
hyper.bindKey("r", hs.reload)

-- Global Application Keyboard Shortcuts
hyper.bindKey("m", hyper.appHandler("com.apple.mail"))
hyper.bindCommandKey("m", hyper.appHandler("com.apple.Music"))

hyper.bindKey("f", hyper.appHandler("net.kovidgoyal.kitty"))
hyper.bindCommandKey("f", hyper.appHandler("com.apple.Terminal"))

hyper.bindKey("d", hyper.appHandler("com.apple.finder"))
hyper.bindKey("a", hyper.appHandler("company.thebrowser.Browser"))
hyper.bindKey("w", hyper.appHandler("com.google.Chrome"))
hyper.bindKey("s", hyper.appHandler("com.tinyspeck.slackmacgap"))
-- hyper.bindKey("d", hyper.appHandler("com.hnc.Discord"))
hyper.bindKey("o", hyper.appHandler("md.obsidian"))
hyper.bindKey("z", hyper.appHandler("us.zoom.xos"))
hyper.bindKey("v", hyper.appHandler("com.jelleglebbeek.youtube-dl-gui"))

hyper.bindKey("p", hyper.appHandler("com.1password.1password"))
hyper.bindCommandKey("p", hyper.appHandler("com.postmanlabs.mac"))
hyper.bindShiftKey("p", hyper.appHandler("com.jetbrains.pycharm"))

-- hyper.bindKey("c", hyper.appHandler("com.apple.iCal"))
hyper.bindKey("c", hyper.appHandler("com.flexibits.fantastical2.mac"))
hyper.bindCommandKey("c", hyper.appHandler("so.amie.electron-app"))

hyper.bindKey(".", hyper.appHandler("com.runningwithcrayons.Alfred-Preferences"))
hyper.bindKey(",", hyper.appHandler("com.apple.systempreferences"))

-- Show the bundleID of the currently open window
hyper.bindKey("b", function()
  local bundleId = hs.window.focusedWindow():application():bundleID()
  hs.alert.show(bundleId)
  hs.pasteboard.setContents(bundleId)
end)

--
-- / Hyper
--

hs.alert.show("Hammerspoon, at your service.", 2)
