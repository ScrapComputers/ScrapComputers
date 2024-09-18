-- Additional functionality towards tables.
sm.scrapcomputers.table = {}

---Merges 2 tables
---(If FullOverwrite is false) It merges the tables:
---    - If value1 and value2 value are both tables. it recursively calls it.
---    - If value1 is a table but not value2, it wont be overwritten
---    - If both of those checks above fail. It will be value2
---@param table1 table The 1st table
---@param table2 table The 2nd table
---@param fullOverwrite boolean? If true, table2 would overwrite anything in table 1 no matter what.
---@return table mergedTable The merged table
function sm.scrapcomputers.table.merge(table1, table2, fullOverwrite)
    fullOverwrite = fullOverwrite or false

    sm.scrapcomputers.errorHandler.assertArgument(table1, 1, {"table"})
    sm.scrapcomputers.errorHandler.assertArgument(table2, 2, {"table"})
    sm.scrapcomputers.errorHandler.assertArgument(fullOverwrite, 3, {"boolean", "nil"})
    
    local mergedTable = unpack({table1})

    local function mergeValues(value1, value2)
        if fullOverwrite then
            return value2
        end

        if type(value1) == "table" and type(value2) == "table" then
            return sm.scrapcomputers.table.merge(value1, value2, fullOverwrite)
        elseif type(value1) == "table" and type(value2) ~= "table" then
            return value1
        end

        return value2
    end

    for key, value in pairs(table2) do
        if type(mergedTable[key]) ~= "nil" then
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
function sm.scrapcomputers.table.clone(tbl)
    sm.scrapcomputers.errorHandler.assertArgument(tbl, nil, {"table"})

    return unpack({tbl})
end

---Converts a lua table to a string
---@param tbl table The lua table to convert to a string
---@return string str The lua table as a string
function sm.scrapcomputers.table.toString(tbl)
    sm.scrapcomputers.errorHandler.assertArgument(tbl, nil, {"table"})

    local output = {}

    local function convertKey(key)
        local keyType = type(key)

        if keyType == "string" then
            return "[\"" .. key .. "\"]"
        elseif keyType == "number" then
            return "[" .. key .. "]"
        end

        return "[" .. sm.scrapcomputers.toString(key) .. "]"
    end

    local function convertValue(value)
        local valueType = type(value)

        if valueType == "string" then
            return "\"" .. value .. "\""
        elseif valueType == "number" or valueType == "boolean" then
            return tostring(value)
        elseif valueType == "function" then
            return "function"
        end

        return sm.scrapcomputers.toString(value)
    end

    for key, value in pairs(tbl) do
        local keyString = convertKey(key)
        local valueString = convertValue(value)

        table.insert(output, keyString .. " = " .. valueString)
    end
    
    return "{" .. table.concat(output, ", ") .. "}"
end

---Gets a item at a index. Ingores the actual indexing of the table
---@param tbl table The table to read
---@param index integer The index to get it at
---@return any? value The recieved value
function sm.scrapcomputers.table.getItemAt(tbl, index)
    sm.scrapcomputers.errorHandler.assertArgument(tbl, 1, {"table"})
    sm.scrapcomputers.errorHandler.assertArgument(index, 2, {"integer"})

    local currentIndex = 1

    for _, value in pairs(tbl) do
        if currentIndex == index then
            return value
        end

        currentIndex = currentIndex + 1
    end
end

---Gets the size of the table, Compattable with dictionaries. (doing #dict will always return 0!)
---@param tbl table The table
---@return integer size  The total amount of values in it
function sm.scrapcomputers.table.getTableSize(tbl)
    sm.scrapcomputers.errorHandler.assertArgument(tbl, nil, {"table"})

    local tableSize = 0

    for _, _ in pairs(tbl) do
        tableSize = tableSize + 1
    end

    return tableSize
end

---Shifts a table's index by shiftAmount
---@param tbl table The table to shift
---@param shiftAmount integer The amount to shift
---@return table shiftedTable The shifted table
function sm.scrapcomputers.table.shiftTableIndexes(tbl, shiftAmount)
    sm.scrapcomputers.errorHandler.assertArgument(tbl, 1, {"table"})
    sm.scrapcomputers.errorHandler.assertArgument(shiftAmount, 2, {"integer"})

    local tableSize = sm.scrapcomputers.table.getTableSize(tbl)

    if tableSize == 0 then return tbl end

    local output = {}

    for index, value in pairs(tbl) do
        output[index + shiftAmount] = value
    end

    return output
end

---Returns true if your table is a dictonary
---@param tbl table  The table to check
---@return boolean isDict If its a dictionary or not
function sm.scrapcomputers.table.isDictonary(tbl)
    sm.scrapcomputers.errorHandler.assertArgument(tbl, nil, {"table"})

    for key, _ in pairs(tbl) do
        if type(key) ~= "number" then
            return true
        end
    end
    
    return false
end

---Gives you a new table ordered by numbers. (linear)
---@param tbl table The table
---@return table tbl The table linearly orded by number
function sm.scrapcomputers.table.numberlyOrderTable(tbl)
    sm.scrapcomputers.errorHandler.assertArgument(tbl, nil, {"table"})

    local output = {}

    for _, value in pairs(tbl) do
        table.insert(output, value)
    end

    return output
end

---Returns true if a value exists in the table
---@param tbl table The table
---@param item any The value to find
---@return boolean valueExists If it exists or not
---@return any? valueIndex  Where it has been found.
function sm.scrapcomputers.table.valueExistsInList(tbl, item)
    sm.scrapcomputers.errorHandler.assertArgument(tbl, 1, {"table"})

    for index, value in pairs(tbl) do
        if value == item then
            return true, index
        end
    end

    return false, nil
end

---Merges 2 lists into 1, tb2 is appended on tbl1. (Indexes will be changed to be numberly ordered!)
---@param  tbl1  table      The 1st table
---@param  tbl2  table      The 2nd table
---@return table mergedList The merged table
function sm.scrapcomputers.table.mergeLists(tbl1, tbl2)
    sm.scrapcomputers.errorHandler.assertArgument(tbl1, 1, {"table"})
    sm.scrapcomputers.errorHandler.assertArgument(tbl2, 2, {"table"})
    
    local output = {}

    for _, value in pairs(tbl1) do
        table.insert(output, value)
    end

    for _, value in pairs(tbl2) do
        table.insert(output, value)
    end

    return output
end