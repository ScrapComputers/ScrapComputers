--[[
FiOne
Copyright (C) 2021  Rerumu

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
]] --

function table_pack(...)
    return {
        n = select("#", ...),
        ...
    }
end

function table_move(src, first, last, offset, dst)
    for i = 0, last - first do
        dst[offset + i] = src[first + i]
    end
end

local string = string
local bit = bit
local math = math
local table = table

local math_abs = math.abs
local string_byte = string.byte
local string_sub = string.sub
local string_format = string.format

local bit_bor = bit.bor
local bit_rshift = bit.rshift
local bit_lshift = bit.lshift
local bit_band = bit.band

local assert = assert
local unpack = unpack

local lua_bc_to_state
local lua_wrap_state
local stm_lua_func

-- SETLIST config
local FIELDS_PER_FLUSH = 50

-- remap for better lookup
local OPCODE_RM = {
    -- level 1
    [22] = 18, -- JMP
    [31] = 8, -- FORLOOP
    [33] = 28, -- TFORLOOP
    -- level 2
    [0] = 3, -- MOVE
    [1] = 13, -- LOADK
    [2] = 23, -- LOADBOOL
    [26] = 33, -- TEST
    -- level 3
    [12] = 1, -- ADD
    [13] = 6, -- SUB
    [14] = 10, -- MUL
    [15] = 16, -- DIV
    [16] = 20, -- MOD
    [17] = 26, -- POW
    [18] = 30, -- UNM
    [19] = 36, -- NOT
    -- level 4
    [3] = 0, -- LOADNIL
    [4] = 2, -- GETUPVAL
    [5] = 4, -- GETGLOBAL
    [6] = 7, -- GETTABLE
    [7] = 9, -- SETGLOBAL
    [8] = 12, -- SETUPVAL
    [9] = 14, -- SETTABLE
    [10] = 17, -- NEWTABLE
    [20] = 19, -- LEN
    [21] = 22, -- CONCAT
    [23] = 24, -- EQ
    [24] = 27, -- LT
    [25] = 29, -- LE
    [27] = 32, -- TESTSET
    [32] = 34, -- FORPREP
    [34] = 37, -- SETLIST
    -- level 5
    [11] = 5, -- SELF
    [28] = 11, -- CALL
    [29] = 15, -- TAILCALL
    [30] = 21, -- RETURN
    [35] = 25, -- CLOSE
    [36] = 31, -- CLOSURE
    [37] = 35, -- VARARG
}

local ABC = 0
local ABx = 1
local AsBx = 2

-- opcode types for getting values
local OPCODE_T = {
    [0] = ABC,
    ABx,
    ABC,
    ABC,
    ABC,
    ABx,
    ABC,
    ABx,
    ABC,
    ABC,
    ABC,
    ABC,
    ABC,
    ABC,
    ABC,
    ABC,
    ABC,
    ABC,
    ABC,
    ABC,
    ABC,
    ABC,
    AsBx,
    ABC,
    ABC,
    ABC,
    ABC,
    ABC,
    ABC,
    ABC,
    ABC,
    AsBx,
    AsBx,
    ABC,
    ABC,
    ABC,
    ABx,
    ABC,
}

local OpArgR = 0
local OpArgN = 1
local OpArgK = 2
local OpArgU = 3

local OPCODE_M = {
    [0] = {b = OpArgR, c = OpArgN},
    {b = OpArgK, c = OpArgN},
    {b = OpArgU, c = OpArgU},
    {b = OpArgR, c = OpArgN},
    {b = OpArgU, c = OpArgN},
    {b = OpArgK, c = OpArgN},
    {b = OpArgR, c = OpArgK},
    {b = OpArgK, c = OpArgN},
    {b = OpArgU, c = OpArgN},
    {b = OpArgK, c = OpArgK},
    {b = OpArgU, c = OpArgU},
    {b = OpArgR, c = OpArgK},
    {b = OpArgK, c = OpArgK},
    {b = OpArgK, c = OpArgK},
    {b = OpArgK, c = OpArgK},
    {b = OpArgK, c = OpArgK},
    {b = OpArgK, c = OpArgK},
    {b = OpArgK, c = OpArgK},
    {b = OpArgR, c = OpArgN},
    {b = OpArgR, c = OpArgN},
    {b = OpArgR, c = OpArgN},
    {b = OpArgR, c = OpArgR},
    {b = OpArgR, c = OpArgN},
    {b = OpArgK, c = OpArgK},
    {b = OpArgK, c = OpArgK},
    {b = OpArgK, c = OpArgK},
    {b = OpArgR, c = OpArgU},
    {b = OpArgR, c = OpArgU},
    {b = OpArgU, c = OpArgU},
    {b = OpArgU, c = OpArgU},
    {b = OpArgU, c = OpArgN},
    {b = OpArgR, c = OpArgN},
    {b = OpArgR, c = OpArgN},
    {b = OpArgN, c = OpArgU},
    {b = OpArgU, c = OpArgU},
    {b = OpArgN, c = OpArgN},
    {b = OpArgU, c = OpArgN},
    {b = OpArgU, c = OpArgN},
}

