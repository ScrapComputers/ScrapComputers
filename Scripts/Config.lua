-- Used to connect all ScrapComputers Components
sm.interactable.connectionType.compositeIO = 4096

-- Used primarly for network ports
sm.interactable.connectionType.networkingIO = 8192

---This is where all information on ScrapComputers are stored.
---
---PLEASE USE `AddonConfig` IF UR PLANNING TO USE SCRAPCOMPUTERS FOR YOUR ADDON
sc = {}

sc.__INTERNALS = {}

-- Load all the modules
local modules = {"Audio", "Base64", "Color", "JSON", "Math", "MD5", "SHA256", "Table", "Util", "Vector3"}
for _, module in pairs(modules) do
    local modulePath = "$CONTENT_3660881a-a6b8-40e5-a348-27b368a742e9/Scripts/Modules/"..module..".lua"

    dofile(modulePath)
    sm.log.info("ScrapComputers: Loaded Module: "..modulePath)
end

sc.__INTERNALS.usedModules = modules

---A table containing Filters. Some are also required for functions in the sc table.
sc.filters = {}

---The Data types for sc.dataList. Great for filtering components.
---@enum sc.filters.dataType
sc.filters.dataType = {
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

---Contains all functions, data (or whatever). Eg: Displays is a list of all displays in Scrap Computers.
sc.dataList = {
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

---This table contains all layout files from $CONTENT_3660881a-a6b8-40e5-a348-27b368a742e9/Gui/Layout. You could also just write the names independenly.
sc.layoutFiles = {
    Computer     = "$CONTENT_3660881a-a6b8-40e5-a348-27b368a742e9/Gui/Layout/Computer.layout",
    Terminal     = "$CONTENT_3660881a-a6b8-40e5-a348-27b368a742e9/Gui/Layout/Terminal.layout",
    Register     = "$CONTENT_3660881a-a6b8-40e5-a348-27b368a742e9/Gui/Layout/Register.layout",
    Configurator = "$CONTENT_3660881a-a6b8-40e5-a348-27b368a742e9/Gui/Layout/Configurator.layout",
    Harddrive    = "$CONTENT_3660881a-a6b8-40e5-a348-27b368a742e9/Gui/Layout/Harddrive.layout",
    Keyboard     = "$CONTENT_3660881a-a6b8-40e5-a348-27b368a742e9/Gui/Layout/Keyboard.layout",
    Banned       = "$CONTENT_3660881a-a6b8-40e5-a348-27b368a742e9/Gui/Layout/Banned.layout",
}

---Contains json files that are uesd on scrapcomputers.
sc.jsonFiles = {
    ExamplesList      = "$CONTENT_3660881a-a6b8-40e5-a348-27b368a742e9/JSON/examples.json",
    HarddriveExamples = "$CONTENT_3660881a-a6b8-40e5-a348-27b368a742e9/JSON/hdd_examples.json",
    AudioList         = "$CONTENT_3660881a-a6b8-40e5-a348-27b368a742e9/JSON/audio.json",
    BuiltInFonts      = "$CONTENT_3660881a-a6b8-40e5-a348-27b368a742e9/JSON/fonts.json"
}

---This is the prefix for private data for a component.
sc.privateDataPrefix = "SC_PRIVATE_"

---Gets data from sc.dataList and filters them to whats connected or not. The boolean value on argument 3 is
---
---needed incase if u want to get the chidlren or parents.
---@param dataType sc.filters.dataType The type of what object to choose. (example: sc.dataType.Display filters to be only displays from ScrapComputers)
---@param interactable Interactable    The interactable itself. (Required to filter of whats connected or not)
---@param getViaChildren boolean       If true. it gets children from interactable. else parents from interactable
---@param flags integer?               This only exists just so the network ports work. <i>(defaults to sm.interactable.connectinType.compositeIO)</i>
---@param allowPrivateData boolean     If true, the results will also have private data that shouldn't be accessable to the public. <i>(defualts to false)</i>
---@return table
function sc.getObjects(dataType, interactable, getViaChildren, flags, allowPrivateData)
    flags = flags or sm.interactable.connectionType.compositeIO -- If flags is nil, Set it to be the default value
    allowPrivateData = allowPrivateData or false -- If allowPrivateData is nil, Set it to be the default value

    local dataList = sc.dataList[dataType] -- Get the datalist
    local tbl = getViaChildren and interactable:getChildren(flags) or interactable:getParents(flags) -- Ge the children (or parents) of the interactable
    local returnValues = {} -- The values that would be returned

    for _, interactablePOR in pairs(tbl) do
        -- Get the data form the interactable
        local data = dataList[interactablePOR:getId()]

        -- Check if it exists
        if data ~= nil then
            -- If it allows private data on the output. Add it to returnValues
            if allowPrivateData then
                table.insert(returnValues, data)
            else
                -- We are here because we do NOT allow private data on the output

                -- This will contain all safe variables and functions from data.
                -- Because anything that starts with sc.privateDataPrefix is considered unsafe!
                local safeData = {}

                -- Loop through data
                ---@param index string
                for index, value in pairs(data) do
                    -- Check if it doesn't start with the prefix
                    if index:sub(1, #sc.privateDataPrefix) ~= sc.privateDataPrefix then
                        safeData[index] = value -- Add it to safeData
                    end
                end

                -- Add it to returnValues
                table.insert(returnValues, safeData)
            end
        end
    end

    -- Return returnValues
    return returnValues
end

---Additional features that the normal tostring function dosen't have
---@param value any The value to convert to a string
---@return string string The value as a string
function sc.toString(value)
    if type(value) == "string" then return ""..value end
    if type(value) == "table" then return sc.table.toString(value, 1) end

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
---@field name string The name of the config
---@field description string The description of the config
---@field selectedOption number The current config's selected option
---@field hostOnly boolean If the configuration is host only accessable
---@field options string[] List of usable options for the config.


-- The actual configuration of the mod
sc.config = {}
sc.config.key = "1974022346117ab44f08add85a6b6e49a5bc13ce3a3cabf3b8769d13cbe4043f5b40fba363441a17f0ec4308d0072dade43a7cf8e934a595611e73e543df1c48"

---@type Configuration[]
sc.config.configurations = sm.storage.load(sc.config.key)

---Creates default configurations
---@return Configuration[]
function sc.config.createDefaultConfigs()
    return {
        {
            name = "Safe/Unsafe Env Mode",
            description = "Allows you to access unsafe functions. When unsafe, u have access to: _G, self, Entire sm table and etc. Some tables may be also be changed so that Lua DLL mods can modify them.",
            selectedOption = 1,
            hostOnly = false,
            options = {"Safe Env", "Unsafe Env"}
        },
        {
            name = "Admin-only accessable Configurator",
            description = "If its set to \"Everyone\", Anyone can access the configurator. Else only the host can access it",
            selectedOption = 1,
            hostOnly = true,
            options = {"Only Host", "Everyone"}
        },
        {
            name = "Max Hologram objects",
            description = "Sets a limit on how many hologram objects u can render PER hologram!\n\nOptions: Unlimited, 16, 32, 64, 128, 256 and 512",
            selectedOption = 1,
            hostOnly = false,
            options = {"Unlimited", "16 Max", "32 Max", "64 Max", "128 Max", "256 Max", "512 Max"}
        }
    } 
end

-- Server only functions
function sc.config.initConfig()
    if sm.isServerMode() then
        -- Sets a config and saves it
        function sc.config.setConfig(name, selectedOption)
           sc.config.configurations[name].selectedOption = selectedOption -- Set option
           sc.config.saveConfig() -- Save it
        end
    
        -- Resets configuration to default's.
        function sc.config.resetConfiguration()
            sm.storage.saveAndSync(sc.config.key, sc.config.createDefaultConfigs()) -- Save a blank configuration
            sc.config.configurations = sm.storage.load(sc.config.key) -- Update it.
        end

        -- Saves config through all clients
        function sc.config.saveConfig()
            sm.storage.saveAndSync(sc.config.key, sc.config.configurations)
        end
    else
        -- Actual function needed for the next comment.
        local function errorCallback() error("Sandbox violation! Running server-side functions on Client-Side!") end
        
        -- All functions bellow are same as the server-side ones but will cause a sandbox error instead actually funcitoning it.
        function sc.config.setConfig         (name, selectedOption) errorCallback() end
        function sc.config.resetConfiguration()                     errorCallback() end
        function sc.config.saveConfig        ()                     errorCallback() end
    end
end

sm.log.info("ScrapComputers: Loaded sc.config")

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