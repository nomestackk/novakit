local middleclass = require(NovaPath .. '.libs.middleclass')
local Component   = require(NovaPath .. '.Component') ---@type NovaKIT.Component
local Text        = require(NovaPath .. '.Text') ---@type fun(...): NovaKIT.Text
local Utility     = require(NovaPath .. '.Utility') ---@type NovaKIT.Utility

local EMPTY       = {}

---@class NovaKIT.Container: NovaKIT.Component
---@operator call: NovaKIT.Container
---@field super NovaKIT.Component
local Container   = Component:subclass 'Container'

---@param settings? NovaKIT.ContainerSettings|NovaKIT.Container[]
function Container:initialize(settings)
  settings = settings or EMPTY

  Component.initialize(self, settings)

  self.alignmentMethod = settings.alignmentMethod or 'position'
  self.fixedSize = settings.fixedSize
  self.gap = settings.gap or 0
  self.children = {}

  if Utility.IsArray(settings) then
    for index = 1, #settings do
      self:add(settings[index])
    end
  end
end

---@param object NovaKIT.Component
function Container:index(object)
  local children = self.children
  for index = 1, #children do
    local child = children[index]
    if child == object then
      return index
    end
  end
end

---@param target NovaKIT.Component
---@param to NovaKIT.Component
---@return boolean
function Container:replace(target, to)
  local targetIndex = self:index(target)
  if not self.children[targetIndex] then
    return false
  end
  self:add(to, targetIndex)
  return true
end

---@param dimensionName string
---@return integer dimension
---@protected
function Container:accumulatorDimensionCalc(dimensionName)
  local accum = 0
  self:forEach(function(child)
    accum = accum + child[dimensionName]
  end)
  return accum
end

---@param dimensionName string
---@return integer dimension
---@protected
function Container:greatestDimensionCalc(dimensionName)
  local max = 0
  self:forEach(function(child)
    if child[dimensionName] > max then
      max = child[dimensionName]
    end
  end)
  return max
end

function Container:deepReplace(target, to)
  local replacedInSelf = self:replace(target, to)
  if replacedInSelf then return end
  local children = self.children
  for index = 1, #children do
    local child = children[index]
    if child.replace then
      ---@cast child NovaKIT.Container
      local success = child:replace(target, to)
      if success then
        return true
      end
    end
  end
  return false
end

---@protected
function Container:alignPosition()
end

---@protected
function Container:alignSize()
end

function Container:alignableChildrenCount()
  return #self:filter(function(child) return child:isAlignable() end)
end

---@param callback fun(child)
function Container:forEach(callback)
  if #self.children == 0 then return end
  local children = self.children
  for index = 1, #children do
    local child = children[index]
    callback(child)
  end
end

---@param callback fun(child): boolean
---@nodiscard
function Container:some(callback)
  local children = self.children
  for index = 1, #children do
    local child = children[index]
    if callback(child) == true then
      return true
    end
  end
  return false
end

---@param callback fun(child): boolean
---@nodiscard
function Container:every(callback)
  local children = self.children
  for index = 1, #children do
    local child = children[index]
    if callback(child) == false then
      return false
    end
  end
  return true
end

---@param callback fun(child): boolean
---@nodiscard
function Container:filter(callback)
  local children = self.children
  local result = {}
  for index = 1, #children do
    local child = children[index]
    if callback(child) == true then
      result[#result + 1] = child
    end
  end
  return result
end

function Container:resize()
end

function Container:align()
  if #self.children == 0 then return end
  if self.alignmentMethod == 'position+size' then
    if self.fixedSize then self:alignSize() end
    self:alignPosition()
  elseif self.alignmentMethod == 'position' then
    self:alignPosition()
  elseif self.alignmentMethod == 'size' then
    if self.fixedSize then self:alignSize() end
  end
  if not self.fixedSize then
    self:resize()
  end
  self:forEach(function(child)
    if child.align then
      child:align()
    end
  end)
end

---Adds `component` to the list of children of this Component and calls `Container:align()` after.
---@generic T: NovaKIT.Component|string
---@param component T
---@return NovaKIT.Component|NovaKIT.Container
function Container:add(component, customIndex)
  if (type(component) ~= 'table') then
    component = Text(tostring(component))
  end
  self.children[customIndex or #self.children + 1] = component ---@diagnostic disable-line
  component.parent = self ---@diagnostic disable-line
  self:align()
  return component
end

---Adds `component` to the list of children of this Component but doesn't call `Container:align()`.
---@generic T: NovaKIT.Component|string
---@param component T
---@return NovaKIT.Component|NovaKIT.Container
function Container:addImmutable(component, customIndex)
  if (type(component) ~= 'table') then
    component = Text(tostring(component))
  end
  self.children[customIndex or #self.children + 1] = component ---@diagnostic disable-line
  component.parent = self ---@diagnostic disable-line
  return component
end

---@generic T
---@param table T[]
---@param callback fun(value: T): NovaKIT.Component
---@param dontAlign? boolean
function Container:map(table, callback, dontAlign)
  if #table == 0 then return end
  for index = 1, #table do
    local value = table[index]
    self:addImmutable(callback(value))
  end
  if not dontAlign then
    self:align()
  end
end

function Container:clear()
  local children = self.children
  for index = 1, #children do
    children[index] = nil
  end
end

---@param functionName string Name of the function to be called in every component.
---@param ... any Arguments to give to the function call.
function Container:call(functionName, ...)
  for i = 1, #self.children do
    local child = self.children[i]
    if child.call then ---@diagnostic disable-line
      child:call(functionName, ...) ---@diagnostic disable-line
    end
    if child[functionName] then
      child[functionName](child, ...)
    end
  end
end

function Container:draw()
  if self.enabled then
    self:capture()
  end
  if self.display then
    self:execute 'draw'
    self:call 'draw'
  end
  self:drawDebugInformation()
end

return Container
