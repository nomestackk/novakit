local path      = (...):gsub('Button', '')

local Component = require(path .. '.Component') ---@type fun(...): NovaKIT.Component
local Stylebox  = require(path .. '.Stylebox') ---@type fun(...): NovaKIT.Stylebox
local TextStyle = require(path .. '.TextStyle') ---@type fun(...): NovaKIT.TextStyle

local EMPTY     = {}
local type      = type
local hand      = love.mouse.getSystemCursor 'hand'

---@class NovaKIT.ButtonStyle
---@field stylebox? NovaKIT.Stylebox
---@field textstyle? NovaKIT.TextStyle

---@class NovaKIT.ButtonSettings: NovaKIT.ComponentSettings
---@field text? string Represents the text content of this Button.
---@field stylebox? NovaKIT.Stylebox Represents the Stylebox that will be rendered behind the text.
---@field textstyle? NovaKIT.TextStyle Represents the TextStyle that will be rendered on top of the background.
---@field hovered? NovaKIT.ButtonStyle
---@field clicked? NovaKIT.ButtonStyle
---@field animationSpeed? number

---Creates a new Button.
---@param settings? NovaKIT.ButtonSettings|string A table containing the settings of the Button. This argument can be nil.
return function(settings)
    settings = settings or EMPTY
    if type(settings) == 'string' then
        settings = { text = settings }
    end

    settings.stylebox = settings.stylebox or Stylebox()
    settings.textstyle = settings.textstyle or TextStyle()
    settings.hovered = settings.hovered or {}
    settings.clicked = settings.clicked or {}
    settings.animationSpeed = settings.animationSpeed or 0.35

    ---@class NovaKIT.Button: NovaKIT.Component
    local Button = Component(settings, 'Button')

    Button.cursor = hand
    Button.text = settings.text or 'Undefined'
    Button.stylebox = Stylebox({ animationSpeed = settings.animationSpeed })
    Button.textstyle = TextStyle({ animationSpeed = settings.animationSpeed })
    Button.style = {}
    Button.style.default = {
        stylebox = settings.stylebox,
        textstyle = settings.textstyle
    }
    Button.style.hovered = {
        stylebox = settings.hovered.stylebox or settings.stylebox,
        textstyle = settings.hovered.textstyle or settings.textstyle
    }
    Button.style.clicked = {
        stylebox = settings.clicked.stylebox or settings.stylebox,
        textstyle = settings.clicked.textstyle or settings.textstyle
    }

    Button:addEventListener('draw', function(self)
        local state = self.clicked and 'clicked' or (self.hovered and 'hovered' or 'default')
        local style = self.style
        local stylebox = style[state].stylebox
        local textstyle = style[state].textstyle
        self.stylebox.interpolate = stylebox
        self.textstyle.interpolate = textstyle
        self.stylebox:draw(self.x, self.y, self.width, self.height)
        self.textstyle:draw(self.text, self.x, self.y, self.width, self.height)
    end)

    return Button
end
