dofile("$CONTENT_DATA/Scripts/Config.lua")
dofile("$CONTENT_DATA/Scripts/LuaVM/Main.lua")

---@class Computer : ShapeClass
Computer = class()
Computer.maxParentCount = -1
Computer.maxChildCount = -1
Computer.connectionInput = sm.interactable.connectionType.logic + sm.interactable.connectionType.power + sm.interactable.connectionType.compositeIO
Computer.connectionOutput = sm.interactable.connectionType.compositeIO
Computer.colorNormal = sm.color.new(0xaaaaaaff)
Computer.colorHighlight = sm.color.new(0xffffffff)

-- SERVER --

function Computer:server_onCreate()
    -- Server side variables
    self.sv = {
        exception = false, -- Check if theres a exception or not
        lastActive = false, -- Last active state of interactable
        env = sm.scrapcomputers.envManager.createEnv(self), -- The enviroment variables them self
        firstTick = 0 -- Is true when the computer is only on for 1 tick
    }

    -- Server side variables that will be saved
    self.sv.saved = self.storage:load()

    -- If theres no data. create new date and save it.
    if not self.sv.saved then
        self.sv.saved = {
            code = ""
        }

        self.storage:save(self.sv.saved)
    end

    self.network:sendToClients("cl_onNewCode", self.sv.saved.code)
end

---Used for updating the text for all client's exception messages
---@param err string
function Computer:sv_onFixedUpdateException(err)
    -- Clone it
    local errmsg = err

    -- The actual run function
    local function run()
        if type(self.sv.env.onError) == "function" then
            self.sv.env.onError(err)
        end
    end

    -- Run the "run" function inside a pcall.
    ---@type boolean, any|string
    local success, errr = pcall(run)
    if not success then
        errmsg = errr
    end

    -- Format and send!
    self:sv_sendException("#E74856ERROR: "..errmsg:gsub("#", "##"):gsub("\t", "    "))
end

function Computer:server_onFixedUpdate()
    -- Get all parents filted by logic connections.
    local parents = self.interactable:getParents(sm.interactable.connectionType.logic)
    local active = false

    -- Loop through parents and check if one of them are active
    if #parents > 0 then
        for _, parent in pairs(parents) do
            if parent:isActive() then
                active = true
                break
            end
        end
    end

    -- DO NOT REMOVE IF STATEMENT!
    -- Removing it will be worsen the performance. See: https://scrapmechanicdocs.com/docs/Game-Script-Environment/Userdata/Interactable#setactive    
    --
    -- Checks if self.interactable.active is not the same as the active variable
    if self.interactable.active ~= active then
        -- Since its diffirent, Change the active of interactable to be the active variable
        self.interactable.active = active
    end
    
    if active ~= self.sv.lastActive then
        self.sv.lastActive = active

        if active then
            self.sv.env = sm.scrapcomputers.envManager.createEnv(self)
            self.sv.firstTick = 1

            -- Check if theres no exception
            if not self.sv.exception then
                 -- The actual run function
                local function run()
                    -- Change the unicode / to be a normal /
                    local newCode = self.sv.saved.code:gsub("⁄", "\\"):gsub("##", "#")

                    -- Run the script
                    ---@type function?,any
                    local func, err = sm.luavm.loadstring(newCode, self.sv.env)

                    if type(func) ~= "function" then
                        error(err)
                    end
                
                    func()

                    if type(self.sv.env.onLoad) == "function" and self.sv.firstTick == 1 then
                        self.sv.env.onLoad()
                        self.sv.firstTick = 2
                    end
                end
            
                -- Run the "run" function inside a pcall.
                ---@type boolean, any|string
                local success, err = pcall(run)
            
                -- If it failed. Set exception to true and set ExceptionData to the error with # formatted to ##
                if not success then
                    self:sv_onFixedUpdateException(err)
                end
            end
        else
            -- The actual run function
            local function run()
                if type(self.sv.env.onDestroy) == "function" then
                    self.sv.env.onDestroy()
                end
            end

            -- Run the "run" function inside a pcall.
            ---@type boolean, any|string
            local success, err = pcall(run)

            -- If it failed. Set exception to true and set ExceptionData to the error with # formatted to ##
            if not success then
                self:sv_onFixedUpdateException(err)
            end
            self.sv.firstTick = 0
        end
    end

    if active and not self.sv.exception then
        -- The actual run function
        local function run()
            if type(self.sv.env.onUpdate) == "function" then
                self.sv.env.onUpdate()
            end
        end

        -- Run the "run" function inside a pcall.
        ---@type boolean, any|string
        local success, err = pcall(run)

        -- If it failed. Set exception to true and set ExceptionData to the error with # formatted to ##
        if not success then
            self:sv_onFixedUpdateException(err)
        end
    end
