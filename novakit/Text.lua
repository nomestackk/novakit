local Component = require(NovaPath .. '.Component') ---@type NovaKIT.Component
local TextStyle = require(NovaPath .. '.TextStyle') ---@type NovaKIT.TextStyle

---@class NovaKIT.TextSettings: NovaKIT.ComponentSettings
---@field text? string
---@field textStyle? NovaKIT.TextStyle

local EMPTY = {}

---@class NovaKIT.Text: NovaKIT.Component
local Text = Component:subclass 'Text'

---@param settings? NovaKIT.TextSettings|string
function Text:initialize(settings)
  settings = settings or EMPTY

  if type(settings) == "string" then
    settings = { text = settings }
  end

  Component.initialize(self, settings)

  self.text = settings.text or 'nil'
  self.textStyle = settings.textStyle or TextStyle()
  self.width = settings.width or self.textStyle:getWidth(self.text)
  self.height = settings.height or self.textStyle:getHeight()

  self:addEventListener('draw', function()
    self.textStyle:render(self.text, self)
  end)
end

return Text