-- int rd_int_basic(string src, int s, int e, int d)
-- @src - Source binary string
-- @s - Start index of a little endian integer
-- @e - End index of the integer
-- @d - Direction of the loop
function rd_int_basic(src, s, e, d)
    local num = 0

    -- Iterate over the source string from index "s" to "e" in steps of "d"
    for i = s, e, d do
        -- Shift the current byte by (8 * (i - s)) bits
        local shift_amount = 8 * math_abs(i - s)
        num = bit_bor(num, bit_lshift(string.byte(src, i, i), shift_amount))
    end

    return num
end

function rd_flt_basic(f1, f2, f3, f4)
    local sign = (-1) ^ bit_rshift(f4, 7)  -- Get the sign bit from the most significant bit of f4
    local exp = bit_rshift(f3, 7) + bit_lshift(bit_band(f4, 0x7F), 1)  -- Extract exponent from f3 and f4
    local frac = f1 + bit_lshift(f2, 8) + bit_lshift(bit_band(f3, 0x7F), 16)  -- Extract fraction bits (mantissa)
    local normal = 1

    if exp == 0 then
        if frac == 0 then
            return sign * 0  -- Handle the case for zero
        else
            normal = 0
            exp = 1  -- Denormalized numbers, exponent is 1
        end
    elseif exp == 0xFF then  -- If the exponent is all 1"s (255)
        if frac == 0 then
            return sign * (1 / 0)  -- Handle infinity
        else
            return sign * (0 / 0)  -- Handle NaN (Not a Number)
        end
    end

    -- Return the final floating-point value
    return sign * 2 ^ (exp - 127) * (1 + normal / 2 ^ 23)
end

-- double rd_dbl_basic(byte f1..8)
-- @f1..8 - The 8 bytes composing a little endian double
function rd_dbl_basic(f1, f2, f3, f4, f5, f6, f7, f8)
    local sign = (-1) ^ bit_rshift(f8, 7)  -- Extract the sign bit from the MSB of f8
    local exp = bit_lshift(bit_band(f8, 0x7F), 4) + bit_rshift(f7, 4)  -- Extract exponent (remaining 7 bits of f8 and 4 bits from f7)
    local frac = bit_band(f7, 0x0F) * 2 ^ 48  -- Extract the fraction bits (mantissa)
    local normal = 1

    -- Build the fraction using all 48 bits of the mantissa
    frac = frac + (f6 * 2 ^ 40) + (f5 * 2 ^ 32) + (f4 * 2 ^ 24) + (f3 * 2 ^ 16) + (f2 * 2 ^ 8) + f1

    if exp == 0 then
        if frac == 0 then
            return sign * 0  -- Handle zero
        else
            normal = 0
            exp = 1  -- Denormalized number, exponent is 1
        end
    elseif exp == 0x7FF then  -- Exponent of all 1's (2047)
        if frac == 0 then
            return sign * (1 / 0)  -- Handle infinity
        else
            return sign * (0 / 0)  -- Handle NaN
        end
    end

    -- Return the final double-precision floating-point value
    return sign * 2 ^ (exp - 1023) * (normal + frac / 2 ^ 52)
end

-- int rd_int_le(string src, int s, int e)
-- @src - Source binary string
-- @s - Start index of a little endian integer
-- @e - End index of the integer
function rd_int_le(src, s, e) return rd_int_basic(src, s, e - 1, 1) end

-- int rd_int_be(string src, int s, int e)
-- @src - Source binary string
-- @s - Start index of a big endian integer
-- @e - End index of the integer
function rd_int_be(src, s, e) return rd_int_basic(src, e - 1, s, -1) end

-- float rd_flt_le(string src, int s)
-- @src - Source binary string
-- @s - Start index of little endian float
function rd_flt_le(src, s) return rd_flt_basic(string_byte(src, s, s + 3)) end

-- float rd_flt_be(string src, int s)
-- @src - Source binary string
-- @s - Start index of big endian float
function rd_flt_be(src, s)
    local f1, f2, f3, f4 = string_byte(src, s, s + 3)
    return rd_flt_basic(f4, f3, f2, f1)
end

