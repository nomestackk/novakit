local path      = (...):gsub('Button', '')
local Component = require(path .. '.Component') ---@type fun(...): NovaKIT.Component
local Stylebox  = require(path .. '.Stylebox') ---@type fun(...): NovaKIT.Stylebox
local TextStyle = require(path .. '.TextStyle') ---@type fun(...): NovaKIT.TextStyle

---@class NovaKIT.ButtonStyle
---@field stylebox NovaKIT.Stylebox
---@field textstyle NovaKIT.TextStyle

---@class NovaKIT.ButtonSettings: NovaKIT.ComponentSettings
---@field text? string Represents the text content of this Button.
---@field stylebox? NovaKIT.Stylebox Represents the Stylebox that will be rendered behind the text.
---@field textstyle? NovaKIT.TextStyle Represents the TextStyle that will be rendered on top of the background.
---@field style? table<'default'|'hovered'|'clicked', NovaKIT.ButtonStyle>

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

    settings.stylebox = settings.stylebox or Stylebox()
    settings.textstyle = settings.textstyle or TextStyle()
    settings.style = settings.style or {}
    settings.style.default = settings.style.default or { stylebox = settings.stylebox, textstyle = settings.textstyle }
    settings.style.hovered = settings.style.hovered or { stylebox = settings.stylebox, textstyle = settings.textstyle }
    settings.style.clicked = settings.style.clicked or { stylebox = settings.stylebox, textstyle = settings.textstyle }

    Button.cursor = love.mouse.getSystemCursor 'hand'
    Button.text = settings.text or 'Undefined'
    Button.stylebox = settings.stylebox
    Button.textstyle = settings.textstyle
    Button.style = settings.style

    Button:addEventListener('draw', function(self)
        local style = self.style
        if self.clicked then
            style.clicked.stylebox:draw(self.x, self.y, self.width, self.height)
            style.clicked.textstyle:draw(self.text, self.x, self.y, self.width, self.height)
        elseif self.hovered then
            style.hovered.stylebox:draw(self.x, self.y, self.width, self.height)
            style.hovered.textstyle:draw(self.text, self.x, self.y, self.width, self.height)
        else
            style.default.stylebox:draw(self.x, self.y, self.width, self.height)
            style.default.textstyle:draw(self.text, self.x, self.y, self.width, self.height)
        end
    end)

    return Button
end
