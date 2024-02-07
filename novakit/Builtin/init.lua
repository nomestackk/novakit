local path = (...):gsub("init", "")

---@class NovaKIT.Builtin
local Builtin = {}

Builtin.Bootstrap = require(path .. '.Bootstrap') ---@type NovaKIT.Builtin.Bootstrap

return Builtin
