--Additonal features for strings
sm.scrapcomputers.string = {}

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
    for index, char in sm.scrapcomputers.utf8.loopCharacters(str) do
        characters[index] = char
    end

    return characters
end

