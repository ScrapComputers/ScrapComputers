local string_format = string.format
local string_match  = string.match
local string_byte   = string.byte
local string_find   = string.find
local string_sub    = string.sub

local luaKeywords = {
    ["and"]      = true, ["break"]  = true, ["do"]    = true, ["else"]   = true,
    ["elseif"]   = true, ["end"]    = true, ["false"] = true, ["for"]    = true,
    ["function"] = true, ["if"]     = true, ["in"]    = true, ["local"]  = true,
    ["nil"]      = true, ["not"]    = true, ["or"]    = true, ["repeat"] = true,
    ["return"]   = true, ["then"]   = true, ["true"]  = true, ["until"]  = true,
    ["while"]  = true
}

local function getUtf8CharacterLength(firstByte)
    if firstByte < 0x80 then
        return 1
    elseif firstByte < 0xE0 then
        return 2
    elseif firstByte < 0xF0 then
        return 3
    else
        return 4
    end
end

local function getNextUtf8Index(inputString, currentIndex)
    local firstByte = string_byte(inputString, currentIndex)
    if not firstByte then
        return nil
    end
    return currentIndex, getUtf8CharacterLength(firstByte)
end

local function isUtf8Letter(byte)
    return (byte >= 65 and byte <= 90) or (byte >= 97 and byte <= 122) or byte >= 0xC2
end

local function isUtf8Digit(byte)
    return byte >= 48 and byte <= 57
end

