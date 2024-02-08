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
NovaKIT.Button = require(path .. '.Button') ---@type fun(settings?: NovaKIT.ButtonSettings|string): NovaKIT.Button
NovaKIT.Text = require(path .. '.Text') ---@type fun(settings?: NovaKIT.TextSettings|string): NovaKIT.Text
NovaKIT.Container = require(path .. '.Container') ---@type fun(settings?: NovaKIT.ContainerSettings): NovaKIT.Container
NovaKIT.Component = require(path .. '.Component') ---@type fun(settings?: NovaKIT.ComponentSettings): NovaKIT.Component
NovaKIT.HDiv = require(path .. '.HDiv') ---@type fun(settings?: NovaKIT.ContainerSettings): NovaKIT.HDiv
NovaKIT.VDiv = require(path .. '.VDiv') ---@type fun(settings?: NovaKIT.ContainerSettings): NovaKIT.VDiv
NovaKIT.Panel = require(path .. '.Panel') ---@type fun(settings?: NovaKIT.PanelSettings): NovaKIT.Panel
NovaKIT.Stylebox = require(path .. '.Stylebox') ---@type fun(settings?: NovaKIT.StyleboxSettings): NovaKIT.Stylebox
NovaKIT.TextStyle = require(path .. '.TextStyle') ---@type fun(settings?: NovaKIT.TextStyleSettings): NovaKIT.TextStyle

return NovaKIT
