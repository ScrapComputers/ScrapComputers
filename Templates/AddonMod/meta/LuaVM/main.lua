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
---@param  str       string       The code to ececute
---@param  env       table        The enviroment variables (This gets modifed during execution!)
---@return function? closure      The function closure to run it
---@return string  ? errorMessage The error if it failed loading it!
function sm.scrapcomputers.luavm.loadstring(str, env)
    -- Create the function and buffer
    local func, writer, buff

    local function loadstringInternal()
        -- Zio? idfk what this is ?_?
        local zio = sm.scrapcomputers.luavm.luaZ:init( sm.scrapcomputers.luavm.luaZ:make_getS( str ), nil )
        if not zio then return error( "LuaZ Failure!" ) end
        
        -- Parse it and create a writer
        local parserFunc = sm.scrapcomputers.luavm.luaY:parser( LuaState, zio, nil, "@input" )
        writer, buff = sm.scrapcomputers.luavm.luaU:make_setS()

        -- Dump it
        sm.scrapcomputers.luavm.luaU:dump( LuaState, parserFunc, writer, buff )
        
        -- Create the state
        local state = sm.scrapcomputers.luavm.lbi.bc_to_state( buff.data )

        -- Wrap the state
        func = sm.scrapcomputers.luavm.lbi.wrap_state( state, env )
    end

    -- Pcall it
    local success,errorMessage = pcall( loadstringInternal )

    -- If succeeded, return the function and bytecode
    if success then
        return func, buff.data
    end

    -- Return no function and a error message since it failed
    return nil, errorMessage
end

---Loads a string and lets you execute it. NOTE: This only allows executing bytecode! be careful when your using it!
---@param  str       string       The code to ececute
---@param  env       table        The enviroment variables (This gets modifed during execution!)
---@return function? closure      The function closure to run it
---@return string  ? errorMessage The error if it failed loading it!
function sm.scrapcomputers.luavm.bytecodeLoadstring(str, env)
    local func = nil
    
    local function loadstringInternal()
        -- Create & Wrap it in a state and store it into func
        local state = sm.scrapcomputers.luavm.lbi.bc_to_state( str )
        func = sm.scrapcomputers.luavm.lbi.wrap_state( state, env )
    end

    -- Pcall it
    local success, errorMessage = pcall( loadstringInternal )

    -- If succeeded, return the function and bytecode
    if success then
        return func, str
    end

    -- Return no function and a error message since it failed
    return nil, errorMessage
end
