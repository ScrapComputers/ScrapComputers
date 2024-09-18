-- VPBS allows you to convert a lua table to a packet buffer. Use this if you do NOT wanna deal with BitStreams and want to do every packet as a string.
sm.scrapcomputers.VPBS = {}

local opcodes = {
    ["number"] = 0x00,
    ["string"] = 0x01,
    ["boolean"] = 0x02,
    ["table"] = 0x03,
    ["Color"] = 0x04,
    ["Vec3"] = 0x05,
    ["Quat"] = 0x06
}

local invertedOpcodes = {}

for key, value in pairs(opcodes) do
    invertedOpcodes[value] = key
end

---Converts a table to a VPBS string
---@param  tbl    table   The table to convert
---@return string vpbsStr The converted string.
function sm.scrapcomputers.VPBS.toString(tbl)
    sm.scrapcomputers.errorHandler.assertArgument(tbl, nil, {"table"})

    local buffer = sm.scrapcomputers.BitStream.new()
    local startString = "\x27VPBS"

    for i = 1, #startString do
        buffer:writeByte(startString:sub(i, i):byte())
    end

    local function parseTable(root)
        local isList = nil

        for key, value in pairs(root) do
            isList = isList or type(key) == "number"

            if type(key) == "string" and not isList then
                buffer:writeBit(false)
                buffer:writeString(key)
            elseif type(key) == "number" and isList then
                buffer:writeBit(true)
                buffer:writeUInt32(key)
            else
                error("Illegal Table!")
            end

            local valueType = type(value)
            buffer:writeByte(opcodes[valueType])

            if valueType == "number" then
                buffer:writeBit(value < 0)
                buffer:writeUInt32(value < 0 and -value or value)
            elseif valueType == "string" then
                buffer:writeString(value)
            elseif valueType == "boolean" then
                buffer:writeBit(value)
            elseif valueType == "table" then
                buffer:writeUInt32(sm.scrapcomputers.table.getTableSize(value))
                parseTable(value)
            elseif valueType == "Color" then
                buffer:writeUInt8(value.r)
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
            end
        end
    end

    parseTable(tbl)

    return buffer:dumpString()
end

---Converts a VPBS string to a table
---@param data string The VPBS string.
---@return table tbl  The table from the string
function sm.scrapcomputers.VPBS.toTable(data)
    sm.scrapcomputers.errorHandler.assertArgument(data, nil, {"string"})

    local buffer = sm.scrapcomputers.BitStream.new(data)
    local startString = "\x27VPBS"

    for i = 1, #startString do
        local character = startString:sub(i, i):byte()
        local byte = buffer:readByte()

        if byte ~= character then
            error("Invalid VPBS header!")
        end
    end

    local output = {}
    local contextStack = {{table = output, remaining = 1}}

    while buffer.bytePos < buffer.size do
        local currentContext = contextStack[#contextStack]
        local currentTable = currentContext.table

        local isNumberIndex = buffer:readByte() == 0x01
        local index = buffer[isNumberIndex and "readInt32" or "readString"](buffer)

        assert(index, "Corrupted VPBS table!")

        local variableType = invertedOpcodes[buffer:readByte()]

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
            local newTable = {}

            currentTable[index] = newTable
            table.insert(contextStack, {table = newTable, remaining = tableSize})
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

            local value = sm.vec3.new(xNegative and -x or x, yNegative and -y or y, zNegative and -z or z)

            currentTable[index] = value
            currentContext.remaining = currentContext.remaining - 1
        end

        while #contextStack > 1 and contextStack[#contextStack].remaining <= 0 do
            table.remove(contextStack)

            currentContext = contextStack[#contextStack]
            currentContext.remaining = currentContext.remaining - 1
        end
    end

    return output
end

---Checks if the string is a VPBS formatted string
---@param data string The data to check
---@return boolean isVPBS True if its a VPBS string, else not.
function sm.scrapcomputers.VPBS.isVPBSstring(data)
    sm.scrapcomputers.errorHandler.assertArgument(data, nil, {"string"})
    
    return data:sub(1, #5) == "\x27VPBS"
end