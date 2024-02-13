local Component = require(NovaPath .. '.Component') ---@type NovaKIT.Component
local Stylebox = require(NovaPath .. '.Stylebox') ---@type NovaKIT.Stylebox
local TextStyle = require(NovaPath .. '.TextStyle') ---@type NovaKIT.TextStyle

local EMPTY = {}
local type = type

---@class NovaKIT.Button: NovaKIT.Component
---@operator call: NovaKIT.Button
local Button = Component:subclass 'Button'

---@param settings? NovaKIT.ButtonSettings|string A table containing the settings of the Button. This argument can be nil.
function Button:initialize(settings)
  settings = settings or EMPTY

  if type(settings) == 'string' then settings = { text = settings } end

  Component.initialize(self, settings)

  self.text = settings.text or 'nil'
  self.stylebox = settings.stylebox or Stylebox()
  self.textstyle = settings.textstyle or TextStyle()
  self:addEventListener('draw', function()
    self.stylebox:render(self)
    self.textstyle:render(self.text, self)
  end)
end

return Button
