-- The SyntaxManager lets you add syntax highlighting to lua code to be showned in a MyGui textbox/editbox
sm.scrapcomputers.syntaxManager = {}

local string_format = string.format
local sm_scrapcomputers_table_mergeLists = sm.scrapcomputers.table.mergeLists
local string_byte = string.byte
local string_sub = string.sub
local tonumber = tonumber
local pairs = pairs
local type = type

local keywords = {
	lua = {
		"false", "nil", "local", "true", "self"
	},

	lua2 = {
		"function", "return", "break", "if", "else", "elseif", "for", "not", "or", "repeat", "until", "while", "in", "end", "and", "then", "do"
	},

	lua3 = {
		"string", "table", "math", "bit", "os"
	},

	operators = {
		"#", "+", "-", "*", "%", "/", "^", "=", "~", "<", ">", ",", ".", ";", ":",
	},

	operators2Open = {
		"(", "{", "[",
	},

	operators2Close = {
		")", "}", "]",
	},

	espaceCodes = {
		"\\a", "\\b", "\\f", "\\n", "\\r", "\\t", "\\v", "\\z", "\\\"", "\\\'",
		"⁄a", "⁄b", "⁄f", "⁄n", "⁄r", "⁄t", "⁄v", "⁄z", "⁄\"", "⁄\'",
	},

	luaAnnotations = {
		["@class"] = {"text"},
		["@type"] = {"localProperty"},
		["@param"] = {"text", "localProperty"},
		["@return"] = {"localProperty", "text"},
		["@field"] = {"text", "localProperty"},
		["@generic"] = {"luaAnnotation"},
		["@vararg"] = {"localProperty"},
		["@deprecated"] = {},
		["@meta"] = {"localProperty"},
		["@see"] = {"localProperty"},
		["@async"] = {},
		["@nodiscard"] = {},
		["@enum"] = {"text"},
		["@package"] = {},
		["@protected"] = {},
	}
}

local function generateNumberEscapeCodes()
	local function generateList(leadingCharacter)
		local output = {}

		for number = 0, 255 do
			output[number + 1] = string_format("%sx%02X", leadingCharacter, number)
		end

		return output
	end

	keywords.espaceCodes = sm_scrapcomputers_table_mergeLists(keywords.espaceCodes, generateList("\\"))
	keywords.espaceCodes = sm_scrapcomputers_table_mergeLists(keywords.espaceCodes, generateList("⁄"))
end
generateNumberEscapeCodes()

-- Define a table for colors
local colors = {
	textColor          = "#9CDCFE",
	errorColor         = "#E74856",
	darkErrorColor     = "#9e333c",
	keywordColor       = "#569CCB",
	numberColor        = "#B5CEA8",
	stringColor        = "#CE9178",
	luaColor           = "#569CCB",
	callColor          = "#DCCE81",
	localPropertyColor = "#3BC9B0",
	functionColor      = "#C586C0",
	commentColor       = "#5E9955",
	operatorColor      = "#D4D4D4",
	escapeCodeColor    = "#D7BA7D",
	luaAnnotationColor = "#569CCB",

	operator2Colors = {
		"#FFD700",
		"#DA70D6",
		"#179FFF"
	}
}

local pairs = pairs
local table_concat = table.concat
local type = type
local math_max = math.max
local sm_scrapcomputers_errorHandler_assertArgument = sm.scrapcomputers.errorHandler.assertArgument

local function createKeywordSet(keywords)
	local keywordSet = {}
	for _, keyword in pairs(keywords) do
		keywordSet[keyword] = true
	end
	return keywordSet
end

local luaSet = createKeywordSet(keywords.lua)
local lua2Set = createKeywordSet(keywords.lua2)
local lua3Set = createKeywordSet(keywords.lua3)

local operatorsSet = createKeywordSet(keywords.operators)
local operators2SetOpen = createKeywordSet(keywords.operators2Open)
local operators2SetClose = createKeywordSet(keywords.operators2Close)

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

local function removeEmptyValuesAndIndexConversion(tbl)
    local newTable, indexMap, newCount = {}, {}, 0

    for i, v in pairs(tbl) do
        if v ~= "" and not v:find("^%s*$") then
            newCount = newCount + 1
            newTable[newCount] = v
            indexMap[i] = newCount
        end
    end

    return newTable, indexMap
end

local function splitStringBySpaces(input)
	local resultIndex = 1
	local result = {}
	local word = ""
	local index = 1

	while index <= #input do
		local char = getUTF8Character(input, index)
		if char:match("%s") then
			if #word > 0 then
				resultIndex = resultIndex + 1
				result[resultIndex] = word
				word = ""
			end
		else
			word = word .. char
		end
		index = index + #char
	end

	if #word > 0 then
		result[resultIndex + 1] = word
	end

	return result
