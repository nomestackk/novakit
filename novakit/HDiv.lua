local Container = require(NovaPath .. '.Container') ---@type NovaKIT.Container

---@class NovaKIT.HDiv: NovaKIT.Container
local HDiv = Container:subclass 'HDiv'

---@param settings? NovaKIT.ContainerSettings
function HDiv:initialize(settings)
    Container.initialize(self, settings)
    self:align()
end

function HDiv:alignPosition()
    local x = self.x
    self:forEach(function(child)
        if child:isAlignable() then
            child.x = x
            child.y = self.y
            x = x + child.width + self.gap
        end
    end)
end

function HDiv:alignSize()
    local width = self.width / self:alignableChildrenCount()
    self:forEach(function(child)
        if child:isAlignable() then
            child.width = width
            child.height = self.height
        end
    end)
end

function HDiv:resize()
    self.width = self:accumulatorDimensionCalc 'width'
    self.height = self:greatestDimensionCalc 'height'
end

return HDiv
