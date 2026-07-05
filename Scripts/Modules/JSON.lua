-- This game fucking sucks. Like why cant they just make sm.json.parseJsonString not crash your fucking
-- game when you put this into it: {iHateEndUsers = true, 0x47} and make the anchient version of jsoncpp shit itself.

local sm_scrapcomputers_errorHandler_assertArgument = sm.scrapcomputers.errorHandler.assertArgument

local sm_scrapcomputers_table_isDictionary = sm.scrapcomputers.table.isDictonary
local sm_scrapcomputers_table_getTableSize = sm.scrapcomputers.table.getTableSize

local type = type
local tostring = tostring
local pairs = pairs
local ipairs = ipairs

local table_concat = table.concat

local string_rep = string.rep
local string_gsub = string.gsub
local string_sub = string.sub
local string_rep = string.rep

local operatorColor   = "#D4D4D4"
local textColor       = "#9CDCFE"
local stringColor     = "#CE9178"
local numberColor     = "#B5CEA8"
local booleanColor    = "#569CCB"
local nilColor        = "#569CCB"
local operator2Colors = { "#FFD700", "#DA70D6", "#179FFF" }

-- Reusable escape replacements (avoids rebuilding the table on every encode call)
local ESCAPE_REPLACEMENTS = {
    ["\\"] = "\\\\",
    ['"']  = '\\"',
    ["\b"] = "\\b",
    ["\f"] = "\\f",
    ["\n"] = "\\n",
    ["\r"] = "\\r",
    ["\t"] = "\\t",
}

local function escapeString(str)
    return string_gsub(str, '[\\"%c]', ESCAPE_REPLACEMENTS)
end

local DISPLAY_ESCAPE_FROM = { "\\", "\b", "\f", "\n", "\r", "\t", '"', "#" }
local DISPLAY_ESACPE_TO   = { "⁄",  "⁄b", "⁄f", "⁄n", "⁄r", "⁄t", '\\"', "##" }

local function makeDisplaySafe(str)
    local outputStr = str
    for index = 1, #DISPLAY_ESCAPE_FROM do
        outputStr = string_gsub(outputStr, DISPLAY_ESCAPE_FROM[index], DISPLAY_ESACPE_TO[index])
    end

    return outputStr
end

local VALID_JSON_KEY_TYPES = { ["string"] = true, ["number"] = true }
local VALID_JSON_VALUE_TYPES = { ["string"] = true, ["number"] = true, ["boolean"] = true, ["nil"] = true, ["table"] = true }

local json = {}

---Returns true if the table is safe for JSON conversion.
---A table is unsafe if it mixes key types (e.g. both string and number keys).
---@param root table The table to check
---@return boolean jsonSafe
function json.isSafe(root)
    sm_scrapcomputers_errorHandler_assertArgument(root, nil, { "table" })

    local defaultIndexType = nil
    for index, value in pairs(root) do
        local indexType = type(index)

        -- JSON only allows string keys in objects and integer keys in arrays
        if indexType ~= "string" and indexType ~= "number" then
            return false
        end

        defaultIndexType = defaultIndexType or indexType

        if indexType ~= defaultIndexType then
            return false
        end

        if type(value) == "table" and not json.isSafe(value) then
            return false
        end
    end

    return true
end

---Prettifies a JSON string
---@param jsonString string
---@param indentCharacter string? Defaults to "\t"
---@return string
local function prettifyJsonString(jsonString, indentCharacter)
    indentCharacter = indentCharacter or "\t"

    local partsIndex = 1
    local parts = {}
    local level = 0
    local inString = false

    for index = 1, #jsonString do
        local character = string_sub(jsonString, index, index)

        if character == '"' and string_sub(jsonString, index - 1, index - 1) ~= '\\' then
            inString = not inString
        end

        if inString then
            parts[partsIndex] = character
            partsIndex = partsIndex + 1
        elseif character == "{" or character == "[" then
            level = level + 1

            parts[partsIndex] = character .. "\n" .. string_rep(indentCharacter, level)
            partsIndex = partsIndex + 1
        elseif character == "}" or character == "]" then
            level = level - 1

            parts[partsIndex] = "\n" .. string_rep(indentCharacter, level) .. character
            partsIndex = partsIndex + 1
        elseif character == "," then
            parts[partsIndex] = character .. "\n" .. string_rep(indentCharacter, level)
            partsIndex = partsIndex + 1
        elseif character == ":" then
            parts[partsIndex] = ": "
            partsIndex = partsIndex + 1
        else
            parts[partsIndex] = character
            partsIndex = partsIndex + 1
        end
    end

    return table_concat(parts)
