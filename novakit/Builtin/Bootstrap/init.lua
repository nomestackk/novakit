local path = (...):gsub("init", "")

--TODO

---@class NovaKIT.Builtin.Bootstrap
local Boostrap = {}

Boostrap.Button = require(path .. '.Button') ---@type fun(settings: NovaKIT.ButtonSettings): NovaKIT.Button

return Boostrap
