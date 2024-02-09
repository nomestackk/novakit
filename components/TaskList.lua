local novakit = require "novakit"
local state = require "novakit/hooks/state"

return function(initialValue)
  local taskList, setTaskList = state(function(value)
    local vdiv = novakit.VDiv()
    for i = 1, #value do
      vdiv:addImmutable(value[i])
    end
    return vdiv
  end)
  setTaskList(initialValue or {})
  return taskList, setTaskList
end
