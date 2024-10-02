-- Veradev is NOT FUCKING DOCUMENTING THIS

-- Source: https://github.com/kikito/md5.lua/blob/master/md5.lua

local md5 = {
    _VERSION = "md5.lua 1.1.0",
    _DESCRIPTION = "MD5 computation in Lua (5.1-3, LuaJIT)",
    _URL = "https://github.com/kikito/md5.lua",
    _LICENSE = [[
      MIT LICENSE

      Copyright (c) 2013 Enrique García Cota + Adam Baldwin + hanzao + Equi 4 Software

      Permission is hereby granted, free of charge, to any person obtaining a
      copy of this software and associated documentation files (the
      "Software"), to deal in the Software without restriction, including
      without limitation the rights to use, copy, modify, merge, publish,
      distribute, sublicense, and/or sell copies of the Software, and to
      permit persons to whom the Software is furnished to do so, subject to
      the following conditions:

      The above copyright notice and this permission notice shall be included
      in all copies or substantial portions of the Software.

      THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
      OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
      MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
      IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
      CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
      TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
      SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
]]
}

-- bit lib implementions
-- convert little-endian 32-bit int to a 4-char string
local function lei2str(x)
    local function f(s)
        return string.char(bit.band(bit.rshift(x, s), 255))
    end

    return f(0) .. f(8) .. f(16) .. f(24)
end


-- convert raw string to big-endian int
local function str2bei(str)
    local integer = 0
    for index = 1, #str do
        integer = integer * 256 + string.byte(str, index)
    end

    return integer
end

-- convert raw string to little-endian int
local function str2lei(str)
    local integer = 0
    for index = #str, 1, -1 do
        integer = integer * 256 + string.byte(str, index)
    end

    return integer
end

-- cut up a string in little-endian ints of given size
local function cut_le_str(str)
    return {
        str2lei(string.sub(str, 1, 4)),
        str2lei(string.sub(str, 5, 8)),
        str2lei(string.sub(str, 9, 12)),
        str2lei(string.sub(str, 13, 16)),
        str2lei(string.sub(str, 17, 20)),
        str2lei(string.sub(str, 21, 24)),
        str2lei(string.sub(str, 25, 28)),
        str2lei(string.sub(str, 29, 32)),
        str2lei(string.sub(str, 33, 36)),
        str2lei(string.sub(str, 37, 40)),
        str2lei(string.sub(str, 41, 44)),
        str2lei(string.sub(str, 45, 48)),
        str2lei(string.sub(str, 49, 52)),
        str2lei(string.sub(str, 53, 56)),
        str2lei(string.sub(str, 57, 60)),
        str2lei(string.sub(str, 61, 64)),
}
end

-- 10/02/2001 jcw@equi4.com
local CONSTS = {
    0xd76aa478, 0xe8c7b756, 0x242070db, 0xc1bdceee,
    0xf57c0faf, 0x4787c62a, 0xa8304613, 0xfd469501,
    0x698098d8, 0x8b44f7af, 0xffff5bb1, 0x895cd7be,
    0x6b901122, 0xfd987193, 0xa679438e, 0x49b40821,
    0xf61e2562, 0xc040b340, 0x265e5a51, 0xe9b6c7aa,
    0xd62f105d, 0x02441453, 0xd8a1e681, 0xe7d3fbc8,
    0x21e1cde6, 0xc33707d6, 0xf4d50d87, 0x455a14ed,
    0xa9e3e905, 0xfcefa3f8, 0x676f02d9, 0x8d2a4c8a,
    0xfffa3942, 0x8771f681, 0x6d9d6122, 0xfde5380c,
    0xa4beea44, 0x4bdecfa9, 0xf6bb4b60, 0xbebfbc70,
    0x289b7ec6, 0xeaa127fa, 0xd4ef3085, 0x04881d05,
    0xd9d4d039, 0xe6db99e5, 0x1fa27cf8, 0xc4ac5665,
    0xf4292244, 0x432aff97, 0xab9423a7, 0xfc93a039,
    0x655b59c3, 0x8f0ccc92, 0xffeff47d, 0x85845dd1,
    0x6fa87e4f, 0xfe2ce6e0, 0xa3014314, 0x4e0811a1,
    0xf7537e82, 0xbd3af235, 0x2ad7d2bb, 0xeb86d391,
    0x67452301, 0xefcdab89, 0x98badcfe, 0x10325476
}

