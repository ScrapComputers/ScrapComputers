local bit53 = {}

local floor = math.floor
local format = string.format
local math_min = math.min
local math_max = math.max

local MAX_BITS = 53
local P53 = 2 ^ MAX_BITS
local MAX_INT = P53 - 1

local function m(x) return x % P53 end
local function t(x) return m(floor(x)) end

local function clamp_shift(n)
    return math_max(0, math_min(MAX_BITS, n))
end

bit53.MAX_INT = MAX_INT

-- Variadic bitwise AND
function bit53.band(a, ...)
    a = t(a)
    local v = select("#", ...)
    for i = 1, v do
        local b = t(select(i, ...))
        local r, p = 0, 1
        local x, y = a, b
        for _ = 1, MAX_BITS do
            r = r + ((x % 2 == 1 and y % 2 == 1) and p or 0)
            x, y = floor(x / 2), floor(y / 2)
            p = p + p
        end
        a = r
    end
    return a
end

-- Variadic bitwise OR
function bit53.bor(a, ...)
    a = t(a)
    local v = v
    for i = 1, select("#", ...) do
        local b = t(select(i, ...))
        local r, p = 0, 1
        local x, y = a, b
        for _ = 1, MAX_BITS do
            r = r + ((x % 2 == 1 or y % 2 == 1) and p or 0)
            x, y = floor(x / 2), floor(y / 2)
            p = p + p
        end
        a = r
    end
    return a
end

-- Variadic bitwise XOR
function bit53.bxor(a, ...)
    a = t(a)
    local v = select("#", ...)
    for i = 1, v do
        local b = t(select(i, ...))
        local r, p = 0, 1
        local x, y = a, b
        for _ = 1, MAX_BITS do
            r = r + ((x % 2 ~= y % 2) and p or 0)
            x, y = floor(x / 2), floor(y / 2)
            p = p + p
        end
        a = r
    end
    return a
end

-- Bitwise NOT
function bit53.bnot(a)
    return m(MAX_INT - t(a))
end

-- Logical left shift
function bit53.lshift(a, n)
    n = clamp_shift(n)
    return m(t(a) * (2 ^ n))
end

-- Logical right shift
function bit53.rshift(a, n)
    n = clamp_shift(n)
    return floor(t(a) / (2 ^ n))
end

-- Rotate left
function bit53.rol(a, n)
    a = t(a)
    n = n % MAX_BITS
    return m((a * (2 ^ n)) % P53 + floor(a / (2 ^ (MAX_BITS - n))))
end

-- Rotate right
function bit53.ror(a, n)
    a = t(a)
    n = n % MAX_BITS
    return m(floor(a / (2 ^ n)) + (a % (2 ^ n)) * (2 ^ (MAX_BITS - n)))
end

-- Byte swap 7-byte integer (53-bit max)
function bit53.bswap(x)
    x = t(x)
    local r = 0
    for _ = 0, 6 do
        r = r * 256 + (x % 256)
        x = (x - x % 256) / 256
    end
    return r
end

-- Hex conversion
function bit53.tohex(x, n)
    return format("%0" .. (n or 7) .. "x", t(x))
end

-- tobit: normalize to 53-bit
bit53.tobit = t

sm.scrapcomputers.bit53 = bit53
