---@class ComponentTemplateClass : ShapeClass
GeneratorClass = class()
GeneratorClass.maxParentCount = 0
GeneratorClass.maxChildCount = -1
GeneratorClass.connectionInput = sm.interactable.connectionType.none
GeneratorClass.connectionOutput = sm.interactable.connectionType.computerIO + sm.interactable.connectionType.bearing
GeneratorClass.colorNormal = sm.color.new(0xFFDC82FF)
GeneratorClass.colorHighlight = sm.color.new(0xFCE8B5FF)

local xMin, xMax = -0.27777, -0.0644805
local yMin, yMax = -0.131733, 0.0308426


-- SERVER --

function GeneratorClass:sv_createData()
    return {
        getName = function ()
            return "Generator"
        end,

        getPower = function ()
            return self.sv.totalPower
        end,

        getUsedPower = function ()
            return self.sv.usedPower
        end,

        getStats = function ()
            return {
                efficiency = self.data.efficiency, 
                maxResistance = self.data.maxResistance
            }
        end,

        setHandlePosition = function (handlePos)
            sm.scrapcomputers.errorHandler.assertArgument(handlePos, 1, {"number"})
            handlePos = sm.util.clamp(handlePos, 0, 1)

            self.sv.updateHandlePos = sm.scrapcomputers.util.mapValue(handlePos, 0, 1, 0.01, 1)
        end,

        getHandlePosition = function ()
            return sm.scrapcomputers.util.mapValue(self.sv.handlePos, 0.01, 1, 0, 1)
        end
    }
end

function GeneratorClass:server_onCreate()
    self.sv = {
        totalPower = 0,
        usedPower = 0
    }

    local handlePos = self.storage:load()

    if handlePos then
        self.sv.handlePos = handlePos
        self.network:sendToClients("cl_setHandlePos", handlePos)
    end
end

function GeneratorClass:server_onFixedUpdate()
    if self.sv.updateHandlePos then
        self:sv_saveHandlePos(self.sv.updateHandlePos)
        self:sv_setHandlePos(self.sv.updateHandlePos)

        self.sv.updateHandlePos = nil
    end
end

function GeneratorClass:sv_saveHandlePos(handlePos)
    self.sv.handlePos = handlePos
    self.network:sendToClients("cl_setHandlePos", handlePos)
    self.storage:save(handlePos)
end

function GeneratorClass:sv_setHandlePos(handlePos)
    self.sv.handlePos = handlePos
    self.network:sendToClients("cl_setHandlePos", handlePos)
end

function GeneratorClass:sv_updatePower(totalPower)
    self.sv.totalPower = totalPower
    sm.scrapcomputers.powerManager.updatePowerInstance(self.shape.id, totalPower)
end

function GeneratorClass:sv_receiveUsedPower(usedPower)
    self.sv.usedPower = usedPower
    self.network:sendToClients("cl_receiveUsedPower", usedPower)
end

-- CLIENT --

function GeneratorClass:client_onCreate()
    self.cl = {
        handlePos = 0.01,
        usedPower = 0,
        totalPower = 0
    }

    self.interactable:setAnimEnabled("HandleBone", true)
    self.interactable:setAnimProgress("HandleBone", 0.01)
end

function GeneratorClass:client_canInteract()
    if self.shape.usable then
        local _, result = sm.localPlayer.getRaycast(7.5)
        local interactPoint = self.shape:transformPoint(result.pointWorld)

        if interactPoint.x > xMin and interactPoint.y > yMin and interactPoint.x < xMax and interactPoint.y < yMax then
            self.cl.canInteract = true
            self.cl.xIntersect = interactPoint.x
        else
            self.cl.canInteract = false
        end

        local bottom = {
            "scrapcomputers.other.generic_use",
        }

        local totalPower = sm.scrapcomputers.util.round(self.cl.totalPower, 1)
        local unusedPower = totalPower - sm.scrapcomputers.util.round(self.cl.usedPower, 1)
        local unusedClamped = unusedPower > 0 and unusedPower or 0

        sm.scrapcomputers.gui:showCustomInteractiveText(
            {
                {"scrapcomputers.power.power_display", totalPower},
                {"scrapcomputers.power.unused_power", unusedClamped},
                {"scrapcomputers.generator.resistance", sm.scrapcomputers.util.round(self.cl.handlePos * self.data.maxResistance, 1)}
            },
            self.cl.canInteract and bottom or nil
        )
    end

    return self.shape.usable
end

function GeneratorClass:client_onInteract(char, state)
    if state and self.cl.canInteract then
        self.cl.sethandle = true
    elseif not state then
        self.cl.sethandle = false
    end
end

function GeneratorClass:client_onFixedUpdate()
    local totalPower = 0
    local currentResistance = self.cl.handlePos * self.data.maxResistance

    for _, joint in pairs(self.interactable:getJoints()) do
        local shapeB = joint.shapeB

        if sm.exists(shapeB) then
            local rpm = (joint.shapeA.body.angularVelocity - shapeB.body.angularVelocity):length() * 9.549296585513721
            
            joint:setMotorVelocity(0, currentResistance)
            totalPower = totalPower + (rpm * currentResistance / 9550) * self.data.efficiency
        end
    end

    self.cl.totalPower = totalPower > 0.001 and totalPower or 0
    self.network:sendToServer("sv_updatePower", totalPower)
end

function GeneratorClass:client_onUpdate(dt)
    if self.cl.sethandle and self.cl.xIntersect then
        local buffer = 0.02
        local handlePos = (self.cl.xIntersect + math.abs(xMin + buffer)) / (xMax - xMin - buffer * 2)

        self.cl.handlePos = sm.util.lerp(self.cl.handlePos, handlePos, dt * 7)
        self.cl.handlePos = sm.util.clamp(self.cl.handlePos, 0.01, 1)

        self.interactable:setAnimProgress("HandleBone", self.cl.handlePos)

        if self.cl.handlePos ~= self.cl.lastHandlePos then
            self.cl.lastHandlePos = self.cl.handlePos

            self.network:sendToServer("sv_saveHandlePos", self.cl.handlePos)
        end
    end
end

function GeneratorClass:client_getAvailableChildConnectionCount(connectionType)
    if connectionType == sm.interactable.connectionType.bearing then
        return 1 - #self.interactable:getChildren(connectionType)
    end

    return 1
end

function GeneratorClass:cl_setHandlePos(handlePos)
    self.cl.handlePos = handlePos
    self.interactable:setAnimProgress("HandleBone", handlePos)
end

function GeneratorClass:cl_receiveUsedPower(usedPower)
    self.cl.usedPower = usedPower
end

sm.scrapcomputers.componentManager.toComponent(GeneratorClass, "PowerComponents", true, _, true)