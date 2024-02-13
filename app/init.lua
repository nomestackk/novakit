local novakit = require 'novakit'
local vdiv = novakit.VDiv
local hdiv = novakit.HDiv
local button = novakit.Button
local text = novakit.Text
local tablex = require('novakit.libs.table')

local CreateTaskList = require 'components/TaskList'

---@class Task
---@field description string
---@field completed boolean

return function()
  local TaskList, setTaskList = CreateTaskList { { description = "New Task", completed = false } }
  return vdiv {
    children = {
      text 'Your tasks',
      TaskList(),
      hdiv {
        children = {
          button {
            text = 'Add',
            width = 100,
            height = 50,
            onclick = function()
              setTaskList(function(previous)
                previous[#previous + 1] = {
                  description = "New Task",
                  completed = false
                }
                return previous
              end)
            end
          }, -- Button
          button {
            text = "Clear Completed",
            width = 100,
            height = 50,
            onclick = function()
              setTaskList(function(previous)
                return tablex.filter(previous, function(task) return not task.completed end)
              end)
            end
          }
        }
      } -- HDiv
    }
  }     -- VDiv
end
