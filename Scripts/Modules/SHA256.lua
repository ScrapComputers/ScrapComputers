--
--  Adaptation of the Secure Hashing Algorithm (SHA-244/256)
--  Found Here: http://lua-users.org/wiki/SecureHashAlgorithm
--
--  Using an adapted version of the bit library
--  Found Here: https://bitbucket.org/Boolsheet/bslf/src/1ee664885805/bit.lua
--
--  Adapted into a single function by GravityScore
--

---Convert a string to SHA256 Encrypted string
---@param str string The string to encode
---@return string The
local function sha256(str)
	local function rrotate(int, by)
		int = int % 2 ^ 32

		local shifted = int / (2 ^ by)
		local fraction = shifted % 1
		
		return (shifted - fraction) + fraction * (2 ^ 32)
	end

	local k = {
		0x428a2f98, 0x71374491, 0xb5c0fbcf, 0xe9b5dba5,
		0x3956c25b, 0x59f111f1, 0x923f82a4, 0xab1c5ed5,
		0xd807aa98, 0x12835b01, 0x243185be, 0x550c7dc3,
		0x72be5d74, 0x80deb1fe, 0x9bdc06a7, 0xc19bf174,
		0xe49b69c1, 0xefbe4786, 0x0fc19dc6, 0x240ca1cc,
		0x2de92c6f, 0x4a7484aa, 0x5cb0a9dc, 0x76f988da,
		0x983e5152, 0xa831c66d, 0xb00327c8, 0xbf597fc7,
		0xc6e00bf3, 0xd5a79147, 0x06ca6351, 0x14292967,
		0x27b70a85, 0x2e1b2138, 0x4d2c6dfc, 0x53380d13,
		0x650a7354, 0x766a0abb, 0x81c2c92e, 0x92722c85,
		0xa2bfe8a1, 0xa81a664b, 0xc24b8b70, 0xc76c51a3,
		0xd192e819, 0xd6990624, 0xf40e3585, 0x106aa070,
		0x19a4c116, 0x1e376c08, 0x2748774c, 0x34b0bcb5,
		0x391c0cb3, 0x4ed8aa4a, 0x5b9cca4f, 0x682e6ff3,
		0x748f82ee, 0x78a5636f, 0x84c87814, 0x8cc70208,
		0x90befffa, 0xa4506ceb, 0xbef9a3f7, 0xc67178f2,
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
		H[1] = 0x6a09e667
		H[2] = 0xbb67ae85
		H[3] = 0x3c6ef372
		H[4] = 0xa54ff53a
		H[5] = 0x510e527f
		H[6] = 0x9b05688c
		H[7] = 0x1f83d9ab
		H[8] = 0x5be0cd19

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

-- SHA256 Encryption library
sm.scrapcomputers.sha256 = {}

---Encodes a string to SHA256
---@param str string The string to encrypt
---@return string SHA256string The string in sha256
function sm.scrapcomputers.sha256.encode(str)
	sm.scrapcomputers.errorHandler.assertArgument(str, nil, {"string"})

	return sha256(str)
end

---Generates a random SHA256 which is HARD to predict.
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

function sm.scrapcomputers.sha256.random()
    local hash = sha256(tostring((nextRandom() + os.clock() + os.time()) * counter))
    counter = counter + 1

    return hash
end