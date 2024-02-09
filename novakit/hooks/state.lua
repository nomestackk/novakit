---@alias NovaKIT.State fun(value): NovaKIT.Component?

---Returns a state.
---@param renderer fun(value: any): NovaKIT.Component
return function(renderer)
  local currentValue
  local current

  local replacer = function(value)
    local new = renderer(value)
    current.parent:replace(current, new)
    return new
  end

  local function rendererReturn()
    current = renderer(currentValue)
    return current
  end

  local function setterReturn(setter)
    if type(setter) == "function" then
      currentValue = setter(currentValue)
    else
      currentValue = setter
    end
    if current then
      current = replacer(currentValue)
      return current
    end
  end

  return rendererReturn, setterReturn
end
