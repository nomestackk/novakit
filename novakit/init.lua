---@class NovaKIT
local NovaKIT = {}

local path = (...):gsub('init', '')

NovaPath = path

-- Utility

NovaKIT.rgb = function(red, green, blue, alpha)
  return { red / 255, green / 255, blue / 255, (alpha or 255) / 255 }
end

NovaKIT.override = function(base, override)
  for k in pairs(base) do
    if override[k] then
      base[k] = override[k]
    end
  end
  return base
end

-- Components

NovaKIT.Font = require(path .. '.Font') ---@type NovaKIT.Font
NovaKIT.Button = require(path .. '.Button') ---@type NovaKIT.Button
NovaKIT.Text = require(path .. '.Text') ---@type NovaKIT.Text
NovaKIT.Container = require(path .. '.Container') ---@type NovaKIT.Container
NovaKIT.Component = require(path .. '.Component') ---@type NovaKIT.Component
NovaKIT.HDiv = require(path .. '.HDiv') ---@type NovaKIT.HDiv
NovaKIT.VDiv = require(path .. '.VDiv') ---@type NovaKIT.VDiv
NovaKIT.Panel = require(path .. '.Panel') ---@type fun(settings?: NovaKIT.PanelSettings): NovaKIT.Panel
NovaKIT.Stylebox = require(path .. '.Stylebox') ---@type fun(settings?: NovaKIT.StyleboxSettings): NovaKIT.Stylebox
NovaKIT.TextStyle = require(path .. '.TextStyle') ---@type fun(settings?: NovaKIT.TextStyleSettings): NovaKIT.TextStyle

-- Scene Manager

local root = NovaKIT.Container()

NovaKIT.getRoot = function()
  return root
end

---@param component function|string
NovaKIT.render = function(component)
  if type(component) == "string" then
    component = require(component)
  end
  local result = component()
  root:addImmutable(result)
end

NovaKIT.load = function(directory)
  love.graphics.setBackgroundColor(1, 1, 1)
  directory = directory or 'app'
  NovaKIT.render(directory)
  love.draw = function()
    root:draw()
  end
end

return NovaKIT