-- double rd_dbl_le(string src, int s)
-- @src - Source binary string
-- @s - Start index of little endian double
function rd_dbl_le(src, s) return rd_dbl_basic(string_byte(src, s, s + 7)) end

-- double rd_dbl_be(string src, int s)
-- @src - Source binary string
-- @s - Start index of big endian double
function rd_dbl_be(src, s)
    local f1, f2, f3, f4, f5, f6, f7, f8 = string_byte(src, s, s + 7) -- same
    return rd_dbl_basic(f8, f7, f6, f5, f4, f3, f2, f1)
end

-- to avoid nested ifs in deserializing
local float_types = {
    [4] = {little = rd_flt_le, big = rd_flt_be},
    [8] = {little = rd_dbl_le, big = rd_dbl_be},
}

-- byte stm_byte(Stream S)
-- @S - Stream object to read from
function stm_byte(S)
    local idx = S.index
    local bt = string_byte(S.source, idx, idx)

    S.index = idx + 1
    return bt
end

-- string stm_string(Stream S, int len)
-- @S - Stream object to read from
-- @len - Length of string being read
function stm_string(S, len)
    local pos = S.index + len
    local str = string_sub(S.source, S.index, pos - 1)

    S.index = pos
    return str
end

-- string stm_lstring(Stream S)
-- @S - Stream object to read from
function stm_lstring(S)
    local len = S:s_szt()
    local str

    if len ~= 0 then str = string_sub(stm_string(S, len), 1, -2) end

    return str
end

-- fn cst_int_rdr(string src, int len, fn func)
-- @len - Length of type for reader
-- @func - Reader callback
function cst_int_rdr(len, func)
    return function(S)
        local pos = S.index + len
        local int = func(S.source, S.index, pos)
        S.index = pos

        return int
    end
end

-- fn cst_flt_rdr(string src, int len, fn func)
-- @len - Length of type for reader
-- @func - Reader callback
function cst_flt_rdr(len, func)
    return function(S)
        local flt = func(S.source, S.index)
        S.index = S.index + len

        return flt
    end
end

function stm_inst_list(S)
    local len = S:s_int()
    local list = {}

    for i = 1, len do
        local ins = S:s_ins()
        local op = bit_band(ins, 0x3F)
        local args = OPCODE_T[op]
        local mode = OPCODE_M[op]
        local data = {value = ins, op = OPCODE_RM[op], A = bit_band(bit_rshift(ins, 6), 0xFF)}
        
        if args == ABC then
            data.B = bit_band(bit_rshift(ins, 23), 0x1FF)
            data.C = bit_band(bit_rshift(ins, 14), 0x1FF)
            data.is_KB = mode.b == OpArgK and data.B > 0xFF -- post process optimization
            data.is_KC = mode.c == OpArgK and data.C > 0xFF

            if op == 10 then -- decode NEWTABLE array size, store it as constant value
                local e = bit_band(bit_rshift(data.B, 3), 31)
                if e == 0 then
                    data.const = data.B
                else
                    data.const = bit_lshift(bit_band(data.B, 7) + 8, e - 1)
                end
            end
        elseif args == ABx then
            data.Bx = bit_band(bit_rshift(ins, 14), 0x3FFFF)
            data.is_K = mode.b == OpArgK
        elseif args == AsBx then
            data.sBx = bit_band(bit_rshift(ins, 14), 0x3FFFF) - 131071
        end

        list[i] = data
    end

    return list
end

function stm_const_list(S)
    local len = S:s_int()
    local list = {}

    for i = 1, len do
        local tt = stm_byte(S)
        local k

        if tt == 1 then
            k = stm_byte(S) ~= 0
        elseif tt == 3 then
            k = S:s_num()
        elseif tt == 4 then
            k = stm_lstring(S)
        end

        list[i] = k -- offset +1 during instruction decode
    end

    return list
end

function stm_sub_list(S, src)
    local len = S:s_int()
    local list = {}

    for i = 1, len do
        list[i] = stm_lua_func(S, src) -- offset +1 in CLOSURE
    end

    return list
end

function stm_line_list(S)
    local len = S:s_int()
    local list = {}

    for i = 1, len do list[i] = S:s_int() end

    return list
end

function stm_loc_list(S)
    local len = S:s_int()
    local list = {}

    for i = 1, len do list[i] = {varname = stm_lstring(S), startpc = S:s_int(), endpc = S:s_int()} end

    return list
end

function stm_upval_list(S)
    local len = S:s_int()
    local list = {}

    for i = 1, len do list[i] = stm_lstring(S) end

    return list
end

