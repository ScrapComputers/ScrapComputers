sm.scrapcomputers.syntax = sm.scrapcomputers.syntax or {}

dofile("./Tokenizer.lua")
dofile("./Comment.lua")

-- Github Theme - Github Dark
-- ---@class Syntax.Theme
-- local defaultTheme = {
--     textColor = "#E1E4E8",

--     stringColor      = "#9ECBE6",
--     numberColor      = "#79B8F2",

--     error = {
--         exactError = "#f7254b",
--         referenceError = "#962839",
--     },

--     variable = {
--         globalColor       = "#FFAB70",
--         unusedGlobalColor = "#B68360",
--         localColor        = "#E1E4E8",
--         unusedLocalColor  = "#8D969D",
--         baseLibraryColor  = "#79B8F2",

--         selfColor         = "#79B8FF",
--         unusedSelfColor   = "#557FAD"
--     },

--     func = {
--         globalDefineColor       = "#6EB8FF",
--         globalUnusedDefineColor = "#6EB8FF",
--         globalColor             = "#6EB8FF",
--         globalCallColor         = "#6EB8FF",
--         globalUnusedColor       = "#6EB8FF",
--         globalUnusedCallColor   = "#6EB8FF",

--         localDefineColor       = "#B392F0",
--         localUnusedDefineColor = "#8372B5",
--         localColor             = "#6EB8FF",
--         localCallColor         = "#B392F0",
--         localUnusedColor       = "#8372B5",
--         localUnusedCallColor   = "#8372B5"
--     },

--     table = {
--         callColor  = "#B392F0",
--         indexColor = "#B392F0",
--     },

--     comment = {
--         defaultColor     = "#6A737D",
--     },

--     keywords = {
--         ["and"]      = "#F97583",
--         ["break"]    = "#F97583",
--         ["do"]       = "#F97583",
--         ["else"]     = "#F97583",
--         ["elseif"]   = "#F97583",
--         ["end"]      = "#F97583",
--         ["false"]    = "#79B8FF",
--         ["for"]      = "#F97583",
--         ["function"] = "#F97583",
--         ["if"]       = "#F97583",
--         ["in"]       = "#F97583",
--         ["local"]    = "#F97583",
--         ["nil"]      = "#79B8FF",
--         ["not"]      = "#F97583",
--         ["or"]       = "#F97583",
--         ["repeat"]   = "#F97583",
--         ["return"]   = "#F97583",
--         ["then"]     = "#F97583",
--         ["true"]     = "#79B8FF",
--         ["until"]    = "#F97583",
--         ["while"]    = "#F97583",
--     },

--     operands = {
--         ["+"]   = "#F97583",
--         ["-"]   = "#F97583",
--         ["*"]   = "#F97583",
--         ["/"]   = "#F97583",
--         ["%"]   = "#F97583",
--         ["^"]   = "#F97583",
--         ["=="]  = "#F97583",
--         ["~="]  = "#F97583",
--         [">="]  = "#F97583",
--         ["<="]  = "#F97583",
--         [">"]   = "#F97583",
--         ["<"]   = "#F97583",
--         ["="]   = "#F97583",
--         ["..."] = "#E1E4E8",
--         [".."]  = "#F97583",
--         ["#"]   = "#F97583",
--         [":"]   = "#79B8FF",
--         ["."]   = "#E1E4E8",
--         [","]   = "#E1E4E8",
--     },

--     bracketColors = { "#79B8FF", "#FFAB6E", "#B392F0" }
-- }


