local path = (...):gsub('Component', '')
local Stylebox = require(path .. '.Stylebox') ---@type fun(...): NovaKIT.Stylebox
local TextStyle = require(path .. '.TextStyle') ---@type fun(...): NovaKIT.TextStyle

local getWidth = love.graphics.getWidth
local getHeight = love.graphics.getHeight
local getOS = love.system.getOS
local isDown = love.mouse.isDown
local getPosition = love.mouse.getPosition
local s = tostring

local IS_IN_MOBILE_DEVICE = getOS() == 'Android' or getOS() == 'iOS'

---@param x number
---@param y number
---@param width number
---@param height number
---@param pointX number
---@param pointY number
local function getPointInsideOf(x, y, width, height, pointX, pointY)
    return pointX > x and pointX < x + width and pointY > y and pointY < y + height
end

local lastCursor = love.mouse.getSystemCursor 'arrow'
local setCursor = love.mouse.setCursor

local function cursor(newCursor)
    setCursor(newCursor)
end

---@class NovaKIT.ComponentSettings
---@field name? string
---@field cursor? love.CursorType
---@field x? number
---@field y? number
---@field width? number
---@field height? number
---@field rotation? integer
---@field events? table<NovaKIT.ComponentEventName, function[]> Represents a queue list of callbacks.
---@field mouseListener? 1|2|3 Determines which mouse button will be heard when clicks are calculated.
---@field parent? NovaKIT.Container Components may have a Container as its parent. If it has this field represents the parent.
---@field display? boolean Determines whether this component is going to be rendered or not.
---@field enabled? boolean Determines whether this component is going to execute other events (except 'draw').
---@field antiAlign? boolean

---@alias NovaKIT.ComponentEventName
---| 'onClick'
---| 'onRelease'
---| 'onEnter'
---| 'onLeave'
---| 'draw'
---| string

local EMPTY = {}
local DebugTransparentColor = { 0.05, 1, 0.2, 0.5 }
local DebugSolidColor = { 0.05, 1, 0.2, 1 }
local DebugTextStyle = TextStyle {
    color = DebugSolidColor,
    halign = 'left',
    valign = 'top'
}
local DebugStylebox = Stylebox {
    color = DebugTransparentColor,
    border = 1,
    borderColor = DebugSolidColor
}

---@param settings? NovaKIT.ComponentSettings
---@param name? string
return function(settings, name)
    settings = settings or EMPTY

    if settings.enabled == nil then settings.enabled = true end
    if settings.display == nil then settings.display = true end
    if settings.antiAlign == nil then settings.antiAlign = false end

    ---@class NovaKIT.Component
    ---@field parent NovaKIT.Container?
    local Component = {}

    Component.cursor = settings.cursor and love.mouse.getSystemCursor(settings.cursor)
    Component.antiAlign = settings.antiAlign
    Component.debug = false
    Component.name = name or settings.name or 'BaseComponent'
    Component.parent = settings.parent
    Component.x = settings.x or 0
    Component.y = settings.y or 0
    Component.width = settings.width or getWidth()
    Component.height = settings.height or getHeight()
    Component.rotation = settings.rotation or 0
    Component.events = settings.events or {}
    Component.hovered = false
    Component.clicked = false
    Component.mouseListener = settings.mouseListener or 1
    Component.enabled = settings.enabled
    Component.display = settings.display

    function Component:drawDebugInformation()
        if not self.debug then
            return
        end
        if not self.hovered then
            return
        end
        local info = '<' ..
            self.name ..
            ' /> (' .. s(self.x) .. ', ' .. s(self.y) .. ', ' .. s(self.width) .. ', ' .. s(self.height) .. ')'
        DebugStylebox:draw(self.x, self.y, self.width, self.height)
        DebugTextStyle:draw(info, self.x + 8, self.y + 8, self.width - 16, self.height - 16)
    end

    ---Captures onClick, onRelease, onEnter and onLeave events.
    ---This function is going to return immediately if `Component.enabled` is equal to `false`.
    function Component:capture()
        if not self.enabled then return end
        if IS_IN_MOBILE_DEVICE then
            -- TODO: Add mobile touch input.
        else
            local mouseX, mouseY = getPosition()
            local hovered = getPointInsideOf(self.x, self.y, self.width, self.height, mouseX, mouseY)
            local clicked = hovered and isDown(self.mouseListener)
            if hovered then
                if not self.hovered then
                    self:execute('onEnter')
                    self.hovered = true
                end
            else
                if self.hovered then
                    self:execute('onLeave')
                    self.hovered = false
                end
            end
            if clicked then
                if not self.clicked then
                    self:execute('onClick')
                    self.clicked = true
                end
            else
                if self.clicked then
                    self:execute('onRelease')
                    self.clicked = false
                end
            end
        end
    end

    ---@param other NovaKIT.Component
    function Component:moveBelow(other)
        self.y = other.y + other.height
    end

    function Component:setAvailableHeight()
        local total = 0
        for i = 1, #self.parent.children do
            local c = self.parent.children[i]
            total = total + c.height
        end
        self.height = total
    end

    ---Executes the `draw` event queue if `Component.display` is equal to `true`.
    function Component:draw()
        if self.enabled then
            self:capture()
        end
        if self.display then
            self:execute 'draw'
        end
    end

    ---Adds an callback to the specified event queue for this Component.
    ---You can add more than one callback to your event queue.
    ---They will be executed in the order you added them when you call `Component:execute()`
    ---@param eventName NovaKIT.ComponentEventName
    ---@param callback fun(self, ...: any): any
    function Component:addEventListener(eventName, callback)
        if not self.events[eventName] then
            self.events[eventName] = {}
        end
        self.events[eventName][#self.events[eventName] + 1] = callback
    end

    ---Executes every callback in the `eventName` event queue of this Component.
    ---If the event queue doesn't exists no error is propagated.
    ---@param eventName NovaKIT.ComponentEventName The name of the event queue.
    ---@param ... any Arguments to give for each callback.
    function Component:execute(eventName, ...)
        if self.events[eventName] then
            for index = 1, #self.events[eventName] do
                local event = self.events[eventName][index]
                event(self, ...)
            end
        end
    end

    Component:addEventListener('onEnter', function(self) if (self.cursor) then cursor(self.cursor) end end)
    Component:addEventListener('onLeave', function(self) if (self.cursor) then cursor(lastCursor) end end)

    return setmetatable(Component, {
        __tostring = function(self)
            return '<' .. self.name .. ' />'
        end
    })
end
