sm.scrapcomputers.bitstream = {}

function sm.scrapcomputers.bitstream.new(data)
    local self = unpack({sm.scrapcomputers.bitstream})
    self.data = {}

    if data then
        for char in data:gmatch(".") do
            table.insert(self.data, string.byte(char))
        end
    end

    self.bitPos = 0

    return self
end

function sm.scrapcomputers.bitstream:writeBits(value, numBits)
    for i = numBits - 1, 0, -1 do
        local byteIndex = math.floor(self.bitPos / 8) + 1
        local bitOffset = self.bitPos % 8
        local bitToWrite = bit.band(bit.rshift(value, i), 1)

        self.data[byteIndex] = self.data[byteIndex] or 0
        self.data[byteIndex] = bit.bor(self.data[byteIndex], bit.lshift(bitToWrite, 7 - bitOffset))

        self.bitPos = self.bitPos + 1
    end
end

function sm.scrapcomputers.bitstream:readBits(numBits)
    local value = 0
    for i = numBits - 1, 0, -1 do
        local byteIndex = math.floor(self.bitPos / 8) + 1
        local bitOffset = self.bitPos % 8
        local bitValue = bit.band(bit.rshift(self.data[byteIndex], 7 - bitOffset), 1)

        value = bit.bor(value, bit.lshift(bitValue, i))
        self.bitPos = self.bitPos + 1
    end
    return value
end


-- Writing an unsigned integer in Big Endian
function sm.scrapcomputers.bitstream:writeUInt(value, numBits)
    local numBytes = math.floor(numBits / 8)

    for i = 0, numBytes - 1 do
        local byte = bit.band(bit.rshift(value, (numBytes - i - 1) * 8), 0xFF)
        self:writeByte(byte)
    end
end

-- Reading an unsigned integer in Big Endian
function sm.scrapcomputers.bitstream:readUInt(numBits)
    local value = 0
    local numBytes = math.floor(numBits / 8)
    
    for i = 0, numBytes - 1 do
        local byte = self:readByte()
        value = bit.bor(value, bit.lshift(byte, (numBytes - i - 1) * 8))
    end

    return value
end

-- Writing a signed integer in Big Endian
function sm.scrapcomputers.bitstream:writeInt(value, numBits)
    if value < 0 then value = value + bit.lshift(1, numBits) end
    self:writeUInt(value, numBits)
end

-- Reading a signed integer in Big Endian
function sm.scrapcomputers.bitstream:readInt(numBits)
    local value = self:readUInt(numBits)
    local maxVal = bit.lshift(1, numBits - 1)
    if value >= maxVal then value = value - bit.lshift(1, numBits) end
    return value
end

function sm.scrapcomputers.bitstream:writeByte(value)
    self:writeBits(value, 8)
end

function sm.scrapcomputers.bitstream:readByte()
    return self:readBits(8)
end

function sm.scrapcomputers.bitstream:writeBytes(bytes)
    for i = 1, #bytes do
        self:writeByte(bytes:byte(i))
    end
end

function sm.scrapcomputers.bitstream:readBytes(numBytes)
    local bytes = {}
    for i = 1, numBytes do
        table.insert(bytes, string.char(self:readByte()))
    end
    return table.concat(bytes)
end

function sm.scrapcomputers.bitstream:writeFloat(value)
    local sign = 0
    if value < 0 then
        sign = 1
        value = -value
    end

    local mantissa, exponent = math.frexp(value)
    mantissa = (mantissa * 2 - 1) * math.ldexp(0.5, 24)
    exponent = exponent + 126

    local b1 = bit.bor(bit.lshift(sign, 7), bit.rshift(exponent, 1))
    local b2 = bit.bor(bit.lshift(bit.band(exponent, 1), 7), bit.rshift(mantissa, 16))
    local b3 = bit.band(bit.rshift(mantissa, 8), 0xFF)
    local b4 = bit.band(mantissa, 0xFF)

    self:writeByte(b1)
    self:writeByte(b2)
    self:writeByte(b3)
    self:writeByte(b4)
end

function sm.scrapcomputers.bitstream:readFloat()
    local b1 = self:readByte()
    local b2 = self:readByte()
    local b3 = self:readByte()
    local b4 = self:readByte()

    local sign = bit.rshift(b1, 7)
    local exponent = bit.band(bit.lshift(b1, 1), 0xFF) + bit.rshift(b2, 7) - 127
    local mantissa = bit.bor(bit.lshift(bit.band(b2, 0x7F), 16), bit.lshift(b3, 8), b4) + math.ldexp(1, 23)
    local value = math.ldexp(mantissa, exponent - 23)
    
    if sign == 1 then value = -value end
    return value
end

function sm.scrapcomputers.bitstream:writeUIntV(value)
    local byte

    if value < 0x80 then
        self:writeByte(value)
        return
    end

    byte = bit.bor(bit.band(value, 0x7F), 0x80)
    self:writeByte(byte)
    value = bit.rshift(value, 7)

    if value < 0x80 then
        self:writeByte(value)
        return
    end

    byte = bit.bor(bit.band(value, 0x7F), 0x80)
    self:writeByte(byte)
    value = bit.rshift(value, 7)

    if value < 0x80 then
        self:writeByte(value)
        return
    end

    byte = bit.bor(bit.band(value, 0x7F), 0x80)
    self:writeByte(byte)
    value = bit.rshift(value, 7)

    self:writeByte(value) -- final byte, no continuation bit
end

function sm.scrapcomputers.bitstream:readUIntV()
    local result = 0
    local shift = 0

    local byte = self:readByte()
    result = bit.bor(result, bit.lshift(bit.band(byte, 0x7F), shift))
    if bit.band(byte, 0x80) == 0 then
        return result
    end

    shift = shift + 7
    byte = self:readByte()
    result = bit.bor(result, bit.lshift(bit.band(byte, 0x7F), shift))
    if bit.band(byte, 0x80) == 0 then
        return result
    end

    shift = shift + 7
    byte = self:readByte()
    result = bit.bor(result, bit.lshift(bit.band(byte, 0x7F), shift))
    if bit.band(byte, 0x80) == 0 then
        return result
    end

    shift = shift + 7
    byte = self:readByte()
    result = bit.bor(result, bit.lshift(bit.band(byte, 0x7F), shift))
    if bit.band(byte, 0x80) == 0 then
        return result
    end

    shift = shift + 7
    byte = self:readByte()
    result = bit.bor(result, bit.lshift(byte, shift))
    return result
end

-- Variable-length Signed Integer (safe)
function sm.scrapcomputers.bitstream:writeIntV(value)
    -- ZigZag encode 32-bit signed integer to unsigned
    local zz = bit.bxor(bit.lshift(value, 1), bit.arshift(value, 31))
    self:writeUIntV(zz)
end

function sm.scrapcomputers.bitstream:readIntV()
    local zz = self:readUIntV()
    -- ZigZag decode: (zz >> 1) ^ -(zz & 1)
    return bit.bxor(bit.rshift(zz, 1), -bit.band(zz, 1))
end

function sm.scrapcomputers.bitstream:reset()
    self.data = {}
    self.bitPos = 0
end

function sm.scrapcomputers.bitstream:align()
    local bitOffset = self.bitPos % 8

    if bitOffset > 0 then
        local bitsToAlign = 8 - bitOffset
        self.bitPos = self.bitPos + bitsToAlign
    end
end

function sm.scrapcomputers.bitstream:tostring()
    local output = {}
    for _, byte in ipairs(self.data) do
        table.insert(output, string.char(byte))
    end
    return table.concat(output)
end
