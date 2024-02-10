local path = (...):gsub('HDiv', '')
local Container = require(path .. '.Container')

---Creates a HDiv.
---HDiv extends from `Container` and aligns its children horizontally.
---@param settings? NovaKIT.ContainerSettings
---@return NovaKIT.HDiv HDiv
return function(settings)
    ---@class NovaKIT.HDiv: NovaKIT.Container
    local HDiv = Container(settings, 'HDiv')

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

    function HDiv:resize()
        self.width = self:accumulatorDimensionCalc 'width'
        self.height = self:greatestDimensionCalc 'height'
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

    HDiv:align()

    return HDiv
end
