local path = (...):gsub('Text', '')
local Component = require(path .. '.Component')
local TextStyle = require(path .. '.TextStyle')

---@class NovaKIT.TextSettings: NovaKIT.ComponentSettings
---@field text? string
---@field textStyle? NovaKIT.TextStyle

local EMPTY = {}

---Creates a new Text.
---Text is a component that can only draw a `TextStyle`.
---Supports events just like any class that inherits from `Component`.
---@param settings? NovaKIT.TextSettings|string
---@return NovaKIT.Text text
return function(settings)
  settings = settings or EMPTY

  if type(settings) == 'string' then settings = { text = settings } end

  ---@class NovaKIT.Text: NovaKIT.Component
  local Text = Component(settings, 'Text')

  Text.text = settings.text or 'Undefined'
  Text.textStyle = settings.textStyle or TextStyle()

  Text:addEventListener('draw', function(self)
    self.textStyle:draw(self.text, self.x, self.y, self.width, self.height)
  end)

  return Text
end
