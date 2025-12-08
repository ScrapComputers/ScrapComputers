---@class BreakerClass : ShapeClass
BreakerClass = class()
BreakerClass.maxParentCount = -1
BreakerClass.maxChildCount = -1
BreakerClass.connectionInput = sm.interactable.connectionType.computerIO + sm.interactable.connectionType.logic
BreakerClass.connectionOutput = sm.interactable.connectionType.computerIO
BreakerClass.colorNormal = sm.color.new(0xFFDC82FF)
BreakerClass.colorHighlight = sm.color.new(0xFCE8B5FF)
BreakerClass.poseWeightCount = 1

-- SERVER --

function BreakerClass:sv_createData()
    return {
        getName = function()
            return "Breaker"
        end,

        getStats = function ()
            return {}
        end,

        isActive = function ()
            return self.sv.isActive
        end,

        getPowerTransfer = function ()
            return self.sv.transferredPower
        end
   }
end

function BreakerClass:server_onCreate()
    self.sv = {
        isActive = false
    }

    local storage = self.storage:load()
    if storage == nil then
        storage = false
        self.storage:save(storage)
    end

    self.sv.interactState = storage
    self.sv.isActive = storage

    self.sv.logicControlled = false

    self.network:sendToClients("cl_updateActiveState", self.sv.isActive)

    sm.scrapcomputers.powerManager.createCustomComponent(self.shape, "breaker", {isActive = false})
end

function BreakerClass:server_onFixedUpdate()
    local isActive = false
    local parents = self.interactable:getParents(sm.interactable.connectionType.logic)

    if #parents > 0 then
        if not self.sv.logicControlled then
            self.storage:save(false)
            self.sv.logicControlled = true
        end

        for _, parent in pairs(parents) do
            if parent.active then
                isActive = true
                break
            end
        end
    else
        if self.sv.isActive and self.sv.logicControlled then
            self.sv.interactState = false
        end

        self.sv.logicControlled = false
        isActive = self.sv.interactState

        self.storage:save(isActive)
    end

    if isActive ~= self.sv.isActive then
        self.network:sendToClients("cl_updateActiveState", isActive)
    end

    self.sv.isActive = isActive
    
    sm.scrapcomputers.powerManager.updateCustomComponent(self.shape.id, {isActive = isActive})
end

function BreakerClass:sv_receiveTransferredPower(power)
    self.sv.transferredPower = power

    if self.sv.lastTransferredPower ~= power then
        self.sv.lastTransferredPower = power

        self.network:sendToClients("cl_syncTransferredPower", power)
    end
end

function BreakerClass:sv_toggleInteractState()
    self.sv.interactState = not self.sv.interactState
end

-- CLIENT --

function BreakerClass:client_onCreate()
    self.cl = {
        transferredPower = 0,
        isActive = false -- Incase needed
    }
end

function BreakerClass:client_onInteract(char, state)
    if state then
        self.network:sendToServer("sv_toggleInteractState")
    end
end

function BreakerClass:client_canInteract()
    if self.shape.usable then
        local canInteract = #self.interactable:getParents(sm.interactable.connectionType.logic) == 0

        sm.scrapcomputers.gui:showCustomInteractiveText(
            {
                {"scrapcomputers.breaker.power_transfer." .. tostring(self.cl.transferredPower > 0), sm.scrapcomputers.util.round(self.cl.transferredPower, 1)},
                canInteract and "scrapcomputers.other.generic_use" or nil
            }
        )
    end

    return canInteract and self.shape.usable
end

function BreakerClass:cl_syncTransferredPower(power)
    self.cl.transferredPower = power
end

function BreakerClass:cl_updateActiveState(state)
    self.cl.isActive = state -- Incase needed
    self.interactable:setPoseWeight(0, state and 1 or 0)
end

sm.scrapcomputers.componentManager.toComponent(BreakerClass, "PowerComponents", true, _, true)