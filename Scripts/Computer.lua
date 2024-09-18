local noExceptionsMessage = "No exceptions!"
local byteLimit = 65000

---@class ComputerClass : ShapeClass
ComputerClass = class()
ComputerClass.maxParentCount = -1
ComputerClass.maxChildCount = -1
ComputerClass.connectionInput = sm.interactable.connectionType.logic + sm.interactable.connectionType.compositeIO
ComputerClass.connectionOutput = sm.interactable.connectionType.compositeIO
ComputerClass.colorNormal = sm.color.new(0xaaaaaaff)
ComputerClass.colorHighlight = sm.color.new(0xffffffff)

-- SERVER + CLIENT --

local function parseErrorMessage(errorMessage)
    local lineNumbers = {}
    local rawErrorMessage = errorMessage:gsub("%[string%s+\"[^\"]-\"%]:%d+:", ""):gsub("@?input:%d+:", ""):match("^%s*(.-)%s*$")

    for lineNumber in errorMessage:gmatch("input:(%d+):") do
        table.insert(lineNumbers, lineNumber)
    end

    if errorMessage:find("input:%d+:") and not errorMessage:find("@input:%d+:") then
        return "#e74856ERROR: On parsing: [LuaVM]: " .. lineNumbers[1] .. ":" .. rawErrorMessage:gsub("#", "##")
    end

    local errorPaths = {}
    for errorPath in errorMessage:gmatch("%[string%s+\"[^\"]-\"%]:%d+:") do
        local filePath, line = errorPath:match("%[string%s+\"(.-)\"%]:(%d+):")
        table.insert(errorPaths, {filePath, line})
    end

    local output = "#e74856ERROR: " .. errorPaths[#errorPaths][1] .. ":" .. errorPaths[#errorPaths][2] .. ": " .. rawErrorMessage:gsub("#", "##") .. "\n#f9f1a5----- Lua Error Traceback -----\n"

    for index, lineNumber in pairs(lineNumbers) do
        output = output .. "\t\t[LuaVM] in " .. (index == 1 and "" or "function ") .. ":" .. lineNumber .. ":\n"
    end

    for _, errorPath in pairs(errorPaths) do
        output = output .. "\t\t" .. errorPath[1] .. ":" .. errorPath[2] .. ":" .. "\n"
    end

    return output
end

-- SERVER --

function ComputerClass:server_onCreate()
    self.sv = {
        exceptionMessage = noExceptionsMessage,
        alwaysOnDisabled = false,
        env = sm.scrapcomputers.enviromentManager.createEnv(self),
        wait1Tick = false,
        previousActive = false,
        canResetError = false,
    }
    self.sv.saved = self.storage:load()

    if not self.sv.saved then
        self.sv.saved = {
            code = "",
            alwaysOn = false,
        }

        self.storage:save(self.sv.saved)
    end

    self:sv_syncClients()
end

function ComputerClass:server_onFixedUpdate(deltaTime)
    if self.sv.wait1Tick then
        self.sv.wait1Tick = false
        return
    end

    local active = false
    local parents = self.interactable:getParents(sm.interactable.connectionType.logic)

    if #parents > 0 then
        for _, parent in pairs(parents) do
            if parent.active then
                active = true
                break
            end
        end
    elseif not self.sv.saved.alwaysOn then
        return
    end

    if not self.sv.alwaysOnDisabled and self.sv.saved.alwaysOn then
        active = true
    end

    if sm.scrapcomputers.config.getConfig("scrapcomputers.computer.reset_error_on_restart").selectedOption == 2 then
        if self:sv_hasException() and self.sv.previousActive ~= active then
            if active then
                if self.sv.canResetError then
                    self.sv.alwaysOnDisabled = false
                    self.interactable.active = false
                    self.sv.exceptionMessage = noExceptionsMessage

                    self.sv.wait1Tick = true
                end
                self.sv.canResetError = true
            end
            self.sv.previousActive = active
        end
    end

    if self:sv_hasException() then
        self.interactable.active = false
        return
    end

    if self.interactable.active ~= active then
        if active then
            self.sv.env = sm.scrapcomputers.enviromentManager.createEnv(self)
            self.sv.exceptionMessage = noExceptionsMessage

            self:sv_syncClients()

            local function run()
                local safeCode = self.sv.saved.code:gsub("##", "#")

                local func, errorMessage = sm.scrapcomputers.luavm.loadstring(safeCode, self.sv.env)
                if not func then error(errorMessage) end

                func()

                self:sv_runFunction(self.sv.env.onLoad)
            end

            local success, errorMessage = pcall(run)
            if not success then
                self:sv_callException(errorMessage)
            end
        else
            self:sv_runFunction(self.sv.env.onDestroy)
        end

        self.interactable.active = active
    end

    if active then
        self:sv_runFunction(self.sv.env.onUpdate, deltaTime)
    end
end

function ComputerClass:sv_hasException()
    return self.sv.exceptionMessage ~= noExceptionsMessage
end

function ComputerClass:sv_serverSync(data)
    if data.type == 1 then
        self.sv.saved.code = data.packet.i == 1 and data.packet.string or self.sv.saved.code .. data.packet.string

        if not data.packet.finished then return end

        self.sv.alwaysOnDisabled = false
        self.interactable.active = false
        self.sv.wait1Tick = true
        self.sv.exceptionMessage = noExceptionsMessage
    elseif data.type == 2 then
        self.sv.saved.alwaysOn = data.packet
    else
        sm.log.warning("ScrapComputers: Unknown server sync data on Computer! Type=[" .. sm.scrapcomputers.toString(data.type) .. "]\n\tData: " .. sm.scrapcomputers.toString(data.packet))
        return
    end

    self.storage:save(self.sv.saved)
    self:sv_syncClients()
end

function ComputerClass:sv_syncClients()
    local strings = sm.scrapcomputers.string.splitString(self.sv.saved.code:gsub("##", "#"), byteLimit)

    for i, string in pairs(strings) do
        self.network:sendToClients("cl_rebuildCode", {string = string, i = i})
    end

    self.network:sendToClients("cl_clientSync", {alwaysOn = self.sv.saved.alwaysOn, exceptionMessage = self.sv.exceptionMessage})
end

function ComputerClass:sv_resyncClient(data, player)
    local strings = sm.scrapcomputers.string.splitString(self.sv.saved.code:gsub("##", "#"), byteLimit)

    for i, string in pairs(strings) do
        self.network:sendToClient(player, "cl_rebuildCode", {string = string, i = i})
    end

    self.network:sendToClient(player, "cl_clientSync", {alwaysOn = self.sv.saved.alwaysOn, exceptionMessage = self.sv.exceptionMessage})
end

function ComputerClass:sv_runFunction(func, arg)
    local function run()
        if type(func) == "function" then
            func(arg)
        end
    end

    local success, errorMessage = pcall(run)
    if not success then
        self:sv_callException(errorMessage)
    end
end

function ComputerClass:sv_callException(errorMessage)
    local function run()
        if type(self.sv.env.onError) == "function" then
            self.sv.env.onError(errorMessage)
        end
    end

    local success, errorMessage2 = pcall(run)
    self.sv.exceptionMessage = parseErrorMessage(success and errorMessage or errorMessage2)
    self.sv.alwaysOnDisabled = true

    self:sv_syncClients()
end


-- CLIENT --

function ComputerClass:client_onCreate()
    self.cl = {
        example = {
            selected = 1,
            list = sm.json.open(sm.scrapcomputers.jsonFiles.ExamplesList)
        },
        exceptionMessage = "",
        hideLogIn = 0,
        code = "",
        unsavedCode = "",
        alwaysOn = false,
    }

    self.cl.gui = sm.gui.createGuiFromLayout(sm.scrapcomputers.layoutFiles.Computer, false, {backgroundAlpha = 0.5})

    self.cl.gui:setTextChangedCallback("scriptData", "cl_scriptDataTextChange")
    self.cl.gui:setTextChangedCallback("selectedExample", "cl_selectedExampleTextChange")

    self.cl.gui:setTextAcceptedCallback("selectedExample", "cl_loadExample")

    self.cl.gui:setButtonCallback("scriptSave", "cl_saveButtonBtn")
    self.cl.gui:setButtonCallback("loadExample", "cl_loadExample")
    self.cl.gui:setButtonCallback("revertChanges", "cl_revertChangesBtn")
    self.cl.gui:setButtonCallback("alwaysOn", "cl_setAlwaysOnState")

    self.cl.gui:setOnCloseCallback("cl_onGuiClose")
end

function ComputerClass:client_onInteract(character, state)
    if not state then return end

    self.network:sendToServer("sv_resyncClient")

    self.cl.example.list = sm.json.open(sm.scrapcomputers.jsonFiles.ExamplesList)
    local exampleText = ""

    for index, example in pairs(self.cl.example.list) do
        exampleText = exampleText .. sm.scrapcomputers.toString(index) .. ": " .. example.name.. "\n"
    end

    self.cl.gui:setText("examplesList", exampleText:sub(1, #exampleText - 1))
    self.cl.gui:setText("scriptData", ({self.cl.code:gsub("\\", "⁄"):gsub("#", "##")})[1])

    self.cl.gui:open()
end

function ComputerClass:client_onFixedUpdate()
    if self.cl.hideLogIn >= 0 then
        if self.cl.hideLogIn == 0 then
            self.cl.gui:setText("log", "")
        end

        self.cl.hideLogIn = self.cl.hideLogIn - 1
    end
end

function ComputerClass:cl_clientSync(data)
    self.cl.unsavedCode = self.cl.code
    self.cl.alwaysOn = data.alwaysOn

    self.cl.exceptionMessage = data.exceptionMessage
    self:cl_updateAlwaysOnMessage()

    self.cl.gui:setText("exceptionData", data.exceptionMessage)
end

function ComputerClass:cl_rebuildCode(data)
    self.cl.code = (data.i == 1 and data.string or self.cl.code .. data.string)
end

-- GUI Callbacks --

function ComputerClass:cl_onGuiClose()
    if sm.scrapcomputers.config.getConfig("scrapcomputers.computer.autosave").selectedOption == 1 then return end

    self:cl_saveCode()
    sm.gui.displayAlertText("[#3A96DDScrap#3b78ffComputers#eeeeee]: Automaticly saved code!")
end

function ComputerClass:cl_scriptDataTextChange(widget, text)
    self.cl.unsavedCode = text
end

function ComputerClass:cl_selectedExampleTextChange(widget, data)
    local dataNumber = tonumber(data)
    if not dataNumber then
        self.cl.gui:setVisible("loadExample", false)

        self:cl_setLogMessage(3 * 40, "e74856", "Not a number!")
        return
    end

    if dataNumber < 1 or dataNumber > #self.cl.example.list then
        self.cl.gui:setVisible("loadExample", false)

        self:cl_setLogMessage(3 * 40, "e74856", "Out of bounds! (1-" .. #self.cl.example.list .. ")")
        return
    end

    if math.floor(dataNumber) ~= dataNumber then
        self.cl.gui:setVisible("loadExample", false)

        self:cl_setLogMessage(3 * 40, "e74856", "Cannot be a decimal!")
        return
    end

    self.cl.gui:setVisible("loadExample", true)
    self.cl.example.selected = dataNumber

    self:cl_setLogMessage(3 * 40, "3a96dd", "Selected example: \"" .. self.cl.example.list[dataNumber].name .. "\"")
end

function ComputerClass:cl_saveButtonBtn(widget, name)
    self:cl_saveCode()
    self:cl_setLogMessage(3 * 40, "16c60c", "Saved code!")
end

function ComputerClass:cl_revertChangesBtn(widget, name)
    self.cl.unsavedCode = self.cl.code
    self.cl.gui:setText("scriptData", self.cl.unsavedCode)

    self:cl_setLogMessage(3 * 40, "3a96dd", "Reverted your code changes to current saved code!")
end

function ComputerClass:cl_loadExample(widget, name)
    local example = self.cl.example.list[self.cl.example.selected]

    self:cl_setLogMessage(3 * 40, "3a96dd", "Loaded example: \"" .. example.name .. "\"")

    self.cl.unsavedCode = example.script
    self.cl.gui:setText("scriptData", ({example.script:gsub("\\", "⁄"):gsub("#", "##")})[1])
end

function ComputerClass:cl_setAlwaysOnState(widget, name)
    self.cl.alwaysOn = not self.cl.alwaysOn

    self:cl_syncServer(2, self.cl.alwaysOn)
    self:cl_updateAlwaysOnMessage()
end

function ComputerClass:cl_saveCode()
    self.cl.code = self.cl.unsavedCode:gsub("⁄", "\\"):gsub("#", "##")

    local strings = sm.scrapcomputers.string.splitString(self.cl.code, byteLimit)
    for i, string in pairs(strings) do
        self:cl_syncServer(1, {i = i, string = string, finished = i == #strings})
    end
end

function ComputerClass:cl_updateAlwaysOnMessage()
    if self.cl.alwaysOn then
        self.cl.gui:setText("alwaysOn", "Always On: #16C60CTrue")
    else
        self.cl.gui:setText("alwaysOn", "Always On: #E74856False")
    end
end

function ComputerClass:cl_syncServer(type, data)
    self.network:sendToServer("sv_serverSync", {type = type, packet = data})
end

function ComputerClass:cl_setLogMessage(totalTicks, textColor, message)
    self.cl.hideLogIn = totalTicks
    self.cl.gui:setText("log", (textColor and "#" .. textColor or "") .. message)
end

-- Env related functions --

function ComputerClass:cl_chatMessage(msg)
    sm.gui.chatMessage(msg)
end

function ComputerClass:cl_alert(data)
    sm.gui.displayAlertText(unpack(data))
end

sm.scrapcomputers.componentManager.toComponent(ComputerClass, nil, false)