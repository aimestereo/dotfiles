hs.console.clearConsole()

local spoons = require("spoons")
spoons.init({ install = true })

-- LSP annotations for Hammerspoon
hs.loadSpoon("EmmyLua")

local hyper = require("hyper")
require("hyper.mapping")

-- Hotkey cheatsheet for any app.
local sheet = hs.loadSpoon("KSheet")
hyper.bindShiftKey("/", hs.fnutils.partial(sheet.toggle, sheet))

-- Menu item search.
local menusearch = require("menusearch")
hyper.bindKey("/", menusearch.toggle)

-- Super Duper mode (hold s and d), Ah Fudge mode (hold a and f). Hold 5 seconds for help.
local keyboard = require("keyboard") -- Load Hammerspoon bits from https://github.com/jasonrudolph/keyboard
hyper.bindKey("w", keyboard.windows.toggle)

-- Draw on screen. hyper + i (c/a/t).  (c)lear/(a)nnotate/(t)oggle
local drawonscreen = require("drawonscreen")
hyper.bindKey("i", drawonscreen.start)

local alert_sound = hs.sound.getByName("Tink")
alert_sound:play()
hs.notify.new({ title = "Hammerspoon", informativeText = "Ready to rock 🤘" }):send()
