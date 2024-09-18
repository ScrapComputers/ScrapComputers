---@class TerminalClass : ShapeClass
TerminalClass = class()
TerminalClass.maxParentCount = 1
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
            table.insert(self.sv.text, newMsg)

            self.sv.updateInput = true
        end,

        ---Clears the console
        clear = function ()
            self.sv.text = {}
            self.sv.updateInput = true
        end,

        ---Clears the input history
        clearInputHistory = function ()
            self.sv.inputHistory = {}
            self.sv.updateInputHistory = true
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
    self.sv = {
        inputHistory = {},
        text = {},
        awaitingInputs = {},

        updateInputHistory = false,
        updateInput = false,
    }
end

function TerminalClass:server_onFixedUpdate()
    if self.sv.updateInputHistory then
        self.sv.updateInputHistory = false
        self.network:sendToClients("cl_setInputHistory", self.sv.inputHistory)
    end

    if self.sv.updateInput then
        self.sv.updateInput = false
        self.network:sendToClients("cl_setText", self.sv.text)
    end
end

function TerminalClass:sv_setInputHistory(inputHistory)
    self.sv.inputHistory = inputHistory
end

function TerminalClass:sv_receiveInput(text)
    table.insert(self.sv.awaitingInputs, text)
end

-- CLIENT --

function TerminalClass:client_onCreate()
    self.cl = {
        inputHistory = {},
        text = {},
        gui = nil,
        inputtedString = "",
}
end

function TerminalClass:client_onInteract(character, state)
    if not state then return end

    self.cl.inputtedString = ""

    self.cl.gui = sm.gui.createGuiFromLayout(sm.scrapcomputers.layoutFiles.Terminal, true, {backgroundAlpha = 0.5})

    self.cl.gui:setText("TerminalData", self:cl_formatText())
    self.cl.gui:setText("InputHistoryList", self:cl_formatInputHistory())

    self.cl.gui:setTextChangedCallback ("InputText", "cl_setInputTextFromGUI")
    self.cl.gui:setTextAcceptedCallback("InputText", "cl_summitInput")

    self.cl.gui:setButtonCallback("InputHistoryList_Button", "cl_clearHistory")
    self.cl.gui:setButtonCallback("InputText_Button", "cl_summitInput")

    self.cl.gui:open()
end

function TerminalClass:cl_setInputTextFromGUI(widget, text)
    self.cl.inputtedString = text
end

function TerminalClass:cl_summitInput(widget, name)
    table.insert(self.cl.text, self.cl.inputtedString)
    table.insert(self.cl.inputHistory, self.cl.inputtedString)

    self.network:sendToServer("sv_receiveInput", self.cl.inputtedString)
    self.network:sendToServer("sv_setInputHistory", self.cl.inputHistory)

    self.cl.gui:setText("InputText", "")
    self.cl.gui:setText("InputHistoryList", self:cl_formatInputHistory())

    self.cl.inputtedString = ""
end

function TerminalClass:cl_clearHistory(widget, name)
    self.cl.inputHistory = {}
    self.cl.gui:setText("InputHistoryList", "")

    self.network:sendToServer("sv_setInputHistory", self.cl.inputHistory)
end

---@return string str The formatted string
function TerminalClass:cl_formatText()
    if #self.cl.text == 0 then return "" end

    local text = ""

    for _, line in pairs(self.cl.text) do
        text = text .. line .. "#eeeeee\n"
    end

    return text:sub(1, #text - 1)
end

---@return string str The formatted string
function TerminalClass:cl_formatInputHistory()
    if #self.cl.inputHistory == 0 then return "" end

    local text = ""

    for _, line in pairs(self.cl.inputHistory) do
        text = text .. line .. "\n"
    end

    return text:sub(1, #text - 1)
end

---@param text string The text to set
function TerminalClass:cl_setText(text)
    -- Set it
    self.cl.text = text

    -- Set it on the gui if it exists
    if sm.exists(self.cl.gui) then
        self.cl.gui:setText("TerminalData", self:cl_formatText())
    end
end

---@param inputHistory string The text to set
function TerminalClass:cl_setInputHistory(inputHistory)
    self.cl.inputHistory = inputHistory

    if sm.exists(self.cl.gui) then
        self.cl.gui:setText("InputHistoryList", self:cl_formatInputHistory())
    end
end

sm.scrapcomputers.componentManager.toComponent(TerminalClass, "Terminals", true)