--- Default Visual Studio Code Theme
---@class Syntax.Theme
local defaultTheme = {
    textColor = "#9CDCFE",

    stringColor      = "#CE916F",
    numberColor      = "#B5CEA8",

    error = {
        exactError = "#f7254b",
        referenceError = "#962839",
    },

    variable = {
        globalColor       = "#9CDCFE",
        unusedGlobalColor = "#9CDCFE",
        localColor        = "#9CDCFE",
        unusedLocalColor  = "#73A1BB",
        baseLibraryColor  = "#9CDCFE",

        selfColor         = "#569CD6",
        unusedSelfColor   = "#4476A1"
    },

    func = {
        globalDefineColor       = "#DCDCAA",
        globalUnusedDefineColor = "#DCDCAA",
        globalColor             = "#DCDCAA",
        globalCallColor         = "#DCDCAA",
        globalUnusedColor       = "#DCDCAA",
        globalUnusedCallColor   = "#DCDCAA",

        localDefineColor       = "#DCDCAA",
        localUnusedDefineColor = "#96A991",
        localColor             = "#DCDCAA",
        localCallColor         = "#DCDCAA",
        localUnusedColor       = "#96A991",
        localUnusedCallColor   = "#96A991"
    },

    table = {
        callColor  = "#DCDCAA",
        indexColor = "#4EC9B0",
    },

    comment = {
        defaultColor     = "#6A9955",
    },

    keywords = {
        ["and"]      = "#D4D4D4",
        ["break"]    = "#CE92A4",
        ["do"]       = "#CE92A4",
        ["else"]     = "#CE92A4",
        ["elseif"]   = "#CE92A4",
        ["end"]      = "#CE92A4",
        ["false"]    = "#569CD6",
        ["for"]      = "#CE92A4",
        ["function"] = "#CE92A4",
        ["if"]       = "#CE92A4",
        ["in"]       = "#CE92A4",
        ["local"]    = "#569CD6",
        ["nil"]      = "#569CD6",
        ["not"]      = "#D4D4D4",
        ["or"]       = "#D4D4D4",
        ["repeat"]   = "#CE92A4",
        ["return"]   = "#CE92A4",
        ["then"]     = "#CE92A4",
        ["true"]     = "#569CD6",
        ["until"]    = "#CE92A4",
        ["while"]    = "#CE92A4",
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
        ["..."] = "#E1E4E8",
        [".."]  = "#D4D4D4",
        ["#"]   = "#D4D4D4",
        [":"]   = "#569CD6",
        ["."]   = "#CCCCCC",
        [","]   = "#CCCCCC",
    },

    bracketColors = { "#FFD700", "#DA70D6", "#179FFF" }
}

local bracketsOpen  = { ["["] = true, ["{"] = true, ["("] = true }
local bracketsClose = { ["]"] = true, ["}"] = true, [")"] = true }

local sm_scrapcomputers_syntax_highlightComment = sm.scrapcomputers.syntax.highlightComment
local table_remove = table.remove
local table_insert = table.insert
local table_concat = table.concat
local string_gsub  = string.gsub
local string_sub   = string.sub
local string_find  = string.find
local math_max     = math.max