end

---Converts a value (table, string, number, boolean, or nil) to a JSON string.
---@param root any
---@param safeMode boolean? Defaults to true — rejects tables that are unsafe for JSON
---@param prettifyOutput boolean? Defaults to false
---@param indentCharacter string? Defaults to "\t"
---@return string
function json.toString(root, safeMode, prettifyOutput, indentCharacter)
    if safeMode == nil then safeMode = true end
    prettifyOutput = prettifyOutput or false

    sm_scrapcomputers_errorHandler_assertArgument(root,            1, { "nil", "number", "boolean", "string", "table" })
    sm_scrapcomputers_errorHandler_assertArgument(safeMode,        2, { "boolean", "nil" })
    sm_scrapcomputers_errorHandler_assertArgument(prettifyOutput,  3, { "boolean", "nil" })
    sm_scrapcomputers_errorHandler_assertArgument(indentCharacter, 4, { "string", "nil" })

    assert(type(root) ~= "table" or not safeMode or json.isSafe(root), "Cannot convert table to JSON string, table is dangerous for the game!")

    -- sm.json.writeJsonString is dogshit, infact this reimplementation is actually better!

    local function encode(value)
        local valueType = type(value)

        if valueType == "nil" then
            return "null"
        elseif valueType == "number" then
            if value ~= value or value == math.huge or value == -math.huge then
                return "null"
            end

            return tostring(value)
        elseif valueType == "boolean" then
            return value and "true" or "false"
        elseif valueType == "string" then
            return '"' .. escapeString(value) .. '"'
        elseif valueType == "table" then
            local sequenceLength = #value
            local keyCount = 0
            for _ in pairs(value) do
                keyCount = keyCount + 1
            end

            if sequenceLength == keyCount and sequenceLength > 0 then
                local items = {}
                for index = 1, sequenceLength do
                    items[index] = encode(value[index])
                end

                return "[" .. table_concat(items, ",") .. "]"
            else
                -- Object
                local itemsIndex = 1
                local items = {}
                for innerKey, innerValue in pairs(value) do
                    assert(type(innerKey) == "string" or type(innerKey) == "number", "JSON object keys must be strings or numbers, got " .. type(innerKey))

                    local encodedValue = encode(innerValue)
                    if encodedValue then
                        items[itemsIndex] = '"' .. escapeString(innerKey) .. '":' .. encodedValue
                        itemsIndex = itemsIndex + 1
                    end
                end

                return "{" .. table_concat(items, ",") .. "}"
            end
        end
    end

    local jsonString = encode(root)
    if prettifyOutput then
        return prettifyJsonString(jsonString, indentCharacter)
    end

    return jsonString
end

