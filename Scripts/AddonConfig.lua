-- Did you know? You cannot fucking sync a variable between 2 fucking mods! I dont understand
-- why you cant do that! Also the fact that 

dofile("$CONTENT_3660881a-a6b8-40e5-a348-27b368a742e9/Scripts/Config.lua")

local oldsc = sc

sc = {}
sc.addon = {}

---Converts a class to a ScrapComputersComponent
---@param classData ShapeClass
---@param dataType string
function sc.addon.CreateComponent(classData, dataType)
	-- Validate input parameters
    assert(type(classData) == "table", "bad argument #1. Expected ShapeClass, Got "..type(classData).." instead!")
    assert(type(classData.sv_createData) == "function", "sv_createData does NOT exist!")
    
    -- Store any existing server_onCreate function
    local _server_onCreate = classData.server_onCreate
    
    -- Override the server_onCreate function
    classData.server_onCreate = function (self)
        self.interactable.publicData = {
            SCRAPCOMPUTERS_PUBLIC_DATA = {
                self = self, -- Reference to `self`
                dataType = dataType,
                getEnv = classData.sv_createData
            }
        }

        -- Call the original server_onCreate if it exists
        if _server_onCreate then
            _server_onCreate(self)
        end
    end
    
    -- Store any existing server_onRefresh function
    local _server_onRefresh = classData.server_onRefresh
    
    -- Override the server_onRefresh function
    classData.server_onRefresh = function (self)
        classData.server_onCreate(self) -- Refresh by calling the new server_onCreate

        -- Call the original server_onRefresh if it exists
        if _server_onRefresh then
            _server_onRefresh(self)
        end
    end

    -- Store any existing client_onCreate function
    local _client_onCreate = classData.client_onCreate
    
    -- Override the client_onCreate function
    classData.client_onCreate = function (self)
        -- Call the original client_onCreate if it exists
        if _client_onCreate then
            _client_onCreate(self)
        end
    end
    
    -- Store any existing client_onRefresh function
    local _client_onRefresh = classData.client_onRefresh
    
    -- Override the client_onRefresh function
    classData.client_onRefresh = function (self)
        classData.client_onCreate(self) -- Refresh by calling the new client_onCreate

        -- Call the original client_onRefresh if it exists
        if _client_onRefresh then
            _client_onRefresh(self)
        end
    end
end

-- Transfer the used modules from the old `sc` to the new `sc`
for _, module in pairs(oldsc.__INTERNALS.usedModules) do
    sc[module:lower()] = oldsc[module:lower()]
end

-- Copy additional properties from the old `sc` to the new `sc`
sc.layoutFiles = oldsc.layoutFiles
sc.jsonFiles = oldsc.jsonFiles
sc.toString = oldsc.toString