---@class NovaKIT.TableModule
local module = {}

---@generic T
---@param table T[]
---@param callback fun(value: T, index: integer, table: T[])
---@param start? integer
function module.foreach(table, callback, start)
  start = start or 1
  for index = start, #table do
    callback(table[index], index, table)
  end
end

---@generic T
---@generic E
---@param table T[]
---@param callback fun(value: T, index: integer, table: T[]): E
---@param start? integer
---@return E[] result
function module.map(table, callback, start)
  start = start or 1
  local result = {}
  for index = start, #table do
    result[#result + 1] = callback(table[index], index, table)
  end
  return result
end

---@generic T
---@param table T[]
---@param callback fun(value: T, index: integer, table: T[]): boolean
---@param start? integer
---@return T[] result
function module.filter(table, callback, start)
  start = start or 1
  local result = {}
  for index = start, #table do
    if callback(table[index], index, table) then
      result[#result + 1] = table[index]
    end
  end
  return result
end

---@param table table
---@return 'array'|'object'
function module.type(table)
  assert(type(table) == "table", "bad argument #1 to table.type, expected table got: " .. type(table))
  local array = #table > 0 and next(table, #table) == nil
  return array and 'array' or 'object'
end

return module