---Adds syntax highlighting to a value for display. The output is automatically prettified.
---@param rootContents table|string|number|boolean|nil
---@return string
function json.prettifyTable(rootContents)
    sm_scrapcomputers_errorHandler_assertArgument(rootContents, 1, { "table", "string", "number", "boolean", "nil" })

    local rootType = type(rootContents)
    if rootType ~= "table" then
        if rootType == "string" then
            return stringColor .. '"' .. makeDisplaySafe(rootContents) .. '"'
        elseif rootType == "number" then
            return numberColor .. tostring(rootContents)
        elseif rootType == "boolean" then
            return booleanColor .. (rootContents and "true" or "false")
        else
            return nilColor .. "null"
        end
    end

    local outputIndex = 1
    local output = {}

    local function selectOperatorColor(level)
        return operator2Colors[(level - 1) % #operator2Colors + 1]
    end

    local function prettify(data, level, hasMoreData)
        local isDictionary = sm_scrapcomputers_table_isDictionary(data)
        local dataSize = sm_scrapcomputers_table_getTableSize(data)

        output[outputIndex] = selectOperatorColor(level) .. (isDictionary and "{" or "[")
        outputIndex = outputIndex + 1

        if dataSize ~= 0 then
            output[outputIndex] = "\n"
            outputIndex = outputIndex + 1

            local numberIndex = 1
            for index, value in pairs(data) do
                output[outputIndex] = string_rep("\t", level)
                outputIndex = outputIndex + 1

                if isDictionary then
                    output[outputIndex] = textColor .. '"' .. index .. '"' .. operatorColor .. ": "
                    outputIndex = outputIndex + 1
                end

                local vtype = type(value)
                if vtype == "table" then
                    prettify(value, level + 1, numberIndex ~= dataSize)
                elseif vtype == "string" then
                    output[outputIndex] = stringColor .. '"' .. makeDisplaySafe(value) .. '"'
                    outputIndex = outputIndex + 1
                elseif vtype == "number" then
                    output[outputIndex] = numberColor .. tostring(value)
                    outputIndex = outputIndex + 1
                elseif vtype == "boolean" then
                    output[outputIndex] = booleanColor .. (value and "true" or "false")
                    outputIndex = outputIndex + 1
                else
                    output[outputIndex] = nilColor .. "null"
                    outputIndex = outputIndex + 1
                end

                if vtype ~= "table" then
                    if numberIndex ~= dataSize then
                        output[outputIndex] = operatorColor .. ","
                        outputIndex = outputIndex + 1
                    end

                    output[outputIndex] = "\n"
                    outputIndex = outputIndex + 1
                end

                numberIndex = numberIndex + 1
            end

            output[outputIndex] = string_rep("\t", level - 1)
            outputIndex = outputIndex + 1
        end

        output[outputIndex] = selectOperatorColor(level) .. (isDictionary and "}" or "]")
        outputIndex = outputIndex + 1

        if hasMoreData then
            output[outputIndex] = operatorColor .. ","
            outputIndex = outputIndex + 1
        end

        output[outputIndex] = "\n"
        outputIndex = outputIndex + 1
    end

    prettify(rootContents, 1, false)
    return table_concat(output)
end

---Prettifies a JSON string by parsing it first, then calling prettifyTable.
---@param root string
---@return string
function json.prettifyString(root)
    sm_scrapcomputers_errorHandler_assertArgument(root, nil, { "string" })
    return json.prettifyTable(sm.json.parseJsonString(root))
end

---Strips keys and values with types that are not valid in JSON, in-place.
---Valid key types: string, number. Valid value types: string, number, boolean, nil, table.
---@param tbl table The table to sanitize (modified in place)
---@return table
function json.toJsonCompatibleTable(tbl)
    sm_scrapcomputers_errorHandler_assertArgument(tbl, 1, { "table" })

    if sm_scrapcomputers_table_isDictionary(tbl) then
        for key, value in pairs(tbl) do
            if not VALID_JSON_KEY_TYPES[type(key)] or not VALID_JSON_VALUE_TYPES[type(value)] then
                tbl[key] = nil
            elseif type(value) == "table" then
                json.toJsonCompatibleTable(value)
            end
        end
    else
        local cleanIndex = 1
        local clean = {}
        for _, value in ipairs(tbl) do
            if VALID_JSON_VALUE_TYPES[type(value)] then
                clean[cleanIndex] = (type(value) == "table") and json.toJsonCompatibleTable(value) or value
                cleanIndex = cleanIndex + 1
            end
        end

        for index = 1, #tbl do
            tbl[index] = nil
        end

        for index = 1, #clean do
            tbl[index] = clean[index]
        end
    end

    return tbl
end

sm.scrapcomputers.json = json