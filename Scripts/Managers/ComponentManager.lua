-- Manages components and lets you create them
sm.scrapcomputers.componentManager = {}

local PRIVATE_DATA_PREFIX = sm.scrapcomputers.privateDataPrefix

local string_sub = string.sub
local table_insert = table.insert
local bit_band = bit.band

local SCRAPCOMPUTERS_FLAGS = sm.interactable.connectionType.compositeIO + sm.interactable.connectionType.networkingIO + sm.interactable.connectionType.computerIO

COMPONENT_MANAGER_REGISTERED_COMPONENTS = COMPONENT_MANAGER_REGISTERED_COMPONENTS or {}
local COMPONENT_MANAGER_REGISTERED_COMPONENTS = COMPONENT_MANAGER_REGISTERED_COMPONENTS

---Hooks your class so you can create components easly. For addon developers, this is required to be called on all of your components and interactables.
---For components, All variables must be used, isAComponent would be true.
---For Interactables, Same for components but you can set componentType to nil and isAComponent to false.
---@param classData ShapeClass The interactable's (or component) class
---@param componentType string The type of component, Make sure this does not be a conflict with other addons or the mod itself!
---@param isAComponent boolean Set this to true if your interactable is a component!
---@param automaticRefreshGen boolean? If this is NIL or true, It will generate *_onRefersh functions. (Defaults to true)
---@param isPowered boolean? Wether the component requires power when the power setting is active.
---@param isInvisible boolean? Wether the component is invisible to getters.
function sm.scrapcomputers.componentManager.toComponent(classData, componentType, isAComponent, automaticRefreshGen, isPowered, isInvisible)
    sm.scrapcomputers.errorHandler.assertArgument(classData, 1, {"table"}, {"ShapeClass"})
    sm.scrapcomputers.errorHandler.assertArgument(componentType, 2, {"string", "nil"})
    sm.scrapcomputers.errorHandler.assertArgument(isAComponent, 3, {"boolean"})
    sm.scrapcomputers.errorHandler.assertArgument(automaticRefreshGen, 4, {"boolean", "nil"})
    sm.scrapcomputers.errorHandler.assertArgument(isPowered, 5, {"boolean", "nil"})
    sm.scrapcomputers.errorHandler.assertArgument(isInvisible, 6, {"boolean", "nil"})

    isPowered = isPowered == true
    isInvisible = isInvisible == true
    if automaticRefreshGen == nil then automaticRefreshGen = true end
    
    if isAComponent then
        sm.scrapcomputers.dataList[componentType] = sm.scrapcomputers.dataList[componentType] or {}
    end

    local createServerDataOriginal = classData.sv_createData
    classData.sv_createData = function(self)
        local data = createServerDataOriginal(self)

        if not isAComponent then return data end

        local function hookFunctions(root)
            local output = {}
            for key, value in pairs(root) do
                local valueType = type(value)

                if valueType == "table" then
                    output[key] = hookFunctions(value)
                elseif valueType == "function" then
                    output[key] = function (...)
                        if not self._sc_dnm_allowExecution then
                            error("Cannot find component!")
                        end
                        return root[key](...)
                    end
                else
                    output[key] = value
                end
            end

            return output
        end
        
        local output = hookFunctions(data)
        if type(output) ~= "table" then
            return output
        end

        if not output.getId and isAComponent then
            output.getId = function()
                return self.shape.id
            end
        end

        return output
    end

    local computerUuid = sm.uuid.new("c44f6e8e-b0b8-4821-83a5-7928c1446df0")
    local serverOnFixedUpdate = classData.server_onFixedUpdate
    classData.server_onFixedUpdate = function(self, dt)
        if isAComponent and self.shape.uuid ~= computerUuid then
            local parents = self.interactable:getParents(sm.interactable.connectionType.compositeIO + sm.interactable.connectionType.networkingIO)
            local children = self.interactable:getChildren(sm.interactable.connectionType.compositeIO + sm.interactable.connectionType.networkingIO)
            
            self._sc_dnm_allowExecution = #parents + #children > 0
        end

        if serverOnFixedUpdate then serverOnFixedUpdate(self, dt) end
    end

    local serverOnDestroyOriginal = classData.server_onDestroy
    classData.server_onDestroy = function(self)
        if isAComponent then
            sm.scrapcomputers.dataList[componentType][self.shape.id] = nil
        end

        if isPowered then
            sm.scrapcomputers.powerManager.removePowerInstance(self.shape.id)
        end
    
        if serverOnDestroyOriginal then serverOnDestroyOriginal(self) end
    end

    local serverOnCreateOriginal = classData.server_onCreate
    classData.server_onCreate = function(self)
        local dataListInstance = {}
        if isAComponent then
            sm.scrapcomputers.dataList[componentType][self.shape.id] = dataListInstance
        end

        if serverOnCreateOriginal then serverOnCreateOriginal(self) end
        
        self._sc_dnm_allowExecution = true

        if isAComponent then
            local createdData = classData.sv_createData(self)

            for key, value in pairs(createdData) do
                dataListInstance[key] = value
            end
        end

        if isPowered then
            sm.scrapcomputers.powerManager.createPowerInstance(self.shape.id)
        end
    end

    if not classData.client_onCreate then
        classData.client_onCreate = function () end
    end

    if classData.client_onInteract and not classData.client_canInteract then
        classData.client_canInteract = function (self)
            sm.scrapcomputers.gui:showInteractTextBasic(self.shape.uuid)
            return true    
        end
    end

    if automaticRefreshGen then
        local clientRefreshOriginal = classData.client_onRefresh
        classData.client_onRefresh = function(self)
            classData.client_onCreate(self)

            if clientRefreshOriginal then clientRefreshOriginal(self) end
        end

        local serverRefreshOriginal = classData.server_onRefresh
        classData.server_onRefresh = function(self)
            classData.server_onCreate(self)

            if serverRefreshOriginal then serverRefreshOriginal(self) end
        end
    end

    if componentType == nil then
        return
    end

    -- The computer outputs into components that take SC input (its children), and takes output from components that output SC data (its parents).
    local viaChildren = bit_band(classData.connectionInput or 0, SCRAPCOMPUTERS_FLAGS) ~= 0
    local viaParents = bit_band(classData.connectionOutput or 0, SCRAPCOMPUTERS_FLAGS) ~= 0

    -- One entry per component type. Several classes can share a type (e.g. PowerComponents), and this also runs again on script reload,
    -- so merge into the existing entry instead of adding a new one.
    for _, data in pairs(COMPONENT_MANAGER_REGISTERED_COMPONENTS) do
        if data.componentType == componentType then
            data.isAComponent = data.isAComponent or isAComponent
            data.isPowered = data.isPowered or isPowered
            data.isInvisible = data.isInvisible and isInvisible
            data.retrievableViaChildren = data.retrievableViaChildren or viaChildren
            data.retrievableViaParents = data.retrievableViaParents or viaParents
            return
        end
    end

    table_insert(COMPONENT_MANAGER_REGISTERED_COMPONENTS, {
        componentType = componentType,
        isAComponent = isAComponent,
        isPowered = isPowered,
        isInvisible = isInvisible,
        retrievableViaChildren = viaChildren,
        retrievableViaParents = viaParents,
    })
