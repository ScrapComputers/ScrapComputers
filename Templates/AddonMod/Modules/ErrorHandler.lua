---A ErrorHandler to check arguments. Thats all what this contains.
sm.scrapcomputers.errorHandler = {}

---A better assert function
---@param value any The value to check
---@param argumentIndex integer? The index where this value was
---@param str string The message when it errors
---@param ... any[] The arguments for str
function sm.scrapcomputers.errorHandler.assert(value, argumentIndex, str, ...)
    if value then return end

    local parameters = type(...) == "table" and ... or {...}
    local formattingMessage = string.format(str or "Assertion Failed!", unpack(parameters))
    
    local badMessage = ""
    
    if argumentIndex then
        badMessage = "Bad argument #" .. sm.scrapcomputers.toString(argumentIndex) .. "! "
    end

    error(string.format("%s%s", badMessage, formattingMessage))
end

---A assert function for function arguments!
---@param value          any       The value to check
---@param argumentIndex  number  ? If your function has multiple arguments, fill this with the argument index, So let say your checking the 3rd argument. Set this to 3.
---@param allowedTypes   type  []  Contains all allowed types
---@param nameOverwrites string[]? This lets you modify the error message arguments. Basicly the words afther Expected. If you dont want to modify a argument name, Set that value in the table to nil and else a string.
function sm.scrapcomputers.errorHandler.assertArgument(value, argumentIndex, allowedTypes, nameOverwrites)
    local valueHasCorrectType = false
    local valueType = type(value)

    for _, allowedType in pairs(allowedTypes) do
        local allowedTypeName = allowedType == "integer" and "number" or allowedType

        if valueType == allowedTypeName then
            if allowedType ~= "integer" then
                valueHasCorrectType = true
                break
            end
            
            if math.floor(value) == value then
                valueHasCorrectType = true
                break
            end
        end
    end
    
    if valueHasCorrectType then return end
    
    local allowedTypesMessage = ""
    
    if #allowedTypes == 1 then
        allowedTypesMessage = nameOverwrites and (nameOverwrites[1] and nameOverwrites[1] or allowedTypes[1]) or allowedTypes[1]
    else
        for TypeIndex, allowedType in pairs(allowedTypes) do
            local allowedType = nameOverwrites and (nameOverwrites[TypeIndex] or allowedType) or allowedType
            
            if TypeIndex == #allowedTypes then
                allowedTypesMessage = allowedTypesMessage .. " or " .. allowedType
                break
            end
            
            allowedTypesMessage = allowedTypesMessage .. ", " .. allowedType
        end
        
        allowedTypesMessage = allowedTypesMessage:sub(3)
    end
    
    local badArgument = ""
    
    if argumentIndex then
        badArgument = "Bad argument #" .. tostring(argumentIndex) .. "! "
    end
   
    error(string.format("%sExpected %s, got %s instead!", badArgument, allowedTypesMessage, valueType))
end