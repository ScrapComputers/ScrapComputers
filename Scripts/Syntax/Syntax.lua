sm.scrapcomputers.syntax = sm.scrapcomputers.syntax or {}

dofile("./Tokenizer.lua")
dofile("./Comment.lua")

--- Default Visual Studio Code Theme
---@class Syntax.Theme
local defaultTheme = {
    textColor = "#9CDCFE",

    stringColor      = "#CE9178",
    numberColor      = "#B5CEA8",

    error = {
        exactError = "#f7254b",
        referenceError = "#962839",
    },

    variable = {
        globalColor       = "#9CDCFE",
        unusedGlobalColor = "#9CDCFE",
        localColor        = "#9CDCFE",
        unusedLocalColor  = "#729DB4",
        baseLibraryColor  = "#78BEEF",

        selfColor         = "#569CD6",
        unusedSelfColor   = "#447299"
    },

    func = {
        globalDefineColor       = "#DCDCAA",
        globalUnusedDefineColor = "#DCDCAA",
        globalColor             = "#DCDCAA",
        globalCallColor         = "#DCDCAA",
        globalUnusedColor       = "#DCDCAA",
        globalUnusedCallColor   = "#DCDCAA",

        localDefineColor       = "#DCDCAA",
        localUnusedDefineColor = "#9D9D7C",
        localColor             = "#DCDCAA",
        localCallColor         = "#DCDCAA",
        localUnusedColor       = "#9D9D7C",
        localUnusedCallColor   = "#9D9D7C"
    },

    table = {
        callColor  = "#DCDCAA",
        indexColor = "#4EC9B0",
    },

    comment = {
        defaultColor     = "#6A9955",
        tagColor         = "#569CD6",
        typeColor        = "#4EC9B0",
        builtinTypeColor = "#4EC9B0",
        keywordColor     = "#569CD6",
        nameColor        = "#9CDCFE",
        literalColor     = "#CE9178",
        symbolColor      = "#D4D4D4",
        codeColor        = "#D7BA7D",
        linkColor        = "#3794FF",
    },

    keywords = {
        ["and"]      = "#D4D4D4",
        ["break"]    = "#C586C0",
        ["do"]       = "#C586C0",
        ["else"]     = "#C586C0",
        ["elseif"]   = "#C586C0",
        ["end"]      = "#C586C0",
        ["false"]    = "#569CD6",
        ["for"]      = "#C586C0",
        ["function"] = "#C586C0",
        ["if"]       = "#C586C0",
        ["in"]       = "#C586C0",
        ["local"]    = "#569CD6",
        ["nil"]      = "#569CD6",
        ["not"]      = "#D4D4D4",
        ["or"]       = "#D4D4D4",
        ["repeat"]   = "#C586C0",
        ["return"]   = "#C586C0",
        ["then"]     = "#C586C0",
        ["true"]     = "#569CD6",
        ["until"]    = "#C586C0",
        ["while"]    = "#C586C0",
    },

    operands = {
        ["+"]   = "#D4D4D4",
        ["-"]   = "#D4D4D4",
        ["*"]   = "#D4D4D4",
        ["/"]   = "#D4D4D4",
        ["%"]   = "#D4D4D4",
        ["^"]   = "#D4D4D4",
        ["=="]  = "#D4D4D4",
        ["~="]  = "#D4D4D4",
        [">="]  = "#D4D4D4",
        ["<="]  = "#D4D4D4",
        [">"]   = "#D4D4D4",
        ["<"]   = "#D4D4D4",
        ["="]   = "#D4D4D4",
        ["..."] = "#569CD6",
        [".."]  = "#D4D4D4",
        ["#"]   = "#D4D4D4",
        [":"]   = "#CCCCCC",
        ["."]   = "#CCCCCC",
        [","]   = "#CCCCCC",
    },

    bracketColors = { "#FFD700", "#DA70D6", "#179FFF" }
}

local sm_scrapcomputers_syntax_highlightComment = sm.scrapcomputers.syntax.highlightComment

local string_gsub  = string.gsub
local string_sub   = string.sub
local string_find  = string.find
local table_concat = table.concat
local math_max     = math.max

local scanLimit = 0x80

local operandTypes = {
    ["ELLIPSIS"] = true,
    ["CONCAT"] = true,
    ["NEQ"] = true,
    ["LE"] = true,
    ["GE"] = true,
    ["EQ"] = true,

    ["ASSIGN"] = true,
    ["LT"] = true,
    ["GT"] = true,
    ["OPERATOR"] = true,
    ["PUNCTUATION"] = true,
}

local baseLibraries = {
    ["string"] = true,
    ["table"] = true,
    ["math"] = true,
    ["bit"] = true,
    ["os"] = true
}