function stm_lua_func(S, psrc)
    local proto = {}
    local src = stm_lstring(S) or psrc -- source is propagated

    proto.source = src -- source name

    S:s_int() -- line defined
    S:s_int() -- last line defined

    proto.num_upval = stm_byte(S) -- num upvalues
    proto.num_param = stm_byte(S) -- num params

    proto.is_vararg = stm_byte(S) -- vararg flag
    proto.max_stack = stm_byte(S) -- max stack size

    proto.code = stm_inst_list(S)
    proto.const = stm_const_list(S)
    proto.subs = stm_sub_list(S, src)
    proto.lines = stm_line_list(S)

    stm_loc_list(S)
    stm_upval_list(S)

    -- post process optimization
    proto.needs_arg = bit.band(proto.is_vararg, 0x5) == 0x5

    local protoCode = proto.code
    local codeSize = #protoCode

    for i = 1, codeSize, 1 do
        local v = protoCode[i]

        if v.is_K then
            v.const = proto.const[v.Bx + 1] -- offset for 1 based index
        else
            if v.is_KB then v.const_B = proto.const[v.B - 0xFF] end

            if v.is_KC then v.const_C = proto.const[v.C - 0xFF] end
        end
    end

    return proto
end

function lua_bc_to_state(src)
    -- func reader
    local rdr_func

    -- header flags
    local little
    local size_int
    local size_szt
    local size_ins
    local size_num
    local flag_int

    -- stream object
    local stream = {
        -- data
        index = 1,
        source = src,
    }

    assert(stm_string(stream, 4) == "\27Lua", "invalid Lua signature")
    assert(stm_byte(stream) == 0x51, "invalid Lua version")
    assert(stm_byte(stream) == 0, "invalid Lua format")

    little = stm_byte(stream) ~= 0
    size_int = stm_byte(stream)
    size_szt = stm_byte(stream)
    size_ins = stm_byte(stream)
    size_num = stm_byte(stream)
    flag_int = stm_byte(stream) ~= 0

    rdr_func = little and rd_int_le or rd_int_be
    stream.s_int = cst_int_rdr(size_int, rdr_func)
    stream.s_szt = cst_int_rdr(size_szt, rdr_func)
    stream.s_ins = cst_int_rdr(size_ins, rdr_func)

    if flag_int then
        stream.s_num = cst_int_rdr(size_num, rdr_func)
    elseif float_types[size_num] then
        stream.s_num = cst_flt_rdr(size_num, float_types[size_num][little and "little" or "big"])
    else
        error("unsupported float size")
    end

    return stm_lua_func(stream, "@virtual")
end

function close_lua_upvalues(list, index)
    local sr = "value"
    
    for i, uv in pairs(list) do
        local uv_index = uv.index

        if uv_index >= index then
            uv.value = uv.store[uv_index]
            uv.store = uv
            uv.index = sr

            list[i] = nil
        end
    end
end

function open_lua_upvalue(list, index, memory)
    local prev = list[index]

    if not prev then
        prev = {index = index, store = memory}
        list[index] = prev
    end

    return prev
end

function on_lua_error(failed, err)
    local src = failed.source
    local line = failed.lines[failed.pc]

    error(string_format("%s:%i: %s", src, line, err), 0)
end

--[[LOADNIL]]
--[[ADD]]
--[[GETUPVAL]]
--[[MOVE]]
--[[GETGLOBAL]]
--[[SELF]]
--[[SUB]]
--[[GETTABLE]]
--[[FORLOOP]]
--[[SETGLOBAL]]
--[[MUL]]
--[[CALL]]
--[[SETUPVAL]]
--[[LOADK]]
--[[SETTABLE]]
--[[TAILCALL]]
--[[DIV]]
--[[NEWTABLE]]
--[[JMP]]
--[[LEN]]
--[[MOD]]
--[[RETURN]]
--[[CONCAT]]
--[[LOADBOOL]]
--[[EQ]]
--[[CLOSE]]
--[[POW]]
--[[LT]]
--[[TFORLOOP]]
--[[LE]]
--[[UNM]]
--[[CLOSURE]]
--[[TESTSET]]
--[[TEST]]
--[[FORPREP]]
--[[VARARG]]
--[[NOT]]
--[[SETLIST]]


-- if op < 18 then
--     if op < 8 then
--         if op < 3 then
--             if op < 1 then
--                 --[[LOADNIL]]
--                 for i = inst.A, inst.B do memory[i] = nil end
--             elseif op > 1 then
--                 --[[GETUPVAL]]
--                 local uv = upvals[inst.B]

--                 memory[inst.A] = uv.store[uv.index]
--             else
--                 --[[ADD]]
--                 memory[inst.A] = (inst.const_B or memory[inst.B]) + (inst.const_C or memory[inst.C])
--             end
--         elseif op > 3 then
--             if op < 6 then
--                 if op > 4 then
--                     --[[SELF]]
--                     local A = inst.A
--                     local B = inst.B

