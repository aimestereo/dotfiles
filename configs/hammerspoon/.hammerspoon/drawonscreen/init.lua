local This = {}

local drawonscreen = require("drawonscreen.drawing")
-- F19 is the yet another Hyper key: read more in the hyper/init.lua
local hotkey = hs.hotkey.modal.new({}, "F19")

function hotkey:entered()
  drawonscreen.start()
  drawonscreen.startAnnotating()
end

function hotkey:exited()
  drawonscreen.stopAnnotating()
  drawonscreen.hide()
end

hotkey:bind({}, "c", function()
  drawonscreen.clear()
end)
hotkey:bind({}, "a", function()
  hotkey:exit()
end)
hotkey:bind({}, "t", function()
  drawonscreen.toggleAnnotating()
end)

This.start = function()
  hotkey:enter()
end

return This
