-- inspired by https://gist.github.com/dalemanthei/dde8bccb22c3a2d3487a6e7d77be33f5

-- Load and install the Hyper key extension. Binding to F18
local hyper = require("hyper")
local am = require("app-management")

hyper.install("F18")

print("Debug")
print(hyper)
print(hyper.bindKey)

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
-- TODO: revisit old crap
--

hs.console.clearConsole()
logger = hs.logger.new("main")

local hyper_old = { "ctrl", "alt", "cmd", "shift" }

------------
-- Utilities
------------

function pairsByKeys(t, f)
  local a = {}
  for n in pairs(t) do
    table.insert(a, n)
  end
  table.sort(a, f)
  local i = 0 -- iterator variable
  local iter = function() -- iterator function
    i = i + 1
    if a[i] == nil then
      return nil
    else
      return a[i], t[a[i]]
    end
  end
  return iter
end

-- Help
to_string = function(t)
  local content = {}
  local long_separator = "\n-----------------\n"
  local separator = ": "

  for k, v in pairsByKeys(t) do
    if type(v) == "table" then
      v = long_separator .. to_string(v) .. "\n"
    end
    table.insert(content, k .. separator .. v)
  end

  -- if level > 0 then separator = '\n' end
  -- return table.concat( content, separator )
  return table.concat(content, "\n")
end

help = function(duration)
  if duration == nil then
    duration = 5
  end
  message = to_string({ Launch = appsBindings, ["Outer mapping"] = hyperBindings })
  hs.alert.show(message, { textFont = "Monaco", textSize = 20 }, duration)
end
-- /Help

-------
-- Main
-------

-- The following keys are configured as hot keys in their respective apps (or in Keyboard Maestro, Alfred)
-- SPACE → Spotlight (configured in System Preferences → Keyboard → Shortcuts → Spotlight, moved so that ⌘␣ could be used for Alfred)
hyperBindings = {
  r = "Reload Config",
  --f = 'iTerm',

  space = "Switch language",

  -- t='Things: add todo',
  -- a='Things with Autofill',
}

-- single bind keys to open apps
appsBindings = {
  --q = 'Quiver',
  q = "Obsidian",

  x = "Preview",
  e = "Finder",
  c = "Calendar",
  m = "Mail",
  s = "Slack",
  d = "Discord",
  z = "zoom.us",

  w = "iTerm",
  --f = 'Warp',
  f = "kitty",

  p = "Postman",
  i = "Pycharm CE",
  v = "Visual Studio Code",

  -- g='Google Chrome',
  -- b='Safari',
  a = "Arc",

  -- a='Alfred Preferences',
  [","] = "System Preferences",
}

for ch, app in pairs(appsBindings) do
  local key = hs.keycodes.map[ch]
  hs.console.printStyledtext(hyper_old, key, nil)
  hs.hotkey.bind(hyper_old, key, nil, function()
    hs.application.launchOrFocus(app)
  end)
end

----------
-- Actions
----------

cursorLocator = require("cursor-locator")
cursorLocator.init(hyper_old, "l")
hyperBindings["l"] = "Cursor locator"

-- Show help when ctrl double pressed
-- ctrlDoublePress = require("ctrlDoublePress")
-- ctrlDoublePress.timeFrame = 1
-- ctrlDoublePress.action = function()
--   help(5)
-- end

-- Alt hold
-- altHold = require("altHold")
-- altHold.timeFrame = 2
-- altHold.action = function()
--   hs.eventtap.keyStroke('F16')
-- end

reloadConfig = require("reload-config")
reloadConfig.init(hyper_old, "r")
hyperBindings["r"] = "Reload"

headphones_watcher = require("headphones_watcher")
headphones_watcher.init()

------
-- End
------

-- local alert_sound = hs.sound.getByFile("alert.wav")
local alert_sound = hs.sound.getByName("Tink")
alert_sound:play()
hs.alert.show("Hammerspoon, at your service.", 2)
