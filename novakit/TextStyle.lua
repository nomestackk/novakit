local middleclass = require(NovaPath .. '.libs.middleclass')
local Utility = require(NovaPath .. '.Utility') ---@type NovaKIT.Utility

local getFont = love.graphics.getFont
local setFont = love.graphics.setFont
local setColor = love.graphics.setColor
local printf = love.graphics.printf

local EMPTY = {}

---@class NovaKIT.TextStyleSettings
---@field font? love.Font Font used for the text.
---@field color? NovaKIT.ColorFormat Color of the text.
---@field decoration? 'none'|'underline'|'line-through'|'overline' Decorations applied to font used for an element's text.
---@field halign? love.AlignMode Controls the text's horizontal alignment. Supports left, center and right.
---@field valign? 'top'|'middle'|'bottom' Controls the text's vertical alignment. Supports top, middle and bottom.
---@field animationSpeed? number

---@class NovaKIT.TextStyle: middleclass.Class
---@operator call: NovaKIT.TextStyle
local TextStyle = middleclass 'TextStyle'

---@param settings? NovaKIT.TextStyleSettings
function TextStyle:initialize(settings)
  settings = settings or EMPTY
  self.font = settings.font or getFont()
  self.color = settings.color or { 0, 0, 0, 1 }
  self.decoration = settings.decoration or 'none'
  self.halign = settings.halign or 'center'
  self.valign = settings.valign or 'middle'
  self.animationSpeed = settings.animationSpeed or 0.35
  self.fontHeight = self.font:getHeight()
  self.interpolate = nil
end

---@param font love.Font
function TextStyle:setFont(font)
  self.font = font
  self.fontHeight = font:getHeight()
end

---@param text string
function TextStyle:getWidth(text)
  return self.font:getWidth(text)
end

function TextStyle:getHeight()
  return self.fontHeight
end

function TextStyle:update()
  local interpolate = self.interpolate
  if not interpolate then return end
  Utility.SmoothColor(self.color, interpolate.color, self.animationSpeed)
  self.font = interpolate.font
  self.decoration = interpolate.decoration
end

---@param text string
---@param component NovaKIT.Component
function TextStyle:render(text, component)
  self:draw(text, component.x, component.y, component.width, component.height)
end

---@param text string
---@param x number
---@param y number
---@param width number
---@param height number
function TextStyle:draw(text, x, y, width, height)
  local textY
  if self.valign == 'top' then
    textY = y
  elseif self.valign == 'middle' then
    textY = y + (height - self.font:getHeight()) / 2
  elseif self.valign == 'bottom' then
    textY = y + (height - self.font:getHeight())
  end
  setColor(self.color)
  setFont(self.font)
  printf(text, x, textY, width, self.halign)
  self:update()
end

return TextStyle
