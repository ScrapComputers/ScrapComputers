dofile("$CONTENT_DATA/Scripts/Config.lua")

---@class Terminal : ShapeClass
Terminal = class()
Terminal.maxParentCount = 1
Terminal.maxChildCount = 0
Terminal.connectionInput = sm.interactable.connectionType.compositeIO
Terminal.connectionOutput = sm.interactable.connectionType.none
Terminal.colorNormal = sm.color.new(0x2f6929ff)
Terminal.colorHighlight = sm.color.new(0x359e31ff)

-- SERVER --

function Terminal:sv_createData()
    return {
        ---Sends a message to the terminal
        ---@param msg string
        send = function (msg)
            -- Convert the msg variable to a string and change ## to #
            local newMsg = sc.toString(msg):gsub("##", "#")

            -- Insert it to self.sv.text
            table.insert(self.sv.text, newMsg)

            -- Set updateInput variable to true
            self.sv.updateInput = true
        end,

        ---Clears all data.
        clear = function ()
            -- Set the self.sv.text to a empty table
            self.sv.text = {}
            
            -- Set updateInput variable to true
            self.sv.updateInput = true
        end,

        ---Clears the userinput
        clearInputHistory = function ()
            -- Set the self.sv.inputHistory to a empty table
            self.sv.inputHistory = {}

            -- Set updateInputHistory variable to true
            self.sv.updateInputHistory = true
        end,

        ---Returns true if theres available inputs.
        ---@return boolean
        receivedInputs = function ()
            -- Returns true if the table isnt empty, else false.
            return #self.sv.waitingInputs > 0
        end,

        ---Gets the latest user input
        ---
        ---**NOTE: Please check if theres any inputs before using this, It will cause a error if theres no user inputs available!**
        ---@return string
        getInput = function ()
            -- Check if theres any inputs
            if #self.sv.waitingInputs > 0 then
                self.sv.updateInput = true
                
                -- Remove the latest item from the list and return the table.remove output valeu
                -- (table.remove returns the deleted value)
                return table.remove(self.sv.waitingInputs, #self.sv.waitingInputs)
            end

            -- If theres no inputs, cause a error.
            error("No received Inputs found! (Use the receivedInputs function to not cause this error)")
        end
    }
end

function Terminal:server_onCreate()
    -- Create the serverside variables
    self.sv = {
        ---A list contaning the input history
        ---@type string[]
        inputHistory = {},

        ---A list contaning the output of the terminal
        ---@type string[]
        text = {},

        ---A list where all inputs from user are stored
        ---@type string[]
        waitingInputs = {},

        ---Used for updating Input History
        ---@type boolean
        updateInputHistory = false,

        ---Used for updating User Input
        ---@type boolean
        updateInput = false,
    }
end

function Terminal:server_onFixedUpdate()
    -- Check if it has to update user history for clients
    if self.sv.updateInputHistory then
        -- Set it to false and update it to all clients
        self.sv.updateInputHistory = false
        self.network:sendToClients("client_setInputHistory", self.sv.inputHistory)
    end

    -- Check if it has to update User input for clients
    if self.sv.updateInput then
        -- Set it to false and update it to all clients
        self.sv.updateInput = false
        self.network:sendToClients("client_setText", self.sv.text)
    end
end

function Terminal:server_setInputHistory(inputHistory)
    -- Sets the input history on the serverside to be what the argument "inputHistory" is.
    self.sv.inputHistory = inputHistory
end

function Terminal:server_receiveInput(text)
    --- Adds the "text" variable to the waitingInputs variable.
    table.insert(self.sv.waitingInputs, text)
end

-- CLIENT --

function Terminal:client_onCreate()    
    self.cl = {
        ---The main Graphical User Interface
        ---@type GuiInterface?
        gui = nil,

        ---A list contaning the input history
        ---@type string[]
        inputHistory = {},

        ---A list contaning the output of the terminal
        ---@type string[]
        text = {},

        ---Contains what the user has inputted from teh Graphical User Interface
        ---@type string
        inputtedString = ""
    }
end

function Terminal:client_onInteract(character, state)
    -- Checks if the state isnt true. if so then return
    if not state then return end
    
    -- Set the inputted string to be empty
    self.cl.inputtedString = ""

    -- Create the Graphical User Interface
    self.cl.gui = sm.gui.createGuiFromLayout(sc.layoutFiles.Terminal, true,  { backgroundAlpha = 0.5 })

    -- Set Widget captions
    self.cl.gui:setText("TerminalData", self:client_formatText())
    self.cl.gui:setText("InputHistoryList", self:client_formatInputHistory())

    -- Add callback when the "InputText" changes or gets accepted.
    self.cl.gui:setTextChangedCallback("InputText", "client_setInputTextFromGUI")
    self.cl.gui:setTextAcceptedCallback("InputText", "client_sendTextData")

    -- Add Button callbacks to InputHistoryList_Button and InputText_Button
    self.cl.gui:setButtonCallback("InputHistoryList_Button", "client_clearHistory")
    self.cl.gui:setButtonCallback("InputText_Button", "client_sendTextData")

    -- Open the Graphical User Interface
    self.cl.gui:open()
end

function Terminal:client_setInputTextFromGUI(widget, text)
    -- Set the inputtedString to be the text variable.
    self.cl.inputtedString = text
end

function Terminal:client_sendTextData(widget, name)
    --Add the input string to text AND inputHistory
    table.insert(self.cl.text, self.cl.inputtedString)
    table.insert(self.cl.inputHistory, self.cl.inputtedString)

    -- Update them
    self.network:sendToServer("server_receiveInput",self.cl.inputtedString )
    self.network:sendToServer("server_setInputHistory", self.cl.inputHistory)

    -- Set the Input Text to be empty and set the InputHistoryList to be the new one.
    self.cl.gui:setText("InputText", "")
    self.cl.gui:setText("InputHistoryList", self:client_formatInputHistory())
    
    -- Reset the inputtedString
    self.cl.inputtedString = ""
end

function Terminal:client_clearHistory(widget, name)
    -- Set the input history to be empty and clear text from the InputHistoryList widget.
    self.cl.inputHistory = {}
    self.cl.gui:setText("InputHistoryList", "")

    -- Update it
    self.network:sendToServer("server_setInputHistory", self.cl.inputHistory)
end

function Terminal:client_formatText()
    -- Return empty string if the self.cl.text is empty
    if #self.cl.text == 0 then return "" end

    local text = ""

    -- Loop through self.cl.text and add it to the text variable above this comment.
    for _, line in pairs(self.cl.text) do
        text = text..line.."#eeeeee\n"
    end

    -- Return the output of the sub (It removes the last character and thats ALWAYS a \n)
    return text:sub(1, #text - 1)
end

function Terminal:client_formatInputHistory()
    -- Return empty string if the self.cl.text is empty
    if #self.cl.inputHistory == 0 then return "" end
    
    local text = ""

    -- Loop through self.cl.text and add it to the text variable above this comment.
    for _, line in pairs(self.cl.inputHistory) do
        text = text..line.."\n"
    end

    -- Return the output of the sub (It removes the last character and thats ALWAYS a \n)
    return text:sub(1, #text - 1)
end

function Terminal:client_setText(text)
    -- Sets the clientside variable text to be the "text" argument
    self.cl.text = text

    -- Check if the gui exists. if so then update its TerminalData to be the formatted version of it.
    if sm.exists(self.cl.gui) then
        self.cl.gui:setText("TerminalData", self:client_formatText())
    end
end

function Terminal:client_setInputHistory(inputHistory)
     -- Sets the clientside variable text to be the "inputHistory" argument
    self.cl.inputHistory = inputHistory

     -- Check if the gui exists. if so then update its InputHistoryList to be the formatted version of it.
    if sm.exists(self.cl.gui) then
        self.cl.gui:setText("InputHistoryList", self:client_formatInputHistory())
    end
end

-- Convert the class to a component
dofile("$CONTENT_DATA/Scripts/ComponentManager.lua")
sc.componentManager.ToComponent(Terminal, "Terminals", true)