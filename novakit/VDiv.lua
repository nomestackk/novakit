local path      = (...):gsub('VDiv', '')
local Container = require(path .. '.Container') ---@type fun(...): NovaKIT.Container
local Utility   = require('novakit/Utility')

---Creates a VDiv.
---VDiv extends from `Container` and aligns its children vertically.
---@param settings? NovaKIT.ContainerSettings
---@return NovaKIT.VDiv VDiv
return function(settings)
    ---@class NovaKIT.VDiv: NovaKIT.Container
    local VDiv = Container(settings, 'VDiv')

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

    VDiv:align()

    return VDiv
end
