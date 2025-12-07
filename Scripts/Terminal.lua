---@class TerminalClass : ShapeClass
TerminalClass = class()
TerminalClass.maxParentCount = -1
TerminalClass.maxChildCount = 0
TerminalClass.connectionInput = sm.interactable.connectionType.compositeIO + sm.interactable.connectionType.seated
TerminalClass.connectionOutput = sm.interactable.connectionType.none
TerminalClass.colorNormal = sm.color.new(0x2f6929ff)
TerminalClass.colorHighlight = sm.color.new(0x359e31ff)

-- SERVER --

function TerminalClass:sv_createData()
    return {
        ---Sends a message
        ---@param msg string The message to send
        send = function (msg)
            local newMsg = sm.scrapcomputers.toString(msg):gsub("##", "#")
            table.insert(self.sv.sharedData.logs, newMsg)
            
            sm.scrapcomputers.sharedTable:forceSyncProperty(self.sv.sharedData, "logs")

            self.sv.updateInput = true
        end,

        ---Clears the console
        clear = function ()
            self.sv.sharedData.logs = {}
            self.sv.updateInput = true
        end,

        ---Clears the input history
        clearInputHistory = function ()
            -- DEPRECATED
        end,

        ---Returns true if there are awaiting inputs
        ---@return boolean hasReceivedInputs If it has received any inputs or not
        receivedInputs = function ()
            return #self.sv.awaitingInputs > 0
        end,

        ---Gets the user's input and returns it. Will error if there are no inputs
        ---@return string str The user's inputted message
        getInput = function ()
            if #self.sv.awaitingInputs > 0 then
                local Userinput = table.remove(self.sv.awaitingInputs, #self.sv.awaitingInputs)
                self.sv.updateInput = true

                return Userinput
            end

            error("Please call Terminal.receivedInputs before calling this!")
        end
}
end

function TerminalClass:server_onCreate()
    sm.scrapcomputers.sharedTable:init(self)

    self.sv = {
        text = {},
        awaitingInputs = {},

        updateInput = false,
    }

    self.sv.sharedData = sm.scrapcomputers.sharedTable:new(self, "self.cl.sharedData")
    self.sv.sharedData.logs = {}

    sm.scrapcomputers.powerManager.updatePowerInstance(self.shape.id, 3)
end

function TerminalClass:sv_onPowerLoss()
    self.sv.sharedData.logs = {}
    self.sv.updateInput = true
end

function TerminalClass:server_onFixedUpdate()
    sm.scrapcomputers.sharedTable:runTick(self)

    if self.sv.updateInput then
        self.sv.updateInput = false
        sm.scrapcomputers.sharedTable:forceSyncProperty(self.sv.sharedData, "logs")
    end
end

function TerminalClass:sv_receiveInput(text)
    table.insert(self.sv.awaitingInputs, text)
end

-- CLIENT --

function TerminalClass:client_onCreate()
    sm.scrapcomputers.sharedTable:init(self)
    
    self.cl = {
        gui = nil,
        inputtedString = "",
        character = nil
    }
end

function TerminalClass:client_onFixedUpdate()
    sm.scrapcomputers.sharedTable:runTick(self)
end

function TerminalClass:client_onInteract(character, state)
    if not state then return end

    self.cl.inputtedString = ""

    self.cl.gui = sm.scrapcomputers.gui:createGuiFromLayout("$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Gui/Layout/Terminal.layout", false)

    self.cl.gui:setTextRaw("MainMainConsole", self:cl_formatText())

    self.cl.gui:setTextChangedCallback ("MainMainInput", "cl_setInputTextFromGUI")
    self.cl.gui:setTextAcceptedCallback("MainMainInput", "cl_onSubmitInput")

    self.cl.gui:setButtonCallback("MainMainSendBtn", "cl_onSubmitInput")

    self:cl_runTranslations()
    self.cl.gui:open()
end

function TerminalClass:client_onSharedTableChange(id, key, value, comesFromSelf)
    -- Theres only 1 shared table with 1 key. so

    if self.cl.gui then
        self.cl.gui:setTextRaw("MainMainConsole", self:cl_formatText())
    end
end

function TerminalClass:cl_setInputTextFromGUI(widget, text)
    self.cl.inputtedString = text
end

function TerminalClass:cl_onSubmitInput(widget, name)
    self.network:sendToServer("sv_receiveInput", self.cl.inputtedString)
    self.cl.gui:setTextRaw("MainMainInput", "")

    self.cl.inputtedString = ""
end

---@return string str The formatted string
function TerminalClass:cl_formatText()
    if #self.cl.sharedData.logs == 0 then return "" end

    local text = ""

    for _, line in pairs(self.cl.sharedData.logs) do
        text = text .. line .. "#eeeeee\n"
    end

    return text:sub(1, #text - 1)
end

function TerminalClass:cl_runTranslations()
    self.cl.gui:setText("MainHeaderText" , "scrapcomputers.terminal.title")
    self.cl.gui:setText("MainMainSendBtn", "scrapcomputers.terminal.send_input_button")
end

sm.scrapcomputers.componentManager.toComponent(TerminalClass, "Terminals", true, nil, true)