---Highlights code to have colors.
---@param source string The code
---@param exceptionLines integer? exception lines
---@param theme Syntax.Theme
---@param simpleMode boolean Wether to disable certain syntax highlighting to improve performance
---@return string
function sm.scrapcomputers.syntax.highlightCode(source, exceptionLines, theme, simpleMode)
    theme = theme or defaultTheme
    source = string_gsub(source, "⁄", "\\")
    simpleMode = type(simpleMode) == "nil" and true or simpleMode

    local themeOperands = theme.operands
    local themeTextColor = theme.textColor
    local themeBracketColors = theme.bracketColors
    local themeKeywords = theme.keywords
    local themeStringColor = theme.stringColor
    local themeNumberColor = theme.numberColor

    local themeVariable_globalColor       = theme.variable.globalColor
    local themeVariable_unusedGlobalColor = theme.variable.unusedGlobalColor
    local themeVariable_localColor        = theme.variable.localColor
    local themeVariable_unusedLocalColor  = theme.variable.unusedLocalColor
    local themeVariable_baseLibraryColor  = theme.variable.baseLibraryColor
    local themeVariable_selfColor         = theme.variable.selfColor
    local themeVariable_unusedSelfColor   = theme.variable.unusedSelfColor

    local themeFunc_globalDefineColor       = theme.func.globalDefineColor
    local themeFunc_globalUnusedDefineColor = theme.func.globalUnusedDefineColor
    local themeFunc_globalColor             = theme.func.globalColor
    local themeFunc_globalCallColor         = theme.func.globalCallColor
    local themeFunc_globalUnusedColor       = theme.func.globalUnusedColor
    local themeFunc_globalUnusedCallColor   = theme.func.globalUnusedCallColor
    local themeFunc_localDefineColor        = theme.func.localDefineColor
    local themeFunc_localUnusedDefineColor  = theme.func.localUnusedDefineColor
    local themeFunc_localColor              = theme.func.localColor
    local themeFunc_localCallColor          = theme.func.localCallColor
    local themeFunc_localUnusedColor        = theme.func.localUnusedColor
    local themeFunc_localUnusedCallColor    = theme.func.localUnusedCallColor

    local themeTable_indexColor = theme.table.indexColor
    local themeTable_callColor  = theme.table.callColor
    
    local themeError_exactError = theme.error.exactError
    local themeError_referenceError = theme.error.referenceError
    
    local bracketColorsSize = #theme.bracketColors

    local tokens = sm.scrapcomputers.syntax.tokenize(source)
    local text = {}

    local tokensNW = {}
    local tokenIndexToNWIndex = {}

    do
        local index = 1
        for key, value in ipairs(tokens) do
            if value.type ~= "WHITESPACE" then
                table_insert(tokensNW, value)
                tokenIndexToNWIndex[key] = index
                index = index + 1
            end
        end
    end

    local function getNWTokenIndex(index)
        return tokenIndexToNWIndex[index]
    end

    local function doesNWTokenMatch(index, expectedType, expectedValue)
        local token = tokensNW[index]
        return token and token.type == expectedType and (expectedValue == nil or token.value == expectedValue)
    end

    local operands = {
        ["ELLIPSIS"] = true, ["CONCAT"] = true, ["NEQ"] = true, ["LE"] = true,
        ["GE"] = true, ["EQ"] = true, ["ASSIGN"] = true, ["LT"] = true,
        ["GT"] = true, ["OPERATOR"] = true, ["PUNCTUATION"] = true,
    }

    local baseLibraries = {
        ["string"] = true, ["table"] = true, ["math"] = true, ["bit"] = true, ["os"] = true
    }

    local bracketLevel = 1

    --- @class Syntax.Internal.Variable
    --- @field index integer
    --- @field isUsed boolean
    --- @field isFunction boolean
    --- @field cameFromFunctionCall boolean

    local codeDepthIndex = 1

    ---@type table<integer, table<string, Syntax.Internal.Variable>>
    local localVariableSheet = { {} }

    ---@type table<string, Syntax.Internal.Variable>
    local globalVariableSheet = {}

    local bracketStack = {}
    local function currentIsTableLiteral()
        for i = #bracketStack, 1, -1 do
            if bracketStack[i].kind == "{" then
                return bracketStack[i].isTable
            end
        end
        return false
    end

    local function replaceColor(str, color)
        if str:sub(1, 1) ~= "#" then
            return color .. str
        end

        return color .. str:sub(8)
    end

    local function findLocalVariable(tokenValue)
        for i = codeDepthIndex, 1, -1 do
            local variables = localVariableSheet[i]
            local value = variables[tokenValue]

            if value then
                return value, i
            end
        end
    end

    local function findGlobalVariable(tokenValue)
        return globalVariableSheet[tokenValue]
    end

    local function findVariable(tokenValue)
        local localVariable, depth = findLocalVariable(tokenValue)
        if localVariable then
            return true, false, localVariable, depth
        end

        local globalVariable = findGlobalVariable(tokenValue)
        if globalVariable then
            return true, true, globalVariable, nil
        end

        return false, nil, nil, nil
    end

    local function colorVariable(name, isUsed, isGlobal, isFunction, isCall, isDefine, iHateThis)
        if iHateThis then
            return isGlobal and themeFunc_globalDefineColor or themeFunc_localDefineColor
        end

        if isFunction then
            if isGlobal then
                if isUsed then
                    return isCall and themeFunc_globalCallColor or (isDefine and themeFunc_globalDefineColor or themeFunc_globalColor)
                else
                    return isCall and themeFunc_globalUnusedCallColor or (isDefine and themeFunc_globalUnusedDefineColor or themeFunc_globalUnusedColor)
                end
            else
                if isUsed then
                    return isCall and themeFunc_localCallColor or (isDefine and themeFunc_localDefineColor or themeFunc_localColor)
                else
                    return isCall and themeFunc_localUnusedCallColor or (isDefine and themeFunc_localUnusedDefineColor or themeFunc_localUnusedColor)
                end
            end
        end

        if name == "self" then
            return isUsed and themeVariable_selfColor or themeVariable_unusedSelfColor
        end

        if isUsed then
            return isGlobal and themeVariable_globalColor or themeVariable_localColor
        end

        return isGlobal and themeVariable_unusedGlobalColor or themeVariable_unusedLocalColor
    end

    local function advancedParseToken(outColor, outValue, index, tokenType, tokenValue)
        local outColor = outColor
        local outValue = outValue

        if tokenType == "PUNCTUATION" then
            if tokenValue == "{" then
                -- PROBABLE BUG: This may not be a valid table or be a false positive
                table_insert(bracketStack, { kind = "{", isTable = true })
            elseif tokenValue == "}" then
                -- Pop matching {
                for j = #bracketStack, 1, -1 do
                    if bracketStack[j].kind == "{" then
                        table_remove(bracketStack, j)
                        break
                    end
                end
            elseif tokenValue == "(" or tokenValue == "[" then
                table_insert(bracketStack, { kind = tokenValue })
            elseif tokenValue == ")" or tokenValue == "]" then
                -- Pop matching ( or [
                for j = #bracketStack, 1, -1 do
                    local kind = bracketStack[j].kind
                    if kind == "(" and tokenValue == ")" or kind == "[" and tokenValue == "]" then
                        table_remove(bracketStack, j)
                        break
                    end
                end
            end
        end

        if tokenType == "IDENTIFIER" then
            local nwTokenIndex = getNWTokenIndex(index)

            local isSelfCall     = doesNWTokenMatch(nwTokenIndex - 1, "PUNCTUATION", ":")
            local isSelfCall2    = doesNWTokenMatch(nwTokenIndex + 1, "PUNCTUATION", ":")
            local isTableIndex   = doesNWTokenMatch(nwTokenIndex - 1, "PUNCTUATION", ".")
            local isTableIndex2  = doesNWTokenMatch(nwTokenIndex + 1, "PUNCTUATION", ".")
            local isFunctionCall = doesNWTokenMatch(nwTokenIndex + 1, "PUNCTUATION", "(")

            if isSelfCall then
                outColor = themeFunc_localColor
            elseif isTableIndex then
               if isFunctionCall then
                   outColor = themeTable_callColor
               else
                   outColor = themeTable_indexColor
               end
            elseif isFunctionCall then
                outColor = themeFunc_globalCallColor
            else
                outColor = nil
            end

            if not (isTableIndex or isSelfCall) and isFunctionCall then
                local foundVariableExists, foundVariableIsGlobal, foundVariableData, _ = findVariable(tokenValue)

                if foundVariableExists then
                    if not foundVariableData.isUsed and foundVariableData.index ~= -1 then
                        local newColor = colorVariable(tokenValue, true, foundVariableIsGlobal, true, true, false, false)
                        text[foundVariableData.index] = replaceColor(text[foundVariableData.index], newColor)
                    end

                    foundVariableData.isUsed = true
                end
            end

            local isFunctionDefinition = false
            local isFunctionDefinitionLocal = false
            local isFunctionDefinitionTableSelf = false

            if isFunctionCall then
                local iterator = 0
                while iterator <= 0x80 do
                    iterator = iterator + 1

                    local validA = doesNWTokenMatch(nwTokenIndex - iterator, "IDENTIFIER" , nil)
                    local validB = doesNWTokenMatch(nwTokenIndex - iterator, "PUNCTUATION", ":")
                    local validC = doesNWTokenMatch(nwTokenIndex - iterator, "PUNCTUATION", ".")
                    local validD = doesNWTokenMatch(nwTokenIndex - iterator, "KEYWORD", "function")

                    if not (validA or validB or validC or validD) then
                        break
                    end

                    if validB then
                        isFunctionDefinitionTableSelf = true
                    end

                    if validD then
                        isFunctionDefinitionLocal = doesNWTokenMatch((nwTokenIndex - iterator) - 1, "KEYWORD", "local")
                        isFunctionDefinition = true
                        break
                    end
                end
            end


            if not (isTableIndex or isTableIndex2) and isFunctionDefinition then
                local newColor = colorVariable(tokenValue, false, not (isFunctionDefinitionLocal or isFunctionDefinitionTableSelf), true, false, true, true)

                if isFunctionDefinitionLocal then
                    localVariableSheet[codeDepthIndex - 1][tokenValue] = {
                        index = index,
                        isUsed = false,
                        isFunction = true,
                        cameFromFunctionCall = false
                    }
                else
                    globalVariableSheet[tokenValue] = {
                        index = index,
                        isUsed = false,
                        isFunction = true,
                        cameFromFunctionCall = false
                    }
                end

                local validA = doesNWTokenMatch(nwTokenIndex + 1, "PUNCTUATION", ".")
                local validB = doesNWTokenMatch(nwTokenIndex + 1, "PUNCTUATION", ":")

                outColor = (validA or validB) and nil or newColor
            end

            local isInsideTable = currentIsTableLiteral()
            local isNextAssign = doesNWTokenMatch(nwTokenIndex + 1, "ASSIGN", "=")
            if isInsideTable and isNextAssign then
                outColor = themeTable_indexColor
            end

            if not outColor then
                outColor = "#FF0000"

                local performChecks = true

                local isLocalVariableDefine  = false
                local isGlobalVariableDefine = false
                local isFunctionCall         = false
                local isForloopParam         = false

                do
                    local iterator = 0
                    while iterator <= 0x80 do
                        iterator = iterator + 1

                        local validA = doesNWTokenMatch(nwTokenIndex - iterator, "IDENTIFIER", nil)
                        local validB = doesNWTokenMatch(nwTokenIndex - iterator, "PUNCTUATION", ",")
                        local validC = doesNWTokenMatch(nwTokenIndex - iterator, "KEYWORD", "for")

                        if not (validA or validB or validC) then
                            break
                        end

                        if validC then
                            isForloopParam = true
                            performChecks = false
                            break
                        end
                    end
                end

                if performChecks then
                    local iterator = 0
                    while iterator <= 0x80 do
                        iterator = iterator + 1

                        local validA = doesNWTokenMatch(nwTokenIndex - iterator, "IDENTIFIER", nil)
                        local validB = doesNWTokenMatch(nwTokenIndex - iterator, "PUNCTUATION", ",")
                        local validC = doesNWTokenMatch(nwTokenIndex - iterator, "KEYWORD", "local")

                        if not (validA or validB or validC) then
                            break
                        end

                        if validC then
                            isLocalVariableDefine = true
                            performChecks = false
                            break
                        end
                    end
                end

                if performChecks then
                    local iterator = 0
                    while iterator <= 0x80 do
                        iterator = iterator + 1

                        local validA = doesNWTokenMatch(nwTokenIndex + iterator, "IDENTIFIER", nil)
                        local validB = doesNWTokenMatch(nwTokenIndex + iterator, "PUNCTUATION", ",")
                        local validC = doesNWTokenMatch(nwTokenIndex + iterator, "ASSIGN", "=")

                        if not (validA or validB or validC) then
                            break
                        end

                        if validC then
                            isGlobalVariableDefine = true
                            performChecks = false
                            break
                        end
                    end
                end

                if performChecks then
                    local iterator = 0

                    local couldBeValidFunctionParam = false

                    while iterator <= 0x80 do
                        iterator = iterator + 1

                        local validA      = doesNWTokenMatch(nwTokenIndex - iterator, "IDENTIFIER", nil)
                        local validB      = doesNWTokenMatch(nwTokenIndex - iterator, "PUNCTUATION", ",")
                        local validC      = doesNWTokenMatch(nwTokenIndex - iterator, "PUNCTUATION", "(")
                        local validD      = doesNWTokenMatch(nwTokenIndex - iterator, "KEYWORD", "function")
                        local validIndexA = doesNWTokenMatch(nwTokenIndex - iterator, "PUNCTUATION", ".")
                        local validIndexB = doesNWTokenMatch(nwTokenIndex - iterator, "PUNCTUATION", ":")

                        if not (validA or validB or validC or validD or validIndexA or validIndexB) then
                            break
                        end

                        if validC then
                            couldBeValidFunctionParam = true
                        end

                        if validD and couldBeValidFunctionParam then
                            isFunctionCall = true
                            performChecks = false

                            break
                        end
                    end
                end

                if performChecks then
                    local iterator = 0
                    while iterator <= 0x80 do
                        iterator = iterator + 1

                        local validA = doesNWTokenMatch(nwTokenIndex - iterator, "IDENTIFIER", nil)
                        local validB = doesNWTokenMatch(nwTokenIndex - iterator, "PUNCTUATION", ",")
                        local validC = doesNWTokenMatch(nwTokenIndex - iterator, "KEYWORD", "for")

                        if not (validA or validB or validC) then
                            break
                        end

                        if validC then
                            isForloopParam = true
                            performChecks = false
                            break
                        end
                    end
                end

                local foundVariableExists, foundVariableIsGlobal, foundVariableData, _ = findVariable(tokenValue)
                local canDefine = isLocalVariableDefine or isGlobalVariableDefine

                if foundVariableExists and not foundVariableIsGlobal then
                    canDefine = isLocalVariableDefine
                end

                local isUnderscore = tokenValue == "_"

                if isForloopParam then
                    localVariableSheet[codeDepthIndex][tokenValue] = {
                        index = index,
                        isUsed = isUnderscore,
                        cameFromFunctionCall = false,
                        isFunction = false
                    }

                    outColor = colorVariable(tokenValue, isUnderscore, false, false, false, false, false)
                elseif canDefine then
                    if isLocalVariableDefine then
                        localVariableSheet[codeDepthIndex][tokenValue] = {
                            index = index,
                            isUsed = isUnderscore,
                            cameFromFunctionCall = false,
                            isFunction = false
                        }

                        outColor = colorVariable(tokenValue, isUnderscore, isGlobalVariableDefine, false, false, false, false)
                    else
                        globalVariableSheet[tokenValue] = {
                            index = index,
                            isUsed = true,
                            cameFromFunctionCall = false,
                            isFunction = false
                        }

                        outColor = colorVariable(tokenValue, true, isGlobalVariableDefine, false, false, false, false)
                    end
                elseif isFunctionCall then
                    localVariableSheet[codeDepthIndex][tokenValue] = {
                        index = index,
                        isUsed = isUnderscore,
                        cameFromFunctionCall = true,
                        isFunction = false
                    }

                    outColor = colorVariable(tokenValue, isUnderscore, true, false, false, false, false)
                else
                    if not foundVariableExists then
                        outColor = baseLibraries[tokenValue] and themeVariable_baseLibraryColor or themeVariable_globalColor
                    else
                        local newColor = colorVariable(tokenValue, true, foundVariableData.cameFromFunctionCall or foundVariableIsGlobal, foundVariableData.isFunction, isFunctionCall, false, false)

                        if not foundVariableData.isUsed and foundVariableData.index ~= -1 then
                            local newColorDefine = colorVariable(tokenValue, true, foundVariableData.cameFromFunctionCall or foundVariableIsGlobal, foundVariableData.isFunction, isFunctionCall, true, false)

                            text[foundVariableData.index] = replaceColor(text[foundVariableData.index], newColorDefine)
                        end

                        outColor = newColor

                        foundVariableData.isUsed = true
                    end
                end
            end
        end

        if tokenType == "KEYWORD" then
            local isIncrease = tokenValue == "function" or tokenValue == "for"   or tokenValue == "do"   or tokenValue == "repeat" or tokenValue == "then" or tokenValue == "else"
            local isDecrease = tokenValue == "end"      or tokenValue == "until" or tokenValue == "else" or tokenValue == "elseif"

            if isIncrease and isDecrease then
                localVariableSheet[codeDepthIndex] = {}
            elseif isIncrease then
                codeDepthIndex = codeDepthIndex + 1
                localVariableSheet[codeDepthIndex] = {}
            elseif isDecrease then
                if codeDepthIndex ~= 1 then
                    localVariableSheet[codeDepthIndex] = nil
                    codeDepthIndex = codeDepthIndex - 1
                end
            end

            if tokenValue == "function" then
                local nwTokenIndex = getNWTokenIndex(index)

                local iterator = 0
                while iterator <= 0x80 do
                    iterator = iterator + 1

                    local validA = doesNWTokenMatch(nwTokenIndex + iterator, "IDENTIFIER", nil)
                    local validB = doesNWTokenMatch(nwTokenIndex + iterator, "PUNCTUATION", ".")
                    local validC = doesNWTokenMatch(nwTokenIndex + iterator, "PUNCTUATION", ":")
                    local validD = doesNWTokenMatch(nwTokenIndex + iterator, "KEYWORD", "local")

                    if not (validA or validB or validC or validD) then
                        break
                    end

                    if validC then
                        localVariableSheet[codeDepthIndex]["self"] = {
                            index = -1,
                            isUsed = true,
                            cameFromFunctionCall = false,
                            isFunction = false
                        }

                        break
                    end
                end
            end
        end

        if operands[tokenType] then
            outColor = themeOperands[tokenValue] or themeTextColor

            if tokenValue == "{" or tokenValue == "[" or tokenValue == "(" then
                outColor = themeBracketColors[((bracketLevel - 1) % bracketColorsSize) + 1]
                bracketLevel = bracketLevel + 1
            elseif tokenValue == "}" or tokenValue == "]" or tokenValue == ")" then
                bracketLevel = math_max(0, bracketLevel - 1)
                outColor = themeBracketColors[((bracketLevel - 1) % bracketColorsSize) + 1]
            end
        end

        table_insert(text, outColor .. outValue)
    end

    local function simpleParseToken(outColor, outValue, index, tokenType, tokenValue)
        local outColor = outColor
        local outValue = outValue

        if tokenType == "PUNCTUATION" and bracketsOpen[outValue] or bracketsClose[outValue] then
            outColor = themeBracketColors[1] or outColor
        end

        table_insert(text, outColor .. outValue)
    end

    local func = simpleMode and simpleParseToken or advancedParseToken
    local function parseToken(index, tokenType, tokenValue)
        local outColor = themeTextColor
        local outValue = string_gsub(tokenValue, "#", "##")

        if tokenType == "IDENTIFIER" then
            local nwTokenindex = getNWTokenIndex(index)

            if doesNWTokenMatch(nwTokenindex - 1, "PUNCTUATION", ".") then
                outColor = themeTable_indexColor
            elseif doesNWTokenMatch(nwTokenindex - 1, "PUNCTUATION", ":") then
                outColor = themeTable_callColor
            end
        elseif tokenType == "KEYWORD" then
            outColor = themeKeywords[tokenValue] or themeTextColor
        elseif operands[tokenType] then
            outColor = themeOperands[tokenValue] or themeTextColor
        elseif tokenType == "STRING" then
            outColor = themeStringColor
        elseif tokenType == "NUMBER" then
            outColor = themeNumberColor
        elseif tokenType == "COMMENT" then
            table_insert(text, sm_scrapcomputers_syntax_highlightComment(tokenValue, theme))
            return
        end

        func(outColor, outValue, index, tokenType, tokenValue)
    end

    for tokenIndex, token in ipairs(tokens) do
        local tokenType  = token.type
        local tokenValue = token.value

        if tokenType == "WHITESPACE" then
            table_insert(text, themeTextColor .. tokenValue)
        else
            parseToken(tokenIndex, tokenType, tokenValue)
        end
    end

    for index, token in ipairs(tokens) do
        for i, errorLine in pairs(exceptionLines) do
            if errorLine == token.line then
                text[index] = replaceColor(text[index], i == 1 and themeError_exactError or themeError_referenceError)
            end
        end
    end

    return table_concat(text)
end