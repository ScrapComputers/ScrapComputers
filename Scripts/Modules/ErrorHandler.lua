sm.scrapcomputers.errorHandler = {}

local sm_scrapcomputers_config = sm.scrapcomputers.config

local tostring = tostring
local type = type
local enumType = enumType -- TODO: Migrate all type checks to enumType
local pairs = pairs
local unpack = unpack
local error = error
local string_format = string.format
local math_floor = math.floor

--- TODO: Probably all game types, because the original sm.types is incomplete.
LUA_TYPES = {
	[0] = "nil", ["nil"] = 0,
	[1] = "boolean", ["boolean"] = 1,
	[2] = "lightUserdata", ["lightUserdata"] = 2,
	[3] = "number", ["number"] = 3,
	[4] = "string", ["string"] = 4,
	[5] = "table", ["table"] = 5,
	[6] = "function", ["function"] = 6,
	[7] = "userdata", ["userdata"] = 7,
	[8] = "thread", ["thread"] = 8,
	
	[10001] = "Uuid", ["Uuid"] = 10001,
	[10003] = "Vec3", ["Vec3"] = 10003,
	[10004] = "Quat", ["Quat"] = 10004,
	[10005] = "Color", ["Color"] = 10005,
	[10006] = "RaycastResult", ["RaycastResult"] = 10006,
	[10007] = "LoadCellHandle", ["LoadCellHandle"] = 10007,
	[10008] = "Effect", ["Effect"] = 10008,
	
	[10021] = "Shape", ["Shape"] = 10021,
	[10022] = "Body", ["Body"] = 10022,
	[10023] = "Interactable", ["Interactable"] = 10023,
	[10024] = "Container", ["Container"] = 10024,
	[10025] = "Harvestable", ["Harvestable"] = 10025,
	[10026] = "Network", ["Network"] = 10026,
	[10027] = "World", ["World"] = 10027,
	[10028] = "Unit", ["Unit"] = 10028,
	[10029] = "Storage", ["Storage"] = 10029,
	[10030] = "Player", ["Player"] = 10030,
	[10031] = "Character", ["Character"] = 10031,
	[10032] = "Joint", ["Joint"] = 10032,
	[10033] = "AiState", ["AiState"] = 10033,
	[10034] = "Quest", ["Quest"] = 10034,
	[10035] = "AreaTrigger", ["AreaTrigger"] = 10035,
	[10036] = "Portal", ["Portal"] = 10036,
	[10037] = "PathNode", ["PathNode"] = 10037,
	[10038] = "Lift", ["Lift"] = 10038,
	[10039] = "ScriptableObject", ["ScriptableObject"] = 10039,
	[10040] = "BuilderGuide", ["BuilderGuide"] = 10040,
	[10041] = "CullSphereGroup", ["CullSphereGroup"] = 10041,
	[10042] = "VoxelTerrain", ["VoxelTerrain"] = 10042,
	[10043] = "JsonGui", ["JsonGui"] = 10043,
	[10044] = "JsonWidget", ["JsonWidget"] = 10044,
	[10045] = "ClientScriptableObject", ["ClientScriptableObject"] = 10045,

	[20002] = "Tool", ["Tool"] = 20002,
	[20006] = "GuiInterface", ["GuiInterface"] = 20006,
	[20007] = "BlueprintVisualization", ["BlueprintVisualization"] = 20007,
	[20008] = "Garage", ["Garage"] = 20008,
}

--- Optimized assert function
---@param value any The value to check
---@param argumentIndex integer? The index where this value was
---@param str string The message when it errors
---@param ... any[]
function sm.scrapcomputers.errorHandler.assert(value, argumentIndex, str, ...)
    if value then return end

    local parameters = {...}
    local formattingMessage = str and string_format(str, unpack(parameters)) or "Assertion Failed!"

    local badMessage = argumentIndex and ("Bad argument #" .. tostring(argumentIndex) .. "! ") or ""
    error(badMessage .. formattingMessage)
end

--- Optimized assertArgument function for function arguments
---@param value          any       The value to check
---@param argumentIndex  integer?  Index of the argument (e.g., 3 for the 3rd argument)
---@param allowedTypes   table     List of allowed types
---@param nameOverwrites table?    Optional names to modify error message (e.g., {"number", nil, "string"})
function sm.scrapcomputers.errorHandler.assertArgument(value, argumentIndex, allowedTypes, nameOverwrites)
    local valueType = type(value)
    local isNanValue = (value ~= value)
    local valueHasCorrectType = false

    -- Check NaN config setting
    local shouldCareAboutNanValues = true

    -- This fucking function gets called when Config.lua loads. but its before the Config system gets loaded.
    -- So i gotta do this bullshit. Great infrastructure that VeraDev has made. Great infrastructure asshole.
    if sm_scrapcomputers_config and sm_scrapcomputers_config.configurations then
        for _, config in pairs(sm_scrapcomputers_config.configurations) do
            if config.id == "scrapcomputers.computer.nanvalues" then
                shouldCareAboutNanValues = config.selectedOption == 2
                break
            end
        end
    end

    -- Check allowed types
    if not (isNanValue and shouldCareAboutNanValues) then
        -- TODO: Check if this shit is faster
        for _, allowedType in pairs(allowedTypes) do
            local allowedTypeIsInteger = allowedType == "integer"
            if valueType == (allowedTypeIsInteger and "number" or allowedType) then
                if not allowedTypeIsInteger or math_floor(value) == value then
                    valueHasCorrectType = true
                    break
                end
            end
        end
    end

    if valueHasCorrectType then return end
    valueType = isNanValue and shouldCareAboutNanValues and "NaN" or valueType

    -- Construct the allowed types message
    local allowedTypesMessage = ""
    for i, allowedType in ipairs(allowedTypes) do
        local typeMessage = nameOverwrites and (nameOverwrites[i] or allowedType) or allowedType
        allowedTypesMessage = allowedTypesMessage .. (i == 1 and "" or (i == #allowedTypes and " or " or ", ")) .. typeMessage
    end

    -- Construct and raise the error
    local badArgument = argumentIndex and ("Bad argument #" .. tostring(argumentIndex) .. "! ") or ""
    error(string_format("%sExpected %s, got %s instead!", badArgument, allowedTypesMessage, valueType))
end

---Runs a sandbox assertion check
---@param isServer boolean If it should check if its running as server or client
function sm.scrapcomputers.errorHandler.sandboxAssert(isServer)
    if sm.isServerMode() ~= isServer then
        local tbl = {
            [true] = "server",
            [false] = "client"
        }

        error(string_format("Attempted to run a %s-side only function as %s!", tbl[isServer], tbl[not isServer]))
    end
end