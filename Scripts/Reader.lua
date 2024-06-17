dofile("$CONTENT_DATA/Scripts/Config.lua")

---@class Reader : ShapeClass
Reader = class()
Reader.maxParentCount = 1
Reader.maxChildCount = -1
Reader.connectionOutput = sm.interactable.connectionType.compositeIO
Reader.connectionInput = sm.interactable.connectionType.logic + sm.interactable.connectionType.power
Reader.colorNormal = sm.color.new(0xaa0000ff)
Reader.colorHighlight = sm.color.new(0xff0000ff)

-- SERVER --

function Reader:server_onCreate()    
    -- Create server side variables
    self.sv = {
        power = 0, -- The current power
        lastPower = 0 -- The previous power
    }

    -- Load the storage and if nil, Be a empty string
    local name = self.storage:load() or ""

    -- Add it to datalist
    sc.dataList["Readers"][self.interactable:getId()] = {name = name, power = 0}

    -- Update the name from all clients to be the same as the server one
    self.network:sendToClients("cl_setReaderName", name)
end

function Reader:server_onFixedUpdate()
    -- Get the only single parent.
    local parent = self.interactable:getSingleParent()

    -- Check if there is a parent
    if parent then
        -- Get its power
        local power = parent.power

        -- Check if its a button or lever. If so then check if its active and if true, Be 1, else 0 and if not button or lever. dont change it.
        if parent.type == "button" or parent.type == "lever" then
            power = parent:isActive() and 1 or 0
        end

        -- Check if the previous power isnt the same as the power variable
        if self.sv.lastPower ~= power then
            -- Update it
            self.sv.lastPower = power
            
            -- Update the API
            sc.dataList["Readers"][self.interactable:getId()].power = power

            -- Update the interactable's power and active state
            self.interactable.power = power
            self.interactable.active = power > 0
        end
    end
end

function Reader:server_onDestroy()
    -- Remove it from the datalist
    sc.dataList["Readers"][self.interactable:getId()] = nil
end

function Reader:sv_setReaderName(name)
    -- Update server-side reader name.
    sc.dataList["Readers"][self.interactable:getId()].name = name
    self.storage:save(name)
end

-- CLIENT --

function Reader:client_onCreate()
    -- Create client-side variables
    self.cl = {
        -- The GUI
        gui = sm.gui.createGuiFromLayout(sc.layoutFiles.Register, nil, { backgroundAlpha = 0.5 }),
        -- The text from user input
        text = "",
        -- The name of the register
        registerName = ""
    }

    -- Set the title of the gui to be "Reader Name"
    self.cl.gui:setText("Title", "Reader Name")

    -- Add callbacks
    self.cl.gui:setTextChangedCallback("Input", "cl_onTextChanged")
    self.cl.gui:setButtonCallback("Button", "cl_onSave")
end

function Reader:cl_setReaderName(name)
    -- Set the client-side registername to be the name from the argument above
    self.cl.registerName = name
end

function Reader:client_onInteract(_, state)
    -- CIf state is not true, return nothing
    if not state then return end

    -- Set the input and open the GUI
    self.cl.gui:setText("Input", self.cl.registerName)
    self.cl.text = self.cl.registerName
    self.cl.gui:open()
end

function Reader:cl_onTextChanged(_, text)
    -- Update the text from the old one with the new
    self.cl.text = text
end

function Reader:cl_onSave()
    -- Update the server with the new name
    self.network:sendToServer("sv_setReaderName", self.cl.text)

    -- Update registerName to be the new one and clear the self.cl.text
    self.cl.registerName = self.cl.text
    self.cl.text = ""

    -- Close the GUI
    self.cl.gui:close()
end

-- Convert the class to a component
dofile("$CONTENT_DATA/Scripts/ComponentManager.lua")
sc.componentManager.ToComponent(Reader, "", false)