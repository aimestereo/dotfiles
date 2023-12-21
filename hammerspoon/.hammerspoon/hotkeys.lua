-- create the bindings for each layout, but don't activate either one yet
-- note that `keyboardlayout1` and `keyboardlayout2` are just example place holders...
-- you should  replace them with the output from `hs.keycodes.currentLayout()` for
-- each layout you want to support.
local bindings = {
  ["keyboardlayout1"] = hs.hotkey.new({"cmd", "alt"}, "`", function() ... end),
  ["keyboardlayout2"] = hs.hotkey.new({"cmd", "alt"}, "ё", function() ... end),
}

-- create the function which activates the right one
local assignHotkeyFunction = function(meta, hotkeys)
    for k, v in pairs(bindings) do
        if k == hs.keycodes.currentLayout() then
            v:enable()
        else
            v:disable()
        end
    end
end





local module   = {}

local mouseCircle = nil
local mouseCircleTimer = nil

local function init_hotkeys(meta, hotkeys)
    meta.triggered = true
    
end


module.init = function(meta, hotkeys)
    local callback = function()
        assignHotkeyFunction(meta, hotkeys)
    end

    -- reassign the key when the keyboard layout changes
    hs.keycodes.inputSourceChanged(assignHotkeyFunction)

    -- assign the key based on the initial keyboard layout
    hotkeys[hs.keycodes.currentLayout()]:enable()
end

return module