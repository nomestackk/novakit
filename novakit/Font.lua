local newFont = love.graphics.newFont

---@class NovaKIT.Font
local Font = {}

---Creates a function font creator wrapper.
---@param name string
---@param isLinear? boolean
---@return fun(size: integer): love.Font
Font.create = function(name, isLinear)
  return function(size)
    local font = newFont(name .. '.ttf', size)
    if not isLinear then
      font:setFilter("nearest", "nearest")
    end
    return font
  end
end

return Font
