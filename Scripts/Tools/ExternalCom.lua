dofile("$CONTENT_DATA/Scripts/Config.lua")

---@class ExternalComClass : ToolClass
ExternalComClass = class()

local isEnabled = true
function ExternalComClass:client_onCreate()
    if not sm.scrapcomputers.isDeveloperEnvironment() then
        isEnabled = false
        return
    end

    sm.scrapcomputers.externalCommunicator.init()
end

function ExternalComClass:client_onFixedUpdate()
    if not isEnabled or sm.game.getServerTick() % 10 ~= 0 then return end

    sm.scrapcomputers.externalCommunicator.tick()
end

function ExternalComClass:client_onRefresh()
    self:client_onCreate()
end