--                     memory[A + 1] = memory[B]
--                     memory[A] = memory[B][inst.const_C or memory[inst.C]]
--                 else
--                     --[[GETGLOBAL]]
--                     memory[inst.A] = env[inst.const]
--                 end
--             elseif op > 6 then
--                 --[[GETTABLE]]
--                 memory[inst.A] = memory[inst.B][inst.const_C or memory[inst.C]]
--             else
--                 --[[SUB]]
--                 memory[inst.A] = (inst.const_B or memory[inst.B]) - (inst.const_C or memory[inst.C])
--             end
--         else --[[MOVE]]
--             memory[inst.A] = memory[inst.B]
--         end
--     elseif op > 8 then
--         if op < 13 then
--             if op < 10 then
--                 --[[SETGLOBAL]]
--                 env[inst.const] = memory[inst.A]
--             elseif op > 10 then
--                 if op < 12 then
--                     --[[CALL]]
--                     local A = inst.A
--                     local B = inst.B
--                     local C = inst.C

--                     local ret_list = table_pack(memory[A](unpack(memory, A + 1, A + (B == 0 and top_index - A or B - 1))))
--                     local ret_num = ret_list.n

--                     if C == 0 then
--                         top_index = A + ret_num - 1
--                     else
--                         ret_num = C - 1
--                     end

--                     table_move(ret_list, 1, ret_num, A, memory)
--                 else
--                     --[[SETUPVAL]]
--                     local uv = upvals[inst.B]

--                     uv.store[uv.index] = memory[inst.A]
--                 end
--             else
--                 --[[MUL]]
--                 memory[inst.A] = (inst.const_B or memory[inst.B]) * (inst.const_C or memory[inst.C])
--             end
--         elseif op > 13 then
--             if op < 16 then
--                 if op > 14 then
--                     --[[TAILCALL]]
--                     local A = inst.A
--                     local B = inst.B
--                     local params = B - 1

--                     if B == 0 then
--                         params = top_index - A
--                     end

--                     close_lua_upvalues(open_list, 0)

--                     return memory[A](unpack(memory, A + 1, A + params))
--                 else
--                     --[[SETTABLE]]
--                     memory[inst.A][inst.const_B or memory[inst.B]] = inst.const_C or memory[inst.C]
--                 end
--             elseif op > 16 then
--                 --[[NEWTABLE]]
--                 memory[inst.A] = {}
--             else
--                 --[[DIV]]
--                 memory[inst.A] = (inst.const_B or memory[inst.B]) / (inst.const_C or memory[inst.C])
--             end
--         else
--             --[[LOADK]]
--             memory[inst.A] = inst.const
--         end
--     else
--         --[[FORLOOP]]
--         local A = inst.A
--         local Mem2A = memory[A + 2]
--         local limit = memory[A + 1]
--         local index = memory[A] + Mem2A
        
--         if Mem2A > 0 then
--             if index <= limit then
--                 memory[A] = index
--                 memory[A + 3] = index
--                 pc = pc + inst.sBx
--             end
--         elseif Mem2A < 0 then
--             if index >= limit then
--                 memory[A] = index
--                 memory[A + 3] = index
--                 pc = pc + inst.sBx
--             end
--         end
--     end
-- elseif op > 18 then
--     if op < 28 then
--         if op < 23 then
--             if op < 20 then
--                 --[[LEN]]
--                 memory[inst.A] = #memory[inst.B]
--             elseif op > 20 then
--                 if op < 22 then
--                     --[[RETURN]]
--                     local A = inst.A
--                     local B = inst.B

--                     close_lua_upvalues(open_list, 0)

--                     return unpack(memory, A, A + (B == 0 and top_index - A + 1 or B - 1) - 1)
--                 else
--                     --[[CONCAT]]
--                     local B, C = inst.B, inst.C
--                     local str = memory[B]

--                     for i = B + 1, C do
--                         str = str .. memory[i]
--                     end

--                     memory[inst.A] = str
--                 end
--             else
--                 --[[MOD]]
--                 memory[inst.A] = (inst.const_B or memory[inst.B]) % (inst.const_C or memory[inst.C])
--             end
--         elseif op > 23 then
--             if op < 26 then
--                 if op > 24 then
--                     --[[CLOSE]]
--                     close_lua_upvalues(open_list, inst.A)
--                 else
--                     --[[EQ]]
--                     if ((inst.const_B or memory[inst.B]) == (inst.const_C or memory[inst.C])) == (inst.A ~= 0) then 
--                         pc = pc + code[pc].sBx 
--                     end
        
