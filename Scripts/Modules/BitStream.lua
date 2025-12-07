sm.scrapcomputers.bitstream = {}

---@return BitStream
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


-- Writing an unsigned integer
function sm.scrapcomputers.bitstream:writeUIntBE(value, numBits)
    local numBytes = math.floor(numBits / 8)
    for i = 0, numBytes - 1 do
        local shift = (numBytes - i - 1) * 8
        local byte = bit.band(bit.rshift(value, shift), 0xFF)
        self:writeByte(byte)
    end
end

function sm.scrapcomputers.bitstream:writeUIntLE(value, numBits)
    local numBytes = math.floor(numBits / 8)
    for i = 0, numBytes - 1 do
        local shift = i * 8
        local byte = bit.band(bit.rshift(value, shift), 0xFF)
        self:writeByte(byte)
    end
end

-- Reading an unsigned integer
function sm.scrapcomputers.bitstream:readUIntBE(numBits)
    local value = 0
    local numBytes = math.floor(numBits / 8)
    for i = 0, numBytes - 1 do
        local byte = self:readByte()
        local shift = (numBytes - i - 1) * 8
        value = bit.bor(value, bit.lshift(byte, shift))
    end
    return value
end

function sm.scrapcomputers.bitstream:readUIntLE(numBits)
    local value = 0
    local numBytes = math.floor(numBits / 8)
    for i = 0, numBytes - 1 do
        local byte = self:readByte()
        local shift = i * 8
        value = bit.bor(value, bit.lshift(byte, shift))
    end
    return value
end

-- Writing a signed integer
function sm.scrapcomputers.bitstream:writeIntBE(value, numBits)
    if value < 0 then value = value + bit.lshift(1, numBits) end
    self:writeUIntBE(value, numBits)
end

function sm.scrapcomputers.bitstream:writeIntLE(value, numBits)
    if value < 0 then value = value + bit.lshift(1, numBits) end
    self:writeUIntLE(value, numBits)
end

-- Reading a signed integer in Big Endian
function sm.scrapcomputers.bitstream:readIntBE(numBits)
    local value = self:readUIntBE(numBits)
    local maxVal = bit.lshift(1, numBits - 1)
    if value >= maxVal then value = value - bit.lshift(1, numBits) end
    return value
end

function sm.scrapcomputers.bitstream:readIntLE(numBits)
    local value = self:readUIntLE(numBits)
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

local function floatToBytes(value)
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

    return b1, b2, b3, b4
end

local function bytesToFloat(b1, b2, b3, b4)
    local sign = bit.rshift(b1, 7)
    local exponent = bit.band(bit.lshift(b1, 1), 0xFF) + bit.rshift(b2, 7) - 127
    local mantissa = bit.bor(bit.lshift(bit.band(b2, 0x7F), 16), bit.lshift(b3, 8), b4) + math.ldexp(1, 23)
    local value = math.ldexp(mantissa, exponent - 23)
    if sign == 1 then value = -value end
    return value
end

function sm.scrapcomputers.bitstream:writeFloatBE(value)
    local b1, b2, b3, b4 = floatToBytes(value)
    self:writeByte(b1)
    self:writeByte(b2)
    self:writeByte(b3)
    self:writeByte(b4)
end

function sm.scrapcomputers.bitstream:writeFloatLE(value)
    local b1, b2, b3, b4 = floatToBytes(value)
    self:writeByte(b4)
    self:writeByte(b3)
    self:writeByte(b2)
    self:writeByte(b1)
end

function sm.scrapcomputers.bitstream:readFloatBE()
    local b1 = self:readByte()
    local b2 = self:readByte()
    local b3 = self:readByte()
    local b4 = self:readByte()
    return bytesToFloat(b1, b2, b3, b4)
end

function sm.scrapcomputers.bitstream:readFloatLE()
    local b4 = self:readByte()
    local b3 = self:readByte()
    local b2 = self:readByte()
    local b1 = self:readByte()
    return bytesToFloat(b1, b2, b3, b4)
end

function sm.scrapcomputers.bitstream:writeUIntVBE(value)
    local bytes = {}
    repeat
        local byte = bit.band(value, 0x7F)
        value = bit.rshift(value, 7)
        if #bytes > 0 then
            byte = bit.bor(byte, 0x80)
        end
        table.insert(bytes, 1, byte) -- insert at front for big-endian
    until value == 0

    for _, b in ipairs(bytes) do
        self:writeByte(b)
    end
end

function sm.scrapcomputers.bitstream:writeUIntVLE(value)
    repeat
        local byte = bit.band(value, 0x7F)
        value = bit.rshift(value, 7)
        if value > 0 then
            byte = bit.bor(byte, 0x80)
        end
        self:writeByte(byte)
    until value == 0
end

function sm.scrapcomputers.bitstream:readUIntVLE()
    local result = 0
    local shift = 0
    local byte
    repeat
        byte = self:readByte()
        result = bit.bor(result, bit.lshift(bit.band(byte, 0x7F), shift))
        shift = shift + 7
    until bit.band(byte, 0x80) == 0
    return result
end

