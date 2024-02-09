---@class NovaKIT.ShapeFormat

---@class NovaKIT.MultiRenderSettings
---@field shapes NovaKIT.ShapeFormat[]

---@param settings NovaKIT.MultiRenderSettings
return function(settings)
  ---@class NovaKIT.MultiRender
  local MultiRender = {}

  MultiRender.shapes = settings.shapes

  function MultiRender:draw(x, y, width, height)
    for index = 1, #self.shapes do
      local shape = self.shapes[index]
    end
  end

  function MultiRender:render(component)

  end

  return MultiRender
end
