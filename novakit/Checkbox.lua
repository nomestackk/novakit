local Component = require(NovaPath .. '.Component') ---@type NovaKIT.Component
local Stylebox = require(NovaPath .. '.Stylebox') ---@type NovaKIT.Stylebox

---@class NovaKIT.CheckboxSettings: NovaKIT.ComponentSettings
---@field checked? boolean
---@field checkmark? NovaKIT.Stylebox
---@field stylebox? NovaKIT.Stylebox
---@field onchange? function

---@class NovaKIT.Checkbox: NovaKIT.Component
---@operator call: NovaKIT.Checkbox
local Checkbox = Component:subclass 'Checkbox'
local EMPTY = {}

---@param settings NovaKIT.CheckboxSettings
function Checkbox:initialize(settings)
  settings = settings or EMPTY

  Component.initialize(self, settings)

  if settings.checked == nil then settings.checked = false end
  if settings.onchange then self:on('onChange', settings.onchange) end

  self.stylebox = settings.stylebox or Stylebox()
  self.checkmark = settings.checkmark or Stylebox {
    color = { 0.1, 0.2, 0.9, 1 },
    borderColor = { 1, 1, 1, 1 },
    border = 1,
    shrink = 4
  }
  self.checked = settings.checked
  self:addEventListener('draw', function()
    self.stylebox:render(self)
    if self.checked then self.checkmark:render(self) end
  end)
  self:addEventListener('onRelease', function()
    self:execute 'onChange'
  end)
end

return Checkbox
