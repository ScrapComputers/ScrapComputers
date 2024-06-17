_G.luavm = _G.luavm or {}

dofile("$CONTENT_DATA/Scripts/LuaVM/LBI.lua")
dofile("$CONTENT_DATA/Scripts/LuaVM/LuaZ.lua")
dofile("$CONTENT_DATA/Scripts/LuaVM/LuaX.lua")
dofile("$CONTENT_DATA/Scripts/LuaVM/LuaP.lua")
dofile("$CONTENT_DATA/Scripts/LuaVM/LuaK.lua")
dofile("$CONTENT_DATA/Scripts/LuaVM/LuaY.lua")
dofile("$CONTENT_DATA/Scripts/LuaVM/LuaU.lua")

_G.luavm.luaX:init()
_G.sm.luavm = {}

local LuaState = {}
function _G.sm.luavm.loadstring(str, env)
    local f,writer,buff
    local ran,error=pcall(function()
        local zio = _G.luavm.luaZ:init(_G.luavm.luaZ:make_getS(str), nil)
        if not zio then return error() end
        local func = _G.luavm.luaY:parser(LuaState, zio, nil, "@input")
        writer, buff = _G.luavm.luaU:make_setS()
        _G.luavm.luaU:dump(LuaState, func, writer, buff)
        local state =_G.luavm.lbi.bc_to_state(buff.data)
        f = _G.luavm.lbi.wrap_state(state, env)
    end)
    if ran then
        return f,buff.data
    else
        return nil,error
    end
end
