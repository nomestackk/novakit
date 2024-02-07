local path     = (...):gsub('Panel', '')
local Stylebox = require(path .. '.Stylebox') ---@type fun(...): NovaKIT.Stylebox

---@class NovaKIT.PanelSettings: NovaKIT.ComponentSettings
---@field root NovaKIT.Container
---@field stylebox? NovaKIT.Stylebox

---Creates a Panel.
---Panel is a **Container** that renders a Stylebox before drawing its children.
---`root` must be a **Container** that will be used for alignment and cant be nil.
---@param settings NovaKIT.PanelSettings
---@return NovaKIT.Panel panel
return function(settings)
  ---@class NovaKIT.Panel: NovaKIT.Container
  local Panel = settings.root

  Panel.name = 'Panel'
  Panel.stylebox = settings.stylebox or Stylebox()

  Panel:addEventListener('draw', function(self)
    self.stylebox:draw(self.x, self.y, self.width, self.height)
  end)

  return Panel
end
