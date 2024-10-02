local noExceptionsMessage = "No exceptions!"
local byteLimit = 65000
local formatAllowedLimit = 75000 -- 75K

---@class ComputerClass : ShapeClass
ComputerClass = class()
ComputerClass.maxParentCount = -1
ComputerClass.maxChildCount = -1
ComputerClass.connectionInput = sm.interactable.connectionType.logic + sm.interactable.connectionType.compositeIO
ComputerClass.connectionOutput = sm.interactable.connectionType.compositeIO
ComputerClass.colorNormal = sm.color.new(0xaaaaaaff)
ComputerClass.colorHighlight = sm.color.new(0xffffffff)

-- SERVER + CLIENT --

local function is2ndStringCutOff(str1, str2)
    if #str1 >= #str2 then
        local trimmed_str1 = string.sub(str1, 1, #str2)
        return trimmed_str1 == str2
    else
        return false
    end
end

local function parseErrorMessage(errorMessage)
    local lineNumbers = {}
    local rawErrorMessage = errorMessage:gsub("%[string%s+\"[^\"]-\"%]:%d+:", ""):gsub("@?input:%d+:", ""):match("^%s*(.-)%s*$")

    for lineNumber in errorMessage:gmatch("input:(%d+):") do
        table.insert(lineNumbers, lineNumber)
    end

    lineNumbers = sm.scrapcomputers.table.reverse(lineNumbers)

    if errorMessage:find("input:%d+:") and not errorMessage:find("@input:%d+:") then
        return "#e74856ERROR: On parsing: [LuaVM]:" .. lineNumbers[1] .. ": " .. rawErrorMessage:gsub("#", "##"), lineNumbers
    end

    local errorPaths = {}
    for errorPath in errorMessage:gmatch("%[string%s+\"[^\"]-\"%]:%d+:") do
        local filePath, line = errorPath:match("%[string%s+\"(.-)\"%]:(%d+):")
        table.insert(errorPaths, {filePath, line})
    end

    local overloadTraceBack = false

    if #errorPaths > 10 then
        for i = #errorPaths, 20, -1 do
            table.remove(errorPaths, i)
        end

        overloadTraceBack = true
    end

    if #lineNumbers > 10 then
        for i = #lineNumbers, 10, -1 do
            table.remove(lineNumbers, i)
        end

        overloadTraceBack = true
    end


    local firstSection = ""
    if #errorPaths > 0 then
        firstSection = errorPaths[#errorPaths][1] .. ":" .. errorPaths[#errorPaths][2] .. ": "
    end

    local output = "#e74856ERROR: " .. firstSection .. rawErrorMessage:gsub("#", "##") .. "\n#f9f1a5----- Lua Error Traceback -----\n"

    for index, lineNumber in pairs(lineNumbers) do
        output = output .. "\t\t[LuaVM] in " .. (index == 1 and "" or "function ") .. ":" .. lineNumber .. ":\n"
    end

    for _, errorPath in pairs(errorPaths) do
        output = output .. "\t\t" .. errorPath[1] .. ":" .. errorPath[2] .. ":" .. "\n"
    end

    if overloadTraceBack then
        output = output .. "\t\t...\n"
    end

    return output:sub(1,-1), lineNumbers
end

-- SERVER --

function ComputerClass:server_onCreate()
    self.sv = {
        exceptionMessage = noExceptionsMessage,
        exceptionLines = {},
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
                    self.sv.exceptionLines = {}

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
            self.sv.exceptionLines = {}
            
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
        self.sv.exceptionLines = {}
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

    self.network:sendToClients("cl_clientSync", {alwaysOn = self.sv.saved.alwaysOn, exceptionMessage = self.sv.exceptionMessage, exceptionLines = self.sv.exceptionLines})
end

function ComputerClass:sv_resyncClient(data, player)
    local strings = sm.scrapcomputers.string.splitString(self.sv.saved.code:gsub("##", "#"), byteLimit)

    for i, string in pairs(strings) do
        self.network:sendToClient(player, "cl_rebuildCode", {string = string, i = i})
    end

    self.network:sendToClient(player, "cl_clientSync", {alwaysOn = self.sv.saved.alwaysOn, exceptionMessage = self.sv.exceptionMessage, exceptionLines = self.sv.exceptionLines})
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
    self.sv.exceptionMessage, self.sv.exceptionLines = parseErrorMessage(success and errorMessage or errorMessage2)
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
        exceptionLines = {},
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
    self.cl.gui:setButtonCallback("formatTextBtn", "cl_formatTextBtn")

    self.cl.gui:setOnCloseCallback("cl_onGuiClose")
end

function ComputerClass:client_onInteract(character, state)
    if not state then return end

    self.network:sendToServer("sv_resyncClient")

    local exampleText = ""

    for index, example in pairs(sm.scrapcomputers.exampleManager.getExamples()) do
        exampleText = exampleText .. sm.scrapcomputers.toString(index) .. ": " .. example.name.. "\n"
    end

    self:cl_runTranslations()

    local code = self.cl.code:gsub("\\", "⁄")
    self.cl.unsavedCode = code

    self.cl.gui:setText("examplesList", exampleText:sub(1, #exampleText - 1))

    if #code > formatAllowedLimit then
        local safeCode = code:gsub("#", "##")

        self.cl.gui:setText("scriptData", safeCode)
    else
        self.cl.gui:setText("scriptData", sm.scrapcomputers.syntaxManager.highlightCode(code, self.cl.exceptionLines))
    end

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
    self.cl.exceptionLines = data.exceptionLines
    self:cl_runTranslations()

    if data.exceptionMessage ~= noExceptionsMessage and not (#self.cl.code > formatAllowedLimit) then
        local safeCode = self.cl.code:gsub("\\", "⁄")
        self.cl.gui:setText("scriptData", sm.scrapcomputers.syntaxManager.highlightCode(safeCode, self.cl.exceptionLines))
    end

    self.cl.gui:setText("exceptionData", data.exceptionMessage)
end

function ComputerClass:cl_rebuildCode(data)
    self.cl.code = (data.i == 1 and data.string or self.cl.code .. data.string)
end

-- GUI Callbacks --

function ComputerClass:cl_onGuiClose()
    if sm.scrapcomputers.config.getConfig("scrapcomputers.computer.autosave").selectedOption == 1 then return end

    self:cl_saveCode()
    sm.gui.displayAlertText("[#3A96DDScrap#3b78ffComputers#eeeeee]: " .. sm.scrapcomputers.languageManager.translatable("scrapcomputers.computer.automaticly_saved"))
end

---@param text string
function ComputerClass:cl_scriptDataTextChange(widget, text)
    local oldCode = self.cl.unsavedCode
    self.cl.unsavedCode = text
    
    if #text == formatAllowedLimit and not is2ndStringCutOff(oldCode, text) then
        self:cl_setLogMessage(3 * 40, "e74856", sm.scrapcomputers.languageManager.translatable("scrapcomputers.computer.syntax_highlighting_disabled"))
    end

    if #text > formatAllowedLimit then
        if text:sub(1, #oldCode) == oldCode or is2ndStringCutOff(oldCode, text) then
            self.cl.gui:setText("scriptData", text)
        end
        return
    end

    if text:sub(1, #oldCode) == oldCode or is2ndStringCutOff(oldCode, text) then
        self:cl_formatTextBtn()
    end
end

function ComputerClass:cl_selectedExampleTextChange(widget, data)
    local dataNumber = tonumber(data)
    if not dataNumber then
        self.cl.gui:setVisible("loadExample", false)

        self:cl_setLogMessage(3 * 40, "e74856", sm.scrapcomputers.languageManager.translatable("scrapcomputers.computer.selected_example.not_a_number"))
        return
    end

    if dataNumber < 1 or dataNumber > sm.scrapcomputers.exampleManager.getTotalExamples() then
        self.cl.gui:setVisible("loadExample", false)

        self:cl_setLogMessage(3 * 40, "e74856", sm.scrapcomputers.languageManager.translatable("scrapcomputers.computer.selected_example.out_of_bounds", sm.scrapcomputers.exampleManager.getTotalExamples()))
        return
    end

    if math.floor(dataNumber) ~= dataNumber then
        self.cl.gui:setVisible("loadExample", false)

        self:cl_setLogMessage(3 * 40, "e74856", sm.scrapcomputers.languageManager.translatable("scrapcomputers.computer.selected_example.cannot_be_decimal"))
        return
    end

    self.cl.gui:setVisible("loadExample", true)
    self.cl.example.selected = dataNumber

    self:cl_setLogMessage(3 * 40, "3a96dd", sm.scrapcomputers.languageManager.translatable("scrapcomputers.computer.selected_example.valid_example_selected", sm.scrapcomputers.exampleManager.getExamples()[dataNumber].name))
end

function ComputerClass:cl_formatTextBtn(widget, name)
    if #self.cl.unsavedCode > formatAllowedLimit then
        self:cl_setLogMessage(5 * 40, "e74856", sm.scrapcomputers.languageManager.translatable("scrapcomputers.computer.syntax_character_limit_reached", formatAllowedLimit, #self.cl.unsavedCode))
        return
    end
    
    local code = self.cl.unsavedCode:gsub("\\", "⁄")
    self.cl.exceptionLines = {}
    self.cl.gui:setText("scriptData", sm.scrapcomputers.syntaxManager.highlightCode(code, {}))
end

function ComputerClass:cl_saveButtonBtn(widget, name)
    self:cl_saveCode()
    self:cl_setLogMessage(3 * 40, "16c60c", sm.scrapcomputers.languageManager.translatable("scrapcomputers.computer.savedcode"))
end

function ComputerClass:cl_revertChangesBtn(widget, name)
    self.cl.unsavedCode = self.cl.code

    local code = self.cl.code:gsub("\\", "⁄")
    
    if #code > formatAllowedLimit then
        self.cl.gui:setText("scriptData", code)
    else
        self.cl.gui:setText("scriptData", sm.scrapcomputers.syntaxManager.highlightCode(code, {}))
    end

    self:cl_setLogMessage(3 * 40, "3a96dd", sm.scrapcomputers.languageManager.translatable("scrapcomputers.computer.code_reverted"))
end

function ComputerClass:cl_loadExample(widget, name)
    local example = sm.scrapcomputers.exampleManager.getExamples()[self.cl.example.selected]

    self:cl_setLogMessage(3 * 40, "3a96dd", sm.scrapcomputers.languageManager.translatable("scrapcomputers.computer.example_loaded", example.name))

    local code = example.script:gsub("\\", "⁄")
    code = sm.scrapcomputers.syntaxManager.highlightCode(code, {})

    self.cl.exceptionLines = {}

    self.cl.unsavedCode = example.script
    self.cl.gui:setText("scriptData", code)
end

function ComputerClass:cl_setAlwaysOnState(widget, name)
    self.cl.alwaysOn = not self.cl.alwaysOn

    self:cl_syncServer(2, self.cl.alwaysOn)
    self:cl_runTranslations()
end

function ComputerClass:cl_saveCode()
    self.cl.code = self.cl.unsavedCode:gsub("⁄", "\\"):gsub("#", "##")
    if self.cl.code == "" then
        self:cl_syncServer(1, {i = 1, string = "", finished = true})
        return
    end

    local strings = sm.scrapcomputers.string.splitString(self.cl.code, byteLimit)
    for i, string in pairs(strings) do
        self:cl_syncServer(1, {i = i, string = string, finished = i == #strings})
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

function ComputerClass:cl_runTranslations()
    if not sm.exists(self.cl.gui) then return end

    self.cl.gui:setText("mainTitle"    , sm.scrapcomputers.languageManager.translatable("scrapcomputers.computer.main_title"))
    self.cl.gui:setText("examplesTitle", sm.scrapcomputers.languageManager.translatable("scrapcomputers.computer.examples_title"))

    self.cl.gui:setText("scriptSave"   , sm.scrapcomputers.languageManager.translatable("scrapcomputers.computer.save_button"))
    self.cl.gui:setText("revertChanges", sm.scrapcomputers.languageManager.translatable("scrapcomputers.computer.revert_changes_button"))
    self.cl.gui:setText("formatTextBtn", sm.scrapcomputers.languageManager.translatable("scrapcomputers.computer.format_text_button"))
    self.cl.gui:setText("loadExample"  , sm.scrapcomputers.languageManager.translatable("scrapcomputers.computer.load_example_button"))

    local alwaysOnText = sm.scrapcomputers.languageManager.translatable("scrapcomputers.computer.always_on_toggable_button", self.cl.alwaysOn and "#16C60CTrue" or "#E74856False")
    self.cl.gui:setText("alwaysOn", alwaysOnText)
end

sm.scrapcomputers.componentManager.toComponent(ComputerClass, nil, false)