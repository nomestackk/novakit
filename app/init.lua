local novakit  = require 'novakit'
local vdiv     = novakit.VDiv
local hdiv     = novakit.HDiv
local button   = novakit.Button
local text     = novakit.Text
local TaskList = require 'components/TaskList'

return function()
  local renderTaskList, setTaskList = TaskList()
  return vdiv {
    width = 800,
    height = 600,
    children = {
      text 'Task List',
      renderTaskList(),
      button 'Test',
      hdiv {
        button {
          text = 'Add',
          width = 100,
          height = 50,
          onclick = function()
            setTaskList(function(prev)
              prev[#prev + 1] = 'New Item'
              return prev
            end)
          end
        },
        button {
          text = 'Clear Selected',
          width = 100,
          height = 50,
          onclick = function()
          end
        }
      }
    }
  }
end
