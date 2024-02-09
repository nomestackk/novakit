local novakit  = require 'novakit'
local TaskList = require 'components/TaskList'
local Scaffold = require 'novakit/Scaffold'
local AppBar   = require 'novakit/AppBar'

return function()
  local taskList, setTaskList = TaskList()

  return Scaffold {
    appBar = AppBar(),
  }

  -- return novakit.VDiv {
  --   children = {
  --     taskList(),
  --     novakit.HDiv {
  --       children = {
  --         novakit.Button {
  --           text = 'Add',
  --           onclick = function()
  --             setTaskList(function(prev)
  --               prev[#prev + 1] = 'New Task'
  --               return prev
  --             end)
  --           end
  --         } -- Button
  --       }
  --     }     -- HDiv
  --   }
  -- }         -- VDiv
end
