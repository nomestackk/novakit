local getFont = love.graphics.getFont
local setFont = love.graphics.setFont
local setColor = love.graphics.setColor
local printf = love.graphics.printf

local EMPTY = {}

---@class NovaKIT.TextStyleSettings
---@field font? love.Font Font used for the text.
---@field color? Nova.ColorFormat Color of the text.
---@field decoration? 'none'|'underline'|'line-through'|'overline' Decorations applied to font used for an element's text.
---@field halign? love.AlignMode Controls the text's horizontal alignment. Supports left, center and right.
---@field valign? 'top'|'middle'|'bottom' Controls the text's vertical alignment. Supports top, middle and bottom.

---Creates a TextStyle.
---TextStyle provides common settings to customize texts.
---@param settings NovaKIT.TextStyleSettings
---@return NovaKIT.TextStyle textStyle
return function(settings)
    settings = settings or EMPTY

    ---@class NovaKIT.TextStyle
    local TextStyle = {}

    TextStyle.font = settings.font or getFont()
    TextStyle.color = settings.color or { 1, 1, 1, 1 }
    TextStyle.decoration = settings.decoration or 'none'
    TextStyle.halign = settings.halign or 'center'
    TextStyle.valign = settings.valign or 'middle'

    ---Draws this TextStyle.
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
        printf(
            text,
            x,
            textY,
            width,
            self.halign
        )
    end

    return TextStyle
end
