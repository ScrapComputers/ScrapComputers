---@alias SharedTable.Internal.StoredSharedTableContent {proxy: table, proxyData: SharedTable.Internal.ProxyData, metatable: SharedTable.Internal.Metatable}}
---@alias SharedTable table

sm.scrapcomputers.sharedTable = {}

local CLIENT_ON_PACKET_DATA = "cl_sc_st_onPacketData"
local SERVER_ON_PACKET_DATA = "sv_sc_st_onPacketData"

local CLIENT_CREATE_SHAREDTABLE = "cl_sc_st_createSharedTable"

local SERVER_ASK_FOR_FULL_SYNC = "sv_sc_st_requestFullSync"
local SERVER_ASK_FOR_TABLE_SYNC = "sv_sc_st_requestSpecficSTSync"

local SYNCING_ENABLED_KEY = "SCRAPCOMPUTERS_SHARED_TABLE_SYNCING_ENABLED"

local PACKET_SIZE_LIMIT = 65000 -- Used for splitting, actual packet limit is 65437 however to play it safe we round it.

if false then
    ---@class SharedTable.ShapeClass : ShapeClass
    local SharedTableShapeClass = {}
    SharedTableShapeClass.sv_sc_st_storedSharedTables = {} ---@type SharedTable.Internal.StoredSharedTableContent[]
    SharedTableShapeClass.cl_sc_st_storedSharedTables = {} ---@type SharedTable.Internal.StoredSharedTableContent[]
end

local function getNewId(classInstance)
    classInstance.__sv_sc_st_idCounter = (classInstance.__sv_sc_st_idCounter or 0) + 1
    return classInstance.__sv_sc_st_idCounter
end

local function splitStringForNetworking(str)
    return sm.scrapcomputers.string.splitString(str, PACKET_SIZE_LIMIT)
end

--- Creates a new shared table (server-side)
---@param classInstance SharedTable.ShapeClass The class instance (aka self for class)
---@param clientPath string The path on the client to store the shared table
---@return SharedTable
function sm.scrapcomputers.sharedTable:new(classInstance, clientPath)
    sm.scrapcomputers.errorHandler.assert(sm.isServerMode(), nil, "Sandbox violation! Running a server function in a client-side VM!")

    ---@class SharedTable.Internal.ProxyData
    local proxyData = {
        clientPath = clientPath,
        data = {},
        syncingEnabled = true,
        id = getNewId(classInstance),

        replicationTable = {},
        tblHash = {}
    }

    proxyData.idText = tostring(proxyData.id)

    ---@class SharedTable.Internal.Metatable
    local metatable = {
        __sc_st_proxyData = proxyData,
 
        __index = function (_, key)
            if key == SYNCING_ENABLED_KEY then
                return proxyData.syncingEnabled
            end

            return proxyData.data[key]
        end,

        __newindex = function (_, key, value)
            if key == SYNCING_ENABLED_KEY then
                proxyData.syncingEnabled = value
                return
            end

            proxyData.data[key] = value

            if not proxyData.syncingEnabled then return end

            if not value then
                proxyData.replicationTable[key] = value
                proxyData.tblHash[key] = nil
                return
            end

            if type(value) == "table" then
                local valueHash = sm.scrapcomputers.table.hashTable(value)
                local tableHash = proxyData.tblHash[key]

                if valueHash == tableHash then
                    -- No change was made for the table! Dont replicate!
                    return
                end

                proxyData.tblHash[key] = valueHash
            end

            proxyData.replicationTable[key] = value
        end
    }

    local proxy = sm.scrapcomputers.util.setmetatable(proxyData.data, metatable)
    table.insert(classInstance.sv_sc_st_storedSharedTables, {proxy = proxy, proxyData = proxyData, metatable = metatable})

    return proxy
end

