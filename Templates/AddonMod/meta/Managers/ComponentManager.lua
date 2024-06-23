local Computer_UUID = "c44f6e8e-b0b8-4821-83a5-7928c1446df0"

-- The component related table!
sm.scrapcomputers.components = {}

---Converts a class to a component class!
---@param classData ShapeClass The class to use for the component
---@param dataType string? The type of component it is
---@param shouldBeComponent boolean Set this to true if your planning it to be a actual component!
sm.scrapcomputers.components.ToComponent = function (classData, dataType, shouldBeComponent)
    assert(type(classData) == "table", "bad argument #1. Expected ShapeClass, got "..type(classData).." instead.")
    assert(type(shouldBeComponent) == "boolean", "bad argument #3. Expected boolean, got "..type(shouldBeComponent).." instead.")

    -- We give no fucks if shouldBeComponent is false, else we give a fuck!
    if shouldBeComponent then
        assert(type(dataType) == "string", "bad argument #2. Expected string, got "..type(dataType).." instead.")
    end

    -- For anyone reading this, Your about to get brain-cancer from this. Please forgive VeraDev
    -- because he wrote this.

    local allowExecuting = true
    
    if shouldBeComponent then
        sm.scrapcomputers.dataList[dataType] = sm.scrapcomputers.dataList[dataType] or {}
    end

    if classData.sv_createData then
        local _sv_createData = classData.sv_createData
        classData.sv_createData = function (self)
            if sm.scrapcomputers.modDisabled then
                return {}
            end

            local data = _sv_createData(self)

            local function hookTable(tbl, hook)
                local output = {}
                for key, value in pairs(tbl) do
                    if type(value) == "table" then
                        output[key] = hookTable(value, hook)
                    elseif type(value) == "function" then
                        output[key] = function (...)
                            return hook(value, {...})
                        end
                    else
                        output[key] = value
                    end
                end
                return output
            end

            return hookTable(data, function(orginFunc, args)
                if allowExecuting then
                    return orginFunc(unpack(args))
                else
                    error("Failed to find component!")
                end
            end)
        end
    end

    local _server_onCreate = classData.server_onCreate
    classData.server_onCreate = function (self)
        if sm.scrapcomputers.modDisabled then
            self.network:sendToClients("cl__do_not_use___disableMod")
        end

        if shouldBeComponent and classData.sv_createData then
            sm.scrapcomputers.dataList[dataType][self.interactable.id] = classData.sv_createData(self)
        end
    
        if _server_onCreate then
            _server_onCreate(self)
        end
    end

    if shouldBeComponent then
        local _server_onDestroy = classData.server_onDestroy
        classData.server_onDestroy = function (self)
            if shouldBeComponent then
                sm.scrapcomputers.dataList[dataType][self.interactable.id] = nil
            end
        
            if _server_onDestroy then
                _server_onDestroy(self)
            end
        end
    end

    if not classData.client_onCreate then
        classData.client_onCreate = function (self)
            -- Do absolutly nothing!
        end
    end

    if classData.client_onInteract then
        local _client_onInteract = classData.client_onInteract
        classData.client_onInteract = function (self, character, state)
            if self.__do_not_use___ModDisabled then
                if state then
                    sm.gui.displayAlertText("[#3A96DDS#3b78ffC#eeeeee]: ScrapComputers is disabled! You cannot interact with this part!")
                end

                return
            end

            _client_onInteract(self, character, state)
        end

        classData.cl__do_not_use___disableMod = function (self)
            self.__do_not_use___ModDisabled = true
        end
    else
        classData.cl__do_not_use___disableMod = function (self) end
    end

    local _client_onRefresh = classData.client_onRefresh
    classData.client_onRefresh = function (self)
        classData.client_onCreate(self)

        if _client_onRefresh then
            _client_onRefresh(self)
        end
    end

    local _server_onRefresh = classData.server_onRefresh
    classData.server_onRefresh = function (self)
        classData.server_onCreate(self)
        
        if _server_onRefresh then
            _server_onRefresh(self)
        end
    end

    local allowConnect = false
    local prevComputers = {}
    local _server_onFixedUpdate = classData.server_onFixedUpdate
    classData.server_onFixedUpdate = function (self)
        if shouldBeComponent then
            local parents = self.interactable:getParents(sm.interactable.connectionType.compositeIO)
            local state = 0
            
            if #parents ~= #prevComputers then
                for _, parent in pairs(prevComputers) do
                    if sm.exists(parent) and sm.exists(parent.shape) and tostring(parent.shape.uuid) == Computer_UUID then
                        state = 1
                        break
                    end
                end

                if state == 0 then
                    for _, parent in pairs(parents) do
                        if sm.exists(parent) and sm.exists(parent.shape) and tostring(parent.shape.uuid) == Computer_UUID then
                            state = 2
                            break
                        end
                    end
                end
            end

            if state ~= 0 then
                if state == 1 then
                    -- Disconnect
                    allowExecuting = false
                elseif allowConnect then
                    -- Connect 
                    sm.scrapcomputers.dataList[dataType][self.interactable.id] = classData.sv_createData(self)
                    allowExecuting = true
                else
                    allowConnect = true
                end
            end

            prevComputers = sm.scrapcomputers.table.clone(parents)
        end

        if _server_onFixedUpdate then
            _server_onFixedUpdate(self)
        end
    end

    return classData
