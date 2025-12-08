---@class HDDClass : ShapeClass
HDDClass = class()
HDDClass.maxParentCount = -1
HDDClass.maxChildCount = 0
HDDClass.connectionInput = sm.interactable.connectionType.compositeIO
HDDClass.connectionOutput = sm.interactable.connectionType.none
HDDClass.colorNormal = sm.color.new(0x0eeb8fff)
HDDClass.colorHighlight = sm.color.new(0x58ed71ff)

-- SERVER --

function HDDClass:server_onCreate()
    sm.scrapcomputers.sharedTable:init(self)

    self.sv = {}

    local storage = self.storage:load()
    if type(storage) == "nil" then
        storage = {
            __hddUpdateReceived = true,
            version = 1,
            data = {}
        }
        self.storage:save(storage)
    end

    -- This is DANGEROUS but for backwards compatability i have to do this
    if not storage.__hddUpdateReceived then
        storage = {
            __hddUpdateReceived = true,
            version = 1,
            data = storage
        }

        self.storage:save(storage)
    end

    self.sv.storage = sm.scrapcomputers.sharedTable:new(self, "self.cl.storage")
    self.sv.storageId = sm.scrapcomputers.sharedTable:getSharedTableId(self.sv.storage)
    sm.scrapcomputers.table.transferTable(self.sv.storage, storage)

    ---@class HDD.SharedData
    self.sv.sharedData = sm.scrapcomputers.sharedTable:new(self, "self.cl.sharedData")
    self.sv.sharedDataId = sm.scrapcomputers.sharedTable:getSharedTableId(self.sv.sharedData)

    self.sv.sharedData.isInteracted = false
    self.sv.sharedData.interactedByWhoId = -1

    self.sv.sharedData.logger = sm.scrapcomputers.fancyInfoLogger:new()

    sm.scrapcomputers.powerManager.updatePowerInstance(self.shape.id, 0.5)
end

function HDDClass:sv_createData()
    return {
        load = function ()
            return sm.scrapcomputers.table.clone(self.sv.storage.data)
        end,

        save = function (data)
            sm.scrapcomputers.errorHandler.assertArgument(data, nil, {"table"})
            sm.scrapcomputers.errorHandler.assert(sm.scrapcomputers.json.isSafe(data), nil, "Cannot save data! Data contains invalid value types!")

            self.storage:save(data)

            self.sv.storage.data = sm.scrapcomputers.table.clone(data)
            sm.scrapcomputers.sharedTable:forceSyncProperty(self.sv.storage, "data")
        end
    }
end

function HDDClass:server_onFixedUpdate()
    sm.scrapcomputers.sharedTable:runTick(self)
end

function HDDClass:server_onSharedTableChange(id, key, value, comesFromSelf, player)
    if not comesFromSelf and id == self.sv.storageId then
        for _, plr in pairs(sm.player.getAllPlayers()) do
            if plr ~= player then
                self.network:sendToClient(plr, "cl_sendAlertOfUserModifingDataHahaYes")
            end
        end

        self.storage:save(sm.scrapcomputers.sharedTable:getRawContents(self.sv.storage))
    end

    if id == self.sv.sharedDataId and key == "logger" then
        sm.scrapcomputers.sharedTable:disableSync(self.sv.sharedData)
        self.sv.sharedData.logger = sm.scrapcomputers.fancyInfoLogger:newFromSharedTable(self.sv.sharedData.logger)
        sm.scrapcomputers.sharedTable:enableSync(self.sv.sharedData)
    end
end

-- CLIENT --

