-- This only exist's so that the config actually works. If this gets tamperted and a error happens
-- The entire mod WILL FALL APART! This peice of sh*t is soo bad that VeraDev had to REWRITE THE
-- ENTIRE CONFIGURATOR JUST SO IT DOESN'T CAUSE BULLSH*T ANYMORE.
--
-- So if ur forking this mod. FOR THE LOVE OF GOD PLEASE MAKE THIS BETTER AND DESH*TIFY THIS ALL.
--      also please make the updateConfig better since i hate it.

dofile("$CONTENT_DATA/Scripts/Config.lua")

---@class ConfigManager : ShapeClass
ConfigManager = class()

-- The next 2 functiions are code that would be removed later, They only exist so the users have time to update there configs without the mod shatting itself.
-- So if you see this. better not ask why the name is long.
--
-- And again: V E R A D E V   H A T E S   W O R K I N G   O N   T H E   C O N F I G S Y S T E M  A N D   H E  W A N T S  T O   C O M M I T   D I E
-- yk what? fuck this im going back to stone age. fuck my life and this code can suck my dick!

function ConfigManager:sv_dangerously_function_that_should_be_deleted_on_the_next_update_because_of_config_system_change_please_do_not_call_this_for_the_love_of_god()
    if sm.scrapcomputers.config.configurations[1] and not sm.scrapcomputers.config.configurations[1].id then
        sm.log.error("[ConfigManager - Updater]: You have outdated configurations! Your configs have been reset!")
        sm.scrapcomputers.config.resetConfiguration()
        self.network:sendToClients("cl_dangerously_function_that_should_be_deleted_on_the_next_update_because_of_config_system_change_please_do_not_call_this_for_the_love_of_god")
    end
end

function ConfigManager:cl_dangerously_function_that_should_be_deleted_on_the_next_update_because_of_config_system_change_please_do_not_call_this_for_the_love_of_god()
    sm.gui.chatMessage("ScrapComputers: Your configurations were reset due to an update. Please rejoin the world. Contact us if the message persists.")
end

function ConfigManager:sv_updateConfig()
    -- Get default configs
    local defaultConfig = sm.scrapcomputers.config.createDefaultConfigs()
    local needsSaving = false
    local hasSavedConfigs = false

    -- Loop through all default configs
    for index, config in ipairs(defaultConfig) do
        -- Check if it exists on the current config
        if sm.scrapcomputers.config.configExists(config.id) then
            -- Get currrent config from loop (NOT from defualt! from sm.scrapcomputers.config.configurations!)
            local curConfig = sm.scrapcomputers.config.configurations[index]

            -- Check if theres a diffirence between the current available options and the default available options.
            -- (Incase developer ever decides to add/remove options)
            if sm.scrapcomputers.table.getTotalItems(curConfig.options) ~= sm.scrapcomputers.table.getTotalItems(config.options) then
                -- Readd all options for that config.
                sm.log.warning("[ConfigManager - Updater]: Current Configuration for \""..curConfig.id.."\" has diffirent available options than the default one! Recreating them...")
                sm.scrapcomputers.config.configurations[index].options = unpack({config.options})
                
                -- Set this to true
                needsSaving = true
            end

            -- Check if theres a description diffirence
            if curConfig.description ~= config.description then
                -- Readd description  for that config.
                sm.log.warning("[ConfigManager - Updater]: Current Configuration for \""..curConfig.id.."\" has outdated description! Updating it...")
                sm.scrapcomputers.config.configurations[index].description = config.description

                -- Set this to true
                needsSaving = true
            end

            -- Check if theres a hostOnly diffirence
            if curConfig.hostOnly ~= config.hostOnly then
                -- Readd hostOnly for that config.
                sm.log.warning("[ConfigManager - Updater]: Current Configuration for \""..curConfig.id.."\" has outdated host-only! Updating it...")
                sm.scrapcomputers.config.configurations[index].hostOnly = config.hostOnly

                -- Set this to true
                needsSaving = true
            end

            -- Check if theres a name diffirence
            if curConfig.name ~= config.name then
                -- Readd name for that config.
                sm.log.warning("[ConfigManager - Updater]: Current Configuration for \""..curConfig.id.."\" has outdated name! Updating it...")
                sm.scrapcomputers.config.configurations[index].name = config.name

                -- Set this to true
                needsSaving = true
            end
        else
            -- Since it dosen't. Update it
            sm.log.warning("[ConfigManager - Updater]: Missing config \""..config.id.."\"! Adding it...")
            sm.scrapcomputers.config.configurations[index] = unpack({config})

            -- Set this to true
            needsSaving = true
        end
    end

    -- If it needs to save, save it.
    if needsSaving then
        sm.scrapcomputers.config.saveConfig()
        hasSavedConfigs = true -- Set hasSavedConfigs to true since we saved someting
        
        -- Reset needsSaving
        needsSaving = false
    end

    -- Identify and delete obsolete configs that are not in the default config
    for index, curConfig in ipairs(sm.scrapcomputers.config.configurations) do
        -- If true, the config is founded
        local found = false

        -- Loop through all configs
        for _, config in ipairs(defaultConfig) do
            -- Check if they match
            if curConfig.id:lower() == config.id:lower() then
                -- Set this to true and stop loop
                found = true
                break
            end
        end

        -- Check if it hasent found anything
        if not found then
            -- Send log and delete it
            sm.log.warning("[ConfigManager - Updater]: Configuration \""..curConfig.id.."\" will be removed. (Addon might have been removed or addon removed it!)")
            table.remove(sm.scrapcomputers.config.configurations, index)

            -- Set this to true
            needsSaving = true
        end
    end

    -- If it needs to save, save it.
    if needsSaving then
        sm.scrapcomputers.config.saveConfig()
        hasSavedConfigs = true -- Set hasSavedConfigs to true since we saved someting
    end

    -- If it has saved anything, log it.
    if hasSavedConfigs then
        sm.log.info("[ConfigManager - Updater]: Configs got changed! Saved it!")
    end
end

function ConfigManager:server_onCreate()
    -- Initalize Config
    sm.scrapcomputers.config.initConfig()

    self:sv_dangerously_function_that_should_be_deleted_on_the_next_update_because_of_config_system_change_please_do_not_call_this_for_the_love_of_god()

    sm.log.info("[ConfigManager]: Initalized ScrapComputers Configuration Manager!")

    -- Reset the configurations if it dosen't even exist (resetting works as creating new config)
    if not sm.scrapcomputers.config.configurations then
        sm.log.warning("[ConfigManager]: No configuration saved! Resetting config...")
        sm.scrapcomputers.config.resetConfiguration()
    end

    self.sv_serverStartingTick = sm.game.getServerTick() -- Get the tick when this was created
    self.sv_serverAllowTick = self.sv_serverStartingTick + 40
end

function ConfigManager:server_onFixedUpdate()
    -- Check if the config is even initalized. If not, initalize it (We only have to check 1 function)
    if not sm.scrapcomputers.config.getConfig then
        sm.log.warning("[ConfigManager]: Server-side functions not initalized! Initalizing them....")
        sm.scrapcomputers.config.initConfig()
    end

    -- Only allow updating afther sv_serverStartingTick is 40 ticks behind
    if self.sv_serverStartingTick == self.sv_serverAllowTick then
        -- Check if it can update once per seccond
        if sm.game.getServerTick() % 40 == 0 then
            -- Update it
            self:sv_updateConfig()
        end
    else
        self.sv_serverStartingTick = self.sv_serverStartingTick + 1
    end
end

-- Dev mode related
function ConfigManager:server_onRefresh() self:server_onCreate() end