local path      = (...):gsub('Button', '')
local Component = require(path .. '.Component') ---@type fun(...): NovaKIT.Component
local Stylebox  = require(path .. '.Stylebox') ---@type fun(...): NovaKIT.Stylebox
local TextStyle = require(path .. '.TextStyle') ---@type fun(...): NovaKIT.TextStyle

---@class NovaKIT.ButtonSettings: NovaKIT.ComponentSettings
---@field text? string Represents the text content of this Button.
---@field stylebox? NovaKIT.Stylebox Represents the Stylebox that will be rendered behind the text.
---@field textstyle? NovaKIT.TextStyle Represents the TextStyle that will be rendered on top of the background.

local EMPTY     = {}

---Creates a new Button.
---A button is just a combination of a Stylebox and a TextStyle.
---Every other event is inherited from Component.
---@param settings? NovaKIT.ButtonSettings|string A table containing the settings of the Button. This argument can be nil.
return function(settings)
    settings = settings or EMPTY

    if type(settings) == 'string' then
        settings = { text = settings }
    end

    ---@class NovaKIT.Button: NovaKIT.Component
    local Button = Component(settings, 'Button')

    Button.text = settings.text or 'Undefined'
    Button.stylebox = settings.stylebox or Stylebox()
    Button.textstyle = settings.textstyle or TextStyle()

    Button:addEventListener('draw', function(self)
        self.stylebox:draw(self.x, self.y, self.width, self.height)
        self.textstyle:draw(self.text, self.x, self.y, self.width, self.height)
    end)

    return Button
end
