sm.scrapcomputers.luavm = sm.scrapcomputers.luavm or {}

dofile( "$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Scripts/LuaVM/LBI.lua"  )
dofile( "$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Scripts/LuaVM/LuaZ.lua" )
dofile( "$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Scripts/LuaVM/LuaX.lua" )
dofile( "$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Scripts/LuaVM/LuaP.lua" )
dofile( "$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Scripts/LuaVM/LuaK.lua" )
dofile( "$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Scripts/LuaVM/LuaY.lua" )
dofile( "$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Scripts/LuaVM/LuaU.lua" )

sm.scrapcomputers.luavm.luaX:init()

local LuaState = {}

---Loads a string and lets you execute it
---@param  str           string       The code to ececute
---@param  env           table        The environment variables (This gets modifed during execution!)
---@return function?     closure      The function closure to run it
---@return string  ?     errorMessage The error if it failed loading it!
function sm.scrapcomputers.luavm.loadstring(str, env)
    sm.scrapcomputers.errorHandler.assertArgument(str, 1, {"string"})
    sm.scrapcomputers.errorHandler.assertArgument(env, 2, {"table" })
    
    local func, writer, buff

    local function loadstringInternal()
        local zio = sm.scrapcomputers.luavm.luaZ:init( sm.scrapcomputers.luavm.luaZ:make_getS(str), nil )
        if not zio then return error("LuaZ Failure!") end
        
        local parserFunc = sm.scrapcomputers.luavm.luaY:parser(LuaState, zio, nil, "@input")
        writer, buff = sm.scrapcomputers.luavm.luaU:make_setS()

        sm.scrapcomputers.luavm.luaU:dump(LuaState, parserFunc, writer, buff)
        
        local state = sm.scrapcomputers.luavm.lbi.bc_to_state(buff.data)
        func = sm.scrapcomputers.luavm.lbi.wrap_state(state, env, nil)
    end

    local success,errorMessage = pcall(loadstringInternal)

    if success then
        return func, buff.data
    end

    return nil, errorMessage
end

---Loads a string and lets you execute it. NOTE: This only allows executing bytecode! be careful when your using it!
---@param  str           string       The code to ececute
---@param  env           table        The environment variables (This gets modifed during execution!)
---@return function?     closure      The function closure to run it
---@return string  ?     errorMessage The error if it failed loading it!
function sm.scrapcomputers.luavm.bytecodeLoadstring(str, env)
    sm.scrapcomputers.errorHandler.assertArgument(str, 1, {"string"})
    sm.scrapcomputers.errorHandler.assertArgument(env, 2, {"table" })

    local func
    
    local function loadstringInternal()
        local state = sm.scrapcomputers.luavm.lbi.bc_to_state(str)
        func = sm.scrapcomputers.luavm.lbi.wrap_state(state, env, nil)
    end

    local success, errorMessage = pcall(loadstringInternal)

    if success then
        return func, str
    end

    return nil, errorMessage
end
