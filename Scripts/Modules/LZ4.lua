-- LZ4 encoding library
sm.scrapcomputers.lz4 = {}

---Decodes a string to LZ4
---@param input string The string to decode
---@return string data The decoded string
function sm.scrapcomputers.lz4.decode(input)
    local inputLength = #input
    local inputPos = 1
    local output = {}

    local function readByte()
        local byte = input:byte(inputPos)
        inputPos = inputPos + 1

        return byte
    end

    local function readBytes(count)
        local bytes = input:sub(inputPos, inputPos + count - 1)
        inputPos = inputPos + count

        return bytes
    end

    local function readUInt16LE()
        local b1 = readByte()
        local b2 = readByte()

        return b1 + bit.lshift(b2, 8)
    end

    while inputPos <= inputLength do
        local token = readByte()
        local literalLength = bit.rshift(token, 4)
        local matchLength = bit.band(token, 0x0F) + 4

        if literalLength == 15 then
            local len

            repeat
                len = readByte()
                literalLength = literalLength + len
            until len < 255
        end

        if literalLength > 0 then
            local literals = readBytes(literalLength)

            for i = 1, #literals do
                table.insert(output, literals:sub(i, i))
            end
        end

        if inputPos > inputLength then
            break
        end

        local offset = readUInt16LE()

        if matchLength == 19 then
            local len

            repeat
                len = readByte()
                matchLength = matchLength + len
            until len < 255
        end

        local outputLength = #output

        for i = 1, matchLength do
            local matchPos = outputLength - offset + i

            table.insert(output, output[matchPos])
        end
    end

    return table.concat(output)
end

---Encodes a string to LZ4
---@param input string The string to encode
---@return string data The encoded string
function sm.scrapcomputers.lz4.encode(input)
    local inputLength = #input
    local inputBytes = {input:byte(1, -1)}
    local i = 1
    local output = {}
    local literalStart = 1
    local outputLen = 1

    while i <= inputLength do
        local bestLength, bestOffset = 0, 0
        local searchStart = (i > 65535) and (i - 65535) or 1

        for j = searchStart, i - 1 do
            local length = 0
            while (i + length <= inputLength) and (inputBytes[j + length] == inputBytes[i + length]) do
                length = length + 1
            end

            if length > bestLength and length >= 4 then
                local compressedSize = 2 + length
                if compressedSize >= 15 then
                    bestLength = length
                    bestOffset = i - j
                    if bestLength == inputLength - i + 1 then break end
                end
            end
        end

        if bestLength >= 4 then
            local literalLength = i - literalStart
            local tokenLiteral = (literalLength < 15) and literalLength or 15
            local tokenMatch = ((bestLength - 4) < 15) and (bestLength - 4) or 15
            output[outputLen] = string.char(bit.bor(bit.lshift(tokenLiteral, 4), tokenMatch))
            outputLen = outputLen + 1

            if literalLength >= 15 then
                local len = literalLength - 15
                while len >= 255 do
                    output[outputLen] = string.char(255)
                    outputLen = outputLen + 1
                    len = len - 255
                end
                output[outputLen] = string.char(len)
                outputLen = outputLen + 1
            end

            if literalLength > 0 then
                output[outputLen] = input:sub(literalStart, i - 1)
                outputLen = outputLen + 1
            end

            output[outputLen] = string.char(bit.band(bestOffset, 0xFF))
            outputLen = outputLen + 1
            output[outputLen] = string.char(bit.rshift(bestOffset, 8))
            outputLen = outputLen + 1

            if bestLength - 4 >= 15 then
                local len = bestLength - 4 - 15
                while len >= 255 do
                    output[outputLen] = string.char(255)
                    outputLen = outputLen + 1
                    len = len - 255
                end
                output[outputLen] = string.char(len)
                outputLen = outputLen + 1
            end

            i = i + bestLength
            literalStart = i
        else
            i = i + 1
        end
    end

    if literalStart <= inputLength then
        local literalLength = inputLength - literalStart + 1
        local tokenLiteral = (literalLength < 15) and literalLength or 15
        output[#output + 1] = string.char(bit.lshift(tokenLiteral, 4))

        if literalLength >= 15 then
            local len = literalLength - 15
            while len >= 255 do
                output[#output + 1] = string.char(255)
                len = len - 255
            end
            output[#output + 1] = string.char(len)
        end

        output[#output + 1] = input:sub(literalStart, inputLength)
    end

    return table.concat(output)
end