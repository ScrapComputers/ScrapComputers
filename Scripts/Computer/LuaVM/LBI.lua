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

local function table_pack(...)
    return {
        n = select("#", ...),
        ...
    }
end

local function table_move(src, first, last, offset, dst)
    local di = offset - first
    for i = first, last do
        dst[i + di] = src[i]
    end
end

local string = string
local bit = bit
local math = math
local table = table

local table_concat = table.concat

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

-- Debugging usage
local OPCODE_DEBUG = {
    -- level 1
    [18] = "JMP",
    [8 ] = "FORLOOP",
    [28] = "TFORLOOP",
    -- level 2
    [3 ] = "MOVE",
    [13] = "LOADK",
    [23] = "LOADBOOL",
    [33] = "TEST",
    -- level 3
    [1 ] = "ADD",
    [6 ] = "SUB",
    [10] = "MUL",
    [16] = "DIV",
    [20] = "MOD",
    [26] = "POW",
    [30] = "UNM",
    [36] = "NOT",
    -- level 4
    [0 ] = "LOADNIL",
    [2 ] = "GETUPVAL",
    [4 ] = "GETGLOBAL",
    [7 ] = "GETTABLE",
    [9 ] = "SETGLOBAL",
    [12] = "SETUPVAL",
    [14] = "SETTABLE",
    [17] = "NEWTABLE",
    [19] = "LEN",
    [22] = "CONCAT",
    [24] = "EQ",
    [27] = "LT",
    [29] = "LE",
    [32] = "TESTSET",
    [34] = "FORPREP",
    [37] = "SETLIST",
    -- level 5
    [5 ] = "SELF",
    [11] = "CALL",
    [15] = "TAILCALL",
    [21] = "RETURN",
    [25] = "CLOSE",
    [31] = "CLOSURE",
    [35] = "VARARG",
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
local function rd_int_basic(src, s, e, d)
    local num = 0

    -- Iterate over the source string from index "s" to "e" in steps of "d"
    for i = s, e, d do
        -- Shift the current byte by (8 * (i - s)) bits
        local shift_amount = 8 * math_abs(i - s)
        num = bit_bor(num, bit_lshift(string.byte(src, i, i), shift_amount))
    end

    return num
end

local function rd_flt_basic(f1, f2, f3, f4)
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
local function rd_dbl_basic(f1, f2, f3, f4, f5, f6, f7, f8)
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
local function rd_int_le(src, s, e) return rd_int_basic(src, s, e - 1, 1) end

-- int rd_int_be(string src, int s, int e)
-- @src - Source binary string
-- @s - Start index of a big endian integer
-- @e - End index of the integer
local function rd_int_be(src, s, e) return rd_int_basic(src, e - 1, s, -1) end

-- float rd_flt_le(string src, int s)
-- @src - Source binary string
-- @s - Start index of little endian float
local function rd_flt_le(src, s) return rd_flt_basic(string_byte(src, s, s + 3)) end

-- float rd_flt_be(string src, int s)
-- @src - Source binary string
-- @s - Start index of big endian float
local function rd_flt_be(src, s)
    local f1, f2, f3, f4 = string_byte(src, s, s + 3)
    return rd_flt_basic(f4, f3, f2, f1)
end

-- double rd_dbl_le(string src, int s)
-- @src - Source binary string
-- @s - Start index of little endian double
local function rd_dbl_le(src, s) return rd_dbl_basic(string_byte(src, s, s + 7)) end

-- double rd_dbl_be(string src, int s)
-- @src - Source binary string
-- @s - Start index of big endian double
local function rd_dbl_be(src, s)
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
local function stm_byte(S)
    local idx = S.index
    local bt = string_byte(S.source, idx, idx)

    S.index = idx + 1
    return bt
end

-- string stm_string(Stream S, int len)
-- @S - Stream object to read from
-- @len - Length of string being read
local function stm_string(S, len)
    local pos = S.index + len
    local str = string_sub(S.source, S.index, pos - 1)

    S.index = pos
    return str
end

-- string stm_lstring(Stream S)
-- @S - Stream object to read from
local function stm_lstring(S)
    local len = S:s_szt()
    local str

    if len ~= 0 then str = string_sub(stm_string(S, len), 1, -2) end

    return str
end

-- fn cst_int_rdr(string src, int len, fn func)
-- @len - Length of type for reader
-- @func - Reader callback
local function cst_int_rdr(len, func)
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
local function cst_flt_rdr(len, func)
    return function(S)
        local flt = func(S.source, S.index)
        S.index = S.index + len

        return flt
    end
end

local function stm_inst_list(S)
    local len = S:s_int()
    local list = {}

    for i = 1, len do
        local ins = S:s_ins()
        local op = bit_band(ins, 0x3F)
        local args = OPCODE_T[op]
        local mode = OPCODE_M[op]

        ---@class LBI.Instruction
        local data = {value = ins, op = OPCODE_RM[op], A = bit_band(bit_rshift(ins, 6), 0xFF), const_B = nil, const_C = nil}

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

local function stm_const_list(S)
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

local function stm_sub_list(S, src, stm_lua_func)
    local len = S:s_int()
    local list = {}

    for i = 1, len do
        list[i] = stm_lua_func(S, src) -- offset +1 in CLOSURE
    end

    return list
end

local function stm_line_list(S)
    local len = S:s_int()
    local list = {}

    for i = 1, len do list[i] = S:s_int() end

    return list
end

local function stm_loc_list(S)
    local len = S:s_int()
    local list = {}

    for i = 1, len do list[i] = {varname = stm_lstring(S), startpc = S:s_int(), endpc = S:s_int()} end

    return list
end

local function stm_upval_list(S)
    local len = S:s_int()
    local list = {}

    for i = 1, len do list[i] = stm_lstring(S) end

    return list
end

---@param proto LBI.Proto
---@return LBI.Instruction[], table<integer, integer>
local function unroll_for_loops(proto)
    local protoCode = proto.code
    local protoLines = proto.lines
    local protoCodeSize = #protoCode

    local newCode = {}
    local newLines = {}
    local newCount = 0

    local FORPREP = 34
    local LOADK   = 13

    local skippedInstructions = {}

    local i = 1
    while i <= protoCodeSize do
        if skippedInstructions[i] then
            i = i + 1
            goto continue
        end

        local instr = protoCode[i]
        if instr.op == FORPREP and i >= 4 then
            local startInstr = protoCode[i - 3]
            local limitInstr = protoCode[i - 2]
            local stepInstr  = protoCode[i - 1]

            local A = instr.A

            local isConstLoop = startInstr.op == LOADK and startInstr.A == A and limitInstr.op == LOADK and limitInstr.A == A + 1 and stepInstr.op == LOADK and stepInstr.A == A + 2
            if isConstLoop then
                local forloopPos = i + instr.sBx + 1
                skippedInstructions[forloopPos] = true

                local forPrepLine = protoLines[i]
                local start, limit, step = startInstr.const, limitInstr.const, stepInstr.const

                local iterations = 0
                if step > 0 and start <= limit then
                    iterations = math.floor((limit - start) / step) + 1
                elseif step < 0 and start >= limit then
                    iterations = math.floor((start - limit) / math.abs(step)) + 1
                end

                local loopStart = i + 1
                local loopEnd   = i + instr.sBx
                local bodySize  = loopEnd - loopStart + 1

                local loopBody  = {}
                local loopLines = {}

                for j = 1, bodySize do
                    loopBody[j] = protoCode[loopStart + j - 1]
                    loopLines[j] = protoLines[loopStart + j - 1]
                end

                local indexAPos = A + 3
                local usesIndex = false

                for k = 1, bodySize do
                    local inst = loopBody[k]
                    if inst.A == indexAPos or inst.B == indexAPos or inst.C == indexAPos then
                        usesIndex = true
                        break
                    end
                end

                local iterator = start
                for _ = 1, iterations do
                    if usesIndex then
                        newCount = newCount + 1
                        newCode[newCount] = { op = LOADK, A = indexAPos, const = iterator }
                        newLines[newCount] = forPrepLine
                    end

                    for k = 1, bodySize do
                        newCount = newCount + 1
                        newCode[newCount] = loopBody[k]
                        newLines[newCount] = loopLines[k]
                    end

                    iterator = iterator + step
                end

                i = loopEnd + 1
                goto continue
            end
        end

        newCount = newCount + 1
        newCode[newCount] = instr
        newLines[newCount] = protoLines[i]

        i = i + 1
        ::continue::
    end

    return newCode, newLines
end

local function stm_lua_func(S, psrc)
    ---@class LBI.Proto
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
    proto.subs = stm_sub_list(S, src, stm_lua_func)
    proto.lines = stm_line_list(S)

    stm_loc_list(S)
    stm_upval_list(S)

    -- post process optimization
    proto.needs_arg = bit.band(proto.is_vararg, 0x5) == 0x5
    
    local protoCode = proto.code
    local codeSize = #protoCode

    local function needFix(value)
        return value == false or value == nil
    end

    local function getMemoryAddressForValue(value)
        if value == false then
            return -2
        elseif value  == nil then
            return -1
        end

        error("failed to convert value to memory address")
    end

    for i = 1, codeSize, 1 do
        local v = protoCode[i]

        if v.is_K then
            local const = proto.const[v.Bx + 1] -- offset for 1 based index
            v.const = const

            if needFix(const) then
                v.is_K = false
                v.B = getMemoryAddressForValue(const)
            end
        else
            if v.is_KB then
                local const_B = proto.const[v.B - 0xFF]
                v.const_B = const_B

                if needFix(const_B) then
                    v.is_KB = false
                    v.B = getMemoryAddressForValue(const_B)
                end
            end

            if v.is_KC then
                local const_C = proto.const[v.C - 0xFF]
                v.const_C = const_C

                if needFix(const_C) then
                    v.is_KC = false
                    v.C = getMemoryAddressForValue(const_C)
                end
            end
        end
    end

    -- This optimization is a bit broken, so its for now disabled.
    --proto.code, proto.lines = unroll_for_loops(proto)
    codeSize = #proto.code
    protoCode = proto.code

    for i = 1, codeSize, 1 do
        local v = protoCode[i]

        protoCode[i] = {
            v.value,
            v.op,
            v.A,
            v.B,
            v.C,
            v.const,
            v.const_B,
            v.const_C,
            v.Bx,
            v.sBx,
        }
    end

    return proto
end

local function lua_bc_to_state(src)
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

local function close_lua_upvalues(list, index)
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

local function open_lua_upvalue(list, index, memory)
    local prev = list[index]

    if not prev then
        prev = {index = index, store = memory}
        list[index] = prev
    end

    return prev
end

local function on_lua_error(failed, err)
    local src = failed.source or "Unknown error"
    local line = failed.lines[failed.pc] or 0

    local message = string_format("[path \"%s\"]:%i: %s", src, line, err)

    -- First cleanup: remove ErrorHandler.lua lines
    local cleanedMessage = message
    repeat
        local before = cleanedMessage
        cleanedMessage = cleanedMessage:gsub('%[string ".-/ErrorHandler%.lua"%]:%d+: ?', "")
    until cleanedMessage == before

    -- Second cleanup: change [string "PATH"] to [path "PATH"]
    repeat
        local before = cleanedMessage
        cleanedMessage = cleanedMessage:gsub('%[string "(.-)"%]:(%d+):', '[path "%1"]:%2:')
    until cleanedMessage == before

    error(cleanedMessage, 0)
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

local function run_lua_func(state, env, upvals, vmLuaState, lua_wrap_state)
    local code = state.code
    local subs = state.subs
    local vararg = state.vararg

    local top_index = -1
    local open_list = {}
    local memory = state.memory
    local pc = state.pc

    local assert       = assert
    local tonumber     = tonumber
    local table_move   = table_move
    local table_concat = table_concat
    local unpack       = unpack
    local table_pack   = table_pack

    while true do
        local inst = code[pc]
        local op = inst[2]
        pc = pc + 1
    
        if op == 0 then
            --[[LOADNIL]]
            local B = inst[4]
            for i = inst[3], B do memory[i] = nil end
        elseif op == 1 then
            --[[ADD]]
            local inst3, inst4, inst5, inst7, inst8 = inst[3], inst[4], inst[5], inst[7], inst[8]
            local lhs = inst7 or memory[inst4]
            local rhs = inst8 or memory[inst5]
            memory[inst3] = lhs + rhs
        elseif op == 2 then
            --[[GETUPVAL]]
            local uv = upvals[inst[4]]
            memory[inst[3]] = uv.store[uv.index]
        elseif op == 3 then 
            --[[MOVE]]
            memory[inst[3]] = memory[inst[4]]
        elseif op == 4 then
            --[[GETGLOBAL]]
            memory[inst[3]] = env[inst[6]]
        elseif op == 5 then
            --[[SELF]]
            local A = inst[3]
            local B = inst[4]

            memory[A + 1] = memory[B]
            memory[A] = memory[B][inst[8] or memory[inst[5]]]
        elseif op == 6 then
            --[[SUB]]
            local inst3, inst4, inst5, inst7, inst8 = inst[3], inst[4], inst[5], inst[7], inst[8]
            local lhs = inst7 or memory[inst4]
            local rhs = inst8 or memory[inst5]
            memory[inst3] = lhs - rhs
        elseif op == 7 then
            --[[GETTABLE]]
            memory[inst[3]] = memory[inst[4]][inst[8] or memory[inst[5]]]
        elseif op == 8 then
            --[[FORLOOP]]
            local A = inst[3]
            local step = memory[A + 2]
            local index = memory[A] + step

            if step * (index - memory[A + 1]) <= 0 then
                memory[A] = index
                memory[A + 3] = index
                pc = pc + inst[10]
            end
        elseif op == 9 then
            --[[SETGLOBAL]]
            env[inst[6]] = memory[inst[3]]
        elseif op == 10 then
            --[[MUL]]
            local inst3, inst4, inst5, inst7, inst8 = inst[3], inst[4], inst[5], inst[7], inst[8]
            local lhs = inst7 or memory[inst4]
            local rhs = inst8 or memory[inst5]
            memory[inst3] = lhs * rhs
        elseif op == 11 then
            --[[CALL]]
            local A = inst[3]
            local B = inst[4]
            local C = inst[5]

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
            local uv = upvals[inst[4]]

            uv.store[uv.index] = memory[inst[3]]
        elseif op == 13 then
            --[[LOADK]]
            memory[inst[3]] = inst[6]
        elseif op == 14 then
            --[[SETTABLE]]
            memory[inst[3]][inst[7] or memory[inst[4]]] = inst[8] or memory[inst[5]]
        elseif op == 15 then
            --[[TAILCALL]]
            local A = inst[3]
            local B = inst[4]

            return memory[A](unpack(memory, A + 1, A + (B == 0 and top_index - A or B - 1)))
        elseif op == 16 then
            --[[DIV]]
            local inst3, inst4, inst5, inst7, inst8 = inst[3], inst[4], inst[5], inst[7], inst[8]
            local lhs = inst7 or memory[inst4]
            local rhs = inst8 or memory[inst5]
            memory[inst3] = lhs / rhs
        elseif op == 17 then
            --[[NEWTABLE]]
            local const = inst[6]
            local tbl = {}

            for i = 1, const do tbl[i] = 0 end
            memory[inst[3]] = tbl
        elseif op == 18 then
            --[[JMP]]
            pc = pc + inst[10]
        elseif op == 19 then
            --[[LEN]]
            memory[inst[3]] = #memory[inst[4]]
        elseif op == 20 then
            --[[MOD]]
            local inst3, inst4, inst5, inst7, inst8 = inst[3], inst[4], inst[5], inst[7], inst[8]
            local lhs = inst7 or memory[inst4]
            local rhs = inst8 or memory[inst5]
            memory[inst3] = lhs % rhs
        elseif op == 21 then
            --[[RETURN]]
            local base = inst[3]
            local nret = inst[4]
            local ret_end = (nret == 0) and top_index or (base + nret - 1)
            return unpack(memory, base, ret_end - 1)
        elseif op == 22 then
            --[[CONCAT]]
            memory[inst[3]] = table_concat(memory, nil, inst[4], inst[5])
        elseif op == 23 then
            --[[LOADBOOL]]
            memory[inst[3]] = inst[4] ~= 0

            if inst[5] ~= 0 then pc = pc + 1 end
        elseif op == 24 then
            --[[EQ]]
            if ((inst[7] or memory[inst[4]]) == (inst[8] or memory[inst[5]])) == (inst[3] ~= 0) then
                pc = pc + code[pc][10]
            end

            pc = pc + 1
        elseif op == 25 then
            --[[CLOSE]]
            close_lua_upvalues(open_list, inst[3])
        elseif op == 26 then
            --[[POW]]
            local inst3, inst4, inst5, inst7, inst8 = inst[3], inst[4], inst[5], inst[7], inst[8]
            local lhs = inst7 or memory[inst4]
            local rhs = inst8 or memory[inst5]
            memory[inst3] = lhs ^ rhs
        elseif op == 27 then
            --[[LT]]
            if ((inst[7] or memory[inst[4]]) < (inst[8] or memory[inst[5]])) == (inst[3] ~= 0) then
                pc = pc + code[pc][10]
            end

            pc = pc + 1
        elseif op == 28 then
            --[[TFORLOOP]]
            local A = inst[3]
            local base = A + 3

            table_move({memory[A](memory[A + 1], memory[A + 2])}, 1, inst[5], base, memory)
            if memory[base] ~= nil then
                memory[A + 2] = memory[base]
                pc = pc + code[pc][10]
            end

            pc = pc + 1
        elseif op == 29 then
            --[[LE]]
            if ((inst[7] or memory[inst[4]]) <= (inst[8] or memory[inst[5]])) == (inst[3] ~= 0) then
                pc = pc + code[pc][10]
            end

            pc = pc + 1
        elseif op == 30 then
            --[[UNM]]
            memory[inst[3]] = -memory[inst[4]]
        elseif op == 31 then
            --[[CLOSURE]]
            local sub = subs[inst[9] + 1]
            local nups = sub.num_upval
            local uvlist = nil

            if nups ~= 0 then
                uvlist = {}

                for i = 1, nups do
                    local pseudo = code[pc + i - 1]
                    local op = pseudo[2]

                    if op == 3 then -- @MOVE
                        uvlist[i - 1] = open_lua_upvalue(open_list, pseudo[4], memory)
                    elseif op == 2 then -- @GETUPVAL
                        uvlist[i - 1] = upvals[pseudo[4]]
                    end
                end

                pc = pc + nups
            end

            memory[inst[3]] = lua_wrap_state(sub, env, uvlist, vmLuaState)
        elseif op == 32 then
            --[[TESTSET]]
            local B = inst[4]
            if (not memory[B]) ~= (inst[5] ~= 0) then
                memory[inst[3]] = memory[B]
                pc = pc + code[pc][10]
            end

            pc = pc + 1
        elseif op == 33 then
            --[[TEST]]
            pc = pc + 1 + ((not memory[inst[3]]) ~= (inst[5] ~= 0) and code[pc][10] or 0)
        elseif op == 34 then
            --[[FORPREP]]
            local A = inst[3]

            local init = assert(tonumber(memory[A]), "`for` initial value must be a number")
                         assert(tonumber(memory[A + 1]), "`for` limit must be a number")
            local step = assert(tonumber(memory[A + 2]), "`for` step must be a number")

            memory[A] = init - step
            if step == 0 then
                pc = pc + 1
            end

            pc = pc + inst[10]
        elseif op == 35 then
            --[[VARARG]]
            local A = inst[3]
            local len = inst[4]

            if len == 0 then
                len = vararg.len
                top_index = A + len - 1
            end

            table_move(vararg.list, 1, len, A, memory)
        elseif op == 36 then
            --[[NOT]]
            memory[inst[3]] = not memory[inst[4]]
        else
            --[[SETLIST]]
            local A = inst[3]
            local C = inst[5]
            local len = inst[4]

            if len == 0 then len = top_index - A end

            if C == 0 then
                C = inst[1]
                pc = pc + 1
            end

            table_move(memory, A + 1, A + len, ((C - 1) * FIELDS_PER_FLUSH) + 1, memory[A])
        end

        state.pc = pc
    end
end

---@param proto LBI.Proto
---@param env table
---@param upval table
---@param vmLuaState LuaVM.LuaState
local function lua_wrap_state(proto, env, upval, vmLuaState)
    function wrapped(...)
        local passed = table_pack(...)
        local memory = {[-2] = false}
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

        ---@class LBI.State
        local state = {vararg = vararg, memory = memory, code = proto.code, subs = proto.subs, pc = 1}

        if vmLuaState then
            ---@class LBI.CurrentFunc
            vmLuaState.currentFunction = {
                state = state,
                proto = proto
            }
        end

        local oldMemory = gcinfo()

        local result = table_pack(pcall(run_lua_func, state, env, upval, vmLuaState, lua_wrap_state))

        local newMemory = gcinfo()

        if vmLuaState then
            vmLuaState.currentFunction = {
                state = state,
                proto = proto
            }
            vmLuaState.memory = {old = oldMemory, new = newMemory}
        end

        if result[1] then
            return unpack(result, 2, result.n)
        end

        local failed = {pc = state.pc, source = proto.source, lines = proto.lines, filename = filename}
        on_lua_error(failed, result[2])
    end

    return wrapped
end

LuaVM.LBI = {bc_to_state = lua_bc_to_state, wrap_state = lua_wrap_state}