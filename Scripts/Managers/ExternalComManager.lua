-- Do not remove smJsonSucks properties. Its so that simdjson (SM json parser) doesnt
-- make the entire fucking parent table become null if other values are all null. Its
-- so that it doesnt fuck up anything and reduces the amount of code checking required.
--
-- Who the fuck thought that empty arrays/dictionaries should become null was a good idea?

---@class ComJsonFile
---@field channels table<string, ComJsonFile.Channel> -- Channels are keyed by SHA-256 identifier
---@field globalChannel ComJsonFile.Channel

---@class ComJsonFile.Channel
---@field modPackets ComJsonFile.Packet[]
---@field softPackets ComJsonFile.Packet[]

---@class ComJsonFile.Packet
---@field id integer
---@field data string|table

sm.scrapcomputers.externalCommunicator = {}
local jsonPath = sm.scrapcomputers.jsonFiles.ExternalSoftwareComminucation

---@type ComJsonFile
---@diagnostic disable-next-line: missing-fields
local cachedData = {}
local dataChanged = false
local firstRead = false

local function createMissingData(data)
    local data = data or {}
    data.channels = data.channels or {smJsonSucks = true}
    data.globalChannel = data.globalChannel or {}
    data.globalChannel.modPackets = data.globalChannel.modPackets or {
        {
            smJsonSucks = true,
            id = -1,
            data = ""
        }
    }
    data.globalChannel.softPackets = data.globalChannel.softPackets or {
        {
            smJsonSucks = true,
            id = -1,
            data = ""
        }
    }

    return data
end

function sm.scrapcomputers.externalCommunicator.loadChanges()
    if not firstRead and not dataChanged then return end
    firstRead = true

    for index = 1, 10 do
        local success, data = pcall(sm.json.open, jsonPath)
        if success then
            cachedData = createMissingData(data)
            return
        end

        local endClock = os.clock() + 1
        while os.clock() < endClock do end

        sm.scrapcomputers.logger.warn("ExternalComManager.lua", "Failed to open JSON file, trying again. (" .. tostring(index) .. "/10)")
    end

    sm.scrapcomputers.logger.fatal("ExternalComManager.lua", "Failed to open JSON file. Not trying again (Exceeded the number of tries)")
    error("Failed to open JSON file!")
end

function sm.scrapcomputers.externalCommunicator.saveChanges()
    if not dataChanged then return end

    for index = 1, 10 do
        local success, err = pcall(sm.json.save, cachedData, jsonPath)
        if success then
            return
        end

        local endClock = os.clock() + 1
        while os.clock() < endClock do end

        sm.scrapcomputers.logger.warn("ExternalComManager.lua", "Failed to save JSON file, trying again. (" .. tostring(index) .. "/10) Error: " .. err)
    end

    sm.scrapcomputers.logger.fatal("ExternalComManager.lua", "Failed to save JSON file. Not trying again (Exceeded the number of tries)")
    error("Failed to save JSON file!")
end

---------------------------------------------------------------------------------------------------------------------------------------

function sm.scrapcomputers.externalCommunicator.readGlobalPacket()
    if not cachedData.globalChannel or not cachedData.globalChannel.softPackets or #cachedData.globalChannel.softPackets == 1 then return end

    local packet = table.remove(cachedData.globalChannel.softPackets, 2) -- Do not change to 1 pos. First packet should always be the packet to not make the fucking table become null!
    if packet then
        dataChanged = true

        local success, jsonData = pcall(sm.json.parseJsonString, packet.data)
        if success then
            packet.data = jsonData
        end
    end

    return packet
end

---@param packetId integer
---@param data string|table
function sm.scrapcomputers.externalCommunicator.writeGlobalPacket(packetId, data)
    local inputData = data

    if type(data) == "table" then
        inputData = sm.scrapcomputers.json.toString(data, true, false)
    end
    
    local packet = table.insert(cachedData.globalChannel.modPackets, {id = packetId, data = inputData})
    if packet then
        dataChanged = true
    end
end

---------------------------------------------------------------------------------------------------------------------------------------

---@param channelId string
function sm.scrapcomputers.externalCommunicator.readChannelPacket(channelId)
    if not cachedData.channels or not cachedData.channels[channelId] or not cachedData.channels[channelId].softPackets or #cachedData.channels[channelId].softPackets == 1 then return end

    local packet = table.remove(cachedData.channels[channelId].softPackets, 2) -- Do not change to 1 pos. First packet should always be the packet to not make the fucking table become null!
    if packet then
        dataChanged = true

        local success, jsonData = pcall(sm.json.parseJsonString, packet.data)
        if success then
            packet.data = jsonData
        end
    end

    return packet
