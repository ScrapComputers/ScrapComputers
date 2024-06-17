dofile("$CONTENT_DATA/Scripts/Config.lua")

sc.componentManager = {}

---Converts a class to a component class!
---@param classData ShapeClass
---@param dataType string
---@param shouldBeComponent boolean
sc.componentManager.ToComponent = function (classData, dataType, shouldBeComponent)
    if classData.sv_createData then
        local _sv_createData = classData.sv_createData
        classData.sv_createData = function (self)
            if sc.modDisabled then
                return {}
            end

            return _sv_createData(self)
        end
    end

    local _server_onCreate = classData.server_onCreate
    classData.server_onCreate = function (self)
        if sc.modDisabled then
            self.network:sendToClients("cl__do_not_use___disableMod")
        end

        if shouldBeComponent and classData.sv_createData then
            sc.dataList[dataType][self.interactable.id] = classData.sv_createData(self)
        end
    
        if _server_onCreate then
            _server_onCreate(self)
        end
    end

    if shouldBeComponent then
        local _server_onDestroy = classData.server_onDestroy
        classData.server_onDestroy = function (self)
            sc.dataList[dataType][self.interactable.id] = nil
        
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

    return classData
end