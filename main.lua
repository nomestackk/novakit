local novakit = require 'novakit'
local bootstrap = novakit.Builtin.Bootstrap

local root = novakit.Center {
  children = {
    bootstrap.Button {
      text = "Bootstrap Button"
    }
  }
} -- Center
root:align()

function love.draw()
  root:draw()
end
