dofile("$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Scripts/Config.lua")

---@class ComponentTest : ShapeClass
ComponentTest = class()
ComponentTest.maxParentCount = 1
ComponentTest.maxChildCount = 0
ComponentTest.connectionInput = sm.interactable.connectionType.compositeIO
ComponentTest.connectionOutput = sm.interactable.connectionType.none
ComponentTest.colorNormal = sm.color.new(0x696969ff)
ComponentTest.colorHighlight = sm.color.new(0x969696ff)

-- SERVER --

function ComponentTest:sv_createData()
    return {
        getState = function ()
            return sm.scrapcomputers.config.getConfig("test_config").selectedOption
        end
    }
end

-- Convert the class to a component
sm.scrapcomputers.components.ToComponent(ComponentTest, "ComponentTest", true)