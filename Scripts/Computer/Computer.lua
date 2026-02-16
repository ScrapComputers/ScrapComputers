dofile("./CurrentEnvFlag.lua")
dofile("./BackwardsComp.lua")
dofile("./MemoryTracker.lua")
dofile("./TextCodec.lua")
dofile("./ErrorParser.lua")
dofile("./Filesystem.lua")
dofile("./PlayerOwnership.lua")

dofile("./LuaVM/LuaVM.lua")

---@class ComputerClass : ShapeClass
ComputerClass = class()
ComputerClass.maxParentCount = -1
ComputerClass.maxChildCount = -1
ComputerClass.connectionInput = sm.interactable.connectionType.logic + sm.interactable.connectionType.compositeIO + sm.interactable.connectionType.computerIO
ComputerClass.connectionOutput = sm.interactable.connectionType.compositeIO
ComputerClass.colorNormal = sm.color.new(0xaaaaaaff)
ComputerClass.colorHighlight = sm.color.new(0xffffffff)

-- CLIENT/SERVER --

function ComputerClass:svcl_checkEncryption(filesystem)
    local contents = filesystem:getRawContents()
    if not contents then
        sm.scrapcomputers.logger.error("Computer.lua", "Failed to get raw contents of filesystem for encryption check on Computer #" .. self.shape.id)
        return false
    end

    local mainFile = contents["Main.lua"]
    if not mainFile then
        sm.scrapcomputers.logger.error("Computer.lua", "Failed to find Main.lua in filesystem for encryption check on Computer #" .. self.shape.id)
        return false
    end

    local success, result = pcall(sm.scrapcomputers.base91.decode, mainFile)
    if not success then
        sm.scrapcomputers.logger.error("Computer.lua", "Failed to decode Main.lua in filesystem for encryption check on Computer #" .. self.shape.id)
        return false
    end

    return result:sub(1, 4) ~= "\x1bKWC"
end

-- SERVER --

local function printIliegalPacketPlayer(player)
    sm.scrapcomputers.logger.warn("Computer.lua", "Player \"" .. player:getName() .. "\" (ID: " .. player:getId() .. ") has attempted to send a iliegal network packet!")
    return false
end

function ComputerClass:server_onCreate()
    local id = sm.scrapcomputers.computerManager:registerComputer(self)
    
    sm.scrapcomputers.sharedTable:init(self)
    self.sv = {}

    self.sv.playerOwnership = nil ---@type PlayerOwnership.Server
    PlayerOwnership:init(self)

    local storage = self.storage:load()
    if not storage then
        local scriptTemplate = sm.scrapcomputers.exampleManager.loadExample("Computer Script Template")
        if not scriptTemplate then
            self.network:sendToClients("cl_internalChatMessage", "scrapcomputers.computer.failed_to_load_default_example")

            scriptTemplate = {
                name = "Computer Script Template Fallback",
                script = "print('Hello World!')"
            }
        end

        ---@class Computer.Storage
        storage = {
            version = 2.2,
            ---@type Computer.Filesystem
            filesystem = {
                ["Main.lua"] = TextCodec:encode(scriptTemplate.script, false, nil)
            },
            cachedBytecode = {},
            cachedBytecodeWasStripped = false,
            flags = {
                alwaysOn = false,
                allowPrinting = true,
                allowAlerts = true,
                currentEnv = SCRAPCOMPUTERS_COMPUTER_CURRENT_ENV_FLAG["Default"],
                stripDebugInfo = false,
                simpleSyntax = false
            }
        }

        self.storage:save(storage)
    end

    local isUpdated, newStorage = BackwardsComp:UpdateStorage(storage)

    if isUpdated then
        storage = newStorage
        self.storage:save(newStorage)
    end

    local default = {
        cachedBytecode = {},
        cachedBytecodeWasStripped = false,
        flags = {
            alwaysOn = false,
            allowPrinting = true,
            allowAlerts = true,
            currentEnv = SCRAPCOMPUTERS_COMPUTER_CURRENT_ENV_FLAG["Default"],
            stripDebugInfo = false,
            simpleSyntax = false
        }
    }

    do
        local modified = false
        local function iterator(tblDefault, tblCurrent)
            for key, value in pairs(tblDefault) do
                if type(value) == "table" then
                    if type(tblCurrent[key]) ~= "table" then
                        tblCurrent[key] = {}
                        modified = true
                    end

                    iterator(value, tblCurrent[key])
                else
                    if type(tblCurrent[key]) ~= type(value) then
                        tblCurrent[key] = value
                    end
                end
            end
        end

        iterator(default, storage)

        local validCurrentEnv = false
        for _, flag in pairs(SCRAPCOMPUTERS_COMPUTER_CURRENT_ENV_FLAG) do
            if storage.flags.currentEnv == flag then
                validCurrentEnv = true
                break
            end
        end

        if not validCurrentEnv then
            modified = true
            storage.flags.currentEnv = SCRAPCOMPUTERS_COMPUTER_CURRENT_ENV_FLAG["Default"]
        end

        if modified then
            self.storage:save(storage)
        end
    end

    storage.filesystem = Filesystem:createFilesystemFromRawData(storage.filesystem)

    self.sv.storage    = sm.scrapcomputers.sharedTable:new(self, "self.cl.storage")     ---@type Computer.Storage
    self.sv.storageId  = sm.scrapcomputers.sharedTable:getSharedTableId(self.sv.storage)

    self.sv.sharedData   = sm.scrapcomputers.sharedTable:new(self, "self.cl.sharedData") ---@class Computer.SharedData
    self.sv.sharedDataId = sm.scrapcomputers.sharedTable:getSharedTableId(self.sv.sharedData)

    self.sv.memoryTracker = MemoryTracker:new()

    self.sv.sharedData.logger = sm.scrapcomputers.fancyInfoLogger:new()
    self.sv.sharedData.memoryTrackerData = MemoryTracker:getEmptyData()
    self.sv.sharedData.logs = {}

    self.sv.sharedData.computerId = id
    self.sv.sharedData.isRunning = false
    self.sv.sharedData.hasException = false
    self.sv.sharedData.exceptionMessage = ""
    self.sv.sharedData.exceptionData = nil ---@type ErrorParser.ErrorData?

    self.sv.encrypted = self:svcl_checkEncryption(storage.filesystem)

    self.sv.luaVM = LuaVM:init(storage.filesystem, storage.cachedBytecode, function ()
        sm.scrapcomputers.sharedTable:forceSyncProperty(self.sv.storage, "cachedBytecode")
    end, self, not storage.flags.stripDebugInfo, self.sv.encrypted)

    self.sv.lastActive = false
    self.sv.lastOnLift = false
    self.sv.lastInteractiveState = false

    self.sv.lastException = false
    self.sv.fileSavePerformed = false
    self.sv.canClearException = false

    self.sv.forceReset = false
    
    self.sv.encrypted = self.sv.encrypted
    self.sv.passwordKnown = false
    self.sv.nonHashedPassword = ""
    self.sv.allowedPlayersDuringEncryption = {}

    if self.sv.encrypted then
        storage.filesystem.isEncrypted = true
    end

    sm.scrapcomputers.table.transferTable(self.sv.storage, storage)
end

