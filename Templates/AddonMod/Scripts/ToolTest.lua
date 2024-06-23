dofile("$CONTENT_3660881a-a6b8-40e5-a348-27b368a742e9/Scripts/Config.lua")

---@class ToolTest : ToolClass
ToolTest = class()

---@param self ShapeClass
function EnvHook(self)
    return {
        sc = {
            getTest = function () return sm.scrapcomputers.components.getComponents("ComponentTest", self.interactable, true) end
        }
    }
end

table.insert(sm.scrapcomputers.envManager.envHooks, EnvHook)

function ToolTest:server_onCreate()
    sm.scrapcomputers.config.initConfig()
    sm.scrapcomputers.config.createConfig("test_config", "Test Configuration", "HahaYes", false, {"Test 1", "Test2"})
end
