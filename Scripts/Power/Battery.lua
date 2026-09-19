---@class BatteryClass : ShapeClass
BatteryClass = class()
BatteryClass.maxParentCount = -1
BatteryClass.maxChildCount = -1
BatteryClass.connectionInput = sm.interactable.connectionType.computerIO
BatteryClass.connectionOutput = sm.interactable.connectionType.computerIO
BatteryClass.colorNormal = sm.color.new(0xFFDC82FF)
BatteryClass.colorHighlight = sm.color.new(0xFCE8B5FF)
BatteryClass.connectIcon = "electrical"
BatteryClass.connectIconScale = 0.75

-- SERVER --

function BatteryClass:server_onCreate()
    local charge = self.storage:load() or self.interactable:getCarryData() or (sm.scrapcomputers.powerManager.isEnabled() and 0 or self.data.maxCapacity)

    self.sv = {
        currentCharge = charge,
        usedPower = 0,
        chargePower = 0,
        isDead = true,

        lastCharge = nil,
        lastChargePower = nil,
        lastUsedPower = nil,
        lastDead = nil,
    }

    self.network:sendToClients("cl_syncCharge", self.sv.currentCharge)

    sm.scrapcomputers.powerManager.createCustomComponent(self.shape, "battery", { chargeRate = self.data.chargeRate })
    sm.scrapcomputers.powerManager.updatePowerInstance(self.shape.id, self.data.dischargeRate)
end

function BatteryClass:server_onFixedUpdate()
    self.sv.currentCharge = sm.util.clamp(self.sv.currentCharge + (self.sv.chargePower - self.sv.usedPower) * 0.025 / 3600, 0, self.data.maxCapacity)

    if self.sv.currentCharge == 0 and not self.sv.isDead then
        self.sv.isDead = true
        sm.scrapcomputers.powerManager.updatePowerInstance(self.shape.id, 0)
    elseif self.sv.currentCharge > 0 and self.sv.isDead then
        self.sv.isDead = false
        sm.scrapcomputers.powerManager.updatePowerInstance(self.shape.id, self.data.dischargeRate)
    end

    if self.sv.isDead ~= self.sv.lastDead then
        self.sv.lastDead = self.sv.isDead
        self.network:sendToClients("cl_syncDeadState", self.sv.isDead)
    end

    if self.sv.currentCharge ~= self.sv.lastCharge then
        self.sv.lastCharge = self.sv.currentCharge

        self.storage:save(self.sv.currentCharge)
        self.interactable:setCarryData(self.sv.currentCharge)

        self.network:sendToClients("cl_syncCharge", self.sv.currentCharge)
    end
end

function BatteryClass:sv_receiveChargePower(chargePower)
    if not chargePower then return end

    self.sv.chargePower = chargePower

    if chargePower ~= self.sv.lastChargePower then
        self.sv.lastChargePower = chargePower
        self.network:sendToClients("cl_syncChargePower", chargePower)
    end
end

function BatteryClass:sv_receiveUsedPower(usedPower)
    if not usedPower then return end

    self.sv.usedPower = usedPower

    if usedPower ~= self.sv.lastUsedPower then
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
            return not self.sv.isDead and self.data.dischargeRate or 0
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
        charge = 0,
        chargePower = 0,
        usedPower = 0,
        isDead = true
    }
end

function BatteryClass:client_canInteract()
    if self.shape.usable then
        local totalPower = not self.cl.isDead and self.data.dischargeRate or 0
        local unusedPower = totalPower - sm.scrapcomputers.util.round(self.cl.usedPower, 1)
        local unusedClamped = unusedPower > 0 and unusedPower or 0
        
        local chargeRatio = self.data.maxCapacity > 0 and (self.cl.charge / self.data.maxCapacity) or 0
        local chargeIndex = chargeRatio >= 0.66 and 1 or (chargeRatio >= 0.33 and 2 or 3)

        local chargeDelta = sm.scrapcomputers.util.round(self.cl.chargePower - self.cl.usedPower, 1)

        sm.scrapcomputers.gui:showCustomInteractiveText(
            {
                {"scrapcomputers.power.power_display", totalPower},
                {"scrapcomputers.power.unused_power", unusedClamped},
                {"scrapcomputers.battery.charge."..chargeIndex, sm.scrapcomputers.util.round(self.cl.charge, 1), self.data.maxCapacity},
                {"scrapcomputers.battery.charge_delta."..tostring(chargeDelta > 0), chargeDelta, self.data.chargeRate}
            }
        )
    end

    return self.shape.usable
end

function BatteryClass:client_canCarry()
    return sm.scrapcomputers.powerManager.isEnabled() and (self.cl.charge >= 0.5)
end

function BatteryClass:cl_syncDeadState(state)
    self.cl.isDead = state
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

sm.scrapcomputers.componentManager.toComponent(BatteryClass, "PowerComponents", true, nil, true)