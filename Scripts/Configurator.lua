dofile("$CONTENT_DATA/Scripts/Config.lua")

---@class Configurator : ShapeClass
Configurator = class()

-- SERVER --

function Configurator:sv_setConfig(params)
    -- Unpack params to 2 paramaters
    --      name: The name of the config
    --      selectedOption: The new option being selected
    local name, selectedOption = unpack(params)

    -- Update the config
    sc.config.setConfig(name, selectedOption)
end

function Configurator:sv_resetConfig()
    sc.config.resetConfiguration()
end

-- CLIENT --

function Configurator:client_onCreate()
    -- Create client-side variables
    self.cl = {
        -- The main gui
        ---@type GuiInterface?
        gui = nil,

        -- The popup gui used for the reset defaults button.
        ---@type GuiInterface?
        popupGui = nil,

        -- The current index to modify.
        currentIndex = 1
    }
end

function Configurator:cl_onChangeValue()
    -- Get current config and its next value
    local currentConfig = sc.config.configurations[self.cl.currentIndex]
    local value = next(currentConfig.options, currentConfig.selectedOption)
    
    -- If it is nil, set it to 1 so it loops back to 1 (next function returns nil if theres nothing on the next item)
    if not value then value = 1 end

    -- Send it to the server to be updated and update the gui to be the new option.
    self.network:sendToServer("sv_setConfig", {self.cl.currentIndex, value})
    self.cl.gui:setText("CurrentValue", currentConfig.options[value])

    -- Play sound effect
    sm.effect.playEffect("NoteTerminal - Interact", self.shape:getWorldPosition())
end

function Configurator:cl_onLoadDefualts()
    -- Close current gui
    self.cl.gui:close()

    -- Create popup gui
    self.cl.popupGui = sm.gui.createGuiFromLayout("$GAME_DATA/Gui/Layouts/PopUp/PopUp_YN.layout", true, { backgroundAlpha = 0.5 })

    -- Set the title and message
    self.cl.popupGui:setText("Title", "Reset Configuration?")
    self.cl.popupGui:setText("Message", "Do you really want to reset your configuration! This is not reversible!")

    -- Create the callbacks for the button
    self.cl.popupGui:setButtonCallback("Yes", "cl_onLoadDefualtsButton")
    self.cl.popupGui:setButtonCallback("No", "cl_onLoadDefualtsButton")

    -- Create a close call back
    self.cl.popupGui:setOnCloseCallback("cl_onPopupClose")

    -- Open the popup Gui.
    self.cl.popupGui:open()
end

function Configurator:cl_onLoadDefualtsButton(widget)
    -- Check the widget name is "Yes" (So check if user pressed the yes button)
    if widget == "Yes" then
        -- Since it did, Reset the config and play sound effect
        self.network:sendToServer("sv_resetConfig")
        sm.effect.playEffect("Farmbot - Destroyed", self.shape:getWorldPosition())
    end

    self.cl.popupGui:close()
end

function Configurator:cl_onPopupClose()
    -- Create the gui and open it
    self:cl_createGui()
    self.cl.gui:open()
end

function Configurator:cl_updateGui(text)
    -- Get result of svcl_isIndexValid
    local result = self:svcl_isIndexValid(text)

    -- If its 0 (Valid)
    if result == 0 then
        -- Update current index with new one.
        self.cl.currentIndex = tonumber(text)

        -- Show the Description and ChangeValueButton
        self.cl.gui:setVisible("Description", true)
        self.cl.gui:setVisible("ChangeValueButton", true)

        -- Get the config
        local config = sc.config.configurations[self.cl.currentIndex]

        -- Update the description with the new current config
        self.cl.gui:setText("Description", config.description)
        self.cl.gui:setText("CurrentValue", config.options[config.selectedOption])

        if sm.isHost or not config.hostOnly then
            self.cl.gui:setVisible("ChangeValueButton", true)
        else
            self.cl.gui:setVisible("ChangeValueButton", false)
        end
    elseif result == -1 then
        -- Show error message and hide Description and ChangeValueButton (Not a number error)
        self.cl.gui:setText("CurrentValue", "#E74856Please put in a number!")
        self.cl.gui:setVisible("Description", false)
        self.cl.gui:setVisible("ChangeValueButton", false)
    else
        -- Show error message and hide Description and ChangeValueButton (Out of bounds error)
        self.cl.gui:setText("CurrentValue", "#E74856Out-of-Bounds (Must be 1-"..sc.table.getTotalItems(sc.config.configurations)..")")
        self.cl.gui:setVisible("Description", false)
        self.cl.gui:setVisible("ChangeValueButton", false)
    end
