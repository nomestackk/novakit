# State

State allows you to re-render a component when a value has changed. This is how to do it.

## Basic Usage

Example creating a counter app.

```lua

local novakit = require 'novakit'
local state = require 'novakit/hooks/state'

return function()
  local counter = state(function(value) return novakit.Text { textStyle = novakit.TextStyle { color = { 1, 1, 1, 1 } }, text = tostring(value) } end)

  counter(0)

  return novakit.VDiv {
    children = {
      counter(),
      novakit.Button {
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

```

The function "state" expects a function, this function will receive the current value of the state and must return a component.
It returns a function that will be used for controlling your state.
If you call the function without arguments it will render your function normally
