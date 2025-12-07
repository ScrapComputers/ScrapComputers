---@class ReaderClass : ShapeClass
InputRegisterClass = class()
InputRegisterClass.maxParentCount = -1
InputRegisterClass.maxChildCount = -1
InputRegisterClass.connectionOutput = sm.interactable.connectionType.compositeIO
InputRegisterClass.connectionInput = sm.interactable.connectionType.logic + sm.interactable.connectionType.power
InputRegisterClass.colorNormal = sm.color.new(0x00aa00ff)
InputRegisterClass.colorHighlight = sm.color.new(0x00ee00ff)

-- SERVER --

function InputRegisterClass:sv_createData()
    return {
        name = self.storage:load() or "",
        power = 0,
    }
end

function InputRegisterClass:server_onCreate()
    self.sv = {
        power = 0,
        lastPower = 0,
    }

    local name = sm.scrapcomputers.dataList["InputRegisters"][self.shape.id].name
    self.network:sendToClients("cl_setName", name)

    sm.scrapcomputers.powerManager.updatePowerInstance(self.shape.id, 0.1)
end

function InputRegisterClass:server_onFixedUpdate()
    local parents = self.interactable:getParents()

    if parents then
        for _, parent in ipairs(parents) do
            local power = parent.power

            if parent.type == "button" or parent.type == "lever" then
                power = parent.active and 1 or 0
            end

            if self.sv.lastPower ~= power then
                self.sv.lastPower = power

                sm.scrapcomputers.dataList["InputRegisters"][self.shape.id].power = power

                -- Update the interactable's power and active state
                self.interactable.power = power
                self.interactable.active = power > 0
            end

            if power > 0 then
                break
            end
        end
    end
end

function InputRegisterClass:sv_onPowerLoss()
    self.sv.lastPower = 0

    self.interactable.power = 0
    self.interactable.active = false
end

function InputRegisterClass:sv_setName(name, player)
    sm.scrapcomputers.dataList["InputRegisters"][self.shape.id].name = name
    self.storage:save(name)

	-- How the fuck did we forgot to do mulitplayer testing on fucking registers?
	
	for _, plr in pairs(sm.player.getAllPlayers()) do
		if plr.id ~= player.id then
			self.network:sendToClient(plr, "cl_setName", name)
		end
	end
end

-- CLIENT --

function InputRegisterClass:client_onCreate()
    self.cl = {
        gui = nil,
        text = "",
        registerName = "",
        character = nil
    }

    self.cl.gui = sm.scrapcomputers.gui:createGuiFromLayout("$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Gui/Layout/Register.layout", false)
    
    self.cl.gui:setTextChangedCallback("Input", "cl_onTextChanged")
    self.cl.gui:setButtonCallback("Button", "cl_onSave")

    self.cl.gui:setOnCloseCallback("cl_onGuiClose")
end

function InputRegisterClass:cl_setName(name)
    self.cl.registerName = name
	self.cl.gui:setTextRaw("Input", self.cl.registerName)
end

function InputRegisterClass:client_onInteract(character, state)
    if not state then return end

    self:cl_reloadTranslations()

    self.cl.gui:setTextRaw("Input", self.cl.registerName)
    self.cl.text = self.cl.registerName

    self.cl.gui:open()
end

function InputRegisterClass:cl_onTextChanged(widget, text)
    self.cl.text = text
end

function InputRegisterClass:cl_onSave()
    self.network:sendToServer("sv_setName", self.cl.text)

    self.cl.registerName = self.cl.text
    self.cl.text = ""

    self.cl.gui:close()
end

function InputRegisterClass:cl_reloadTranslations()
    self.cl.gui:setText("MainHeaderText", "scrapcomputers.registers.input_title")
    self.cl.gui:setText("Button", "scrapcomputers.other.save_and_closebtn")
end

sm.scrapcomputers.componentManager.toComponent(InputRegisterClass, "InputRegisters", true, nil, true)
