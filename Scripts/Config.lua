---@diagnostic disable: duplicate-doc-field
sm.interactable.connectionType.compositeIO = 131072
sm.interactable.connectionType.networkingIO = 262144

if sm.scrapcomputers then return end

-- The scrap computers API (Addon API & Internal API)
sm.scrapcomputers = {}

---------------------------------------------------------------------------------------

-- Converts

---------------------------------------------------------------------------------------

local storageConfigKey = "1974022346117ab44f08add85a6b6e49a5bc13ce3a3cabf3b8769d13cbe4043f5b40fba363441a17f0ec4308d0072dade43a7cf8e934a595611e73e543df1c48"

local isDevEnv
function sm.scrapcomputers.isDeveloperEnvironment()
    if type(isDevEnv) == "boolean" then
        return isDevEnv
    end
    
    -- This is a very hacky solution!
    -- Our Public build generator replaces all uuid's so we can release playtesting builds.
    -- But because the 2 mods have completly diffirent uuid's, we can just check if the first character is a 3 as that
    -- is the starting character of the dev uuid. If its a 6, thats the public build.
    local isPlaytestingOrDevBuild = ("632be32f-6ebd-414e-a061-d45906ae4dc6"):sub(1, 1) == "3"
    
    if isPlaytestingOrDevBuild then
        isDevEnv = true
    else
        if sm.scrapcomputers.config then
            local config = sm.scrapcomputers.config.getConfig("config.scrapcomputers.global.developerenvironment")
            isDevEnv = config.selectedOption == 2
        else
            ---@type Configuration[]
            local configs = sm.storage.load(storageConfigKey)
            for _, config in pairs(configs) do
                if config.id == "config.scrapcomputers.global.developerenvironment" then
                    isDevEnv = config.selectedOption == 2
                    return isDevEnv
                end
            end
    
            -- Please stop.
            print("Please stop breaking our mod :c")
            isDevEnv = false
            return isDevEnv
        end
    end
    
    return isDevEnv
end
sm.scrapcomputers.isDeveloperEnvironment()

---------------------------------------------------------------------------------------

--A table relating to special backend activities that need to happen between components
sm.scrapcomputers.backend = {}

-- Do not fucking put any modules behind ErrorHandler, so that you atleast can have proper error handling.
local modules = {"Logger", "ErrorHandler", "String", "Audio", "Base64", "LZ4", "Color", "JSON", "MD5", "SHA256", "Table", "Util", "Vector2", "Vector3", "BitStream", "NBS", "VirtualDisplay", "Multidisplay"}

for _, module in pairs(modules) do
    local modulePath = "$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Scripts/Modules/" .. module .. ".lua"
    dofile(modulePath)

    sm.scrapcomputers.logger.info("Config.lua", "Loaded Module: " .. modulePath)
end


---Contains all functions, data (or whatever). Eg: Displays is a list of all displays in ScrapComputers.
sm.scrapcomputers.dataList = {
    -- Removing all of these causes all of the components to break. I have no fucking idea why but IDC.

    ["Computers"] = {},
    ["Displays"] = {},
    ["Harddrives"] = {},
    ["Holograms"] = {},
    ["Terminals"] = {},
    ["Radars"] = {},
    ["InputRegisters"] = {},
    ["OutputRegisters"] = {},
    ["NetworkPorts"] = {},
    ["Antennas"] = {},
    ["Cameras"] = {},
    ["Speakers"] = {},
    ["Keyboards"] = {},
    ["Motors"] = {},
    ["Lasers"] = {},
    ["GPSs"] = {},
    ["SeatControllers"] = {},
    ["GravityControllers"] = {},
    
    ["NetworkInterfaces"] = {} -- This is not a component and we have a system to make this not needed, but it works so fuck you.
}

sm.scrapcomputers.logger.info("Config.lua", "Loaded pre-installed components!")

