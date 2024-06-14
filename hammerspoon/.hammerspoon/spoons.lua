local This = {}

-- function takes long time to run
-- so installation is optional
local installSpoons = function()
  hs.loadSpoon("SpoonInstall")
  local Install = spoon.SpoonInstall
  Install.use_syncinstall = true
  Install:updateRepo("default")

  Install:installSpoonFromRepo("EmmyLua")
  Install:installSpoonFromRepo("KSheet")
end

-- param opts: table
-- opts.install: boolean
This.init = function(opts)
  if opts.install then
    installSpoons()
  end
end

return This
