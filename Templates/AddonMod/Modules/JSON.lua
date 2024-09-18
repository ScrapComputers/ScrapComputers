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
---@param safeMode boolean If you wanted to, you can check if the json somehow had corrupt data that the game didnt caught.
---@return table tbl The table from json string
function sm.scrapcomputers.json.toTable(root, safeMode)
    safeMode = safeMode or true

    sm.scrapcomputers.errorHandler.assertArgument(root, 1, {"string"})
    sm.scrapcomputers.errorHandler.assertArgument(safeMode, 2, {"boolean", "nil"})
    
    local newRoot = sm.json.parseJsonString(root)

    if safeMode and not sm.scrapcomputers.json.isSafe(newRoot) then error("Game crash prevented!") end
    
    return newRoot
end