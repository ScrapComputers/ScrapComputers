---@class Computer.LuaVM
LuaVM = LuaVM or {}

dofile("LuaZ.lua")
dofile("LuaX.lua")
dofile("LuaP.lua")
dofile("LuaK.lua")
dofile("LuaY.lua")
dofile("LuaU.lua")

dofile("LBI.lua")

LuaVM.luaX:init()

local function loadString(str, env, filePath, vmLuaState, release)    
    local internalLuaState = {}
    local func, writer, buff

    local function loadStringInternal()
        local zio = LuaVM.luaZ:init(LuaVM.luaZ:make_getS(str), nil )
        if not zio then return error("LuaZ Failure!") end

        local parserFunc = LuaVM.luaY:parser(internalLuaState, zio, nil, filePath)
        writer, buff = LuaVM.luaU:make_setS()
        
        LuaVM.luaU:dump(internalLuaState, parserFunc, writer, buff, release)

        local state = LuaVM.LBI.bc_to_state(buff.data)
        func = LuaVM.LBI.wrap_state(state, env, nil, vmLuaState)
    end

    local success, errorMessage = pcall(loadStringInternal)

    if success then
        return func, buff.data
    end

    errorMessage = ErrorParser:fixErrorMessage(errorMessage)
    return nil, errorMessage
end

local function loadStringBytecode(str, env, vmLuaState)
    local func

    local function loadStringInternal()
        local state = LuaVM.LBI.bc_to_state(str)
        func = LuaVM.LBI.wrap_state(state, env, nil, vmLuaState)
    end

    local success, errorMessage = pcall(loadStringInternal)

    if success then
        return func, str
    end

    errorMessage = ErrorParser:fixErrorMessage(errorMessage)
    return nil, errorMessage
end

---@return self
function LuaVM:init(mainCodeFS, byteCodeFS, requestBCSyncFunc, classInstance)
    ---@type Computer.LuaVM
    local data = sm.scrapcomputers.table.merge(self, {
        mainCodeFS = mainCodeFS,
        byteCodeFS = byteCodeFS,
        requestBCSyncFunc = requestBCSyncFunc,
        classInstance = classInstance,
        pendingConsoleLogs = {}
    })
    data:reset()

    return data
end

function LuaVM:readPendingConsoleLogs()
    if #self.pendingConsoleLogs == 0 then
        return {}
    end

    local tbl = self.pendingConsoleLogs
    self.pendingConsoleLogs = {}

    return tbl
end

function LuaVM:enableDebugInfo(debugInfoEnabled)
    self.debugInfoEnabled = debugInfoEnabled
end

function LuaVM:resyncFilesystems(mainCodeFS, byteCodeFS, encrypted, password)
    self.mainCodeFS = mainCodeFS ---@type Computer.Filesystem
    self.byteCodeFS = byteCodeFS ---@type Computer.Filesystem
    self.encrypted = encrypted
    self.password = password
end

function LuaVM:require(path, filePath)
    sm.scrapcomputers.errorHandler.assertArgument(path, nil, {"string"})

    local oldPath = self.mainCodeFS:getCurrentPath()
    self.mainCodeFS:setCurrentPath(filePath)
    local absolutePath = self.mainCodeFS:resolve(path)
    self.mainCodeFS:setCurrentPath(oldPath)

    if self.moduleCache[absolutePath] then
        return self.moduleCache[absolutePath]
    end

    sm.scrapcomputers.errorHandler.assert(self.mainCodeFS:exists(absolutePath), nil, "File \"" .. path .. "\" does not exist!")
    local byteCodeData = self.byteCodeFS[absolutePath]
    if byteCodeData then
        local func, errMsg = loadStringBytecode(TextCodec:decode(byteCodeData, self.encrypted, self.password), self.enviroment, self.luaState)
        sm.scrapcomputers.errorHandler.assert(func, nil, errMsg)
        
        local success, result = pcall(func)
        sm.scrapcomputers.errorHandler.assert(success, nil, result)
        
        self.moduleCache[absolutePath] = result
        return result
    end
    
    local func, data = loadString(self.mainCodeFS:readFile(absolutePath), self.enviroment, absolutePath, self.luaState, self.debugInfoEnabled)
    sm.scrapcomputers.errorHandler.assert(func, nil, data)

    local success, result = pcall(func)
    sm.scrapcomputers.errorHandler.assert(success, nil, result)

    self.byteCodeFS[absolutePath] = TextCodec:encode(data, self.encrypted, self.password)
    self.requestBCSyncFunc()

    self.moduleCache[absolutePath] = result

    return result
end

function LuaVM:reset()
    self.moduleCache = {} ---@type table<string, string>
    self.enviroment = sm.scrapcomputers.environmentManager.createEnv(self.classInstance, self)

    ---@class LuaVM.LuaState
    self.luaState = {
        ---@type LBI.CurrentFunc
        currentFunction = nil,
        memory = {old = 0, new = 0},
    }

    self.enviroment.require = function (path)
        sm.scrapcomputers.errorHandler.assertArgument(path, nil, {"string"})
        local parentPath = self.luaState.currentFunction.proto.source:match("^(.*)/[^/]+$")
        if parentPath:sub(1, 1) ~= "/" then
            parentPath = "/" .. parentPath
        end

        return self:require(path, parentPath)
    end

    ---@param code string
    ---@param env table
    ---@param bytecodeMode boolean?
    ---@return function?
    ---@return string?
    self.enviroment.loadstring = function (code, env, bytecodeMode)
        sm.scrapcomputers.errorHandler.assertArgument(code, 1, {"string"})
        sm.scrapcomputers.errorHandler.assertArgument(env, 2, {"table"})
        sm.scrapcomputers.errorHandler.assertArgument(bytecodeMode, 3, {"boolean", "nil"})
        
        if bytecodeMode then
            local isUnsafeENV = sm.scrapcomputers.config.getConfig("scrapcomputers.computer.safe_or_unsafe_env").selectedOption == 2
            sm.scrapcomputers.errorHandler.assert(isUnsafeENV, nil, "Cannot execute bytecode in safe env!")

            return self:loadstringBytecode(code, env, false)
        end

        return self:loadstring(code, env, false)
    end

    self.enviroment.sc.console = {
        info  = function (...) table.insert(self.pendingConsoleLogs, "#E5E5E5[ #3B8EEAINFO #E5E5E5]: " .. string.format(...) .. "\n") end,
        warn  = function (...) table.insert(self.pendingConsoleLogs, "#E5E5E5[ #F5F543WARN #E5E5E5]: " .. string.format(...) .. "\n") end,
        error = function (...) table.insert(self.pendingConsoleLogs, "#E5E5E5[ #F14C4CERROR #E5E5E5]: " .. string.format(...) .. "\n") end,

        log = function(...) table.insert(self.pendingConsoleLogs, string.format(...)) end
    }

    self.exception = {
        hasException = false,
        errMsg = ""
    }
end

function LuaVM:hasException()
    return self.exception.hasException
end

function LuaVM:clearException()
    self.exception.hasException = false
    self.exception.errMsg = ""
end

function LuaVM:getException()
    return self.exception.errMsg
end

function LuaVM:forceSetException(errMsg)
    self.exception.hasException = true
    self.exception.errMsg = errMsg
end

function LuaVM:loadstring(str, env, name, debugInfoEnabled)
    return loadString(str, env, name or "@input", self.luaState, debugInfoEnabled)
end

function LuaVM:loadstringBytecode(str, env)
    return loadStringBytecode(str, env, self.luaState)
end