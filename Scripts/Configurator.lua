---@class ConfiguratorClass : ShapeClass
ConfiguratorClass = class()

-- SERVER --

---@param params {[1]: string, [2]: integer} The parameters
function ConfiguratorClass:sv_setConfig(params)
    local id, selectedOption = unpack(params)

    sm.scrapcomputers.config.setConfig(id, selectedOption)
end

function ConfiguratorClass:sv_resetConfig()
    sm.scrapcomputers.config.resetConfiguration()
end

-- CLIENT --

function ConfiguratorClass:client_onCreate()
    self.cl = {
        gui = nil, ---@type GuiInterface
        popupGui = nil,
        currentIndex = 1,
    }

    self.cl.starEffect = sm.effect.createEffect("ScrapComputers - ConfiguratiorStar", self.interactable)
    self.cl.starEffect:setAutoPlay(true)
    self.cl.starEffect:start()
end

function ConfiguratorClass:cl_onChangeValue()
    local currentConfig = sm.scrapcomputers.config.configurations[self.cl.currentIndex]
    local value = next(currentConfig.options, currentConfig.selectedOption)

    if not value then value = 1 end

    self.network:sendToServer("sv_setConfig", {currentConfig.id, value})
    sm.effect.playEffect("NoteTerminal - Interact", self.shape:getWorldPosition())

    local valueName = "config." .. currentConfig.id .. "=option=" .. sm.scrapcomputers.toString(value)
    local valueText = sm.scrapcomputers.languageManager.translatable(valueName)
    if valueText == valueName then
        valueText = currentConfig.options[value]
    end

    self.cl.gui:setText("CurrentValue", valueText)

    -- A hacky solution comming up!
    -- We want to refresh the text in the gui when the language changes via this. But to make
    -- it as simple as possible, i can just do this.
    --
    -- I am not bothered unhackifying it.

    if currentConfig.id == "scrapcomputers.global.selectedLanguage" then
        currentConfig.selectedOption = value
        self:cl_updateGui(tostring(self.cl.currentIndex))
        self:cl_runTranslations()
        
        self.cl.gui:setText("List", self:svcl_formatList())
    end
end

function ConfiguratorClass:cl_onLoadDefualts()
    self.cl.gui:close()

    self.cl.popupGui = sm.gui.createGuiFromLayout("$GAME_DATA/Gui/Layouts/PopUp/PopUp_YN.layout", true, {backgroundAlpha = 0.5})

    self.cl.popupGui:setText("Title", sm.scrapcomputers.languageManager.translatable("scrapcomputers.configurator.resetpopup.title"))
    self.cl.popupGui:setText("Message", sm.scrapcomputers.languageManager.translatable("scrapcomputers.configurator.resetpopup.description"))

    self.cl.popupGui:setButtonCallback("Yes", "cl_onLoadDefualtsButton")
    self.cl.popupGui:setButtonCallback("No", "cl_onLoadDefualtsButton")

    self.cl.popupGui:setOnCloseCallback("cl_onPopupClose")

    self.cl.popupGui:open()
end

function ConfiguratorClass:cl_onLoadDefualtsButton(widget)
    if widget == "Yes" then
        self.network:sendToServer("sv_resetConfig")
        sm.effect.playEffect("Farmbot - Destroyed", self.shape:getWorldPosition())
    end

    self.cl.popupGui:close()
end

function ConfiguratorClass:cl_onPopupClose()
    self:cl_createGui()
    self.cl.gui:open()
end

