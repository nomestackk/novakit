local novakit = require 'novakit'

local finish = novakit.MultiRender {
  width = 100,
  height = 100,
  shapes = {
    {
      x = 0,
      y = 0,
      width = 1,
      height = 1,
      color = { 1, 1, 1, 1 },
      radius = 0.25
    }
  }
}

local start = novakit.MultiRender {
  width = 100,
  height = 100,
  interpolate = finish,
  animationSpeed = 0.05,
  shapes = {
    {
      x = 0,
      y = 0,
      width = 1,
      height = 1,
      color = { 1, 1, 1, 1 }
    }
  }
}


function love.draw()
  start:draw(0, 0)
end
