---@class WriterClass : ShapeClass
OutputRegisterClass = class()
OutputRegisterClass.maxParentCount = -1
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

        -- The only time SC_PRIVATE was used.
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

    sm.scrapcomputers.powerManager.updatePowerInstance(self.shape.id, 0.1)
end

function OutputRegisterClass:sv_setName(name, player)
    sm.scrapcomputers.dataList["OutputRegisters"][self.shape.id].name = name
    self.storage:save(name)

	-- How the fuck did we forget to do mulitplayer testing on fucking registers?
	
	for _, plr in pairs(sm.player.getAllPlayers()) do
		if plr.id ~= player.id then
			self.network:sendToClient(plr, "cl_setName", name)
		end
	end
end

function OutputRegisterClass:sv_onReceivePowerUpdate(power)
    if self.sv.lastPower ~= power then
        self.sv.lastPower = power

        sm.scrapcomputers.dataList["OutputRegisters"][self.shape.id].power = power

        self.interactable.power = power
        self.interactable.active = power > 0
    end
end

function OutputRegisterClass:sv_onPowerLoss()
    self.sv.lastPower = 0

    self.interactable.power = 0
    self.interactable.active = false
end

-- CLIENT --

function OutputRegisterClass:client_onCreate()
    self.cl = {
        gui = nil,
        userInput = "",
        registerName = "",
        character = nil
    }

    self.cl.gui = sm.scrapcomputers.gui:createGuiFromLayout("$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Gui/Layout/Register.layout", false)
    self.cl.gui:setTextChangedCallback("Input", "cl_onTextChanged")
    self.cl.gui:setButtonCallback("Button", "cl_onSave")
    self.cl.gui:setOnCloseCallback("cl_onGuiClose")
end

function OutputRegisterClass:cl_setName(name)
    self.cl.registerName = name
	self.cl.gui:setTextRaw("Input", self.cl.registerName)
end

function OutputRegisterClass:client_onInteract(character, state)
    if not state then return end

    self:cl_reloadTranslations()

    self.cl.gui:setTextRaw("Input", self.cl.registerName)
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

function OutputRegisterClass:cl_reloadTranslations()
    self.cl.gui:setText("MainHeaderText", "scrapcomputers.registers.output_title")
    self.cl.gui:setText("Button", "scrapcomputers.other.save_and_closebtn")
end

sm.scrapcomputers.componentManager.toComponent(OutputRegisterClass, "OutputRegisters", true, nil, true)