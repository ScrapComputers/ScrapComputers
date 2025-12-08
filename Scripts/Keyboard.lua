---@class KeyboardClass : ShapeClass
KeyboardClass = class()
KeyboardClass.maxParentCount = 2
KeyboardClass.maxChildCount = 0
KeyboardClass.connectionInput = sm.interactable.connectionType.compositeIO + sm.interactable.connectionType.seated
KeyboardClass.connectionOutput = sm.interactable.connectionType.none
KeyboardClass.colorNormal = sm.color.new(0xaa00aaff)
KeyboardClass.colorHighlight = sm.color.new(0xff00ffff)

-- SERVER --

function KeyboardClass:sv_createData()
    return {
        ---Gets the latest keystroke
        ---@return string keystroke The keystroke
        getLatestKeystroke = function()
            return self.sv.latestKeystroke
        end,

        ---Returns true if its pressed a key
        ---@return boolean isPressing If its pressed a key
        isPressed = function()
            return self.sv.isPressed
        end
}
end

function KeyboardClass:server_onCreate()
    self.sv = {
        isPressed = false,
        latestKeystroke = ""
    }
end

---Sets the latest keystroke
---@param key string the keystroke
function KeyboardClass:sv_setLatestKeystroke(key)
    self.sv.latestKeystroke = key
end

---Sets it if its pressed
---@param bool boolean If its pressed or not.
function KeyboardClass:sv_setPressed(bool)
    self.sv.isPressed = bool
end

-- CLIENT --

function KeyboardClass:client_onCreate()
    self.cl = {
        gui = nil
    }

    self.cl.gui = sm.scrapcomputers.gui:createGuiFromLayout("$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Gui/Layout/Keyboard.layout")
    self.cl.gui:setTextChangedCallback("TextBox", "cl_onKeystroke")
    self.cl.gui:setTextRaw("TextBox", "0")
    self.cl.gui:setButtonCallback("Exit", "cl_onExit")

    sm.scrapcomputers.powerManager.updatePowerInstance(self.shape.id, 0.1)
end

function KeyboardClass:client_onUpdate()
    if self.cl.gui:isActive() then
        self.cl.gui:setFocus("TextBox")
    end
end

function KeyboardClass:client_onFixedUpdate()
    if self.cl.pressTimer and self.cl.pressTimer + 1 < sm.game.getCurrentTick() then
        self.cl.pressTimer = nil

        self.network:sendToServer("sv_setPressed", false)
    end
end

function KeyboardClass:client_canInteract()
    if self.shape.usable then
        -- sm.gui.setInteractionText sucks. They can suck my sweaty balls.
        local translatableText = sm.scrapcomputers.languageManager.translatable("scrapcomputers.keyboard.press_to_type_text", "[TEXT_SPLIT]")
        local firstPart, secondPart = translatableText:match("^(.-)%[TEXT_SPLIT%](.*)$")

        sm.gui.setInteractionText(firstPart, sm.gui.getKeyBinding("Use", true), secondPart)
        sm.gui.setInteractionText("")
    end
    
    return self.shape.usable
end

function KeyboardClass:client_onInteract(char, state)
    if not state then return end

    self.cl.gui:setText("Exit", "scrapcomputers.keyboard.exit")
    self.cl.gui:open()
end

function KeyboardClass:client_getAvailableParentConnectionCount(flags)
    return 1 - #self.interactable:getParents(flags)
end

function KeyboardClass:cl_onKeystroke(_, text)
    if #text == 1 then return end
    local keystroke = (#text == 0 and "backSpace" or sm.scrapcomputers.utf8.getCharacterAt(text, 2))
    self.cl.pressTimer = sm.game.getCurrentTick()

    self.cl.gui:setTextRaw("TextBox", "0")

    self.network:sendToServer("sv_setLatestKeystroke", keystroke)
    self.network:sendToServer("sv_setPressed", true)
end

function KeyboardClass:cl_onExit()
    self.cl.gui:close()
end

sm.scrapcomputers.componentManager.toComponent(KeyboardClass, "Keyboards", true, nil, true)