local Container = require(NovaPath .. '.Container') ---@type NovaKIT.Container

---@class NovaKIT.VDiv: NovaKIT.Container
---@operator call: NovaKIT.VDiv
local VDiv = Container:subclass 'VDiv'

function VDiv:initialize(settings)
  Container.initialize(self, settings)
  self:align()
end

function VDiv:alignPosition()
  local y = self.y
  self:forEach(function(child)
    if child:isAlignable() then
      child.x = self.x
      child.y = y
      y = y + child.height + self.gap
    end
  end)
end

function VDiv:resize()
  self.width = self:greatestDimensionCalc 'width'
  self.height = self:accumulatorDimensionCalc 'height'
end

function VDiv:alignSize()
  local height = self.height / self:alignableChildrenCount()
  self:forEach(function(child)
    if child:isAlignable() then
      child.height = height
      child.width = self.width
    end
  end)
end

return VDiv