-- Paths to layout files
sm.scrapcomputers.layoutFiles = {
    Computer = "$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Gui/Layout/Computer.layout",
    Terminal = "$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Gui/Layout/Terminal.layout",
    Register = "$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Gui/Layout/Register.layout",
    Configurator = "$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Gui/Layout/Configurator.layout",
    Harddrive = "$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Gui/Layout/Harddrive.layout",
    Keyboard = "$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Gui/Layout/Keyboard.layout",
    Banned = "$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Gui/Layout/Banned.layout",
    ComputerESNSConfig = "$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Gui/Layout/ComputerESNSConfig.layout"
}

sm.scrapcomputers.logger.info("Config.lua", "Loaded layout file shortcuts!")

-- Paths to json files
sm.scrapcomputers.jsonFiles = {
    ExamplesList = "$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/JSON/examples.json",
    HarddriveExamples = "$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/JSON/hdd_examples.json",
    AudioList = "$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/JSON/audio.json",
    BuiltInFonts = "$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/JSON/fonts.json",
    ExternalSoftwareComminucation = "$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/JSON/externalcom.json",
}

sm.scrapcomputers.logger.info("Config.lua", "Loaded json file shortcuts!")

-- Prefix used to hide variables and tables inside component's computer api.
sm.scrapcomputers.privateDataPrefix = "SC_PRIVATE_"

---Converts a value to a string, Better than lua's tostring
---@param value any the value to convert
---@return string str The converted value as a string
function sm.scrapcomputers.toString(value)
    if type(value) == "string" then return ""..value end
    if type(value) == "table" then return sm.scrapcomputers.table.toString(value, 1) end

    return type(value) == "nil" and "nil" or tostring(value)
end

-- Configuration system --

-- The configuration to modify ScrapComputers Behaviour (including addon behaviour!)
sm.scrapcomputers.config = {}

-- The key for sm.storage
sm.scrapcomputers.config.key = storageConfigKey

-- Please do not use! Use sm.scrapcomputers.config.createConfig instead of this table!
---@type Configuration[]
sm.scrapcomputers.config.additonalConfigurations = {}

