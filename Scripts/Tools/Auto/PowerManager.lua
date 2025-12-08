dofile("$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Scripts/Config.lua")

---@class PowerManagerClass : ToolClass
PowerManagerClass = class()

function PowerManagerClass:server_onCreate()
end

local useage = {}

function PowerManagerClass:server_onFixedUpdate()
    local computers = sm.scrapcomputers.backend.computerManager.computers
    local avaliablePower = sm.scrapcomputers.table.clone(sm.scrapcomputers.powerManager.powerTable)
    local powerComponents = {}
    local updatedGenerators = {}
    local breakerPowers = {}
    local powerEnabled = sm.scrapcomputers.powerManager.isEnabled()

    for _, klass in pairs(computers) do
        if sm.exists(klass.shape) then
            powerComponents[klass.shape.id] = {type = "computer", klass = klass}
        end
    end

    for _, customData in pairs(sm.scrapcomputers.powerManager.customTable) do
        if sm.exists(customData.shape) then
            powerComponents[customData.shape.id] = customData
        end
    end

    for _, powerComponent in pairs(powerComponents) do
        local type_ = powerComponent.type
        local klass = powerComponent.klass
        local allChilds = {}
        local parents = {}
        local viaBreakers = {}

        local pptNeeded = 0

        local function recursiveFind(interactable, flags)
            if sm.exists(interactable) then
                for _, child in pairs(interactable:getChildren(flags)) do
                    if child.shape and child.shape.id and not allChilds[child.shape.id] then
                        allChilds[child.shape.id] = child
                        recursiveFind(child)
                    end
                end
            end
        end

        local function getTrueParents(customComponentP, breakerTree)
            if not breakerTree then breakerTree = {customComponentP.shape} end
    
            local breakerParents = customComponentP.shape.interactable:getParents(sm.interactable.connectionType.computerIO)
            local anySuccess

            for i, breakerParent in pairs(breakerParents) do
                local customComponent = sm.scrapcomputers.powerManager.customTable[breakerParent.shape.id]

                if customComponent and customComponent.type == "breaker" and customComponent.data.isActive then
                    anySuccess = true

                    table.insert(breakerTree, customComponent.shape)
                    getTrueParents(customComponent, breakerTree)
                else
                    local broke

                    for i, parent in pairs(parents) do
                        if parent == breakerParent then
                            broke = true
                            break
                        end
                    end

                    if not broke then
                        anySuccess = true

                        table.insert(parents, breakerParent)
                        viaBreakers[breakerParent.shape.id] = breakerTree
                    end
                end
            end

            if not anySuccess then
                table.remove(breakerTree, #breakerTree)
            end
        end


        if type_ == "computer" then
            local active

            for _, parent in pairs(klass.interactable:getParents(sm.interactable.connectionType.logic)) do
                if parent.active then
                    active = true
                    break
                end
            end

            if (active or klass.sv.storage.flags.alwaysOn) and not klass.sv.luaVM:hasException() then
                recursiveFind(klass.interactable, sm.interactable.connectionType.compositeIO)

                pptNeeded = sm.util.clamp(math.abs(klass.sv.sharedData.memoryTrackerData.avgDiff / 10), 0.1, 100)

                for shapeId in pairs(allChilds) do
                    local powerPoints = sm.scrapcomputers.powerManager.powerTable[shapeId]

                    if powerPoints then
                        pptNeeded = pptNeeded + powerPoints
                    end
                end
            end

            parents = klass.interactable:getParents(sm.interactable.connectionType.computerIO)

            for i, parent in pairs(parents) do
                local customComponent = sm.scrapcomputers.powerManager.customTable[parent.shape.id]

                if customComponent and customComponent.type == "breaker" then
                    parents[i] = nil

                    if customComponent.data.isActive then
                        getTrueParents(customComponent)
                    end
                end
            end
        elseif type_ == "battery" then
            pptNeeded = powerComponent.data.chargeRate
            parents = powerComponent.shape.interactable:getParents(sm.interactable.connectionType.computerIO)

            for i, parent in pairs(parents) do
                local customComponent = sm.scrapcomputers.powerManager.customTable[parent.shape.id]

                if customComponent and customComponent.type == "breaker" then
                    parents[i] = nil

                    if customComponent.data.isActive then
                        getTrueParents(customComponent)
                    end
                end
            end
        end
        
        local totalPower = 0

        for _, powerSource in pairs(parents) do
            totalPower = totalPower + avaliablePower[powerSource.shape.id]
        end

        local generatedActual = 0

        for _, powerSource in pairs(parents) do
            local availPower = avaliablePower[powerSource.shape.id]
            local used = 0

            local takePower = availPower / totalPower * pptNeeded + 0.01 -- Floating point garbage

            if takePower <= availPower then
                used = takePower
                generatedActual = generatedActual + takePower
                avaliablePower[powerSource.shape.id] = availPower - takePower
            else
                used = availPower
                generatedActual = generatedActual + availPower
                avaliablePower[powerSource.shape.id] = 0
            end

            local childBreakers = viaBreakers[powerSource.shape.id]

            if childBreakers then
                for _, breaker in pairs(childBreakers) do
                    if not breakerPowers[breaker.id] then breakerPowers[breaker.id] = 0 end
                    
                    breakerPowers[breaker.id] = breakerPowers[breaker.id] + used
                end
            end

            if not useage[powerSource.shape.id] then useage[powerSource.shape.id] = {src = powerSource, count = 0} end

            useage[powerSource.shape.id].count = useage[powerSource.shape.id].count + used
            updatedGenerators[powerSource.shape.id] = true
        end

        if type_ == "computer" then
            local hasPower = generatedActual >= pptNeeded and pptNeeded ~= 0

            if not powerEnabled then
                hasPower = true
            end

            klass.sv.hasPower = hasPower
            klass.sv.totalPPTNeeded = pptNeeded
            if not hasPower and klass.sv.wasPowered then
                for _, child in pairs(allChilds) do
                    if child:getType() == "scripted" then
                        sm.event.sendToInteractable(child, "sv_onPowerLoss")
                    end
                end

                klass.sv.wasPowered = false
            elseif hasPower then
                klass.sv.wasPowered = true
            end
        elseif type_ == "battery" then
            sm.event.sendToInteractable(powerComponent.shape.interactable, "sv_receiveChargePower", powerEnabled and generatedActual or powerComponent.data.chargeRate)
        end
    end

    for id, source in pairs(useage) do
        if sm.exists(source.src) then
            if updatedGenerators[id] then
                sm.event.sendToInteractable(source.src, "sv_receiveUsedPower", source.count)
            else
                sm.event.sendToInteractable(source.src, "sv_receiveUsedPower", 0)
            end

            source.count = 0
        else
            useage[id] = nil
        end
    end

    for _, customComponent in pairs(sm.scrapcomputers.powerManager.customTable) do
        if customComponent.type == "breaker" then
            sm.event.sendToInteractable(customComponent.shape.interactable, "sv_receiveTransferredPower", breakerPowers[customComponent.shape.id] or 0)
        end
    end
end

function PowerManagerClass:server_onRefresh()
    self:server_onCreate()
end
