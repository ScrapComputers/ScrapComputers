---@class ComponentTemplateClass : ShapeClass
SolarPanelClass = class()
SolarPanelClass.maxParentCount = 0
SolarPanelClass.maxChildCount = -1
SolarPanelClass.connectionInput = sm.interactable.connectionType.computerIO + sm.interactable.connectionType.logic
SolarPanelClass.connectionOutput = sm.interactable.connectionType.computerIO
SolarPanelClass.colorNormal = sm.color.new(0xFFDC82FF)
SolarPanelClass.colorHighlight = sm.color.new(0xFCE8B5FF)

-- CLIENT / SERVER --

local localPanelNormal = sm.vec3.new(0, 1, 0):rotateX(math.rad(20))
local sunDir = sm.vec3.new(-0.232843, -0.688331, 0.687011)

-- SERVER --

function SolarPanelClass:sv_createData()
    return {
        getName = function ()
            return "Solar Panel"
        end,

        getPower = function ()
            return self.sv.totalPower
        end,

        getUsedPower = function ()
            return self.sv.usedPower
        end,

        getEfficiency = function ()
            return (self.sv.totalPower / self.data.maxOutput) * 100
        end,

        getStats = function ()
            return {
                maxOutput = self.data.maxOutput,
            }
        end
    }
end

function SolarPanelClass:server_onCreate()
    self.sv = {
        totalPower = 0,
        usedPower = 0
    }
end

function SolarPanelClass:server_onFixedUpdate()
    local dir = self.shape.worldRotation * localPanelNormal
    local start = self.shape.worldPosition
    local hit, res = sm.physics.raycast(start, start + sunDir * 20, self.shape)

    local efficiency = 0

    if not (hit and res.type ~= "limiter") then
        efficiency = sm.util.clamp(dir:dot(sunDir), 0, 1)
    end

    local time = sm.game.getTimeOfDay()
    if time < 0.2 or time > 0.9 then
        efficiency = 0
    end

    local totalPower = efficiency * self.data.maxOutput
    self.sv.totalPower = totalPower

    sm.scrapcomputers.powerManager.updatePowerInstance(self.shape.id, totalPower)

    if self.sv.lastPower ~= totalPower then
        self.network:sendToClients("cl_receiveTotalPower", totalPower)
        self.sv.lastPower = totalPower
    end
end

function SolarPanelClass:sv_receiveUsedPower(usedPower)
    self.sv.usedPower = usedPower

    if self.sv.lastUsedPower ~= usedPower then
        self.network:sendToClients("cl_receiveUsedPower", usedPower)
        self.sv.lastUsedPower = usedPower
    end
end

-- CLIENT --

function SolarPanelClass:client_onCreate()
    self.cl = {
        totalPower = 0,
        usedPower = 0
    }
end

function SolarPanelClass:client_canInteract()
    local totalPower = sm.scrapcomputers.util.round(self.cl.totalPower, 1)
    local unusedPower = totalPower - sm.scrapcomputers.util.round(self.cl.usedPower, 1)
    local unusedClamped = unusedPower > 0 and unusedPower or 0

    sm.scrapcomputers.gui:showCustomInteractiveText(
        {
            {"scrapcomputers.power.power_display", totalPower},
            {"scrapcomputers.power.unused_power", unusedClamped},
            {"scrapcomputers.solarpanel.efficiency", sm.scrapcomputers.util.round(sm.util.clamp(totalPower / self.data.maxOutput, 0, 1), 3) * 100, "%"}
        }
    )

    return true
end

function SolarPanelClass:cl_receiveTotalPower(totalPower)
    self.cl.totalPower = totalPower
end


function SolarPanelClass:cl_receiveUsedPower(usedPower)
    self.cl.usedPower = usedPower
end

sm.scrapcomputers.componentManager.toComponent(SolarPanelClass, "PowerComponents", true, _, true)