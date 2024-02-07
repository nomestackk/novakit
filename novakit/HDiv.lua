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
        for i = 1, #self.children do
            local child = self.children[i]
            if not child.antiAlign then
                child.x = x
                child.y = self.y
                x = x + child.width + self.gap
            end
        end
    end

    function HDiv:alignSize()
        local width = self.width / #self.children
        for i = 1, #self.children do
            local child = self.children[i]
            if not child.antiAlign then
                child.width = width
                child.height = self.height
            end
        end
    end

    return HDiv
end
