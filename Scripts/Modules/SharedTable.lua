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
    SharedTableShapeClass.sv_sc_st_storedSharedTables = {} ---@type SharedTable.Internal.ProxyData[]
    SharedTableShapeClass.cl_sc_st_storedSharedTables = {} ---@type SharedTable.Internal.ProxyData[]
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
        classInstance = classInstance,

        clientPath = clientPath,
        data = {},
        syncingEnabled = true,
        id = getNewId(classInstance),

        replicationTable = {},
        tblHash = {},
    }
    
    proxyData.idText = tostring(proxyData.id)

    ---@class SharedTable.Internal.Metatable
    local metatable = {
        __sc_st_proxyData = proxyData,
 
        __index = function (tbl, key)
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
    table.insert(classInstance.sv_sc_st_storedSharedTables, proxyData)

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

    for _, proxyData in pairs(storedSharedTables) do
        if sm.scrapcomputers.table.getTableSize(proxyData.replicationTable) ~= 0 then
            local jsonStr = sm.scrapcomputers.json.toString(proxyData.replicationTable, true, false)
            local packets = splitStringForNetworking(jsonStr)
            
            for i, packet in pairs(packets) do
                classInstance.network[networkSendToEventName](classInstance.network, networkEventName, {id = proxyData.id, data = packet, isEnd = i == #packets})
            end

            if classInstance[onSharedTableChangeName] then
                for key, value in pairs(proxyData.replicationTable) do
                    classInstance[onSharedTableChangeName](classInstance, proxyData.id, key, value, true, nil)
                end
            end

            proxyData.replicationTable = {}
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
            classInstance = classInstance,

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

        table.insert(classInstance.cl_sc_st_storedSharedTables, proxyData)
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

        local proxyData = nil ---@type SharedTable.Internal.ProxyData?
        for _, value in pairs(classInstance.cl_sc_st_storedSharedTables) do
            if value.id == data.id then
                proxyData = value
                break
            end
        end

        if not proxyData then
            sm.scrapcomputers.logger.warn( "SharedTable.lua", "Desync warning on \"" .. CLIENT_ON_PACKET_DATA .. "\"! Failed to sync SharedTable(" .. tostring(data.id) .. ") as it wasen't found in the class.")
            return
        end

        -- HACK: We should TRANSFER shit per server_onSharedTableChange call! This is makes more sense but means computer fixing but eh idfc stfu.

        local parsedBuffer = sm.json.parseJsonString(buffer)
        sm.scrapcomputers.table.transferTable(proxyData.data, parsedBuffer)

        if classInstance.client_onSharedTableChange then
            for key, value in pairs(parsedBuffer) do
                classInstance.client_onSharedTableChange(classInstance, proxyData.id, key, value, false, sm.localPlayer.getPlayer())
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

        for _, proxyData in pairs(classInstance.sv_sc_st_storedSharedTables) do
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
        local proxyData = nil ---@type SharedTable.Internal.ProxyData?
        for _, proxyData in pairs(classInstance.sv_sc_st_storedSharedTables) do
            if proxyData.id == id then
                proxyData = proxyData
                break
            end
        end

        if not proxyData then
            return
        end

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
    classInstance[SERVER_ON_PACKET_DATA] = function (_, data, player)
        if classInstance.server_onSharedTableEventReceived then
            local allowed = classInstance:server_onSharedTableEventReceived(data, player)
            if type(allowed) == "boolean" and allowed == false then
                return
            end
        end

        local buffer = classInstance.sv_sc_st_buffers[data.id] or ""
        buffer = buffer .. data.data

        if not data.isEnd then
            classInstance.sv_sc_st_buffers[data.id] = buffer
            return
        end

        classInstance.sv_sc_st_buffers[data.id] = nil

        local proxyData = nil ---@type SharedTable.Internal.ProxyData?
        for _, value in pairs(classInstance.sv_sc_st_storedSharedTables) do
            if value.id == data.id then
                proxyData = value
                break
            end
        end

        if not proxyData then
            sm.scrapcomputers.logger.warn( "SharedTable.lua", "Desync warning on \"" .. SERVER_ON_PACKET_DATA .. "\"! Failed to sync SharedTable(" .. tostring(data.id) .. ") as it wasn't found in the class.")
            return
        end

        -- We cant do the same as the client's on shared table change function.
        -- We need to go through all modifiers in buffer and call server_onSharedTableChange first, then we check if it:
        --      - returns a boolean, if so then check if it has returned true. If true, we allow the modification. if
        --        not, the client can fuck off.
        --      - returns nil, we will do a "trust me bro"

        -- HACK: We should TRANSFER shit per server_onSharedTableChange call! This is makes more sense but means computer fixing but eh idfc stfu.

        local parsedBuffer = sm.json.parseJsonString(buffer)
        local oldValues = {}
        for key, value in pairs(parsedBuffer) do
            oldValues[key] = proxyData.data[value]
        end

        sm.scrapcomputers.table.transferTable(proxyData.data, parsedBuffer)

        local revet
        if classInstance.server_onSharedTableChange then
            for key, value in pairs(parsedBuffer) do
                local allowed = classInstance:server_onSharedTableChange(proxyData.id, key, value, false, player)
                if type(allowed) == "boolean" and allowed == false then
                    proxyData.data[key] = oldValues[key]
                end
            end
        end

        for _, proxyData in pairs(classInstance.sv_sc_st_storedSharedTables) do
            if sm.scrapcomputers.table.getTableSize(proxyData.replicationTable) ~= 0 then
                local jsonStr = sm.scrapcomputers.json.toString(sm.scrapcomputers.json.toJsonCompatibleTable(sm.scrapcomputers.table.clone(proxyData.data)), true, false)
                local packets = splitStringForNetworking(jsonStr)

                for i, packet in pairs(packets) do
                    classInstance.network:sendToClients(CLIENT_ON_PACKET_DATA, {id = proxyData.id, data = packet, isEnd = i == #packets})
                end

                proxyData.replicationTable = {}
            end
        end
    end
end

---Forcefully syncs a SharedTable, This is needed if the SharedTable conatins inner-tables!
---Can be network expensive because it sends all values over the network!
---
---Use forceSyncProperty if you are just modifing 1 variable
---@param sharedTable SharedTable The shared table to sync
function sm.scrapcomputers.sharedTable:forceSync(sharedTable)
    local metatable = sm.scrapcomputers.util.getmetatable(sharedTable) ---@type SharedTable.Internal.Metatable
    local proxyData = metatable.__sc_st_proxyData

    for key, value in pairs(proxyData.data) do
        proxyData.replicationTable[key] = value
    end
end

---Forecfully syncs a specific property at a SharedTable. This is needed if the SharedTable conatins inner-tables!
---@param sharedTable SharedTable The shared table to sync
---@param propertyIndex string The property to snyc
function sm.scrapcomputers.sharedTable:forceSyncProperty(sharedTable, propertyIndex)
    local metatable = sm.scrapcomputers.util.getmetatable(sharedTable) ---@type SharedTable.Internal.Metatable
    local proxyData = metatable.__sc_st_proxyData
    
    proxyData.replicationTable[propertyIndex] = proxyData.data[propertyIndex]
end

---Gets the id of the SharedTable
---@param sharedTable SharedTable The shared table to sync
---@return integer id The id of the table
function sm.scrapcomputers.sharedTable:getSharedTableId(sharedTable)
    local metatable = sm.scrapcomputers.util.getmetatable(sharedTable) ---@type SharedTable.Internal.Metatable
    return metatable.__sc_st_proxyData.id
end

---Gets the raw contents of a SharedTable. (Without metamethods)
---
---Any modifications applied to the output will NOT be applied to the main shared table!
---@param sharedTable SharedTable The shared table
---@return table rawContents The raw contents of the shared table.
function sm.scrapcomputers.sharedTable:getRawContents(sharedTable)
    local metatable = sm.scrapcomputers.util.getmetatable(sharedTable) ---@type SharedTable.Internal.Metatable
    return unpack({metatable.__sc_st_proxyData.data})
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