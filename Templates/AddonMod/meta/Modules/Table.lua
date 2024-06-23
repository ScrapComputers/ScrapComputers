--Additonal features for table's.
sm.scrapcomputers.table = {}

---Merges 2 tables into 1
---@param table1 table The 1st table
---@param table2 table The 2nd table
---@param fullOverwrite boolean? If true, any merging done would make table2 always right. It will not care if table1 is right. table1 element exists in table2? replace with table2.
---@return table mergedTable The merged table
sm.scrapcomputers.table.merge = function(table1, table2, fullOverwrite)
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
                return sm.scrapcomputers.table.merge(value1, value2, fullOverwrite) -- Recursively merge nested tables
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
sm.scrapcomputers.table.clone = function (tbl)
    assert(type(tbl) == "table", "Expected table, got "..type(tbl).." instead!") -- Error handling

    return unpack({tbl})
end

---Converts a table to a lua table string
---@param tbl table The table
---@return string luaTableStr The lua table as string.
sm.scrapcomputers.table.toString = function(tbl)
    assert(type(tbl) == "table", "Expected table, got "..type(tbl).." instead!") -- Error handling

    local str = "{"
    
    for index, v in pairs(tbl) do
        local keyStr, valueStr

        if type(index) == "number" then
            keyStr = ""
        elseif type(index) == "string" then
            keyStr = '["' .. index .. '"]'
        else
            keyStr = sm.scrapcomputers.toString(index)
        end

        if type(tbl[index]) == "function" then
            valueStr = "function"
        elseif type(tbl[index]) == "table" then
            valueStr = sm.scrapcomputers.toString(tbl[index])
        elseif type(tbl[index]) == "string" then
            valueStr = '"' .. sm.scrapcomputers.toString(tbl[index]) .. '"'
        else
            valueStr = sm.scrapcomputers.toString(tbl[index])
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
---@param tbl table The table
---@param index number The index to get from the table
---@return any value The data received
sm.scrapcomputers.table.getItemAt = function(tbl, index)
    -- Assert your mom.
    assert(type(tbl)   == "table" , "bad argument #1. Expected table, got "..type(tbl  ).." instead!")
    assert(type(index) == "number", "bad argument #2. Expected table, got "..type(index).." instead!")
    assert(not sm.scrapcomputers.table.isDictonary(tbl), "bad argument #1. Table is not a list!")

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

    -- Couldnt find anything!
end

---Gets the total elements from a table. Unlike doing #tbl, If the table wasen't using number's as index. the # wouldn't get anything but return 0. This fixes that issue.
---@param tbl table The table
---@return number totalItems The total items inside the table
sm.scrapcomputers.table.getTotalItems = function(tbl)
    --Assertions!
    assert(type(tbl) == "table", "Expected table, got "..type(tbl).." instead!")
    assert(not sm.scrapcomputers.table.isDictonary(tbl), "Table is not a list!")

    local totalItems = 0

    -- Get all items (non-nil only) inside the tbl and each item will increase totalItems by 1
    for _, _ in ipairs(tbl) do
        totalItems = totalItems + 1
    end

    -- Return totalItems
    return totalItems
end

-- Like sm.scrapcomputers.table.getTotalItems but works with dictonaries.
---@param tbl table The table
---@return number totalItems The total items inside the table
sm.scrapcomputers.table.getTotalItemsDict = function(tbl)
    -- Assertions!
    assert(type(tbl) == "table", "Expected table, got "..type(tbl).." instead!")
    assert(sm.scrapcomputers.table.isDictonary(tbl), "Table is not a dictonary!")

    local totalItems = 0

    -- Get all items inside the tbl and each item will increase totalItems by 1
    for _, _ in pairs(tbl) do
        totalItems = totalItems + 1
    end

    -- Return totalItems
    return totalItems
end

-- Shifts list's indexes.
---@param tbl table The table
---@param shiftAmount integer The amount to shift
---@return table shiftedTable The shifted table
sm.scrapcomputers.table.shiftTableIndexes = function(tbl, shiftAmount)
    -- Assert the cunts
    assert(type(tbl)         == "table", "bad argument #1. Expected table, got "..type(tbl).." instead!")
    assert(type(shiftAmount) == "number", "bad argument #2. Expected number, got "..type(shiftAmount).." instead!")

    local isDictonary = sm.scrapcomputers.table.isDictonary(tbl)
    local tableSize = sm.scrapcomputers.table[isDictonary and "getTotalItemsDict" or "getTotalItems"](tbl)

    -- Check if table size is empty, if so then return the table since its empty!
    if tableSize == 0 then
        return tbl  -- No shift needed for an empty table
    end

    -- Create a new table for the result
    local output = {}

    -- Handle positive and negative shifts
    for index, value in pairs(tbl) do
        output[index + shiftAmount] = value
    end

    return output
end

-- Returns true if its a dictonary
---@param tbl table The table to check
---@return boolean isDict Is true if its a dictonary.
sm.scrapcomputers.table.isDictonary = function (tbl)
    -- Assertions!
    assert(type(tbl) == "table", "Expected table, got "..type(tbl).." instead!")

    local count = 0

    -- Loop through all tables
    for key, _ in pairs(tbl) do
        -- Check if the key isnt a number, the key's number value isnt the same as the floored value or lower than 1.
        -- If one of those match, Its a dictonary so return true
        if type(key) ~= "number" or key ~= math.floor(key) or key < 1 then
            return true
        else
            -- Increase count by 1.
            count = count + 1
        end
    end
    
    -- Check if numeric keys are contiguous and start from 1
    for index = 1, count do
        -- If nil, then its a dictonary so return true
        if tbl[index] == nil then
            return true
        end
    end
    
    -- Both checks failed! return false!
    return false
end

-- Orders the list to be 1 to table size
---@param tbl table The table to check
---@return table organizedTable The organized table.
sm.scrapcomputers.table.numberlyOrderTable = function (tbl)
    -- Assertions!
    assert(type(tbl) == "table", "Expected table, got "..type(tbl).." instead!")
    assert(not sm.scrapcomputers.table.isDictonary(tbl), "Table is not a list!")

    local output = {}

    -- Loop through all items inside the table and add it to output
    for _, value in pairs(tbl) do
        table.insert(output, value)
    end

    -- Return output
    return output
end

-- Returns true if a item is found in a list
---@param tbl table The table to check
---@param item any The item to try finding the table. (Cannot be nil!)
---@return boolean exists If it was found or not.
sm.scrapcomputers.table.itemExistsInList = function (tbl, item)
    -- Assertions!
    assert(type(tbl) == "table", "bad argument #1. Expected table, got "..type(tbl).." instead!")
    assert(not sm.scrapcomputers.table.isDictonary(tbl), "bad argument #1. Table is not a list!")

    assert(type(tbl) ~= "nil", "bad argument #1. Expected not nil, got nil instead!")

    -- Loop and check if value is item.
    for _, value in pairs(tbl) do
        if value == item then
            return true -- Item exist!
        end
    end

    -- Item doesn't exist
    return false
end