local bracketsOpen  = { ["["] = true, ["{"] = true, ["("] = true }
local bracketsClose = { ["]"] = true, ["}"] = true, [")"] = true }

local scopeOpen  = { ["function"] = true, ["for"]   = true, ["do"]   = true, ["repeat"] = true, ["then"] = true, ["else"] = true }
local scopeClose = { ["end"]      = true, ["until"] = true, ["else"] = true, ["elseif"] = true                                   }

local nameList      = { IDENTIFIER = true, PUNCTUATION = { [","] = true } }
local functionName  = { IDENTIFIER = true, PUNCTUATION = { ["."] = true } }

local forStop       = { KEYWORD     = { ["for"]   = true } }
local localStop     = { KEYWORD     = { ["local"] = true } }
local assignStop    = { ASSIGN      = { ["="]     = true } }
local colonStop     = { PUNCTUATION = { [":"]     = true } }

local function tokenIs(tokens, index, tokenType, value)
    local token = tokens[index]
    return token ~= nil and token.type == tokenType and (value == nil or token.value == value)
end

local function matches(token, spec)
    local rule = spec[token.type]
    return rule == true or (rule and rule[token.value]) or false
end

local function scan(tokens, index, step, walk, stop)
    for scanIndex = 1, scanLimit do
        local token = tokens[index + scanIndex * step]
        if not token then
            return false
        end

        if matches(token, stop) then
            return true
        end

        if not matches(token, walk) then
            return false
        end
    end

    return false
end

---Walks backwards over a function name (`a.b:c`) looking for `function`.
---@return boolean isDefinition
---@return boolean isLocal
---@return boolean hasColon
local function findFunctionDefinition(tokens, index)
    local hasColon = false
    for scanIndex = 1, scanLimit do
        local token = tokens[index - scanIndex]
        if not token then
            return false, false, false
        end

        local tokenType, value = token.type, token.value

        if tokenType == "KEYWORD" and value == "function" then
            return true, tokenIs(tokens, index - scanIndex - 1, "KEYWORD", "local"), hasColon
        elseif tokenType == "PUNCTUATION" and value == ":" then
            hasColon = true
        elseif not (tokenType == "IDENTIFIER" or (tokenType == "PUNCTUATION" and value == ".")) then
            return false, false, false
        end
    end

    return false, false, false
end

local function isFunctionParameter(tokens, index)
    local sawParen = false
    for scanIndex = 1, scanLimit do
        local token = tokens[index - scanIndex]
        if not token then
            return false
        end

        local tokenType, value = token.type, token.value

        if tokenType == "KEYWORD" and value == "function" then
            if sawParen then
                return true
            end
        elseif tokenType == "PUNCTUATION" and value == "(" then
            sawParen = true
        elseif not (tokenType == "IDENTIFIER" or (tokenType == "PUNCTUATION" and (value == "," or value == "." or value == ":"))) then
            return false
        end
    end

    return false
end

local function replaceColor(str, color)
    if string_sub(str, 1, 1) ~= "#" then
        return color .. str
    end

    return color .. string_sub(str, 8)
end

local function variableColor(variableTheme, name, isUsed, isGlobal)
    if name == "self" then
        return isUsed and variableTheme.selfColor or variableTheme.unusedSelfColor
    end

    if isUsed then
        return isGlobal and variableTheme.globalColor or variableTheme.localColor
    end

    return isGlobal and variableTheme.unusedGlobalColor or variableTheme.unusedLocalColor
end

local function functionColor(funcTheme, isGlobal, isUsed, isCall, isDefine)
    if isGlobal then
        if isUsed then
            return isCall and funcTheme.globalCallColor or isDefine and funcTheme.globalDefineColor or funcTheme.globalColor
        end

        return isCall and funcTheme.globalUnusedCallColor or isDefine and funcTheme.globalUnusedDefineColor or funcTheme.globalUnusedColor
    end

    if isUsed then
        return isCall and funcTheme.localCallColor or isDefine and funcTheme.localDefineColor or funcTheme.localColor
    end

    return isCall and funcTheme.localUnusedCallColor or isDefine and funcTheme.localUnusedDefineColor or funcTheme.localUnusedColor
end

---@param entry Syntax.Internal.Variable
local function entryColor(theme, entry, name, isGlobal, isDefine)
    if entry.isFunction then
        return functionColor(theme.func, isGlobal, true, false, isDefine)
    end

    return variableColor(theme.variable, name, true, isGlobal)
end

local function escapestring(value)
    if not string_find(value, "[\\#]") then
        return value
    end

    return (string_gsub(string_gsub(string_gsub(value, "\\t", "⁄t"), "\\n", "⁄n"), "#", "##"))
