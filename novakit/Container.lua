local path           = (...):gsub('Container', '')
local Component      = require(path .. '.Component') ---@type fun(...): NovaKIT.Component
local Text           = require(path .. '.Text') ---@type fun(...): NovaKIT.Text

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
---@param settings? NovaKIT.ContainerSettings A table containing the settings of the Container. This argument can be nil.
---@param name? string
return function(settings, name)
    settings = settings or EMPTY

    ---@class NovaKIT.Container: NovaKIT.Component
    local Container = Component(settings, name or 'Container')

    setmetatable(Container, metatable)

    Container.alignmentMethod = settings.alignmentMethod or 'position+size'
    Container.gap = settings.gap or 0
    Container.children = settings.children or {} ---@type NovaKIT.Component[]|NovaKIT.Container[]

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

    ---Calls `Container:alignPosition()` and `Container:alignSize()` on this container
    ---based on the value of `Container.alignmentMethod`.
    ---If the alignment method is equal to 'position+size' then it will align the position
    ---and the size. If the alignment method is equal to 'position' it will align only the
    ---position. If the alignment method is equal to 'size' it will align only the size.
    function Container:align()
        if self.alignmentMethod == 'position+size' then
            self:alignSize()
            self:alignPosition()
        elseif self.alignmentMethod == 'position' then
            self:alignPosition()
        elseif self.alignmentMethod == 'size' then
            self:alignSize()
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
    function Container:add(component)
        if (type(component) ~= 'table') then
            component = Text(tostring(component))
        end
        self.children[#self.children + 1] = component ---@diagnostic disable-line
        component.parent = self ---@diagnostic disable-line
        self:align()
        return component
    end

    ---Adds `component` to the list of children of this Component but doesn't call `Container:align()`.
    ---@generic T: NovaKIT.Component|string
    ---@param component T
    ---@return NovaKIT.Component|NovaKIT.Container
    function Container:addImmutable(component)
        if (type(component) ~= 'table') then
            component = Text(tostring(component))
        end
        self.children[#self.children + 1] = component ---@diagnostic disable-line
        component.parent = self ---@diagnostic disable-line
        return component
    end

    ---@generic T
    ---@param tbl T[]
    ---@param fun fun(value: T): NovaKIT.Component
    ---@param dontAlign? boolean
    function Container:map(tbl, fun, dontAlign)
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
            self:execute('draw')
            self:call('draw')
        end
        self:drawDebugInformation()
    end

    return Container
end
