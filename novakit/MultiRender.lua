local middleclass = require(NovaPath .. '.libs.middleclass') ---@type middleclass

---@class NovaKIT.ShapeFormat
---@field x number
---@field y number
---@field width number
---@field height number
---@field color? NovaKIT.ColorFormat
---@field mode? love.DrawMode
---@field radius? integer

---@class NovaKIT.MultiRender: middleclass.Class
---@operator call: NovaKIT.MultiRender
---@field defaultMode love.DrawMode
---@field defaultRadius integer
local MultiRender = middleclass 'MultiRender'
MultiRender.static.defaultRadius = 0
MultiRender.static.defaultMode = 'fill'

local EMPTY = {}
local rectangle = love.graphics.rectangle
local setColor = love.graphics.setColor
local type = type
local pairs = pairs

---@class NovaKIT.MultiRenderSettings
---@field interpolate? NovaKIT.MultiRender
---@field shapes? NovaKIT.ShapeFormat[]
---@field animationSpeed? number
---@field width number
---@field height number

local function clone(table)
  if not table then return end
  local result = {}
  for key, value in pairs(table) do
    if type(value) == "table" then
      result[key] = clone(value)
    else
      result[key] = value
    end
  end
  return result
end

local function lerp(a, b, t)
  return a + (b - a) * t
end

function MultiRender:update()
  local interpolate = self.interpolate
  if not interpolate then
    return
  end

  local shapes = self.shapes
  if not shapes then
    return
  end

  local interpolateShapes = interpolate.shapes
  if not interpolateShapes then
    return
  end

  local speed = self.animationSpeed

  for index = 1, #shapes do
    local shape = shapes[index]
    local interpolateShape = interpolateShapes[index]
    if interpolateShape then
      shape.x = lerp(shape.x, interpolateShape.x, speed)
      shape.y = lerp(shape.y, interpolateShape.y, speed)
      shape.width = lerp(shape.width, interpolateShape.width, speed)
      shape.height = lerp(shape.height, interpolateShape.height, speed)
      shape.radius = lerp(shape.radius, interpolateShape.radius, speed)
    end
  end
end

---@param settings? NovaKIT.MultiRenderSettings
function MultiRender:initialize(settings)
  settings = settings or EMPTY
  self.interpolate = settings.interpolate
  self.animationSpeed = settings.animationSpeed or 0.25
  self.shapes = clone(settings.shapes)
  self.width = settings.width or love.graphics.getWidth()
  self.height = settings.height or love.graphics.getHeight()
end

---@param x number
---@param y number
---@param shape NovaKIT.ShapeFormat
function MultiRender:drawShape(x, y, shape)
  shape.radius = shape.radius or MultiRender.defaultRadius
  local shapeX = x + (shape.x * self.width)
  local shapeY = y + (shape.y * self.height)
  local width = self.width * shape.width
  local height = self.height * shape.height
  local radius = shape.radius
  local radiusX = self.width * radius
  local radiusY = self.height * radius
  if shape.color then setColor(shape.color) end
  rectangle(
    shape.mode or MultiRender.defaultMode,
    shapeX,
    shapeY,
    width,
    height,
    radiusX,
    radiusY
  )
  self:update()
end

---@param x number
---@param y number
function MultiRender:draw(x, y)
  local shapes = self.shapes
  if not shapes then return end
  for index = 1, #shapes do
    local shape = shapes[index]
    self:drawShape(x, y, shape)
  end
end

---@param component NovaKIT.Component
function MultiRender:render(component)
  self:draw(component.x, component.y)
end

return MultiRender