end

---@param tokens string[]
---@param index integer
---@param data table
---@return string?
---@return string?
local function getHighlight(tokens, index, data, actualTokens, actualTokensIndexMap)
	local actualTokensIndex = actualTokensIndexMap[index]
	local token = tokens[index]:gsub("⁄", "\\")

	if tonumber(token) then
		return colors.numberColor
	elseif token:sub(1, 2) == "--" then
		local isFunctionComment = token:sub(1, 3) == "---"

		if isFunctionComment then
			local newText = token:gsub("#", "##")
			local newTextClone = newText

			for annotation, annotationData in pairs(keywords.luaAnnotations) do
				local annotation = annotation .. " "
				local tokenLocation = token:find(annotation)

				if tokenLocation then
					local previousText = newText:sub(1, tokenLocation - 1)
					newText = newText:sub(tokenLocation + #annotation)
					local startingText = previousText .. colors.luaAnnotationColor .. annotation

					local splittedString = splitStringBySpaces(newText)
					local output = {}
					for index, word in pairs(splittedString) do
						local color = annotationData[index]
						if color then
							local actualColor = colors[color .. "Color"]
							if type(actualColor) == "string" then
								output[#output+1] = actualColor .. word
							else
								output[#output+1] = word
							end
						else
							output[#output+1] = word
						end

						if index == #annotationData then
							output[#output] = output[#output] .. colors.commentColor
						end
					end

					newText = startingText .. colors.commentColor .. table_concat(output, " ")
				end
			end

			local lastCharacter = newTextClone:sub(#newTextClone)
			if lastCharacter == " " or lastCharacter == "\t" then
				newText = newText .. lastCharacter
			end

			if data.tokenOperatorLevel > 0 then
				newText = newText .. colors.localPropertyColor
			elseif actualTokens[actualTokensIndex + 3] == "function" then
				newText = newText .. colors.callColor
			else
				newText = newText .. colors.textColor
			end

			return colors.commentColor, colors.commentColor .. newText
		end

		return colors.commentColor
	elseif operatorsSet[token] then
		return colors.operatorColor
	elseif operators2SetOpen[token] then
		data.tokenOperatorLevel = data.tokenOperatorLevel + 1
		if token == "{" or token == "[" then
			data.tableTokenOperatorLevel = data.tableTokenOperatorLevel + 1
		end
		local selectedColor = colors.operator2Colors[(data.tokenOperatorLevel - 1) % #colors.operator2Colors + 1]
		return selectedColor
	elseif operators2SetClose[token] then
		data.tokenOperatorLevel = math_max(data.tokenOperatorLevel - 1, 0)
		if token == "}" or token == "]" then
			data.tableTokenOperatorLevel = math_max(data.tableTokenOperatorLevel - 1, 0)
		end

		local selectedColor = colors.operator2Colors[data.tokenOperatorLevel % #colors.operator2Colors + 1]
		
		return selectedColor
	elseif luaSet[token] then
		return colors.luaColor
	elseif lua2Set[token] then
		if token == "function" then
			data.functionLevel = data.functionLevel + 1
		elseif token == "end" then
			data.functionLevel = data.functionLevel - 1
		end

		return colors.functionColor
	elseif lua3Set[token] then
		return colors.callColor
	elseif token:sub(1, 1) == "\"" or token:sub(1, 1) == "\'" then
		return colors.stringColor
	elseif token == "true" or token == "false" then
		return colors.keywordColor
	end

	if tokens[index + 1] == "(" then
		if tokens[index - 1] == ":" then
			return colors.callColor
		end
		return colors.callColor
	end

	
	if actualTokensIndex then
		if actualTokens[actualTokensIndex + 2] == "function" and (data.tableTokenOperatorLevel - data.functionLevel) > 0 then
			return colors.callColor
		end

		if actualTokens[actualTokensIndex - 1] == "." and actualTokens[actualTokensIndex - 2] ~= "." then
			return colors.localPropertyColor
		end

		if data.tableTokenOperatorLevel > 0 then
			if data.functionLevel == 0 then
				local previousTrueToken = actualTokensIndex and actualTokens[actualTokensIndex - 1] or -1
				if previousTrueToken == "{" or previousTrueToken == "," then
					return colors.localPropertyColor
				end
			end
		end
	end
end


---Adds syntax highlighting to the source and returns it. You can also mark exceptionLines, The first one is where the actual error happened and the rest are code that leads to that error. If you dont want that, set it to a empty table
---@param source string The source to highlight
---@param exceptionLines integer[] Lines where the exceptions happened
---@return string code The highlighted code
function sm.scrapcomputers.syntaxManager.highlightCode(source, exceptionLines)
	sm_scrapcomputers_errorHandler_assertArgument(source, 1, {"string"})
	sm_scrapcomputers_errorHandler_assertArgument(exceptionLines, 2, {"table"}, {"integer[]"})

	local data = { tokenOperatorLevel = 0, tableTokenOperatorLevel = 0, functionLevel = 0 }

	local tokens = {}
	local tokensIndex = 0
	local currentToken = ""
	
	---@type string|boolean
	local inString = false
	local inComment = false
	local commentPersist = false

	local i = 1
	while i <= #source do
		local character = getUTF8Character(source, i)
		
		if inComment then
			if character == "\n" and not commentPersist then
				tokens[tokensIndex + 1] = currentToken
				tokens[tokensIndex + 2] = character
				tokensIndex = tokensIndex + 2
				
				currentToken = ""
				
				inComment = false
			elseif source:sub(i - 1, i) == "]]" and commentPersist then
				currentToken = currentToken .. "]"
				
				tokensIndex = tokensIndex + 1
				tokens[tokensIndex] = currentToken
				currentToken = ""
				
				inComment = false
				commentPersist = false
			else
				currentToken = currentToken .. character
			end
		elseif inString then
			currentToken = currentToken .. character
			if character == inString and source:sub(i-1, i-1) ~= "\\" and source:sub(i-3, i-1) ~= "⁄" or character == "\n" then
				inString = false
			end
		else
			if source:sub(i, i + 1) == "--" then
				tokensIndex = tokensIndex + 1
				tokens[tokensIndex] = currentToken

				currentToken = "-"
				inComment = true
				commentPersist = source:sub(i + 2, i + 3) == "[["
			elseif character == "\"" or character == "\'" then
				tokensIndex = tokensIndex + 1
				tokens[tokensIndex] = currentToken

				currentToken = character
				inString = character
			elseif operatorsSet[character] then
				tokens[tokensIndex + 1] = currentToken
				tokens[tokensIndex + 2] = character
				tokensIndex = tokensIndex + 2

				currentToken = ""
			elseif character:match("[%w_]") then
				currentToken = currentToken .. character
			else
				tokens[tokensIndex + 1] = currentToken
				tokens[tokensIndex + 2] = character
				tokensIndex = tokensIndex + 2

				currentToken = ""
			end
		end

		i = i + #character
	end
	
	tokens[tokensIndex + 1] = currentToken
	
	local highlighted = {}
	local actualTokens, actualTokensIndexMap = removeEmptyValuesAndIndexConversion(tokens)

	local colors_textColor = colors.textColor
	local characterIndex = 1

	for i, token in pairs(tokens) do
		local highlight, textOverwrite = getHighlight(tokens, i, data, actualTokens, actualTokensIndexMap)
		characterIndex = characterIndex + #token

		if highlight then
			local newToken = token:gsub("#", "##")
			local syntax = colors_textColor .. highlight .. newToken .. colors_textColor

			if not textOverwrite then
				if ((newToken:sub(1, 1) == "\"" or newToken:sub(1, 1) == "\'") and (newToken:sub(-1, -1) == "\"" or newToken:sub(-1, -1) == "\'")) then
					local outputSyntax = syntax
		
					for _, escapeCode in pairs(keywords.espaceCodes) do
						outputSyntax = outputSyntax:gsub(escapeCode, colors.escapeCodeColor .. escapeCode .. highlight)
					end
		
					syntax = outputSyntax
				end

				highlighted[#highlighted+1] = syntax
			else
				highlighted[#highlighted+1] = textOverwrite
			end
		else
			highlighted[#highlighted+1] = token
		end
	end

	local concattedString = table_concat(highlighted)
	local errorLines = {}

	if #exceptionLines > 0 then
		local index = 1

		for line in source:gmatch("([^\n]*)\n?") do
			for _, exceptionLine in pairs(exceptionLines) do
				if index == tonumber(exceptionLine) then
					local text = line:gsub("#", "##")
					errorLines[index] = text
					break
				end
			end
			index = index + 1
		end
	end

	
	local lines = {}
	local index = 1
	for line in concattedString:gmatch("([^\n]*)\n?") do
		local isErrorLine = false
		local isDarkened = false

		for index2, exceptionLine in pairs(exceptionLines) do
			if index == tonumber(exceptionLine) then
				isDarkened = index2 ~= 1
				isErrorLine = true
				break
			end
		end

		if isErrorLine then
			local color = isDarkened and colors.darkErrorColor or colors.errorColor
			lines[index] = color .. errorLines[index] .. colors.textColor
		else
			lines[index] = line
		end
		index = index + 1
	end

	if source:sub(-1, -1) ~= "\n" and lines[#lines] then
		table.remove(lines, #lines)
	end

	return colors.textColor .. table_concat(lines, "\n")
end
