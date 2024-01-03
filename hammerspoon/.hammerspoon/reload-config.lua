-- Reload Configuration
--- http://www.hammerspoon.org/go/#fancyreload

module = {}

-- manual
local reload = function()
  hs.reload()
end

module.init = function(hyper, key)
  hs.hotkey.bind(hyper, key, nil, reload)
end

local function reloadConfig(files)
  doReload = false
  for _, file in pairs(files) do
    if file:sub(-4) == ".lua" then
      doReload = true
    end
  end
  if doReload then
    hs.reload()
  end
end

-- watcher
hs.pathwatcher.new(os.getenv("HOME") .. "/.hammerspoon/", reloadConfig):start()

return module
