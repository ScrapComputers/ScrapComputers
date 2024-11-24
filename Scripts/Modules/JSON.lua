-- This game fucking sucks. Like why cant they just make sm.json.parseJsonString not crash your fucking
-- game when you put this into it: {iHateEndUsers = true, 0x47} and make simdjson shit itself.

-- Safer version of converting a table to json and vise versa
sm.scrapcomputers.json = {}

---Returns true if the table is safe for JSON conversion!
---@param root table The table to check
---@return boolean jsonSafe If its safe for JSON usage or not.
function sm.scrapcomputers.json.isSafe(root)
    sm.scrapcomputers.errorHandler.assertArgument(root, nil, {"table"})

    local defualtIndexType = nil
    
    for index, value in pairs(root) do
        local indexType = type(index)
        
        defualtIndexType = defualtIndexType or indexType

        if indexType ~= defualtIndexType then
            return false
        end

        if type(value) == "table" then
            local isSafe = sm.scrapcomputers.json.isSafe(value)

            if not isSafe then
                return false
            end
        end
    end

    return true
end

---Prettifies a json string
---@param jsonString string The string to prettify
---@param indentCharacter string? The character to use for indentation
---@return string prettifiedString The pretified string.
local function prettifyJsonString(jsonString, indentCharacter)
    indentCharacter = indentCharacter or "\t"

    local prettyString = ""
    local level = 0
    local in_string = false

    for i = 1, #jsonString do
        local character = jsonString:sub(i, i)

        if character == '"' and (i == 1 or jsonString:sub(i - 1, i - 1) ~= '\\') then
            in_string = not in_string
        end

        if not in_string then
            if character == "{" or character == "[" then
                level = level + 1
                prettyString = prettyString..character.."\n"..indentCharacter:rep(level)
            elseif character == "}" or character == "]" then
                level = level - 1
                prettyString = prettyString.."\n"..indentCharacter:rep(level)..character
            elseif character == "," then
                prettyString = prettyString..character.."\n"..indentCharacter:rep(level)
            elseif character == ":" then
                prettyString = prettyString..": "
            else
                prettyString = prettyString..character
            end
        else
            prettyString = prettyString..character
        end
    end

    return prettyString
end

---Converts a table to a string
---@param root table The table to convert
---@param safeMode boolean? If it should care about saftey or not
---@param prettifyOutput boolean? If it should be prettified or not
---@param indentCharacter string The indentation character
---@return string jsonString The converted string
function sm.scrapcomputers.json.toString(root, safeMode, prettifyOutput, indentCharacter)
    safeMode = safeMode or true
    prettifyOutput = prettifyOutput or false

    sm.scrapcomputers.errorHandler.assertArgument(root, 1, {"table"})
    sm.scrapcomputers.errorHandler.assertArgument(safeMode, 2, {"boolean", "nil"})
    sm.scrapcomputers.errorHandler.assertArgument(prettifyOutput, 3, {"boolean", "nil"})
    sm.scrapcomputers.errorHandler.assertArgument(indentCharacter, 4, {"string", "nil"})
    
    if safeMode and not sm.scrapcomputers.json.isSafe(root) then error("Game crash prevented!") end

    local jsonString = sm.json.writeJsonString(root)

    if prettifyOutput then
        return prettifyJsonString(jsonString, indentCharacter)
    end

    return jsonString
end

---Converts it to a table
---@param root string The json string to convert to a table
---@return table tbl The table from json string
function sm.scrapcomputers.json.toTable(root)
    sm.scrapcomputers.errorHandler.assertArgument(root, 1, {"string"})
    
    return sm.json.parseJsonString(root)
end

local operatorColor = "#D4D4D4"
local textColor = "#9CDCFE"
local stringColor = "#CE9178"
local numberColor = "#B5CEA8"
local booleanColor = "#569CCB"
local operator2Colors = {
    "#FFD700",
    "#DA70D6",
    "#179FFF"
}

---Adds syntax highlighting to the json tab. Note that it will be automaticly prettified.
function sm.scrapcomputers.json.prettifyTable(rootContents)
    sm.scrapcomputers.errorHandler.assertArgument(rootContents, 1, {"table"})

    local output = ""
    
    local function selectOperatorColorBasedOnLevel(level)
        return operator2Colors[(level - 1) % #operator2Colors + 1]
    end

    local function prettifyTable(data, level, hasMoreData)
        local isDict = sm.scrapcomputers.table.isDictonary(data)
        output = output .. selectOperatorColorBasedOnLevel(level) .. (isDict and "{" or "[")

        local dataSize = sm.scrapcomputers.table.getTableSize(data)
        if dataSize ~= 0 then
            output = output  .. "\n"

            local numberIndex = 1
            for index, value in pairs(data) do
                if isDict then
                    output = output .. ("\t"):rep(level) .. textColor .. "\"" .. index .. "\"" .. operatorColor .. ": "
                else
                    output = output .. ("\t"):rep(level)
                end
    
                local valueType = type(value)
                if valueType == "table" then
                    prettifyTable(value, level + 1, numberIndex ~= dataSize)
                elseif valueType == "string" then
                    local safeText = value:gsub("\\", "⁄")
                    local safeEscapeCodes = {"⁄b", "⁄f", "⁄n", "⁄r", "⁄t"}
                    for key, value in pairs({"\b", "\f", "\n", "\r", "\t"}) do
                        safeText = safeText:gsub(value, safeEscapeCodes[key])
                    end
                    output = output .. stringColor .. "\"" .. safeText .. "\""
                elseif valueType == "number" then
                    output = output .. numberColor .. tostring(value)
                else
                    output = output .. booleanColor .. (value and "true" or "false")
                end

                if valueType ~= "table" then
                    if dataSize ~= numberIndex then
                        output = output .. operatorColor .. ","
                    end
    
                    output = output .. "\n"
                end
    
                numberIndex = numberIndex + 1
            end
        end
        
        output = output .. ("\t"):rep(level - 1) .. selectOperatorColorBasedOnLevel(level) .. (isDict and "}" or "]")
        if hasMoreData then
            output = output .. operatorColor .. ","
        end
        output = output  .. "\n"
    end

    prettifyTable(rootContents, 1, false)
    return output
end

function sm.scrapcomputers.json.prettifyString(root)
    sm.scrapcomputers.errorHandler.assertArgument(root, nil, {"string"})

    return sm.scrapcomputers.json.prettifyTable(sm.scrapcomputers.json.toTable(root))
end
