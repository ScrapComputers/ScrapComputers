---@class LightClass : ShapeClass
LightClass = class()
LightClass.maxParentCount = -1
LightClass.maxChildCount = 0
LightClass.connectionInput = sm.interactable.connectionType.compositeIO
LightClass.connectionOutput = sm.interactable.connectionType.none
LightClass.colorNormal = sm.color.new(0x872740ff)
LightClass.colorHighlight = sm.color.new(0xc4365cff)

-- SERVER --

function LightClass:server_onCreate()
    sm.scrapcomputers.powerManager.updatePowerInstance(self.shape.id, 0.1)
end

function LightClass:sv_createData()
    return {
        setColor = function (color)
            sm.scrapcomputers.errorHandler.assertArgument(color, nil, {"string", "Color"})
            self.shape.color = type(color) == "string" and sm.color.new(color) or color
        end,
        getColor = function () return self.shape.color end
    }
end

function LightClass:sv_onPowerLoss()
    self.shape.color = sm.color.new(0, 0, 0)
end

sm.scrapcomputers.componentManager.toComponent(LightClass, "Lights", true, nil, true)