function HDDClass:client_onCreate()
    sm.scrapcomputers.sharedTable:init(self)

    self.cl = {}
    self.cl.unsavedInput = ""
    self.cl.hasChanges = false
    self.cl.actionsPerforming = false

    self.cl.gui = sm.scrapcomputers.gui:createGuiFromLayout("$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Gui/Layout/Harddrive.layout")
    self.cl.gui:setButtonCallback("MainMainSaveBtn", "cl_onSavedBtnPressed")
    self.cl.gui:setButtonCallback("MainMainReformatContentsBtn", "cl_reformatContentsBtnPressed")
    self.cl.gui:setButtonCallback("MainMainReloadContentsBtn", "cl_reloadContentsBtnPressed")

    self.cl.gui:setTextChangedCallback("MainMainData", "cl_onDataTextChanged")
    self.cl.gui:setOnCloseCallback("cl_onCloseGui")

    self.cl.unsavedChanges = {}
    self.cl.unsavedChanges.gui = sm.scrapcomputers.gui:createGuiFromLayout("$GAME_DATA/Gui/Layouts/PopUp/PopUp_YN.layout")

    self.cl.unsavedChanges.gui:setButtonCallback("Yes", "cl_unsavedChanges_onButtonPressed")
    self.cl.unsavedChanges.gui:setButtonCallback("No", "cl_unsavedChanges_onButtonPressed")

    self.cl.unsavedChanges.gui:setOnCloseCallback("cl_unsavedChanges_onCloseCallback")

    self.cl.unsavedChanges.onButtonPressedCallback = nil ---@type function?
    self.cl.unsavedChanges.onCloseCallback         = nil ---@type function?

    ---@type HDD.SharedData
    self.cl.sharedData = nil
end

function HDDClass:client_onFixedUpdate()
    sm.scrapcomputers.sharedTable:runTick(self)

    if not self.cl.sharedData then return end

    if not self.cl.sharedData.isInteracted or self.cl.sharedData.interactedByWhoId ~= sm.localPlayer.getId() then
        return
    end

    if self.cl.sharedData.logger then
        self.cl.gui:setText("MainHeaderTextInfoText", self.cl.sharedData.logger:getLog())
    end
end

function HDDClass:client_onInteract(character, state)
    if not state then return end

    if self.cl.sharedData.isInteracted then
        sm.scrapcomputers.gui:alert("scrapcomputers.drive.gui_already_opened")
        return
    end

    self.cl.sharedData.logger:setDefaultText("scrapcomputers.drive.logs.no_events")

    self.cl.sharedData.interactedByWhoId = sm.localPlayer.getId()
    self.cl.sharedData.isInteracted = true
    self:cl_openGui()
end

function HDDClass:cl_openGui()
    self:cl_reloadTranslations()

    self.cl.unsavedInput = sm.scrapcomputers.json.toString(self.cl.storage.data, false)
    self.cl.gui:setTextRaw("MainMainData", sm.scrapcomputers.json.prettifyTable(self.cl.storage.data))
    self.cl.gui:open()
end

function HDDClass:cl_onCloseGui()
    if self.cl.actionsPerforming then return end

    if not self.cl.hasChanges then
        self.cl.sharedData.isInteracted = false
        self.cl.sharedData.interactedByWhoId = -1

        return
    end

    self.cl.unsavedChanges.onButtonPressedCallback = function (pressedYes)
        if not pressedYes then
            self:cl_reloadTranslations()
            self.cl.gui:open()
        else
            self.cl.hasChanges = false
            self.cl.sharedData.isInteracted = false
            self.cl.sharedData.interactedByWhoId = -1
        end
    end

    self.cl.unsavedChanges.onCloseCallback = function ()
        if self.cl.hasChanges then
            self:cl_reloadTranslations()
            self.cl.gui:open()
        end
    end

    self:cl_reloadTranslations()
    self.cl.unsavedChanges.gui:open()
end

function HDDClass:cl_onDataTextChanged(widgetName, text)
    self.cl.hasChanges = true
    self.cl.unsavedInput = text
end

function HDDClass:cl_unsavedChanges_onCloseCallback()
    if self.cl.unsavedChanges.onCloseCallback then
        self.cl.unsavedChanges.onCloseCallback()
    end
end

function HDDClass:cl_unsavedChanges_onButtonPressed(widgetName)
    self.cl.unsavedChanges.onButtonPressedCallback(widgetName == "Yes")
    self.cl.unsavedChanges.gui:close()
end

