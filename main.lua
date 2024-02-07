local novakit = require 'novakit'

local root = novakit.Center {
  children = {
    novakit.Panel {
      stylebox = novakit.Stylebox {
        shrink = -8,
        color = { 0.75, 0.75, 0.75, 1 },
      },
      root = novakit.VDiv {
        width = 400,
        height = 300,
        children = {
          novakit.Text 'Admin Password:',
          novakit.Button '',
          novakit.Button 'Log In'
        }
      } -- VDiv
    }   -- Panel
  }
}       -- Center
root:align()

function love.draw()
  root:draw()
end