function ComputerClass:server_onFixedUpdate()
    sm.scrapcomputers.sharedTable:runTick(self)

    local onLift = self.shape:getBody():isOnLift()
    if self.sv.lastOnLift ~= onLift then
        self.sv.lastOnLift = onLift

        if onLift and self.sv.lastActive and self.sv.storage.flags.alwaysOn then
            self.sv.forceReset = true
        end
    end

    if self.interactable.active ~= self.sv.lastInteractiveState then
        self.sv.lastInteractiveState = self.interactable.active
        
        if self.sv.lastInteractiveState then
            -- This is probably unintended behaviour and i dont know how to reimplement this from the behaviour on the V2 computer
        else
            self.sv.forceReset = true
        end
    end

    local currentServerTick = sm.game.getServerTick()
    local currentOwnerId = self.sv.playerOwnership:getPlayerId()
    if currentOwnerId ~= -1 and self.sv.allowedPlayersDuringEncryption[currentOwnerId] then
        self.sv.allowedPlayersDuringEncryption[currentOwnerId] = currentServerTick
    end

    do
        local toRemove = {}
        for index, value in pairs(self.sv.allowedPlayersDuringEncryption) do
            if currentServerTick - value > ((2 * 60) * 40) then -- 2 Minutes
                table.insert(toRemove, index)
            end
        end

        for _, index in pairs(toRemove) do
            self.sv.allowedPlayersDuringEncryption[index] = nil
        end
    end

    if currentServerTick % 20 == 0 and type(self.sv.hasPower) ~= "nil" then
        local players = sm.player.getAllPlayers()

        for _, player in pairs(players) do
            if sm.exists(player) and sm.exists(player.character) then
                local worldPosition = player.character.worldPosition
                local distance = (worldPosition - self.shape.worldPosition):length()

                if distance <= 7.5 then
                    self.network:sendToClient(player, "cl_onPowerDataUpdate", {
                        hasPower       = self.sv.hasPower,
                        wasPowered     = self.sv.wasPowered,
                        totalPPTNeeded = self.sv.totalPPTNeeded
                    })
                end
            end
        end
    end

    if self.sv.forceReset then
        self.sv.forceReset = false

        self.sv.luaVM:clearException()

        if self.sv.lastActive then
            -- Turning off
            if self.sv.luaVM.enviroment.onDestroy then
                local success, errMsg = pcall(self.sv.luaVM.enviroment.onDestroy)
                if not success then
                    self.sv.luaVM:forceSetException(ErrorParser:fixErrorMessage(errMsg, self.sv.luaVM.luaState.currentFunction))
                end
            end

            -- We need to reset the luaVM to free up memory
            self.sv.memoryTracker:reset()
            self.sv.luaVM:reset()
        end

        self.sv.sharedData.isRunning = false
        self.sv.sharedData.hasException = false
        self.sv.lastActive = false
        self.sv.lastException = false

        
        self.interactable.active = false
        self.sv.lastInteractiveState = false
        return
    end
    
    local active = self.sv.storage.flags.alwaysOn
    
    local configIsSafeEnv = sm.scrapcomputers.config.getConfig("scrapcomputers.computer.safe_or_unsafe_env").selectedOption == 1
    local safeEnv = configIsSafeEnv

    if self.sv.storage.flags.currentEnv ~= SCRAPCOMPUTERS_COMPUTER_CURRENT_ENV_FLAG["Default"] then
        safeEnv = self.sv.storage.flags.currentEnv == SCRAPCOMPUTERS_COMPUTER_CURRENT_ENV_FLAG["Safe Env"]
    end

    if not active then
        local parents = self.interactable:getParents(sm.interactable.connectionType.logic)
        for _, parent in pairs(parents) do
            if parent.active then
                active = true
                break
            end
        end
    end
    
    if active and self.sv.fileSavePerformed then
        active = false

        self.sv.luaVM:clearException()
        self.sv.fileSavePerformed = false
        self.sv.lastException = false

        if self.sv.luaVM.enviroment.onReload then
            local success, errMsg = pcall(self.sv.luaVM.enviroment.onReload)
            if not success then
                self.sv.luaVM:forceSetException(ErrorParser:fixErrorMessage(errMsg, self.sv.luaVM.luaState.currentFunction))
            end
        end
    end

    self.sv.luaVM:resyncFilesystems(self.sv.storage.filesystem, self.sv.storage.cachedBytecode, self.sv.encrypted, self.sv.nonHashedPassword)

    local hasException = self.sv.luaVM:hasException()
    if not hasException then
        if not self.sv.hasPower then
            active = false

            if not hasException then
                if self.sv.luaVM.enviroment.onPowerLoss then
                    local success, errMsg = pcall(self.sv.luaVM.enviroment.onPowerLoss)
                    if not success then
                        self.sv.luaVM:forceSetException(ErrorParser:fixErrorMessage(errMsg, self.sv.luaVM.luaState.currentFunction))
                    end
                end
            end
        end

        if active then
            self.sv.memoryTracker:trackMemory(self.sv.luaVM.luaState)

            if sm.game.getCurrentTick() % 10 == 0 then
                self.sv.sharedData.memoryTrackerData = self.sv.memoryTracker:getData()
            end
        end
    end
      
    if self.sv.lastActive ~= active then
        self.sv.lastActive = active
        self.interactable.active = active
        self.sv.lastInteractiveState = active

        if hasException then
            if active and sm.scrapcomputers.config.getConfig("scrapcomputers.computer.reset_error_on_restart").selectedOption == 2 then
                self.sv.luaVM:clearException()
                self.sv.lastActive = false
            end
        else
            if active then
                if self.sv.storage.cachedBytecodeWasStripped ~= self.sv.storage.flags.stripDebugInfo then
                    self.sv.storage.cachedBytecodeWasStripped = self.sv.storage.flags.stripDebugInfo 
                    self.sv.storage.cachedBytecode = {}

                    -- We do this so the bytecode can be actually reconstructed due to network bullshet from SharedTables.
                    -- SO DONT REMOVE THESE 2 LINES BELOW!

                    self.sv.lastActive = false
                    self.interactable.active = false
                    self.sv.lastInteractiveState = active
                    return
                end

                self.sv.sharedData.isRunning = true
                self.sv.sharedData.hasException = false
                self.sv.sharedData.exceptionMessage = ""
                self.sv.sharedData.exceptionData = nil

                self.sv.memoryTracker:reset()
                self.sv.luaVM:enableDebugInfo(self.sv.storage.flags.stripDebugInfo)
                self.sv.luaVM:reset()

                self.sv.sharedData.logs = {}
                sm.scrapcomputers.sharedTable:forceSyncProperty(self.sv.sharedData, "logs")

                -- Turning on
                local funcs = {
                    -- Password check
                    function ()
                        if self.sv.encrypted and not self.sv.passwordKnown then
                            self.sv.luaVM:forceSetException("This computers is encrypted! Please enter a password to enable execution!")
                        end
                    end,

                    -- Env check
                    function ()
                        if configIsSafeEnv and not safeEnv then
                            self.sv.luaVM:forceSetException("Attempted to start the computer as Unsafe Env on a Safe Env world! (Change computer config or World Config to fix this)")
                        end
                    end,

                    -- Load main.lua
                    function ()
                        local success, result = pcall(LuaVM.require, self.sv.luaVM, "/Main.lua", "/")
                        if not success then
                            self.sv.luaVM:forceSetException(result:sub(63))
                        end
                    end,

                    -- Call OnLoad
                    function ()
                        if not self.sv.luaVM.enviroment.onLoad then return end

                        local success, errMsg = pcall(self.sv.luaVM.enviroment.onLoad)
                        if not success then
                            self.sv.luaVM:forceSetException(ErrorParser:fixErrorMessage(errMsg, self.sv.luaVM.luaState.currentFunction))
                        end
                    end
                }

                for _, func in pairs(funcs) do
                    func()

                    if self.sv.luaVM:hasException() then
                        break
                    end
                end
            else
                self.sv.sharedData.isRunning = false
                self.sv.sharedData.hasException = false
                self.sv.sharedData.exceptionMessage = ""
                self.sv.sharedData.exceptionData = nil

                -- Turning off
                if self.sv.luaVM.enviroment.onDestroy then
                    local success, errMsg = pcall(self.sv.luaVM.enviroment.onDestroy)
                    if not success then
                        self.sv.luaVM:forceSetException(ErrorParser:fixErrorMessage(errMsg, self.sv.luaVM.luaState.currentFunction))
                    end
                end

                -- We need to reset the luaVM to free up memory
                self.sv.memoryTracker:reset()
                self.sv.luaVM:reset()
            end
        end
    elseif active and not hasException then
        -- Update
        if self.sv.luaVM.enviroment.onUpdate then

            -- TODO: Get a proper way of calculating deltaTime. You cannot use deltaTime provided from onFixedUpdate as
            --       its actually faked (constant FLOAT 0.025 no matter what), infact theres no write operation in the game to deltaTime
            --       used by onFixedUpdate meaning the static 0.025 here is actually 1:1 replica of using deltaTime from onFixedUpdate.
            --
            --       To make it even worse, you can literally just write to ScrapMechanic+0xFF7790 to any double value and it would
            --       be applied towards all onFixedUpdate and the game won't realise at all. (This is complely artifictual so no you cant
            --       do actual 80 TPS with that double)
            --
            --       Thats why we cant use deltaTime from onFixedUpdate. I am not sure wether to base deltaTime from os.clock (CPU-Time)
            --       or sm.game.getCurrentTick so yeah. Maybe os.time() + fractional tick counters?

            local success, errMsg = pcall(self.sv.luaVM.enviroment.onUpdate, 0.025)
            if not success then
                self.sv.luaVM:forceSetException(ErrorParser:fixErrorMessage(errMsg, self.sv.luaVM.luaState.currentFunction))
            end
        end
    end

    local pendingLogs = self.sv.luaVM:readPendingConsoleLogs()
    if #pendingLogs > 0 then
        for _, log in pairs(pendingLogs) do
            table.insert(self.sv.sharedData.logs, log)
        end
        
        sm.scrapcomputers.sharedTable:forceSyncProperty(self.sv.sharedData, "logs")
    end

    local hasException = self.sv.luaVM:hasException()
    if hasException ~= self.sv.lastException then
        self.sv.lastException = hasException

        if hasException then
            local message = self.sv.luaVM:getException()
            local data = ErrorParser:parseError(message)

            table.insert(self.sv.sharedData.logs, ErrorParser:generateError(data))
            sm.scrapcomputers.sharedTable:forceSyncProperty(self.sv.sharedData, "logs")

            if self.sv.luaVM.enviroment.onError then
                local success, errMsg = pcall(self.sv.luaVM.enviroment.onError, self.sv.luaVM:getException())
                if not success then
                    table.insert(self.sv.sharedData.logs, ErrorParser:parseAndGenError(ErrorParser:fixErrorMessage(errMsg)))
                    sm.scrapcomputers.sharedTable:forceSyncProperty(self.sv.sharedData, "logs")
                end
            end

            self.interactable.active = false
            self.sv.lastInteractiveState = false

            self.sv.sharedData.isRunning = false
            self.sv.sharedData.hasException = true
            self.sv.sharedData.exceptionMessage = ErrorParser:parseAndGenShortErr(message)

            self.sv.sharedData.exceptionData = data
        end
    end
end

function ComputerClass:sv_clearError(_, player)
    if player:getId() ~= self.sv.playerOwnership:getPlayerId() then
        return printIliegalPacketPlayer(player)
    end

    self.sv.forceReset = true
end

---@param player Player
function ComputerClass:sv_password_newPassword(newPassword, player)
    if player:getId() ~= self.sv.playerOwnership:getPlayerId() then
        return printIliegalPacketPlayer(player)
    end

    self:sv_password_setEncryption({true, newPassword})
end

function ComputerClass:sv_password_setEncryption(value, player)
    if player then
        return printIliegalPacketPlayer(player)
    end

    local value, newPassword = unpack(value)
    self.sv.encrypted = value
    
    if value then
        self.sv.storage.filesystem:enableEncryption(newPassword)

        for key, value in pairs(self.sv.storage.cachedBytecode) do
            self.sv.storage.cachedBytecode[key] = TextCodec:encode(TextCodec:decode(value, false, nil), true, newPassword)
        end

        self.sv.luaVM:resyncFilesystems(self.sv.storage.filesystem, self.sv.storage.cachedBytecode, self.sv.encrypted, newPassword)
        sm.scrapcomputers.sharedTable:forceSyncProperty(self.sv.storage, "filesystem")
        sm.scrapcomputers.sharedTable:forceSyncProperty(self.sv.storage, "cachedBytecode")

        self.sv.passwordKnown = true
        self.sv.nonHashedPassword = newPassword
    else
        self.sv.storage.filesystem:disableEncryption()

        for key, value in pairs(self.sv.storage.cachedBytecode) do
            self.sv.storage.cachedBytecode[key] = TextCodec:encode(TextCodec:decode(value, true, self.sv.nonHashedPassword), false, nil)
        end

        self.sv.luaVM:resyncFilesystems(self.sv.storage.filesystem, self.sv.storage.cachedBytecode, false, "")
        sm.scrapcomputers.sharedTable:forceSyncProperty(self.sv.storage, "filesystem")
        sm.scrapcomputers.sharedTable:forceSyncProperty(self.sv.storage, "cachedBytecode")
    
        self.sv.passwordKnown = false
        self.sv.nonHashedPassword = ""
    end
end

function ComputerClass:sv_password_sendPassword(password, player)
    if self.sv.playerOwnership:getPlayerId() ~= -1 then
        return printIliegalPacketPlayer(player)
    end


    if self.sv.storage.filesystem:enterEncryptionPassword(password) then
        sm.scrapcomputers.sharedTable:forceSyncProperty(self.sv.storage, "filesystem")

        self.sv.luaVM:resyncFilesystems(self.sv.storage.filesystem, self.sv.storage.cachedBytecode, true, password)

        self.sv.passwordKnown = true
        self.sv.nonHashedPassword = password
        self.sv.allowedPlayersDuringEncryption[player:getId()] = sm.game.getServerTick()

        if self.sv.lastActive then
            self.sv.lastActive = false
        end

        return
    end

    sm.scrapcomputers.logger.warn("Computer.lua", "Player \"" .. player:getName() .. "\" (ID: " .. player:getId() .. ") has attempted to send a invalid password! (The client should check this so seeing this means the client has a modified instance of ScrapComputers)")
end

function ComputerClass:sv_password_clearPassword(password, player)
    if player:getId() ~= self.sv.playerOwnership:getPlayerId() then
        return printIliegalPacketPlayer(player)
    end

    if self.sv.encrypted and self.sv.nonHashedPassword == password then
        self:sv_password_setEncryption({false, password})
        self.sv.allowedPlayersDuringEncryption = {}
        return
    end
end

function ComputerClass:sv_password_updatePassword(data, player)
    if player:getId() ~= self.sv.playerOwnership:getPlayerId() then
        return printIliegalPacketPlayer(player)
    end

    local oldPassword, newPassword = unpack(data)

    if self.sv.encrypted and self.sv.nonHashedPassword == oldPassword then
        self:sv_password_setEncryption({false, oldPassword})
        self:sv_password_setEncryption({true, newPassword})

        return
    end
end

---@param player Player
function ComputerClass:server_onPlayerOwnershipRequested(player, caller)
    if caller then
        return printIliegalPacketPlayer(caller)
    end

    if not self.sv.encrypted then
        self.network:sendToClient(player, "cl_openGui")
        return true
    end

    if self.sv.allowedPlayersDuringEncryption[player:getId()] then
        self.network:sendToClient(player, "cl_openGuiDelayed")
        return true
    end

    self.network:sendToClient(player, "cl_pasword_enter_open")
    return false
end

function ComputerClass:sv_forceReload(_, player)
    if player:getId() ~= self.sv.playerOwnership:getPlayerId() then
        return printIliegalPacketPlayer(player)
    end

    self.sv.fileSavePerformed = true
end

function ComputerClass:server_onSharedTableEventReceived(_, player)
    if player:getId() ~= self.sv.playerOwnership:getPlayerId() then
        return printIliegalPacketPlayer(player)
    end

    return true
