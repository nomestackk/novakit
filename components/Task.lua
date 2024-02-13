local novakit = require 'novakit'
local hdiv = novakit.HDiv
local checkbox = novakit.Checkbox
local text = novakit.Text

---@param props { task: Task, onChange: function }
return function(props)
  local task = props.task
  local onChange = props.onChange
  return hdiv {
    children = {
      task.description,
      checkbox {
        width = 40,
        height = 40,
        checked = task.completed,
        onchange = onChange
      }
    }
  }
end