end

function Computer:sv_sendException(err)
    -- Enable exception
    self.sv.exception = true

    -- Send data
    self.network:sendToClients("cl_setExceptionData", err)
end

function Computer:sv_saveScript(code)
    -- Update code and set exception to false
    self.sv.saved.code = code
    self.sv.exception = false
    self.sv.lastActive = false
    self.interactable:setActive(false)

    -- Save it
    self.storage:save(self.sv.saved)

    -- Update client side code value to the new code.
    self.network:sendToClients("cl_onNewCode", code)
end

function Computer:sv_updateclCodeFromServer()
    self.network:sendToClients("cl_onNewCode", self.sv.saved.code)
end

-- CLIENT --

function Computer:client_onCreate()
    -- Create a brand new table containing variables.
    self.cl = {
        code = "", -- The current code that's saved
        lastCode = "", -- The code that is used before actually saving it
        computerGui_LogDelay = 0, -- Log delay stuff. (Used to clear the logs afther a certan amount of ticks, Usally 5 secconds)
        exceptionData = "No exceptions!", -- The exception message
        allowLoadingExample = true, -- If true, u can load examples. else NO
        selectedExample = 1 -- The current selecte example
    }
end

function Computer:client_onInteract(_, state)
    -- Get saved code and store it here
    self.network:sendToServer("sv_updateclCodeFromServer")
    
    -- Check if the state isnt false. else return (client_Interact gets called when you push the use key down and release it)
    -- This prevents it to being called twice.
    if not state then return end
    
    -- Update last code to the latest code
    self.cl.lastCode = self.cl.code

    -- Update selectedExample to be 1 and allow loading examples
    self.cl.selectedExample = 1
    self.cl.allowLoadingExample = true
    
    -- Create the GUI and update callbacks and set text's
    self.computerGui = sm.gui.createGuiFromLayout(sm.scrapcomputers.layoutFiles.Computer, true, { backgroundAlpha = 0.5 })
    self.computerGui:setTextChangedCallback("ScriptData", "cl_TextChangedCallbackScriptData")
    self.computerGui:setTextChangedCallback("ExamplesList_Number", "cl_onTextChangedCallbackExamplesList")
    self.computerGui:setButtonCallback("ScriptSave", "cl_ScriptSave_ButtonCallback")
    self.computerGui:setButtonCallback("RevertChanges", "cl_onRevertChangesPressed")
    self.computerGui:setButtonCallback("ExamplesList_Button", "cl_onLoadExamplePressed")
    self.computerGui:setText("ExceptionData", self.cl.exceptionData)
    self.computerGui:setText("ScriptData", self.cl.code)
    
    -- Update example list
    self:cl_updateExampleList()

    -- Open the GUI
    self.computerGui:open()
end

function Computer:cl_updateExampleList()
    -- Get all examples
    ---@type CodeExample[]
    local json = sm.json.open(sm.scrapcomputers.jsonFiles.ExamplesList)

    -- Loop through them, format it and put it inside the text value
    local text = ""
    for key, value in pairs(json) do
        text = text.."\n"..sm.scrapcomputers.toString(key)..": "..value.name
    end

    -- Remove the first character so theres no \n at the beginning.
    text = text:sub(2)

    -- Update the example list (Check also if gui even exists)
    if sm.exists(self.computerGui) then
        self.computerGui:setText("ExamplesList", text)
    end
end

