dofile("$CONTENT_DATA/Scripts/AddonConfig.lua")

---@class Component : ShapeClass
Component = class()
Component.maxParentCount = 1
Component.maxChildCount = 0
Component.connectionInput = sm.interactable.connectionType.compositeIO
Component.connectionOutput = sm.interactable.connectionType.none
Component.colorNormal = sm.color.new(0x696969ff)
Component.colorHighlight = sm.color.new(0x969696ff)

-- SERVER --

function Component:sv_createData()
    return {
        helloWorld = function()
            print("A")
        end
    }
end

-- Convert the class to a component
sc.addon.CreateComponent(Component, "Component")