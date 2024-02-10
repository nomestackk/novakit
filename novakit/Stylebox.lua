---@class NovaKIT.StyleboxSettings
---@field color? NovaKIT.ColorFormat The background color of the stylebox.
---@field shrink? integer Shrinks the size of the stylebox.
---@field border? integer Border width of the stylebox
---@field borderColor? NovaKIT.ColorFormat Border color of the stylebox.
---@field radius? integer Corner radius of the stylebox.
---@field animationSpeed? number

local EMPTY = {}

local push = love.graphics.push
local pop = love.graphics.pop
local setColor = love.graphics.setColor
local rectangle = love.graphics.rectangle
local translate = love.graphics.translate
local rotate = love.graphics.rotate
local setLineWidth = love.graphics.setLineWidth

local function clamp(a, m, n)
    if a < m then return m end
    if a > n then return n end
    return a
end

local function smooth(a, b, amount)
    local t = clamp(amount, 0, 1)
    local m = t * t * (3 - 2 * t)
    return a + (b - a) * m
end

---@param from NovaKIT.ColorFormat
---@param to NovaKIT.ColorFormat
local function smoothColor(from, to, speed)
    from[1] = smooth(from[1], to[1], speed)
    from[2] = smooth(from[2], to[2], speed)
    from[3] = smooth(from[3], to[3], speed)
    from[4] = smooth(from[4], to[4], speed)
end

---Creates a Stylebox.
---Stylebox provides common settings to draw boxes.
---@param settings? NovaKIT.StyleboxSettings
---@return NovaKIT.Stylebox stylebox
return function(settings)
    settings = settings or EMPTY

    ---@class NovaKIT.Stylebox
    local Stylebox = {}

    Stylebox.color = settings.color or { 0.75, 0.75, 0.75, 1 }
    Stylebox.shrink = settings.shrink or 4
    Stylebox.border = settings.border or 0.5
    Stylebox.borderColor = settings.borderColor or { 0.5, 0.5, 0.5, 1 }
    Stylebox.radius = settings.radius or 4
    Stylebox.animationSpeed = settings.animationSpeed or 0.35
    Stylebox.interpolate = nil ---@type NovaKIT.Stylebox|nil

    function Stylebox:update()
        local interpolate = self.interpolate
        if not interpolate then return end
        self.shrink = smooth(self.shrink, interpolate.shrink, self.animationSpeed)
        self.border = smooth(self.border, interpolate.border, self.animationSpeed)
        self.radius = smooth(self.radius, interpolate.radius, self.animationSpeed)
        smoothColor(self.color, interpolate.color, self.animationSpeed)
        smoothColor(self.borderColor, interpolate.borderColor, self.animationSpeed)
    end

    ---@param x number
    ---@param y number
    ---@param width number
    ---@param height number
    ---@param rotation? integer
    ---@param ox? number
    ---@param oy? number
    function Stylebox:draw(x, y, width, height, rotation, ox, oy)
        x = x + self.shrink
        y = y + self.shrink
        width = width - self.shrink * 2
        height = height - self.shrink * 2
        rotation = rotation or 0
        ox = ox or width / 2
        oy = oy or height / 2
        push()
        translate(x + ox, y + oy)
        rotate(-rotation)
        setColor(self.color)
        rectangle('fill', -ox, -oy, width, height, self.radius, self.radius)
        if self.border > 0 then
            setColor(self.borderColor)
            setLineWidth(self.border)
            rectangle('line', -ox, -oy, width, height, self.radius, self.radius)
        end
        pop()
        self:update()
    end

    ---@param component NovaKIT.Component
    function Stylebox:render(component)
        print('stylebox', component)
        self:draw(component.x, component.y, component.width, component.height)
    end

    return Stylebox
end