end

function ComputerClass:server_onSharedTableChange(id, key, value, comesFromSelf, player)
    if type(key) == "Player" or (not comesFromSelf and player:getId() ~= self.sv.playerOwnership:getPlayerId()) then
        return printIliegalPacketPlayer(player)
    end

    if id == self.sv.storageId then
        if key == "filesystem" then
            if self.sv.luaVM:hasException() then
                self.sv.luaVM:clearException()
            end
        end
    
        ---@type Computer.Storage
        local rawData = sm.scrapcomputers.sharedTable:getRawContents(self.sv.storage)
    
        local function unwrapSharedData(name)
            local entry = rawData[name]
            if not entry then return end
    
            if entry.__hey_computer_please_cast_this_shit == 6969 then
                rawData[name] = entry.contents
                return true
            elseif entry.createSharedTableInfo then
                rawData[name] = entry:getRawContents()
                return true
            end

            return false
        end

        local fsChanged = unwrapSharedData("filesystem")
        if fsChanged then
            local contents = rawData.filesystem

            if not contents["Main.lua"] then
                sm.scrapcomputers.logger.warn("Computer.lua", "Computer #" .. self.shape.id .. " storage filesystem is missing Main.lua file! Recreating it...")
                contents["Main.lua"] = TextCodec:encode("print('Hello World!')", false, nil)
            end
        end
        self.storage:save(rawData)
    
        sm.scrapcomputers.sharedTable:disableSync(self.sv.storage)
     
        if fsChanged then
            self.sv.storage.filesystem = Filesystem:createFilesystemFromRawData(rawData.filesystem)

            if self.sv.encrypted and self.sv.passwordKnown then
                self.sv.storage.filesystem:enterEncryptionPassword(self.sv.nonHashedPassword)
            else
                self.sv.storage.filesystem.isEncrypted = self.sv.encrypted
            end
        end

        sm.scrapcomputers.sharedTable:enableSync(self.sv.storage)
    end
    
    if id == self.sv.sharedDataId and not comesFromSelf then
        sm.scrapcomputers.sharedTable:disableSync(self.sv.sharedData)
        
        if key == "logger" then
            self.sv.sharedData.logger = sm.scrapcomputers.fancyInfoLogger:newFromSharedTable(self.sv.sharedData.logger)
        end
    
        sm.scrapcomputers.sharedTable:enableSync(self.sv.sharedData)
    end
end

-- CLIENT --

function ComputerClass:client_onCreate()
    sm.scrapcomputers.sharedTable:init(self)

    self.cl = {}

    self.cl.playerOwnership = nil ---@type PlayerOwnership.Client
    PlayerOwnership:init(self)

    self.cl.isOtherGuiOpening = false
    self.cl.delayTick = {} ---@type function[]

    self.cl.storage    = nil ---@type Computer.Storage
    self.cl.sharedData = nil ---@type Computer.SharedData

    self.cl.logsHash = ""
    self.cl.noActiveUITick = 0

    self:cl_updateCanUpdateInfoValue()

    self.cl.powerInfo = {
        hasPower       = false,
        wasPowered     = false,
        totalPPTNeeded = 0
    }

    self.cl.tempDisableLogs = false
    self.cl.lastException = false

    -- Main --

    self.cl.main = {}
    self.cl.main.currentlyEditingFile = "/Main.lua"
    self.cl.main.hasUnsavedChanges = false
    self.cl.main.currentCode = ""

    -- Examples
    
    self.cl.main.examples = {}
    self.cl.main.examples.input = ""

    -- Prompt system --

    -- Main Gui --

    self.cl.main.gui = sm.scrapcomputers.gui:createGuiFromLayout("$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Gui/Layout/Computer/Computer.layout")

    self.cl.main.gui:setTextChangedCallback("MainMainCodeInput", "cl_onCodeTextChanged")

    self.cl.main.gui:setButtonCallback("SaveMainBtn", "cl_onSaveBtnPressed")

    self.cl.main.gui:setButtonCallback("OptionsToolsMainRenameCurrentFile"      , "cl_renameCurrentFileBtnPressed")
    self.cl.main.gui:setButtonCallback("OptionsToolsMainDeleteCachedBytecodeBtn", "cl_deleteCachedBytecodeBtnPressed")
    self.cl.main.gui:setButtonCallback("OptionsToolsMainRehighlightCodeBtn"     , "cl_rehighlightCodeBtnPressed")

    self.cl.main.gui:setButtonCallback("OptionsToolsMainCurrentEnvBtn"     , "cl_onToggleButtonPressed")
    self.cl.main.gui:setButtonCallback("OptionsToolsMainStripDebugInfoBtn" , "cl_onToggleButtonPressed")
    self.cl.main.gui:setButtonCallback("OptionsToolsMainAllowAlertsBtn"    , "cl_onToggleButtonPressed")
    self.cl.main.gui:setButtonCallback("OptionsToolsMainAllowPrintingBtn"  , "cl_onToggleButtonPressed")
    self.cl.main.gui:setButtonCallback("OptionsToolsMainAlwaysOnBtn"       , "cl_onToggleButtonPressed")
    self.cl.main.gui:setButtonCallback("OptionsToolsMainSimpleSyntaxBtn"   , "cl_onToggleButtonPressed")

    self.cl.main.gui:setButtonCallback("OptionsToolsMainOpenFileExplorerBtn", "cl_fs_open")

    self.cl.main.gui:setButtonCallback("OptionsToolsMainManagePasswordBtn", "cl_password_openUnknown")

    self.cl.main.gui:setTextChangedCallback("ExamplesMainSelectExampleInput", "cl_examplesTextChanged")
    self.cl.main.gui:setButtonCallback     ("ExamplesMainLoadExampleBtn"    , "cl_examplesLoadExample")

    self.cl.main.gui:setOnCloseCallback("cl_onGuiClose")

    -- Main Unsaved Changes --

    self.cl.main.unsavedChanges = {}
    self.cl.main.unsavedChanges.gui = sm.scrapcomputers.gui:createGuiFromLayout("$GAME_DATA/Gui/Layouts/PopUp/PopUp_YN.layout")
    
    self.cl.main.unsavedChanges.gui:setButtonCallback("Yes", "cl_unsavedChanges_onButtonPressed")
    self.cl.main.unsavedChanges.gui:setButtonCallback("No", "cl_unsavedChanges_onButtonPressed")

    self.cl.main.unsavedChanges.gui:setOnCloseCallback("cl_unsavedChanges_onCloseCallback")
    
    self.cl.main.unsavedChanges.onButtonPressedCallback = nil ---@type function?
    self.cl.main.unsavedChanges.onCloseCallback         = nil ---@type function?

    -- Main Rename --

    self.cl.main.rename = {}
    self.cl.main.rename.input = ""

    self.cl.main.rename.gui = sm.scrapcomputers.gui:createGuiFromLayout("$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Gui/Layout/Computer/Rename.layout")

    self.cl.main.rename.gui:setTextChangedCallback("MainMainInput", "cl_renameOnInputTextChanged")
    self.cl.main.rename.gui:setButtonCallback("MainMainApplyBtn", "cl_renameOnApplyBtnPressed")

    self.cl.main.rename.gui:setOnCloseCallback("cl_openGuiDelayed")

    -- Main Password --

    self.cl.main.passwordmgr = {}
    self.cl.main.passwordmgr.password = ""
    self.cl.main.passwordmgr.passwordKnown = false

    self.cl.main.passwordmgr.new = {}
    self.cl.main.passwordmgr.new.password = ""
    self.cl.main.passwordmgr.new.passwordComfirm = ""
    self.cl.main.passwordmgr.new.gui = sm.scrapcomputers.gui:createGuiFromLayout("$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Gui/Layout/Computer/Password/New.layout")
    self.cl.main.passwordmgr.new.gui:setOnCloseCallback("cl_openGuiDelayed")

    self.cl.main.passwordmgr.new.gui:setTextChangedCallback("MainMainInput1", "cl_password_new_onInputChanged")
    self.cl.main.passwordmgr.new.gui:setTextChangedCallback("MainMainInput2", "cl_password_new_onInputChanged")
    
    self.cl.main.passwordmgr.new.gui:setTextAcceptedCallback("MainMainInput1", "cl_password_new_onFocusChangeRequired")
    self.cl.main.passwordmgr.new.gui:setTextAcceptedCallback("MainMainInput2", "cl_password_new_onSetPasswordBtnPressed")
    
    self.cl.main.passwordmgr.new.gui:setButtonCallback("MainMainSetBtn", "cl_password_new_onSetPasswordBtnPressed")
    
    self.cl.main.passwordmgr.new.logger = sm.scrapcomputers.fancyInfoLogger:new()
    self.cl.main.passwordmgr.new.logger:setDefaultText("")
    
    self.cl.main.passwordmgr.enter = {}
    self.cl.main.passwordmgr.enter.password = ""
    self.cl.main.passwordmgr.enter.gui = sm.scrapcomputers.gui:createGuiFromLayout("$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Gui/Layout/Computer/Password/Enter.layout")
    
    self.cl.main.passwordmgr.enter.gui:setTextAcceptedCallback("MainMainInput", "cl_password_enter_onEnterBtnPressed")
    self.cl.main.passwordmgr.enter.gui:setButtonCallback("MainMainEnterBtn", "cl_password_enter_onEnterBtnPressed")

    self.cl.main.passwordmgr.enter.gui:setTextChangedCallback("MainMainInput", "cl_password_enter_onInputChanged")

    self.cl.main.passwordmgr.main = {}
    self.cl.main.passwordmgr.main.gui = sm.scrapcomputers.gui:createGuiFromLayout("$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Gui/Layout/Computer/Password/Main.layout")
    
    self.cl.main.passwordmgr.main.gui:setButtonCallback("MainMainUpdatePassowrdBtn", "cl_password_main_onButtonPressed")
    self.cl.main.passwordmgr.main.gui:setButtonCallback("MainMainClearPasswordBtn", "cl_password_main_onButtonPressed")
    self.cl.main.passwordmgr.main.gui:setOnCloseCallback("cl_openGuiDelayed")

    self.cl.main.passwordmgr.main.comfirm = {}
    self.cl.main.passwordmgr.main.comfirm.buffer = ""
    
    self.cl.main.passwordmgr.main.comfirm.onAccept = function(password) end
    self.cl.main.passwordmgr.main.comfirm.onCancel = function() self:cl_password_openUnknown() end

    self.cl.main.passwordmgr.main.comfirm.gui = sm.scrapcomputers.gui:createGuiFromLayout("$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Gui/Layout/Computer/Password/Enter.layout")
    self.cl.main.passwordmgr.main.comfirm.gui:setTextAcceptedCallback("MainMainInput", "cl_password_comfirm_onEnterBtnPressed")
    self.cl.main.passwordmgr.main.comfirm.gui:setButtonCallback("MainMainEnterBtn", "cl_password_comfirm_onEnterBtnPressed")
    
    self.cl.main.passwordmgr.main.comfirm.gui:setOnCloseCallback("cl_password_comfirm_onGuiClose")
    
    self.cl.main.passwordmgr.main.comfirm.gui:setTextChangedCallback("MainMainInput", "cl_password_comfirm_onInputChange")

    self.cl.main.passwordmgr.main.update = {}
    self.cl.main.passwordmgr.main.update.logger = sm.scrapcomputers.fancyInfoLogger:new()
    self.cl.main.passwordmgr.main.update.logger:setDefaultText("")

    self.cl.main.passwordmgr.main.update.oldPassword = ""
    self.cl.main.passwordmgr.main.update.newPassword = ""
    self.cl.main.passwordmgr.main.update.newPasswordComfirm = ""

    self.cl.main.passwordmgr.main.update.gui = sm.scrapcomputers.gui:createGuiFromLayout("$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Gui/Layout/Computer/Password/Update.layout")
    self.cl.main.passwordmgr.main.update.gui:setOnCloseCallback("cl_password_openUnknown")

    self.cl.main.passwordmgr.main.update.gui:setTextChangedCallback("MainMainInput1", "cl_password_update_onInputChanged")
    self.cl.main.passwordmgr.main.update.gui:setTextChangedCallback("MainMainInput2", "cl_password_update_onInputChanged")
    self.cl.main.passwordmgr.main.update.gui:setTextChangedCallback("MainMainInput3", "cl_password_update_onInputChanged")

    self.cl.main.passwordmgr.main.update.gui:setTextAcceptedCallback("MainMainInput1", "cl_password_update_onFocusChangeRequired")
    self.cl.main.passwordmgr.main.update.gui:setTextAcceptedCallback("MainMainInput2", "cl_password_update_onFocusChangeRequired")
    self.cl.main.passwordmgr.main.update.gui:setTextAcceptedCallback("MainMainInput3", "cl_password_update_onUpdateBtnPressed")

    self.cl.main.passwordmgr.main.update.gui:setButtonCallback("MainMainSetBtn", "cl_password_update_onUpdateBtnPressed")

    -- Filesystem --
        
    self.cl.filesystem = {}
    self.cl.filesystem.currentPath = "/"
    
    self.cl.filesystem.currentPage = 1
    self.cl.filesystem.selectedElement = -1

    self.cl.filesystem.needsUnsavedGuiToBeOpen = false
    self.cl.filesystem.newSelectedElement = ""

    -- Filesystem Gui --

    self.cl.filesystem.gui = sm.scrapcomputers.gui:createGuiFromLayout("$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Gui/Layout/Computer/FileExplorer.layout")
    
    self.cl.filesystem.gui:setButtonCallback("MainMainNavigationLeftBtn" , "cl_onPageNagivationButtonPressed")
    self.cl.filesystem.gui:setButtonCallback("MainMainNavigationRightBtn", "cl_onPageNagivationButtonPressed")
    
    self.cl.filesystem.gui:setButtonCallback("MainMainNewFileDirBtn", "cl_fs_newOpen")
    self.cl.filesystem.gui:setButtonCallback("MainMainDelFileDirBtn", "cl_fs_deleteOpen")
    self.cl.filesystem.gui:setButtonCallback("MainMainRenFileDirBtn", "cl_fs_renameOpen")
    self.cl.filesystem.gui:setButtonCallback("MainMainOpenFileDirBtn", "cl_fs_openFileOrDir")

    self.cl.filesystem.gui:setButtonCallback("MainMainGoBackBtn", "cl_fs_goBackDirectory")

    for i = 1, 13, 1 do
        self.cl.filesystem.gui:setButtonCallback(tostring(i), "cl_fs_onElementPressed")
    end

    self.cl.filesystem.gui:setOnCloseCallback("cl_fs_closeGui")

    -- Filsystem New --

    self.cl.filesystem.new = {}
    self.cl.filesystem.new.name = ""

    self.cl.filesystem.new.gui = sm.scrapcomputers.gui:createGuiFromLayout("$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Gui/Layout/Computer/FileExplorerNew.layout")

    self.cl.filesystem.new.gui:setOnCloseCallback("cl_fs_openGuiDelayed")
    self.cl.filesystem.new.gui:setButtonCallback("MainMainCreateFileBtn", "cl_newOnCreateBtnPressed")
    self.cl.filesystem.new.gui:setButtonCallback("MainMainCreateDirBtn", "cl_newOnCreateBtnPressed")

    self.cl.filesystem.new.gui:setTextChangedCallback("MainMainInput", "cl_fs_newOnTextInputChanged")
    
    self:cl_fs_newRefresh()

    -- Filesystem Delete --
    
    self.cl.filesystem.deleteGui = sm.scrapcomputers.gui:createGuiFromLayout("$GAME_DATA/Gui/Layouts/PopUp/PopUp_YN.layout")

    self.cl.filesystem.deleteGui:setButtonCallback("Yes", "cl_fs_deleteOnButtonPressed")
    self.cl.filesystem.deleteGui:setButtonCallback("No", "cl_fs_deleteOnButtonPressed")

    self.cl.filesystem.deleteGui:setOnCloseCallback("cl_fs_openGuiDelayed")

    -- Filesystem Rename --

    self.cl.filesystem.rename = {}
    self.cl.filesystem.rename.input = ""

    self.cl.filesystem.rename.gui = sm.scrapcomputers.gui:createGuiFromLayout("$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Gui/Layout/Computer/Rename.layout")

    self.cl.filesystem.rename.gui:setTextChangedCallback("MainMainInput", "cl_fs_renameOnInputTextChanged")
    self.cl.filesystem.rename.gui:setButtonCallback("MainMainApplyBtn", "cl_fs_renameOnApplyBtnPressed")

    self.cl.filesystem.rename.gui:setOnCloseCallback("cl_fs_openGuiDelayed")
