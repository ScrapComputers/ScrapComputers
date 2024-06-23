---@diagnostic disable: duplicate-doc-field, duplicate-doc-alias
-- Used to connect all ScrapComputers Components
sm.interactable.connectionType.compositeIO = 32768

-- Used primarly for network ports
sm.interactable.connectionType.networkingIO = 65536

if sm.scrapcomputers then return end

---This is where all information on ScrapComputers are stored.
sm.scrapcomputers = {}

-- Load all the modules
local modules = {"Audio", "Base64", "Color", "JSON", "Math", "MD5", "SHA256", "Table", "Util", "Vector3", "BitStream", "VPBS"}
for _, module in pairs(modules) do
    local modulePath = "$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Scripts/Modules/"..module..".lua"

    dofile(modulePath)
    sm.log.info("ScrapComputers: Loaded Module: "..modulePath)
end

---A table containing Filters. Some are also required for functions in the sm.scrapcomputers table.
sm.scrapcomputers.filters = {}

---The Data types for sm.scrapcomputers.dataList. Great for filtering components.
---@enum sm.scrapcomputers.filters.dataType
sm.scrapcomputers.filters.dataType = {
    Displays = "Displays",
    Harddrives = "Harddrives",
    Holograms = "Holograms",
    Terminals = "Terminals",
    Radars = "Radars",
    Readers = "Readers",
    Writers = "Writers",
    NetworkPorts = "NetworkPorts",
    Antennas = "Antennas",
    Cameras = "Cameras",
    Speakers = "Speakers",
    Keyboards = "Keyboards",
    Motors = "Motors",
    Lasers = "Lasers",
    GPSs = "GPSs",
    SeatControllers = "SeatControllers",

    -- This is used for Network Port! Do not use!
    NetworkInterfaces = "NetworkInterfaces"
}

---Contains all functions, data (or whatever). Eg: Displays is a list of all displays in ScrapComputers.
sm.scrapcomputers.dataList = {
    ["Displays"] = {},
    ["Harddrives"] = {},
    ["Holograms"] = {},
    ["Terminals"] = {},
    ["Radars"] = {},
    ["Readers"] = {},
    ["Writers"] = {},
    ["WriterInters"] = {},
    ["NetworkPorts"] = {},
    ["Antennas"] = {},
    ["Cameras"] = {},
    ["Speakers"] = {},
    ["Keyboards"] = {},
    ["Motors"] = {},
    ["Lasers"] = {},
    ["GPSs"] = {},
    ["SeatControllers"] = {},
    
    -- This is used for Network Port! Do not use!
    ["NetworkInterfaces"] = {}
}

---This table contains all layout files from $CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Gui/Layout. You could also just write the names independenly.
sm.scrapcomputers.layoutFiles = {
    Computer     = "$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Gui/Layout/Computer.layout",
    Terminal     = "$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Gui/Layout/Terminal.layout",
    Register     = "$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Gui/Layout/Register.layout",
    Configurator = "$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Gui/Layout/Configurator.layout",
    Harddrive    = "$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Gui/Layout/Harddrive.layout",
    Keyboard     = "$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Gui/Layout/Keyboard.layout",
    Banned       = "$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Gui/Layout/Banned.layout",
}

---Contains json files that are uesd on scrapcomputers.
sm.scrapcomputers.jsonFiles = {
    ExamplesList      = "$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/JSON/examples.json",
    HarddriveExamples = "$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/JSON/hdd_examples.json",
    AudioList         = "$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/JSON/audio.json",
    BuiltInFonts      = "$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/JSON/fonts.json"
}

---This is the prefix for private data for a component.
sm.scrapcomputers.privateDataPrefix = "SC_PRIVATE_"

---Additional features that the normal tostring function dosen't have
---@param value any The value to convert to a string
---@return string string The value as a string
function sm.scrapcomputers.toString(value)
    if type(value) == "string" then return ""..value end
    if type(value) == "table" then return sm.scrapcomputers.table.toString(value, 1) end

