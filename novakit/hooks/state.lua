local assert = assert
local type = type

---@param factory fun(value: any): NovaKIT.Component
return function(factory)
  local state, component

  local replace = function(value)
    local new = factory(value)
    if new.align then new:align() end ---@diagnostic disable-line
    component.parent:replace(component, new)
    return new
  end

  local function render()
    component = factory(state)
    assert(component, "component function factory must return a component")
    return component
  end

  local function set(value)
    if type(value) == 'function' then
      state = value(state)
    else
      state = value
    end
    if component then
      component = replace(state)
      return component
    end
  end

  return render, set
end
