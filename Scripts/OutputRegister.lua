---@class WriterClass : ShapeClass
OutputRegisterClass = class()
OutputRegisterClass.maxParentCount = 1
OutputRegisterClass.maxChildCount = -1
OutputRegisterClass.connectionInput = sm.interactable.connectionType.compositeIO
OutputRegisterClass.connectionOutput = sm.interactable.connectionType.logic + sm.interactable.connectionType.power
OutputRegisterClass.colorNormal = sm.color.new(0xaa0000ff)
OutputRegisterClass.colorHighlight = sm.color.new(0xee0000ff)

-- SERVER --

-- Computer API* Data
function OutputRegisterClass:sv_createData()
    return {
        name = self.storage:load() or "",
        power = 0,
        SC_PRIVATE_interactable = self.interactable
}
end

function OutputRegisterClass:server_onCreate()
    self.sv = {
        power = 0,
        lastPower = 0
    }

    local name = sm.scrapcomputers.dataList["OutputRegisters"][self.shape.id].name
    self.network:sendToClients("cl_setName", name)
end

function OutputRegisterClass:sv_setName(name)
    sm.scrapcomputers.dataList["OutputRegisters"][self.shape.id].name = name
    self.storage:save(name)
end

function OutputRegisterClass:sv_onRecievePowerUpdate(power)
    if self.cl.lastPower ~= power then
        self.cl.lastPower = power

        sm.scrapcomputers.dataList["OutputRegisters"][self.shape.id].power = power

        self.interactable.power = power
        self.interactable.active = power > 0
    end
end

-- CLIENT --

function OutputRegisterClass:client_onCreate()
    self.cl = {
        gui = nil,
        userInput = "",
        registerName = ""
    }

    self.cl.gui = sm.gui.createGuiFromLayout(sm.scrapcomputers.layoutFiles.Register, false, {backgroundAlpha = 0.5})
    self.cl.gui:setText("Title", "Output Register's Name")

    self.cl.gui:setTextChangedCallback("Input", "cl_onTextChanged")
    self.cl.gui:setButtonCallback ("Button", "cl_onSave")
end

function OutputRegisterClass:cl_setName(name)
    self.cl.registerName = name
end

function OutputRegisterClass:client_onInteract(character, state)
    if not state then return end

    self.cl.gui:setText("Input", self.cl.registerName)
    self.cl.userInput = self.cl.registerName

    self.cl.gui:open()
end

function OutputRegisterClass:cl_onTextChanged(widget, newText)
    self.cl.userInput = newText
end

function OutputRegisterClass:cl_onSave()
    self.cl.registerName = self.cl.userInput
    self.network:sendToServer("sv_setName", self.cl.userInput)

    self.cl.gui:close()
end

sm.scrapcomputers.componentManager.toComponent(OutputRegisterClass, "OutputRegisters", true)