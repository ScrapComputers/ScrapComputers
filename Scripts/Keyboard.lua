dofile("$CONTENT_DATA/Scripts/Config.lua")

---@class ObjectTemplate : ShapeClass
Keyboard = class()
Keyboard.maxParentCount = 2
Keyboard.maxChildCount = 0
Keyboard.connectionInput = sm.interactable.connectionType.compositeIO + sm.interactable.connectionType.seated
Keyboard.connectionOutput = sm.interactable.connectionType.none
Keyboard.colorNormal = sm.color.new(0xaa00aaff)
Keyboard.colorHighlight = sm.color.new(0xff00ffff)

-- CLIENT / SERVER --

function getUTF8Character(str, index)
    local byte = string.byte(str, index)
    local byteCount = 1

    if byte >= 0xC0 and byte <= 0xDF then
        byteCount = 2
    elseif byte >= 0xE0 and byte <= 0xEF then
        byteCount = 3
    elseif byte >= 0xF0 and byte <= 0xF7 then
        byteCount = 4
    end

    return string.sub(str, index, index + byteCount - 1)
end

local interactionStr = "<p textShadow='true' bg='' color='#ffffff' spacing='5'>Press"..sm.gui.getKeyBinding("Use", true).."to start typing</p>"

-- SERVER --

function Keyboard:sv_createData()
    return {
        getLatestKeystroke = function()
            return self.sv.latestKeystroke
        end,

        isPressed = function()
            return self.sv.isPressed
        end
    }
end

function Keyboard:server_onCreate()
    self.sv = {
        isPressed = false,
        latestKeystroke = ""
    }
end

function Keyboard:sv_setLatestKeystroke(key)
    self.sv.latestKeystroke = key
end

function Keyboard:sv_setPressed(bool)
    self.sv.isPressed = bool
end

-- CLIENT --

function Keyboard:client_onCreate()
    self.cl = {
        gui = sm.gui.createGuiFromLayout(sm.scrapcomputers.layoutFiles.Keyboard)
    }

    self.cl.gui:setTextChangedCallback("TextBox", "cl_onKeystroke")
    self.cl.gui:setText("TextBox", "0")

    self.cl.gui:setButtonCallback("Exit", "cl_onExit")
end

function Keyboard:client_onUpdate()
    if self.cl.gui:isActive() then
        self.cl.gui:setFocus("TextBox")
    end
end

function Keyboard:client_onFixedUpdate()
    if self.cl.pressTimer and self.cl.pressTimer + 1 <= sm.game.getCurrentTick() then
        self.cl.pressTimer = nil

        self.network:sendToServer("sv_setPressed", false)
    end
end

function Keyboard:client_canInteract()
    sm.gui.setInteractionText("", interactionStr, "")
    sm.gui.setInteractionText("")
    return true
end

function Keyboard:client_onInteract(char, state)
    if state then
        self.cl.gui:open()
    end
end

function Keyboard:client_getAvailableParentConnectionCount(flags)
    return 1 - #self.interactable:getParents(flags)
end

function Keyboard:cl_onKeystroke(_, text)
    if #text == 1 then
        sm.gui.displayAlertText("[#3A96DDScrap#3b78ffComputers#eeeeee]: Invalid keystroke!")    
        return
    end
    local keystroke = (#text == 0 and "backSpace" or getUTF8Character(text, 2))
    
    self.cl.pressTimer = sm.game.getCurrentTick()
            
    self.cl.gui:setText("TextBox", "0")

    self.network:sendToServer("sv_setLatestKeystroke", keystroke)
    self.network:sendToServer("sv_setPressed", true)
end

function Keyboard:cl_onExit()
    self.cl.gui:close()
end

-- Convert the class to a component
sm.scrapcomputers.components.ToComponent(Keyboard, "Keyboards", true)