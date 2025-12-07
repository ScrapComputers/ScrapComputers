ErrorParser = {}

---@class ErrorParser.ErrorData
---@field isParserError boolean If its a parser error.
---@field isRuntimeError boolean If its a runtime error.
---@field message string The error message itself
---@field messageNoNewlines string The error message itself but without any new lines
---@field origin ErrorParser.ErrorData.FileLine? (Parser) The origin file
---@field source ErrorParser.ErrorData.FileLine? (Parser) The source file
---@field traceback ErrorParser.ErrorData.TracebackLog[] (Runtime) The traceback

---@class ErrorParser.ErrorData.FileLine
---@field file string The file path
---@field line integer The line where the error happened

---@class ErrorParser.ErrorData.TracebackLog
---@field path string The file path of the traceback
---@field line integer The line of the traceback
---@field isComputerFile boolean If its a file from the computer
---@field isLBI boolean If its a file from the LBI


---Parses the error message and returns information out of it
---@param err string The error message
---@return ErrorParser.ErrorData
function ErrorParser:parseError(err)
    local tracePart, errMsg = err:match("^(.*):%s(.+)$")
    if not tracePart or not errMsg then
        return {
            isParserError = false,
            isRuntimeError = false,
            message = err,
            messageNoNewlines = err
        }
    end

    tracePart = tracePart .. ":"

    ---@type ErrorParser.ErrorData.TracebackLog[]
    local traceback = {}
    for path, line in tracePart:gmatch('%[path "(.-)"%]%:(%d+)%:') do
        local isComputerFile = path:sub(1, 1) == "/"

        table.insert(traceback, 1, {
            path = path,
            line = tonumber(line),
            isComputerFile = isComputerFile,
            isLBI = (path:sub(#path - 6) == "LBI.lua" and not isComputerFile)
        })
    end

    -- These are all yueliang files which do parsing. See if one of them is in traceback and if so, that
    -- means its a parser error
    local matches = {
        "Scripts/Computer/LuaVM/LuaK.lua",
        "Scripts/Computer/LuaVM/LuaP.lua",
        "Scripts/Computer/LuaVM/LuaU.lua",
        "Scripts/Computer/LuaVM/LuaX.lua",
        "Scripts/Computer/LuaVM/LuaY.lua",
        "Scripts/Computer/LuaVM/LuaZ.lua"
    }

    local isParserError = false
    for _, trace in pairs(traceback) do
        for _, match in pairs(matches) do
            if trace.path:sub(#trace.path - #match + 1) == match then
                isParserError = true
                break
            end
        end
    end

    local errorFile = traceback[1] or { path = "<Unknown>", line = 0}
    for _, tracebackLog in pairs(traceback) do
        if tracebackLog.isComputerFile then
            errorFile = tracebackLog
            
            if errMsg:sub(1,1) == " " then
                errMsg = errMsg:sub(2)
            end
            
            break
        end
    end

    errMsg = errMsg:gsub("\r?\n$", "") -- Remove ending new line
    
    local noNewLinesErrMsg = errMsg:gsub("\r?\n", "")

    return {
        isParserError = isParserError,
        isRuntimeError = not isParserError,
        traceback = traceback,
        message = errMsg,
        messageNoNewlines = noNewLinesErrMsg,

        source = {
            file = errorFile.path,
            line = errorFile.line
        }
    }
end

---Generates a formatted error message
---@param data ErrorParser.ErrorData
---@return string msg the formatted message
function ErrorParser:generateError(data)
    local dataMessage = data.message:gsub("#", "##")

    if data.isParserError then
        return "#e74856ERROR: On parsing: " .. data.source.file .. ":" .. tostring(data.source.line) .. ": " .. dataMessage
    end

    if not data.isRuntimeError then
        return "#e74856ERROR: " .. dataMessage
    end

    local errorFile = data.traceback[1] and (data.traceback[1].path .. ":" .. data.traceback[1].line .. ":") or "<Unknown>:?:"

    for _, tracebackLog in pairs(data.traceback) do
        if tracebackLog.isComputerFile then
            errorFile = tracebackLog.path .. ":" .. tostring(tracebackLog.line) .. ":"
            break
        end
    end

    local text = "#e74856ERROR:  " .. errorFile .. " " .. dataMessage .. "\n#f9f1a5----- Lua Error Traceback -----"

    for _, tracebackLog in pairs(data.traceback) do
        text = text .. "\n\t"

        if tracebackLog.isComputerFile then
            text = text .. "[LuaVM]: "
        elseif tracebackLog.isLBI then
            text = text .. "[LBI]: "
        end

        text = text .. tracebackLog.path .. ":" .. tostring(tracebackLog.line) .. ":"
    end

    return text
end

---Parses and generates to a formatted error message
---@param err string The error message
---@return string msg the formatted message
function ErrorParser:parseAndGenError(err)
    return self:generateError(self:parseError(err))
end

---Fixes weird formatting with some error messages
---@param err string The error message
---@return string err The fixed error message
function ErrorParser:fixErrorMessage(err)
    local errMsg = err

    local cleanedMsg
    repeat
        cleanedMsg = errMsg
        errMsg = errMsg:gsub('%[string "(.-)"%]:(%d+):', '[path "%1"]:%2: ')
    until errMsg == cleanedMsg

    return errMsg
end

---Generates a short formatted error message
---@param data ErrorParser.ErrorData
---@return string msg the formatted message
function ErrorParser:genShortErr(data)
    local dataMessage = data.messageNoNewlines:gsub("#", "##")

    if data.isParserError then
        return "#e74856ERROR: On parsing: " .. data.source.file .. ":" .. tostring(data.source.line) .. ": " .. dataMessage
    end

    if not data.isRuntimeError then
        return "#e74856ERROR: " .. dataMessage
    end

    local errorFile = data.traceback[1] and data.traceback[1].path or "<Unknown>:?:"

    for _, tracebackLog in pairs(data.traceback) do
        if tracebackLog.isComputerFile then
            errorFile = tracebackLog.path .. ":" .. tostring(tracebackLog.line) .. ":"
            break
        end
    end
    
    return "#e74856ERROR: " .. errorFile .. " " .. dataMessage
end

---Parses and generates to a short formatted error message
---@param err string The error message
---@return string msg the formatted message
function ErrorParser:parseAndGenShortErr(err)
    return self:genShortErr(self:parseError(err))
end