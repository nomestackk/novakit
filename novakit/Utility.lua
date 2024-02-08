local print = print

local IsHintEnabled = true
local AgressiveMode = true

---@param message string
local function Hint(message)
    if IsHintEnabled then
        print('[Hint]: ' .. tostring(message))
    end
end

local function Throw(message, level)
    if AgressiveMode then
        error(message, level)
    else
        print('[Error]: ' .. tostring(message))
    end
end

local function ExpectType(object, expected, argumentName, level)
    local actualType = type(object)
    if actualType ~= expected then
        Throw('Argument \'' ..
            tostring(argumentName) ..
            '\' is expected to be: \'' .. expected .. '\' but instead it is: \'' .. actualType .. '\'', level or 4)
        return false
    end
    return true
end

---@class NovaKIT.Utility
local Utility = {
    Hint = Hint,
    ExpectType = ExpectType,
    Throw = Throw
}

return Utility