end

function ComputerClass:client_onInteract(_, state)
    if not state then return end

    if self.cl.playerOwnership:hasOwner() then
        sm.scrapcomputers.gui:alert("scrapcomputers.computer.gui_already_opened")
        return
    end

    self:cl_reloadTranslations()
    self.cl.playerOwnership:ownInteractable()
end

function ComputerClass:client_canInteract(character)
    if self.shape.usable then
        if not self.cl.sharedData or not self.cl.canShowInfo then
            sm.scrapcomputers.gui:showCustomInteractiveText(
                {
                    "scrapcomputers.computer.interationtext.press_use",
                }
            )
            return true
        end

        sm.scrapcomputers.gui:showCustomInteractiveText(
            {
                "scrapcomputers.computer.interationtext.press_use",
                {
                    "scrapcomputers.computer.interationtext.computer_id",
                    self.cl.sharedData.computerId
                },
                "scrapcomputers.computer.interationtext.is_running." .. tostring(self.cl.sharedData.isRunning),
                "scrapcomputers.computer.interationtext.exception." .. tostring(self.cl.sharedData.hasException),
                {
                    "scrapcomputers.computer.interationtext.power." .. tostring(self.cl.powerInfo.hasPower),
                    sm.scrapcomputers.util.round(self.cl.powerInfo.totalPPTNeeded, 1)
                },
            },
            {
                self.cl.sharedData.hasException and self.cl.sharedData.exceptionMessage or "scrapcomputers.computer.interationtext.no_exception"
            }
        )
    end
    
    return self.shape.usable
end

function ComputerClass:client_onFixedUpdate()
    sm.scrapcomputers.sharedTable:runTick(self)

    for _, func in pairs(self.cl.delayTick) do
        func()
    end
    self.cl.delayTick = {}


    -- This is only for when a error happens where you cant reopen the gui. If there is no gui
    -- open BUT self.cl.playerOwnership:isOwner is true fore more than 40 ticks (1 seccond)
    -- then we know it needs to be reset.
    --
    -- This makes debugging (eg the Syntax Manager) easier cause you dont need to refresh the computer.
    if self.cl.playerOwnership:isOwner() then
        if self.cl.noActiveUITick >= 40 then
            sm.scrapcomputers.logger.warn("Computer.lua", "Computer #" .. self.cl.sharedData.computerId .. " likey errored on the visual side! Resetting ownership and pray.")
            
            self.cl.noActiveUITick = 0
            self.cl.playerOwnership:stopOwningInteractable()
        else
            local guis = {
                self.cl.main.gui,
                self.cl.main.unsavedChanges.gui,
                self.cl.main.rename.gui,
                self.cl.main.passwordmgr.new.gui,
                self.cl.main.passwordmgr.enter.gui,
                self.cl.main.passwordmgr.main.gui,
                self.cl.main.passwordmgr.main.comfirm.gui,
                self.cl.main.passwordmgr.main.update.gui,

                self.cl.filesystem.deleteGui,
                self.cl.filesystem.new.gui,
                self.cl.filesystem.rename.gui,
                self.cl.filesystem.gui,
            }

            local canIncrement = true
            for _, gui in pairs(guis) do
                if gui:isActive() then
                    canIncrement = false
                    break
                end
            end

            if canIncrement then
                self.cl.noActiveUITick = self.cl.noActiveUITick + 1
            else
                self.cl.noActiveUITick = 0
            end
        end
    end

    local localPlayer = sm.localPlayer.getPlayer()
    if localPlayer and localPlayer.character and sm.exists(localPlayer.character) then
        if (localPlayer.character.worldPosition - self.shape.worldPosition):length() <= 7.5 and sm.game.getCurrentTick() % 10 == 0 then
            self:cl_updateCanUpdateInfoValue()
        end
    end

    local sharedData = self.cl.sharedData
    if not sharedData or not self.cl.playerOwnership:isOwner() then return end -- Optimization!

    if sharedData.logger then
        self:cl_fixLoggerIfNeeded()

        local log = sharedData.logger:getLog()
        self.cl.main.gui:setTextRaw("MainHeaderTextInfoText", log)
    end

    if sharedData.logs and self.cl.logsHash ~= tostring(sharedData.logs) then
        if self.cl.tempDisableLogs then
            self.cl.tempDisableLogs = false
        else
            self.cl.logsHash = tostring(sharedData.logs)

            local text = ""
            
            for _, log in pairs(sharedData.logs) do
                text = text .. log
            end

            self.cl.main.gui:setTextRaw("MainMainLogsText", text)
        end
    end

    if sharedData.memoryTrackerData and sm.game.getServerTick() % 10 == 0 then
        local data = sharedData.memoryTrackerData
        
        local translatable = sm.scrapcomputers.languageManager.translatable
        local prefix = "scrapcomputers.computer.info.memory."
        local textArray = {
            translatable(prefix .. "title", data.frameCount),
        
            translatable(prefix .. "average_positive", data.averagePositive),
            translatable(prefix .. "average_negative", data.averageNegative),
            translatable(prefix .. "average_difference", data.avgDiff),
        
            "",
        
            translatable(
                prefix .. (data.trend > 0 and "trend.increase" or "trend.decrease"),
                data.trend
            ),
            translatable(prefix .. "growth_streak", data.growthStreak),
            translatable(
                prefix .. (data.lastWasGC and "garbage_collector.active" or "garbage_collector.inactive")
            )
        }

        local haywireMessages = {}
        if data.memoryIsLikelyHigh then
            table.insert(haywireMessages, translatable(prefix .. "warnings.high_memory_usage"))
        end

        if #haywireMessages > 0 then
            table.insert(textArray, "\n" .. translatable(prefix .. "warnings.title"))
            for _, msg in pairs(haywireMessages) do
                table.insert(textArray, msg)
            end
        end

        local text = table.concat(textArray, "\n")
        self.cl.main.gui:setTextRaw("OptionsToolsMainInfoText", text)
    end

    self:cl_password_onFixedUpdate()
end

function ComputerClass:cl_fixLoggerIfNeeded()
    if self.cl.sharedData.logger and not self.cl.sharedData.logger.getLog then
        self.cl.sharedData.logger = sm.scrapcomputers.fancyInfoLogger:newFromSharedTable(self.cl.sharedData.logger)
    end
end

function ComputerClass:cl_updateCanUpdateInfoValue()
    self.cl.canShowInfo = sm.scrapcomputers.config.getConfig("scrapcomputers.computer.show_info_on_computer_hover").selectedOption == 1
end


-- CLIENT - MAIN GUI --

