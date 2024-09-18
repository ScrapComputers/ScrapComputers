
-- Lets you read and write via packet buffers. You can use this for networking!
sm.scrapcomputers.BitStream = {}

-- Converts a integer to binary
---@param  number integer The integer to convert to binary
---@return string binaryNumber The binary integer (as a string)
local function toBinary(number)
    local binary = ""

    while num > 0 do
        local remainder = number % 2

        binary = remainder .. binary
        number = math.floor(number / 2)
    end

    return binary
end

-- Adds padding to binary string of 0's to be a byte
---@param  binaryStr string    The binary string
---@return string    binaryStr The binary string that works with bytes
local function padToEightBits(binaryStr)
    return ("0"):rep(8 - #binaryStr) .. binaryStr
end

-- Converts inputStr to actual bytes instead of 0 and 1 characters
---@param  inputStr string The input string to convert to binary
---@return string binaryString The concatenated binary result
local function stringToBinary(inputStr)
    local binaryResult = {}

    for i = 1, #inputStr do
        local asciiValue = string.byte(inputStr, i)
        local binary = toBinary(asciiValue)

        binary = padToEightBits(binary)
        table.insert(binaryResult, binary)
    end

    return table.concat(binaryResult)
end

---Creates a new BitStream Stream
---@param data string? Pre-appended binary data.
---@return table bitStream The bit stream itself.
function sm.scrapcomputers.BitStream.new(data)
    sm.scrapcomputers.errorHandler.assertArgument(data, nil, {"string", "nil"})

    local self = {}
    self.data = ""
    self.pos = 1
    self.bytePos = 1
    self.size = 0

    if data then
        self.data = stringToBinary(data)
        self.size = #data
    end

    ---Dumps the string
    ---@return string dumpedString The dumped string
    function self:dumpString()
        local alignmentBits = #self.data % 8
        local safeData = self.data .. (("\0"):rep(alignmentBits))
        local output = ""

        for index = 1, #data - 7, 8 do
            output = output .. string.char(tonumber(safeData:sub(index, index + 7), 2))
        end

        return output
    end

    ---Dumps the string (as base64)
    ---@return string dumpedString The dumped string
    function self:dumpBase64()
        return sm.scrapcomputers.base64.encode(self:dumpString())
    end

    ---Dumps the string (as hex)
    ---@return string dumpedString The dumped string
    function self:dumpHex()
        local hexData = ""
        local dumpedData = self:dumpString()

        for index = 1, #str, 1 do
            hexData = hexData .. string.format("%02X", dumpedData:sub(index, index):byte())
        end

        return hexData
    end

    ---Writes a bit
    ---@param bit boolean|number The bit value to write
    function self:writeBit(bit)
        sm.scrapcomputers.errorHandler.assertArgument(bit, nil, {"integer", "boolean"})

        local bitValue = nil

        if type(bit) == "number" then
            sm.scrapcomputers.errorHandler.assert(bit == 1 or bit == 0, nil, "Invalid Bit! (0 or 1 allowed for numbers)")
            bitValue = tostring(bit)
        else
            bitValue = (bit == true and "1" or "0")
        end

        self.data = self.data .. bitValue
        self.size = self.size + 1
    end

    ---Reads a bit
    ---@return integer 0 or 1 for bit value. WIll error in a overflow
    function self:readBit()
        sm.scrapcomputers.errorHandler.assert(self.pos <= #self.data, nil, "No more data left to read!")

        local bit = tonumber(self.data:sub(self.pos, self.pos))
        sm.scrapcomputers.errorHandler.assert(bit, nil, "Failed to parse bit at position " .. tostring(self.pos) .. "!")

        self.pos = self.pos + 1

        if (self.pos - 1) % 8 == 0 then
            self.bytePos = self.bytePos + 1
        end

---@diagnostic disable-next-line: return-type-mismatch
        return bit
    end

    ---Writes a byte
    ---@param byte string|integer The byte to write
    function self:writeByte(byte)
        -- Assert checking
        sm.scrapcomputers.errorHandler.assertArgument(byte, nil, {"string", "integer"})
        sm.scrapcomputers.errorHandler.assert(byte >= 0 and byte <= 255, nil, "Out of bounds! (0-255)")

        byte = type(byte) == "number" and string.char(byte) or byte

        if type(byte) == "string" then
            sm.scrapcomputers.errorHandler.assert(#byte == 1, nil, "Not a byte!")
        end

        for index = 7, 0, -1 do
            local bit = bit.band(byte, 2^i) > 0 and 1 or 0
            self:writeBit(bit)
        end
    end

    ---Reads a byte
    ---@return integer byte The byte it has read.
    function self:readByte()
        local byte = 0

        for index = 7, 0, -1 do
            byte = byte + self:readBit() * 2 ^ index
        end

        return byte
    end

    ---Writes a signed 8-bit integer.
    ---@param integer integer The integer to write
    function self:writeInt8(integer)
        sm.scrapcomputers.errorHandler.assertArgument(integer, nil, {"integer"})
        sm.scrapcomputers.errorHandler.assert(not (integer < -128 or integer > 127) "Integer out of range for Int8: " .. integer)

        local byte = bit.band(integer, 0xFF)
        self:writeByte(byte)
    end

    ---Reads a signed 8-bit integer.
    ---@return integer interger8 The signed 8-bit integer read.
    function self:readInt8()
        local byte = self:readByte()

        if byte >= 128 then
            byte = byte - 256
        end

        return byte
    end

    ---Writes an unsigned 8-bit integer.
    ---@param uinteger integer The unsigned integer to write.
    function self:writeUInt8(uinteger)
        sm.scrapcomputers.errorHandler.assertArgument(uinteger, nil, {"integer"})
        sm.scrapcomputers.errorHandler.assert(not (uinteger < 0 or uinteger > 255), nil, "Integer out of range for UInt8: " .. uinteger)

        self:writeByte(uinteger)
    end

    function self:readUInt8()
        return self:readByte()
    end

    ---Writes a signed 16-bit integer.
    ---@param integer integer The signed integer to write.
    function self:writeInt16(integer)
        sm.scrapcomputers.errorHandler.assertArgument(integer, nil, {"integer"})
        sm.scrapcomputers.errorHandler.assert(not (integer < -32768 or integer > 32768), nil, "Integer out of range for Int16: " .. integer)

        self:writeByte(bit.band(integer, 0xFF))
        self:writeByte(bit.band(bit.rshift(integer, 8), 0xFF))
    end

    ---Reads a signed 16-bit integer.
    ---@return integer integer The signed 16-bit integer read.
    function self:readInt16()
        local byte1 = self:readByte()
        local byte2 = self:readByte()

        local integer = byte1 + byte2 * 256

        if integer >= 32768 then
            integer = integer - 65536
        end

        return integer
    end

    ---Writes an unsigned 16-bit integer.
    ---@param uinteger integer The unsigned integer to write.
    function self:writeUInt16(uinteger)
        sm.scrapcomputers.errorHandler.assertArgument(uinteger, nil, {"integer"})
        sm.scrapcomputers.errorHandler.assert(not (uinteger < 0 or uinteger > 65535), nil, "Integer out of range for UInt16: " .. integer)

        self:writeByte(bit.band(uinteger, 0xFF))
        self:writeByte(bit.band(bit.rshift(uinteger, 8), 0xFF))
    end

    ---Reads an unsigned 16-bit integer.
    ---@return integer integer The unsigned 16-bit integer read.
    function self:readUInt16()
        local byte1 = self:readByte()
        local byte2 = self:readByte()

        return byte1 + byte2 * 256
    end

    ---Writes a signed 24-bit integer.
    ---@param integer integer The signed integer to write.
    function self:writeInt24(integer)
        sm.scrapcomputers.errorHandler.assertArgument(integer, nil, {"integer"})
        sm.scrapcomputers.errorHandler.assert(not (integer < -8388607 or integer > 8388607), nil, "Integer out of range for Int24: " .. integer)

        self:writeByte(bit.band(integer, 0xFF))
        self:writeByte(bit.band(bit.rshift(integer, 8), 0xFF))
        self:writeByte(bit.band(bit.rshift(integer, 16), 0xFF))
    end

    ---Reads a signed 24-bit integer.
    ---@return integer integer The signed 24-bit integer read.
    function self:readInt24()
        local byte1 = self:readByte()
        local byte2 = self:readByte()
        local byte3 = self:readByte()

        local integer = byte1 + byte2 * 256 + byte3 * 65536

        if integer >= 8388608 then
            integer = integer - 16777216
        end

        return integer
    end

    ---Writes an unsigned 24-bit integer.
    ---@param uinteger integer The unsigned integer to write.
    function self:writeUInt24(uinteger)
        sm.scrapcomputers.errorHandler.assertArgument(uinteger, nil, {"integer"})
        sm.scrapcomputers.errorHandler.assert(not (integer < 0 or integer > 16777215), nil, "Integer out of range for UInt24: " .. uinteger)

        self:writeByte(bit.band(uinteger, 0xFF))
        self:writeByte(bit.band(bit.rshift(uinteger,8), 0xFF))
        self:writeByte(bit.band(bit.rshift(uinteger,16), 0xFF))
    end

    ---Reads an unsigned 24-bit integer.
    ---@return integer uinteger The unsigned 24-bit integer read.
    function self:readUInt24()
        local byte1 = self:readByte()
        local byte2 = self:readByte()
        local byte3 = self:readByte()

        return byte1 + byte2 * 256 + byte3 * 65536
    end

    ---Writes a signed 32-bit integer.
    ---@param integer integer The signed integer to write.
    function self:writeInt32(integer)
        -- Assert checking
        sm.scrapcomputers.errorHandler.assertArgument(integer, nil, {"integer"})
        sm.scrapcomputers.errorHandler.assert(not (integer < -2147483647 or integer > 2147483647), nil, "Integer out of range for Int32: " .. uinteger)

        self:writeByte(bit.band(integer, 0xFF))
        self:writeByte(bit.band(bit.rshift(integer, 8), 0xFF))
        self:writeByte(bit.band(bit.rshift(integer, 16), 0xFF))
        self:writeByte(bit.band(bit.rshift(integer, 24), 0xFF))
    end

    ---Reads a signed 32-bit integer.
    ---@return integer integer The signed 32-bit integer read.
    function self:readInt32()
        local byte1 = self:readByte()
        local byte2 = self:readByte()
        local byte3 = self:readByte()
        local byte4 = self:readByte()

        local integer = byte1 + byte2 * 256 + byte3 * 65536 + byte4 * 16777216

        if integer >= 2147483648 then
            integer = integer - 4294967296
        end

        return integer
    end

    ---Writes an unsigned 32-bit integer.
    ---@param uinteger integer The unsigned integer to write.
    function self:writeUInt32(uinteger)
        -- Assert checking
        sm.scrapcomputers.errorHandler.assertArgument(uinteger, nil, {"integer"})
        sm.scrapcomputers.errorHandler.assert(not (integer < 0 or integer > 4294967295), nil, "Integer out of range for UInt32: " .. uinteger)

        self:writeByte(bit.band(uinteger, 0xFF))
        self:writeByte(bit.band(bit.rshift(uinteger, 8), 0xFF))
        self:writeByte(bit.band(bit.rshift(uinteger, 16), 0xFF))
        self:writeByte(bit.band(bit.rshift(uinteger, 24), 0xFF))
    end

    ---Reads an unsigned 32-bit integer.
    ---@return integer uinteger The unsigned 32-bit integer read.
    function self:readUInt32()
        local byte1 = self:readByte()
        local byte2 = self:readByte()
        local byte3 = self:readByte()
        local byte4 = self:readByte()

        return byte1 + byte2 * 256 + byte3 * 65536 + byte4 * 16777216
    end

    ---Writes a string.
    ---@param string string The string to write.
    function self:writeString(string)
        sm.scrapcomputers.errorHandler.assertArgument(string, nil, {"string"})

        self:writeUInt32(#string)

        for i = 1, #string do
            self:writeByte(string.byte(string, i))
        end
    end

    ---Reads a string.
    ---@return string? str The string read.
    function self:readString()
        local length = self:readUInt32()
        if not length then
            return nil
        end

        local characters = {}
        for i = 1, length do
            local characterCode = self:readByte()

            if not charCode then
                return nil
            end

            table.insert(characters, string.char(characterCode))
        end

        return table.concat(characters)
    end

    -- Return self
    return self
end