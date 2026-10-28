sm.scrapcomputers.metatable = {}

---@class Metatable.Internal.Entry
---@field metatable table The metatable the user assigned. This is what getmetatable returns.
---@field class table The class table backing the proxy. This is the proxy's real metatable, so metamethods are toggled and changed here.

-- Keyed by the proxy returned from setmetatable. Weak keys so proxies can still be garbage collected.
local entries = class({__mode = "k"})() ---@type table<table, Metatable.Internal.Entry>

---Replaces everything inside a class table with the given metatable's fields.
---@param classTable table The class table to overwrite.
---@param metatable table? The metatable to copy from. If nil, the class table is just cleared.
local function applyMetatable(classTable, metatable)
    for key in pairs(classTable) do
        classTable[key] = nil
    end

    if not metatable then
        return
    end

    for key, value in pairs(metatable) do
        classTable[key] = value
    end
end

---Reimplementation of Lua's setmetatable.
---
---Unlike Lua's version this does NOT modify `tbl`. It returns a new table with the metatable applied (a copy of tbl's contents),
---so always use the returned value. Passing a table previously returned by this function changes its metatable in place.
---@param tbl table The table to apply the metatable to.
---@param metatable table? The metatable. If nil, the metatable is removed.
---@return table tbl The table with the metatable applied.
function sm.scrapcomputers.metatable.setmetatable(tbl, metatable)
    sm.scrapcomputers.errorHandler.assertArgument(tbl, 1, {"table"})
    sm.scrapcomputers.errorHandler.assertArgument(metatable, 2, {"table", "nil"})

    local entry = entries[tbl]
    if entry then
        assert(entry.metatable.__metatable == nil, "cannot change a protected metatable")

        applyMetatable(entry.class, metatable)
        if metatable then
            entry.metatable = metatable
        else
            entries[tbl] = nil
        end

        return tbl
    end

    if not metatable then
        return tbl
    end

    local classTable = class()
    local proxy = classTable()

    -- No metamethods are applied yet, so this is a raw copy.
    for key, value in pairs(tbl) do
        proxy[key] = value
    end

    applyMetatable(classTable, metatable)
    entries[proxy] = {metatable = metatable, class = classTable}

    return proxy
end

---Reimplementation of Lua's getmetatable.
---@param tbl table The table to get the metatable from.
---@return table? metatable The metatable (or its `__metatable` field if set), or nil if it has none.
function sm.scrapcomputers.metatable.getmetatable(tbl)
    sm.scrapcomputers.errorHandler.assertArgument(tbl, 1, {"table"})

    local entry = entries[tbl]
    if not entry then
        return nil
    end

    local protected = entry.metatable.__metatable
    if protected ~= nil then
        return protected
    end

    return entry.metatable
end

---Gets a value without triggering `__index`.
---@param tbl table The table to read from.
---@param key string|number The key.
---@return any value The raw value.
function sm.scrapcomputers.metatable.rawget(tbl, key)
    sm.scrapcomputers.errorHandler.assertArgument(tbl, 1, {"table"})
    sm.scrapcomputers.errorHandler.assertArgument(key, 2, {"string", "number"})

    local entry = entries[tbl]
    if not entry then
        return tbl[key]
    end

    local classTable = entry.class
    local oldIndex = classTable.__index

    classTable.__index = nil
    local value = tbl[key]
    classTable.__index = oldIndex

    return value
end

---Sets a value without triggering `__newindex`.
---@param tbl table The table to write to.
---@param key string|number The key.
---@param value any The value.
---@return table tbl The table.
function sm.scrapcomputers.metatable.rawset(tbl, key, value)
    sm.scrapcomputers.errorHandler.assertArgument(tbl, 1, {"table"})
    sm.scrapcomputers.errorHandler.assertArgument(key, 2, {"string", "number"})

    local entry = entries[tbl]
    if not entry then
        tbl[key] = value
        return tbl
    end

    local classTable = entry.class
    local oldNewIndex = classTable.__newindex

    classTable.__newindex = nil
    tbl[key] = value
    classTable.__newindex = oldNewIndex

    return tbl
end

---Gets the length of a table without triggering `__len`.
---@param tbl table The table.
---@return integer length The raw length.
function sm.scrapcomputers.metatable.rawlen(tbl)
    sm.scrapcomputers.errorHandler.assertArgument(tbl, 1, {"table"})

    local entry = entries[tbl]
    if not entry then
        return #tbl
    end

    local classTable = entry.class
    local oldLen = classTable.__len

    classTable.__len = nil
    local length = #tbl
    classTable.__len = oldLen

    return length
end

--- Checks if two tables are equal without triggering `__eq`.
---@param tbl1 table The first table.
---@param tbl2 table The second table.
---@return boolean equal True if they are equal, false otherwise.
function sm.scrapcomputers.metatable.rawequal(tbl1, tbl2)
    sm.scrapcomputers.errorHandler.assertArgument(tbl1, 1, {"table"})
    sm.scrapcomputers.errorHandler.assertArgument(tbl2, 2, {"table"})

    local entry1 = entries[tbl1]
    local entry2 = entries[tbl2]
    if not entry1 and not entry2 then
        return tbl1 == tbl2
    end

    local classTable1 = entry1 and entry1.class or nil
    local classTable2 = entry2 and entry2.class or nil

    local oldEq1 = classTable1 and classTable1.__eq or nil
    local oldEq2 = classTable2 and classTable2.__eq or nil

    if classTable1 then classTable1.__eq = nil end
    if classTable2 then classTable2.__eq = nil end

    local equal = tbl1 == tbl2

    if classTable1 then classTable1.__eq = oldEq1  end
    if classTable2 then classTable2.__eq = oldEq2 end

    return equal
end