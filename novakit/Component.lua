local middleclass = require(NovaPath .. '.libs.middleclass') ---@type middleclass
local Stylebox = require(NovaPath .. '.Stylebox') ---@type fun(...): NovaKIT.Stylebox
local TextStyle = require(NovaPath .. '.TextStyle') ---@type fun(...): NovaKIT.TextStyle

local getWidth = love.graphics.getWidth
local getHeight = love.graphics.getHeight
local getOS = love.system.getOS
local isDown = love.mouse.isDown
local getPosition = love.mouse.getPosition
local getSystemCursor = love.mouse.getSystemCursor

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

local EMPTY = {}

local DebugTextStyle = TextStyle {
  color = { 0.05, 1, 0.2, 1 },
  halign = 'left',
  valign = 'top'
}
local DebugStylebox = Stylebox {
  color = { 0.05, 1, 0.2, 0.5 },
  border = 1,
  borderColor = { 0.05, 1, 0.2, 1 }
}

---@class NovaKIT.Component: middleclass.Class
---@operator call: NovaKIT.Component
local Component = middleclass 'Component'

---@param settings NovaKIT.ComponentSettings
function Component:initialize(settings)
  settings = settings or EMPTY

  if settings.enabled == nil then settings.enabled = true end
  if settings.display == nil then settings.display = true end
  if settings.antiAlign == nil then settings.antiAlign = false end

  self.enabled = settings.enabled
  self.display = settings.display
  self.x = settings.x or 0
  self.y = settings.y or 0
  self.rotation = settings.rotation or 0
  self.mouseListener = settings.mouseListener or 1
  self.width = settings.width or getWidth()
  self.height = settings.height or getHeight()
  self.cursor = settings.cursor and getSystemCursor(settings.cursor)
  self.antiAlign = settings.antiAlign
  self.debug = false
  self.hovered = false
  self.clicked = false
  self.parent = settings.parent
  self.events = settings.events or {
    onClick = settings.onclick,
    onRelease = settings.onrelease,
    onEnter = settings.onenter,
    onLeave = settings.onleave,
    draw = settings.draw
  }
end

---@param display boolean
function Component:setDisplay(display)
  self.display = display
  if self.parent then
    self.parent:align()
  end
end

---@param event NovaKIT.ComponentEventName
---@param callback function
function Component:on(event, callback)
  self.events[event] = callback
end

---@return boolean alignable
function Component:isAlignable()
  return self.display and not self.antiAlign ---@diagnostic disable-line
end

function Component:drawDebugInformation()
  if not self.hovered then return end
  local information = tostring(self)
  DebugStylebox:render(self)
  DebugTextStyle:render(information, self)
end

function Component:capture()
  if not self.enabled then return end
  if IS_IN_MOBILE_DEVICE then
    -- TODO
  else
    local mouseX, mouseY = getPosition()
    local hovered = getPointInsideOf(self.x, self.y, self.width, self.height, mouseX, mouseY)
    local clicked = hovered and isDown(self.mouseListener)
    if hovered then
      if not self.hovered then
        self:execute 'onEnter'
        self.hovered = true
      end
    else
      if self.hovered then
        self:execute 'onLeave'
        self.hovered = false
      end
    end
    if clicked then
      if not self.clicked then
        self:execute 'onClick'
        self.clicked = true
      end
    else
      if self.clicked then
        self:execute 'onRelease'
        self.clicked = false
      end
    end
  end
end

---@param offset number?
function Component:center(offset)
  offset = offset or 0
  local parent = self.parent
  if parent then self.x = (parent.x + parent.width / 2) - (self.width / 2) + offset end
end

---@param offset number?
function Component:middle(offset)
  offset = offset or 0
  local parent = self.parent
  if parent then self.y = (parent.y + parent.height / 2) - (self.height / 2) + offset end
end

---@param margin number?
function Component:top(margin)
  margin = margin or 0
  local parent = self.parent
  if parent then self.y = parent.y + margin end
end

---@param margin number?
function Component:bottom(margin)
  margin = margin or 0
  local parent = self.parent
  if parent then self.y = (parent.y + parent.height) - (self.height + margin) end
end

---@param margin number?
function Component:left(margin)
  margin = margin or 0
  local parent = self.parent
  if parent then self.x = parent.x + margin end
end

---@param margin number?
function Component:right(margin)
  margin = margin or 0
  local parent = self.parent
  if parent then self.x = (parent.x + parent.width) - (self.width + margin) end
end

---@param target NovaKIT.Component
function Component:moveBelow(target)
  self.y = target.y + target.height
end

function Component:draw()
  if self.enabled then self:capture() end
  if self.display then self:execute 'draw' end
end

---@param event NovaKIT.ComponentEventName
---@param callback fun(self, ...: any): any
function Component:addEventListener(event, callback)
  local events = self.events
  if not events[event] then events[event] = {} end
  local queue = events[event]
  queue[#queue + 1] = callback
end

---@param name NovaKIT.ComponentEventName
---@param ... any
function Component:execute(name, ...)
  if self.events[name] then
    local queue = self.events[name]
    if type(queue) == "function" then
      queue(self, ...)
    else
      for index = 1, #queue do
        local event = queue[index] ---@diagnostic disable-line
        event(self, ...)
      end
    end
  end
end

return Component