local f = function(x, y, z) return bit.bor (bit.band(x, y), bit.band(-x - 1, z)) end
local g = function(x, y, z) return bit.bor (bit.band(x, z), bit.band(y, -z - 1)) end
local h = function(x, y, z) return bit.bxor(x, bit.bxor(y, z)) end
local i = function(x, y, z) return bit.bxor(y, bit.bor (x, -z - 1)) end

local z = function(ff, a, b, c, d, x, s, ac)
    a = bit.band(a + ff(b, c, d) + x + ac, 0xFFFFFFFF)
    -- be *very* careful that left shift does not cause rounding!
    return bit.bor(bit.lshift(bit.band(a, bit.rshift(0xFFFFFFFF, s)), s), bit.rshift(a, 32 - s)) + b
end

local function transform(A, B, C, D, X)
    local a, b, c, d = A, B, C, D
    local t = CONSTS

    a = z(f, a, b, c, d, X[0], 7, t[1])
    d = z(f, d, a, b, c, X[1], 12, t[2])
    c = z(f, c, d, a, b, X[2], 17, t[3])
    b = z(f, b, c, d, a, X[3], 22, t[4])
    a = z(f, a, b, c, d, X[4], 7, t[5])
    d = z(f, d, a, b, c, X[5], 12, t[6])
    c = z(f, c, d, a, b, X[6], 17, t[7])
    b = z(f, b, c, d, a, X[7], 22, t[8])
    a = z(f, a, b, c, d, X[8], 7, t[9])
    d = z(f, d, a, b, c, X[9], 12, t[10])
    c = z(f, c, d, a, b, X[10], 17, t[11])
    b = z(f, b, c, d, a, X[11], 22, t[12])
    a = z(f, a, b, c, d, X[12], 7, t[13])
    d = z(f, d, a, b, c, X[13], 12, t[14])
    c = z(f, c, d, a, b, X[14], 17, t[15])
    b = z(f, b, c, d, a, X[15], 22, t[16])

    a = z(g, a, b, c, d, X[1], 5, t[17])
    d = z(g, d, a, b, c, X[6], 9, t[18])
    c = z(g, c, d, a, b, X[11], 14, t[19])
    b = z(g, b, c, d, a, X[0], 20, t[20])
    a = z(g, a, b, c, d, X[5], 5, t[21])
    d = z(g, d, a, b, c, X[10], 9, t[22])
    c = z(g, c, d, a, b, X[15], 14, t[23])
    b = z(g, b, c, d, a, X[4], 20, t[24])
    a = z(g, a, b, c, d, X[9], 5, t[25])
    d = z(g, d, a, b, c, X[14], 9, t[26])
    c = z(g, c, d, a, b, X[3], 14, t[27])
    b = z(g, b, c, d, a, X[8], 20, t[28])
    a = z(g, a, b, c, d, X[13], 5, t[29])
    d = z(g, d, a, b, c, X[2], 9, t[30])
    c = z(g, c, d, a, b, X[7], 14, t[31])
    b = z(g, b, c, d, a, X[12], 20, t[32])

    a = z(h, a, b, c, d, X[5], 4, t[33])
    d = z(h, d, a, b, c, X[8], 11, t[34])
    c = z(h, c, d, a, b, X[11], 16, t[35])
    b = z(h, b, c, d, a, X[14], 23, t[36])
    a = z(h, a, b, c, d, X[1], 4, t[37])
    d = z(h, d, a, b, c, X[4], 11, t[38])
    c = z(h, c, d, a, b, X[7], 16, t[39])
    b = z(h, b, c, d, a, X[10], 23, t[40])
    a = z(h, a, b, c, d, X[13], 4, t[41])
    d = z(h, d, a, b, c, X[0], 11, t[42])
    c = z(h, c, d, a, b, X[3], 16, t[43])
    b = z(h, b, c, d, a, X[6], 23, t[44])
    a = z(h, a, b, c, d, X[9], 4, t[45])
    d = z(h, d, a, b, c, X[12], 11, t[46])
    c = z(h, c, d, a, b, X[15], 16, t[47])
    b = z(h, b, c, d, a, X[2], 23, t[48])

    a = z(i, a, b, c, d, X[0], 6, t[49])
    d = z(i, d, a, b, c, X[7], 10, t[50])
    c = z(i, c, d, a, b, X[14], 15, t[51])
    b = z(i, b, c, d, a, X[5], 21, t[52])
    a = z(i, a, b, c, d, X[12], 6, t[53])
    d = z(i, d, a, b, c, X[3], 10, t[54])
    c = z(i, c, d, a, b, X[10], 15, t[55])
    b = z(i, b, c, d, a, X[1], 21, t[56])
    a = z(i, a, b, c, d, X[8], 6, t[57])
    d = z(i, d, a, b, c, X[15], 10, t[58])
    c = z(i, c, d, a, b, X[6], 15, t[59])
    b = z(i, b, c, d, a, X[13], 21, t[60])
    a = z(i, a, b, c, d, X[4], 6, t[61])
    d = z(i, d, a, b, c, X[11], 10, t[62])
    c = z(i, c, d, a, b, X[2], 15, t[63])
    b = z(i, b, c, d, a, X[9], 21, t[64])

    return bit.band(A + a, 0xFFFFFFFF), bit.band(B + b, 0xFFFFFFFF), bit.band(C + c, 0xFFFFFFFF), bit.band(D + d, 0xFFFFFFFF)
