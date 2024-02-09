# State

State allows you to re-render a component when a value has changed. This is how to do it.

## Basic Usage

Example creating a counter app.

```lua

local novakit = require 'novakit'
local state = require 'novakit/hooks/state'

return function()
  local counter, setCounter = state(function(value) return novakit.Text(value) end)
  setCounter(0)

  return novakit.VDiv {
    children = {
      counter(),
      novakit.Button {
        text = 'Add',
        events = {
          onClick = {
            function()
              setCounter(function(prev) return prev + 1 end)
            end
          }
        }
      }
    }
  }
end

```

The function "state" expects a function, this function will receive the current value of the state and must return a component.
It returns a two functions, one for rendering the component and other to modify the value of the state.
