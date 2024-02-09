local Container = require(NovaPath .. '.Container') ---@type fun(settings: NovaKIT.ContainerSettings): NovaKIT.Container

---@class NovaKIT.ScaffoldSettings
---@field appBar NovaKIT.AppBar

local unit = love.graphics.getHeight() / 12

return function(settings)
  ---@class NovaKIT.Scaffold: NovaKIT.Container
  local Scaffold = Container {}

  local appBar = settings.appBar and Scaffold:addImmutable(settings.appBar)
  appBar:top()
  appBar.height = unit

  Scaffold.appBar = appBar

  return Scaffold
end
