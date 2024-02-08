local print = print
local error = error
local tostring = tostring

local IsHintEnabled = true
local AgressiveMode = true

local function Clamp(a, m, n)
    if a < m then return m end
    if a > n then return n end
    return a
end

local function Smooth(a, b, amount)
    local t = Clamp(amount, 0, 1)
    local m = t * t * (3 - 2 * t)
    return a + (b - a) * m
end

local function SmoothColor(from, to, speed)
    from[1] = Smooth(from[1], to[1], speed)
    from[2] = Smooth(from[2], to[2], speed)
    from[3] = Smooth(from[3], to[3], speed)
    from[4] = Smooth(from[4], to[4], speed)
end

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
    Throw = Throw,
    Smooth = Smooth,
    SmoothColor = SmoothColor
}

return Utility
