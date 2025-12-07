---@class ConfiguratorClass : ShapeClass
ConfiguratorClass = class()

-- SERVER --

---@param params {[1]: string, [2]: integer} The parameters
function ConfiguratorClass:sv_setConfig(params, player)
    local hostOnly = sm.scrapcomputers.config.getConfig("scrapcomputers.configurator.admin_only").selectedOption == 1
    if (player == sm.scrapcomputers.backend.thisPlayer and hostOnly) or not hostOnly then
        local id, selectedOption = unpack(params)
        sm.scrapcomputers.config.setConfig(id, selectedOption)
    else
        sm.scrapcomputers.logger.warn("Player \"" .. player:getName() .. "\" (ID: " .. player:getId() .. ") has attempted to iliegally set a config (admin only enabled)")
    end
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

    self.cl.gui:setTextRaw("ConfigMainCurrentTextBtn", valueText)

    -- A hacky solution comming up!
    -- We want to refresh the text in the gui when the language changes via this. But to make
    -- it as simple as possible, i can just do this.
    --
    -- I am not bothered unhackifying it.

    if currentConfig.id == "scrapcomputers.global.selectedLanguage" then
        currentConfig.selectedOption = value
        self:cl_updateGui(tostring(self.cl.currentIndex))
        self:cl_runTranslations()
        
        self.cl.gui:setTextRaw("ConfigsMainList", self:svcl_formatList())
    end
end

function ConfiguratorClass:cl_onLoadDefualts()
    self.cl.gui:close()

    self.cl.popupGui = sm.scrapcomputers.gui:createGuiFromLayout("$GAME_DATA/Gui/Layouts/PopUp/PopUp_YN.layout", true)

    self.cl.popupGui:setText("Title", "scrapcomputers.configurator.resetpopup.title")
    self.cl.popupGui:setText("Message", "scrapcomputers.configurator.resetpopup.description")

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

        self.cl.gui:setVisible("ConfigMainDescription", true)
        self.cl.gui:setVisible("ConfigMainCurrentTextBtn", true)

        local config = sm.scrapcomputers.config.configurations[self.cl.currentIndex]
        local description = sm.scrapcomputers.languageManager.translatable("config." .. config.id .. "=description")
        if description == ("config." .. config.id .. "=description") then description = config.description end

        local valueName = "config." .. config.id .. "=option=" .. sm.scrapcomputers.toString(config.selectedOption)
        local value = sm.scrapcomputers.languageManager.translatable(valueName)
        if value == valueName then value = config.options[config.selectedOption] end

        local name = sm.scrapcomputers.languageManager.translatable("config." .. config.id .. "=name")
        if name == ("config." .. config.id .. "=name") then
            name = config.name
        end

        self.cl.gui:setTextRaw("ConfigMainDescription", description)
        self.cl.gui:setText("InfoHeaderTextSelectedConfigText", "scrapcomputers.configurator.current_config", name)
        self.cl.gui:setTextRaw("ConfigMainCurrentTextBtn", value)

        self.cl.gui:setVisible("ConfigMainCurrentTextBtn", (sm.isHost or not config.hostOnly))
    elseif result == -1 then
        self.cl.gui:setText("InfoHeaderTextSelectedConfigText", "scrapcomputers.configurator.not_a_number")
        self.cl.gui:setVisible("ConfigMainDescription", false)
        self.cl.gui:setVisible("ConfigMainCurrentTextBtn", false)
    else
        self.cl.gui:setText("InfoHeaderTextSelectedConfigText", "scrapcomputers.configurator.out_of_bounds", sm.scrapcomputers.config.getTotalConfigurations())
        self.cl.gui:setVisible("ConfigMainDescription", false)
        self.cl.gui:setVisible("ConfigMainCurrentTextBtn", false)
    end
end

---@param text string The text
function ConfiguratorClass:cl_onNewInput(widget, text)
    self:cl_updateGui(text)
end

function ConfiguratorClass:cl_createGui()
    if self.cl.gui and self.cl.gui:isActive() then
        self.cl.gui:close()
    end

    self.cl.gui = sm.scrapcomputers.gui:createGuiFromLayout("$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Gui/Layout/Configurator.layout", true)

    self.cl.gui:setTextRaw("ConfigsMainList", self:svcl_formatList())
    self.cl.gui:setTextRaw("ConfigMainInput", tostring(self.cl.currentIndex))

    self.cl.gui:setTextChangedCallback("ConfigMainInput", "cl_onNewInput")

    self.cl.gui:setButtonCallback("ConfigMainCurrentTextBtn", "cl_onChangeValue")
    self.cl.gui:setButtonCallback("ConfigMainResetBtn", "cl_onLoadDefualts")

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
    self.cl.gui:setText("ConfigHeaderText"  , "scrapcomputers.configurator.configs_title")
    self.cl.gui:setText("InfoHeaderText"    , "scrapcomputers.configurator.info_title")
    self.cl.gui:setText("ConfigMainResetBtn", "scrapcomputers.configurator.load_defaults")
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