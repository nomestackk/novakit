local novakit = require 'novakit'
local Task = require 'components.Task'
local vdiv = novakit.VDiv
local state = require 'novakit/hooks/state'

return function(initialValue)
  local render, setTasks
  render, setTasks = state(function(tasks)
    local list = vdiv()
    list:map(tasks, function(value, index)
      return Task {
        debug = true,
        task = value,
        onChange = function()
          setTasks(function(previous)
            previous[index].completed = not previous[index].completed
            return previous
          end)
        end
      }
    end)
    return list
  end)
  setTasks(initialValue or {})
  return render, setTasks
end