function Computer:cl_TextChangedCallbackScriptData(widget, text)
    -- Set last code to the changed new text (And also change # to ## so you cant put in #FF00FF and expect to change the code color)
    self.cl.lastCode = text:gsub("#", "##")
end

function Computer:cl_onLoadExamplePressed(widget, name)
    -- Check if you can load a example
    if not self.cl.allowLoadingExample then
        -- Send log message
        self.cl.computerGui_LogDelay = 3 * 40
        self.computerGui:setText("Log", "#E74856Cannot load Example! Your inputs may be wrong.")
    else
        -- Get the example
        ---@type CodeExample
        local example = sm.json.open(sm.scrapcomputers.jsonFiles.ExamplesList)[self.cl.selectedExample]
        local code = example.script:gsub("#", "##") -- Get the code and format it to prevent hex colors to getting formatted.

        -- Set ScriptData to the example code
        self.computerGui:setText("ScriptData", code) 
        self.cl.lastCode = code

        -- Send Log message
        self.cl.computerGui_LogDelay = 3 * 40
        self.computerGui:setText("Log", "#3A96DDLoaded \""..example.name.."\" Example.")
    end
end

function Computer:cl_onTextChangedCallbackExamplesList(_, text)
    -- Convert the text to a number and get all examples
    local result = tonumber(text)
    ---@type CodeExample[]
    local json = sm.json.open(sm.scrapcomputers.jsonFiles.ExamplesList)

    -- Check if result is nil
    if type(result) == "nil" then
        -- Send error log message (Not a number)
        self.cl.computerGui_LogDelay = 3 * 40

        self.cl.allowLoadingExample = false-- Dont allow loading examples.
        self.computerGui:setText("Log", "#E74856Inputted Example must be a positive-number!")
    elseif result <= 0 then -- Check if its 0 or lower.
        -- Send error log message (Input was lower than a 1)
        self.cl.computerGui_LogDelay = 3 * 40
        
        self.cl.allowLoadingExample = false -- Dont allow loading examples.
        self.computerGui:setText("Log", "#E74856Inputted Example cannot be 0 or lower!")
    elseif result > #json then -- Check if its more than the total examples
        -- Send error log message (Input was higher than the total existing examples)
        self.cl.computerGui_LogDelay = 3 * 40

        self.cl.allowLoadingExample = false -- Dont allow loading examples.
        self.computerGui:setText("Log", "#E74856Example dosen't exist! (Choose from 1 to "..#json..")")
    else
        -- Example exists. empty the log message and allow loading examples.
        self.cl.computerGui_LogDelay = -1

        self.cl.allowLoadingExample = true
        self.computerGui:setText("Log", "")

        self.cl.selectedExample = result
    end
end

function Computer:cl_ScriptSave_ButtonCallback(_, _)
    -- Set log message to say that it saved it.
    self.cl.computerGui_LogDelay = 3 * 40
    self.cl.exceptionData = "No exceptions!"
    
    self.computerGui:setText("Log", "#16C60CSaved Script!")
    
    -- Reset exception.
    self.computerGui:setText("ExceptionData", self.cl.exceptionData)

    -- Update code to change \ character to a unicode character and actually save it.
    local code = self.cl.lastCode:gsub("\\", "⁄")
    self.network:sendToServer("sv_saveScript", code)
end

function Computer:cl_onRevertChangesPressed(widget, name)
    -- Update last code
    self.cl.lastCode = self.cl.code

    -- Create the delay and send log and scriptdata to new one's
    self.cl.computerGui_LogDelay = 3 * 40
    self.computerGui:setText("Log", "#16C60CReverted Changes!")
    self.computerGui:setText("ScriptData", self.cl.lastCode)
end

function Computer:client_onFixedUpdate(dt)
    -- Check if computerGui_LogDelay is higher than a 0. if so, -1 it.
    -- Else check if its 0 and gui exists, then reset log message and set logDelay to -1.
    if self.cl.computerGui_LogDelay > 0 then
        self.cl.computerGui_LogDelay = self.cl.computerGui_LogDelay - 1
    elseif self.cl.computerGui_LogDelay == 0 and self.computerGui ~= nil then
        -- If the gui exist's. clear it, Else don't do that.
        if sm.exists(self.computerGui) then
            self.computerGui:setText("Log", "")
        end
        self.cl.computerGui_LogDelay = -1
    end
end

function Computer:cl_onNewCode(code)
    self.cl.code = code -- Update self.cl.code to the first argument above
end

function Computer:cl_setExceptionData(data)
    self.cl.exceptionData = data -- Update exception message to the first argument above

    -- If it exist's, Set the exception data to the new one.
    if sm.exists(self.computerGui) then
        self.computerGui:setText("ExceptionData", self.cl.exceptionData)
    end
end

function Computer:cl_chatMessage(msg)
    sm.gui.chatMessage(msg) -- Send chat message
end

function Computer:cl_alert(data)
    sm.gui.displayAlertText(unpack(data))
end