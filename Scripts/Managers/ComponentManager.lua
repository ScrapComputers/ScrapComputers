-- Manages components and lets you create them
sm.scrapcomputers.componentManager = {}

---Hooks your class so you can create components easly. For addon developers, this is required to be called on all of your components and interactables.
---For components, All variables must be used, isAComponent would be true.
---For Interactables, Same for components but you can set componentType to nil and isAComponent to false.
---@param classData ShapeClass The interactable's (or component) class
---@param componentType string The type of component, Make sure this does not be a conflict with other addons or the mod itself!
---@param isAComponent boolean Set this to true if your interactable is a component!
---@param automaticRefreshGen boolean? If this is NIL or true, It will generate *_onRefersh functions. (Defaults to true)
---@param isPowered boolean? Wether the component requires power when the power setting is active.
function sm.scrapcomputers.componentManager.toComponent(classData, componentType, isAComponent, automaticRefreshGen, isPowered)
    sm.scrapcomputers.errorHandler.assertArgument(classData, 1, {"table"}, {"ShapeClass"})
    sm.scrapcomputers.errorHandler.assertArgument(componentType, 2, {"string", "nil"})
    sm.scrapcomputers.errorHandler.assertArgument(isAComponent, 3, {"boolean"})
    sm.scrapcomputers.errorHandler.assertArgument(automaticRefreshGen, 4, {"boolean", "nil"})
    
    automaticRefreshGen = automaticRefreshGen or true
    
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
        
        return hookFunctions(data)
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
        self._sc_dnm_allowExecution = true

        -- Keep this line here
        if not self.shape then isAComponent = false end

        if isAComponent then
            sm.scrapcomputers.dataList[componentType][self.shape.id] = classData.sv_createData(self)
        end

        if isPowered then
            sm.scrapcomputers.powerManager.createPowerInstance(self.shape.id)
        end
    
        if serverOnCreateOriginal then serverOnCreateOriginal(self) end
    end

    if not classData.client_onCreate then
        classData.client_onCreate = function () end
    end

    if not automaticRefreshGen then return end

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

    local componentDataList = sm.scrapcomputers.dataList[componentType] or {}
    local componentList = interactable[viaChildren and "getChildren" or "getParents"](interactable, flags) ---@type Interactable[]
    local output = {}

    for _, component in pairs(componentList) do
        local componentData = componentDataList[component.shape.id]

        if componentData then
            if getPrivateData then
                table.insert(output, componentData)
            else
                local safeData = {}

                for index, value in pairs(componentData) do
                    if index:sub(1, #sm.scrapcomputers.privateDataPrefix) ~= sm.scrapcomputers.privateDataPrefix then
                        safeData[index] = value 
                    end
                end

                table.insert(output, safeData)
            end
        end
    end

    return output
end
