-- The SyntaxManager lets you add syntax highlighting to lua code to be showned in a MyGui textbox/editbox
sm.scrapcomputers.syntaxManager = {}

local keywords = {
	lua = {
		"false", "nil", "local", "true",
	},

    lua2 = {
        "function", "return", "break", "if", "else", "elseif", "for", "not", "or", "repeat", "until", "while", "in", "end", "and", "then", "do"
    },

	operators = {
		"#", "+", "-", "*", "%", "/", "^", "=", "~", "<", ">", ",", ".", ";", ":",
	},

    operators2 = {
        "(", ")", "{", "}", "[", "]",
    },

    espaceCodes = {
        "\\a", "\\b", "\\f", "\\n", "\\r", "\\t", "\\v", "\\z",
        "⁄a" , "⁄b" , "⁄f" , "⁄n" , "⁄r" , "⁄t" , "⁄v" , "⁄z" ,
    }
}

local textColor          = "#9CDCFE"
local errorColor         = "#E74856"
local darkErrorColor     = "#9e333c"

local keywordColor       = "#569CCB"
local numberColor        = "#B5CEA8"
local stringColor        = "#CE9178"
local luaColor           = "#569CCB"
local callColor          = "#DCCE81"
local localPropertyColor = "#3BC9B0"
local functionColor      = "#C586C0"
local commentColor       = "#5E9955"
local opeartorColor      = "#D4D4D4"
local escapeCodeColor    = "#D7BA7D"

local function createKeywordSet(keywords)
	local keywordSet = {}
	for _, keyword in ipairs(keywords) do
		keywordSet[keyword] = true
	end
	return keywordSet
end

local luaSet = createKeywordSet(keywords.lua)
local lua2Set = createKeywordSet(keywords.lua2)
local operatorsSet = createKeywordSet(keywords.operators)
local operators2Set = createKeywordSet(keywords.operators2)

local function getHighlight(tokens, index)
	local token = tokens[index]
	if tonumber(token) then
		return numberColor
	elseif token:sub(1, 2) == "--" then
        return commentColor
	elseif operatorsSet[token] then
		return opeartorColor
    elseif operators2Set[token] then
        return keywordColor
    elseif luaSet[token] then
		return luaColor
	elseif lua2Set[token] then
		return functionColor
	elseif token:sub(1, 1) == "\"" or token:sub(1, 1) == "\'" then
		return stringColor
	elseif token == "true" or token == "false" then
		return keywordColor
	end

	if tokens[index + 1] == "(" then
		if tokens[index - 1] == ":" then
			return callColor
		end

		return callColor
	end

	if tokens[index - 1] == "." then
		return localPropertyColor
	end
end

---Adds syntax highlighting to the source and returns it. You can also mark exceptionLines, The first one is where the actual error happened and the rest are code that leads to that error. If you dont want that, set it to a empty table
---@param source string The source to highlight
---@param exceptionLines integer[] Lines where the exceptions happened
---@return string code The highlighted code
function sm.scrapcomputers.syntaxManager.highlightCode(source, exceptionLines)
	sm.scrapcomputers.errorHandler.assertArgument(source, 1, {"string"})
	sm.scrapcomputers.errorHandler.assertArgument(exceptionLines, 2, {"table"}, {"integer[]"})

    local tokens = {}
	local currentToken = ""
	
	---@type string|boolean
	local inString = false
	local inComment = false
	local commentPersist = false
	
	for i = 1, #source do
		local character = source:sub(i, i)
		
		if inComment then
			if character == "\n" and not commentPersist then
				table.insert(tokens, currentToken)
				table.insert(tokens, character)
				currentToken = ""
				
				inComment = false
			elseif source:sub(i - 1, i) == "]]" and commentPersist then
				currentToken = currentToken .. "]"
				
				table.insert(tokens, currentToken)
				currentToken = ""
				
				inComment = false
				commentPersist = false
			else
				currentToken = currentToken .. character
			end
		elseif inString then
			if character == inString and source:sub(i-1, i-1) ~= "\\" or character == "\n" then
				currentToken = currentToken .. character
				inString = false
			else
				currentToken = currentToken .. character
			end
		else
			if source:sub(i, i + 1) == "--" then
				table.insert(tokens, currentToken)
				currentToken = "-"
				inComment = true
				commentPersist = source:sub(i + 2, i + 3) == "[["
			elseif character == "\"" or character == "\'" then
				table.insert(tokens, currentToken)
				currentToken = character
				inString = character
			elseif operatorsSet[character] then
				table.insert(tokens, currentToken)
				table.insert(tokens, character)
				currentToken = ""
			elseif character:match("[%w_]") then
				currentToken = currentToken .. character
			else
				table.insert(tokens, currentToken)
				table.insert(tokens, character)
				currentToken = ""
			end
		end
	end
	
	table.insert(tokens, currentToken)

	local highlighted = {}
	
	for i, token in ipairs(tokens) do
		local highlight = getHighlight(tokens, i)

		if highlight then
            token = token == "#" and "##" or token

			local syntax = textColor .. highlight .. token .. textColor
			if ((token:sub(1, 1) == "\"" or token:sub(1, 1) == "\'") and (token:sub(-1, -1) == "\"" or token:sub(-1, -1) == "\'")) then
                local outputSyntax = syntax

                for index, escapeCode in pairs(keywords.espaceCodes) do
                    outputSyntax = outputSyntax:gsub(escapeCode, escapeCodeColor .. escapeCode .. highlight)
                end

                syntax = outputSyntax
            end
			table.insert(highlighted, syntax)
		else
			table.insert(highlighted, token)
		end
	end

	local concattedString = table.concat(highlighted)
    local lines = {}
    local errorLines = {}

    if #exceptionLines > 0 then
        local index = 1

        for line in source:gmatch("([^\n]*)\n?") do
            for _, exceptionLine in pairs(exceptionLines) do
                if index == tonumber(exceptionLine) then
                    table.insert(errorLines, index, line)
                    break
                end
            end
            index = index + 1
        end
    end

    local index = 1
    for line in concattedString:gmatch("([^\n]*)\n?") do
        local isErrorLine = false
        local isDarkened = false

        for index2, exceptionLine in pairs(exceptionLines) do
            if index == tonumber(exceptionLine) then
                isDarkened = index2 == 1
                isErrorLine = true
                break
            end
        end

        if isErrorLine then
            if isDarkened then
                table.insert(lines, errorColor .. errorLines[index] .. textColor)
            else
                table.insert(lines, darkErrorColor .. errorLines[index] .. textColor)
            end
        else
            table.insert(lines, line)
        end
        index = index + 1
    end

    if source:sub(-1, -1) ~= "\n" and lines[#lines] then
        table.remove(lines, #lines)
    end

    return textColor .. table.concat(lines, "\n")
end
