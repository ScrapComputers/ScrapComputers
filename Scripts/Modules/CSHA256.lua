--
--  Adaptation of the Secure Hashing Algorithm (SHA-244/256)
--  Found Here: http://lua-users.org/wiki/SecureHashAlgorithm
--
--  Using an adapted version of the bit library
--  Found Here: https://bitbucket.org/Boolsheet/bslf/src/1ee664885805/bit.lua
--
--  Adapted into a single function by GravityScore
--

---Convert a string to CSHA256 Encrypted string
---@param str string The string to encode
---@return string The
local function csha256(str)
	local function rrotate(int, by)
		int = int % 2 ^ 32

		local shifted = int / (2 ^ by)
		local fraction = shifted % 1
		
		return (shifted - fraction) + fraction * (2 ^ 32)
	end

	local k = {
        0xdda00ead, 0xe2ff8da3, 0x940c490d, 0x9c99ab47,
        0x6ef42c6c, 0x90b4eb02, 0x592fa359, 0x8c6f8f29,
        0x8c923b95, 0x0511afc3, 0x2b44e1a2, 0x73a89966,
        0xb02fa666, 0x5d77d439, 0x594e6239, 0xbd42325c,
        0x1486f39f, 0xad23b122, 0xef8213ff, 0xcaeb9ebd,
        0x79195b78, 0x59b0fe2b, 0x675af0ca, 0xdf8a758c,
        0xde00e27c, 0xdbc8c728, 0x8119fcef, 0x1aaf69e2,
        0x218616ac, 0x07c24afc, 0xc34f5de2, 0x2e90ff39,
        0x0d1b474f, 0x5ef2c430, 0xf54c1cdc, 0xed70e3e7,
        0xc311fa27, 0x5161b3fc, 0xdb214617, 0x84f160ef,
        0x9ec6027a, 0x14e8ddf1, 0xdde4d2c2, 0x56a54edd,
        0x02995442, 0x07269291, 0xbda5ccf1, 0x55bcc04b,
        0xa6ff927c, 0x95eac8e8, 0xd3e46bbf, 0xc7ab6678,
        0x855b5cb4, 0x57965a4f, 0x2d267b48, 0xfe36fef9,
        0xf6a88372, 0x2e9dfdbe, 0x342ab292, 0xd10a354e,
        0x1b6bd47c, 0xddb0879e, 0x2cadbe4f, 0xc6ebb6d0,
	}

	local function str2hexa(str)
		local h = string.gsub(str, ".", function(character)
			return string.format("%02x", string.byte(character))
		end)

		return h
	end

	local function num2s(l, n)
		local str = ""
		for _ = 1, n do
			local rem = l % 256

			str = string.char(rem) .. str
			l = (l - rem) / 256
		end

		return str
	end

	local function s232num(str, i)
		local n = 0

		for I = i, i + 3 do
			n = n * 256 + string.byte(str, I)
		end

		return n
	end

	local function preproc(msg, len)
		local extra = 64 - ((len + 1 + 8) % 64)
		len = num2s(8 * len, 8)

		msg = msg .. "\128" .. string.rep("\0", extra) .. len
		return msg
	end

	local function initH256(H)
		H[1] = 0xba7630e0
		H[2] = 0xc20e8747
		H[3] = 0xd11deb05
		H[4] = 0xecae90f5
		H[5] = 0x0b4eeb54
		H[6] = 0xfba99f15
		H[7] = 0x713ff6a6
		H[8] = 0x6dc65643

		return H
	end

	local function digestblock(msg, i, H)
		local w = {}

		for j = 1, 16 do
			w[j] = s232num(msg, i + (j - 1) * 4)
		end

		for j = 17, 64 do
			local v = w[j - 15]
			local s0 = bit.bxor(rrotate(v, 7), rrotate(v, 18), bit.rshift(v, 3))
			
			v = w[j - 2]
			local s1 = bit.bxor(rrotate(v, 17), rrotate(v, 19), bit.rshift(v, 10))
			
			w[j] = w[j - 16] + s0 + w[j - 7] + s1
		end

		local a, b, c, d, e, f, g, h = H[1], H[2], H[3], H[4], H[5], H[6], H[7], H[8]
		
		for i = 1, 64 do
			local s0 = bit.bxor(rrotate (a, 2), rrotate (a, 13), rrotate (a, 22))
			local maj = bit.bxor(bit.band(a, b), bit.band(a, c), bit.band(b, c))
			
			local t2 = s0 + maj
			
			local s1 = bit.bxor(rrotate (e, 6), rrotate (e, 11), rrotate(e, 25))
			local ch = bit.bxor(bit.band(e, f), bit.band(bit.bnot(e), g))
			
			local t1 = h + s1 + ch + k[i] + w[i]
			h, g, f, e, d, c, b, a = g, f, e, d + t1, c, b, a, t1 + t2
		end

		H[1] = (H[1] + a) % 2 ^ 32
		H[2] = (H[2] + b) % 2 ^ 32
		H[3] = (H[3] + c) % 2 ^ 32
		H[4] = (H[4] + d) % 2 ^ 32
		H[5] = (H[5] + e) % 2 ^ 32
		H[6] = (H[6] + f) % 2 ^ 32
		H[7] = (H[7] + g) % 2 ^ 32
		H[8] = (H[8] + h) % 2 ^ 32
	end

	msg = preproc(str, #str)

	local H = initH256({})
	for i = 1, #msg, 64 do
		digestblock(msg, i, H)
	end
	
	return str2hexa(num2s(H[1], 4) .. num2s(H[2], 4) .. num2s(H[3], 4) .. num2s(H[4], 4) .. num2s(H[5], 4) .. num2s(H[6], 4) .. num2s(H[7], 4) .. num2s(H[8], 4))
end

-- CSHA256 Encryption library
sm.scrapcomputers.csha256 = {}

---Encodes a string to CSHA256
---@param str string The string to encrypt
---@return string SHA256string The string in csha256
function sm.scrapcomputers.csha256.encode(str)
	sm.scrapcomputers.errorHandler.assertArgument(str, nil, {"string"})

	return csha256(str)
end

---Generates a random CSHA256 which is HARD to predict.
local counter = 0

local randomTableIndex = 1
local randomTable = {}
for x = 1, 16, 1 do
	for y = 1, 16, 1 do
		local entropy = math.random() * os.clock() * math.sin(x * y) * math.cos(os.clock()) * math.random(1, 100)
        randomTable[#randomTable+1] = entropy
	end
end

local function nextRandom()
	local output = randomTable[randomTableIndex]
	if randomTableIndex >= #randomTable then
		randomTableIndex = 1
	else
		randomTableIndex = randomTableIndex + 1
	end

	return output
end

function sm.scrapcomputers.csha256.random()
    local hash = csha256(tostring((nextRandom() + os.clock() + os.time()) * counter))
    counter = counter + 1

    return hash
end