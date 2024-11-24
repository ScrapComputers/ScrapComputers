sm.scrapcomputers.errorHandler = {}

local sm_scrapcomputers_config = sm.scrapcomputers.config
local tostring, type, pairs, unpack, error, string_format = tostring, type, pairs, unpack, error, string.format

--- Optimized assert function
---@param value any The value to check
---@param argumentIndex integer? The index where this value was
---@param str string The message when it errors
---@param ... any[]
function sm.scrapcomputers.errorHandler.assert(value, argumentIndex, str, ...)
    if value then return end

    local parameters = {...}
    local formattingMessage = str and string_format(str, unpack(parameters)) or "Assertion Failed!"

    local badMessage = argumentIndex and ("Bad argument #" .. tostring(argumentIndex) .. "! ") or ""
    error(badMessage .. formattingMessage)
end

--- Optimized assertArgument function for function arguments
---@param value          any       The value to check
---@param argumentIndex  integer?  Index of the argument (e.g., 3 for the 3rd argument)
---@param allowedTypes   table     List of allowed types
---@param nameOverwrites table?    Optional names to modify error message (e.g., {"number", nil, "string"})
function sm.scrapcomputers.errorHandler.assertArgument(value, argumentIndex, allowedTypes, nameOverwrites)
    local valueType = type(value)
    local isNanValue = (value ~= value)
    local valueHasCorrectType = false

    -- Check NaN config setting
    local shouldCareAboutNanValues = true

    -- This fucking function gets called when Config.lua loads. but its before the Config system gets loaded.
    -- So i gotta do this bullshit. Great infrastructure that VeraDev has made. Great infrastructure asshole.
    if sm_scrapcomputers_config and sm_scrapcomputers_config.configurations then
        for _, config in pairs(sm_scrapcomputers_config.configurations) do
            if config.id == "scrapcomputers.computer.nanvalues" then
                shouldCareAboutNanValues = config.selectedOption == 2
                break
            end
        end
    end

    -- Check allowed types
    if not (isNanValue and shouldCareAboutNanValues) then
        for _, allowedType in pairs(allowedTypes) do
            local allowedTypeName = (allowedType == "integer") and "number" or allowedType
            --                                           Iliegal math.floor version. Dont call the police on us!
            --                                                                    |
            --                                                                    V
            if valueType == allowedTypeName and (allowedType ~= "integer" or value % 1 == 0) then
                valueHasCorrectType = true
                break
            end
        end
    end

    if valueHasCorrectType then return end
    valueType = isNanValue and shouldCareAboutNanValues and "NaN" or valueType

    -- Construct the allowed types message
    local allowedTypesMessage = ""
    for i, allowedType in ipairs(allowedTypes) do
        local typeMessage = nameOverwrites and (nameOverwrites[i] or allowedType) or allowedType
        allowedTypesMessage = allowedTypesMessage .. (i == 1 and "" or (i == #allowedTypes and " or " or ", ")) .. typeMessage
    end

    -- Construct and raise the error
    local badArgument = argumentIndex and ("Bad argument #" .. tostring(argumentIndex) .. "! ") or ""
    error(string_format("%sExpected %s, got %s instead!", badArgument, allowedTypesMessage, valueType))
    -- I really should change this line above to say "Expected bitches, got none instead!"
    -- Is this why i cant get any?
end
