---@class BatteryClassClass : ShapeClass
BatteryClass = class()
BatteryClass.maxParentCount = -1
BatteryClass.maxChildCount = -1
BatteryClass.connectionInput = sm.interactable.connectionType.computerIO
BatteryClass.connectionOutput = sm.interactable.connectionType.computerIO
BatteryClass.colorNormal = sm.color.new(0xFFDC82FF)
BatteryClass.colorHighlight = sm.color.new(0xFCE8B5FF)

-- SERVER --

function BatteryClass:server_onCreate()
    self.sv = {
        currentCharge = self.storage:load() or ((sm.scrapcomputers.powerManager.isEnabled() and 0) or self.data.maxCapacity),
        usedPower = 0,
        chargePower = 0
    }

    self.network:sendToClients("cl_syncCharge", self.sv.currentCharge)

    sm.scrapcomputers.powerManager.createCustomComponent(self.shape, "battery", {chargeRate = self.data.chargeRate})
    sm.scrapcomputers.powerManager.updatePowerInstance(self.shape.id, self.data.dischargeRate)
end

function BatteryClass:server_onFixedUpdate()
    self.sv.currentCharge = sm.util.clamp(self.sv.currentCharge + (self.sv.chargePower - self.sv.usedPower) * 0.025 / 3600, 0, self.data.maxCapacity)
    self.sv.currentCharge = self.sv.currentCharge * 0.9999999

    if self.sv.currentCharge == 0 and not self.sv.dead then
        sm.scrapcomputers.powerManager.updatePowerInstance(self.shape.id, 0)
        self.sv.dead = true
    elseif self.sv.currentCharge ~= 0 and self.sv.dead then
        sm.scrapcomputers.powerManager.updatePowerInstance(self.shape.id, self.data.dischargeRate)
        self.sv.dead = false
    end

    if self.sv.currentCharge ~= self.sv.lastCharge then
        self.sv.lastCharge = self.sv.currentCharge
        self.storage:save(self.sv.currentCharge)

        self.network:sendToClients("cl_syncCharge", self.sv.currentCharge)
    end

    if not sm.scrapcomputers.powerManager.isEnabled() then
        self.sv.currentCharge = self.data.maxCapacity
    end
end

function BatteryClass:sv_receiveChargePower(chargePower)
    self.sv.chargePower = chargePower

    if chargePower ~= self.sv.lastChargePower and chargePower then
        self.sv.lastChargePower = chargePower
        self.network:sendToClients("cl_syncChargePower", chargePower)
    end
end

function BatteryClass:sv_receiveUsedPower(usedPower)
    self.sv.usedPower = usedPower

    if usedPower ~= self.sv.lastUsedPower and usedPower then
        self.sv.lastUsedPower = usedPower
        self.network:sendToClients("cl_syncUsedPower", usedPower)
    end
end

function BatteryClass:sv_createData()
    return {
        getName = function ()
            return "Battery"
        end,

        getPower = function ()
            return not self.sv.dead and self.data.dischargeRate or 0
        end,

        getUsedPower = function ()
            return self.sv.usedPower or 0
        end,

        getStats = function ()
            return {
                dischargeRate = self.data.dischargeRate, 
                chargeRate = self.data.chargeRate, 
                maxCapacity = self.data.maxCapacity
            }
        end,

        getCharge = function ()
            return self.sv.currentCharge
        end,

        getChargeDelta = function ()
            return sm.scrapcomputers.util.round(self.sv.chargePower - self.sv.usedPower, 1)
        end
   }
end

-- CLIENT --

function BatteryClass:client_onCreate()
    self.cl = {
        usedPower = 0,
        chargePower = 0
    }
end

function BatteryClass:client_canInteract()
    local totalPower = not self.sv.dead and self.data.dischargeRate or 0
    local unusedPower = totalPower - sm.scrapcomputers.util.round(self.cl.usedPower, 1)
    local unusedClamped = unusedPower > 0 and unusedPower or 0
    local chargeIndex

    if self.cl.charge == 0 then
        chargeIndex = 3
    else
        chargeIndex = sm.util.clamp(math.floor(self.data.maxCapacity / self.cl.charge), 1, 3)
    end

    local chargeDelta = sm.scrapcomputers.util.round(self.cl.chargePower - self.cl.usedPower, 1)

    sm.scrapcomputers.gui:showCustomInteractiveText(
        {
            {"scrapcomputers.power.power_display", not self.sv.dead and self.data.dischargeRate or 0},
            {"scrapcomputers.power.unused_power", unusedClamped},
            {"scrapcomputers.battery.charge."..chargeIndex, sm.scrapcomputers.util.round(self.cl.charge, 1), self.data.maxCapacity},
            {"scrapcomputers.battery.charge_delta."..tostring(chargeDelta > 0), chargeDelta, self.data.chargeRate}
        }
    )

    return true
end

function BatteryClass:cl_syncCharge(charge)
    self.cl.charge = charge
end

function BatteryClass:cl_syncChargePower(chargePower)
    self.cl.chargePower = chargePower
end

function BatteryClass:cl_syncUsedPower(usedPower)
    self.cl.usedPower = usedPower
end

sm.scrapcomputers.componentManager.toComponent(BatteryClass, "PowerComponents", true, _, true)