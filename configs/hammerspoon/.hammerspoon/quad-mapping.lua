local am = require("hyper.app-management")
local drawonscreen = require("drawonscreen.drawing")

local HYPER = { "cmd", "ctrl", "alt", "shift" }

local function switchApp(bundleID)
  return function()
    am.switchToAndFromApp(bundleID)
  end
end

-- Reload
hs.hotkey.bind(HYPER, "r", hs.reload)

-- Apps
hs.hotkey.bind(HYPER, "a", switchApp("company.thebrowser.Browser"))
hs.hotkey.bind(HYPER, "b", switchApp("com.google.Chrome"))
hs.hotkey.bind(HYPER, "c", switchApp("com.apple.iCal"))
hs.hotkey.bind(HYPER, "d", switchApp("net.kovidgoyal.kitty"))
hs.hotkey.bind(HYPER, "e", switchApp("com.apple.finder"))
hs.hotkey.bind(HYPER, "m", switchApp("ru.yandex.desktop.music"))
hs.hotkey.bind(HYPER, "o", switchApp("md.obsidian"))
hs.hotkey.bind(HYPER, "p", switchApp("com.postmanlabs.mac"))
hs.hotkey.bind(HYPER, "s", switchApp("com.tinyspeck.slackmacgap"))
hs.hotkey.bind(HYPER, "t", switchApp("com.tdesktop.Telegram"))
hs.hotkey.bind(HYPER, "v", switchApp("com.apple.Preview"))
hs.hotkey.bind(HYPER, "y", switchApp("ru.yandex.desktop.yandex-browser"))
hs.hotkey.bind(HYPER, "z", switchApp("us.zoom.xos"))
hs.hotkey.bind(HYPER, "\\", switchApp("com.1password.1password"))
hs.hotkey.bind(HYPER, ",", switchApp("com.apple.systempreferences"))
hs.hotkey.bind(HYPER, ".", switchApp("com.runningwithcrayons.Alfred-Preferences"))

-- Window management (no modal, direct bindings)
hs.window.animationDuration = 0

local function moveWindow(fn)
  return function()
    local win = hs.window.focusedWindow()
    if not win then return end
    local max = win:screen():frame()
    fn(win, max)
  end
end

hs.hotkey.bind(HYPER, "h", moveWindow(function(win, max)
  win:setFrame({ x = max.x, y = max.y, w = max.w / 2, h = max.h })
end))
hs.hotkey.bind(HYPER, "j", moveWindow(function(win, max)
  win:setFrame({ x = max.x, y = max.y + max.h / 2, w = max.w, h = max.h / 2 })
end))
hs.hotkey.bind(HYPER, "k", moveWindow(function(win, max)
  win:setFrame({ x = max.x, y = max.y, w = max.w, h = max.h / 2 })
end))
hs.hotkey.bind(HYPER, "l", moveWindow(function(win, max)
  win:setFrame({ x = max.x + max.w / 2, y = max.y, w = max.w / 2, h = max.h })
end))
hs.hotkey.bind(HYPER, "f", function()
  local win = hs.window.focusedWindow()
  if win then win:maximize() end
end)
hs.hotkey.bind(HYPER, "n", function()
  local win = hs.window.focusedWindow()
  if not win then return end
  local allScreens = hs.screen.allScreens()
  local idx = hs.fnutils.indexOf(allScreens, win:screen())
  win:moveToScreen(allScreens[idx + 1] or allScreens[1])
end)
hs.hotkey.bind(HYPER, "left", function()
  local win = hs.window.focusedWindow()
  if win then win:moveOneScreenWest() end
end)
hs.hotkey.bind(HYPER, "right", function()
  local win = hs.window.focusedWindow()
  if win then win:moveOneScreenEast() end
end)

-- Draw on screen (toggle: start fresh or stop)
local drawActive = false
hs.hotkey.bind(HYPER, "i", function()
  if drawActive then
    drawonscreen.stopAnnotating()
    drawonscreen.hide()
    drawActive = false
  else
    drawonscreen.clear()
    drawonscreen.start()
    drawonscreen.startAnnotating()
    drawActive = true
  end
end)
