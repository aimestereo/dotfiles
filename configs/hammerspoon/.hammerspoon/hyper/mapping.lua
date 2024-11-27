-- Load and install the Hyper key extension. Binding to F18
local hyper = require("hyper")

hyper.install("F18")

-- Quick Reloading of Hammerspoon
hyper.bindKey("r", hs.reload)

-- Global Application Keyboard Shortcuts
hyper.bindKey("m", hyper.appHandler("com.apple.mail"))
hyper.bindShiftKey("m", hyper.appHandler("com.apple.Music"))

hyper.bindKey("f", hyper.appHandler("net.kovidgoyal.kitty"))

hyper.bindKey("d", hyper.appHandler("com.apple.finder"))

hyper.bindKey("a", hyper.appHandler("company.thebrowser.Browser"))

hyper.bindKey("s", hyper.appHandler("com.tinyspeck.slackmacgap"))
hyper.bindKey("t", hyper.appHandler("com.tdesktop.Telegram"))
-- hyper.bindKey("d", hyper.appHandler("com.hnc.Discord"))
--
hyper.bindKey("o", hyper.appHandler("md.obsidian"))
hyper.bindKey("z", hyper.appHandler("us.zoom.xos"))
hyper.bindKey("v", hyper.appHandler("com.apple.Preview"))

hyper.bindKey("\\", hyper.appHandler("com.1password.1password"))

hyper.bindKey("p", hyper.appHandler("com.postmanlabs.mac"))
hyper.bindShiftKey("p", hyper.appHandler("com.jetbrains.pycharm"))

hyper.bindKey("c", hyper.appHandler("com.apple.iCal"))

hyper.bindKey(".", hyper.appHandler("com.runningwithcrayons.Alfred-Preferences"))
hyper.bindKey(",", hyper.appHandler("com.apple.systempreferences"))

-- Show the bundleID of the currently open window
hyper.bindKey("b", function()
  local bundleId = hs.window.focusedWindow():application():bundleID()
  hs.alert.show(bundleId)
  hs.pasteboard.setContents(bundleId)
end)
