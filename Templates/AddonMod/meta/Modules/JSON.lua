---Additional JSON features that sm.json dosen't have.
sc.json = {}

---Returns a boolean to see if the root (table) is vaild and dosent cause a crash when u use it in functions
---@param root table
---@return boolean
sc.json.isSafe = function(root)
    assert(type(root) == "table", "Expected table. Got "..type(root).." instead")

    local defualtIndexType = nil
    
    ---Loop through table.
    for index, value in pairs(root) do
        -- If defualtIndexType is nil. set it to the index's type
        if not defualtIndexType then
            defualtIndexType = type(index)
        end

        -- If the index's type is not the same as defualtIndexType, return false as the table would be dangerous to use for functions like sm.json.writeJsonString
        if type(index) ~= defualtIndexType then
            return false
        end

        -- If the valuse is a table. Run sc.json.isSafe again but for that table.
        if type(value) == "table" then
            local isSafe = sc.json.isSafe(value)

            -- If isSafe is false. We already know that the table would be dangerous to use so return false.
            if not isSafe then
                return false
            end
        end
    end

    -- Return true because the for loop above this comment hasent ever returned false then.
    return true
end

---Converts a lua table to a json string. This is the reccommended function as it provides more features and security
---@param root table
---@param safeMode boolean
---@param prettify boolean
---@param indent string?
---@return string
sc.json.toString = function (root, safeMode, prettify, indent)
    safeMode = safeMode or true
    prettify = prettify or false

    assert(type(root) == "table", "bad argument #1. Expected table, Got "..type(root).." instead.")
    assert(type(safeMode) == "boolean", "bad argument #1. Expected boolean or nil, Got "..type(safeMode).." instead.")
    assert(type(prettify) == "boolean", "bad argument #1. Expected boolean or nil, Got "..type(prettify).." instead.")
    assert(type(safeMode) == "boolean", "bad argument #1. Expected boolean or nil, Got "..type(safeMode).." instead.")

    -- If safe mode is eanbled. then use the sm.json.safeWriteJsonString function.
    if safeMode and not sc.json.isSafe(root) then error("Iliegal Table! (If not checked, will cause the game to crash!)") end

    if prettify then
        local function prettify_json(json_str, indent)
            indent = indent or "\t" -- default indentation is two spaces
            local pretty_str = ""
            local level = 0
            local in_string = false
        
            -- Loop through all character's of json_str
            for i = 1, #json_str do
                -- Get the character
                local char = json_str:sub(i, i)
        
                -- Do some funny shit that veradev doesn't wanna expalin
                if char == '"' and (i == 1 or json_str:sub(i - 1, i - 1) ~= '\\') then
                    in_string = not in_string
                end
        
                if not in_string then
                    if char == "{" or char == "[" then
                        level = level + 1
                        pretty_str = pretty_str..char.."\n"..indent:rep(level)
                    elseif char == "}" or char == "]" then
                        level = level - 1
                        pretty_str = pretty_str.."\n"..indent:rep(level)..char
                    elseif char == "," then
                        pretty_str = pretty_str..char.."\n"..indent:rep(level)
                    elseif char == ":" then
                        pretty_str = pretty_str..": "
                    else
                        pretty_str = pretty_str..char
                    end
                else
                    pretty_str = pretty_str..char
                end
            end
        
            return pretty_str
        end

        -- Convert it to json unsafely and prettify it
        return prettify_json(sm.json.writeJsonString(root), indent)
    else
        -- Convert to json unsafely
        return sm.json.writeJsonString(root)
    end
end

---Converts a json string to a lua table. This is the reccommended function as it provides more features and security
---@param root string
---@param safeMode boolean
---@return table
sc.json.toTable = function (root, safeMode)
    safeMode = safeMode or true
    
    assert(type(root) == "string", "bad argument #1. Expected string, Got "..type(root).." instead.")
    assert(type(safeMode) == "boolean", "bad argument #1. Expected boolean or nil, Got "..type(safeMode).." instead.")
    
    -- Convert it to a table
    local newRoot = sm.json.parseJsonString(root)

    -- If safe mode is enabled. Check if it is safe and if not. errot it out.
    if safeMode and not sc.json.isSafe(newRoot) then error("Iliegal Table! (If not checked, will cause the game to crash!)") end
    
    -- Return the new root.
    return newRoot
end