--                     pc = pc + 1
--                 end
--             elseif op > 26 then
--                 --[[LT]]
--                 if ((inst.const_B or memory[inst.B]) < (inst.const_C or memory[inst.C])) == (inst.A ~= 0) then pc = pc + code[pc].sBx end

--                 pc = pc + 1
--             else
--                 --[[POW]]
--                 memory[inst.A] = (inst.const_B or memory[inst.B]) ^ (inst.const_C or memory[inst.C])
--             end
--         else
--             --[[LOADBOOL]]
--             memory[inst.A] = inst.B ~= 0

--             if inst.C ~= 0 then pc = pc + 1 end
--         end
--     elseif op > 28 then
--         if op < 33 then
--             if op < 30 then
--                 --[[LE]]
--                 if ((inst.const_B or memory[inst.B]) <= (inst.const_C or memory[inst.C])) == (inst.A ~= 0) then pc = pc + code[pc].sBx end

--                 pc = pc + 1
--             elseif op > 30 then
--                 if op < 32 then
--                     --[[CLOSURE]]
--                     local sub = subs[inst.Bx + 1]
--                     local nups = sub.num_upval
--                     local uvlist

--                     if nups ~= 0 then
--                         uvlist = {}

--                         for i = 1, nups do
--                             local pseudo = code[pc + i - 1]

--                             if pseudo.op == OPCODE_RM[0] then -- @MOVE
--                                 uvlist[i - 1] = open_lua_upvalue(open_list, pseudo.B, memory)
--                             elseif pseudo.op == OPCODE_RM[4] then -- @GETUPVAL
--                                 uvlist[i - 1] = upvals[pseudo.B]
--                             end
--                         end

--                         pc = pc + nups
--                     end

--                     memory[inst.A] = lua_wrap_state(sub, env, uvlist)
--                 else
--                     --[[TESTSET]]
--                     local B = inst.B

--                     if (not memory[B]) ~= (inst.C ~= 0) then
--                         memory[inst.A] = memory[B]
--                         pc = pc + code[pc].sBx
--                     end
--                     pc = pc + 1
--                 end
--             else
--                 --[[UNM]]
--                 memory[inst.A] = -memory[inst.B]
--             end
--         elseif op > 33 then
--             if op < 36 then
--                 if op > 34 then
--                     --[[VARARG]]
--                     local A = inst.A
--                     local len = inst.B

--                     if len == 0 then
--                         len = vararg.len
--                         top_index = A + len - 1
--                     end

--                     table_move(vararg.list, 1, len, A, memory)
--                 else
--                     --[[FORPREP]]
--                     local A = inst.A

--                     local init = assert(tonumber(memory[A]), "`for` initial value must be a number")
--                     local limit = assert(tonumber(memory[A + 1]), "`for` limit must be a number")
--                     local step = assert(tonumber(memory[A + 2]), "`for` step must be a number")

--                     memory[A] = init - step
--                     memory[A + 1] = limit
--                     memory[A + 2] = step

--                     pc = pc + inst.sBx
--                 end
--             elseif op > 36 then
--                 --[[SETLIST]]
--                 local A = inst.A
--                 local C = inst.C
--                 local len = inst.B
--                 local offset

--                 if len == 0 then len = top_index - A end

--                 if C == 0 then
--                     C = inst[pc].value
--                     pc = pc + 1
--                 end

--                 offset = (C - 1) * FIELDS_PER_FLUSH

--                 table_move(memory, A + 1, A + len, offset + 1, memory[A])
--             else
--                 --[[NOT]]
--                 memory[inst.A] = not memory[inst.B]
--             end
--         else
--             --[[TEST]]
--             if (not memory[inst.A]) ~= (inst.C ~= 0) then pc = pc + code[pc].sBx end
--             pc = pc + 1
--         end
--     else
--         --[[TFORLOOP]]
--         local A = inst.A
--         local base = A + 3

--         table_move({memory[A](memory[A + 1], memory[A + 2])}, 1, inst.C, base, memory)

--         if memory[base] ~= nil then
--             memory[A + 2] = memory[base]
--             pc = pc + code[pc].sBx
--         end

--         pc = pc + 1
--     end
-- else
--     --[[JMP]]
--     pc = pc + inst.sBx
-- end

