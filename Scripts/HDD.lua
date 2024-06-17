dofile("$CONTENT_DATA/Scripts/Config.lua")

---@class ObjectTemplate : ShapeClass
HDD = class()
HDD.maxParentCount = 1
HDD.maxChildCount = 0
HDD.connectionInput = sm.interactable.connectionType.compositeIO
HDD.connectionOutput = sm.interactable.connectionType.none
HDD.colorNormal = sm.color.new(0x0eeb8fff)
HDD.colorHighlight = sm.color.new(0x58ed71ff)

local byteLimit = 65000

-- SERVER --

function HDD:sv_createData()
    return {
        -- Returns the self.savedData variable
        load = function () return self.sv.savedData end,

        -- Saves data to the shape itself
        save = function (data)
            -- Checks if the data variable is a table. else error it out.
            assert(type(data) == "table", "Expected table, got "..type(data).." instead!")

            -- JSON COMPATTABILITY CHECKER --
            ---@param root table
            local function jsonCompattiblityChecker(root, rootPath)
                -- Contains all valid types that JSON supports.
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

                -- Loop through root table.
                for index, value in pairs(root) do
                    -- Get the type of the value
                    local errorMessage = "Path=[\""..(rootPath == "" and "ROOT" or rootPath:sub(1, #rootPath - 1)).."\"] Name=[\""..sc.toString(index).."\"] Type="..(invalid == 1 and type(index) or type(value))

                    -- Check if the type of the index matches with anything in validIndexTypes table. If not, send error message
                    if not validIndexTypes[type(index)] then
                        error("Unsupported index type: "..errorMessage)
                    end

                    -- Check if the valueType matches with anything in validValueTypes table. If not, send error message
                    if not validValueTypes[type(value)] then
                        error("Unsupported value type: "..errorMessage)
                    end

                    -- If its a table, Run the jsonCompattiblityChecker on the value (so u cant store a function in a nested table)
                    if type(value) == "table" then
                        jsonCompattiblityChecker(value, rootPath..index..".")
                    end
                end
            end

            -- Check if compatible with data.
            jsonCompattiblityChecker(data, "")
            
            -- Convert the table to a string and check if its not above a limit. else error!
            local dataSize = #sc.json.toString(data, false)
            if dataSize > byteLimit then
                error("Data too big! (Max is "..byteLimit..", The data's size is "..dataSize..")")
            end

            -- Save it
            self:sv_saveData({data, true})
        end
    }
end

function HDD:sv_saveData(params)
    -- Unpack the data
    local data, souldUpdateToClients = unpack(params)

    -- Update self.savedData and save it to the storage of the shape
    self.sv.savedData = data
    self.storage:save(self.sv.savedData)

    if souldUpdateToClients then
        -- Enable boolean to update through clients
        self.sv.updateDataToClients = true
    end
end

function HDD:server_onCreate()
    -- Server-side Variables
    self.sv = {
        -- The saved data
        savedData = self.storage:load(),

        -- If true, It will update all clients with new drive contents
        updateDataToClients = true
    }

    -- If no data is present. Set it to a empty table and save it.
    if not self.sv.savedData then
        self.sv.savedData = {}
        self.storage:save(self.sv.savedData)
    end
end

function HDD:server_onFixedUpdate()
    -- Check if it sould update all clients data with new one
    if self.sv.updateDataToClients then
        self.sv.updateDataToClients = false

        self.network:sendToClients("cl_updateDriveData", self.sv.savedData)
    end
end

-- CLIENT --

function HDD:client_onCreate()
    -- Create client side variables
    self.cl = {
        gui = nil,             ---@type GuiInterface? The main GUI for the Harddrive
        hddContentText = "",   --                     Contains the data of the harddrive
        inputText = "",        --                     The input text provided by the user.
        exampleInputText = "", --                     The input provided by the user (FOR EAXMPLE LOADING/DELETION/CREATION)
        waitCount = 0,         --                     Log related (total wait time before clear)
        selectedExample = nil  ---@type DriveExample? The selected example
    }
end

function HDD:client_onInteract(_, state)
    -- If the state is false, return since this function gets called twice
    if not state then return end
    
    self.cl.inputText = self.cl.hddContentText -- Update input text
    self.cl.exampleInputText = "" -- Clear example input text
    
    self.cl.gui = sm.gui.createGuiFromLayout(sc.layoutFiles.Harddrive, true, { backgroundAlpha = 0.5 }) -- Create the gui
    
    local safeInput = self.cl.hddContentText:gsub("\\", "⁄")

    -- Update texts
    self.cl.gui:setText("DriveContents", safeInput)

    -- Add button callbacks
    self.cl.gui:setButtonCallback("SaveButton", "cl_onSaveBtn")
    self.cl.gui:setButtonCallback("ImportDataButton", "cl_onImportExampleBtn")
    self.cl.gui:setButtonCallback("ExportDataButton", "cl_onExportExampleBtn")
    self.cl.gui:setButtonCallback("DeleteButton", "cl_onDeleteExampleBtn")

    -- Add text callbacks
    self.cl.gui:setTextChangedCallback("DriveContents", "cl_updateHDDContents")
    self.cl.gui:setTextChangedCallback("SelectedOption", "cl_updateSelectedExample")

    -- Set default visibilties
    self.cl.gui:setVisible("DeleteButton", false)
    self.cl.gui:setVisible("ExportDataButton", true)
    self.cl.gui:setVisible("ImportDataButton", false)
    
    -- Update Drive Examples
    self:cl_updateExamples()

    -- Open the Gui
    self.cl.gui:open()
end

-- Called when user inputs text to the example selector
---@param text string
function HDD:cl_updateSelectedExample(_, text)
    ---@type DriveExample[] Get all drive examples
    local examples = sm.json.open(sc.jsonFiles.HarddriveExamples)
    ---@type DriveExample?
    local selectedExample = nil

    -- Loop through them
    for _, example in pairs(examples) do
        -- Check if example.name matches with text (lower-case characters only)
        if example.name:lower() == text:lower() then
            -- Set selectedExample to THIS example and stop
            selectedExample = example
            break
        end
    end

    -- Check if it found a example
    if selectedExample then
        if selectedExample.builtIn then
            -- Set visibilties (READ-ONLY EXAMPLE)
            self.cl.gui:setVisible("DeleteButton", false) -- Disabled since its a built-in Example
            self.cl.gui:setVisible("ExportDataButton", false) -- Disabled since its a built-in Example
            self.cl.gui:setVisible("ImportDataButton", true)
        else
            -- Set visibilties (OVERWRITE EXAMPLE)
            self.cl.gui:setVisible("DeleteButton", true)
            self.cl.gui:setVisible("ExportDataButton", true)
            self.cl.gui:setVisible("ImportDataButton", true)
            self.cl.gui:setText("ExportDataButton", "Overwrite Example") -- Update text to say that you can overwrite it
        end

        self.cl.selectedExample = selectedExample -- Update selected example
    else
        -- Set visibilties (CREATE EXAMPLE)
        self.cl.gui:setVisible("DeleteButton", false)
        self.cl.gui:setVisible("ExportDataButton", true)
        self.cl.gui:setVisible("ImportDataButton", false)
        self.cl.gui:setText("ExportDataButton", "Export Example") -- Update text since theres no example found

        self.cl.selectedExample = nil -- Set the selected eaxmple to nil since theres no example found
    end

    self.cl.exampleInputText = text -- Set the example input text to be the new one.
end

-- Called when the user will delete a example
function HDD:cl_onDeleteExampleBtn()
    local contents = sm.json.open(sc.jsonFiles.HarddriveExamples) ---@type DriveExample[] Get all examples

    for index, example in pairs(contents) do
        if example.name:lower() == self.cl.exampleInputText:lower() then
            table.remove(contents, index)
            sm.json.save(contents, sc.jsonFiles.HarddriveExamples)

            -- Send the log message
            self.cl.gui:setText("Log", "#3A96DDDeleted \""..self.cl.exampleInputText.."\" Example")
            self.cl.waitCount = 3 * 40

            -- Update Drive Examples
            self:cl_updateExamples()
                
            -- We can reuse a callback to update the button's. although not good practice
            self:cl_updateSelectedExample(nil, self.cl.exampleInputText)
            return
        end
    end

    -- Since it failed finding a example. Send a error log
    self.cl.gui:setText("Log", "#E74856Cannot find Example!")
    self.cl.waitCount = 3 * 40
end

-- Called when user will import data from the selected example
function HDD:cl_onImportExampleBtn()
    local data = self.cl.selectedExample.data -- Get the selected example's data
    
    local newText = "{}"

    -- Check if the data is not nil
    if data then
        -- Convert it to a string to update the DriveContents EditBox
        -- We need to check if the next item in data is nil. In that case its empty! else it has someting in!
        --                                    Empty table since theres nothing | Convert the data to a string       Dont color the text   Replace real \ with fake \
        newText = next(data) == nil and "{}"                             or sc.json.toString(data, false, true):gsub("#", "##")    :gsub("\\", "⁄") 
    end

    self.cl.inputText = newText -- Update the input text
    self.cl.gui:setText("DriveContents", newText) -- Update the drive content's gui text.

    -- Send the log message
    self.cl.gui:setText("Log", "#3A96DDImported \""..self.cl.selectedExample.name.."\" Example")
    self.cl.waitCount = 3 * 40
end

-- Called when user will export data from the selected example
function HDD:cl_onExportExampleBtn()
    -- Check if the name is valid
    if not self:svcl_isExampleNameCorrect(self.cl.exampleInputText) then
        -- Send the log message
        self.cl.gui:setText("Log", "#E74856Invalid Name for a example!")
        self.cl.waitCount = 3 * 40
        return
    end

    -- Open the examples
    local contents = sm.json.open(sc.jsonFiles.HarddriveExamples) ---@type DriveExample[] Get all examples
    local newInput = self.cl.inputText:gsub("⁄", "\\")            -- Convert fake \ to real \
    local newData = sc.json.toTable(newInput, false)              -- Convert it to a table

    -- Check if it selected a example
    if self.cl.selectedExample then
        -- Loop through all contents
        for index, example in pairs(contents) do
            -- Check if they both match
            if example.name:lower() == self.cl.exampleInputText:lower() then
                -- Overwrite it
                contents[index].data = newData
                sm.json.save(contents, sc.jsonFiles.HarddriveExamples) -- Save it

                -- Send the log message
                self.cl.gui:setText("Log", "#3A96DDOverwritten \""..self.cl.selectedExample.name.."\" Example")
                self.cl.waitCount = 3 * 40
                break
            end
        end
    else
        table.insert(contents, {builtIn = false, data = newData, name = self.cl.exampleInputText}) -- Add it to the bitch
        sm.json.save(contents, sc.jsonFiles.HarddriveExamples) -- Save it

        -- Send the log message
        self.cl.gui:setText("Log", "#3A96DDCreated \""..self.cl.exampleInputText.."\" Example")
        self.cl.waitCount = 3 * 40
    end

    -- Update Drive Examples
    self:cl_updateExamples()

    -- We can reuse a callback to update the button's. although not good practice
    self:cl_updateSelectedExample(nil, self.cl.exampleInputText)
end

-- Called when user presses the save button
function HDD:cl_onSaveBtn()
    -- Convert fake \ to real \
    local newInput = self.cl.inputText:gsub("⁄", "\\")

    -- Convert JSON data to a Lua table (used for error checking and updating the new data)
    ---@type boolean,string|table
    local success, result = pcall(sc.json.toTable, newInput)

    if success then
        -- Convert it back to a string
        local dataSize = sc.json.toString(result, false)
        
        --  Check if its not over the byte limit
        if #dataSize > byteLimit then
            -- Send the log message
            self.cl.gui:setText("Log", "#E74856Too much data! (Max: "..byteLimit..", Datasize: "..#dataSize..")")
            self.cl.waitCount = 10 * 40
        else
            -- Save it
            self.network:sendToServer("sv_saveData", {result, true})

            -- Send the log message
            self.cl.gui:setText("Log", "#3A96DDSaved brand new data!")
            self.cl.waitCount = 3 * 40
        end
    else
        -- We recieved a error! Let's see if it was a lua error or a JSON error by checking if there was a \n in the error msg
        if result:find("\n") then
            -- (JSON ERROR)
            -- Get line and Column nunbers
            local line, column = string.match(result, "Line (%d+), Column (%d+)")

            -- Get all lines of the message
            local error_lines = {}
            for line in result:gmatch("[^\n]+") do
                table.insert(error_lines, line)
            end

            -- Get the fourth element for error_line. That one usually contains the actual error message. If its nil, Just make it a "Unknown error"
            local specific_error = error_lines[3] or "Unknown error"

            -- Send the log message
            self.cl.gui:setText("Log", "#E74856JSON Error: Line "..line..", Column: "..column.."\n"..specific_error)
            self.cl.waitCount = 10 * 40
        else
            -- (LUA ERROR)
            -- Send the log message
            self.cl.gui:setText("Log", "#E74856"..result)
            self.cl.waitCount = 10 * 40

            -- Send it also to the console
            sm.log.error(result)
        end
    end
end

function HDD:client_onFixedUpdate()
    -- LOG SYSTEM
    -- Check if the wait count is higher than 0
    if self.cl.waitCount >= 0 then
        -- If its 0 and the gui exists. Clear the log
        if self.cl.waitCount == 0 and sm.exists(self.cl.gui) then
            self.cl.gui:setText("Log", "")
        end

        -- Decrease it by 1
        self.cl.waitCount = self.cl.waitCount - 1
    end
end

-- Used to update the text provided by the user.
---@param text string
function HDD:cl_updateHDDContents(_, text)
    self.cl.inputText = text
end

-- Used to be in sync with server side for drive contents
function HDD:cl_updateDriveData(newData)
    -- Check if its empty table. If so then make it a "{}" and not null. Else actually convert it to a json string.
    if not next(newData) then
        self.cl.hddContentText = "{}"
    else
        self.cl.hddContentText = sc.json.toString(newData, false, true):gsub("#", "##")
    end
end

-- Updates the example list
function HDD:cl_updateExamples()
    -- Get all examples
    ---@type DriveExample[]
    local examples = sm.json.open(sc.jsonFiles.HarddriveExamples)
    local text = ""

    -- Loop through them and put it into text variable
    for _, example in pairs(examples) do
        text = text..example.name.."\n"
    end

    -- Update it
    self.cl.gui:setText("List", text)
end

-- SERVER / CLIENT --

-- List of Lua keywords that cannot be used as identifiers
local lua_keywords = {
    ["and"] = true, ["break"] = true, ["do"] = true, ["else"] = true, ["elseif"] = true,
    ["end"] = true, ["false"] = true, ["for"] = true, ["function"] = true, ["if"] = true,
    ["in"] = true, ["local"] = true, ["nil"] = true, ["not"] = true, ["or"] = true,
    ["repeat"] = true, ["return"] = true, ["then"] = true, ["true"] = true,
    ["until"] = true, ["while"] = true
}


-- Returns true if a example name is correct
function HDD:svcl_isExampleNameCorrect(name)
    -- The awnser should be reversed!
    return not (
        name == nil              or -- Check if the name is nil
        name == ""               or -- Check if the name is an empty string
        name:match("^%s")        or -- Check if the name starts with whitespace
        lua_keywords[name]       or -- Check if the name is a Lua keyword
        not name:match("^[%a_]") or -- Check if the name starts with a valid character (letter or underscore)
        not name:match("^%w+$" )    -- Check if the name contains only valid characters (letters, digits, underscores)
    )
end


-- Convert the class to a component
dofile("$CONTENT_DATA/Scripts/ComponentManager.lua")
sc.componentManager.ToComponent(HDD, "Harddrives", true)