function sm.scrapcomputers.bitstream:readUIntVBE()
    local bytes = {}
    local byte
    repeat
        byte = self:readByte()
        table.insert(bytes, byte)
    until bit.band(byte, 0x80) == 0

    local result = 0
    local shift = 0
    for i = #bytes, 1, -1 do
        local b = bit.band(bytes[i], 0x7F)
        result = bit.bor(result, bit.lshift(b, shift))
        shift = shift + 7
    end
    return result
end

function sm.scrapcomputers.bitstream:readIntVBE()
    local zz = self:readUIntVBE()
    return bit.bxor(bit.rshift(zz, 1), -bit.band(zz, 1))
end

function sm.scrapcomputers.bitstream:readIntVLE()
    local zz = self:readUIntVLE()
    return bit.bxor(bit.rshift(zz, 1), -bit.band(zz, 1))
end

-- ZigZag encode and write VLE
function sm.scrapcomputers.bitstream:writeIntVLE(value)
    local zz = bit.bxor(bit.lshift(value, 1), bit.arshift(value, 31))
    self:writeUIntVLE(zz)
end

-- ZigZag encode and write VBE
function sm.scrapcomputers.bitstream:writeIntVBE(value)
    local zz = bit.bxor(bit.lshift(value, 1), bit.arshift(value, 31))
    self:writeUIntVBE(zz)
end

local function doubleToBytes(value)
    local sign = 0
    if value < 0 then
        sign = 1
        value = -value
    end

    local mantissa, exponent = math.frexp(value)
    if value == 0 then
        return 0, 0, 0, 0, 0, 0, 0, 0
    end

    -- Normalize
    exponent = exponent + 1022
    mantissa = (mantissa * 2 - 1) * math.ldexp(1, 52)

    local hiMant = math.floor(mantissa / 2^32)
    local loMant = math.floor(mantissa % 2^32)

    local b1 = bit.bor(bit.lshift(sign, 7), bit.rshift(exponent, 4))
    local b2 = bit.bor(bit.lshift(bit.band(exponent, 0xF), 4), bit.rshift(hiMant, 24))
    local b3 = bit.band(bit.rshift(hiMant, 16), 0xFF)
    local b4 = bit.band(bit.rshift(hiMant, 8), 0xFF)
    local b5 = bit.band(hiMant, 0xFF)
    local b6 = bit.band(bit.rshift(loMant, 24), 0xFF)
    local b7 = bit.band(bit.rshift(loMant, 16), 0xFF)
    local b8 = bit.band(bit.rshift(loMant, 8), 0xFF)

    return b1, b2, b3, b4, b5, b6, b7, bit.band(loMant, 0xFF)
end

local function bytesToDouble(b1, b2, b3, b4, b5, b6, b7, b8)
    local sign = bit.rshift(b1, 7)
    local exponent = bit.band(b1, 0x7F) * 16 + bit.rshift(b2, 4)
    local hiMant = bit.band(b2, 0x0F)
    hiMant = bit.bor(bit.lshift(hiMant, 24), bit.lshift(b3, 16), bit.lshift(b4, 8), b5)
    local loMant = bit.bor(bit.lshift(b6, 24), bit.lshift(b7, 16), bit.lshift(b8, 8), 0)

    if exponent == 0 and hiMant == 0 and loMant == 0 then
        return 0.0
    end

    exponent = exponent - 1023
    local mantissa = hiMant * 2^(-20) + loMant * 2^(-52)
    local value = math.ldexp(1 + mantissa, exponent)

    if sign == 1 then
        value = -value
    end

    return value
end

function sm.scrapcomputers.bitstream:writeDoubleBE(value)
    local b1, b2, b3, b4, b5, b6, b7, b8 = doubleToBytes(value)
    self:writeByte(b1)
    self:writeByte(b2)
    self:writeByte(b3)
    self:writeByte(b4)
    self:writeByte(b5)
    self:writeByte(b6)
    self:writeByte(b7)
    self:writeByte(b8)
end

function sm.scrapcomputers.bitstream:writeDoubleLE(value)
    local b1, b2, b3, b4, b5, b6, b7, b8 = doubleToBytes(value)
    self:writeByte(b8)
    self:writeByte(b7)
    self:writeByte(b6)
    self:writeByte(b5)
    self:writeByte(b4)
    self:writeByte(b3)
    self:writeByte(b2)
    self:writeByte(b1)
end

function sm.scrapcomputers.bitstream:readDoubleBE()
    local b1 = self:readByte()
    local b2 = self:readByte()
    local b3 = self:readByte()
    local b4 = self:readByte()
    local b5 = self:readByte()
    local b6 = self:readByte()
    local b7 = self:readByte()
    local b8 = self:readByte()
    return bytesToDouble(b1, b2, b3, b4, b5, b6, b7, b8)
end

function sm.scrapcomputers.bitstream:readDoubleLE()
    local b8 = self:readByte()
    local b7 = self:readByte()
    local b6 = self:readByte()
    local b5 = self:readByte()
    local b4 = self:readByte()
    local b3 = self:readByte()
    local b2 = self:readByte()
    local b1 = self:readByte()
    return bytesToDouble(b1, b2, b3, b4, b5, b6, b7, b8)
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

function sm.scrapcomputers.bitstream:skipBits(bits)
    self.bitPos = self.bitPos + bits
end