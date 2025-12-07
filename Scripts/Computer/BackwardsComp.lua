dofile("./TextCodec.lua")

BackwardsComp = {}

function BackwardsComp:UpdateStorage(data)
    local function updateStorage(data)
        if not data.version then
            -- Before version system!

            return updateStorage({
                version = 1,
                code = sm.scrapcomputers.base64.encode(sm.scrapcomputers.keywordCompression.compress(data.code)),
                alwaysOn = type(data.alwaysOn) == "boolean" and data.alwaysOn or false,
            })
        end

        if data.version == 1 then
            -- We need to convert all ##'s to #
            local decmpressedCode = sm.scrapcomputers.keywordCompression.decompress(sm.scrapcomputers.base64.decode(data.code))
            decmpressedCode = decmpressedCode:gsub("##", "#")
            
            return updateStorage({
                version = 2,
                filesystem = {
                    ["Main.lua"] = TextCodec:encode(decmpressedCode, false, nil)
                },
                cachedBytecode = {},
                cachedBytecodeIsInDebug = true,
                flags = {
                    alwaysOn = data.alwaysOn,
                    allowPrinting = true,
                    allowAlerts = true,
                    currentEnv = SCRAPCOMPUTERS_COMPUTER_CURRENT_ENV_FLAG["Default"],
                    isDebugCompilation = true,
                }
            })
        end

        if data.version == 2 then
            local clone = sm.scrapcomputers.table.clone(data)
            clone.version = 2.1
            clone.flags.simpleSyntax = false
            return updateStorage(clone)
        end

        if data.version == 2.1 then
            local clone = sm.scrapcomputers.table.clone(data)
            clone.version = 2.2
            clone.hashedPassword = ""
            return updateStorage(clone)
        end

        return data
    end
    
    local newData = updateStorage(data)

    return newData ~= data, newData
end