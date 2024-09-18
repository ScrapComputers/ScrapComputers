--Additonal features for strings
sm.scrapcomputers.string = {}

-- Split a string into chunks.
---@param inputString string The string to split into
---@param chunkSize number The size per chunk
---@return string[] inputStringChunks The inputString's chunks by chunkSize
function sm.scrapcomputers.string.splitString(inputString, chunkSize)
    local chunks = {}

    for i = 1, #inputString, chunkSize do
        local chunk = string.sub(inputString, i, i + chunkSize - 1)
        chunks[#chunks + 1] = chunk
    end

    return chunks
end