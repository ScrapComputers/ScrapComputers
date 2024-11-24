--Additonal features for strings
sm.scrapcomputers.string = {}

local function getUTF8Character(str, index)
    local byte = string.byte(str, index)
    local byteCount = 1

    if byte >= 0xC0 and byte <= 0xDF then
        byteCount = 2
    elseif byte >= 0xE0 and byte <= 0xEF then
        byteCount = 3
    elseif byte >= 0xF0 and byte <= 0xF7 then
        byteCount = 4
    end

    return string.sub(str, index, index + byteCount - 1)
end

local function getUTF8StringSize(str)
    local length = 0
    local index = 1

    while index <= #str do
        local byte = string.byte(str, index)

        if byte >= 0 and byte <= 127 then
            index = index + 1
        elseif byte >= 192 and byte <= 223 then
            index = index + 2
        elseif byte >= 224 and byte <= 239 then
            index = index + 3
        elseif byte >= 240 and byte <= 247 then
            index = index + 4
        else
            index = index + 1
        end

        length = length + 1
    end

    return length
end

-- Split a string into chunks.
---@param inputString string The string to split into
---@param chunkSize number The size per chunk
---@return string[] inputStringChunks The inputString's chunks by chunkSize
function sm.scrapcomputers.string.splitString(inputString, chunkSize)
    sm.scrapcomputers.errorHandler.assertArgument(inputString, 1, {"string"})
    sm.scrapcomputers.errorHandler.assertArgument(chunkSize, 2, {"integer"})
    
    local chunks = {}
    local index = 1
    for i = 1, #inputString, chunkSize do
        local chunk = string.sub(inputString, i, i + chunkSize - 1)
        chunks[index] = chunk
        index = index + 1
    end

    return chunks
end

-- Split a string into chunks.
---@param str string The string to split into
---@return string[] characters 
function sm.scrapcomputers.string.toCharacters(str)
    sm.scrapcomputers.errorHandler.assertArgument(str, nil, {"string"})

    local characters = {}
    local index = 1

    while index <= #str do
        local char = getUTF8Character(str, index)
        characters[#characters+1] = char
        index = index + #char
    end
    return characters
end

