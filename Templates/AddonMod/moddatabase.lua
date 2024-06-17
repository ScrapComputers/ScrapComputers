---@diagnostic disable

-- Mod database didn't have its own syntax highlighting function. so i made one!
-- Add this code below if u want to actually use ModDatabase
-- ```lua
-- dofile("$CONTENT_40639a2c-bb9f-4d4f-b88c-41bfe264ffa8/Scripts/ModDatabase.lua")
-- ```
---@class ModDatabase
ModDatabase = {}

-- Loads the Description Database
function ModDatabase.loadDescriptions() end

-- Loads the Shapesets Database
function ModDatabase.loadShapesets() end

-- Loads the Toolsets Database
function ModDatabase.loadToolsets() end

-- Loads the HarvestableSets Database
function ModDatabase.loadHarvestablesets() end

-- Loads the KinematicsSets Database
function ModDatabase.loadKinematicsets() end

-- Loads the Characterset Database
function ModDatabase.loadCharactersets() end

-- Loads the ScriptableObjectSets Database
function ModDatabase.loadScriptableobjectsets() end

-- Unloads the Description database
function ModDatabase.unloadDescriptions() end

-- Unloads the Shapesets database
function ModDatabase.unloadShapesets() end

-- Unloads the Toolsets database
function ModDatabase.unloadToolsets() end

-- Unloads the HarvestableSets database
function ModDatabase.unloadHarvestablesets() end

-- Unloads the KinematicsSets database
function ModDatabase.unloadKinematicsets() end

-- Unloads the Characterset database
function ModDatabase.unloadCharactersets() end

-- Unloads the ScriptableObjectSets database
function ModDatabase.unloadScriptableobjectsets() end

---Returns true if a mod is loaded
---@param localId string The mod local id
---@return nil|boolean modLoaded Returns true if loaded, false if not and nil if it doesn't even exist.
function ModDatabase.isModLoaded(localId) end

---Gets all loaded mods
---@return string[] loadedMods All mods that are loaded (each item is a local id of the mod!)
function ModDatabase.getAllLoadedMods() end

---Returns true if a mod is installed
---@param localId string The mod local id
---@return nil|boolean modInstalled Returns true if installed, false if not and nil if it doesn't even exist.
function ModDatabase.isModInstalled(localId) end

---Returns all installed mods.
---
---### Warning: This is not recommended to do, as it will try to open a file for each mod, causing a long freeze. Also logs 2 lines for each mod not found, increasing it's size by about 500kB.
---@return string[] loadedMods All mods that are installed (each item is a local id of the mod!)
function ModDatabase.getAllInstalledMods() end