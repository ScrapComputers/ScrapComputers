dofile("$CONTENT_DATA/Scripts/Config.lua")

---@class Writer : ShapeClass
Writer = class()
Writer.maxParentCount = 1
Writer.maxChildCount = -1
Writer.connectionInput = sm.interactable.connectionType.compositeIO
Writer.connectionOutput = sm.interactable.connectionType.logic + sm.interactable.connectionType.power
Writer.colorNormal = sm.color.new(0x00aa00ff)
Writer.colorHighlight = sm.color.new(0x00ff00ff)

-- SERVER --

function Writer:server_onCreate()
    -- Create the server-side variables
    self.sv = {
        power = 0,
        lastPower = 0
    }

    -- Load the storage, if nil then be a empty string
    local name = self.storage:load() or ""
    
    -- Add to datalist
    sc.dataList["Writers"][self.interactable:getId()] = {name = name, power = 0, SC_PRIVATE_id = self.interactable:getId()}
    -- Create interactable accessability for the power updating
    sc.dataList["WriterInters"][self.interactable:getId()] = self.interactable

    -- Update the clients to have the new name
    self.network:sendToClients("cl_setWriterName", name)
end

function Writer:sv_setWriterName(name)
    -- Set the writer name to be the new one and save the new data.
    sc.dataList["Writers"][self.interactable:getId()].name = name
    self.storage:save(name)
end

function Writer:sv_onRecievePowerUpdate(power)
    -- Check if the previous power isn't
    if self.cl.lastPower ~= power then
        -- Update the previous power to be the new one
        self.cl.lastPower = power

        -- Update it
        sc.dataList["Writers"][self.interactable:getId()].power = power

        -- Set the interactable power and active state to be power. For active, it will be true if power is higher than 0
        self.interactable.power = power
        self.interactable.active = power > 0
    end
end

function Writer:server_onDestroy()
    -- Remove it from datalist
    sc.dataList["Writers"][self.interactable:getId()] = nil
    sc.dataList["WriterInters"][self.interactable:getId()] = nil
end

-- Dev mode related
function Writer:server_onRefresh() self:server_onCreate() end

-- CLIENT --

function Writer:client_onCreate()
    -- Create client side variables
    self.cl = {
        -- The actual GUI
        gui = sm.gui.createGuiFromLayout(sc.layoutFiles.Register, nil, { backgroundAlpha = 0.5 }),
        -- The text used for the GUI
        text = "",
        -- The name of the register
        registerName = ""
    }

    -- Set title to be "Writer Name"
    self.cl.gui:setText("Title", "Writer Name")

    -- Add callbacks
    self.cl.gui:setTextChangedCallback("Input", "cl_onTextChanged")
    self.cl.gui:setButtonCallback("Button", "cl_onSave")
end

function Writer:cl_setWriterName(name)
    -- Set register the name with the new name argument
    self.cl.registerName = name
end

function Writer:client_onInteract(_, state)
    -- If state is not true, return nothing
    if not state then return end

    self.cl.gui:setText("Input", self.cl.registerName) -- Set the text of the input to be the register name
    self.cl.text = self.cl.registerName -- Update the text variable to be the register name

    -- Open the GUI
    self.cl.gui:open()
end

function Writer:cl_onTextChanged(_, text)
    -- Set the text to be the new text from the user
    self.cl.text = text
end

function Writer:cl_onSave()
    -- Update the writer's name to be self.cl.text
    self.network:sendToServer("sv_setWriterName", self.cl.text)

    -- Update registerName to be self.cl.text and then reset self.cl.text
    self.cl.registerName = self.cl.text
    self.cl.text = ""

    -- Close the GUI
    self.cl.gui:close()
end

-- Convert the class to a component
dofile("$CONTENT_DATA/Scripts/ComponentManager.lua")
sc.componentManager.ToComponent(Writer, "", false)