function HDDClass:cl_onSavedBtnPressed()
    if not self.cl.hasChanges then
        self:cl_showLog("scrapcomputers.drive.logs.no_contents_modified", "#eeeeee")
        return
    end

    local success, result = pcall(sm.json.parseJsonString, self.cl.unsavedInput)
    if not success then
        local line, column = result:match("Line (%d+), Column (%d+)")
        line = tonumber(line)
        column = tonumber(column)

        local message = result:match("Column %d+\n%s*(.+)")
        message = message:sub(1, #message - 1)

        self:cl_showLog("scrapcomputers.drive.logs.json_error", "#f14c4c", line, column, message)
        return
    end

    self.cl.hasChanges = false

    self.cl.storage.data = result
    sm.scrapcomputers.sharedTable:forceSyncProperty(self.cl.storage, "data")

    self:cl_showLog("scrapcomputers.drive.logs.saved_data", "#23d18b")
end

function HDDClass:cl_reloadContentsBtnPressed()
    if not self.cl.hasChanges then
        self:cl_openGui()
        return
    end

    self.cl.actionsPerforming = true
    self.cl.gui:close()

    self.cl.unsavedChanges.onButtonPressedCallback = function (pressedYes)
        if pressedYes then
            self:cl_openGui()
        end
    end

    self.cl.unsavedChanges.onCloseCallback = function ()
        if not self.cl.gui:isActive() then
            self:cl_reloadTranslations()
            self.cl.gui:open()
        end

        self.cl.actionsPerforming = false
    end

    self:cl_reloadTranslations()
    self.cl.unsavedChanges.gui:open()
end

function HDDClass:cl_reformatContentsBtnPressed()
    if not self.cl.hasChanges then return end

    local success, result = pcall(sm.json.parseJsonString, self.cl.unsavedInput)
    if not success then
        local line, column = result:match("Line (%d+), Column (%d+)")
        line = tonumber(line)
        column = tonumber(column)

        local message = result:match("Column %d+\n%s*(.+)")
        message = message:sub(1, #message - 1)

        self:cl_showLog("scrapcomputers.drive.logs.json_error", "#f14c4c", line, column, message)
        return
    end

    self.cl.gui:setTextRaw("MainMainData", sm.scrapcomputers.json.prettifyTable(result))
    self:cl_showLog("scrapcomputers.drive.logs.reformatted", "#23d18b")
end

function HDDClass:client_canInteract()
    if self.shape.usable then
        sm.scrapcomputers.gui:showCustomInteractiveText(
            {
                "scrapcomputers.drive.interactiontext.main"
            }
        )
    end

    return self.shape.usable
end

function HDDClass:cl_showLog(msg, color, ...)
    if self.cl.sharedData.logger then
        self.cl.sharedData.logger:showLog(msg, color, ...)
        sm.scrapcomputers.sharedTable:forceSyncProperty(self.cl.sharedData, "logger")
    end
end

function HDDClass:cl_sendAlertOfUserModifingDataHahaYes()
    self:cl_showLog("scrapcomputers.drive.logs.contents_modified_by_user", "#23d18b")
end

function HDDClass:client_onSharedTableChange(id, key, value, comesFromSelf)
    self.cl.sharedDataId = self.cl.sharedData and sm.scrapcomputers.sharedTable:getSharedTableId(self.cl.sharedData) or nil
    self.cl.storageId    = self.cl.storage    and sm.scrapcomputers.sharedTable:getSharedTableId(self.cl.storage   ) or nil

    if id == self.cl.sharedDataId and key == "logger" then
        sm.scrapcomputers.sharedTable:disableSync(self.cl.sharedData)
        self.cl.sharedData.logger = sm.scrapcomputers.fancyInfoLogger:newFromSharedTable(self.cl.sharedData.logger)
        sm.scrapcomputers.sharedTable:enableSync(self.cl.sharedData)
    end

    if id == self.cl.storageId and not comesFromSelf then
        self:cl_showLog("scrapcomputers.drive.logs.contents_modified_by_computer", "#23d18b")
    end
end

function HDDClass:cl_reloadTranslations()
    self.cl.unsavedChanges.gui:setText("Title"  , "scrapcomputers.drive.unsaved_changes.title")
    self.cl.unsavedChanges.gui:setText("Message", "scrapcomputers.drive.unsaved_changes.text")

    self.cl.gui:setText("MainHeader", "scrapcomputers.drive.title")

    self.cl.gui:setText("MainMainSaveBtn"            , "scrapcomputers.drive.save")
    self.cl.gui:setText("MainMainReloadContentsBtn"  , "scrapcomputers.drive.reload_contents")
    self.cl.gui:setText("MainMainReformatContentsBtn", "scrapcomputers.drive.reformat_contents")
end

sm.scrapcomputers.componentManager.toComponent(HDDClass, "Harddrives", true, nil, true)