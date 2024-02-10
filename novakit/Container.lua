local path           = (...):gsub('Container', '')
local Component      = require(path .. '.Component') ---@type fun(...): NovaKIT.Component
local Text           = require(path .. '.Text') ---@type fun(...): NovaKIT.Text
local Utility        = require(path .. '.Utility') ---@type NovaKIT.Utility

local setmetatable   = setmetatable

local tabs           = ''
local EMPTY          = {}

local metatable      = {}

metatable.__tostring = function(self)
    local s = '<' .. self.name .. ' />:\n'
    tabs = tabs .. '\t'
    for i = 1, #self.children do
        local child = self.children[i]
        s = s .. tabs .. tostring(child) .. '\n'
    end
    tabs = string.sub(tabs, 1, #tabs - 2)
    return s
end

metatable.__len      = function(self)
    return #self.children
end

metatable.__add      = function(self, object)
    self:add(object)
    return self
end

---Creates a new Container.
---By default containers automatically aligns its children when its position is mutated.
---This class's won't do anything. See `HDiv`, `VDiv` or `Grid` instead.
---You can add elements to the container using the '+' operator. Example: `myContainer = myContainer + Button({ text = 'Hello World' })`
---You can use `tostring` in containers.
---You can use the '#' operator to get the length of the children list of this container. Example: `print(#myContainer)`.
---@param settings? NovaKIT.ContainerSettings|NovaKIT.Container[] A table containing the settings of the Container. This argument can be nil.
---@param name? string
return function(settings, name)
    settings = settings or EMPTY
    local childrenList

    if Utility.IsArray(settings) then
        childrenList = {}
        for i = 1, #settings do
            childrenList[#childrenList + 1] = settings[i]
        end
    end

    ---@class NovaKIT.Container: NovaKIT.Component
    local Container = Component(settings, name or 'Container')

    setmetatable(Container, metatable)

    Container.fixedSize = settings.fixedSize
    Container.alignmentMethod = settings.alignmentMethod or 'position+size'
    Container.gap = settings.gap or 0
    Container.children = {} ---@type NovaKIT.Component[]|NovaKIT.Container[]

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

    ---This function is designed to mutate the position of every child of this Container.
    ---This function will only be called if `Component.alignmentMethod` is equal to 'position+size' or 'position'.
    ---@protected
    function Container:alignPosition()
    end

    ---This function is designed to mutate the size of every child of this Container.
    ---This function will only be called if `Component.alignmentMethod` is equal to 'position+size' or 'size'.
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

    ---Calls `Container:alignPosition()` and `Container:alignSize()` on this container
    ---based on the value of `Container.alignmentMethod`.
    ---If the alignment method is equal to 'position+size' then it will align the position
    ---and the size. If the alignment method is equal to 'position' it will align only the
    ---position. If the alignment method is equal to 'size' it will align only the size.
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
            print("resize", self)
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
    ---@param tbl T[]
    ---@param fun fun(value: T): NovaKIT.Component
    ---@param dontAlign? boolean
    function Container:map(tbl, fun, dontAlign)
        if #tbl == 0 then return end
        for i = 1, #tbl do
            local value = tbl[i]
            self:addImmutable(fun(value))
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

    ---Executes `functionName` for every child of this Component.
    ---Doesn't propagates an error if `functionName` doesnt exists in some child.
    ---There is no need to write: `Container:call('call', 'functionName')` because if the child has a method called `call`
    ---this method will be executed with the same arguments as this function call.
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

    ---Executes the `draw` event queue if `Component.display` is equal to `true`.
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

    if childrenList then
        for index = 1, #childrenList do
            print('added', childrenList[index])
            Container:addImmutable(childrenList[index])
        end
    else
        if settings.children then
            for index = 1, #settings.children do
                Container:addImmutable(settings.children[index])
            end
        end
    end

    return Container
end
