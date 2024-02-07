local path = (...):gsub("Font", "")
local newFont = love.graphics.newFont

---@class NovaKIT.Font
local Font = {}

---Creates a function font creator wrapper.
---@param name string
---@param isLinear? boolean
---@return fun(size: integer): love.Font
Font.create = function(name, isLinear)
  return function(size)
    local font = newFont(path .. "/Fonts/" .. name .. '.ttf', size)
    if not isLinear then
      font:setFilter("nearest", "nearest")
    end
    return font
  end
end

Font.Inter = {
  Black = Font.create('Inter/Black'),
  Bold = Font.create('Inter/Bold'),
  ExtraBold = Font.create('Inter/ExtraBold'),
  ExtraLight = Font.create('Inter/ExtraLight'),
  Light = Font.create('Inter/Light'),
  Medium = Font.create('Inter/Medium'),
  Regular = Font.create('Inter/Regular'),
  SemiBold = Font.create('Inter/SemiBold'),
  Thin = Font.create('Inter/Thin')
}

return Font