end

----------------------------------------------------------------

local function md5_update(self, str)
    sm.scrapcomputers.errorHandler.assertArgument(self, 1, {"table"}, {"MD5Stream"})
    sm.scrapcomputers.errorHandler.assertArgument(str, 2, {"string"})
    
    self.pos = self.pos + #str
    str = self.buf .. str

    for index = 1, #str - 63, 64 do
        local X = cut_le_str(string.sub(str, index, index + 63))
        assert(#X == 16)

        X[0] = table.remove(X, 1) -- zero based!
        self.a, self.b, self.c, self.d = transform(self.a, self.b, self.c, self.d, X)
    end

    self.buf = string.sub(str, math.floor(#str / 64) * 64 + 1, #str)
    return self
end

local function md5_finish(self)
    sm.scrapcomputers.errorHandler.assertArgument(self, nil, {"table"}, {"MD5Stream"})
    
    local msgLen = self.pos
    local padLen = 56 - msgLen % 64

    if msgLen % 64 > 56 then
        padLen = padLen + 64
    end

    if padLen == 0 then
        padLen = 64
    end

    local str = string.char(128) .. string.rep(string.char(0), padLen - 1) .. lei2str(bit.band(8 * msgLen, 0xFFFFFFFF)) .. lei2str(math.floor(msgLen / 0x20000000))
    md5_update(self, str)

    assert(self.pos % 64 == 0)
    return lei2str(self.a) .. lei2str(self.b) .. lei2str(self.c) .. lei2str(self.d)
end

----------------------------------------------------------------

-- MD5 encryption library
sm.scrapcomputers.md5 = {}

---Creates a MD5 Stream
---@return MD5Stream
function sm.scrapcomputers.md5.new()
    return {
        a = CONSTS[65],
        b = CONSTS[66],
        c = CONSTS[67],
        d = CONSTS[68],
        pos = 0,
        buf = '',
        update = md5_update,
        finish = md5_finish,
}
end

---Converts raw bytes to hex
---@param rawBytes string The raw bytes
---@return string hexData The data in hex
function sm.scrapcomputers.md5.tohex(rawBytes)
    sm.scrapcomputers.errorHandler.assertArgument(rawBytes, nil, {"string"})

    return string.format("%08x%08x%08x%08x", str2bei(string.sub(rawBytes, 1, 4)), str2bei(string.sub(rawBytes, 5, 8)), str2bei(string.sub(rawBytes, 9, 12)), str2bei(string.sub(rawBytes, 13, 16)))
end

---Converts a string to a MD5 string
---@param str string The string to convert to MD5
---@return string md5Data The data in MD5
function sm.scrapcomputers.md5.sum(str)
    sm.scrapcomputers.errorHandler.assertArgument(str, nil, {"string"})

    return sm.scrapcomputers.md5.new():update(str):finish()
end

---Converts a string to a MD5 string (In hex)
---@param str string The string to convert to MD5
---@return string md5hexData The data in MD5
function sm.scrapcomputers.md5.sumhexa(str)
    sm.scrapcomputers.errorHandler.assertArgument(str, nil, {"string"})

    return sm.scrapcomputers.md5.tohex(sm.scrapcomputers.md5.sum(str))
end