function ComputerClass:cl_saveFromUnsavedChanges()
    local cachedBytecode = self.cl.storage.cachedBytecode
    local filePath = self.cl.main.currentlyEditingFile

    if cachedBytecode[filePath] then
        cachedBytecode[filePath] = nil
        sm.scrapcomputers.sharedTable:forceSyncProperty(self.cl.storage, "cachedBytecode")
    end
    self.cl.storage.filesystem:writeToFile(filePath, self.cl.main.currentCode, false)

    sm.scrapcomputers.sharedTable:forceSyncProperty(self.cl.storage, "filesystem")

    self.cl.main.hasUnsavedChanges = false
    
    self:cl_updateDefaultText()
end

function ComputerClass:cl_createExceptionLines()
    local exceptionData = self.cl.sharedData.exceptionData
    if not self.cl.sharedData.hasException or not exceptionData then
        return {}
    end

    local exceptionLines = {}

    if exceptionData.traceback then
        for _, traceback in pairs(exceptionData.traceback) do
            if traceback.isComputerFile and traceback.path == self.cl.main.currentlyEditingFile then
                table.insert(exceptionLines, traceback.line)
            end
        end 
    end

    return exceptionLines
end

function ComputerClass:cl_openGui()
    local success, result = pcall(self.cl_openGuiReal, self)
    if success then
        return
    end
    
    sm.scrapcomputers.logger.error(result)
    sm.scrapcomputers.gui:alert("scrapcomputers.other.lua_error")

    self.cl.playerOwnership:stopOwningInteractable()
end

