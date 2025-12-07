local sm_scrapcomputers_errorHandler_assertArgument = sm.scrapcomputers.errorHandler.assertArgument

local bit_bor    = bit.bor
local bit_band   = bit.band
local bit_rshift = bit.rshift
local bit_lshift = bit.lshift

local string_byte = string.byte
local string_char = string.char
local string_sub  = string.sub

local math_floor = math.floor

local table_concat = table.concat

sm.scrapcomputers.base91 = {}

local b91EncodeTable     = {}
local b91DecodeTable     = {}

local function precomputateTables()
    local alphabet = [[ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789!#$%&()*+,./:;<=>?@[]^_`{|}~"]]
    for i = 1, #alphabet do
        local char = alphabet:sub(i, i)
        b91EncodeTable[i - 1] = char
        b91DecodeTable[char] = i - 1
    end
end

precomputateTables()

---Encodes a string to base91
---@param data string
---@return string
function sm.scrapcomputers.base91.encode(data)
    sm_scrapcomputers_errorHandler_assertArgument(data, nil, {"string"})

    local output = {}
    local c = 1

    local counter = 0
    local numBits = 0

    for i = 1, #data do
        counter = bit_bor(counter, bit_lshift(string_byte(data, i), numBits))
        numBits = numBits + 8
        if numBits > 13 then
            local entry = bit_band(counter, 8191) -- 2^13-1 = 8191
            if entry > 88 then                    -- Voodoo magic (https://www.reddit.com/r/learnprogramming/comments/8sbb3v/understanding_base91_encoding/e0y85ot/)
                counter = bit_rshift(counter, 13)
                numBits = numBits - 13
            else
                entry = bit_band(counter, 16383) -- 2^14-1 = 16383
                counter = bit_rshift(counter, 14)
                numBits = numBits - 14
            end
            output[c] = b91EncodeTable[entry % 91] .. b91EncodeTable[math_floor(entry / 91)]
            c = c + 1
        end
    end

    if numBits > 0 then
        output[c] = b91EncodeTable[counter % 91]
        if numBits > 7 or counter > 90 then
            output[c + 1] = b91EncodeTable[math_floor(counter / 91)]
        end
    end

    return table_concat(output)
end

---Decodes a base91 string
---@param data string
---@return string
function sm.scrapcomputers.base91.decode(data)
    sm_scrapcomputers_errorHandler_assertArgument(data, nil, {"string"})

    local output = {}
    local c = 1

    local counter = 0
    local numBits = 0
    local entry = -1

    for i = 1, #data do
        if b91DecodeTable[string_sub(data, i, i)] then
            if entry == -1 then
                entry = b91DecodeTable[string_sub(data, i, i)]
            else
                entry = entry + b91DecodeTable[string_sub(data, i, i)] * 91
                counter = bit_bor(counter, bit_lshift(entry, numBits))
                if bit_band(entry, 8191) > 88 then
                    numBits = numBits + 13
                else
                    numBits = numBits + 14
                end

                while numBits > 7 do
                    output[c] = string_char(counter % 256)
                    c = c + 1
                    counter = bit_rshift(counter, 8)
                    numBits = numBits - 8
                end
                entry = -1
            end
        end
    end

    if entry ~= -1 then
        output[c] = string_char(bit_bor(counter, bit_lshift(entry, numBits)) % 256)
    end

    return table_concat(output)
end