--- Runs a tick for SharedTables
---@param classInstance SharedTable.ShapeClass The class instance (aka self for class)
function sm.scrapcomputers.sharedTable:runTick(classInstance)
    local isServerMode = sm.isServerMode()

    local storedSharedTables      = isServerMode and classInstance.sv_sc_st_storedSharedTables or classInstance.cl_sc_st_storedSharedTables

    local onSharedTableChangeName = isServerMode and "server_onSharedTableChange" or "client_onSharedTableChange"
    local networkSendToEventName  = isServerMode and "sendToClients"              or "sendToServer"
    local networkEventName        = isServerMode and CLIENT_ON_PACKET_DATA        or SERVER_ON_PACKET_DATA

    for _, sharedTable in pairs(storedSharedTables) do
        local replicationTable = sharedTable.proxyData.replicationTable
        if sm.scrapcomputers.table.getTableSize(replicationTable) ~= 0 then
            local jsonStr = sm.scrapcomputers.json.toString(replicationTable, true, false)
            local packets = splitStringForNetworking(jsonStr)
            for i, packet in pairs(packets) do
                classInstance.network[networkSendToEventName](classInstance.network, networkEventName, {id = sharedTable.proxyData.id, data = packet, isEnd = i == #packets})
            end

            if classInstance[onSharedTableChangeName] then
                for key, value in pairs(replicationTable) do
                    classInstance[onSharedTableChangeName](classInstance, sharedTable.proxyData.id, key, value, true)
                end
            end

            sharedTable.proxyData.replicationTable = {}
        end
    end
end

--- Initializes for shared tables to be used
---@param classInstance ShapeClass The class instance (aka self for class)
function sm.scrapcomputers.sharedTable:init(classInstance)
    if sm.isServerMode() then
        sm.scrapcomputers.sharedTable:initServer(classInstance)
    else
        sm.scrapcomputers.sharedTable:initClient(classInstance)
    end
end

--- Initializes for shared tables to be used (Client)
---@param classInstance ShapeClass The class instance (aka self for class)
function sm.scrapcomputers.sharedTable:initClient(classInstance)
    classInstance.cl_sc_st_storedSharedTables = {}

    classInstance.network:sendToServer(SERVER_ASK_FOR_FULL_SYNC)

    ---@param data {id: integer, clientPath: string}
    classInstance[CLIENT_CREATE_SHAREDTABLE] = function (_, data)        
        local pathParts = {}
        for part in data.clientPath:gmatch("[^%.]+") do
            table.insert(pathParts, part)
        end

        local variableName = table.remove(pathParts)
        table.remove(pathParts, 1)
        
        local currentTbl = classInstance
        for _, part in pairs(pathParts) do
            local value = currentTbl[part]
            if value then
                currentTbl = value
            else
                local newTbl =  {}
                currentTbl[part] = newTbl
                currentTbl = currentTbl[part]
            end
        end
        
        ---@type SharedTable.Internal.ProxyData
        local proxyData = {
            clientPath = data.clientPath,
            data = {},
            syncingEnabled = true,
            id = data.id,
            tblHash = {},

            replicationTable = {}
        }

        proxyData.idText = tostring(proxyData.id)

        local metatable = {
            __sc_st_proxyData = proxyData,

            __index = function (_, key)
                if key == SYNCING_ENABLED_KEY then
                    return proxyData.syncingEnabled
                end

                return proxyData.data[key]
            end,

            __newindex = function (_, key, value)
                if key == SYNCING_ENABLED_KEY then
                    proxyData.syncingEnabled = value
                    return
                end

                proxyData.data[key] = value

                if not proxyData.syncingEnabled then return end

                if type(value) == "table" then
                    local valueHash = sm.scrapcomputers.table.hashTable(value)
                    local tableHash = proxyData.tblHash[key]

                    if valueHash == tableHash then
                        -- No change was made for the table! Dont replicate!
                        return
                    end

                    proxyData.tblHash[key] = valueHash
                end

                proxyData.replicationTable[key] = value
            end
        }

        local proxy = sm.scrapcomputers.util.setmetatable(proxyData.data, metatable)
        currentTbl[variableName] = proxy

        table.insert(classInstance.cl_sc_st_storedSharedTables, {proxy = proxy, proxyData = proxyData, metatable = metatable})
    end

    classInstance.cl_sc_st_buffers = {}

    ---@param data {id: integer, isEnd: boolean, data: string}
    classInstance[CLIENT_ON_PACKET_DATA] = function (_, data)
        local buffer = classInstance.cl_sc_st_buffers[data.id] or ""
        buffer = buffer .. data.data

        if not data.isEnd then
            classInstance.cl_sc_st_buffers[data.id] = buffer
            return
        end

        classInstance.cl_sc_st_buffers[data.id] = nil

        local sharedTable = nil ---@type SharedTable.Internal.StoredSharedTableContent?
        for _, value in pairs(classInstance.cl_sc_st_storedSharedTables) do
            if value.proxyData.id == data.id then
                sharedTable = value
                break
            end
        end

        if not sharedTable then
            sm.scrapcomputers.logger.warn( "SharedTable.lua", "Desync warning on \"" .. CLIENT_ON_PACKET_DATA .. "\"! Failed to sync SharedTable(" .. tostring(data.id) .. ") as it wasen't found in the class.")
            return
        end

        local parsedBuffer = sm.json.parseJsonString(buffer)
        sm.scrapcomputers.table.transferTable(sharedTable.proxyData.data, parsedBuffer)

        if classInstance.client_onSharedTableChange then
            for key, value in pairs(parsedBuffer) do
                classInstance.client_onSharedTableChange(classInstance, sharedTable.proxyData.id, key, value, false)
            end
        end
    end
end

--- Initializes for shared tables to be used (Server)
---@param classInstance ShapeClass The class instance (aka self for class)
function sm.scrapcomputers.sharedTable:initServer(classInstance)
    classInstance.sv_sc_st_storedSharedTables = {}

    ---@param _ nil
    ---@param player Player
    classInstance[SERVER_ASK_FOR_FULL_SYNC] = function (_, _, player)
        local callbacks = {} ---@type function[]

        for _, data in pairs(classInstance.sv_sc_st_storedSharedTables) do
            local proxyData = data.proxyData
            local rawData = sm.scrapcomputers.json.toJsonCompatibleTable(sm.scrapcomputers.table.clone(proxyData.data))

            classInstance.network:sendToClient(player, CLIENT_CREATE_SHAREDTABLE, {id = proxyData.id, clientPath = proxyData.clientPath})

            local jsonStr = sm.scrapcomputers.json.toString(rawData, true, false)
            local packets = splitStringForNetworking(jsonStr)
            
            if sm.scrapcomputers.table.getTableSize(rawData) ~= 0 then
                local function callback()
                    for i, packet in pairs(packets) do
                        classInstance.network:sendToClient(player, CLIENT_ON_PACKET_DATA, {id = proxyData.id, data = packet, isEnd = i == #packets})
                    end
                end

                table.insert(callbacks, callback)
            end
        end

        for _, callback in pairs(callbacks) do
            callback()
        end
    end

    ---@param id integer
    ---@param player Player
    classInstance[SERVER_ASK_FOR_TABLE_SYNC] = function (_, id, player)
        local data = nil ---@type SharedTable.Internal.StoredSharedTableContent?
        for _, value in pairs(classInstance.sv_sc_st_storedSharedTables) do
            if value.proxyData.id == id then
                data = value
                break
            end
        end

        if not data then
            sm.scrapcomputers.logger.warn( "SharedTable.lua", "Desync warning on \"" .. SERVER_ASK_FOR_TABLE_SYNC .. "\"! Failed to sync SharedTable(" .. tostring(data.id) .. ") for player " .. tostring(player) .. " as it wasen't found in the class.")
            return
        end

        local proxyData = data.proxyData

        local rawData = sm.scrapcomputers.json.toJsonCompatibleTable(sm.scrapcomputers.table.clone(proxyData.data))
        local jsonStr = sm.scrapcomputers.json.toString(rawData, true, false)
        local packets = splitStringForNetworking(jsonStr)
        
        if sm.scrapcomputers.table.getTableSize(rawData) ~= 0 then
            for i, packet in pairs(packets) do
                classInstance.network:sendToClient(player, CLIENT_ON_PACKET_DATA, {id = proxyData.id, data = packet, isEnd = i == #packets})
            end
        end
    end

    classInstance.sv_sc_st_buffers = {}

    ---@param data {id: integer, isEnd: boolean, data: string}
    classInstance[SERVER_ON_PACKET_DATA] = function (_, data)
        local buffer = classInstance.sv_sc_st_buffers[data.id] or ""
        buffer = buffer .. data.data

        if not data.isEnd then
            classInstance.sv_sc_st_buffers[data.id] = buffer
            return
        end

        classInstance.sv_sc_st_buffers[data.id] = nil

        local sharedTable = nil ---@type SharedTable.Internal.StoredSharedTableContent?
        for _, value in pairs(classInstance.sv_sc_st_storedSharedTables) do
            if value.proxyData.id == data.id then
                sharedTable = value
                break
            end
        end

        if not sharedTable then
            sm.scrapcomputers.logger.warn( "SharedTable.lua", "Desync warning on \"" .. SERVER_ON_PACKET_DATA .. "\"! Failed to sync SharedTable(" .. tostring(data.id) .. ") as it wasen't found in the class.")
            return
        end

        local parsedBuffer = sm.json.parseJsonString(buffer)
        sm.scrapcomputers.table.transferTable(sharedTable.proxyData.data, parsedBuffer)

        if classInstance.server_onSharedTableChange then
            for key, value in pairs(parsedBuffer) do
                classInstance:server_onSharedTableChange(sharedTable.proxyData.id, key, value, false)
            end
        end
    end
end

---Forcefully syncs a SharedTable, This is needed if the SharedTable conatins inner-tables!
---Can be network expensive because it sends all values over the network!
---
---Use forceSyncProperty if you are just modifing 1 variable
---@param sharedTable SharedTable
function sm.scrapcomputers.sharedTable:forceSync(sharedTable)
    local metatable = sm.scrapcomputers.util.getmetatable(sharedTable) ---@type SharedTable.Internal.Metatable
    local proxyData = metatable.__sc_st_proxyData

    for key, value in pairs(proxyData.data) do
        proxyData.replicationTable[key] = value
    end
end

---Forecfully syncs a specific property at a SharedTable. This is needed if the SharedTable conatins inner-tables!
function sm.scrapcomputers.sharedTable:forceSyncProperty(sharedTable, propertyIndex)
    local metatable = sm.scrapcomputers.util.getmetatable(sharedTable) ---@type SharedTable.Internal.Metatable
    local proxyData = metatable.__sc_st_proxyData
    
    proxyData.replicationTable[propertyIndex] = proxyData.data[propertyIndex]
end

---Gets the id of the SharedTable
---@param sharedTable SharedTable
---@return integer id The id of the table
function sm.scrapcomputers.sharedTable:getSharedTableId(sharedTable)
    local metatable = sm.scrapcomputers.util.getmetatable(sharedTable) ---@type SharedTable.Internal.Metatable
    return metatable.__sc_st_proxyData.id
end

---Gets the raw contents of a SharedTable. (Without metamethods)
---Only exists cause modifing __index for SOME reaosn causues any iteration (including the C api's one) to break.
---
---Any modifications applied to the output will NOT be applied to the main shared table!
---@param sharedTable SharedTable The shared table
---@return table rawContents The raw contents of the shared table.
function sm.scrapcomputers.sharedTable:getRawContents(sharedTable)
    local metatable = sm.scrapcomputers.util.getmetatable(sharedTable) ---@type SharedTable.Internal.Metatable
    return metatable.__sc_st_proxyData.data
end

---Disables syncing for a SharedTable.
---@param sharedTable SharedTable The shared table
function sm.scrapcomputers.sharedTable:disableSync(sharedTable)
    sharedTable[SYNCING_ENABLED_KEY] = false
end

---Enables syncing for a SharedTable.
---@param sharedTable SharedTable The shared table
function sm.scrapcomputers.sharedTable:enableSync(sharedTable)
    sharedTable[SYNCING_ENABLED_KEY] = true
end

---Returns wether the sharedTable has syncing enabled or not
---@param sharedTable SharedTable The shared table
function sm.scrapcomputers.sharedTable:isSyncingEnabled(sharedTable)
    return sharedTable[SYNCING_ENABLED_KEY]
end