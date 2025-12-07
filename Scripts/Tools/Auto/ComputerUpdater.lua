dofile("$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Scripts/Config.lua")

---@class ComputerUpdaterClass : ToolClass
ComputerUpdaterClass = class()

function ComputerUpdaterClass:server_onCreate()
end

function ComputerUpdaterClass:server_onFixedUpdate()
    if not sm.scrapcomputers or not sm.scrapcomputers.computerManager then return end

    sm.scrapcomputers.computerManager:update()
end

function ComputerUpdaterClass:server_onRefresh()
    self:server_onCreate()
end