end

-- Used for the SelectedOption TextChanged callback to change the current config with whatever the new one is (if valid)
---@param text string
function Configurator:cl_onNewInput(_, text)
    -- Update gui.
    self:cl_updateGui(text)
end

-- Creates the GUI
function Configurator:cl_createGui()
    if sm.exists(self.cl.gui) then self.cl.gui:close() end -- If the gui exists. close it

    self.cl.gui = sm.gui.createGuiFromLayout(sc.layoutFiles.Configurator, true, { backgroundAlpha = 0.5 }) -- Create the gui

    self.cl.gui:setText("List", self:svcl_formatList()) -- Get the list and put it inside the List Widget
    self.cl.gui:setText("SelectedOption", sc.toString(self.cl.currentIndex)) -- Update SelectedOption to be the new one

    self.cl.gui:setTextChangedCallback("SelectedOption", "cl_onNewInput") -- Create a text change callback to SelectedOption

    -- Create button callback's
    self.cl.gui:setButtonCallback("ChangeValueButton", "cl_onChangeValue")
    self.cl.gui:setButtonCallback("LoadDefaultsButton", "cl_onLoadDefualts")

    -- Run cl_updateGui to generate the stuff needed for end-user
    self:cl_updateGui(self.cl.currentIndex)
end

function Configurator:client_onInteract(_, state)
    -- Check if the state isn't false, If so then return true since client_onInteract gets called twice (See https://scrapmechanicdocs.com/docs/Game-Script-Environment/Classes/ShapeClass#oninteract for the reason)
    if not state then return end

    -- If the current config for "Admin-only accessable Configurator" is "Only Host" and the client isn't a host, We cant allow him to change it so send a alert and stop further execution.
    if sc.config.configurations[2].selectedOption == 1 and not sm.isHost then
        sm.gui.displayAlertText("[#3A96DDScrap#3b78ffComputers#eeeeee]: You do not have access to the Configurator!")
        return
    end

    if not self:svcl_isIndexValid(self.cl.currentIndex) == 0 then self.cl.currentIndex = 1 end     -- Check if the index isn't valid. If that's true, Then reset the index to 1.

    -- Create the gui and open it
    self:cl_createGui()
    self.cl.gui:open()

    -- Play a effect.
    sm.effect.playEffect("PowerSocket - Activate", self.shape:getWorldPosition())
end

-- CLIENT / SERVER --

-- Used to format a list to a string.
function Configurator:svcl_formatList()
    local text = ""

    local index = 1 -- We do NOT use the index system from table!
                    -- This is because let say the fourth item's index is 1004. We do NOT want 1004 on the list but 4!
    -- Loop through all configurations
    for _, config in ipairs(sc.config.configurations) do
        -- Format it to a string and add it to the text (string) variable
        text = text..sc.toString(index)..": "..config.name.."\n"

        index = index + 1 -- Increase the index by 1
    end

    -- Return the text (string) variable.
    return text
end

-- Used to check if num is a number and in-bounds of the sc.config.configurations
function Configurator:svcl_isIndexValid(num)
    -- Convert it to a number (if possible)
    local actualNumber = tonumber(num)

    -- If actualNumber failed, return -1. (Invalid: Not a number!)
    if not actualNumber then
        return -1
    end

    -- If its below 0 or above the total amount of configurations, return -2. (Invalid: Out-of-Bounds)
    if actualNumber < 0 or actualNumber > sc.table.getTotalItems(sc.config.configurations) then
        return -2
    end

    -- Since it is a number and isn't out of the bounds. Return 0. (Valid)
    return 0
end

-- Convert the class to a component
dofile("$CONTENT_DATA/Scripts/ComponentManager.lua")
sc.componentManager.ToComponent(Configurator, "", false)