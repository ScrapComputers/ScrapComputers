local string_sub = string.sub
local string_byte = string.byte
local table_concat = table.concat

sm.scrapcomputers.keywordCompression = {}

-- DO NOT FUCKING REORDER THIS!
local delimiters = {
    "and", "break", "do", "else", "elseif", "end", "false", "for", "function",
    "if", "in", "local", "nil", "not", "or", "repeat", "return", "then", "true",
    "until", "while",

    "        ",   -- Space x8
    "      ",     -- Space x6
    "    ",       -- Space x4
    "  ",         -- Space x2
    " ",          -- Space
    "\t\t",       -- Tab x2
    "\t",         -- Tab
    "\n",         -- Newline
    "--[[",       -- Start of long comment
    "--]]",       -- End of long comment
    "--[",        -- Start of multi-line comment
    "--]",        -- End of multi-line comment
    "--",         -- Single-line comment
    "'",          -- Single-quoted string
    '"',          -- Double-quoted string
    "[[",         -- Start of long string
    "]]",         -- End of long string
    "{",          -- Start of table
    "}",          -- End of table
    "[",          -- Start of bracket
    "]",          -- End of bracket
    "(",          -- Open parenthesis
    ")",          -- Close parenthesis
    ",",          -- Comma separator
    ";",          -- Semicolon (rarely used, but valid)
    "==",         -- Equality
    "=",          -- Assignment
    "~=",         -- Not equal
    "<",          -- Less than
    ">",          -- Greater than
    "<=",         -- Less than or equal
    ">=",         -- Greater than or equal
    "+",          -- Addition
    "-",          -- Subtraction
    "*",          -- Multiplication
    "/",          -- Division
    "%",          -- Modulus
    "^",          -- Exponent
    "..",         -- String concatenation
    "#",          -- Length operator
    ".",          -- Member access
    ":",          -- Method call
}

local function getUTF8Character(str, index)
    local byte = string_byte(str, index)
    local byteCount = 1

    if byte >= 0xC0 and byte <= 0xDF then
        byteCount = 2
    elseif byte >= 0xE0 and byte <= 0xEF then
        byteCount = 3
    elseif byte >= 0xF0 and byte <= 0xF7 then
        byteCount = 4
    end

    return string_sub(str, index, index + byteCount - 1)
end

function sm.scrapcomputers.keywordCompression.compress(text)
    local keywords = {}
    local keywordCache = {}
    local data = {}

    local currentToken = ""
    local dataLen = 0
    local keywordsLen = 0

    local i = 1
    while i <= #text do
        local isDelimitor = false
        local delimitorText
        local delimitorIndex

        for j, delimitor in pairs(delimiters) do
            if string_sub(text, i, i + #delimitor - 1) == delimitor then
                delimitorText = delimitor
                delimitorIndex = -j
                isDelimitor = true
                break
            end
        end

        local character = getUTF8Character(text, i)
        if isDelimitor then
            if #currentToken > 0 then
                local keywordIndex = keywordCache[currentToken]
                if not keywordIndex then
                    keywordsLen = keywordsLen + 1
                    keywordIndex = keywordsLen
                    keywords[keywordIndex] = currentToken
                    keywordCache[currentToken] = keywordIndex
                end
                dataLen = dataLen + 1
                data[dataLen] = keywordIndex
                currentToken = ""
            end
            dataLen = dataLen + 1
            data[dataLen] = delimitorIndex
            i = i + #delimitorText
        else
            currentToken = currentToken .. character
            i = i + #character
        end
    end

    if #currentToken > 0 then
        local keywordIndex = keywordCache[currentToken]
        if not keywordIndex then
            keywordsLen = keywordsLen + 1
            keywordIndex = keywordsLen
            keywords[keywordIndex] = currentToken
            keywordCache[currentToken] = keywordIndex
        end
        dataLen = dataLen + 1
        data[dataLen] = keywordIndex
    end

    local stream = sm.scrapcomputers.bitstream.new()
    stream:writeBytes("\x1bKWC")

    stream:writeUIntV(keywordsLen)
    for i = 1, keywordsLen do
        local keyword = keywords[i]
        stream:writeUIntV(#keyword)
        stream:writeBytes(keyword)
    end

    stream:writeUIntV(dataLen)
    for i = 1, dataLen do
        stream:writeIntV(data[i])
    end

    return stream:tostring()
end

function sm.scrapcomputers.keywordCompression.decompress(data)
    local stream = sm.scrapcomputers.bitstream.new(data)
    local identifier = stream:readBytes(4)
    sm.scrapcomputers.errorHandler.assert(identifier == "\x1bKWC", nil, "Not KWC Compressed data!")

    local keywordsSize = stream:readUIntV()
    local keywords = {}
    for i = 1, keywordsSize do
        local keywordTextSize = stream:readUIntV()
        keywords[i] = stream:readBytes(keywordTextSize)
    end

    local dataSize = stream:readUIntV()
    local outputParts = {}
    for i = 1, dataSize do
        local number = stream:readIntV()
        outputParts[i] = number < 0 and delimiters[-number] or keywords[number]
    end

    return table_concat(outputParts)
end

function sm.scrapcomputers.keywordCompression.isCompressedWithKWC(data)
    return string_sub(data, 1, 4) == "\x1bKWC"
end