sm.scrapcomputers.syntax = sm.scrapcomputers.syntax or {}

local string_find  = string.find
local string_sub   = string.sub
local string_gsub  = string.gsub
local string_match = string.match
local table_insert = table.insert
local table_concat = table.concat

local builtinTypes = {
    ["any"] = true,
    ["unknown"] = true,
    ["void"] = true,
    ["self"] = true
}

for typeId, typeName in pairs(sm.scrapcomputers.types) do
    if type(typeId) == "number" and type(typeName) == "string" then
        builtinTypes[typeName] = true
    end
end

local keywordTypes = {
    ["nil"] = true,
    ["true"] = true,
    ["false"] = true,
    ["fun"] = true
}

local fieldScopes = {
    public = true,
    private = true,
    protected = true,
    package = true
}

---@class Syntax.Internal.CommentPalette
---@field text string
---@field tag string
---@field type string
---@field builtin string
---@field keyword string
---@field name string
---@field literal string
---@field symbol string
---@field code string
---@field link string

---@type table<Syntax.Theme, Syntax.Internal.CommentPalette>
local palettes = sm.scrapcomputers.metatable.setmetatable({}, { __mode = "k" })

---@param theme Syntax.Theme
---@return Syntax.Internal.CommentPalette
local function buildPalette(theme)
    local comment = theme.comment
    local text = comment.defaultColor

    local palette = {
        text    = text,
        tag     = comment.tagColor         or theme.keywords["local"]   or text,
        type    = comment.typeColor        or theme.table.indexColor    or text,
        builtin = comment.builtinTypeColor or theme.table.indexColor    or text,
        keyword = comment.keywordColor     or theme.keywords["nil"]     or text,
        name    = comment.nameColor        or theme.variable.localColor or text,
        literal = comment.literalColor     or theme.stringColor         or text,
        symbol  = comment.symbolColor      or theme.operands[","]       or text,
        code    = comment.codeColor        or theme.stringColor         or text,
        link    = comment.linkColor        or theme.table.indexColor    or text,
    }

    palettes[theme] = palette
    return palette
end

local function escapeString(text)
    if not string_find(text, "[\\#]") then
        return text
    end

    return (string_gsub(string_gsub(string_gsub(text, "\\t", "⁄t"), "\\n", "⁄n"), "#", "##"))
end

local function emitText(buffer, color, text)
    if text ~= "" then
        table_insert(buffer, color .. escapeString(text))
    end
end

local function typeEnd(str, position)
    local depth = 0
    local index = position

    local length = #str
    while index <= length do
        local character = string_sub(str, index, index)

        if character == '"' or character == "'" then
            index = string_find(str, character, index + 1, true) or length
        elseif character == "<" or character == "(" or character == "[" or character == "{" then
            depth = depth + 1
        elseif character == ">" or character == ")" or character == "]" or character == "}" then
            depth = depth - 1
        elseif depth <= 0 then
            if character == "," then
                return index - 1
            elseif character == " " or character == "\t" then
                local nextPos = string_find(str, "%S", index)
                if not nextPos then return index - 1 end

                if string_sub(str, nextPos, nextPos) ~= "|" and string_sub(str, index - 1, index - 1) ~= "|" then
                    return index - 1
                end

                index = nextPos - 1
            end
        end

        index = index + 1
    end

    return length
end

local function emitType(buffer, palette, str)
    local index = 1

    local length = #str
    while index <= length do
        local first, last = string_find(str, "^[%a_][%w_%.]*", index)

        if first then
            local word = string_sub(str, first, last)
            local color = palette.type

            if string_find(str, "^%??%s*:", last + 1) then
                color = palette.name -- `fun(name: type)` parameter
            elseif keywordTypes[word] then
                color = palette.keyword
            elseif builtinTypes[word] then
                color = palette.builtin
            end

            emitText(buffer, color, word)
            index = last + 1
        else
            local character = string_sub(str, index, index)

            if character == '"' or character == "'" then
                local close = string_find(str, character, index + 1, true) or length
                emitText(buffer, palette.literal, string_sub(str, index, close))

                index = close + 1
            else
                local _, symbolEnd = string_find(str, "^[^%a_\"']+", index)
                emitText(buffer, palette.symbol, string_sub(str, index, symbolEnd))

                index = symbolEnd + 1
            end
        end
    end
end

local function skipSpace(buffer, palette, str, position)
    local _, last = string_find(str, "^%s*", position)
    emitText(buffer, palette.text, string_sub(str, position, last))

    return last + 1
end

local function readName(buffer, palette, str, position, color)
    position = skipSpace(buffer, palette, str, position)

    local _, last = string_find(str, "^[%w_%.]+%??", position)
    if not last then return position end

    emitText(buffer, color, string_sub(str, position, last))
    return last + 1
end

local function readType(buffer, palette, str, position)
    position = skipSpace(buffer, palette, str, position)

    local last = typeEnd(str, position)
    emitType(buffer, palette, string_sub(str, position, last))
    return last + 1
end

local function readTypeList(buffer, palette, str, position)
    while true do
        position = skipSpace(buffer, palette, str, readType(buffer, palette, str, position))
        if string_sub(str, position, position) ~= "," then
            return position
        end

        emitText(buffer, palette.symbol, ",")
        position = position + 1
    end
