-- VPBS allows you to convert a lua table to a packet buffer. Use this if you do NOT wanna deal with BitStreams and want to do every packet as a string.
sm.scrapcomputers.VPBS = {}

-- Opcode definitions for data types
local opcodes = {
    ["number"]  = 0x00,
    ["string"]  = 0x01,
    ["boolean"] = 0x02,
    ["table"]   = 0x03,
    ["Color"]   = 0x04,
    ["Vec3"]    = 0x05,
    ["Quat"]    = 0x06
}

-- Reverse lookup table for opcodes
local reverse_opcodes = {}

-- Populate reverse_opcodes table for quick lookup
for key, value in pairs(opcodes) do
    reverse_opcodes[value] = key
end

---Converts a table to a VPBS string
---@param tbl table The table to convert
---@return string vpbsStr The converted string.
sm.scrapcomputers.VPBS.tostring = function(tbl)
    local buffer = sm.scrapcomputers.BitStream.new()  -- BitStream for efficient binary data handling
    local startString = "\x27VPBS"  -- Header for VPBS format

    -- Write header to buffer
    for i = 1, #startString do
        buffer:writeByte(startString:sub(i, i):byte())
    end

    -- Recursive function to parse and serialize table
    local function parse_table(root)
        local isList = nil

        for key, value in pairs(root) do
            -- Determine if table is list-like (numerical keys only)
            isList = isList or type(key) == "number"

            -- Write key to buffer based on type
            if type(key) == "string" and not isList then
                buffer:writeBit(false)  -- String type
                buffer:writeString(key)
            elseif type(key) == "number" and isList then
                buffer:writeBit(true)  -- Number type
                buffer:writeInt32(key)
            else
                error("Illegal Table!")  -- Error for unexpected table structure
            end

            local valueType = type(value)
            buffer:writeByte(opcodes[valueType])  -- Write value type opcode

            -- Write value based on its type
            if valueType == "number" then
                buffer:writeBit(value < 0)  -- Positive/Negative number indicator
                buffer:writeUInt32(value < 0 and -value or value)
            elseif valueType == "string" then
                buffer:writeString(value)
            elseif valueType == "boolean" then
                buffer:writeBit(value)  -- Boolean indicator
            elseif valueType == "table" then
                if #value == 0 and next(value) ~= nil then
                    local size = 0
                    for _ in pairs(value) do
                        size = size + 1
                    end
                    buffer:writeUInt32(size)  -- Write size of nested table
                else
                    buffer:writeUInt32(#value)  -- Write length of table
                end
                parse_table(value)  -- Recursive call to handle nested tables
            elseif valueType == "Color" then
                buffer:writeUInt8(value.r)  -- Write Color component values
                buffer:writeUInt8(value.g)
                buffer:writeUInt8(value.b)
                buffer:writeUInt8(value.a)
            elseif valueType == "Vec3" then
                buffer:writeBit(value.x < 0)
                buffer:writeUInt32(value.x)
                buffer:writeBit(value.y < 0)
                buffer:writeUInt32(value.y)
                buffer:writeBit(value.z < 0)
                buffer:writeUInt32(value.z)
            elseif valueType == "Quat" then
                buffer:writeInt8(value.x)
                buffer:writeInt8(value.y)
                buffer:writeInt8(value.z)
                buffer:writeInt8(value.w)
            end
        end
    end

    parse_table(tbl)  -- Start parsing from the top-level table

    return buffer:dumpString()  -- Return serialized VPBS string
end

---Converts a VPBS string to a table
---@param data string The VPBS string.
---@return table tbl The table from the string
sm.scrapcomputers.VPBS.totable = function(data)
    local buffer = sm.scrapcomputers.BitStream.new(data)  -- BitStream initialized with VPBS string
    local startString = "\x27VPBS"

    -- Validate VPBS format by checking header
    for i = 1, #startString do
        local chr = startString:sub(i, i):byte()
        local byte = buffer:readByte()

        if byte ~= chr then
            error("Not VPBS Data!")
        end
    end

    local output = {}  -- Output Lua table to build
    local contextStack = { { table = output, remaining = 1 } }  -- Stack to manage nested table parsing

    -- Parse VPBS string and convert to Lua table
    while buffer.bytePos < buffer.size do
        local currentContext = contextStack[#contextStack]
        local currentTable = currentContext.table

        local isNumberIndex = buffer:readByte() == 0x01  -- Check if index is a number
        local index

        -- Read index based on type (number or string)
        if isNumberIndex then
            index = buffer:readInt32()
        else
            index = buffer:readString()
        end

        if index == nil then
            error("Invalid index!")
        end

        -- Determine value type based on opcode
        local variableType = reverse_opcodes[buffer:readByte()]

        -- Handle different value types and assign to current table
        if variableType == "number" then
            local isNegative = buffer:readByte() == 0x00
            local value = isNegative and -buffer:readUInt32() or buffer:readUInt32()
            currentTable[index] = value
            currentContext.remaining = currentContext.remaining - 1
        elseif variableType == "string" then
            local value = buffer:readString()
            currentTable[index] = value
            currentContext.remaining = currentContext.remaining - 1
        elseif variableType == "boolean" then
            local value = buffer:readByte() == 0x01
            currentTable[index] = value
            currentContext.remaining = currentContext.remaining - 1
        elseif variableType == "table" then
            local tableSize = buffer:readUInt32()

            -- Create a new table and push it onto the stack
            local newTable = {}
            currentTable[index] = newTable
            table.insert(contextStack, { table = newTable, remaining = tableSize })
        elseif variableType == "Color" then
            local value = sm.color.new(buffer:readUInt8(), buffer:readUInt8(), buffer:readUInt8(), buffer:readUInt8())
            currentTable[index] = value
            currentContext.remaining = currentContext.remaining - 1
        elseif variableType == "Vec3" then
            local xNegative = buffer:readBit() == 1
            local x = buffer:readUInt32()
            local yNegative = buffer:readBit() == 1
            local y = buffer:readUInt32()
            local zNegative = buffer:readBit() == 1
            local z = buffer:readUInt32()

            local value = sm.color.new(xNegative and -x or x, yNegative and -y or y, zNegative and -z or z)
            currentTable[index] = value
            currentContext.remaining = currentContext.remaining - 1
        elseif variableType == "Quat" then
            local value = sm.quat.new(buffer:readInt8(), buffer:readInt8(), buffer:readInt8(), buffer:readInt8())
            currentTable[index] = value
            currentContext.remaining = currentContext.remaining - 1
        end

        -- Pop contexts if the current one has no remaining items
        while #contextStack > 1 and contextStack[#contextStack].remaining <= 0 do
            table.remove(contextStack)
            currentContext = contextStack[#contextStack]
            currentContext.remaining = currentContext.remaining - 1
        end
    end

    return output  -- Return parsed Lua table
end

---Checks if the string is a VPBS formatted string
---@param data string The data to check
---@return boolean isVPBS True if its a VPBS string, else not.
sm.scrapcomputers.VPBS.isVPBSstring = function(data)
    if type(data) ~= "string" then -- It gotta be a string or else nuh nuh
        return false
    end
    
    return data:sub(1, #5) == "\x27VPBS" -- Check if it is one by its starting format.
end