end

--- @class Syntax.Internal.Variable
--- @field index integer Token index of the definition (-1 if implicit)
--- @field isUsed boolean
--- @field isFunction boolean
--- @field cameFromFunctionCall boolean

---@return Syntax.Internal.Variable
local function newEntry(index, isUsed, isFunction, cameFromFunctionCall)
    return {
        index = index,
        isUsed = isUsed,
        isFunction = isFunction,
        cameFromFunctionCall = cameFromFunctionCall
    }
end

---Highlights code to have colors.
---@param source string The code
---@param exceptionLines integer[]? Error lines, the first one is the exact error
---@param theme Syntax.Theme?
---@param simpleMode boolean? Whether to disable certain syntax highlighting to improve performance (default true)
---@return string
function sm.scrapcomputers.syntax.highlightCode(source, exceptionLines, theme, simpleMode)
    theme = theme or defaultTheme
    if simpleMode == nil then
        simpleMode = true
    end

    source = string_gsub(source, "⁄", "\\")

    local textColor      = theme.textColor
    local operandColors  = theme.operands
    local keywordColors  = theme.keywords
    local bracketColors  = theme.bracketColors
    local bracketCount   = #bracketColors
    local variableTheme  = theme.variable
    local funcTheme      = theme.func
    local tableTheme     = theme.table

    local tokens = sm.scrapcomputers.syntax.tokenize(source)
    local text = {}

    local tokensNW, nwIndexOf = {}, {}
    for index, token in ipairs(tokens) do
        if token.type ~= "WHITESPACE" and token.type ~= "NEWLINE" then
            local nwIndex = #tokensNW + 1
            tokensNW[nwIndex] = token
            nwIndexOf[index] = nwIndex
        end
    end

    local depth = 1
    
    ---@type table<integer, table<string, Syntax.Internal.Variable>>
    local scopes = { {} }

    ---@type table<string, Syntax.Internal.Variable>
    local globals = {}

    local braceDepth = 0
    local bracketLevel = 1
    local pendingForDo = false

    ---@return Syntax.Internal.Variable?, boolean isGlobal
    local function findVariable(name)
        for index = depth, 1, -1 do
            local entry = scopes[index][name]
            if entry then
                return entry, false
            end
        end

        local entry = globals[name]
        if entry then
            return entry, true
        end
    end

    local function updateScope(keyword)
        local opens, closes = scopeOpen[keyword], scopeClose[keyword]

        if keyword == "for" then
            pendingForDo = true
        elseif keyword == "do" and pendingForDo then
            pendingForDo = false
            opens = false
        end

        if opens and closes then
            scopes[depth] = {}
        elseif opens then
            depth = depth + 1
            scopes[depth] = {}
        elseif closes and depth ~= 1 then
            scopes[depth] = nil
            depth = depth - 1
        end
    end

    local function highlightKeyword(index, value)
        updateScope(value)

        if value == "function" and scan(tokensNW, nwIndexOf[index], 1, functionName, colonStop) then
            scopes[depth].self = newEntry(-1, true, false, false)
        end

        return keywordColors[value] or textColor
    end

    local function highlightOperand(value)
        if value == "{" then
            braceDepth = braceDepth + 1
        elseif value == "}" then
            braceDepth = math_max(0, braceDepth - 1)
        end

        if bracketsOpen[value] then
            local color = bracketColors[(bracketLevel - 1) % bracketCount + 1]
            bracketLevel = bracketLevel + 1
            return color
        elseif bracketsClose[value] then
            bracketLevel = math_max(0, bracketLevel - 1)
            return bracketColors[(bracketLevel - 1) % bracketCount + 1]
        end

        return operandColors[value] or textColor
    end

    local function highlightVariable(index, nwIndex, name)
        local isForParam  = scan(tokensNW, nwIndex, -1, nameList, forStop)
        local isLocalDef  = not isForParam and scan(tokensNW, nwIndex, -1, nameList, localStop)
        local isGlobalDef = not (isForParam or isLocalDef) and scan(tokensNW, nwIndex, 1, nameList, assignStop)
        local isParam     = not (isForParam or isLocalDef or isGlobalDef) and isFunctionParameter(tokensNW, nwIndex)

        local entry, isGlobal = findVariable(name)
        local isUnderscore = name == "_"

        local canDefine = isLocalDef or isGlobalDef
        if entry and not isGlobal then
            canDefine = isLocalDef
        end

        if isForParam or (canDefine and isLocalDef) then
            scopes[depth][name] = newEntry(index, isUnderscore, false, false)
            return variableColor(variableTheme, name, isUnderscore, false)
        elseif canDefine then
            globals[name] = newEntry(index, true, false, false)
            return variableColor(variableTheme, name, true, true)
        elseif isParam then
            scopes[depth][name] = newEntry(index, isUnderscore, false, true)
            return variableColor(variableTheme, name, isUnderscore, true)
        end

        if not entry then
            return baseLibraries[name] and variableTheme.baseLibraryColor or variableTheme.globalColor
        end

        local colorAsGlobal = entry.cameFromFunctionCall or isGlobal
        if not entry.isUsed and entry.index ~= -1 then
            text[entry.index] = replaceColor(text[entry.index], entryColor(theme, entry, name, colorAsGlobal, true))
        end

        entry.isUsed = true
        return entryColor(theme, entry, name, colorAsGlobal, false)
    end

    local function highlightIdentifier(index, name)
        local nwIndex = nwIndexOf[index]

        local isSelfCall   = tokenIs(tokensNW, nwIndex - 1, "PUNCTUATION", ":")
        local isTableIndex = tokenIs(tokensNW, nwIndex - 1, "PUNCTUATION", ".")
        local isCall       = tokenIs(tokensNW, nwIndex + 1, "PUNCTUATION", "(")

        if isCall and not (isTableIndex or isSelfCall) then
            local entry, isGlobal = findVariable(name)

            if entry then
                if not entry.isUsed and entry.index ~= -1 then
                    text[entry.index] = replaceColor(text[entry.index], functionColor(funcTheme, isGlobal, true, true, false))
                end

                entry.isUsed = true
            end
        end

        local color
        if isSelfCall then
            color = funcTheme.localColor
        elseif isTableIndex then
            color = isCall and tableTheme.callColor or tableTheme.indexColor
        elseif isCall then
            color = funcTheme.globalCallColor
        end

        if isCall and not isTableIndex then
            local isDefinition, isLocal, hasColon = findFunctionDefinition(tokensNW, nwIndex)

            if isDefinition then
                local entry = newEntry(index, false, true, false)

                if isLocal then
                    scopes[depth - 1][name] = entry
                else
                    globals[name] = entry
                end

                color = (isLocal or hasColon) and funcTheme.localDefineColor or funcTheme.globalDefineColor
            end
        end

        if braceDepth > 0 and tokenIs(tokensNW, nwIndex + 1, "ASSIGN", "=") then
            color = tableTheme.indexColor
        end

        return color or highlightVariable(index, nwIndex, name)
    end

    local function baseColor(index, tokenType, value)
        if tokenType == "IDENTIFIER" then
            local nwIndex = nwIndexOf[index]

            if tokenIs(tokensNW, nwIndex - 1, "PUNCTUATION", ".") then
                return tableTheme.indexColor
            elseif tokenIs(tokensNW, nwIndex - 1, "PUNCTUATION", ":") then
                return tableTheme.callColor
            end
        elseif tokenType == "KEYWORD" then
            return keywordColors[value] or textColor
        elseif operandTypes[tokenType] then
            return operandColors[value] or textColor
        elseif tokenType == "STRING" then
            return theme.stringColor
        elseif tokenType == "NUMBER" then
            return theme.numberColor
        end

        return textColor
    end

    local function simpleColor(index, tokenType, value)
        if tokenType == "PUNCTUATION" and (bracketsOpen[value] or bracketsClose[value]) then
            return bracketColors[1] or textColor
        end

        return baseColor(index, tokenType, value)
    end

    local function advancedColor(index, tokenType, value)
        if tokenType == "IDENTIFIER" then
            return highlightIdentifier(index, value)
        elseif tokenType == "KEYWORD" then
            return highlightKeyword(index, value)
        elseif operandTypes[tokenType] then
            return highlightOperand(value)
        end

        return baseColor(index, tokenType, value)
    end

    local colorToken = simpleMode and simpleColor or advancedColor

    for index, token in ipairs(tokens) do
        local tokenType, value = token.type, token.value

        if tokenType == "WHITESPACE" then
            text[index] = textColor .. value
        elseif tokenType == "COMMENT" then
            text[index] = sm_scrapcomputers_syntax_highlightComment(value, theme)
        else
            text[index] = colorToken(index, tokenType, value) .. escapestring(value)
        end
    end

    if exceptionLines and #exceptionLines > 0 then
        local errorColors = {}
        for index, line in ipairs(exceptionLines) do
            errorColors[line] = errorColors[line] or (index == 1 and theme.error.exactError or theme.error.referenceError)
        end

        for index, token in ipairs(tokens) do
            local color = errorColors[token.line]
            if color then
                text[index] = replaceColor(text[index], color)
            end
        end
    end

    return table_concat(text)
end