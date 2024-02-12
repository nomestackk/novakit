local novakit = require 'novakit'

local container = novakit.Container()

local hdiv = container:add(novakit.HDiv {
  children = {
    novakit.Button("1"),
    novakit.Button("2")
  }
})


function love.draw()
  container:draw()
end