---Creates default configurations and returns it
---@param onlyDefaultConfigs boolean? If true, it will only return default configs without the addon parts. Default is false
---@return Configuration[] configs The generated configurations
function sm.scrapcomputers.config.createDefaultConfigs(onlyDefaultConfigs)
    onlyDefaultConfigs = onlyDefaultConfigs or false

    sm.scrapcomputers.errorHandler.assertArgument(onlyDefaultConfigs, nil, {"boolean"})

    local config = {}

    -- Naughty function. Trying to save code?
    local function dirtySuperNaughtyCreateConfig(id, selectedOption, hostOnly, totalOptions)
        local cfg = {id = id, name = "TRANSLATABLE_TEXT_ONLY", description = "UNKNOWN_DESCRIPTION", selectedOption = selectedOption, hostOnly = hostOnly, options = {}}
        for _ = 1, totalOptions do cfg.options[#cfg.options+1] = "TRANSLATABLE_TEXT_ONLY" end
        config[#config+1] = cfg
    end

    -- You like playing among us?
    dirtySuperNaughtyCreateConfig("scrapcomputers.computer.safe_or_unsafe_env"    , 1, false , 2)
    dirtySuperNaughtyCreateConfig("scrapcomputers.configurator.admin_only"        , 1, true  , 2)
    config[#config+1] = {id="scrapcomputers.hologram.max_objects",name="TRANSLATABLE_TEXT_ONLY",description="TRANSLATABLE_TEXT_ONLY",selectedOption=1,hostOnly=false,options={"Unlimited","16 Max","32 Max","64 Max","128 Max","256 Max","512 Max","1024 Max","2048 Max","4096 Max"}}
    dirtySuperNaughtyCreateConfig("scrapcomputers.computer.autosave"              , 1, false , 2)
    dirtySuperNaughtyCreateConfig("scrapcomputers.computer.reset_error_on_restart", 2, false , 2)
    dirtySuperNaughtyCreateConfig("scrapcomputers.computer.nanvalues"             , 2, false , 2)
    dirtySuperNaughtyCreateConfig("scrapcomputers.global.selectedLanguage"        , 1, true  , 1)
    dirtySuperNaughtyCreateConfig("scrapcomputers.global.developerenvironment"    , 1, true  , 2)

    if onlyDefaultConfigs then return config end

    local additionalConfigs = sm.scrapcomputers.config.additonalConfigurations
    local shiftedAdditionalConfigs = sm.scrapcomputers.table.shiftTableIndexes(additionalConfigs, #config)
    
    return sm.scrapcomputers.table.merge(config, shiftedAdditionalConfigs)
end

---@type Configuration[] The configurations
sm.scrapcomputers.config.configurations = sm.storage.load(sm.scrapcomputers.config.key) or sm.scrapcomputers.config.createDefaultConfigs()

---Initalizes the configuration functions.
function sm.scrapcomputers.config.initConfig()
    if not sm.isServerMode() then error("Sandbox violation! Cannot call sm.scrapcomputers.config.initConfig on the Client-Side!") end

    ---Sets a config's current selected option
    ---@param id string The id of the config
    ---@param selectedOption integer The new selected option
    function sm.scrapcomputers.config.setConfig(id, selectedOption)
        sm.scrapcomputers.errorHandler.assertArgument(id, 1, {"string"})
        sm.scrapcomputers.errorHandler.assertArgument(selectedOption, 2, {"integer"})
        
        local configIndex = nil
        
        for index, config in pairs(sm.scrapcomputers.config.configurations) do
            if config.id:lower() == id:lower() then
                configIndex = index
                break
            end
        end

        sm.scrapcomputers.errorHandler.assert(configIndex, 1, "Config not found!")
        sm.scrapcomputers.errorHandler.assert(selectedOption > 0 and selectedOption <= #sm.scrapcomputers.config.configurations[configIndex].options, 2, "Option does not exist!")

        sm.scrapcomputers.config.configurations[configIndex].selectedOption = selectedOption
        sm.scrapcomputers.config.saveConfig()
    end
    
    ---Resets the configurations to its defaults
    function sm.scrapcomputers.config.resetConfiguration()
        sm.storage.saveAndSync(sm.scrapcomputers.config.key, sm.scrapcomputers.config.createDefaultConfigs())
        sm.scrapcomputers.config.configurations = sm.storage.load(sm.scrapcomputers.config.key)
    end

    ---Saves the current configurations to the world
    function sm.scrapcomputers.config.saveConfig()
        sm.storage.saveAndSync(sm.scrapcomputers.config.key, sm.scrapcomputers.config.configurations)
    end

    ---Creates a new config.
    ---@param id string The id of the config. Reccommended to be in this format to not cause any conflicts: `[MOD_NAME].[COMPONENT_NAME].[CONFIG_NAME]`
    ---@param name string The name of the configuration
    ---@param description string The description of the config
    ---@param hostOnly boolean If it is only acceessable by the host or not
    ---@param options string[] The options the configuration has
    function sm.scrapcomputers.config.createConfig(id, name, description, hostOnly, options)
        sm.scrapcomputers.errorHandler.assertArgument(id, 1, {"string"})
        sm.scrapcomputers.errorHandler.assertArgument(name, 2, {"string"})
        sm.scrapcomputers.errorHandler.assertArgument(description, 3, {"string"})
        sm.scrapcomputers.errorHandler.assertArgument(hostOnly, 4, {"boolean"})
        sm.scrapcomputers.errorHandler.assertArgument(options, 5, {"table"}, {"string[]"})
        
        local indexCounter = 1
        for index, value in pairs(options) do
            local indexCounterStr = sm.scrapcomputers.toString(indexCounter)
            local indexTypeStr = sm.scrapcomputers.toString(index)

            sm.scrapcomputers.errorHandler.assert(type(index) == "number", nil, "bad argument #5 on index #" .. indexCounterStr .. " (real index: " .. indexTypeStr .. "). Expected number on index, got " .. type(index).." instead!")
            sm.scrapcomputers.errorHandler.assert(index == indexCounter, nil, "bad argument #5 on index #" .. indexCounterStr .. " (real index: " .. indexTypeStr .. "). Expected index to be " .. indexCounterStr .. ", got " .. indexTypeStr .. " instead!")
            
            asm.scrapcomputers.errorHandler.assert(type(value) == "string", nil, "bad argument #5 on index #" .. indexCounterStr ..". Expected string on value, got ".. type(value) .. " instead!")

            indexCounter = indexCounter + 1
        end

        table.insert(sm.scrapcomputers.config.additonalConfigurations, {
            id = id,
            name = name,
            description = description,
            selectedOption = 1,
            hostOnly = hostOnly,
            options = options,
        })
    end
end

---Converts a name to a id
---@param name string The name of the config
---@return string? id The id of the config
function sm.scrapcomputers.config.nameToId(name)
    sm.scrapcomputers.errorHandler.assertArgument(name, nil, {"string"})

    for _, config in pairs(sm.scrapcomputers.config.configurations) do
        if config.name:lower() == name:lower() then
            return config.id
        end
    end
end

---Gets a configuration by index (not id!)
---@param index integer The index to search
---@return Configuration config The configuration it has found, if discovered.
function sm.scrapcomputers.config.getConfigByIndex(index)
    sm.scrapcomputers.errorHandler.assertArgument(index, nil, {"integer"})

    local config = sm.scrapcomputers.config.configurations[index]
    sm.scrapcomputers.errorHandler.assert(config, nil, "Config not found!")

    return config
end

---Gets the total configurations and returns it
---@return integer totalConfigs The amount of configurations
function sm.scrapcomputers.config.getTotalConfigurations()
    return #sm.scrapcomputers.config.configurations
end

---Gets a configuration by id
---@param id string The ID of the config
---@return Configuration config The configuration
function sm.scrapcomputers.config.getConfig(id)
    sm.scrapcomputers.errorHandler.assertArgument(id, nil, {"string"})

    for _, config in pairs(sm.scrapcomputers.config.configurations) do
        if config.id:lower() == id:lower() then
            return config
        end
    end

    error("Config doesn't exist")
end

---Returns true if a configuration existed via ID
---@param id string The ID of the configuration
---@return boolean configExists If the configuration existed or not
function sm.scrapcomputers.config.configExists(id)
    sm.scrapcomputers.errorHandler.assertArgument(id, nil, {"string"})

    for _, config in pairs(sm.scrapcomputers.config.configurations) do
        if config.id:lower() == id:lower() then
            return true
        end
    end

    return false
end

sm.scrapcomputers.logger.info("Config.lua", "Loaded conifg API!")

---@class Configuration A configuration for ScrapComputers.
---@field id string The id of the config. Reccommended to be in this format to not cause any conflicts: `[MOD_NAME].[COMPONENT_NAME].[CONFIG_NAME]`
---@field name string The name of the config
---@field description string The description of the config
---@field selectedOption integer The current config's selected option
---@field hostOnly boolean If the configuration is host only accessable
---@field options string[] List of usable options for the config.

---------------------------------------------------------------------------------------

local managers = {"EnvManager", "ComponentManager", "FontManager", "SyntaxManager", "ExampleManager", "LanguageManager", "ASCFManager", "ExternalComManager"}

for _, manager in pairs(managers) do
    local managerPath = "$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Scripts/Managers/" .. manager .. ".lua"
    dofile(managerPath)

    sm.scrapcomputers.logger.info("Config.lua", "Loaded manager: ", managerPath)
end

---------------------------------------------------------------------------------------

dofile("$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Scripts/LuaVM/Main.lua")

sm.scrapcomputers.logger.info("Config.lua", "Fully loaded core internals of the mod!")