local function matchLongBracketString(inputString, startIndex)
    local equalsSequence = string_match(inputString, "^%[(=*)%[", startIndex)
    if not equalsSequence then
        return nil
    end

    local openingBracket = "[" .. equalsSequence .. "["
    local closingBracket = "]" .. equalsSequence .. "]"
    local closingPattern = "(.-)" .. closingBracket

    local content, _ = string_match(inputString, closingPattern, startIndex + #openingBracket)
    if content then
        local fullString = openingBracket .. content .. closingBracket
        return fullString, startIndex + #fullString - 1
    else
        return string_sub(inputString, startIndex), #inputString
    end
end

local function matchShortQuotedString(inputString, startIndex)
    local openingQuote = string_sub(inputString, startIndex, startIndex)
    local currentIndex = startIndex + 1

    while currentIndex <= #inputString do
        local currentChar = string_sub(inputString, currentIndex, currentIndex)
        if currentChar == "\\" then
            local nextChar = string_sub(inputString, currentIndex + 1, currentIndex + 1)
            if nextChar == "u" and string_sub(inputString, currentIndex + 2, currentIndex + 2) == "{" then
                local closingBraceIndex = string_find(inputString, "}", currentIndex + 3)
                if not closingBraceIndex then
                    return string_sub(inputString, startIndex), #inputString
                end

                currentIndex = closingBraceIndex + 1
            elseif nextChar == "x" then
                currentIndex = currentIndex + 4
            elseif nextChar == "z" then
                local whitespaceSequence = string_match(inputString, "^%s*", currentIndex)
                currentIndex = currentIndex + #whitespaceSequence + 2
            else
                currentIndex = currentIndex + 2
            end
        elseif currentChar == openingQuote then
            return string_sub(inputString, startIndex, currentIndex), currentIndex
        else
            currentIndex = currentIndex + 1
        end
    end

    return string_sub(inputString, startIndex), #inputString
end

local simpleTokenPatterns = {
    { "NUMBER",           "^0[xX][%da-fA-F]+%.[%da-fA-F]*[pP][+-]?%d+" },
    { "NUMBER",           "^0[xX][%da-fA-F]+[pP][+-]?%d+"              },
    { "NUMBER",           "^0[xX][%da-fA-F]+%.[%da-fA-F]*"             },
    { "NUMBER",           "^0[xX][%da-fA-F]+"                          },
    { "NUMBER",           "^%d+%.%d*[eE][+-]?%d+"                      },
    { "NUMBER",           "^%d+%.%d*"                                  },
    { "NUMBER",           "^%d+[eE][+-]?%d+"                           },
    { "NUMBER",           "^%d+"                                       },

    { "ELLIPSIS",         "^%.%.%."                                    },
    { "CONCAT",           "^%.%."                                      },
    { "LE",               "^<="                                        },
    { "GE",               "^>="                                        },
    { "EQ",               "^=="                                        },
    { "NEQ",              "^~="                                        },
    
    { "OPERATOR",         "^%+"                                        },
    { "OPERATOR",         "^%-"                                        },
    { "OPERATOR",         "^%*"                                        },
    { "OPERATOR",         "^/"                                         },
    { "OPERATOR",         "^%%"                                        },
    { "OPERATOR",         "^%^"                                        },
    { "OPERATOR",         "^#"                                         },

    { "ASSIGN",           "^="                                         },
    { "LT",               "^<"                                         },
    { "GT",               "^>"                                         },

    { "PUNCTUATION",      "^[%(%)%[%]%{%}%.,;:]"                       },

    { "NEWLINE",          "^\r?\n"                                     },
    { "WHITESPACE",       "^%s+"                                       },
}

function sm.scrapcomputers.syntax.tokenize(inputString)
    local tokens = {}
    local currentLine = 1
    local currentIndex = 1
    local inputLength = #inputString

    local function countNewlines(s)
        local _, count = string.gsub(s, "\n", "")
        return count
    end

    while currentIndex <= inputLength do
        local remainingString = string_sub(inputString, currentIndex)
        local matchedToken = false

        -- Long bracket comment
        if string_match(remainingString, "^%-%-%[=*%[") then
            local commentContent, _ = matchLongBracketString(inputString, currentIndex + 2)
            tokens[#tokens + 1] = {
                type = "COMMENT",
                value = "--" .. commentContent,
                line = currentLine
            }

            currentLine = currentLine + countNewlines(commentContent)
            currentIndex = currentIndex + #commentContent + 2
            matchedToken = true
        -- Long bracket string
        elseif string_match(remainingString, "^%[=*%[") then
            local stringContent, stringEndIndex = matchLongBracketString(inputString, currentIndex)
            tokens[#tokens + 1] = {
                type = "STRING",
                value = stringContent,
                line = currentLine
            }

            currentLine = currentLine + countNewlines(stringContent)
            currentIndex = stringEndIndex + 1
            matchedToken = true
        -- Single-line comment
        elseif string_match(remainingString, "^%-%-") then
            local _, endPosition = string_find(remainingString, "^[^\n]*")
            local commentContent = string_sub(remainingString, 1, endPosition)
            tokens[#tokens + 1] = {
                type = "COMMENT",
                value = commentContent,
                line = currentLine
            }

            -- Single-line comment does not advance lines unless it has newline
            currentLine = currentLine + countNewlines(commentContent)
            currentIndex = currentIndex + #commentContent
            matchedToken = true
        -- Short quoted string
        elseif string_match(remainingString, "^[\"']") then
            local stringContent, stringEndIndex = matchShortQuotedString(inputString, currentIndex)
            tokens[#tokens + 1] = {
                type = "STRING",
                value = stringContent,
                line = currentLine
            }

            currentLine = currentLine + countNewlines(stringContent)
            currentIndex = stringEndIndex + 1
            matchedToken = true
        -- Identifier or keyword
        else
            local currentByte = string_byte(inputString, currentIndex)
            if currentByte and (isUtf8Letter(currentByte) or currentByte == 95) then
                local identifierEndIndex = currentIndex
                while identifierEndIndex <= inputLength do
                    local nextByte = string_byte(inputString, identifierEndIndex)
                    if not nextByte then
                        break
                    end

                    if isUtf8Letter(nextByte) or isUtf8Digit(nextByte) or nextByte == 95 then
                        identifierEndIndex = identifierEndIndex + select(2, getNextUtf8Index(inputString, identifierEndIndex))
                    else
                        break
                    end
                end

                local identifierValue = string_sub(inputString, currentIndex, identifierEndIndex - 1)
                local tokenType = luaKeywords[identifierValue] and "KEYWORD" or "IDENTIFIER"
                tokens[#tokens + 1] = {
                    type = tokenType,
                    value = identifierValue,
                    line = currentLine
                }

                currentIndex = identifierEndIndex
                matchedToken = true
            end
        end

        -- Simple token patterns
        if not matchedToken then
            for _, tokenPattern in ipairs(simpleTokenPatterns) do
                local tokenType, pattern = tokenPattern[1], tokenPattern[2]
                local startPosition, endPosition = string_find(remainingString, pattern)
                if startPosition then
                    local matchedValue = string_sub(remainingString, startPosition, endPosition)
                    if tokenType == "NEWLINE" then
                        tokens[#tokens + 1] = {
                            type = tokenType,
                            value = matchedValue,
                            line = currentLine
                        }

                        currentLine = currentLine + 1
                    else
                        -- Calculate newlines inside whitespace
                        if tokenType == "WHITESPACE" then
                            currentLine = currentLine + countNewlines(matchedValue)
                        end
                        
                        tokens[#tokens + 1] = {
                            type = tokenType,
                            value = matchedValue,
                            line = currentLine
                        }
                    end

                    currentIndex = currentIndex + #matchedValue
                    matchedToken = true
                    break
                end
            end
        end

        if not matchedToken then
            tokens[#tokens+1] = {
                type = "UNKNOWN",
                value = remainingString:sub(1, 1),
                line = currentLine
            }

            currentIndex = currentIndex + 1
        end
    end

    return tokens
end
