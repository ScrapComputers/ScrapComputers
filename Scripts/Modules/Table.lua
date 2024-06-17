--Additonal features for table's.
sc.table = {}

---Merges 2 tables into 1
---@param table1 table The 1st table
---@param table2 table The 2nd table
---@param fullOverwrite boolean? If true, any merging done would make table2 always right. It will not care if table1 is right. table1 element exists in table2? replace with table2.
---@return table
sc.table.merge = function(table1, table2, fullOverwrite)
    fullOverwrite = fullOverwrite or false

    -- Error handling
    assert(type(table1) == "table", "bad argument #1. Expected table, Got "..type(table1).." instead!")
    assert(type(table2) == "table", "bad argument #2. Expected table, Got "..type(table2).." instead!")
    assert(type(fullOverwrite) == "boolean", "bad argument #2. Expected nil or boolean, Got "..type(table2).." instead!")
    
    local mergedTable = unpack({table1})

    -- Helper function to merge two values, considering nested tables
    local function mergeValues(value1, value2)
        if fullOverwrite then
            return value2
        else
            if type(value1) == "table" and type(value2) == "table" then
                return mergeTables(value1, value2) -- Recursively merge nested tables
            elseif type(value1) == "table" then
                return value1 -- Prefer value1 if it's a table
            elseif type(value2) == "table" then
                return value2 -- Prefer value2 if it's a table
            end
            return value2 -- If both are non-table values, prefer value2
        end
    end

    -- Merge contents of table2 to mergedTable
    for key, value in pairs(table2) do
        if mergedTable[key] ~= nil then
            mergedTable[key] = mergeValues(mergedTable[key], value)
        else
            mergedTable[key] = value
        end
    end

    return mergedTable
end

---Clones a table
---@param tbl table The table to clone
---@return table clonedTable The cloned table
sc.table.clone = function (tbl)
    assert(type(tbl) == "table", "Expected table, got "..type(tbl).." instead!") -- Error handling

    return unpack({tbl})
end

---Converts a table to a lua table string
---@param tbl table The table
---@return string luaTableStr The lua table as string.
sc.table.toString = function(tbl)
    assert(type(tbl) == "table", "Expected table, got "..type(tbl).." instead!") -- Error handling

    local str = "{"
    
    for index, v in pairs(tbl) do
        local keyStr, valueStr

        if type(index) == "number" then
            keyStr = ""
        elseif type(index) == "string" then
            keyStr = '["' .. index .. '"]'
        else
            keyStr = sc.toString(index)
        end

        if type(tbl[index]) == "function" then
            valueStr = "function"
        elseif type(tbl[index]) == "table" then
            valueStr = sc.toString(tbl[index])
        elseif type(tbl[index]) == "string" then
            valueStr = '"' .. sc.toString(tbl[index]) .. '"'
        else
            valueStr = sc.toString(tbl[index])
        end

        if keyStr ~= "" then
            str = str .. keyStr .. " = " .. valueStr .. ", "
        else
            str = str .. valueStr .. ", "
        end
    end

    if next(tbl) then
        str = str:sub(1, -3)
    end

    str = str .. "}"

    return str
end

---Gets a element from table, Unlike `tbl[index]` If like the starting element has index 2, doing `tbl[1]` won't work. This fixes that issue.
---@param tbl table
---@param index number
---@return any
sc.table.getItemAt = function(tbl, index)
    assert(type(tbl) == "table", "Expected table, got "..type(tbl).." instead!") -- Error handling

    -- The current index
    local curIndex = 1

    for _, value in pairs(tbl) do
        -- Check if currentIndex matches with index
        if curIndex == index then
            return value -- Return it
        end

        -- Increase curIndex by 1
        curIndex = curIndex + 1
    end

    -- Couldnt find anything! return nil
    return nil
end

---Gets the total elements from a table. Unlike doing #tbl, If the table wasen't using number's as index. the # wouldn't get anything but return 0. This fixes that issue.
---@param tbl table
---@return number
sc.table.getTotalItems = function(tbl)
    assert(type(tbl) == "table", "Expected table, got "..type(tbl).." instead!") -- Error handling

    local totalItems = 0

    -- Get all items (non-nil only) inside the tbl and each item will increase totalItems by 1
    for _, _ in ipairs(tbl) do
        totalItems = totalItems + 1
    end

    -- Return totalItems
    return totalItems
end

-- Like sc.table.getTotalItems but works with dictonaries.
---@param tbl table
---@return number
sc.table.getTotalItemsDict = function(tbl)
    assert(type(tbl) == "table", "Expected table, got "..type(tbl).." instead!") -- Error handling

    local totalItems = 0

    -- Get all items inside the tbl and each item will increase totalItems by 1
    for _, _ in pairs(tbl) do
        totalItems = totalItems + 1
    end

    -- Return totalItems
    return totalItems
end