---@diagnostic disable-next-line: return-type-mismatch
    return type(value) == "nil" and "nil" or tostring(value)
end

sm.log.info("ScrapComputers: Loaded Config.lua!")

-------------------------------------------------------------------------------------------
-- ACTUAL CONFIGURATION OF THE MOD (Go to next comments for a rant about it)             --
--                                                                                       --
-- "Why the f**k is the configurator randomly cause all fucking compoonents to break?    --
--  It dosen't make any sense. And its soo janky that i had to f**king rewrite it. I F** --
--  -KING HATE IT. I HOPE IT BURNS IN HELL"                                              --
--                                             -- VeraDev                                --
-------------------------------------------------------------------------------------------

---@class Configuration
---@field id string The id of the config
---@field name string The name of the config
---@field description string The description of the config
---@field selectedOption integer The current config's selected option
---@field hostOnly boolean If the configuration is host only accessable
---@field options string[] List of usable options for the config.


-- The actual configuration of the mod
sm.scrapcomputers.config = {}
sm.scrapcomputers.config.key = "1974022346117ab44f08add85a6b6e49a5bc13ce3a3cabf3b8769d13cbe4043f5b40fba363441a17f0ec4308d0072dade43a7cf8e934a595611e73e543df1c48"

-- DO NOT USE
---@private
---@type Configuration[]
sm.scrapcomputers.config.additonalConfigurations = {}

---Creates default configurations
---@param onlyDefaultConfigs boolean? If true, it will only return default configs without the addon parts. Default is false
---@return Configuration[]
function sm.scrapcomputers.config.createDefaultConfigs(onlyDefaultConfigs)
    onlyDefaultConfigs = onlyDefaultConfigs or false

    assert(type(onlyDefaultConfigs) == "boolean", "Expected boolean or nil, got "..type(onlyDefaultConfigs).. " instead.")

    local config = {
        {
            id = "scrapcomputers.computer.safe_or_unsafe_env",
            name = "Safe/Unsafe Env Mode",
            description = "Allows you to access unsafe functions. When unsafe, u have access to: _G, self, Entire sm table and etc. Some tables may be also be changed so that Lua DLL mods can modify them.",
            selectedOption = 1,
            hostOnly = false,
            options = {"Safe Env", "Unsafe Env"}
        },
        {
            id = "scrapcomputers.configurator.admin_only",
            name = "Admin-only accessable Configurator",
            description = "If its set to \"Everyone\", Anyone can access the configurator. Else only the host can access it",
            selectedOption = 1,
            hostOnly = true,
            options = {"Only Host", "Everyone"}
        },
        {
            id = "scrapcomputers.hologram.max_objects",
            name = "Max Hologram objects",
            description = "Sets a limit on how many hologram objects u can render PER hologram!\n\nOptions: Unlimited, 16, 32, 64, 128, 256 and 512",
            selectedOption = 1,
            hostOnly = false,
            options = {"Unlimited", "16 Max", "32 Max", "64 Max", "128 Max", "256 Max", "512 Max"}
        }
    }

    -- Check if it has to return the default configs, If so then do it
    if onlyDefaultConfigs then
        return config
    end

    -- Since we are NOT returning default configs, add addon configs and then return it.

    local additionalConfigs = sm.scrapcomputers.config.additonalConfigurations -- Get additonalConfigurations Contents
    local currentConfigSize = sm.scrapcomputers.table.getTotalItems(config)    -- Get config size

    local shiftedAdditionalConfigs = sm.scrapcomputers.table.shiftTableIndexes(additionalConfigs, currentConfigSize) -- Shift the table indexes
    
    -- Merge it.
    return sm.scrapcomputers.table.merge(config, shiftedAdditionalConfigs)
end

-- This one would be above the function but gotta be first defined!

---@type Configuration[]
sm.scrapcomputers.config.configurations = sm.storage.load(sm.scrapcomputers.config.key) or sm.scrapcomputers.config.createDefaultConfigs()


