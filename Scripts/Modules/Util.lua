-- Utility functions.
sm.scrapcomputers.util = {}


---Reimplementation of sm.util.positiveModulo. 
---@param x number The number to divide
---@param n number The amount to divide
---@return number remainder The remains that it is impossible to divide
function sm.scrapcomputers.util.positiveModulo(x, n)
    -- Funfact, this is more accurate than SM's positiveModulo function.
    -- They seriously cant code a proper simple fucking thing
    sm.scrapcomputers.errorHandler.assertArgument(x, 1, {"number"})
    sm.scrapcomputers.errorHandler.assertArgument(n, 1, {"number"})

    local result = x % n

    if result < 0 and n >= 0 then
        result = result + n
    end

    return result
end

---This generates an interpolated gradient between the numbers provided and is dependent on the ammount of gradient specified.
---@param numbers number[] The table of numbers to generate the gradient from.
---@param numNumbers integer The ammount of blending each number gets in the gradient table.
---@return number[] numberGradient The generated gradient table.
function sm.scrapcomputers.util.generateNumberGradient(numbers, numNumbers)
    sm.scrapcomputers.errorHandler.assertArgument(numbers, 1, {"table"}, {"number[]"})
    sm.scrapcomputers.errorHandler.assertArgument(numNumbers, 2, {"number"})

    local gradient = {}

    for i = 1, numNumbers do
        local p = (i - 1) / (numNumbers - 1)
        local segment = math.floor(p * (#numbers - 1))
        local t = (p * (#numbers - 1)) - segment

        local num1 = numbers[segment + 1]
        local num2 = numbers[segment + 2] or num1

        local interpolatedNumber = num1 + (num2 - num1) * t
        table.insert(gradient, interpolatedNumber)
    end

    return gradient
end

---Maps a value from rangeA (fromMin & fromMax) to rangeB (toMin & toMax)
---@param value number The number to map
---@param fromMin number The old mininum range.
---@param fromMax number The old max range.
---@param toMin number The new mininum range.
---@param toMax number The new max range.
---@return number
function sm.scrapcomputers.util.mapValue(value, fromMin, fromMax, toMin, toMax)
    sm.scrapcomputers.errorHandler.assertArgument(value  , 1, {"number"})
    sm.scrapcomputers.errorHandler.assertArgument(fromMin, 2, {"number"})
    sm.scrapcomputers.errorHandler.assertArgument(fromMax, 3, {"number"})
    sm.scrapcomputers.errorHandler.assertArgument(toMin  , 4, {"number"})
    sm.scrapcomputers.errorHandler.assertArgument(toMax  , 5, {"number"})

    local ratio = (value - fromMin) / (fromMax - fromMin)
    return toMin + (ratio * (toMax - toMin))
end


function sm.scrapcomputers.util.setmetatable(tbl, metatable)
    for index, value in pairs(metatable) do
        tbl[index] = value
    end

    tbl["__raw_metatable"] = metatable
    tbl = class(tbl)()

    return tbl
end

function sm.scrapcomputers.util.getmetatable(tbl)
    return sm.scrapcomputers.table.clone(tbl["__raw_metatable"])
end