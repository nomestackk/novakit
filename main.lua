local novakit = require 'novakit'

local root = novakit.Container()

local topbar = root:addImmutable(novakit.HDiv { alignmentMethod = 'position', height = 50 }) ---@cast topbar NovaKIT.HDiv
local statusText = topbar:addImmutable(novakit.Text { text = 'Completed: 0/0', width = topbar.width - 100, height = topbar.height })
local clear = topbar:addImmutable(novakit.Button { text = 'Clear', width = 100, height = 50 })
clear:right()

local tasks = root:addImmutable(novakit.VDiv { alignmentMethod = 'position', y = topbar.height, height = root.height - topbar.height })

local floatingAddButton = root:addImmutable(novakit.Button { antiAlign = true, text = '+', width = 64, height = 64 })
floatingAddButton:bottom(32)
floatingAddButton:right(32)
floatingAddButton:addEventListener('onClick', function(self, ...)
  tasks = tasks + novakit.Text { text = 'New Task', height = 50 }
end)

function love.draw()
  root:draw()
end
