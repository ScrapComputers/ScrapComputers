dofile("$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Scripts/Config.lua")

---@class ToolTest : ToolClass
ToolTest = class()

---@param self ShapeClass
local function enviromentHook(self)
    return {
        sc = {
            getTest = function () return sm.scrapcomputers.componentManager.getComponents("ComponentTest", self.interactable, true) end
        }
    }
end

table.insert(sm.scrapcomputers.enviromentManager.enviromentHooks, enviromentHook)

function ToolTest:server_onCreate()
    sm.scrapcomputers.config.initConfig()
    sm.scrapcomputers.config.createConfig("test_config", "Test Configuration", "HahaYes", false, {"Test 1", "Test2"})
end
