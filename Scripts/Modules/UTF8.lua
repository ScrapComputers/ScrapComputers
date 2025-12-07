sm.scrapcomputers.utf8 = {}

local string_sub = string.sub
local string_byte = string.byte

---Returns the UTF-8 character starting at the given byte index in the string.
---@param str string The UTF-8 encoded string.
---@param index integer The byte index in the string where the character starts (1-based).
---@return string The full UTF-8 character at the given byte index.
---@return integer byteCount The number of bytes in the character.
function sm.scrapcomputers.utf8.getCharacterAt(str, index)
    local byte = string_byte(str, index)
    local byteCount = 0

    if byte >= 0 and byte <= 127 then
        byteCount = 1
    elseif byte >= 0xC0 and byte <= 0xDF then
        byteCount = 2
    elseif byte >= 0xE0 and byte <= 0xEF then
        byteCount = 3
    elseif byte >= 0xF0 and byte <= 0xF7 then
        byteCount = 4
    else
        error("Invalid UTF8 string!")
    end

    return string_sub(str, index, index + byteCount - 1), byteCount
end

---Returns the number of UTF-8 characters in the string.
---@param str string The UTF-8 encoded string.
---@return number size The number of UTF-8 characters in the string.
function sm.scrapcomputers.utf8.getStringSize(str)
    local length = 0
    local index = 1

    while index <= #str do
        local byte = string_byte(str, index)

        if byte >= 0 and byte <= 127 then
            index = index + 1
        elseif byte >= 192 and byte <= 223 then
            index = index + 2
        elseif byte >= 224 and byte <= 239 then
            index = index + 3
        elseif byte >= 240 and byte <= 247 then
            index = index + 4
        else
            error("Invalid UTF8 string!")
        end

        length = length + 1
    end

    return length
end

---Returns an iterator to loop through each UTF-8 character in a string.
---@param str string The UTF-8 encoded string to iterate over.
---@return function iteratorFunc An iterator function which returns the next UTF-8 character each time it is called.
function sm.scrapcomputers.utf8.loopCharacters(str)
    local index = 1
    local length = #str

    return function()
        if index > length then
            return nil
        end

        local byte = string_byte(str, index)
        local byteCount = 1

        if byte >= 0xC0 and byte <= 0xDF then
            byteCount = 2
        elseif byte >= 0xE0 and byte <= 0xEF then
            byteCount = 3
        elseif byte >= 0xF0 and byte <= 0xF7 then
            byteCount = 4
        end

        local char = string_sub(str, index, index + byteCount - 1)
        index = index + byteCount
        return index, char
    end
end
