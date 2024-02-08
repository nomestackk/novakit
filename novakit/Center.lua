local path = (...):gsub('Center', '')

local Container = require(path .. '.Container') ---@type fun(...): NovaKIT.Container

local EMPTY = {}

---CenterContainer is a container that automatically keeps all of its child components centered within it at their minimum size.
---It ensures that the child controls are always aligned to the center, making it easier to create centered layouts without manual positioning.
---@param settings? NovaKIT.ContainerSettings
---@return NovaKIT.Center center
return function(settings)
  settings = settings or EMPTY
  settings.alignmentMethod = 'position'

  ---@class NovaKIT.Center: NovaKIT.Container
  local Center = Container(settings, 'Center')

  function Center:alignPosition()
    local x = self.x + self.width / 2
    local y = self.y + self.height / 2
    for i = 1, #self.children do
      local child = self.children[i]
      child.x = x - child.width / 2
      child.y = y - child.height / 2
    end
  end

  return Center
end