function ComputerClass:cl_openGuiReal()
    self:cl_reloadTranslations()

    if self.cl.isOtherGuiOpening then
        -- If another GUI is opening, we don't want to close the computer GUI
        -- This is used to prevent closing the computer GUI when opening the file explorer
        self.cl.isOtherGuiOpening = false
        return
    end

    self:cl_updateDefaultText()

    local fileExists = self.cl.storage.filesystem:exists(self.cl.main.currentlyEditingFile)
    self.cl.main.gui:setVisible("OptionsToolsMainDeleteCachedBytecodeBtn", fileExists)
    self.cl.main.gui:setVisible("OptionsToolsMainRenameCurrentFile"      , fileExists)
    self.cl.main.gui:setVisible("OptionsToolsMainRehighlightCodeBtn"     , fileExists)

    self.cl.main.gui:setVisible("MainMainCodeInput"     , fileExists)
    self.cl.main.gui:setVisible("MainMainLogsText"      , fileExists)
    self.cl.main.gui:setVisible("MainMainSaveAndExitBtn", fileExists)
    self.cl.main.gui:setVisible("MainMainSaveBtn"       , fileExists)

    self.cl.main.gui:setVisible("ExamplesMainLoadExampleBtn"    , fileExists)
    self.cl.main.gui:setVisible("ExamplesMainSelectExampleInput", fileExists)
    self.cl.main.gui:setVisible("ExamplesMainList"              , fileExists) -- Only here to make it less uglier
    
    self.cl.main.gui:setVisible("MainMainFileNotFound", not fileExists)
    
    self:cl_refreshSidebar()
    
    if not fileExists then
        self.cl.main.gui:open()
        return
    end

    if not self.cl.main.hasUnsavedChanges then
        local file = self.cl.storage.filesystem:readFile(self.cl.main.currentlyEditingFile)
        self:cl_rehighlightCode(file, self:cl_createExceptionLines())
        self.cl.main.currentCode = file
    end

    do
        local text = ""

        local examples = sm.scrapcomputers.exampleManager.getExamples()
        for i, value in pairs(examples) do
            text = text .. i .. " | " .. value.name .. "\n"
        end
        self.cl.main.gui:setTextRaw("ExamplesMainList", text:sub(1, #text - 1))
    end

    self.cl.main.gui:open()
    self:cl_updateLogs()
end

function ComputerClass:cl_onGuiClose()
    if self.cl.isOtherGuiOpening then
        -- If another GUI is opening, we don't want to close the computer GUI
        -- This is used to prevent closing the computer GUI when opening the file explorer
        self.cl.isOtherGuiOpening = false
        return
    end

    if not self.cl.main.hasUnsavedChanges then
        self.cl.playerOwnership:stopOwningInteractable()
        return
    end

    if sm.scrapcomputers.config.getConfig("scrapcomputers.computer.autosave").selectedOption == 2 then
        self:cl_saveFromUnsavedChanges()
        self.cl.playerOwnership:stopOwningInteractable()
        return
    end

    local comfirmed = false
    self.cl.main.unsavedChanges.onCloseCallback = function ()
        if not comfirmed then
            self:cl_openGui()
            return
        end

        self.cl.playerOwnership:stopOwningInteractable()
    end

    self.cl.main.unsavedChanges.onButtonPressedCallback = function (comfirm)
        comfirmed = comfirm

        if comfirm then
            self.cl.main.hasUnsavedChanges = false
        end
    end

    self.cl.main.unsavedChanges.gui:open()
end

function ComputerClass:cl_onToggleButtonPressed(widgetName)
    -- This function is used for all the buttons in the OptionsToolsMain GUI.
    -- It is used to handle the button presses and toggle the state of the buttons.
    -- 
    -- Because its stupid to have a separate function for each button!
    local flags = self.cl.storage.flags
    local buttons = {
        ["OptionsToolsMainCurrentEnvBtn"] = function ()
            local newEnv = flags.currentEnv + 1
            for _, number in pairs(SCRAPCOMPUTERS_COMPUTER_CURRENT_ENV_FLAG) do
                if number == newEnv then
                    flags.currentEnv = number
                    return
                end
            end

            flags.currentEnv = 0
        end,
        ["OptionsToolsMainStripDebugInfoBtn"] = function ()
            flags.stripDebugInfo = not flags.stripDebugInfo
        end,
        ["OptionsToolsMainAllowAlertsBtn"] = function ()
            flags.allowAlerts = not flags.allowAlerts
        end,
        ["OptionsToolsMainAllowPrintingBtn"] = function ()
            flags.allowPrinting = not flags.allowPrinting
        end,
        ["OptionsToolsMainAlwaysOnBtn"] = function ()
            flags.alwaysOn = not flags.alwaysOn
        end,
        ["OptionsToolsMainSimpleSyntaxBtn"] = function ()
            flags.simpleSyntax = not flags.simpleSyntax
        end
    }

    local buttonFunc = buttons[widgetName]
    sm.scrapcomputers.errorHandler.assert(buttonFunc, nil, "ButtunFunc was nil, WTF?")

    buttonFunc()

    sm.scrapcomputers.sharedTable:forceSyncProperty(self.cl.storage, "flags")
    
    self:cl_refreshSidebar()
end

function ComputerClass:cl_refreshSidebar()
    local flags = self.cl.storage.flags

    local function loadToggleTranslation(bool)
        return (bool and "#0dbc79" or "#cd3131") .. sm.scrapcomputers.languageManager.translatable(bool and "scrapcomputers.other.enabled" or "scrapcomputers.other.disabled")
    end

    self.cl.main.gui:setText("OptionsToolsMainSimpleSyntaxBtn"  , "scrapcomputers.computer.toggles.simple_syntax"    , loadToggleTranslation(flags.simpleSyntax  ))
    self.cl.main.gui:setText("OptionsToolsMainAlwaysOnBtn"      , "scrapcomputers.computer.toggles.always_on"        , loadToggleTranslation(flags.alwaysOn      ))
    self.cl.main.gui:setText("OptionsToolsMainAllowPrintingBtn" , "scrapcomputers.computer.toggles.allow_printing"   , loadToggleTranslation(flags.allowPrinting ))
    self.cl.main.gui:setText("OptionsToolsMainAllowAlertsBtn"   , "scrapcomputers.computer.toggles.allow_alerts"     , loadToggleTranslation(flags.allowAlerts   ))
    self.cl.main.gui:setText("OptionsToolsMainStripDebugInfoBtn", "scrapcomputers.computer.toggles.strip_debug_info" , loadToggleTranslation(flags.stripDebugInfo))
    
    self.cl.main.gui:setText("OptionsToolsMainCurrentEnvBtn"    , "scrapcomputers.computer.toggles.current_env"      ,
        sm.scrapcomputers.languageManager.translatable("scrapcomputers.computer.toggles.current_env#" .. tostring(flags.currentEnv))
    )
end

function ComputerClass:cl_onSaveBtnPressed()
    self.cl.logsHash = ""
    self.cl.sharedData.logs = {}
    
    self.cl.tempDisableLogs = true
    self.cl.lastException = false
    
    self.network:sendToServer("sv_clearError")
    self.network:sendToServer("sv_forceReload")

    self:cl_rehighlightCode(self.cl.main.currentCode, {})
    if not self.cl.main.hasUnsavedChanges then
        self:cl_showLog("scrapcomputers.computer.logs.no_saved_changes")
        return
    end
    
    self:cl_saveFromUnsavedChanges()
    self:cl_showLog("scrapcomputers.computer.logs.saved_changes", "#23d18b")

    local emptyData = MemoryTracker:getEmptyData()

    for key, value in pairs(self.cl.sharedData.memoryTrackerData) do
        if emptyData[key] ~= value then
            self.cl.sharedData.memoryTrackerData = MemoryTracker:getEmptyData()
            break
        end
    end
end

function ComputerClass:cl_deleteCachedBytecodeBtnPressed()
    local cachedBytecode = self.cl.storage.cachedBytecode
    local filePath = self.cl.main.currentlyEditingFile

    if cachedBytecode[filePath] then
        cachedBytecode[filePath] = nil
        sm.scrapcomputers.sharedTable:forceSyncProperty(self.cl.storage, "cachedBytecode")

        self:cl_showLog("scrapcomputers.computer.logs.successfully_deleted_byte_code", "#23d18b")
        return
    end

    self:cl_showLog("scrapcomputers.computer.logs.no_byte_code", "#f14c4c")
end

function ComputerClass:cl_showLog(msg, color, ...)
    self:cl_fixLoggerIfNeeded()
    self.cl.sharedData.logger:showLog(msg, color, ...)
    sm.scrapcomputers.sharedTable:forceSyncProperty(self.cl.sharedData, "logger")
end

function ComputerClass:cl_openGuiDelayed()
    table.insert(self.cl.delayTick, function ()
        self.cl.isOtherGuiOpening = false
        self:cl_openGui()
    end)
end

function ComputerClass:cl_rehighlightCode(code, exceptionLines)
    -- TODO: Add user theme support

    local safeCode = code:gsub("\\", "⁄")
    local output = sm.scrapcomputers.syntax.highlightCode(safeCode, exceptionLines, nil, self.cl.storage.flags.simpleSyntax)
    self.cl.main.gui:setTextRaw("MainMainCodeInput", output)
end

function ComputerClass:cl_updateDefaultText()
    self:cl_fixLoggerIfNeeded()
    
    local safeCurrentlyEditingFile = self.cl.main.currentlyEditingFile:gsub("#", "##")
    self.cl.sharedData.logger:setDefaultText("scrapcomputers.computer.currently_editing", safeCurrentlyEditingFile .. (self.cl.main.hasUnsavedChanges and "*" or ""))
end

function ComputerClass:cl_onCodeTextChanged(widgetName, text)
    text = text:gsub("⁄", "\\")

    local oldCode = self.cl.main.currentCode

    local startsWithOld = text:sub(1, #oldCode) == oldCode
    local firstCharMismatch = text:sub(1, 1) ~= oldCode:sub(1, 1)
    local lastCharMismatch = text:sub(-1) ~= oldCode:sub(-1)
    
    if startsWithOld or (firstCharMismatch and lastCharMismatch) then
        self:cl_rehighlightCode(text, {})
    end

    self.cl.main.currentCode = text

    if not self.cl.main.hasUnsavedChanges then
        self.cl.main.hasUnsavedChanges = true
        self:cl_updateDefaultText()
    end
end

function ComputerClass:cl_rehighlightCodeBtnPressed()
    self:cl_rehighlightCode(self.cl.main.currentCode, {})
end

-- CLIENT - MAIN EXAMPLES -

function ComputerClass:cl_examplesTextChanged(widgetName, text)
    self.cl.main.examples.input = text
end

function ComputerClass:cl_examplesLoadExample()
    local input = tonumber(self.cl.main.examples.input)
    if not input or math.floor(input) ~= input then
        self:cl_showLog("scrapcomputers.computer.logs.examples.not_a_number", "#f14c4c")
        return
    end

    local examples = sm.scrapcomputers.exampleManager.getExamples()
    local selectedExample = examples[input]

    if not selectedExample then
        self:cl_showLog("scrapcomputers.computer.logs.examples.out_of_bounds", "#f14c4c", #examples)
        return
    end

    self.cl.main.currentCode = selectedExample.script
    self.cl.main.hasUnsavedChanges = true
    self:cl_rehighlightCode(self.cl.main.currentCode, {})

    self:cl_showLog("scrapcomputers.computer.logs.examples.loaded_example", "#23d18b", selectedExample.name, input)
end

-- CLIENT - MAIN RENAME CURRENT FILE --

function ComputerClass:cl_renameCurrentFileBtnPressed()
    if self.cl.main.currentlyEditingFile == "/Main.lua" then
        self:cl_showLog("scrapcomputers.computer.logs.cannot_rename_main_file", "#f14c4c")
        return
    end

    self:cl_reloadTranslations()

    self.cl.isOtherGuiOpening = true
    self.cl.main.gui:close()

    do
        local filename = self.cl.main.currentlyEditingFile:match("([^/]+)$"):gsub("#", "##")
        self.cl.main.rename.gui:setTextRaw("MainMainInput", filename)
    end

    self.cl.main.rename.gui:open()
end

function ComputerClass:cl_renameOnInputTextChanged(widgetName, text)
    self.cl.main.rename.input = text
end

function ComputerClass:cl_renameOnApplyBtnPressed()
    local input = self.cl.main.rename.input

    if input:find("[/\\]") ~= nil then
        sm.scrapcomputers.gui:alert("scrapcomputers.computer.fs.new.invalid_name")
        return
    end

    local parentPath = self.cl.main.currentlyEditingFile:match("^(.*)/[^/]+$") .. "/"
    local newFullPath = parentPath .. input

    if self.cl.storage.filesystem:exists(newFullPath) then
        sm.scrapcomputers.gui:alert("scrapcomputers.computer.already_exists")
        return
    end
    
    self.cl.storage.filesystem:rename(self.cl.main.currentlyEditingFile, newFullPath)
    sm.scrapcomputers.sharedTable:forceSyncProperty(self.cl.storage, "filesystem")

    self.cl.main.rename.gui:close()

    self.cl.main.currentlyEditingFile = newFullPath
end

-- CLIENT - FILE EXPLORER -- 

function ComputerClass:cl_fs_open()
    self:cl_reloadTranslations()

    self.cl.isOtherGuiOpening = true
    self.cl.main.gui:close()

    self:cl_fs_refreshList()
    self:cl_fs_updatePaginationText()
    self:cl_fs_updateButtonVisiblities()
    self:cl_fs_updateCurrentDirectory()

    self.cl.filesystem.gui:open()
end

function ComputerClass:cl_fs_closeGui()
    if not self.cl.filesystem.needsUnsavedGuiToBeOpen then
        self.cl.isOtherGuiOpening = false
        self:cl_openGui()
        return
    end

    self.cl.filesystem.needsUnsavedGuiToBeOpen = false

    local comfirmed = false
    self.cl.main.unsavedChanges.onCloseCallback = function ()
        if comfirmed then
            self.cl.main.currentlyEditingFile = self.cl.filesystem.currentPath .. self.cl.filesystem.newSelectedElement
            self:cl_openGuiDelayed()
        else
            self:cl_fs_open()
        end
    end

    self.cl.main.unsavedChanges.onButtonPressedCallback = function (comfirm)
        comfirmed = comfirm

        if comfirm then
            self.cl.main.hasUnsavedChanges = false
        end
    end

    self.cl.main.unsavedChanges.gui:open()
end

function ComputerClass:cl_fs_refreshList()
    local contents = self.cl.storage.filesystem:list(self.cl.filesystem.currentPath)

    if not contents then
        sm.scrapcomputers.logger.error("Computer.lua", "OH SHIT OH SHIT! WE ARE FUCKED! Ether the filesystem got corrutped or currentPath is fucked!")
        contents = {} -- Fallback
    end

    local visible = {}

    for i = (self.cl.filesystem.currentPage * 13) - 12, self.cl.filesystem.currentPage * 13, 1 do
        local element = contents[i]
        if element then
            table.insert(visible, element)
        end
    end

    if #visible == 0 then
        for i = 1, 13 do
            self.cl.filesystem.gui:setVisible(tostring(i), false)
        end

        self.cl.filesystem.gui:setVisible("MainMainEmptyDirectoryText", true)
    else
        self.cl.filesystem.gui:setVisible("MainMainEmptyDirectoryText", false)

        for i = 1, 13 do
            local iStr = tostring(i)

            local visibleOffset = (self.cl.filesystem.currentPage * 13) - (12 - (i - 1))
            self.cl.filesystem.gui:setButtonState(iStr, visibleOffset == self.cl.filesystem.selectedElement)

            local element = visible[i]

            if element then
                local isFile = element[2] == "file"
                local name = element[1]:gsub("#", "##")

                self.cl.filesystem.gui:setTextRaw(iStr, (isFile and "" or "#ffa000") .. name .. (isFile and "" or "/"))
                self.cl.filesystem.gui:setVisible(iStr, true)
            else
                self.cl.filesystem.gui:setVisible(iStr, false)
            end
        end
    end

    self.cl.filesystem.gui:setVisible("MainMainGoBackBtn", self.cl.filesystem.currentPath ~= "/")
end

function ComputerClass:cl_fs_onElementPressed(widgetName)
    local index = tonumber(widgetName)
    local visibleOffset = (self.cl.filesystem.currentPage * 13) - (12 - (index - 1))

    self.cl.filesystem.selectedElement = visibleOffset
    self:cl_fs_refreshList()

    self:cl_fs_updateButtonVisiblities()
end

function ComputerClass:cl_onPageNagivationButtonPressed(widgetName)
    if widgetName == "MainMainNavigationLeftBtn" then
        self.cl.filesystem.currentPage = self.cl.filesystem.currentPage - 1
    elseif widgetName == "MainMainNavigationRightBtn" then
        self.cl.filesystem.currentPage = self.cl.filesystem.currentPage + 1
    end

    self:cl_fs_validatePagination()
    self:cl_fs_updatePaginationText()
    self:cl_fs_refreshList()
end

function ComputerClass:cl_fs_validatePagination()
    local totalFiles = self.cl.storage.filesystem:list(self.cl.filesystem.currentPath)
    local totalPages = math.ceil(#totalFiles / 13)

    if totalPages == 0 then
        totalPages = 1
    end

    if self.cl.filesystem.currentPage < 1 then
        self.cl.filesystem.currentPage = 1
    elseif self.cl.filesystem.currentPage > totalPages then
        self.cl.filesystem.currentPage = totalPages
    end
end

function ComputerClass:cl_fs_updatePaginationText()
    local totalFiles = self.cl.storage.filesystem:list(self.cl.filesystem.currentPath)
    local totalPages = math.ceil(#totalFiles / 13)

    if totalPages == 0 then
        totalPages = 1
    end

    self.cl.filesystem.gui:setTextRaw("MainMainNavigationText", string.format("%d/%d", self.cl.filesystem.currentPage, totalPages))
end

function ComputerClass:cl_fs_updateButtonVisiblities()
    local hasElementSelected = self.cl.filesystem.selectedElement ~= -1
    local selectedFilePath = self.cl.filesystem.currentPath ..  (self.cl.storage.filesystem:list(self.cl.filesystem.currentPath)[self.cl.filesystem.selectedElement] or {""})[1]

    if selectedFilePath == "/Main.lua" then
        self.cl.filesystem.gui:setVisible("MainMainOpenFileDirBtn", true)
        self.cl.filesystem.gui:setVisible("MainMainDelFileDirBtn", false)
        self.cl.filesystem.gui:setVisible("MainMainRenFileDirBtn", false)
    else
        self.cl.filesystem.gui:setVisible("MainMainOpenFileDirBtn", hasElementSelected)
        self.cl.filesystem.gui:setVisible("MainMainDelFileDirBtn", hasElementSelected)
        self.cl.filesystem.gui:setVisible("MainMainRenFileDirBtn", hasElementSelected)
    end
end

function ComputerClass:cl_fs_openGuiDelayed()
    self.cl.isOtherGuiOpening = false
    
    -- SM Sucks
    table.insert(self.cl.delayTick, function()
        self:cl_fs_open()
        self.cl.isOtherGuiOpening = false
    end)
end

function ComputerClass:cl_fs_updateCurrentDirectory()
    local currentPath = self.cl.filesystem.currentPath:gsub("#", "##")
    self.cl.filesystem.gui:setText("MainHeaderTextCurrentDirectoryText", "scrapcomputers.computer.fs.current_directory", currentPath)
end

-- CLIENT - FILE EXPLORER NEW --

function ComputerClass:cl_fs_newOpen()
    self:cl_reloadTranslations()

    self.cl.isOtherGuiOpening = true
    self.cl.filesystem.gui:close()

    self.cl.filesystem.new.name = "MyFile.lua"

    self:cl_fs_newRefresh()
    self.cl.filesystem.new.gui:open()
end

function ComputerClass:cl_fs_newRefresh()
    local name = self.cl.filesystem.new.name:gsub("#", "##")
    self.cl.filesystem.new.gui:setTextRaw("MainMainInput", name)
end

---@param widgetName string
function ComputerClass:cl_newOnCreateBtnPressed(widgetName)
    local input = self.cl.filesystem.new.name

    if input:find("[/\\]") ~= nil then
        sm.scrapcomputers.gui:alert("scrapcomputers.computer.fs.new.invalid_name")
        return
    end

    local fullPath = self.cl.filesystem.currentPath .. input

    if self.cl.storage.filesystem:exists(fullPath) then
        sm.scrapcomputers.gui:alert("scrapcomputers.computer.already_exists")
        return
    end

    if widgetName == "MainMainCreateFileBtn" then
        self.cl.storage.filesystem:createFile(fullPath, "")
    else
        self.cl.storage.filesystem:createDirectory(fullPath)
    end
    
    sm.scrapcomputers.sharedTable:forceSyncProperty(self.cl.storage, "filesystem")
    
    self.cl.filesystem.new.gui:close()
end

function ComputerClass:cl_fs_newOnTextInputChanged(widgetName, text)
    self.cl.filesystem.new.name = text
end

-- CLIENT - FILE EXPLORER DELETE --

function ComputerClass:cl_fs_deleteOpen()
    self:cl_reloadTranslations()

    self.cl.isOtherGuiOpening = true
    self.cl.filesystem.gui:close()

    self.cl.filesystem.deleteGui:open()
end

function ComputerClass:cl_fs_deleteOnButtonPressed(widgetName)
    if widgetName == "Yes" then
        local elements = self.cl.storage.filesystem:list(self.cl.filesystem.currentPath)
        local selectedElement = elements[self.cl.filesystem.selectedElement]

        if not selectedElement then
            sm.scrapcomputers.gui:alert("scrapcomputers.computer.failed_to_find")
            return
        end

        self.cl.storage.filesystem:delete(self.cl.filesystem.currentPage .. "/" .. selectedElement[1])
        sm.scrapcomputers.sharedTable:forceSyncProperty(self.cl.storage, "filesystem")
    end
    self.cl.filesystem.deleteGui:close()
end

-- CLIENT - FILE EXPLORER RENAME --

function ComputerClass:cl_fs_renameOpen()
    local directoryContents = self.cl.storage.filesystem:list(self.cl.filesystem.currentPath)
    local selectedElement = directoryContents[self.cl.filesystem.selectedElement]

    if not selectedElement then
        sm.scrapcomputers.gui:alert("scrapcomputers.computer.failed_to_find")
        return
    end

    local name = selectedElement[1]
    local safeName = name:gsub("#", "##")

    self:cl_reloadTranslations()

    self.cl.isOtherGuiOpening = true
    self.cl.filesystem.gui:close()

    self.cl.filesystem.rename.input = name
    self.cl.filesystem.rename.gui:setTextRaw("MainMainInput", safeName)

    self.cl.filesystem.rename.gui:open()
end

function ComputerClass:cl_fs_renameOnInputTextChanged(widgetName, text)
    self.cl.filesystem.rename.input = text
end

function ComputerClass:cl_updateLogs()
	local rawData = sm.scrapcomputers.base91.decode(self.cl.storage.filesystem:getRawContents()["Main.lua"])
	local bypassed = rawData:sub(1, 4) ~= "\x1bKWC" and self.cl.storage.filesystem:readFile("Main.lua") == rawData
	
	if bypassed then
		self.cl.main.gui:close()
        sm.scrapcomputers.gui:alert("Lil bro really tried to bypass it :skull:")
	end
end

function ComputerClass:cl_fs_renameOnApplyBtnPressed(widgetName)
    local input = self.cl.filesystem.rename.input

    if input:find("[/\\]") ~= nil then
        sm.scrapcomputers.gui:alert("scrapcomputers.computer.fs.new.invalid_name")
        return
    end

    local newFullPath = self.cl.filesystem.currentPath .. input

    if self.cl.storage.filesystem:exists(newFullPath) then
        sm.scrapcomputers.gui:alert("scrapcomputers.computer.already_exists")
        return
    end

    local directoryContents = self.cl.storage.filesystem:list(self.cl.filesystem.currentPath)
    local selectedElement = directoryContents[self.cl.filesystem.selectedElement]

    if not selectedElement then
        sm.scrapcomputers.gui:alert("scrapcomputers.computer.failed_to_find")
        return
    end
    
    -- Theres a better way which is this: selectedElement[1] = input
    -- However thats hacky as fuck aka: fuck you!

    local oldFullPath = self.cl.filesystem.currentPath .. selectedElement[1]
    self.cl.storage.filesystem:rename(oldFullPath, newFullPath)
    sm.scrapcomputers.sharedTable:forceSyncProperty(self.cl.storage, "filesystem")
    
    self.cl.filesystem.rename.gui:close()
end

-- CLIENT - FILESYSTEM OPEN --

function ComputerClass:cl_fs_openFileOrDir()
    local directoryContents = self.cl.storage.filesystem:list(self.cl.filesystem.currentPath)
    local selectedElement = directoryContents[self.cl.filesystem.selectedElement]

    if not selectedElement then
        sm.scrapcomputers.gui:alert("scrapcomputers.computer.failed_to_find")
        return
    end

    self.cl.filesystem.selectedElement = -1

    local newCurrentPath = self.cl.filesystem.currentPath .. selectedElement[1]
    if selectedElement[2] == "directory" then
        self.cl.filesystem.currentPath = newCurrentPath .. "/"

        self:cl_fs_refreshList()
        self:cl_fs_updatePaginationText()
        self:cl_fs_updateButtonVisiblities()
        self:cl_fs_updateCurrentDirectory()
        return
    end

    local hasUnsavedChanges = self.cl.main.hasUnsavedChanges
    if self.cl.main.currentlyEditingFile == newCurrentPath then
        hasUnsavedChanges = false
    end

    if not hasUnsavedChanges then
        self.cl.main.currentlyEditingFile = newCurrentPath
    else
        self:cl_reloadTranslations()
        
        self.cl.isOtherGuiOpening = true

        self.cl.filesystem.needsUnsavedGuiToBeOpen = true
        self.cl.filesystem.newSelectedElement = selectedElement[1]
    end

    self.cl.filesystem.gui:close()
end

-- CLIENT - FILESYSTEM GO BACK DIR --

function ComputerClass:cl_fs_goBackDirectory()
    self.cl.filesystem.currentPath = (self.cl.filesystem.currentPath:match("^(.-)/[^/]+/$") or "") .. "/"
    self.cl.filesystem.selectedElement = -1

    self:cl_fs_refreshList()
    self:cl_fs_updatePaginationText()
    self:cl_fs_updateButtonVisiblities()
    self:cl_fs_updateCurrentDirectory()
end

-- CLIENT - PASSWORD MANAGER GUI --

function ComputerClass:cl_password_openUnknown()
    self:cl_reloadTranslations()

    self.cl.isOtherGuiOpening = true
    self.cl.main.gui:close()

    if not self:svcl_checkEncryption(self.cl.storage.filesystem) then
        self.cl.main.passwordmgr.new.password = ""
        self.cl.main.passwordmgr.new.gui:setTextRaw("MainMainInput1", "")

        self:cl_password_new_clearSecondInputField()

        self.cl.main.passwordmgr.new.gui:open()
        return
    end

    self.cl.main.passwordmgr.main.gui:open()
end

function ComputerClass:cl_password_onFixedUpdate()
    if self.cl.main.passwordmgr.new.gui:isActive() then
        self.cl.main.passwordmgr.new.gui:setText("MainHeaderTextLogText", self.cl.main.passwordmgr.new.logger:getLog())
    end

    if self.cl.main.passwordmgr.main.update.gui:isActive() then
        self.cl.main.passwordmgr.main.update.gui:setText("MainHeaderTextLogText", self.cl.main.passwordmgr.main.update.logger:getLog())
    end
end

function ComputerClass:cl_password_new_clearSecondInputField()
    self.cl.main.passwordmgr.new.passwordComfirm = ""
    self.cl.main.passwordmgr.new.gui:setTextRaw("MainMainInput2", "")
end

function ComputerClass:cl_password_new_onInputChanged(widgetName, text)
    if widgetName == "MainMainInput1" then
        self.cl.main.passwordmgr.new.password = text
    else
        self.cl.main.passwordmgr.new.passwordComfirm = text
    end
end


function ComputerClass:cl_password_new_onFocusChangeRequired()
    self.cl.main.passwordmgr.new.gui:setFocus("MainMainInput2")
end

function ComputerClass:cl_password_new_onSetPasswordBtnPressed()
    if #self.cl.main.passwordmgr.new.password < 5 then
        self.cl.main.passwordmgr.new.logger:showLog("scrapcomputers.computer.passwordmgr.general.new_too_short", "#f14c4c")
        self:cl_password_new_clearSecondInputField()
        return
    end

    if self.cl.main.passwordmgr.new.password ~= self.cl.main.passwordmgr.new.passwordComfirm then
        self.cl.main.passwordmgr.new.logger:showLog("scrapcomputers.computer.passwordmgr.general.new_mismatch", "#f14c4c")
        self:cl_password_new_clearSecondInputField()
        return
    end

    self.cl.playerOwnership:ownInteractable()
    self.network:sendToServer("sv_password_newPassword", self.cl.main.passwordmgr.new.password)

    -- HACK: Im too lazy to make a better implementation, i need to get this to work since 6 months ago.
    local old = self.cl_openGuiDelayed
    self.cl_openGuiDelayed = function (self)
        self.cl_openGuiDelayed = old
        self:cl_onGuiClose()
    end 

    self.cl.main.passwordmgr.new.gui:close()
end

function ComputerClass:cl_pasword_enter_open()
    self.cl.main.passwordmgr.enter.password = ""
    self.cl.main.passwordmgr.enter.gui:setTextRaw("MainMainInput", "")
    self.cl.main.passwordmgr.enter.gui:open()
end

function ComputerClass:cl_password_enter_onInputChanged(widgetName, text)
    self.cl.main.passwordmgr.enter.password = text
end

function ComputerClass:cl_password_enter_onEnterBtnPressed()
    local password = self.cl.main.passwordmgr.enter.password
    
    self.cl.main.passwordmgr.enter.password = ""
    self.cl.main.passwordmgr.enter.gui:setTextRaw("MainMainInput", "")

    if self.cl.storage.filesystem:enterEncryptionPassword(password) then
        self.cl.main.passwordmgr.enter.gui:close()
        
        self.cl.main.passwordmgr.passwordKnown = true
        self.cl.main.passwordmgr.password = password
                
        table.insert(self.cl.delayTick, function ()
            self.network:sendToServer("sv_password_sendPassword", password)
            self.cl.playerOwnership:ownInteractable()
        end)
    else
        sm.scrapcomputers.gui:alert("scrapcomputers.computer.passwordmgr.general.mismatch")
    end
end

function ComputerClass:cl_password_comfirm_open()
    self.cl.main.passwordmgr.main.comfirm.buffer = ""
    self.cl.main.passwordmgr.main.comfirm.gui:setTextRaw("MainMainInput", "")
    self.cl.main.passwordmgr.main.comfirm.gui:open()
end

function ComputerClass:cl_password_comfirm_onInputChange(_, text)
    self.cl.main.passwordmgr.main.comfirm.buffer = text
end

function ComputerClass:cl_password_comfirm_onEnterBtnPressed()
    local shouldClose = self.cl.main.passwordmgr.main.comfirm.onAccept(self.cl.main.passwordmgr.main.comfirm.buffer)

    local old = self.cl_password_comfirm_onGuiClose
    self.cl_password_comfirm_onGuiClose = function (self)
        self.cl_password_comfirm_onGuiClose = old
    end

    if shouldClose then
        self.cl.main.passwordmgr.main.comfirm.gui:close()
    end
end

function ComputerClass:cl_password_comfirm_onGuiClose()
    self.cl.main.passwordmgr.main.comfirm.onCancel()
end

function ComputerClass:cl_password_main_onButtonPressed(widgetName)
    if widgetName == "MainMainClearPasswordBtn" then
        self.cl.isOtherGuiOpening = true
        self.cl.main.passwordmgr.main.gui:close()

        self.cl.main.passwordmgr.main.comfirm.gui:setText("MainHeaderText"  , "scrapcomputers.computer.passwordmgr.clear.title")
        self.cl.main.passwordmgr.main.comfirm.gui:setText("MainMainEnterBtn", "scrapcomputers.computer.passwordmgr.clear.button")

        self.cl.main.passwordmgr.main.comfirm.onAccept = function (password)
            if self.cl.main.passwordmgr.password == password then
                self.network:sendToServer("sv_password_clearPassword", password)
                self.cl.playerOwnership:stopOwningInteractable()
                return true
            end

            sm.scrapcomputers.gui:alert("scrapcomputers.computer.passwordmgr.general.mismatch")
            return false
        end

        self.cl.main.passwordmgr.main.comfirm.onCancel = function ()
            self:cl_password_openUnknown()
        end

        self:cl_password_comfirm_open()
        return
    elseif widgetName == "MainMainUpdatePassowrdBtn" then
        self.cl.isOtherGuiOpening = true
        self.cl.main.passwordmgr.main.gui:close()

        self:cl_password_update_open()
        return
    end

    sm.scrapcomputers.logger.warn("Computer.lua", "UNIMPLEMENTED ComputerClass:cl_password_main_onButtonPressed(\"" .. widgetName .. "\")")
end

function ComputerClass:cl_password_update_open()
    self.cl.main.passwordmgr.main.update.currentPassword = ""
    self.cl.main.passwordmgr.main.update.newPassword = ""
    self.cl.main.passwordmgr.main.update.newPasswordComfirm = ""

    self.cl.main.passwordmgr.main.update.gui:setTextRaw("MainMainInput1", "")
    self.cl.main.passwordmgr.main.update.gui:setTextRaw("MainMainInput2", "")
    self.cl.main.passwordmgr.main.update.gui:setTextRaw("MainMainInput3", "")

    self.cl.main.passwordmgr.main.update.gui:open()
end

function ComputerClass:cl_password_update_onInputChanged(widgetName, text)
    if widgetName == "MainMainInput1" then
        self.cl.main.passwordmgr.main.update.currentPassword = text
    elseif widgetName == "MainMainInput2" then
        self.cl.main.passwordmgr.main.update.newPassword = text
    else
        self.cl.main.passwordmgr.main.update.newPasswordComfirm = text
    end
end

function ComputerClass:cl_password_update_onUpdateBtnPressed()
    local currentPassword = self.cl.main.passwordmgr.main.update.currentPassword
    local newPassword = self.cl.main.passwordmgr.main.update.newPassword
    local newPasswordComfirm = self.cl.main.passwordmgr.main.update.newPasswordComfirm

    if currentPassword ~= self.cl.main.passwordmgr.password then
        self.cl.main.passwordmgr.main.update.logger:showLog("scrapcomputers.computer.passwordmgr.general.invalid_old_password", "#f14c4c")
        return
    end

    if #newPassword < 5 then
        self.cl.main.passwordmgr.main.update.logger:showLog("scrapcomputers.computer.passwordmgr.general.updated_too_short", "#f14c4c")
        return
    end

    if newPassword ~= newPasswordComfirm then
        self.cl.main.passwordmgr.main.update.logger:showLog("scrapcomputers.computer.passwordmgr.general.updated_mismatch", "#f14c4c")
        return
    end

    self.cl.main.passwordmgr.password = newPassword

    self.network:sendToServer("sv_password_updatePassword", {currentPassword, newPassword})
    self.cl.main.passwordmgr.main.update.gui:close()
end

-- CLIENT - UNSAVED CHANGES GUI --

function ComputerClass:cl_unsavedChanges_onCloseCallback()
    if self.cl.main.unsavedChanges.onCloseCallback then
        self.cl.main.unsavedChanges.onCloseCallback()
    end
end

function ComputerClass:cl_unsavedChanges_onButtonPressed(widgetName)
    self.cl.main.unsavedChanges.onButtonPressedCallback(widgetName == "Yes")
    self.cl.main.unsavedChanges.gui:close()
end

-- CLIENT - SHARED TABLE CHANGE HANDLER --

function ComputerClass:client_onSharedTableChange(id, key, value, comesFromSelf)
    self.cl.storageId    = self.cl.storageId       or sm.scrapcomputers.sharedTable:getSharedTableId(self.cl.storage)
    self.cl.sharedDataId = self.cl.sharedDataId    or sm.scrapcomputers.sharedTable:getSharedTableId(self.cl.sharedData)
    
    if self.cl.storageId == id then
        sm.scrapcomputers.sharedTable:disableSync(self.cl.storage)
        
        if key == "filesystem" then
            self.cl.storage.filesystem = Filesystem:createFilesystemFromSharedTableInfo(self.cl.storage.filesystem)
            
            if self:svcl_checkEncryption(self.cl.storage.filesystem) and self.cl.main.passwordmgr.passwordKnown then
                self.cl.storage.filesystem:enterEncryptionPassword(self.cl.main.passwordmgr.password)
            end
        end

        sm.scrapcomputers.sharedTable:enableSync(self.cl.storage)
    end

    if id == self.cl.sharedDataId and not comesFromSelf then
        sm.scrapcomputers.sharedTable:disableSync(self.cl.sharedData)

        if key == "logger" then
            self.cl.sharedData.logger = sm.scrapcomputers.fancyInfoLogger:newFromSharedTable(self.cl.sharedData.logger)
            self.cl.previousLogCount = -1
        end

        sm.scrapcomputers.sharedTable:enableSync(self.cl.sharedData)

        if self.cl.playerOwnership:isOwner() and key == "hasException" and value then
            if self.cl.lastException ~= value then
                if value then
                    if self.cl.main.hasUnsavedChanges then
                        self:cl_showLog("scrapcomputers.computer.logs.error_during_runtime_has_changes", "#f14c4c")
                    else
                        local exceptionLines = self:cl_createExceptionLines()
                        if #exceptionLines == 0 then
                            self:cl_showLog("scrapcomputers.computer.logs.error_during_runtime_diff_file", "#f14c4c")
                        else
                            local file = self.cl.storage.filesystem:readFile(self.cl.main.currentlyEditingFile)
                            self:cl_rehighlightCode(file, self:cl_createExceptionLines())
                            self.cl.main.currentCode = file
                        
                            self:cl_showLog("scrapcomputers.computer.logs.error_during_runtime", "#f14c4c")
                        end
                    end
                end

                self.cl.lastException = value
            end
        end
    end
end

-- CLIENT - POWER --

function ComputerClass:cl_onPowerDataUpdate(data)
    self.cl.powerInfo = data
end

-- CLIENT - TRANSLATIONS --

function ComputerClass:cl_reloadTranslations()
    self.cl.main.unsavedChanges.gui:setText("Title"  , "scrapcomputers.computer.unsaved_changes.title")
    self.cl.main.unsavedChanges.gui:setText("Message", "scrapcomputers.computer.unsaved_changes.text")

    self.cl.filesystem.deleteGui:setText("Title"  , "scrapcomputers.computer.fs.deletion.title")
    self.cl.filesystem.deleteGui:setText("Message", "scrapcomputers.computer.fs.deletion.message")

    self.cl.main.gui:setText("MainHeaderText"       , "scrapcomputers.computer.title.main")
    self.cl.main.gui:setText("OptionsToolHeaderText", "scrapcomputers.computer.title.optionstools")
    self.cl.main.gui:setText("ExamplesHeaderText"   , "scrapcomputers.computer.title.examples")
    
    self.cl.main.gui:setText("OptionsToolsMainDeleteCachedBytecodeBtn", "scrapcomputers.computer.buttons.delete_cached_bytecode")
    self.cl.main.gui:setText("OptionsToolsMainRehighlightCodeBtn"     , "scrapcomputers.computer.buttons.rehighlight_code")
    self.cl.main.gui:setText("OptionsToolsMainRenameCurrentFile"      , "scrapcomputers.computer.buttons.rename_current_file")
    self.cl.main.gui:setText("OptionsToolsMainOpenFileExplorerBtn"    , "scrapcomputers.computer.buttons.open_file_explorer")

    self.cl.main.gui:setText("ExamplesMainLoadExampleBtn", "scrapcomputers.computer.buttons.load_example")
    self.cl.main.gui:setText("SaveMainBtn"               , "scrapcomputers.computer.buttons.save")

    self.cl.main.rename.gui:setText("MainHeaderText"  , "scrapcomputers.computer.rename.title")
    self.cl.main.rename.gui:setText("MainMainApplyBtn", "scrapcomputers.computer.rename.apply")

    self.cl.main.passwordmgr.new.gui:setText("MainHeaderText"  , "scrapcomputers.computer.passwordmgr.new.title")
    self.cl.main.passwordmgr.new.gui:setText("MainMainText1"   , "scrapcomputers.computer.passwordmgr.new.enter_text")
    self.cl.main.passwordmgr.new.gui:setText("MainMainText2"   , "scrapcomputers.computer.passwordmgr.new.comfirm_text")
    self.cl.main.passwordmgr.new.gui:setText("MainMainWarnText", "scrapcomputers.computer.passwordmgr.new.warn_text")
    self.cl.main.passwordmgr.new.gui:setText("MainMainSetBtn"  , "scrapcomputers.computer.passwordmgr.new.set_button")

    self.cl.main.passwordmgr.enter.gui:setText("MainHeaderText"  , "scrapcomputers.computer.passwordmgr.enter.title")
    self.cl.main.passwordmgr.enter.gui:setText("MainMainEnterBtn", "scrapcomputers.computer.passwordmgr.enter.enter_button")

    self.cl.main.passwordmgr.main.gui:setText("MainHeaderText"             , "scrapcomputers.computer.passwordmgr.main.title")
    self.cl.main.passwordmgr.main.gui:setText("MainMainUpdatePassowrdBtn"  , "scrapcomputers.computer.passwordmgr.main.buttons.update")
    self.cl.main.passwordmgr.main.gui:setText("MainMainClearPasswordBtn"   , "scrapcomputers.computer.passwordmgr.main.buttons.clear")

    self.cl.main.passwordmgr.main.update.gui:setText("MainHeaderText"   , "scrapcomputers.computer.passwordmgr.update.title")
    self.cl.main.passwordmgr.main.update.gui:setText("MainMainUpdateBtn", "scrapcomputers.computer.passwordmgr.update.update_button")

    self.cl.main.passwordmgr.main.update.gui:setText("MainMainText1"  , "scrapcomputers.computer.passwordmgr.update.old_password")
    self.cl.main.passwordmgr.main.update.gui:setText("MainMainText2"  , "scrapcomputers.computer.passwordmgr.update.new_password")
    self.cl.main.passwordmgr.main.update.gui:setText("MainMainText3"  , "scrapcomputers.computer.passwordmgr.update.comfirm_new_password")
    
    self.cl.filesystem.gui:setText("MainHeaderText"            , "scrapcomputers.computer.fileexplorer.main.title")
    self.cl.filesystem.gui:setText("MainMainEmptyDirectoryText", "scrapcomputers.computer.fileexplorer.main.empty_directory")

    self.cl.filesystem.gui:setText("MainMainOpenFileDirBtn"    , "scrapcomputers.computer.fileexplorer.main.buttons.open")
    self.cl.filesystem.gui:setText("MainMainRenFileDirBtn"     , "scrapcomputers.computer.fileexplorer.main.buttons.rename")
    self.cl.filesystem.gui:setText("MainMainDelFileDirBtn"     , "scrapcomputers.computer.fileexplorer.main.buttons.delete")
    self.cl.filesystem.gui:setText("MainMainNewFileDirBtn"     , "scrapcomputers.computer.fileexplorer.main.buttons.new")
    self.cl.filesystem.gui:setText("MainMainGoBackBtn"         , "scrapcomputers.computer.fileexplorer.main.buttons.go_back")
    
    self.cl.filesystem.new.gui:setText("MainHeaderText"       , "scrapcomputers.computer.fileexplorer.new.title")
    self.cl.filesystem.new.gui:setText("MainMainCreateDirBtn" , "scrapcomputers.computer.fileexplorer.new.create_directory")
    self.cl.filesystem.new.gui:setText("MainMainCreateFileBtn", "scrapcomputers.computer.fileexplorer.new.create_file")
    
    self.cl.filesystem.rename.gui:setText("MainHeaderText"  , "scrapcomputers.computer.fileexplorer.rename.title")
    self.cl.filesystem.rename.gui:setText("MainMainApplyBtn", "scrapcomputers.computer.fileexplorer.rename.apply")
end

function ComputerClass:cl_chatMessage(msg)
    if self.cl.storage.flags.allowPrinting then
        sm.gui.chatMessage(msg)
    end
end

function ComputerClass:cl_internalChatMessage(msg)
    sm.scrapcomputers.gui:chatMessage(msg)
end

function ComputerClass:cl_alert(data)
    if self.cl.storage.flags.allowAlerts then
        sm.gui.displayAlertText(data[1], data[2])
    end
end

sm.scrapcomputers.componentManager.toComponent(ComputerClass, nil, false, true)