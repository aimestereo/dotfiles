local message = require("keyboard.status-message")

local This = {}

This.getModifiersStr = function(modifiers)
  local modMap = { shift = "⇧", ctrl = "⌃", alt = "⌥", cmd = "⌘" }
  local retVal = ""

  for _, v in ipairs(modifiers) do
    retVal = retVal .. modMap[v]
  end

  return retVal
end

-- Bind the given key to call the given function and exit WindowLayout mode
This.bindWithAutomaticExit = function(mode, modifiers, key, fn)
  mode:bind(modifiers, key, function()
    local exit = fn()
    if exit then
      mode:exit()
    end
  end)
end

This.initMenu = function(mode, msgStr, mappings, menuCallback)
  local Menu = {}
  local showHelp = false
  local shortMsgStr = msgStr .. "\n? => toggle help"

  Menu.modeActive = false
  Menu.mode = mode

  mode.bindWithAutomaticExit = This.bindWithAutomaticExit

  Menu.toggle = function()
    if Menu.modeActive then
      Menu.mode:exit()
    else
      Menu.mode:enter()
    end
  end

  mode.entered = function()
    Menu.modeActive = true
    mode.statusMessage:show()
  end
  mode.exited = function()
    Menu.modeActive = false
    mode.statusMessage:hide()
  end

  Menu.setMsg = function()
    local msg
    if showHelp then
      msg = msgStr
    else
      msg = shortMsgStr
    end

    mode.statusMessage = message.new(msg)
  end

  for _, mapping in ipairs(mappings) do
    local modifiers, trigger, description, optionCallback = table.unpack(mapping)
    local hotKeyStr = This.getModifiersStr(modifiers)

    if string.len(hotKeyStr) > 0 then
      msgStr = msgStr .. (string.format("\n%10s+%s => %s", hotKeyStr, trigger, description))
    else
      msgStr = msgStr .. (string.format("\n%11s => %s", trigger, description))
    end

    mode:bindWithAutomaticExit(modifiers, trigger, function()
      hs.printf("MenuItem. key:%s, menu:%s", trigger, description)

      if description == "toggle help" then
        showHelp = not showHelp
        mode.statusMessage:hide()
        Menu.setMsg()
        mode.statusMessage:show()
        return false
      end

      if optionCallback then
        return optionCallback()
      else
        return menuCallback(description)
      end
    end)
  end

  Menu.setMsg()

  return Menu
end

return This
