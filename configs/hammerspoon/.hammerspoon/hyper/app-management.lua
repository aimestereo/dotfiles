-- AppManagement originally by jqno

local This = {}

-- Quickly move to and from a specific app
-- (Thanks Teije)
local previousApp = ""

local log = hs.logger.new("app-management", "debug")

local ENABLE_SWITCH_BACK = false

function This.switchToAndFromApp(bundleID)
  local focusedWindow = hs.window.focusedWindow()

  log.i("Switching to and from app with bundle ID: " .. bundleID)

  if focusedWindow == nil then
    hs.application.launchOrFocusByBundleID(bundleID)
  elseif focusedWindow:application():bundleID() == bundleID then
    if ENABLE_SWITCH_BACK and previousApp == nil then
      hs.window.switcher.nextWindow()
    elseif ENABLE_SWITCH_BACK then
      previousApp:activate()
    end
  else
    previousApp = focusedWindow:application()
    hs.application.launchOrFocusByBundleID(bundleID)
  end
end

-- Open new windows

function This.newTerminalWindow()
  hs.applescript.applescript([[
    tell application "Terminal"
      do script ""
      activate
    end tell
  ]])
end

return This
