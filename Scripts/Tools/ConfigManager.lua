-- This only exist's so that the config actually works. If this gets tamperted and a error happens
-- The entire mod WILL FALL APART! This peice of sh*t is soo bad that VeraDev had to REWRITE THE
-- ENTIRE CONFIGURATOR JUST SO IT DOESN'T CAUSE BULLSH*T ANYMORE.
--
-- So if ur forking this mod. FOR THE LOVE OF GOD PLEASE MAKE THIS BETTER AND DESH*TIFY THIS ALL.
--      also please make the updateConfig better since i hate it.

dofile("$CONTENT_DATA/Scripts/Config.lua")
dofile("$CONTENT_DATA/Scripts/FontManager.lua") -- We dont use any functionalities from FontManager but we load it so it loads when world gets loaded

---@class ConfigManager : ShapeClass
ConfigManager = class()

function ConfigManager:sv_updateConfig()
    -- Get default configs
    local defualtConfig = sc.config.createDefaultConfigs()

    -- Loop through all default configs
    for index, config in ipairs(defualtConfig) do
        -- Check if it exists on the current config
        if sc.config.configurations[index] then
            -- Get currrent config from loop (NOT from defualt! from sc.config.configurations!)
            local curConfig = sc.config.configurations[index]

            -- Check if theres a diffirence between the current available options and the default available options.
            -- (Incase developer ever decides to add/remove options)
            if sc.table.getTotalItems(curConfig.options) ~= sc.table.getTotalItems(config.options) then
                -- Readd all options for that config.
                sm.log.warning("[ConfigManager - Updater]: Current Configuration for \""..curConfig.name.."\" has diffirent available options than the default one! Recreating them...")
                sc.config.configurations[index].options = unpack({config.options})
                sc.config.saveConfig()
            end
        else
            -- Since it dosen't. Update it
            sm.log.warning("[ConfigManager - Updater]: Missing config option! Adding it... (NAME: \""..config.name.."\")")
            sc.config.configurations[index] = unpack({config})
        end
    end
end

function ConfigManager:server_onCreate()
    -- Initalize Config
    sc.config.initConfig()
    sm.log.info("[ConfigManager]: Initalized ScrapComputers Configuration Manager!")

    -- Reset the configurations if it dosen't even exist (resetting works as creating new config)
    if not sc.config.configurations then
        sm.log.warning("[ConfigManager]: No configuration saved! Resetting config...")
        sc.config.resetConfiguration()
    else
        self:sv_updateConfig() -- Update config
    end
end

function ConfigManager:server_onFixedUpdate()
    -- Check if the config is even initalized. If not, initalize it (We only have to check 1 function)
    if not sc.config.setConfig then
        sm.log.warning("[ConfigManager]: Server-side functions not initalized! Initalizing them....")
        sc.config.initConfig()
    end

    -- Update the configurator for every 1 secconds
    if sm.game.getServerTick() % 40 == 0 then
        self:sv_updateConfig() -- Update config
    end
end

-- Dev mode related
function ConfigManager:server_onRefresh() self:server_onCreate() end