end

local function emitDescription(buffer, palette, text)
    local position = 1

    while true do
        local first, last = string_find(text, "`[^`]+`", position)
        if not first then break end

        emitText(buffer, palette.text, string_sub(text, position, first - 1))
        emitText(buffer, palette.code, string_sub(text, first, last))
        position = last + 1
    end

    emitText(buffer, palette.text, string_sub(text, position))
end

local function plainComment(palette, line)
    if not string_find(line, "`", 1, true) then
        return palette.text .. escapeString(line)
    end

    local buffer = {}
    emitDescription(buffer, palette, line)

    return table_concat(buffer)
end

local function readText(buffer, palette, str, position)
    emitDescription(buffer, palette, string_sub(str, position))
end

local function typeHandler(buffer, palette, str, position)
    readText(buffer, palette, str, readTypeList(buffer, palette, str, position))
end

local tagHandlers = {
    param = function(buffer, palette, str, position)
        position = readName(buffer, palette, str, position, palette.name)
        readText(buffer, palette, str, readType(buffer, palette, str, position))
    end,

    field = function(buffer, palette, str, position)
        position = skipSpace(buffer, palette, str, position)

        local scope = string_match(str, "^(%a+)%s", position)
        if scope and fieldScopes[scope] then
            emitText(buffer, palette.builtin, scope)
            position = position + #scope
        end

        position = readName(buffer, palette, str, position, palette.name)
        readText(buffer, palette, str, readType(buffer, palette, str, position))
    end,

    class = function(buffer, palette, str, position) -- `Name`, `(exact) Name`, `Name: Parent, Parent2`
        position = skipSpace(buffer, palette, str, position)

        local _, modifierEnd = string_find(str, "^%b()", position)
        if modifierEnd then
            emitText(buffer, palette.builtin, string_sub(str, position, modifierEnd))

            position = modifierEnd + 1
        end

        position = skipSpace(buffer, palette, str, readName(buffer, palette, str, position, palette.type))

        if string_sub(str, position, position) == ":" then
            emitText(buffer, palette.symbol, ":")

            position = readTypeList(buffer, palette, str, position + 1)
        end

        readText(buffer, palette, str, position)
    end,

    generic = function(buffer, palette, str, position)
        while true do
            position = skipSpace(buffer, palette, str, readName(buffer, palette, str, position, palette.type))

            if string_sub(str, position, position) == ":" then
                emitText(buffer, palette.symbol, ":")
                position = skipSpace(buffer, palette, str, readType(buffer, palette, str, position + 1))
            end

            if string_sub(str, position, position) ~= "," then break end

            emitText(buffer, palette.symbol, ",")
            position = position + 1
        end

        readText(buffer, palette, str, position)
    end,

    alias = function(buffer, palette, str, position)
        position = readName(buffer, palette, str, position, palette.type)
        readText(buffer, palette, str, readType(buffer, palette, str, position))
    end,

    cast = function(buffer, palette, str, position)
        typeHandler(buffer, palette, str, readName(buffer, palette, str, position, palette.name))
    end,

    enum = function(buffer, palette, str, position)
        readText(buffer, palette, str, readName(buffer, palette, str, position, palette.type))
    end,

    ["return"] = function(buffer, palette, str, position)
        position = readTypeList(buffer, palette, str, position)

        if string_sub(str, position, position) ~= "#" then
            position = readName(buffer, palette, str, position, palette.name)
        end

        readText(buffer, palette, str, position)
    end,

    see = function(buffer, palette, str, position)
        position = skipSpace(buffer, palette, str, position)

        local _, last = string_find(str, "^[%w_%.:#]+", position)
        if last then
            emitText(buffer, palette.link, string_sub(str, position, last))
            position = last + 1
        end

        readText(buffer, palette, str, position)
    end,

    type     = typeHandler,
    overload = typeHandler,
    vararg   = typeHandler,
    as       = typeHandler,
}

---Highlights a lua comment.
---@param line string
---@param theme Syntax.Theme
---@return string
function sm.scrapcomputers.syntax.highlightComment(line, theme)
    local palette = palettes[theme] or buildPalette(theme)
    if not string_find(line, "^%-%-%-[^%-]") then
        return plainComment(palette, line)
    end
    
    local lead, tag = string_match(line, "^(%-%-%-%s*)@([%w_]+)")

    if tag then
        local tagEnd = #lead + 1 + #tag
        local buffer = {}

        emitText(buffer, palette.text, lead)
        emitText(buffer, palette.tag, string_sub(line, #lead + 1, tagEnd))

        local handler = tagHandlers[tag]
        if handler then
            handler(buffer, palette, line, tagEnd + 1)
        else
            readText(buffer, palette, line, tagEnd + 1)
        end

        return table_concat(buffer)
    end

    if string_find(line, "^%-%-%-|") then
        local buffer = {}

        emitText(buffer, palette.text, "---")
        emitText(buffer, palette.tag, "|")
        readText(buffer, palette, line, readType(buffer, palette, line, 5))

        return table_concat(buffer)
    end

    return plainComment(palette, line)
end