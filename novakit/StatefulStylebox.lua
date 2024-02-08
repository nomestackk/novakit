local EMPTY = {}

---@class NovaKIT.StatefulStyleboxSettings
---@field default string
---@field style table<string, NovaKIT.Stylebox>

---@param settings NovaKIT.StatefulStyleboxSettings
return function(settings)
  settings = settings or EMPTY

  ---@class NovaKIT.StatefulStylebox
  local StatefulStylebox = {}

  StatefulStylebox.default = settings.default
  StatefulStylebox.style = settings.style or {}
  StatefulStylebox.current = {}

  function StatefulStylebox:get()
    return self.style[self.default]
  end

  ---@param component NovaKIT.Component
  function StatefulStylebox:draw(component)
    local style = self:get()
    style:draw(component.x, component.y, component.width, component.height)
  end

  return StatefulStylebox
end