function run_lua_func(state, env, upvals)
    local code = state.code
    local subs = state.subs
    local vararg = state.vararg

    local top_index = -1
    local open_list = {}
    local memory = state.memory
    local pc = state.pc

    while true do
        local inst = code[pc]
        local op = inst.op
        pc = pc + 1

        if op == 0 then
            --[[LOADNIL]]
            for i = inst.A, inst.B do memory[i] = nil end
        elseif op == 1 then
            --[[ADD]]
            memory[inst.A] = (inst.const_B or memory[inst.B]) + (inst.const_C or memory[inst.C])
        elseif op == 2 then
            --[[GETUPVAL]]
            local uv = upvals[inst.B]

            memory[inst.A] = uv.store[uv.index]
        elseif op == 3 then
            --[[MOVE]]
            memory[inst.A] = memory[inst.B]
        elseif op == 4 then
            --[[GETGLOBAL]]
            memory[inst.A] = env[inst.const]
        elseif op == 5 then
            --[[SELF]]
            local A = inst.A
            local B = inst.B

            memory[A + 1] = memory[B]
            memory[A] = memory[B][inst.const_C or memory[inst.C]]
        elseif op == 6 then
            --[[SUB]]
            memory[inst.A] = (inst.const_B or memory[inst.B]) - (inst.const_C or memory[inst.C])
        elseif op == 7 then
            --[[GETTABLE]]
            memory[inst.A] = memory[inst.B][inst.const_C or memory[inst.C]]
        elseif op == 8 then
            --[[FORLOOP]]
            local A = inst.A
            local Mem2A = memory[A + 2]
            local limit = memory[A + 1]
            local index = memory[A] + Mem2A
            
            if Mem2A > 0 then
                if index <= limit then
                    memory[A] = index
                    memory[A + 3] = index
                    pc = pc + inst.sBx
                end
            elseif Mem2A < 0 then
                if index >= limit then
                    memory[A] = index
                    memory[A + 3] = index
                    pc = pc + inst.sBx
                end
            end
        elseif op == 9 then
            --[[SETGLOBAL]]
            env[inst.const] = memory[inst.A]
        elseif op == 10 then
            --[[MUL]]
            memory[inst.A] = (inst.const_B or memory[inst.B]) * (inst.const_C or memory[inst.C])
        elseif op == 11 then
            --[[CALL]]
            local A = inst.A
            local B = inst.B
            local C = inst.C

            local ret_list = table_pack(memory[A](unpack(memory, A + 1, A + (B == 0 and top_index - A or B - 1))))
            local ret_num = ret_list.n

            if C == 0 then
                top_index = A + ret_num - 1
            else
                ret_num = C - 1
            end

            table_move(ret_list, 1, ret_num, A, memory)
        elseif op == 12 then
            --[[SETUPVAL]]
            local uv = upvals[inst.B]

            uv.store[uv.index] = memory[inst.A]
        elseif op == 13 then
            --[[LOADK]]
            memory[inst.A] = inst.const
        elseif op == 14 then
            --[[SETTABLE]]
            memory[inst.A][inst.const_B or memory[inst.B]] = inst.const_C or memory[inst.C]
        elseif op == 15 then
            --[[TAILCALL]]
            local A = inst.A
            local B = inst.B
            local params = B - 1

            if B == 0 then
                params = top_index - A
            end

            close_lua_upvalues(open_list, 0)

            return memory[A](unpack(memory, A + 1, A + params))
        elseif op == 16 then
            --[[DIV]]
            memory[inst.A] = (inst.const_B or memory[inst.B]) / (inst.const_C or memory[inst.C])
        elseif op == 17 then
            --[[NEWTABLE]]
            memory[inst.A] = {}
        elseif op == 18 then
            --[[JMP]]
            pc = pc + inst.sBx
        elseif op == 19 then
            --[[LEN]]
            memory[inst.A] = #memory[inst.B]
        elseif op == 20 then
            --[[MOD]]
            memory[inst.A] = (inst.const_B or memory[inst.B]) % (inst.const_C or memory[inst.C])
        elseif op == 21 then
            --[[RETURN]]
            local A = inst.A
            local B = inst.B

            close_lua_upvalues(open_list, 0)

            return unpack(memory, A, A + (B == 0 and top_index - A + 1 or B - 1) - 1)
        elseif op == 22 then
            --[[CONCAT]]
            local B, C = inst.B, inst.C
            local str = memory[B]

            for i = B + 1, C do
                str = str .. memory[i]
            end

            memory[inst.A] = str
        elseif op == 23 then
            --[[LOADBOOL]]
            memory[inst.A] = inst.B ~= 0

            if inst.C ~= 0 then pc = pc + 1 end
        elseif op == 24 then
            --[[EQ]]

            if ((inst.const_B or memory[inst.B]) == (inst.const_C or memory[inst.C])) == (inst.A ~= 0) then 
                pc = pc + code[pc].sBx 
            end

            pc = pc + 1
        elseif op == 25 then
            --[[CLOSE]]
            close_lua_upvalues(open_list, inst.A)
        elseif op == 26 then
            --[[POW]]
            memory[inst.A] = (inst.const_B or memory[inst.B]) ^ (inst.const_C or memory[inst.C])
        elseif op == 27 then
            --[[LT]]
            if ((inst.const_B or memory[inst.B]) < (inst.const_C or memory[inst.C])) == (inst.A ~= 0) then pc = pc + code[pc].sBx end

            pc = pc + 1
        elseif op == 28 then
            --[[TFORLOOP]]
            local A = inst.A
            local base = A + 3

            table_move({memory[A](memory[A + 1], memory[A + 2])}, 1, inst.C, base, memory)

            if memory[base] ~= nil then
                memory[A + 2] = memory[base]
                pc = pc + code[pc].sBx
            end

            pc = pc + 1
        elseif op == 29 then
            --[[LE]]
            if ((inst.const_B or memory[inst.B]) <= (inst.const_C or memory[inst.C])) == (inst.A ~= 0) then pc = pc + code[pc].sBx end

            pc = pc + 1
        elseif op == 30 then
            --[[UNM]]
            memory[inst.A] = -memory[inst.B]
        elseif op == 31 then
            --[[CLOSURE]]
            local sub = subs[inst.Bx + 1]
            local nups = sub.num_upval
            local uvlist

            if nups ~= 0 then
                uvlist = {}

                for i = 1, nups do
                    local pseudo = code[pc + i - 1]

                    if pseudo.op == OPCODE_RM[0] then -- @MOVE
                        uvlist[i - 1] = open_lua_upvalue(open_list, pseudo.B, memory)
                    elseif pseudo.op == OPCODE_RM[4] then -- @GETUPVAL
                        uvlist[i - 1] = upvals[pseudo.B]
                    end
                end

                pc = pc + nups
            end

            memory[inst.A] = lua_wrap_state(sub, env, uvlist)
        elseif op == 32 then
            --[[TESTSET]]
            local B = inst.B

            if (not memory[B]) ~= (inst.C ~= 0) then
                memory[inst.A] = memory[B]
                pc = pc + code[pc].sBx
            end
            pc = pc + 1
        elseif op == 33 then
            --[[TEST]]
            if (not memory[inst.A]) ~= (inst.C ~= 0) then pc = pc + code[pc].sBx end
            pc = pc + 1
        elseif op == 34 then
            --[[FORPREP]]
            local A = inst.A

            local init = assert(tonumber(memory[A]), "`for` initial value must be a number")
            local limit = assert(tonumber(memory[A + 1]), "`for` limit must be a number")
            local step = assert(tonumber(memory[A + 2]), "`for` step must be a number")

            memory[A] = init - step
            memory[A + 1] = limit
            memory[A + 2] = step

            pc = pc + inst.sBx
        elseif op == 35 then
            --[[VARARG]]
            local A = inst.A
            local len = inst.B

            if len == 0 then
                len = vararg.len
                top_index = A + len - 1
            end

            table_move(vararg.list, 1, len, A, memory)
        elseif op == 36 then
            --[[NOT]]
            memory[inst.A] = not memory[inst.B]
        else
            --[[SETLIST]]
            local A = inst.A
            local C = inst.C
            local len = inst.B
            local offset

            if len == 0 then len = top_index - A end

            if C == 0 then
                C = inst[pc].value
                pc = pc + 1
            end

            offset = (C - 1) * FIELDS_PER_FLUSH

            table_move(memory, A + 1, A + len, offset + 1, memory[A])
        end

        state.pc = pc
    end
end

function lua_wrap_state(proto, env, upval)
    function wrapped(...)
        local passed = table_pack(...)
        local memory = {}
        local vararg = {len = 0, list = {}}

        table_move(passed, 1, proto.num_param, 0, memory)

        if proto.num_param < passed.n then
            local start = proto.num_param + 1
            local len = passed.n - proto.num_param

            vararg.len = len
            table_move(passed, start, start + len - 1, 1, vararg.list)
        end

        if proto.needs_arg then
            memory[proto.num_param] = {n = vararg.len, unpack(vararg.list, 1, vararg.len)}
        end
        local state = {vararg = vararg, memory = memory, code = proto.code, subs = proto.subs, pc = 1}

        local result = table_pack(pcall(run_lua_func, state, env, upval))

        if result[1] then
            return unpack(result, 2, result.n)
        else
            local failed = {pc = state.pc, source = proto.source, lines = proto.lines}

            on_lua_error(failed, result[2])

            return
        end
    end

    return wrapped
end

sm.scrapcomputers.luavm.lbi = {bc_to_state = lua_bc_to_state, wrap_state = lua_wrap_state}