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

---Reimplementation of LUA's set metatable function.
---@param tbl table The table to modify.
---@param metatable table The metatable data to set to the given table.
---@return table
function sm.scrapcomputers.util.setmetatable(tbl, metatable)
    sm.scrapcomputers.errorHandler.assertArgument(tbl, 1, {"table"})
    sm.scrapcomputers.errorHandler.assertArgument(metatable, 2, {"table"})
        
    for index, value in pairs(metatable) do
        tbl[index] = value
    end

    tbl = class(tbl)

    local metatableIndex = metatable.__index
    if metatableIndex then
        local metatableIndexType = type(metatableIndex)
        tbl.__index = function(tbl, key)
            if key == "__raw_metatable" then
                return metatable
            end

            if metatableIndexType == "table" then
                return metatableIndex[key]
            elseif metatableIndexType == "function" then
                return metatableIndex(tbl, key)
            end
            
            return nil
        end
    end

    local metatableNewIndexEnabled = false
    local metatableNewIndex = metatable.__newindex
    if metatableNewIndex then
        metatable.__newindex = function (tbl, key, value)
            if metatableNewIndexEnabled then
                return metatableNewIndex(tbl, key, value)
            end

            tbl[key] = value
        end
    end

    tbl = tbl()

    for key, _ in pairs(metatable) do
        tbl[key] = nil
    end

    metatableNewIndexEnabled = true

    return tbl
end

---Returns the metatable data of a table.
---@param tbl table The table to retreive the data from.
---@return table
function sm.scrapcomputers.util.getmetatable(tbl)
    return unpack({tbl["__raw_metatable"]}) -- Cant use sm.scrapcomputers.table.clone without a recursive issue
end

---Applies the rpairs algorithm to a table.
---@param tbl table the table to modify.
---@return function
function sm.scrapcomputers.util.rpairs(tbl)
    local stack = {{tbl, nil}}

    return function()
        while #stack > 0 do
            local current = stack[#stack]
            local t, key = current[1], current[2]

            local next_key, value = next(t, key)
            current[2] = next_key

            if next_key == nil then
                table.remove(stack)
            else
                if type(value) == "table" then
                    table.insert(stack, {value, nil})
                else
                    return value
                end
            end
        end
    end
end

---Rounds a value with a given decimal point.
---@param number number The number to round.
---@param dp number The decimal point to round to (1 is 0.1, 2 is 0.01 etc).
---@reutrn number
function sm.scrapcomputers.util.round(number, dp)
    sm.scrapcomputers.errorHandler.assertArgument(number, 1, {"number"})
    sm.scrapcomputers.errorHandler.assertArgument(dp, 2, {"number"})
    dp = math.floor(dp)
    
    local mult = 10 ^ dp
    return math.floor(number * mult + 0.5) / mult
end