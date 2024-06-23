---@diagnostic disable: return-type-mismatch
-- A BitStream Module that lets you make packet data (for example)
sm.scrapcomputers.BitStream = {}

-- Converts a number to binary
---@param num number The number to convert to binary
---@return string binaryNumber The binary number
local function toBinary(num)
    local binary = ""  -- Initialize an empty string to store the binary representation
    while num > 0 do
        local remainder = num % 2  -- Get the remainder when num is divided by 2
        binary = remainder..binary  -- Append the remainder to the binary string
        num = math.floor(num / 2)  -- Divide num by 2 and take the floor to get the quotient
    end
    return binary  -- Return the binary string
end

-- Adds padding to binary string of 0's to be a byte
---@param binaryStr string The binary string
---@return string binaryStr The binary string that works with bytes
local function padToEightBits(binaryStr)
    return ("0"):rep(8 - #binaryStr)..binaryStr  -- Add leading zeros to make the length of binaryStr 8
end

-- Converts inputStr to actual bytes instead of 0 and 1 characters
---@param inputStr string The input string to convert to binary
---@return string The concatenated binary result
local function stringToBinary(inputStr)
    local binaryResult = {}  -- Initialize an empty table to store binary values

    -- Loop through each character in inputStr
    for i = 1, #inputStr do
        local asciiValue = string.byte(inputStr, i)  -- Get the ASCII value of the character
        local binary = toBinary(asciiValue)  -- Convert the ASCII value to binary
        binary = padToEightBits(binary)  -- Pad the binary value to 8 bits
        table.insert(binaryResult, binary)  -- Insert the binary value into the result table
    end

    return table.concat(binaryResult)  -- Concatenate all binary values into a single string
end

-- Assert for checking types
---@param allowedTypes type[] Allowed Types
---@param badArgument number? The argument it was located. Set this to nil if there's only 1 argument.
---@param value any The value to check.
local function assertType(allowedTypes, badArgument, value)
    local valueType = type(value)  -- Get the type of the value

    -- Check if the valueType is in allowedTypes
    for _, allowedType in pairs(allowedTypes) do
        if valueType == allowedType then
            return  -- If the value type matches an allowed type, exit the function
        end
    end

    -- Construct an error message
    local errorMsg = "Expected"

    -- Append "bad argument #..." if badArgument is provided
    if type(badArgument) == "number" then
        errorMsg = "bad argument #"..sm.scrapcomputers.toString(badArgument).."."..errorMsg
    end

    -- Check if there's only one allowed type
    if #allowedTypes == 1 then
        errorMsg = errorMsg..allowedTypes[1]  -- Append the single allowed type to the error message
    else
        for index, allowedType in pairs(allowedTypes) do
            if index == #allowedTypes then
                errorMsg = errorMsg:sub(1, #errorMsg - 2).." or "..allowedType  -- Append the last type with "or"
            else
                errorMsg = errorMsg.. ", "..allowedType  -- Append the type to the error message
            end
        end
    end

    error(errorMsg..", got "..valueType.." instead.")  -- Throw the error with the constructed message
end

---Creates a new BitStream Stream
---@param data string? Pre-appended binary data.
---@return table bitStream The bit stream itself.
function sm.scrapcomputers.BitStream.new(data)
    local self = {}  -- Create a new table to represent the BitStream
    self.data = ""  -- Initialize data as an empty string
    self.pos = 1  -- Initialize the bit position pointer
    self.bytePos = 1  -- Initialize the byte position pointer
    self.size = 0  -- Initialize the size of the data

    if data then  -- If pre-appended data is provided
        self.data = stringToBinary(data)  -- Convert the data to binary and store it
        self.size = #data  -- Update the size to the length of the data
    end

    ---Dumps the string
    ---@return string dumpedString The dumped string
    function self:dumpString()
        local alignmentBits = #self.data % 8  -- Calculate how many bits are needed for alignment
        local data = self.data..(("\0"):rep(alignmentBits))  -- Pad with null characters for alignment
        local output = ""

        -- Iterate over the binary data in chunks of 8 bits
        for i = 1, #data - 7, 8 do
            -- Convert each 8-bit chunk to a character and append it to the output
            output = output..string.char(tonumber(data:sub(i, i + 7), 2))
        end
        
        return output  -- Return the converted string
    end

    ---Dumps the string (as base64)
    ---@return string dumpedString The dumped string
    function self:dumpBase64()
        return sm.scrapcomputers.base64.encode(self:dumpString())  -- Encode the dumped string as base64 and return it
    end

    ---Dumps the string (as hex)
    ---@return string dumpedString The dumped string
    function self:dumpHex()
        local chr = ""  -- Initialize an empty string for the hex characters
        local str = self:dumpString()  -- Get the dumped string

        -- Iterate over each character in the dumped string
        for i = 1, #str, 1 do
            -- Convert each character to its hex representation and append it to chr
            chr = chr..string.format("%02X", str:sub(i, i):byte())
        end

        return chr
    end

    ---Writes a bit
    ---@param bit boolean|number The bit value to write
    function self:writeBit(bit)
        assertType({"boolean", "number"}, nil, bit)  -- Ensure the bit is either a boolean or a number

        local bitValue = nil  -- Initialize bitValue

        if type(bit) == "number" then
            assert(bit == 1 or bit == 0, "Invalid Bit! (0 or 1 allowed for numbers)")  -- Ensure the bit is 0 or 1
            bitValue = tostring(bit)  -- Convert the number to a string
        else
            bitValue = (bit == true and "1" or "0")  -- Convert the boolean to "1" or "0"
        end

        self.data = self.data..bitValue  -- Append the bit value to the data
        self.size = self.size + 1  -- Increment the size
    end

    ---Reads a bit
    ---@return integer? 0 or 1 for bit value. Nil if it overflows.
    function self:readBit()
        if self.pos <= #self.data then  -- If the position is within the bounds of the data
            local bit = tonumber(self.data:sub(self.pos, self.pos))  -- Get the bit at the current position
            self.pos = self.pos + 1  -- Move the bit position pointer
            if (self.pos - 1) % 8 == 0 then
                self.bytePos = self.bytePos + 1  -- Move the byte position pointer if a byte boundary is crossed
            end

            return bit  -- Return the bit value
        end
    end

    ---Writes a byte
    ---@param byte number The byte to write (Number because it must be as ASCII char)
    function self:writeByte(byte)
        assertType({"number"}, nil, byte)  -- Ensure the byte is a number
        assert(#byte == 1, "Not a byte!")  -- Ensure the byte is of length 1

        -- Loop through each bit in the byte
        for i = 7, 0, -1 do
            local bit = bit.band(byte, 2^i) > 0 and 1 or 0  -- Get the bit at position i
            self:writeBit(bit)  -- Write the bit
        end
    end

    ---Reads a byte
    ---@return string? byte The byte it has read.
    function self:readByte()
        local byte = 0  -- Initialize the byte to 0

        -- Loop through 8 bits to form a byte
        for i = 7, 0, -1 do
            local bit = self:readBit()  -- Read the bit
            if bit then
                byte = byte + bit * 2^i  -- Add the bit to the byte value
            else
                return  -- Return if no bit is read (overflow)
            end
        end

        return byte  -- Return the byte
    end

    ---Writes a signed 8-bit integer.
    ---@param integer integer The integer to write
    function self:writeInt8(integer)
        if integer < -128 or integer > 127 then
            error("Integer out of range for int8: "..integer)  -- Throw an error if the integer is out of range
        end
        local byte = bit.band(integer, 0xFF)  -- Get the least significant byte
        self:writeByte(byte)  -- Write the byte
    end
    
    ---Reads a signed 8-bit integer.
    ---@return integer? The signed 8-bit integer read.
    function self:readInt8()
        local byte = self:readByte()  -- Read a byte
        if byte >= 128 then
            byte = byte - 256  -- Convert to signed if necessary
        end
        return byte  -- Return the signed integer
    end
    
    ---Writes an unsigned 8-bit integer.
    ---@param uinteger integer The unsigned integer to write.
    function self:writeUInt8(uinteger)
        if uinteger < 0 or uinteger > 255 then
            error("Integer out of range for uint8: "..uinteger)  -- Throw an error if the integer is out of range
        end
        self:writeByte(uinteger)  -- Write the unsigned byte
    end
    
    ---Reads an unsigned 8-bit integer.
    ---@return integer? The unsigned 8-bit integer read.
    function self:readUInt8()
        return self:readByte()  -- Read a byte and return it as unsigned
    end
    
    ---Writes a signed 16-bit integer.
    ---@param integer integer The signed integer to write.
    function self:writeInt16(integer)
        if integer < -32768 or integer > 32767 then
            error("Integer out of range for int16: "..integer)  -- Throw an error if the integer is out of range
        end
        self:writeByte(bit.band(integer, 0xFF))  -- Write the least significant byte
        self:writeByte(bit.band(bit.rshift(integer, 8), 0xFF))  -- Write the most significant byte
    end
    
    ---Reads a signed 16-bit integer.
    ---@return integer? The signed 16-bit integer read.
    function self:readInt16()
        local byte1 = self:readByte()  -- Read the least significant byte
        local byte2 = self:readByte()  -- Read the most significant byte
        local integer = byte1 + byte2 * 256  -- Combine bytes into a 16-bit integer
        if integer >= 32768 then
            integer = integer - 65536  -- Convert to signed if necessary
        end
        return integer  -- Return the signed integer
    end
    
    ---Writes an unsigned 16-bit integer.
    ---@param uinteger integer The unsigned integer to write.
    function self:writeUInt16(uinteger)
        if uinteger < 0 or uinteger > 65535 then
            error("Integer out of range for uint16: "..uinteger)  -- Throw an error if the integer is out of range
        end
        self:writeByte(bit.band(uinteger, 0xFF))  -- Write the least significant byte
        self:writeByte(bit.band(bit.rshift(uinteger, 8), 0xFF))  -- Write the most significant byte
    end
    
    ---Reads an unsigned 16-bit integer.
    ---@return integer? The unsigned 16-bit integer read.
    function self:readUInt16()
        local byte1 = self:readByte()  -- Read the least significant byte
        local byte2 = self:readByte()  -- Read the most significant byte
        return byte1 + byte2 * 256  -- Combine bytes into an unsigned 16-bit integer
    end
    
    ---Writes a signed 24-bit integer.
    ---@param integer integer The signed integer to write.
    function self:writeInt24(integer)
        if integer < -8388608 or integer > 8388607 then
            error("Integer out of range for int24: "..integer)  -- Throw an error if the integer is out of range
        end
        self:writeByte(bit.band(integer, 0xFF))  -- Write the least significant byte
        self:writeByte(bit.band(bit.rshift(integer, 8), 0xFF))  -- Write the middle byte
        self:writeByte(bit.band(bit.rshift(integer, 16), 0xFF))  -- Write the most significant byte
    end
    
    ---Reads a signed 24-bit integer.
    ---@return integer? The signed 24-bit integer read.
    function self:readInt24()
        local byte1 = self:readByte()  -- Read the least significant byte
        local byte2 = self:readByte()  -- Read the middle byte
        local byte3 = self:readByte()  -- Read the most significant byte
        local integer = byte1 + byte2 * 256 + byte3 * 65536  -- Combine bytes into a 24-bit integer
        if integer >= 8388608 then
            integer = integer - 16777216  -- Convert to signed if necessary
        end
        return integer  -- Return the signed integer
    end
    
    ---Writes an unsigned 24-bit integer.
    ---@param uinteger integer The unsigned integer to write.
    function self:writeUInt24(uinteger)
        if uinteger < 0 or uinteger > 16777215 then
            error("Integer out of range for uint24: "..uinteger)  -- Throw an error if the integer is out of range
        end
        self:writeByte(bit.band(uinteger, 0xFF))  -- Write the least significant byte
        self:writeByte(bit.band(bit.rshift(uinteger, 8), 0xFF))  -- Write the middle byte
        self:writeByte(bit.band(bit.rshift(uinteger, 16), 0xFF))  -- Write the most significant byte
    end
    
    ---Reads an unsigned 24-bit integer.
    ---@return integer? The unsigned 24-bit integer read.
    function self:readUInt24()
        local byte1 = self:readByte()  -- Read the least significant byte
        local byte2 = self:readByte()  -- Read the middle byte
        local byte3 = self:readByte()  -- Read the most significant byte
        return byte1 + byte2 * 256 + byte3 * 65536  -- Combine bytes into an unsigned 24-bit integer
    end
    
    ---Writes a signed 32-bit integer.
    ---@param integer integer The signed integer to write.
    function self:writeInt32(integer)
        self:writeByte(bit.band(integer, 0xFF))  -- Write the least significant byte
        self:writeByte(bit.band(bit.rshift(integer, 8), 0xFF))  -- Write the second byte
        self:writeByte(bit.band(bit.rshift(integer, 16), 0xFF))  -- Write the third byte
        self:writeByte(bit.band(bit.rshift(integer, 24), 0xFF))  -- Write the most significant byte
    end
    
    ---Reads a signed 32-bit integer.
    ---@return integer? The signed 32-bit integer read.
    function self:readInt32()
        local byte1 = self:readByte()  -- Read the least significant byte
        local byte2 = self:readByte()  -- Read the second byte
        local byte3 = self:readByte()  -- Read the third byte
        local byte4 = self:readByte()  -- Read the most significant byte
        local integer = byte1 + byte2 * 256 + byte3 * 65536 + byte4 * 16777216  -- Combine bytes into a 32-bit integer
        if integer >= 2147483648 then
            integer = integer - 4294967296  -- Convert to signed if necessary
        end
        return integer  -- Return the signed integer
    end
    
    ---Writes an unsigned 32-bit integer.
    ---@param uinteger integer The unsigned integer to write.
    function self:writeUInt32(uinteger)
        if uinteger < 0 or uinteger > 4294967295 then
            error("Integer out of range for uint32: "..uinteger)  -- Throw an error if the integer is out of range
        end
        self:writeByte(bit.band(uinteger, 0xFF))  -- Write the least significant byte
        self:writeByte(bit.band(bit.rshift(uinteger, 8), 0xFF))  -- Write the second byte
        self:writeByte(bit.band(bit.rshift(uinteger, 16), 0xFF))  -- Write the third byte
        self:writeByte(bit.band(bit.rshift(uinteger, 24), 0xFF))  -- Write the most significant byte
    end
    
    ---Reads an unsigned 32-bit integer.
    ---@return integer? The unsigned 32-bit integer read.
    function self:readUInt32()
        local byte1 = self:readByte()  -- Read the least significant byte
        local byte2 = self:readByte()  -- Read the second byte
        local byte3 = self:readByte()  -- Read the third byte
        local byte4 = self:readByte()  -- Read the most significant byte
        return byte1 + byte2 * 256 + byte3 * 65536 + byte4 * 16777216  -- Combine bytes into an unsigned 32-bit integer
    end
    
    ---Writes a string.
    ---@param str string The string to write.
    function self:writeString(str)
        self:writeUInt32(#str)  -- Write the length of the string
        for i = 1, #str do
            local charCode = string.byte(str, i)  -- Get the ASCII code
            self:writeByte(charCode)  -- Write each character as a byte
        end
    end
    
    ---Reads a string.
    ---@return string? The string read.
    function self:readString()
        local length = self:readUInt32()  -- Read the length of the string
        if not length then
            return nil  -- Return nil if length is not valid
        end
        local chars = {}
        for i = 1, length do
            local charCode = self:readByte()  -- Read each character byte
            if not charCode then
                return nil  -- Return nil if character code is not valid
            end
            table.insert(chars, string.char(charCode))  -- Convert byte to character and insert into table
        end
        return table.concat(chars)  -- Return the concatenated string
    end
    
    return self
end