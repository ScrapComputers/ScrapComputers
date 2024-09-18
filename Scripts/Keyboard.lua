---@class KeyboardClass : ShapeClass
KeyboardClass = class()
KeyboardClass.maxParentCount = 2
KeyboardClass.maxChildCount = 0
KeyboardClass.connectionInput = sm.interactable.connectionType.compositeIO + sm.interactable.connectionType.seated
KeyboardClass.connectionOutput = sm.interactable.connectionType.none
KeyboardClass.colorNormal = sm.color.new(0xaa00aaff)
KeyboardClass.colorHighlight = sm.color.new(0xff00ffff)

-- CLIENT / SERVER --

---@param str string The character
---@param index integer The index to get it at
---@return string character The UTF8 character
function getUTF8Character(str, index)
    local byte = string.byte(str, index)
    local byteCount = 1 -- The byte count

    if byte >= 0xC0 and byte <= 0xDF then
        byteCount = 2
    elseif byte >= 0xE0 and byte <= 0xEF then
        byteCount = 3
    elseif byte >= 0xF0 and byte <= 0xF7 then
        byteCount = 4
    end

    return string.sub(str, index, index + byteCount - 1)
end

local interactionStr = "<p textShadow='true' bg='' color='#ffffff' spacing='5'>Press" .. sm.gui.getKeyBinding("Use", true) .. "to start typing</p>"

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

    self.cl.gui = sm.gui.createGuiFromLayout(sm.scrapcomputers.layoutFiles.Keyboard)
    self.cl.gui:setTextChangedCallback("TextBox", "cl_onKeystroke")
    self.cl.gui:setText ("TextBox", "0")

    self.cl.gui:setButtonCallback("Exit", "cl_onExit")
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
    sm.gui.setInteractionText("", interactionStr, "")
    sm.gui.setInteractionText("")
    return true
end

function KeyboardClass:client_onInteract(char, state)
    if not state then return end

    self.cl.gui:open()
end

function KeyboardClass:client_getAvailableParentConnectionCount(flags)
    return 1 - #self.interactable:getParents(flags)
end

function KeyboardClass:cl_onKeystroke(_, text)
    if #text == 1 then return end
    local keystroke = (#text == 0 and "backSpace" or getUTF8Character(text, 2))
    self.cl.pressTimer = sm.game.getCurrentTick()

    self.cl.gui:setText("TextBox", "0")

    self.network:sendToServer("sv_setLatestKeystroke", keystroke)
    self.network:sendToServer("sv_setPressed", true)
end

function KeyboardClass:cl_onExit()
    self.cl.gui:close()
end

sm.scrapcomputers.componentManager.toComponent(KeyboardClass, "Keyboards", true)