-- Server only functions
function sm.scrapcomputers.config.initConfig()
    if sm.isServerMode() then
        ---Converts a name to a id
        ---@param name string The config name
        ---@return string? configId The id of the config
        function sm.scrapcomputers.config.nameToId(name)
            -- Assert my dick
            assert(type(name) == "string", "bad argument #1. Expected string, got "..type(name).." instead.")

            -- Loop throug all configs
            for _, config in pairs(sm.scrapcomputers.config.configurations) do
                -- Check if the name matches
                if config.name == name then
                    -- Return its id
                    return config.id
                end
            end

            -- No need to return nil! It will do that automaticly if no return value passed!
        end

        ---Sets a config and saves it
        ---@param id string ID of config to set
        ---@param selectedOption integer The config option to set
        function sm.scrapcomputers.config.setConfig(id, selectedOption)
            -- Assert my dick
            assert(type(id            ) == "string", "bad argument #1. Expected string, got " ..type(id            ).." instead.")
            assert(type(selectedOption) == "number", "bad argument #2. Expected integer, got "..type(selectedOption).." instead.")
            
            -- Vars
            local configFound = false
            local configIndex = 0
            
            -- Loop through all configs
            for index, config in pairs(sm.scrapcomputers.config.configurations) do
                -- Check if id matches
                if config.id:lower() == id:lower() then
                    -- Update values
                    configFound = true
                    configIndex = index

                    -- Stop loop
                    break
                end
            end

            -- Assertion checks
            assert(configFound, "bad argument #1. Config not found!")
            assert(selectedOption <= sm.scrapcomputers.table.getTotalItems(sm.scrapcomputers.config.configurations[configIndex].options) and selectedOption >= 1, "bad argument #2. Out-of-Range")

            -- Update it and save it
            sm.scrapcomputers.config.configurations[configIndex].selectedOption = selectedOption
            sm.scrapcomputers.config.saveConfig()
         end
         
        -- Resets configuration to default's.
        function sm.scrapcomputers.config.resetConfiguration()
            sm.storage.saveAndSync(sm.scrapcomputers.config.key, sm.scrapcomputers.config.createDefaultConfigs()) -- Save a blank configuration
            sm.scrapcomputers.config.configurations = sm.storage.load(sm.scrapcomputers.config.key) -- Update it.
        end

        -- Saves config through all clients
        function sm.scrapcomputers.config.saveConfig()
            sm.storage.saveAndSync(sm.scrapcomputers.config.key, sm.scrapcomputers.config.configurations)
        end

        -- Creates a new config
        ---@param id string The id name
        ---@param name string The name of the config (Would be showned to Configurator)
        ---@param description string The description of the config
        ---@param hostOnly boolean If true, Only the host can modify this
        ---@param options string[] The usable options for this config
        function sm.scrapcomputers.config.createConfig(id, name, description, hostOnly, options)
            -- ID Assertion Check
            assert(type(id) == "string" , "bad argument #1. Expected string, got "..type(id         ).." instead.")

            -- Rest assert checks
            assert(type(name       ) == "string" , "bad argument #2. Expected string, got "..type(name       ).." instead.")
            assert(type(description) == "string" , "bad argument #3. Expected string, got "..type(description).." instead.")
            assert(type(hostOnly   ) == "boolean", "bad argument #4. Expected string, got "..type(hostOnly   ).." instead.")
            assert(type(options    ) == "table"  , "bad argument #5. Expected string[], got "..type(options    ).." instead.")

            -- There MUST be a option
            assert(sm.scrapcomputers.table.getTotalItems(options) > 0, "bad argument #5. Expected options, got none")
            
            -- Loop through all options
            local indexCounter = 1
            for index, value in pairs(options) do
                -- Convert indexCounter to string
                local indexCounterStr = sm.scrapcomputers.toString(indexCounter)

                -- Assertion my ass!
                assert(type(index) == "number", "bad argument #5 on index #"..indexCounterStr.." (real index: "..sm.scrapcomputers.toString(index).."). Expected number on index, got "..type(index).." instead.")
                assert(index == indexCounter, "bad argument #5 on index #"..indexCounterStr.." (real index: "..sm.scrapcomputers.toString(index)..". Expected index to be "..indexCounterStr..", got "..sm.scrapcomputers.toString(index).." instead.")
                
                assert(type(value) == "string", "bad argument #5 on index #"..indexCounterStr..". Expected string on value, got "..type(value).." instead.")
                
                -- Increase indexCounter by 1
                indexCounter = indexCounter + 1
            end

            -- Add it to the list
            table.insert(sm.scrapcomputers.config.additonalConfigurations, {
                id = id,
                name = name,
                description = description,
                selectedOption = 1,
                hostOnly = hostOnly,
                options = options
            })
        end

        ---Gets a config
        ---@param id string The id of the config to get
        ---@return Configuration config The configuration to receive
        function sm.scrapcomputers.config.getConfig(id)
            -- ID Assertion Check
            assert(type(id) == "string" , "Expected string, got "..type(id).." instead.")
                    
            -- Loop through each config and error if it's id matches with the id argument.
            for _, config in pairs(sm.scrapcomputers.config.configurations) do
                if config.id:lower() == id:lower() then
                    return config
                end
            end

            error("Config doesn't exist")
        end

        ---Returns true if the config exists
        ---@param id string The id of the config to checl
        ---@return boolean doesExist True if the config exists
        function sm.scrapcomputers.config.configExists(id)
            assert(type(id) == "string" , "Expected string, got "..type(id).." instead.")

            -- Loop through all configs
            for index, config in pairs(sm.scrapcomputers.config.configurations) do
                -- Check if id matches
                if config.id:lower() == id:lower() then
                    return true -- It exists so return true
                end
            end

            return false -- Return false since it doesnt exist
        end
    else
        -- Actual function needed for the next comment.
        local function errorCallback() error("Sandbox violation! Running server-side functions on Client-Side!") end
        
        -- All functions bellow are same as the server-side ones but will cause a sandbox error instead actually funcitoning it.
        function sm.scrapcomputers.config.nameToId          (name                                    ) errorCallback() end
        function sm.scrapcomputers.config.setConfig         (id, selectedOption                      ) errorCallback() end
        function sm.scrapcomputers.config.resetConfiguration(                                        ) errorCallback() end
        function sm.scrapcomputers.config.saveConfig        (                                        ) errorCallback() end
        function sm.scrapcomputers.config.createConfig      (id, name, description, hostOnly, options) errorCallback() end
        function sm.scrapcomputers.config.getConfig         (id                                      ) errorCallback() end
        function sm.scrapcomputers.config.configExists      (id                                      ) errorCallback() end
    end
end

sm.log.info("ScrapComputers: Loaded sm.scrapcomputers.config")

---------------------------------------------------------------------------------------
--                            AUTOMATICLY LOAD LIBRARIES                             --
---------------------------------------------------------------------------------------

dofile("$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Scripts/Managers/EnvManager.lua")
dofile("$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Scripts/Managers/ComponentManager.lua")
dofile("$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Scripts/Managers/FontManager.lua")

---------------------------------------------------------------------------------------
--          INTELISENSE RELATED - NOT USED FOR CODING BUT FOR DOCUMENTATION          --
---------------------------------------------------------------------------------------

---Drive example for a item. Do DriveExample[] for a list. (This is for HDD, VeraDev didnt know what to name it so its called a Drive Example. Used for the list on the left of where u can read/write to the saved data editbox)
---@class DriveExample
---@field name string The name of the example
---@field data table The contents of the example
---@field builtIn boolean If true, this is built into ScrapComputers and souldnt be modifed.

---Code example for a item. Do CodeExample[] for a list. (For Computer!)
---@class CodeExample
---@field name string The name of the example
---@field script string The code for the example

