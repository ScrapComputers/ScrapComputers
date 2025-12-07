TextCodec = {}

function TextCodec:encode(data, isEncrypted, password)
    local isBytecode = data:sub(1, 4) == "\27Lua"
    if not isBytecode then
        data = sm.scrapcomputers.keywordCompression.compress(data)
    end

    if isEncrypted then
        data = sm.scrapcomputers.aes256.encrypt(password, data)
    end

    return sm.scrapcomputers.base91.encode(data)
end

function TextCodec:decode(data, isEncrypted, password)
    local data = sm.scrapcomputers.base91.decode(data)
    if isEncrypted then
        data = sm.scrapcomputers.aes256.decrypt(password, data)
    end

    if data:sub(1, 4) ~= "\x1bKWC" then
        return data
    end

    return sm.scrapcomputers.keywordCompression.decompress(data)
end