function ConfiguratorClass:cl_updateGui(text)
    local result = self:svcl_isIndexValid(text)

    if result == 0 then
        self.cl.currentIndex = tonumber(text)

        self.cl.gui:setVisible("Description", true)
        self.cl.gui:setVisible("ChangeValueButton", true)

        local config = sm.scrapcomputers.config.configurations[self.cl.currentIndex]
        local description = sm.scrapcomputers.languageManager.translatable("config." .. config.id .. "=description")
        if description == ("config." .. config.id .. "=description") then description = config.description end

        local valueName = "config." .. config.id .. "=option=" .. sm.scrapcomputers.toString(config.selectedOption)
        local value = sm.scrapcomputers.languageManager.translatable(valueName)
        if value == valueName then value = config.options[config.selectedOption] end

        self.cl.gui:setText("Description", description)
        self.cl.gui:setText("CurrentValue", value)

        self.cl.gui:setVisible("ChangeValueButton", (sm.isHost or not config.hostOnly))
    elseif result == -1 then
        self.cl.gui:setText ("CurrentValue", "#E74856Please put in a number!")
        self.cl.gui:setVisible("Description", false)
        self.cl.gui:setVisible("ChangeValueButton", false)
    else
        self.cl.gui:setText ("CurrentValue", "#E74856Out-of-Bounds (Must be 1-" .. sm.scrapcomputers.config.getTotalConfigurations() .. ")")
        self.cl.gui:setVisible("Description", false)
        self.cl.gui:setVisible("ChangeValueButton", false)
    end
end

---@param text string The text
function ConfiguratorClass:cl_onNewInput(widget, text)
    self:cl_updateGui(text)
end

function ConfiguratorClass:cl_createGui()
    if sm.exists(self.cl.gui) then self.cl.gui:close() end

    self.cl.gui = sm.gui.createGuiFromLayout(sm.scrapcomputers.layoutFiles.Configurator, true, {backgroundAlpha = 0.5})

    self.cl.gui:setText("List", self:svcl_formatList())
    self.cl.gui:setText("SelectedOption", sm.scrapcomputers.toString(self.cl.currentIndex))

    self.cl.gui:setTextChangedCallback("SelectedOption", "cl_onNewInput")

    self.cl.gui:setButtonCallback("ChangeValueButton", "cl_onChangeValue")
    self.cl.gui:setButtonCallback("LoadDefaultsButton", "cl_onLoadDefualts")

    self:cl_runTranslations()
    self:cl_updateGui(self.cl.currentIndex)
end

function ConfiguratorClass:client_onInteract(character, state)
    if not state then return end

    if sm.scrapcomputers.config.getConfig("scrapcomputers.configurator.admin_only").selectedOption == 1 and not sm.isHost then
        sm.gui.displayAlertText("[#3A96DDScrap#3b78ffComputers#eeeeee]: " .. sm.scrapcomputers.languageManager.translatable("scrapcomputers.configurator.cannot_access_object"))
        return
    end

    if not self:svcl_isIndexValid(self.cl.currentIndex) == 0 then
        self.cl.currentIndex = 1
    end

    self:cl_createGui()
    self.cl.gui:open()

    sm.effect.playEffect("PowerSocket - Activate", self.shape:getWorldPosition())
end

function ConfiguratorClass:cl_runTranslations()
    self.cl.gui:setText("Title"             , sm.scrapcomputers.languageManager.translatable("scrapcomputers.configurator.title"        ))
    self.cl.gui:setText("ChangeValueButton" , sm.scrapcomputers.languageManager.translatable("scrapcomputers.configurator.change_value" ))
    self.cl.gui:setText("LoadDefaultsButton", sm.scrapcomputers.languageManager.translatable("scrapcomputers.configurator.load_defaults"))

end

-- CLIENT / SERVER --

function ConfiguratorClass:svcl_formatList()
    local text = ""

    ---@param config Configuration
    for index, config in ipairs(sm.scrapcomputers.table.numberlyOrderTable(sm.scrapcomputers.config.configurations)) do
        local name = sm.scrapcomputers.languageManager.translatable("config." .. config.id .. "=name")
        if name == ("config." .. config.id .. "=name") then
            name = config.name
        end

        text = text .. sm.scrapcomputers.toString(index) .. ": " .. name .. "\n"
    end

    return text:sub(1, -1)
end

function ConfiguratorClass:svcl_isIndexValid(index)
    local actualIndex = tonumber(index)

    if not actualIndex then
        return -1
    end

    if actualIndex < 0 or actualIndex > sm.scrapcomputers.config.getTotalConfigurations() then
        return -2
    end

    return 0
end

sm.scrapcomputers.componentManager.toComponent(ConfiguratorClass, nil, false)