end

---@param channelId string
---@param packetId integer
---@param data string|table
function sm.scrapcomputers.externalCommunicator.writeChannelPacket(channelId, packetId, data)
    local inputData = data

    if type(data) == "table" then
        inputData = sm.scrapcomputers.json.toString(data, true, false)
    end
    
    local packet = table.insert(cachedData.channels[channelId].modPackets, {id = packetId, data = inputData})
    if packet then
        dataChanged = true
    end
end

---------------------------------------------------------------------------------------------------------------------------------------

function sm.scrapcomputers.externalCommunicator.createChannel()
    local channelId = sm.scrapcomputers.sha256.random()
    cachedData.channels[channelId] = {
        simdjsonSucks = true,
        modPackets = {
            {
                smJsonSucks = true,
                id = -1,
                data = ""
            }
        },
        softPackets = {
            {
                smJsonSucks = true,
                id = -1,
                data = ""
            }
        },
        timeSinceLastPing = -1
    }
    dataChanged = true

    return channelId
end

function sm.scrapcomputers.externalCommunicator.destroyChannel(channelId)
    cachedData.channels[channelId] = nil
    dataChanged = true
end

function sm.scrapcomputers.externalCommunicator.getChannelIds()
    if not cachedData.channels then return {} end
    
    local output = {}
    for channelId, value in pairs(cachedData.channels) do
        if type(value) == "table" then
            table.insert(output, channelId)
        end
    end

    return output
end

function sm.scrapcomputers.externalCommunicator.getChannel(channelId)
    return cachedData.channels[channelId]
end

---------------------------------------------------------------------------------------------------------------------------------------

function sm.scrapcomputers.externalCommunicator.clearContents()
    cachedData = createMissingData()
    dataChanged = true
    sm.scrapcomputers.externalCommunicator.saveChanges()
end

---------------------------------------------------------------------------------------------------------------------------------------

function sm.scrapcomputers.externalCommunicator.init()
    sm.scrapcomputers.externalCommunicator.clearContents()
end

function sm.scrapcomputers.externalCommunicator.tick()
    sm.scrapcomputers.externalCommunicator.loadChanges()

    local packet = sm.scrapcomputers.externalCommunicator.readGlobalPacket()
    if packet then
        if packet.id == 1 then -- NEW CHANNEL PACKET
            local channelId = sm.scrapcomputers.externalCommunicator.createChannel()

            sm.scrapcomputers.externalCommunicator.writeGlobalPacket(2, channelId)
			sm.scrapcomputers.logger.info("ExternalComManager.lua", "New channel created! ID=\"" .. channelId .. "\"")
        end
    end

    for _, channelId in pairs(sm.scrapcomputers.externalCommunicator.getChannelIds()) do
        local packet = sm.scrapcomputers.externalCommunicator.readChannelPacket(channelId)
        local channel = sm.scrapcomputers.externalCommunicator.getChannel(channelId)
        
        if packet then
            if packet.id == 3 then -- PING PACKET
                channel.timeSinceLastPing = os.clock()

                sm.scrapcomputers.externalCommunicator.writeChannelPacket(channelId, 4, "")
            elseif packet.id == 5 then -- DISCONNECT PACKET
                sm.scrapcomputers.externalCommunicator.destroyChannel(channelId)
				sm.scrapcomputers.logger.info("ExternalComManager.lua", "Channel \"" .. channelId .. "\" has been closed!")
            elseif packet.id == 6 then -- GET COMPUTERS PACKET
                sm.scrapcomputers.externalCommunicator.writeChannelPacket(channelId, 6, sm.scrapcomputers.dataList["Computers"])
            end
        end

        if channel.timeSinceLastPing ~= -1 and os.clock() - channel.timeSinceLastPing > 5 then
            sm.scrapcomputers.externalCommunicator.destroyChannel(channelId)
			sm.scrapcomputers.logger.warn("ExternalComManager.lua", "Channel \"" .. channelId .. "\" has been closed! (Could not comminucate!)")
        end
    end

    sm.scrapcomputers.externalCommunicator.saveChanges()
end