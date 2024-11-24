---@class ReaderClass : ShapeClass
InputRegisterClass = class()
InputRegisterClass.maxParentCount = 1
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
end

function InputRegisterClass:server_onFixedUpdate()
    local parent = self.interactable:getSingleParent()

    if parent then
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
    end
end

function InputRegisterClass:sv_setName(name)
    sm.scrapcomputers.dataList["InputRegisters"][self.shape.id].name = name

    self.storage:save(name)
end

-- CLIENT --

function InputRegisterClass:client_onCreate()
    self.cl = {
        gui = nil,
        text = "",
        registerName = "",
        character = nil
    }

    self.cl.gui = sm.gui.createGuiFromLayout(sm.scrapcomputers.layoutFiles.Register, false, {backgroundAlpha = 0.5})
    self.cl.gui:setText("Title", sm.scrapcomputers.languageManager.translatable("scrapcomputers.registers.input_title"))
    self.cl.gui:setText("Button", sm.scrapcomputers.languageManager.translatable("scrapcomputers.other.save_and_closebtn"))

    self.cl.gui:setTextChangedCallback("Input", "cl_onTextChanged")
    self.cl.gui:setButtonCallback ("Button", "cl_onSave")

    self.cl.gui:setOnCloseCallback("cl_onGuiClose")
end

function InputRegisterClass:cl_onGuiClose()
    if self.cl.character then
        sm.effect.playHostedEffect("ScrapComputers - event:/ui/menu_close", self.cl.character)
    end
end

function InputRegisterClass:cl_setName(name)
    self.cl.registerName = name
end

function InputRegisterClass:client_onInteract(character, state)
    if not state then return end

    self.cl.gui:setText("Input", self.cl.registerName)
    self.cl.text = self.cl.registerName

    self.cl.gui:open()

    sm.effect.playHostedEffect("ScrapComputers - event:/ui/menu_open", character)
    self.cl.character = character
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

-- Convert the class to a component
sm.scrapcomputers.componentManager.toComponent(InputRegisterClass, "InputRegisters", true)