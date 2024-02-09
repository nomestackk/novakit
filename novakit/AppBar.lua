local Panel = require(NovaPath .. '.Panel') ---@type fun(settings?: NovaKIT.PanelSettings): NovaKIT.Panel
local HDiv = require(NovaPath .. '.HDiv') ---@type fun(settings?: NovaKIT.ContainerSettings): NovaKIT.HDiv

return function()
  ---@class NovaKIT.AppBar: NovaKIT.Panel
  local AppBar = Panel { root = HDiv() }

  AppBar.stylebox.color = { 0.1, 0.1, 0.9, 1 }
  AppBar.stylebox.shrink = 0
  AppBar.stylebox.radius = 0

  return AppBar
end
