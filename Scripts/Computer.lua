local noExceptionsMessage = "No exceptions!"
local byteLimit = 65000
--local formatAllowedLimit = 5000 -- 5K
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

local function generateTableHash(tbl)
    local hash = 0
    local prime = 31

    for key, value in pairs(tbl) do
        local keyHash = (type(key) == "number" and key or #key)

        local valueHash = 0
        if type(value) == "number" then
            valueHash = value
        elseif type(value) == "string" then
            for i = 1, #value do
                valueHash = valueHash + string.byte(value, i)
            end
        elseif type(value) == "boolean" then
            valueHash = value and 0x32 or 0x84
        end

        hash = hash + (keyHash * prime + valueHash)
    end

    return hash % (2^32)
end

---@param errorMessage string
---@return string
---@return table
local function parseErrorMessage(errorMessage, code)
    ---@type string
    local rawErrorMessage = errorMessage:gsub("%[string%s+\"[^\"]-\"%]:%d+:", ""):gsub("@?input:%d+:", ""):match("^%s*(.-)%s*$")
    local tracebackString = errorMessage:sub(1, #errorMessage - #rawErrorMessage - 1)
        :gsub("@input", "[string \"[LuaVM]\"]") -- Lua patterns fucking suck! I hope they burn in hell!
        
    local safeRawErrorMessage = rawErrorMessage:gsub("#", "##")

    if errorMessage:find("input:%d+:") and not errorMessage:find("@input:%d+: ") then
        local msgStart, msgEnd = errorMessage:find("input:%d+:")
        local lineNumber = errorMessage:sub(msgStart + 6, msgEnd - 1)
        
        return "#e74856ERROR: On parsing: [LuaVM]:" .. lineNumber .. ": " .. safeRawErrorMessage, {lineNumber}
    end

    if rawErrorMessage:sub(1, #"@virtual") == "@virtual" then
        local safeErrorMessage = errorMessage:gsub("@virtual:%d+: ", ""):gsub("#", "##")
        local multilineWarning = [[----- Fatal LBI Error -----
\tYou generally shouldn't get this error message, as this is a error caused by the LBI itself and it isn't with your code.
\tReport this error message to the ScrapComputers Team and tell us the error message above & how you can reproduce this ASAP!]]
        return "#e74856FATAL LBI ERROR: " .. safeErrorMessage .. "#f9f1a5\n" .. multilineWarning:gsub("\\t", "\t"), {}
    end

    local traceback = {}
    local firstLuaVM
    local shouldWarn = false
    for file, line in tracebackString:gmatch("%[string \"([^\"]+)\"%]:(%d+):") do
        if line ~= "0" then
            if not firstLuaVM and file == "[LuaVM]" then
                firstLuaVM = {file = file, line = line}
            end
            table.insert(traceback, {file = file, line = line})
        else
            shouldWarn = true
        end
    end

    firstLuaVM = firstLuaVM or traceback[1] or {file = "NaN", line = "NaN"}

    local output = "#e74856ERROR: " .. firstLuaVM.file .. ":" .. firstLuaVM.line .. ": " .. safeRawErrorMessage .. "\n" .. "#f9f1a5----- Lua Error Traceback -----"
    if shouldWarn then
        output = "#f9f1a5WARNING: LBI (LuaVM) has failed to retreive the Line where the error happened! This is not the fault for the LBI.\n" ..  output
    end
    local lines = {}

    for index, data in pairs(traceback) do
        output = output .. "\n\t"
        table.insert(lines, data.line)

        output = output .. data.file .. ":" .. data.line .. ":"
    end

    return output, lines
end

local function compressCode(data)
    return sm.scrapcomputers.base64.encode(sm.scrapcomputers.keywordCompression.compress(data))
end

local function decompressCode(data)
    return sm.scrapcomputers.keywordCompression.decompress(sm.scrapcomputers.base64.decode(data))
end

-- SERVER --

function ComputerClass:server_onCreate()
    self.sv = {
        exceptionMessage = noExceptionsMessage,
        exceptionLines = {},
        alwaysOnDisabled = false,
        env = sm.scrapcomputers.environmentManager.createEnv(self),
        wait1Tick = false,
        previousActive = false,
        canResetError = false,
        dataListHash = nil,
        cachedCode = nil
    }
    self.sv.saved = self.storage:load()
    
    if not self.sv.saved then
        self.sv.cachedCode = sm.scrapcomputers.exampleManager.getExamples()[1].script

        self.sv.saved = {
            version = 1,
            code = compressCode(self.sv.cachedCode),
            alwaysOn = false,
            identifier = sm.scrapcomputers.sha256.random(),
            displayName = "Computer #" .. tostring(self.interactable.id)
        }

        self.storage:save(self.sv.saved)
    end

    if not self.sv.saved.version then
        self.sv.saved.version = 1
        self.sv.cachedCode = self.sv.saved.code
        self.sv.saved.code = compressCode(self.sv.saved.code)
        self.storage:save(self.sv.saved)
    else
        -- This edge case likey never happens but just incase.
        
        local success, result = pcall(decompressCode, self.sv.saved.code)
        
        if success then
            self.sv.cachedCode = result
        else
            self.sv.cachedCode = self.sv.saved.code
            self.sv.saved.code = compressCode(self.sv.saved.code)
            self.storage:save(self.sv.saved)
        end
    end

    if not self.sv.saved.identifier then
        self.sv.saved.identifier = sm.scrapcomputers.sha256.random()
        self.sv.saved.displayName = "Computer #" .. tostring(self.interactable.id)

        self.storage:save(self.sv.saved)
    end

    self:sv_syncClients()
end

function ComputerClass:server_onDestroy()
    sm.scrapcomputers.dataList["Computers"][self.interactable.id] = nil
end

function ComputerClass:server_onFixedUpdate(deltaTime)
    if self.sv.wait1Tick then
        self.sv.wait1Tick = false
        self:sv_updateDataList()
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
        self:sv_updateDataList()
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
        self:sv_updateDataList()
        return
    end

    if self.interactable.active ~= active then
        if active then
            self.sv.env = sm.scrapcomputers.environmentManager.createEnv(self)
            self.sv.exceptionMessage = noExceptionsMessage
            self.sv.exceptionLines = {}
            
            self:sv_syncClients()

            local function run()
                local func, errorMessage = nil, nil
  
                if self.sv.saved.cachedBytecode then
                    func, errorMessage = sm.scrapcomputers.luavm.bytecodeLoadstring(sm.scrapcomputers.base64.decode(self.sv.saved.cachedBytecode), self.sv.env)
                else
                    local safeCode = self.sv.cachedCode:gsub("##", "#"):gsub("⁄", "\\")
                    func, errorMessage = sm.scrapcomputers.luavm.loadstring(safeCode, self.sv.env)
                    --func, errorMessage = loadstring(safeCode)

                    if func then
                        --setfenv(func, self.sv.env)

                        self.sv.saved.cachedBytecode = sm.scrapcomputers.base64.encode(errorMessage)
                        self.storage:save(self.sv.saved)
                    end
                end

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
    self:sv_updateDataList()
end

function ComputerClass:sv_updateDataList()
    local data = {
        identifer = self.sv.saved.identifier,
        displayName = self.sv.saved.displayName,
        exception = {
            hasException = self:sv_hasException(),
            exceptionMessage = self.sv.exceptionMessage,
            exceptionLines = self.sv.exceptionLines
        },
        config = {
            alwaysOn = self.sv.saved.alwaysOn,
        }
    }
    local dataHash = generateTableHash(data)

    if self.sv.dataListHash == dataHash then return end
    self.sv.dataListHash = dataHash

    sm.scrapcomputers.dataList["Computers"][self.interactable.id] = data
    self.network:sendToClients("cl_updateDataList", data)
end

function ComputerClass:sv_hasException()
    return self.sv.exceptionMessage ~= noExceptionsMessage
end

function ComputerClass:sv_serverSync(data)
    if data.type == 1 then
        self.sv.saved.cachedBytecode = nil
        self.sv.saved.code = data.packet.i == 1 and data.packet.string or self.sv.saved.code .. data.packet.string
        
        if not data.packet.finished then
            return
        end

        self.sv.cachedCode = self.sv.saved.code
        self.sv.saved.code = compressCode(self.sv.saved.code)

        self.sv.alwaysOnDisabled = false
        self.interactable.active = false
        self.sv.wait1Tick = true
        self.sv.exceptionMessage = noExceptionsMessage
        self.sv.debugConsoleLines = {}
        self.sv.exceptionLines = {}
    elseif data.type == 2 then
        self.sv.saved.alwaysOn = data.packet
    elseif data.type == 3 then
        self.sv.saved.displayName = data.packet
    else
        sm.scrapcomputers.logger.warn("Computer.lua", "Unknown server sync data on Computer! Type=[" .. sm.scrapcomputers.toString(data.type) .. "]\n\tData: " .. sm.scrapcomputers.toString(data.packet))
        return
    end

    self.storage:save(self.sv.saved)
    self:sv_syncClients()
end

function ComputerClass:sv_syncClients()
    local strings = sm.scrapcomputers.string.splitString(self.sv.cachedCode:gsub("##", "#"), byteLimit)

    for i, string in pairs(strings) do
        self.network:sendToClients("cl_rebuildCode", {string = string, i = i})
    end

    self.network:sendToClients("cl_clientSync", {
        alwaysOn = self.sv.saved.alwaysOn,
        exceptionMessage = self.sv.exceptionMessage,
        exceptionLines = self.sv.exceptionLines,
        identifier = self.sv.saved.identifier,
        displayName = self.sv.saved.displayName
    })
end

function ComputerClass:sv_resyncClient(data, player)
    local strings = sm.scrapcomputers.string.splitString(self.sv.cachedCode:gsub("##", "#"), byteLimit)

    for i, string in pairs(strings) do
        self.network:sendToClient(player, "cl_rebuildCode", {string = string, i = i})
    end

    self.network:sendToClient(player, "cl_clientSync", {
        alwaysOn = self.sv.saved.alwaysOn,
        exceptionMessage = self.sv.exceptionMessage,
        exceptionLines = self.sv.exceptionLines,
        identifier = self.sv.saved.identifier,
        displayName = self.sv.saved.displayName
    })
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
    self.sv.exceptionMessage, self.sv.exceptionLines = parseErrorMessage(success and errorMessage or errorMessage2, self.sv.cachedCode)
    self.sv.alwaysOnDisabled = true

    self:sv_syncClients()
end

function ComputerClass:sv_callOnReload()
    self:sv_runFunction(self.sv.env.onReload)
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
        character = nil,
        identifier = nil,
        displayName = nil,
        allowedToFormatForSyncing = false
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
    self.cl.gui:setButtonCallback("openESNSconfigBtn", "cl_openESNSconfig")

    self.cl.gui:setOnCloseCallback("cl_onGuiClose")
    if not sm.scrapcomputers.isDeveloperEnvironment() then
        self.cl.gui:setVisible("openESNSconfigBtn", false)
    end
    
    self.cl.esnsGui = sm.gui.createGuiFromLayout(sm.scrapcomputers.layoutFiles.ComputerESNSConfig, false, {backgroundAlpha = 0.5})
    self.cl.esnsGui:setTextChangedCallback("displayName", "cl_esnsDisplayNameChanged")
    self.cl.esnsGui:setOnCloseCallback("cl_onESNSGuiClose")

    self.network:sendToServer("sv_resyncClient")
end

function ComputerClass:client_onInteract(character, state)
    if not state then return end
    self.cl.allowedToFormatForSyncing = true

    local exampleText = ""

    for index, example in pairs(sm.scrapcomputers.exampleManager.getExamples()) do
        exampleText = exampleText .. sm.scrapcomputers.toString(index) .. ": " .. example.name.. "\n"
    end

    self:cl_runTranslations()

    local code = self.cl.code:gsub("\\", "⁄")
    self.cl.unsavedCode = code

    self.cl.gui:setText("examplesList", exampleText:sub(1, #exampleText - 1))
    self.cl.gui:setText("exceptionData", self.cl.exceptionMessage)
    
    if #code > formatAllowedLimit then
        local safeCode = code:gsub("#", "##")

        self.cl.gui:setText("scriptData", safeCode)
    else
        self.cl.gui:setText("scriptData", sm.scrapcomputers.syntaxManager.highlightCode(code, self.cl.exceptionLines))
    end

    self.cl.gui:open()

    sm.effect.playHostedEffect("ScrapComputers - event:/ui/menu_open", character)
    self.cl.character = character
end

function ComputerClass:client_onFixedUpdate()
    if self.cl.hideLogIn >= 0 then
        if self.cl.hideLogIn == 0 then
            self.cl.gui:setText("log", "")
        end

        self.cl.hideLogIn = self.cl.hideLogIn - 1
    end
end

function ComputerClass:client_onDestroy()
    sm.scrapcomputers.dataList["Computers"][self.interactable.id] = nil
end

function ComputerClass:cl_clientSync(data)
    self.cl.unsavedCode = self.cl.code
    self.cl.alwaysOn = data.alwaysOn

    self.cl.exceptionMessage = data.exceptionMessage
    self.cl.exceptionLines = data.exceptionLines

    self.cl.identifier = data.identifier
    self.cl.displayName = data.displayName

    self:cl_runTranslations()

    if self.cl.allowedToFormatForSyncing and not (#self.cl.code > formatAllowedLimit) then
        local safeCode = self.cl.code:gsub("\\", "⁄")
        self.cl.gui:setText("scriptData", sm.scrapcomputers.syntaxManager.highlightCode(safeCode, self.cl.exceptionLines))
    end

    self.cl.gui:setText("exceptionData", data.exceptionMessage)
end

function ComputerClass:cl_rebuildCode(data)
    self.cl.code = (data.i == 1 and data.string or self.cl.code .. data.string)
end

-- GUI Callbacks --

-- Note, the code below here are bombarded with translations so they are basicly half the level readability of SComputer's entire source code.
-- And also the length of these translations are bigger than the wall of china.

function ComputerClass:cl_onGuiClose()
    if self.cl.character then
        sm.effect.playHostedEffect("ScrapComputers - event:/ui/menu_close", self.cl.character)
    end

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
            local text2 = text:gsub("#", "##")
            self.cl.gui:setText("scriptData", text2)
        end
        return
    end

    if text:sub(1, #oldCode) == oldCode or is2ndStringCutOff(oldCode, text) then
        local code = self.cl.unsavedCode:gsub("\\", "⁄")
        self.cl.exceptionLines = {}
        self.cl.gui:setText("scriptData", sm.scrapcomputers.syntaxManager.highlightCode(code, {}))
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

    if #self.cl.code < formatAllowedLimit then
        local code = self.cl.code:gsub("\\", "⁄"):gsub("##", "#")
        self.cl.exceptionLines = {}
        self.cl.gui:setText("scriptData", sm.scrapcomputers.syntaxManager.highlightCode(code, {}))
    end

    if self.interactable.active then
        self.network:sendToServer("sv_callOnReload")
    end
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

-- ESNS Config --

function ComputerClass:cl_openESNSconfig(widget, name)
    self.cl.gui:close()

    local safeDisplayName = self.cl.displayName:gsub("#", "##")
    self.cl.esnsGui:setText("identifer", self.cl.identifier)
    self.cl.esnsGui:setText("displayName", safeDisplayName)
    
    self.cl.esnsGui:open()
end

function ComputerClass:cl_esnsDisplayNameChanged(widget, text)
    self.cl.displayName = text
    self:cl_syncServer(3, self.cl.displayName)
end

function ComputerClass:cl_onESNSGuiClose()
    self:client_onInteract(self.cl.character, true)
end

-- Other --

function ComputerClass:cl_syncServer(type, data)
    self.network:sendToServer("sv_serverSync", {type = type, packet = data})
end

function ComputerClass:cl_setLogMessage(totalTicks, textColor, message)
    self.cl.hideLogIn = totalTicks
    self.cl.gui:setText("log", (textColor and "#" .. textColor or "") .. message)
end

function ComputerClass:cl_updateDataList(data)
    sm.scrapcomputers.dataList["Computers"][self.interactable.id] = data
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
    self.cl.gui:setText("loadExample"  , sm.scrapcomputers.languageManager.translatable("scrapcomputers.computer.load_example_button"))

    self.cl.gui:setText("formatTextBtn", "#eeeeee" .. sm.scrapcomputers.languageManager.translatable("scrapcomputers.computer.format_text_button"))
    self.cl.gui:setText("openESNSconfigBtn", "#eeeeee" .. sm.scrapcomputers.languageManager.translatable("scrapcomputers.computer.open_esncfg_button"))

    local alwaysOnText = sm.scrapcomputers.languageManager.translatable("scrapcomputers.computer.always_on_toggable_button", self.cl.alwaysOn and "#16C60CTrue" or "#E74856False")
    self.cl.gui:setText("alwaysOn", alwaysOnText)
end

sm.scrapcomputers.componentManager.toComponent(ComputerClass, nil, false)