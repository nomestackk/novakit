local novakit = require 'novakit'
local state = require 'novakit/hooks/state'

local vdiv = novakit.VDiv
local text = novakit.Text
local button = novakit.Button

return function()
  local counter = state(function(value) return text { textStyle = novakit.TextStyle { color = { 1, 1, 1, 1 } }, text = tostring(value) } end)

  counter(0)

  return vdiv {
    children = {
      counter(),
      button {
        text = 'Add',
        events = {
          onClick = {
            function()
              counter(function(prev) return prev + 1 end)
            end
          }
        }
      }
    }
  }
end
