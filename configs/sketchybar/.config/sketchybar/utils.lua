#!/usr/bin/env lua

POPUP_TOGGLE = function(name)
  print("Toggling " .. name)
  Sbar.exec("sketchybar --set " .. name .. " popup.drawing=toggle")
end

POPUP_OFF = function(name)
  print("Hiding " .. name)
  Sbar.exec("sketchybar --set " .. name .. " popup.drawing=off")
end

POPUP_ON = function(name)
  print("Showing " .. name)
  Sbar.exec("sketchybar --set " .. name .. " popup.drawing=on")
end

IS_EMPTY = function(s)
  return s == nil or s == ""
end

STR_SPLIT = function(inputstr, sep)
  local t = {}
  if inputstr == nil then
    return t
  end
  if sep == nil then
    sep = "%s"
  end
  for str in string.gmatch(inputstr, "([^" .. sep .. "]+)") do
    table.insert(t, str)
  end
  return t
end

PRINT_TABLE = function(t)
  for key, value in pairs(t) do
    if type(value) == "table" then
      print(key, ":")
      PRINT_TABLE(value)
    else
      print(key, ":", value)
    end
  end
end

SLEEP = function(seconds)
  local start = os.time()
  while os.time() - start < seconds do
  end
end

COLOR_TO_HEX = function(color)
  return string.format("0x%x", color)
end

BOOL_TO_STR = function(v)
  return v and "on" or "off"
end

TOGGLE_SLIM = function(item)
  print("Toggling slim of " .. item.name)
  item:set({ label = { drawing = "toggle" } })
end

SLIM_CLICK_HANDLER = function(item, env)
  if not (env.INFO.modifier == "ctrl") then
    return false
  end
  TOGGLE_SLIM(item)
  return true
end
