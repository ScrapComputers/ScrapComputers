---@class HDDClass : ShapeClass
HDDClass = class()
HDDClass.maxParentCount = 1
HDDClass.maxChildCount = 0
HDDClass.connectionInput = sm.interactable.connectionType.compositeIO
HDDClass.connectionOutput = sm.interactable.connectionType.none
HDDClass.colorNormal = sm.color.new(0x0eeb8fff)
HDDClass.colorHighlight = sm.color.new(0x58ed71ff)

-- This is against our prinicple. Fuck you Scrap Mechanic.
local byteLimit = 65000

-- SERVER + CLIENT --

local luaKeywords = {
    ["and"] = true, ["break"] = true, ["do"] = true, ["else"] = true, ["elseif"] = true,
    ["end"] = true, ["false"] = true, ["for"] = true, ["function"] = true, ["if"] = true,
    ["in"] = true, ["local"] = true, ["nil"] = true, ["not"] = true, ["or"] = true,
    ["repeat"] = true, ["return"] = true, ["then"] = true, ["true"] = true, ["until"] = true,
    ["while"] = true
}

local function isExampleNameCorrect(name)
    return not (name == nil or name == "" or name:match("^%s") or luaKeywords[name] or not name:match("^[%a_]") or not name:match("^%w+$"))
end

-- SERVER --

