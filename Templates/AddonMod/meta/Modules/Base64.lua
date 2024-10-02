-- Base64 encoding and decoding library
sm.scrapcomputers.base64 = {}

---Encodes a string to base64
---@param data string The string to encode
---@return string data The encoded string
function sm.scrapcomputers.base64.encode(data)
    sm.scrapcomputers.errorHandler.assertArgument(data, nil, {"string"})

    local base64Chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    local binaryRepresentation = {}

    for index = 1, #data do
        local asciiValue = data:byte(index)
        local binaryString = ""
        
        for j = 7, 0, -1 do
            binaryString = binaryString .. (bit.band(asciiValue, bit.lshift(1, j)) ~= 0 and "1" or "0")
        end
        
        binaryRepresentation[#binaryRepresentation + 1] = binaryString
    end

    local concatedbinaryRepresentation = table.concat(binaryRepresentation) .. "0000"
    local base64Encoded = {}

    for binarySegment in concatedbinaryRepresentation:gmatch("%d%d%d?%d?%d?%d?") do
        if #binarySegment < 6 then break end
        local index = 0
        
        for index2 = 1, 6 do
            index = index + (binarySegment:sub(index2, index2) == "1" and bit.lshift(1, 6 - index2) or 0)
        end
        
        base64Encoded[#base64Encoded + 1] = base64Chars:sub(index + 1, index + 1)
    end

    return table.concat(base64Encoded) .. ({"", "==", "="})[#data % 3 + 1]
end

---Decodes a string to base64
---@param data string The string to decode
---@return string data The decoded string
function sm.scrapcomputers.base64.decode(data)
    sm.scrapcomputers.errorHandler.assertArgument(data, nil, {"string"})

    local base64Chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789+/"
    data = data:gsub("[^" .. base64Chars .. "=]", "")

    local binaryRepresentation = {}

    for index = 1, #data do
        local character = data:sub(index, index)

        if character == "=" then break end

        local index2 = base64Chars:find(character) - 1
        local binaryString = ""

        for j = 5, 0, -1 do
            binaryString = binaryString .. (bit.band(index2, bit.lshift(1, j)) ~= 0 and "1" or "0")
        end

        binaryRepresentation[#binaryRepresentation + 1] = binaryString
    end

    local concatedbinaryRepresentation = table.concat(binaryRepresentation)
    local decodedString = {}
    for binarySegment in concatedbinaryRepresentation:gmatch("%d%d%d%d%d%d%d%d") do
        if #binarySegment ~= 8 then break end

        local asciiValue = 0
        
        for i = 1, 8 do
            asciiValue = asciiValue + (binarySegment:sub(i, i) == "1" and bit.lshift(1, 8 - i) or 0)
        end
        
        decodedString[#decodedString + 1] = string.char(asciiValue)
    end

    return table.concat(decodedString)
end