end


---Gets data from sm.scrapcomputers.dataList and filters them to whats connected or not. The boolean value on argument 3 is needed incase if u want to get the children or parents.
---@param dataType sm.scrapcomputers.filters.dataType The type of what object to choose. (example: sm.scrapcomputers.dataType.Display filters to be only displays from ScrapComputers)
---@param interactable Interactable                   The interactable itself. (Required to filter of whats connected or not)
---@param getViaChildren boolean                      If true. it gets children from interactable. else parents from interactable
---@param flags integer?                              This only exists just so the network ports work. <i>(defaults to sm.interactable.connectinType.compositeIO)</i>
---@param allowPrivateData boolean?                   If true, the results will also have private data that shouldn't be accessable to the public. <i>(defualts to false)</i>
---@return table componentList                        All components discovered
function sm.scrapcomputers.components.getComponents(dataType, interactable, getViaChildren, flags, allowPrivateData)
    flags = flags or sm.interactable.connectionType.compositeIO -- If flags is nil, Set it to be the default value
    allowPrivateData = allowPrivateData or false -- If allowPrivateData is nil, Set it to be the default value

    local dataList = sm.scrapcomputers.dataList[dataType] -- Get the datalist
    local tbl = getViaChildren and interactable:getChildren(flags) or interactable:getParents(flags) -- Ge the children (or parents) of the interactable
    local returnValues = {} -- The values that would be returned

    for _, interactablePOR in pairs(tbl) do
        -- Get the data form the interactable
        local data = dataList[interactablePOR:getId()]

        -- Check if it exists
        if data ~= nil then
            -- If it allows private data on the output. Add it to returnValues
            if allowPrivateData then
                table.insert(returnValues, data)
            else
                -- We are here because we do NOT allow private data on the output

                -- This will contain all safe variables and functions from data.
                -- Because anything that starts with sm.scrapcomputers.privateDataPrefix is considered unsafe!
                local safeData = {}

                -- Loop through data
                ---@param index string
                for index, value in pairs(data) do
                    -- Check if it doesn't start with the prefix
                    if index:sub(1, #sm.scrapcomputers.privateDataPrefix) ~= sm.scrapcomputers.privateDataPrefix then
                        safeData[index] = value -- Add it to safeData
                    end
                end

                -- Add it to returnValues
                table.insert(returnValues, safeData)
            end
        end
    end

    -- Return returnValues
    return returnValues
end