function HDDClass:sv_createData()
    return {
        -- Returns the self.savedData variable
        ---@return table data The data
        load = function ()
            return type(self.sv.savedData) == "string" and sm.json.parseJsonString(self.sv.savedData) or self.sv.savedData 
        end,

        -- Saves data to the shape itself
        save = function (data)
            sm.scrapcomputers.errorHandler.assertArgument(data, nil, {"table"})

            local function jsonCompattiblityChecker(root, rootPath)
                local validValueTypes = {
                    ["table"] = true,
                    ["number"] = true,
                    ["string"] = true,
                    ["boolean"] = true,
                    ["nil"] = true,
                }
                local validIndexTypes = {
                    ["number"] = true,
                    ["string"] = true,
                }

                for index, value in pairs(root) do
                    local path = rootPath == "" and "ROOT" or rootPath:sub(1, #rootPath - 1)
                    local indexName = sm.scrapcomputers.toString(index)

                    local errorMessage = "Path=[\"" .. path .."\"] Name=[\"" .. indexName .. "\"] Type=[\""

                    sm.scrapcomputers.errorHandler.assert(validIndexTypes[type(index)], nil, "Unsupported index type: " .. errorMessage .. type(index) .. "\"]")
                    sm.scrapcomputers.errorHandler.assert(validValueTypes[type(value)], nil, "Unsupported value type: " .. errorMessage .. type(value) .. "\"]")

                    if type(value) == "table" then
                        jsonCompattiblityChecker(value, rootPath .. index .. ". ")
                    end
                end
            end

            jsonCompattiblityChecker(data, "")

            local dataSize = #sm.scrapcomputers.json.toString(data, false)
            if dataSize > byteLimit then
                error("Data too big! (Max is "..byteLimit..", The data's size is "..dataSize..")")
            end

            self:sv_saveData({data, true})
        end
}
end

---@param params {[1]: string, [2]: boolean} The data
function HDDClass:sv_saveData(params)
    local data, souldUpdateToClients = unpack(params)
    
    self.sv.savedData = sm.json.writeJsonString(data)
    self.storage:save(self.sv.savedData)

    self.sv.updateDataToClients = souldUpdateToClients
end

function HDDClass:server_onCreate()
    self.sv = {
        savedData = self.storage:load(),
        updateDataToClients = true
    }

    if type(self.sv.savedData) == "string" then
        self.sv.savedData = sm.json.parseJsonString(self.sv.savedData)
    end

    if not self.sv.savedData then
        self.sv.savedData = {}
        self.storage:save(self.sv.savedData)
    end
end

function HDDClass:server_onFixedUpdate()
    if self.sv.updateDataToClients then
        self.sv.updateDataToClients = false
        self.network:sendToClients("cl_updateDriveData", self.sv.savedData)
    end
end

function HDDClass:sv_updateClient(_, player)
    self.network:sendToClient(player, "cl_updateDriveData", self.sv.savedData)
end

-- CLIENT --

function HDDClass:client_onCreate()
    self.cl = {
        gui = nil,
        driveContents = {},
        inputText = "",
        exampleInputText = "",
        waitCount = 0,
        selectedExample = nil,
        character = nil
    }

    self.network:sendToServer("sv_updateClient")
end

function HDDClass:client_onInteract(character, state)
    if not state then return end

    self.cl.exampleInputText = ""
    
    self.cl.gui = sm.gui.createGuiFromLayout(sm.scrapcomputers.layoutFiles.Harddrive, true, {backgroundAlpha = 0.5})
        
    self.cl.gui:setText("driveContents", sm.scrapcomputers.json.prettifyTable(self.cl.driveContents))
    self.cl.inputText = sm.scrapcomputers.json.toString(self.cl.driveContents)

    self.cl.gui:setButtonCallback("saveBtn", "cl_onSaveBtn")
    self.cl.gui:setButtonCallback("importDataBtn", "cl_onImportExampleBtn")
    self.cl.gui:setButtonCallback("exportDataBtn", "cl_onExportExampleBtn")
    self.cl.gui:setButtonCallback("deleteBtn", "cl_onDeleteExampleBtn")
    self.cl.gui:setButtonCallback("formatDataBtn", "cl_onFormatBtn")

    self.cl.gui:setTextChangedCallback("driveContents", "cl_updateHDDContents")
    self.cl.gui:setTextChangedCallback("selectedOption", "cl_updateSelectedExample")

    self.cl.gui:setVisible("deleteBtn", false)
    self.cl.gui:setVisible("exportDataBtn", true)
    self.cl.gui:setVisible("importDataBtn", false)

    self:cl_updateExamples()
    self:cl_runTranslations()

    self.cl.gui:setOnCloseCallback("cl_onGuiClose")

    self.cl.gui:open()
    sm.effect.playHostedEffect("ScrapComputers - event:/ui/menu_open", character)
    self.cl.character = character
end

function HDDClass:cl_onGuiClose()
    if self.cl.character then
        sm.effect.playHostedEffect("ScrapComputers - event:/ui/menu_close", self.cl.character)
    end
end

function HDDClass:cl_onFormatBtn(widget, p)
    local safeText = self.cl.inputText:gsub("\\", "⁄")
    self.cl.gui:setText("driveContents", sm.scrapcomputers.json.prettifyString(safeText))
end

---@param text string The text
function HDDClass:cl_updateSelectedExample(widget, text)
    local examples = sm.json.open(sm.scrapcomputers.jsonFiles.HarddriveExamples)
    local selectedExample = nil

    for _, example in pairs(examples) do
        if example.name:lower() == text:lower() then
            selectedExample = example
            break
        end
    end

    if selectedExample then
        self.cl.gui:setVisible("deleteBtn"    , not selectedExample.builtIn)
        self.cl.gui:setVisible("exportDataBtn", not selectedExample.builtIn)

        if not selectedExample.builtIn then
            self.cl.gui:setText("exportDataBtn", sm.scrapcomputers.languageManager.translatable("scrapcomputers.drive.overwritebtn"))
        end
        self.cl.gui:setVisible("importDataBtn", true)

        self.cl.selectedExample = selectedExample
    else
        self.cl.gui:setVisible("deleteBtn", false)
        self.cl.gui:setVisible("exportDataBtn", true)
        self.cl.gui:setVisible("importDataBtn", false)
        self.cl.gui:setText("exportDataBtn", sm.scrapcomputers.languageManager.translatable("scrapcomputers.drive.exportbtn"))

        self.cl.selectedExample = nil
    end

    self.cl.exampleInputText = text
end

function HDDClass:cl_onDeleteExampleBtn()
    local contents = sm.json.open(sm.scrapcomputers.jsonFiles.HarddriveExamples)

    for index, example in pairs(contents) do
        if example.name:lower() == self.cl.exampleInputText:lower() then
            table.remove(contents, index)

            sm.json.save(contents, sm.scrapcomputers.jsonFiles.HarddriveExamples)

            self.cl.gui:setText("log", "#3A96DD" .. sm.scrapcomputers.languageManager.translatable("scrapcomputers.drive.examples.example_deleted", self.cl.exampleInputText))
            self.cl.waitCount = 3 * 40

            self:cl_updateExamples()
            self:cl_updateSelectedExample(nil, self.cl.exampleInputText)
            return
        end
    end

    self.cl.gui:setText("log", "#E74856" .. sm.scrapcomputers.languageManager.translatable("scrapcomputers.drive.examples.example_not_found"))
    self.cl.waitCount = 3 * 40
end

function HDDClass:cl_onImportExampleBtn()
    local data = self.cl.selectedExample.data
    local newText = "{}"

    self.cl.inputText = newText
    self.cl.gui:setText("driveContents", sm.scrapcomputers.json.prettifyTable(data))

    self.cl.gui:setText("log", "#3A96DD" .. sm.scrapcomputers.languageManager.translatable("scrapcomputers.drive.examples.imported_example", self.cl.selectedExample.name))
    self.cl.waitCount = 3 * 40
end

function HDDClass:cl_onExportExampleBtn()
    if not isExampleNameCorrect(self.cl.exampleInputText) then
        self.cl.gui:setText("log", "#E74856" .. sm.scrapcomputers.languageManager.translatable("scrapcomputers.drive.examples.invalid_name"))
        self.cl.waitCount = 3 * 40

        return
    end

    local contents = sm.json.open(sm.scrapcomputers.jsonFiles.HarddriveExamples)
    local newInput = self.cl.inputText:gsub("⁄", "\\")
    local newData = sm.json.parseJsonString(newInput)

    if self.cl.selectedExample then
        for index, example in pairs(contents) do
            if example.name:lower() == self.cl.exampleInputText:lower() then
                contents[index].data = newData
                sm.json.save(contents, sm.scrapcomputers.jsonFiles.HarddriveExamples)

                self.cl.gui:setText("log", "#3A96DD" .. sm.scrapcomputers.languageManager.translatable("scrapcomputers.drive.examples.overwrited_example", self.cl.selectedExample.name))
                self.cl.waitCount = 3 * 40

                break
            end
        end
    else
        table.insert(contents, {builtIn = false, data = newData, name = self.cl.exampleInputText})
        sm.json.save(contents, sm.scrapcomputers.jsonFiles.HarddriveExamples)

        self.cl.gui:setText("log", "#3A96DD" .. sm.scrapcomputers.languageManager.translatable("scrapcomputers.drive.examples.created_example", self.cl.exampleInputText))
        self.cl.waitCount = 3 * 40
    end

    self:cl_updateExamples()
    self:cl_updateSelectedExample(nil, self.cl.exampleInputText)
end

function HDDClass:cl_onSaveBtn()
    local newInput = self.cl.inputText:gsub("⁄", "\\")
    local success, result = pcall(sm.json.parseJsonString, newInput) ---@type boolean, string|table

    if success then
        local dataSize = sm.scrapcomputers.json.toString(result, true)

        if #dataSize > byteLimit then
            self.cl.gui:setText("log", "#E74856" .. sm.scrapcomputers.languageManager.translatable("scrapcomputers.drive.data_overload", byteLimit, #dataSize))
            self.cl.waitCount = 10 * 40
        else
            self.network:sendToServer("sv_saveData", {result, true})

            self.cl.gui:setText("log", "#3A96DD" .. sm.scrapcomputers.languageManager.translatable("scrapcomputers.drive.saved_data"))
            self.cl.waitCount = 3 * 40
        end
    else
        if result:find("\n") then
            local line, column = string.match(result, "Line (%d+), Column (%d+)")
            local errorLines = {}

            for line in result:gmatch("[^\n]+") do
                table.insert(errorLines, line)
            end

            local specificError = errorLines[3] or sm.scrapcomputers.languageManager.translatable("scrapcomputers.drive.unknown_error")

            self.cl.gui:setText("log", "#E74856" .. sm.scrapcomputers.languageManager.translatable("scrapcomputers.drive.json_error", line, column, specificError))
            self.cl.waitCount = 10 * 40
        else
            self.cl.gui:setText("log", "#E74856" .. result)
            self.cl.waitCount = 10 * 40
            
            sm.scrapcomputers.logger.error("HDD.lua", result)
        end
    end
end

function HDDClass:client_onFixedUpdate()
    if self.cl.waitCount >= 0 then
        if self.cl.waitCount == 0 and sm.exists(self.cl.gui) then
            self.cl.gui:setText("log", "")
        end

        self.cl.waitCount = self.cl.waitCount - 1
    end
end

---@param text string
function HDDClass:cl_updateHDDContents(widget, text)
    local unsafeText = text:gsub("⁄", "\\")
    self.cl.inputText = unsafeText
end

function HDDClass:cl_updateDriveData(newData)
    -- BUGFIX: Do NoT reMove
    if type(newData) == "string" then
        newData =  sm.json.parseJsonString(newData)
    end

    if type(newData) == "nil" or not next(newData) then
        self.cl.driveContents = {}
    else
        self.cl.driveContents = newData
    end
end

-- Updates the example list
function HDDClass:cl_updateExamples()
    local examples = sm.json.open(sm.scrapcomputers.jsonFiles.HarddriveExamples)
    local text = ""

    for _, example in pairs(examples) do
        text = text .. example.name .. "\n"
    end

    self.cl.gui:setText("list", text)
end

function HDDClass:cl_runTranslations()
    self.cl.gui:setText("title"        , sm.scrapcomputers.languageManager.translatable("scrapcomputers.drive.title"             ))
    self.cl.gui:setText("saveBtn"      , sm.scrapcomputers.languageManager.translatable("scrapcomputers.drive.savebtn"           ))
    self.cl.gui:setText("deleteBtn"    , sm.scrapcomputers.languageManager.translatable("scrapcomputers.drive.deletebtn"         ))
    self.cl.gui:setText("importDataBtn", sm.scrapcomputers.languageManager.translatable("scrapcomputers.drive.importbtn"         ))
    self.cl.gui:setText("exportDataBtn", sm.scrapcomputers.languageManager.translatable("scrapcomputers.drive.exportbtn"         ))
    self.cl.gui:setText("formatDataBtn", sm.scrapcomputers.languageManager.translatable("scrapcomputers.drive.format_text_button"))
end

sm.scrapcomputers.componentManager.toComponent(HDDClass, "Harddrives", true)