-- Base64 encoding and decoding library
sm.scrapcomputers.base64 = {}

local b64chars = 'ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/'

---Encodes a string to base64
---@param data string The string to encode
---@return string data The encoded string
function sm.scrapcomputers.base64.encode(data)
    sm.scrapcomputers.errorHandler.assertArgument(data, nil, {"string"})

    local output = {}
    local len = #data
    local i = 1

    while i <= len do
        local a, b, c = data:byte(i, i+2)
        local bits = bit.bor(bit.lshift(a or 0, 16), bit.lshift(b or 0, 8), (c or 0))

        table.insert(output, b64chars:sub(bit.band(bit.rshift(bits, 18), 0x3F) + 1, bit.band(bit.rshift(bits, 18), 0x3F) + 1))
        table.insert(output, b64chars:sub(bit.band(bit.rshift(bits, 12), 0x3F) + 1, bit.band(bit.rshift(bits, 12), 0x3F) + 1))

        if b then
            table.insert(output, b64chars:sub(bit.band(bit.rshift(bits, 6), 0x3F) + 1, bit.band(bit.rshift(bits, 6), 0x3F) + 1))
        end

        if c then
            table.insert(output, b64chars:sub(bit.band(bits, 0x3F) + 1, bit.band(bits, 0x3F) + 1))
        end

        i = i + 3
    end

    return table.concat(output)
end

---Decodes a string to base64
---@param data string The string to decode
---@return string data The decoded string
function sm.scrapcomputers.base64.decode(data)
    sm.scrapcomputers.errorHandler.assertArgument(data, nil, {"string"})

    local b64lookup = {}

    for i = 1, #b64chars do
        b64lookup[b64chars:sub(i, i)] = i - 1
    end

    b64lookup['='] = 0

    local output = {}
    local buffer = 0
    local bitsCollected = 0

    for i = 1, #data do
        local char = data:sub(i, i)
        local value = b64lookup[char]
        
        if value == nil then
            error("Invalid Base64 character: " .. char)
        end

        buffer = bit.bor(bit.lshift(buffer, 6), value)
        bitsCollected = bitsCollected + 6

        if bitsCollected >= 8 then
            bitsCollected = bitsCollected - 8
            local byte = bit.band(bit.rshift(buffer, bitsCollected), 0xFF)

            table.insert(output, string.char(byte))
        end
    end

    return table.concat(output)
end
