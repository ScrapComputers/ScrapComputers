-- Lets you read and write via packet buffers. You can use this for networking!
sm.scrapcomputers.bitstream = {}

---Creates a new BitStream Stream
---@param data string? Pre-appended binary data.
---@return BitStream
function sm.scrapcomputers.bitstream.new(data)
    sm.scrapcomputers.errorHandler.assertArgument(data, nil, {"string", "nil"})

    local self = {}
    self.data = data or ""
    self.pos = 1
    self.size = data and #data or 0

    ---Dumps the buffer
    ---@return string buffer The dumped buffer
    function self:dumpString()
        return self.data
    end

    ---Dumps the buffer (As Base64)
    ---@return string buffer The dumped buffer
    function self:dumpBase64()
        return sm.scrapcomputers.base64.encode(self:dumpString())
    end

    ---Dumps the buffer (As Hex)
    ---@return string buffer The dumped buffer
    function self:dumpHex()
        local hexData = ""
        local dumpedData = self:dumpString()

        for index = 1, #dumpedData do
            hexData = hexData .. string.format("%02X", dumpedData:sub(index, index):byte())
        end

        return hexData
    end

    ---Reads a number from the bit stream (Big Endian)
    ---@param byteSize integer Size of the number in bytes
    ---@return integer number The read number
    function self:readNumberBE(byteSize)
        sm.scrapcomputers.errorHandler.assertArgument(byteSize, nil, {"integer"})
        sm.scrapcomputers.errorHandler.assert(byteSize > 0 and byteSize <= 64, nil, "Out of bounds! (1-64 Range)")

        if self.pos + byteSize - 1 > self.size then
            error("Not enough data to read")
        end

        local number = 0
        for i = 0, byteSize - 1 do
            local byte = self.data:sub(self.pos + (byteSize - 1 - i), self.pos + (byteSize - 1 - i)):byte() or 0
            number = number + (byte * 2 ^ (i * 8))
        end

        self.pos = self.pos + byteSize
        return number
    end

    ---Reads a number from the bit stream (Little Endian)
    ---@param byteSize integer Size of the number in bytes
    ---@return integer number The read number
    function self:readNumberLE(byteSize)
        sm.scrapcomputers.errorHandler.assertArgument(byteSize, nil, {"integer"})
        sm.scrapcomputers.errorHandler.assert(byteSize > 0 and byteSize <= 64, nil, "Out of bounds! (1-64 Range)")

        if self.pos + byteSize - 1 > self.size then
            error("Not enough data to read")
        end

        local number = 0
        for i = 0, byteSize - 1 do
            local byte = self.data:sub(self.pos + i, self.pos + i):byte() or 0
            number = number + (byte * 2 ^ (i * 8))
        end

        self.pos = self.pos + byteSize
        return number
    end

    --- Writes a float using IEEE 754 standard (Big Endian)
    ---@param value number The float value to encode
    ---@return integer encodedFloat The encoded float as integer
    function self:encodeFloat(value)
        if value == 0.0 then return 0 end
        if value ~= value then return 0x7FC00000 end -- NaN
        if value == math.huge then return 0x7F800000 end -- Positive Infinity
        if value == -math.huge then return 0xFF800000 end -- Negative Infinity

        local sign = value < 0 and 1 or 0
        value = math.abs(value)

        local exponent = 0
        while value >= 2 do
            value = value / 2
            exponent = exponent + 1
        end
        while value < 1 and exponent > -127 do
            value = value * 2
            exponent = exponent - 1
        end

        if exponent >= 128 then error("Float overflow") end

        local fraction = (value * 8388608) - 8388608

        return bit.bor(
            bit.lshift(sign, 31),
            bit.lshift(exponent + 127, 23),
            bit.band(fraction, 0x007FFFFF)
        )
    end

    --- Reads a float using IEEE 754 standard (Big Endian)
    ---@param bytes integer The 4-byte integer representation of the float
    ---@return number decodedFloat The decoded float
    function self:decodeFloat(bytes)
        local sign = bit.rshift(bytes, 31) == 1 and -1 or 1
        local exponent = bit.rshift(bit.band(bytes, 0x7F800000), 23) - 127
        local fraction = bit.band(bytes, 0x007FFFFF)

        if exponent == 128 then
            if fraction == 0 then return sign * math.huge end -- Infinity
            return 0/0 -- NaN
        end

        local value = 0
        if exponent == -127 then
            value = fraction / 8388608
        else
            value = (fraction + 8388608) * math.pow(2, exponent)
        end

        return sign * value
    end

    --- Reads a double using IEEE 754 standard (Big Endian)
    ---@param bytes integer The 8-byte integer representation of the double
    ---@return number decodedDouble The decoded double
    function self:decodeDouble(bytes)
        local sign = bit.rshift(bytes, 63) == 1 and -1 or 1
        local exponent = bit.rshift(bit.band(bytes, 0x7FF0000000000000), 52) - 1023
        local fraction = bit.band(bytes, 0x000FFFFFFFFFFFFF)

        if exponent == 2047 then
            if fraction == 0 then return sign * math.huge end -- Infinity
            return 0/0 -- NaN
        end

        local value = 0
        if exponent == -1023 then
            value = fraction / 4503599627370496
        else
            value = (fraction + 4503599627370496) * math.pow(2, exponent)
        end

        return sign * value
    end

    --- Writes a double using IEEE 754 standard (Big Endian)
    ---@param value number The double value to encode
    ---@return integer encodedDouble The encoded double as integer
    function self:encodeDouble(value)
        if value == 0.0 then return 0 end
        if value ~= value then return 0x7FF8000000000000 end -- NaN
        if value == math.huge then return 0x7FF0000000000000 end -- Positive Infinity
        if value == -math.huge then return 0xFFF0000000000000 end -- Negative Infinity

        local sign = value < 0 and 1 or 0
        value = math.abs(value)

        local exponent = 0
        while value >= 2 do
            value = value / 2
            exponent = exponent + 1
        end
        while value < 1 and exponent > -1023 do
            value = value * 2
            exponent = exponent - 1
        end

        if exponent >= 1024 then error("Double overflow") end

        local fraction = (value * 4503599627370496) - 4503599627370496

        return bit.bor(
            bit.lshift(sign, 63),
            bit.lshift(exponent + 1023, 52),
            bit.band(fraction, 0x000FFFFFFFFFFFFF)
        )
    end

    ---Reads a byte from the bit stream
    ---@return integer byte The read byte
    function self:readByte()
        return self:readNumberLE(1)
    end

    ---Writes a byte to the bit stream
    ---@param byte string The byte to write
    function self:writeByte(byte)
        sm.scrapcomputers.errorHandler.assertArgument(byte, nil, {"string"})
        sm.scrapcomputers.errorHandler.assert(#byte == 1, nil, "Not a byte!")

        self:writeNumberLE(1, string.byte(byte))
    end

    ---Reads a string of a given size from the bit stream
    ---@param size integer The size of the string
    ---@param stopNulByte boolean? If it should stop by a nul byte
    ---@return string str The read string
    function self:readStringEx(size, stopNulByte)
        sm.scrapcomputers.errorHandler.assertArgument(size           , 1, {"integer"       })
        sm.scrapcomputers.errorHandler.assertArgument(sistopNulByteze, 2, {"boolean", "nil"})

        local str = ""
        for _ = 1, size do
            local byte = self:readByte()
            if byte == 0 and stopNulByte then
                break
            end

            str = str .. string.char(byte)
        end

        return str
    end

       ---Writes a float to the bit stream (Big Endian)
    ---@param value number The float value to write
    function self:writeFloatBE(value)
        local encoded = self:encodeFloat(value)
        self:writeNumberBE(4, encoded)
    end

    ---Reads a float from the bit stream (Big Endian)
    ---@return number value The read float value
    function self:readFloatBE()
        local encoded = self:readNumberBE(4)
        return self:decodeFloat(encoded)
    end

    ---Writes a double to the bit stream (Big Endian)
    ---@param value number The double value to write
    function self:writeDoubleBE(value)
        local encoded = self:encodeDouble(value)
        self:writeNumberBE(8, encoded)
    end

    ---Reads a double from the bit stream (Big Endian)
    ---@return number value The read double value
    function self:readDoubleBE()
        local encoded = self:readNumberBE(8)
        return self:decodeDouble(encoded)
    end

    ---Writes a float to the bit stream (Little Endian)
    ---@param value number The float value to write
    function self:writeFloatLE(value)
        local encoded = self:encodeFloat(value)
        self:writeNumberLE(4, encoded)
    end

    ---Reads a float from the bit stream (Little Endian)
    ---@return number value The read float value
    function self:readFloatLE()
        local encoded = self:readNumberLE(4)
        return self:decodeFloat(encoded)
    end

    ---Writes a double to the bit stream (Little Endian)
    ---@param value number The double value to write
    function self:writeDoubleLE(value)
        local encoded = self:encodeDouble(value)
        self:writeNumberLE(8, encoded)
    end

    ---Reads a double from the bit stream (Little Endian)
    ---@return number value The read double value
    function self:readDoubleLE()
        local encoded = self:readNumberLE(8)
        return self:decodeDouble(encoded)
    end

    ---Reads a string from the bit stream
    ---@param isLittleEndian boolean? If it is in little endian or big endian, Defaults to little endian.
    ---@param stopNulByte boolean? If it should stop by a nul byte
    ---@return string str The read string
    function self:readString(isLittleEndian, stopNulByte)
        sm.scrapcomputers.errorHandler.assertArgument(isLittleEndian, 1, {"boolean", "nil"})
        sm.scrapcomputers.errorHandler.assertArgument(stopNulByte   , 2, {"boolean", "nil"})
        
        if isLittleEndian or type(isLittleEndian) == "nil"  then
            return self:readStringEx(self:readNumberLE(4), stopNulByte)
        end
        return self:readStringEx(self:readNumberBE(4), stopNulByte)
    end

    function self:skipBytes(bytes)
        self.pos = self.pos + bytes
    end

    function self:seek(newPosition)
        self.pos = newPosition
    end

    return self
end