end

---@deprecated
---Gets all connected commponents of the interactable and returns it.
---@param componentType string The component type to get
---@param interactable Interactable The interactable to search through
---@param viaChildren boolean If it should get components via children or parents
---@param flags integer? The flags to use to get the components
---@param getPrivateData boolean? If you set this to true, You get data from components that normally wont be for the computer api to use.
---@return table components All connected components it has discovered.
function sm.scrapcomputers.componentManager.getComponents(componentType, interactable, viaChildren, flags, getPrivateData)
    sm.scrapcomputers.errorHandler.assertArgument(componentType, 1, {"string"})
    sm.scrapcomputers.errorHandler.assertArgument(interactable, 2, {"Interactable"})
    sm.scrapcomputers.errorHandler.assertArgument(viaChildren, 3, {"boolean"})
    sm.scrapcomputers.errorHandler.assertArgument(flags, 4, {"integer", "nil"})
    sm.scrapcomputers.errorHandler.assertArgument(getPrivateData, 5, {"boolean", "nil"})

    viaChildren = viaChildren or false
    flags = flags or sm.interactable.connectionType.compositeIO
    getPrivateData = getPrivateData or false

    local componentDataList = sm.scrapcomputers.dataList[componentType]
    if not componentDataList then
        return {}
    end

    local componentList = interactable[viaChildren and "getChildren" or "getParents"](interactable, flags) ---@type Interactable[]
    local output = {}

    for _, component in pairs(componentList) do
        local componentData = componentDataList[component.shape.id]

        if componentData then
            if getPrivateData then
                table_insert(output, componentData)
            else
                local safeData = {}

                for index, value in pairs(componentData) do
                    if string_sub(index, 1, #PRIVATE_DATA_PREFIX) ~= PRIVATE_DATA_PREFIX then
                        safeData[index] = value
                    end
                end

                table_insert(output, safeData)
            end
        end
    end

    return output
end

---A easier api than getComponents. Its also a lot safer so we highly recommended using this instead of getComponents.
---@param componentType string The component type to get
---@param interactable Interactable The interactable to search through
---@param getPrivateData boolean? If you set this to true, You get data from components that normally wont be for the computer api to use.
---@return table components The connected components. Empty if the type is unregistered, not a component, or invisible (without getPrivateData).
function sm.scrapcomputers.componentManager.getComponentsSimplified(componentType, interactable, getPrivateData)
    sm.scrapcomputers.errorHandler.assertArgument(componentType, 1, {"string"})
    sm.scrapcomputers.errorHandler.assertArgument(interactable, 2, {"Interactable"})
    sm.scrapcomputers.errorHandler.assertArgument(getPrivateData, 3, {"boolean", "nil"})

    local registeredComponentData = nil
    for _, data in pairs(COMPONENT_MANAGER_REGISTERED_COMPONENTS) do
        if data.componentType == componentType then
            registeredComponentData = data
            break
        end
    end

    if not registeredComponentData or not registeredComponentData.isAComponent then
        return {}
    end

    if not registeredComponentData.retrievableViaChildren and not registeredComponentData.retrievableViaParents then
        return {}
    end

    -- Invisible components can only be retrieved when private data access is requested (internal use).
    if registeredComponentData.isInvisible and not getPrivateData then
        return {}
    end

    
    local componentDataList = sm.scrapcomputers.dataList[componentType]
    if not componentDataList then
        return {}
    end
    
    local componentList = {} ---@type Interactable[]
    if registeredComponentData.retrievableViaChildren then
        for _, component in pairs(interactable:getChildren(SCRAPCOMPUTERS_FLAGS)) do
            table_insert(componentList, component)
        end
    end

    if registeredComponentData.retrievableViaParents then
        for _, component in pairs(interactable:getParents(SCRAPCOMPUTERS_FLAGS)) do
            table_insert(componentList, component)
        end
    end

    local output = {}

    for _, component in pairs(componentList) do
        local componentData = componentDataList[component.shape.id]

        if componentData then
            local clonedData = sm.scrapcomputers.table.clone(componentData)
            if not getPrivateData then
                for index, _ in pairs(clonedData) do
                    if string_sub(index, 1, #PRIVATE_DATA_PREFIX) == PRIVATE_DATA_PREFIX then
                        clonedData[index] = nil
                    end
                end
            end

            table_insert(output, clonedData)
        end
    end

    return output
end

---Returns all component type names registered.
---@return string[] componentTypes All component type names registered.
function sm.scrapcomputers.componentManager.getRegisteredComponentTypes()
    local output = {}
    for _, data in pairs(COMPONENT_MANAGER_REGISTERED_COMPONENTS) do
        if data.componentType then
            table_insert(output, data.componentType)
        end
    end

    return output
end

---Returns true if this component type is registered.
---@param componentType string The component type to check
---@return boolean isRegistered If this component type is registered or not.
function sm.scrapcomputers.componentManager.isComponentTypeRegistered(componentType)
    sm.scrapcomputers.errorHandler.assertArgument(componentType, 1, {"string"})

    for _, data in pairs(COMPONENT_MANAGER_REGISTERED_COMPONENTS) do
        if data.componentType == componentType and data.isAComponent then
            return true
        end
    end

    return false
end

---Returns true if this component type is avaliable.
---@param componentType string The component type to check
---@return boolean isAvaliable If this component type is avaliable or not.
function sm.scrapcomputers.componentManager.isComponentTypeAvaliable(componentType)
    sm.scrapcomputers.errorHandler.assertArgument(componentType, 1, {"string"})

    for _, data in pairs(COMPONENT_MANAGER_REGISTERED_COMPONENTS) do
        if data.componentType == componentType and data.isAComponent and not data.isInvisible then
            return true
        end
    end

    return false
end