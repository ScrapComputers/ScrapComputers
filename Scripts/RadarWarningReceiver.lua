---@class RadarWarningReceiverClass : ShapeClass
RadarWarningReceiverClass = class()
RadarWarningReceiverClass.maxParentCount = -1
RadarWarningReceiverClass.maxChildCount = 0
RadarWarningReceiverClass.connectionInput = sm.interactable.connectionType.compositeIO
RadarWarningReceiverClass.connectionOutput = sm.interactable.connectionType.none
RadarWarningReceiverClass.colorNormal = sm.color.new(0x696969ff)
RadarWarningReceiverClass.colorHighlight = sm.color.new(0x969696ff)

-- SERVER --

function RadarWarningReceiverClass:server_onCreate()
    sm.scrapcomputers.powerManager.updatePowerInstance(self.shape.id, 10)
end

function RadarWarningReceiverClass:sv_createData()
    return {
        ---Gets the radars that are actively targeting the creation
        ---@return RadarPosition[] radarPositions The positions of the targeting radars
        getTargets = function()
            local radarTargets = sm.scrapcomputers.backend.radarTargets
            
            if radarTargets then
                local radarPositions = radarTargets[self.shape.body:getCreationId()]

                if radarPositions then
                    return sm.scrapcomputers.table.numberlyOrderTable(radarPositions)
                end
            end
        end
   }
end

sm.scrapcomputers.componentManager.toComponent(RadarWarningReceiverClass, "RadarWarningReceivers", true, nil, true)