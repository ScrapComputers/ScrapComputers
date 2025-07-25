dofile("$CONTENT_DATA/Scripts/Config.lua")

---@class ConfigManagerClass : ShapeClass
ConfigManagerClass = class()

local function movingAverage(num, averageBuffer, bufferIndex, count)
    averageBuffer[bufferIndex] = num;
    bufferIndex = (bufferIndex + 1)%count
  
    local runningAverage = 0

    for k, v in pairs(averageBuffer) do
        if k >= count then
            v = 0
        else
            runningAverage = runningAverage + v
        end
    end

    return runningAverage / count, averageBuffer, bufferIndex
end

function ConfigManagerClass:server_onCreate()
    sm.scrapcomputers.config.initConfig()

    sm.scrapcomputers.logger.info("ConfigManager.lua", "Initalized ScrapComputers Configuration Manager!")

    if not sm.scrapcomputers.config.configurations then
        sm.scrapcomputers.logger.warn("ConfigManager.lua", "No configuration saved! Resetting config...")
        sm.scrapcomputers.config.resetConfiguration()
    end

    local serverTick = sm.game.getServerTick()

    self.sv = {
        serverStartingTick = serverTick,
        serverAllowTick = serverTick + 40,
        resettedConfigs = {}
    }

    self:sv_updateConfig()
end

function ConfigManagerClass:server_onFixedUpdate()
    if not sm.scrapcomputers.config.getConfig then
        sm.scrapcomputers.logger.warn("ConfigManager.lua", "Server-side functions not initalized! Initalizing them....")
        sm.scrapcomputers.config.initConfig()
        self:sv_updateConfig()
    end

    if self.sv.serverStartingTick == self.sv.serverAllowTick then
        if sm.game.getServerTick() % 40 then
            if #self.sv.resettedConfigs > 0 then
                self.network:sendToClients("self.sv.resettedConfigs")
                self.sv.resettedConfigs = {}
            end
        end
    else
        self.sv.serverStartingTick = self.sv.serverStartingTick + 1
    end

    if sm.scrapcomputers.PIDHandler and sm.scrapcomputers.table.getTableSize(sm.scrapcomputers.PIDHandler.processes) > 0 then
        if sm.scrapcomputers.table.getTableSize(sm.scrapcomputers.dataList["Computers"]) == 0 then
            sm.scrapcomputers.PIDHandler.processes = {}
        end

        for _, process in pairs(sm.scrapcomputers.PIDHandler.processes) do
            local _error = process.setValue - process.processValue
            process.dBuffer[process.dBufferIndex] = _error
            local lasterror = (process.dBuffer[(process.dBufferIndex - process.deltatimeD)%20] == nil) and _error or process.dBuffer[(process.dBufferIndex - process.deltatimeD)%20]
            
            local maOut
            maOut, process.averageBuffer, process.bufferIndex = movingAverage(_error, process.averageBuffer, process.bufferIndex, process.deltatimeI)
            
            local output = _error * process.p + maOut * process.i + (_error - lasterror) * process.d
            output = sm.util.clamp(output, -4096, 4096)

            process.dBufferIndex = (process.dBufferIndex + 1)%20
            process.PIDOut = output
        end
    end
end

function ConfigManagerClass:server_onRefresh() self:server_onCreate() end

function ConfigManagerClass:sv_updateConfig()
    local defaultConfig = sm.scrapcomputers.config.createDefaultConfigs()
    local needsSaving = false

    for index, config in ipairs(defaultConfig) do
        if sm.scrapcomputers.config.configExists(config.id) then
            local curConfig = sm.scrapcomputers.config.configurations[index]

            if #curConfig.options ~= #config.options then
                sm.scrapcomputers.logger.warn("ConfigManager.lua", "Current Configuration for \"" .. curConfig.id .. "\" has diffirent available options than the default one! Recreating them... ")
                sm.scrapcomputers.config.configurations[index].options = unpack({config.options})
                
                needsSaving = true
            end

            if curConfig.description ~= config.description then
                sm.scrapcomputers.logger.warn("ConfigManager.lua", "Current Configuration for \"" .. curConfig.id .. "\" has outdated description! Updating it...")
                sm.scrapcomputers.config.configurations[index].description = config.description

                needsSaving = true
            end

            if curConfig.hostOnly ~= config.hostOnly then
                sm.scrapcomputers.logger.warn("ConfigManager.lua", "Current Configuration for \"" .. curConfig.id .. "\" has outdated host-only! Updating it...")
                sm.scrapcomputers.config.configurations[index].hostOnly = config.hostOnly

                needsSaving = true
            end

            if curConfig.name ~= config.name then
                sm.scrapcomputers.logger.warn("ConfigManager.lua", "Current Configuration for \"" .. curConfig.id .. "\" has outdated name! Updating it...")
                sm.scrapcomputers.config.configurations[index].name = config.name

                needsSaving = true
            end

            local incorrectConfigOptions = #curConfig.options ~= #config.options

            if not incorrectConfigOptions then
                for optionIndex, optionValue in pairs(curConfig.options) do
                    if optionValue ~= config.options[optionIndex] then
                        incorrectConfigOptions = true
                        break
                    end
                end
            end

            if incorrectConfigOptions then
                sm.scrapcomputers.logger.warn("ConfigManager.lua", "Current Configuration for \"" .. curConfig.id .. "\" has invalid options! Updating it...")
                sm.scrapcomputers.config.configurations[index].options = config.options

                if curConfig.selectedOption > #config.options then
                    sm.scrapcomputers.logger.warn("ConfigManager.lua", "Current Configuration for \"" .. curConfig.id .. "\" selected option is out-of-bounds! Resetting it... (Mentioned to user aswel!)")
                    curConfig.selectedOption = config.selectedOption

                    table.insert(self.sv.resettedConfigs, config.name)
                end

                needsSaving = true
            end
        else
            sm.scrapcomputers.logger.warn("ConfigManager.lua", "Missing config \"" .. config.id .. "\"! Adding it...")
            sm.scrapcomputers.config.configurations[index] = unpack({config})

            needsSaving = true
        end
    end

    for index, curConfig in ipairs(sm.scrapcomputers.config.configurations) do
        local found = false

        for _, config in ipairs(defaultConfig) do
            if curConfig.id:lower() == config.id:lower() then
                found = true
                break
            end
        end

        if not found then
            sm.scrapcomputers.logger.warn("ConfigManager.lua", "Configuration \"" .. curConfig.id .. "\" will be removed. (Addon might have been removed or a addon removed it!)")
            table.remove(sm.scrapcomputers.config.configurations, index)

            needsSaving = true
        end
    end

    if needsSaving then
        sm.scrapcomputers.config.saveConfig()

        sm.scrapcomputers.logger.info("ConfigManager.lua", "Configs got changed! Saved it!")
    end
end

-- CLIENT --

function ConfigManagerClass:client_onCreate() end
function ConfigManagerClass:client_onRefresh() self:client_onCreate() end

function ConfigManagerClass:cl_printResettedConfigurations(data)
    local message = "ScrapComputers has resetted " .. sm.scrapcomputers.toString(#data) .. " configurations because of a config change which caused there selected config to be invalid.\n\nConfigurations:#eb4034"
    
    for _, name in pairs(data) do
        local translatableName = "config." .. name .. "=name"
        local actualName = sm.scrapcomputers.languageManager.translatable(translatableName)
        if actualName == translatableName then actualName = name end
        
        message = message .. "\n\t" .. actualName
    end

    sm.gui.chatMessage(message)
end