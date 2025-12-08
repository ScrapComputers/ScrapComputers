---@class AntennaClass : ShapeClass
AntennaClass = class()
AntennaClass.maxParentCount = 1
AntennaClass.maxChildCount = 0
AntennaClass.connectionInput = sm.interactable.connectionType.networkingIO
AntennaClass.connectionOutput = sm.interactable.connectionType.none
AntennaClass.colorNormal = sm.color.new(0x1dded1ff)
AntennaClass.colorHighlight = sm.color.new(0x0cdff2ff)

local isSurvival = sm.scrapcomputers.gamemodeManager.isSurvival() or sm.scrapcomputers.config.getConfig("scrapcomputers.global.survivalBehavior").selectedOption == 2
local maxRange = 2000

local function isWithinRange(shapeA, shapeB)
    return (shapeA.worldPosition - shapeB.worldPosition):length() < maxRange
end

-- SERVER --

function AntennaClass:sv_createData()
    return {
        -- Gets the name of the antenna
        ---@return string name The antenna's name.
        getName = function ()
            return self.sv.saved.name
        end,

        -- Sets the name of the antenna
        ---@param name string The new name of the antenna
        setName = function (name)
            assert(type(name) == "string", "Expected string, got "..type(name).." instead!")

            self.sv.saved.name = name
            self.storage:save(self.sv.saved)

            self.sv.updateClientsComputer = true
        end,

        -- Returns true if theres a connection with another antenna.
        ---@return boolean hasConnection If it has a connection or not
        hasConnection = function ()
            ---@param antenna ShapeClass
            for _, antenna in pairs(sm.scrapcomputers.dataList["NetworkInterfaces"]) do
                if antenna.sv.isAntenna and antenna.shape.id ~= self.shape.id then
                    if antenna.sv.saved.name == self.sv.saved.name then
                        return true
                    end
                end
            end

            return false
        end,

        ---Scans for all antennas and returns all of there names
        ---@return string[] antennaNames All discovered antenna's names.
        scanAntennas = function ()
            local names = {}
            
            ---@param antenna ShapeClass
            for _, antenna in pairs(sm.scrapcomputers.dataList["NetworkInterfaces"]) do
                if antenna.sv.isAntenna and antenna.shape.id ~= self.shape.id and (not isSurvival or (isSurvival and isWithinRange(self.shape, antenna.shape))) then
                    table.insert(names, antenna.sv.saved.name)
                end
            end

            return names
        end
}
end

function AntennaClass:server_onFixedUpdate()
    if self.sv.updateClientsComputer == true then
        self:server_updateClientName()
        self.sv.updateClientsComputer = false
    end
end

function AntennaClass:server_onCreate()
    self.sv = {
        saved = self.storage:load(),
        isAntenna = true,
    }

    if not self.sv.saved then
        self.sv.saved = { name = sm.scrapcomputers.toString(math.random(0,100)) }
        self.storage:save(self.sv.saved)
    end

    sm.scrapcomputers.dataList["NetworkInterfaces"][self.shape.id] = self
end

function AntennaClass:server_onDestroy()
    sm.scrapcomputers.dataList["NetworkInterfaces"][self.shape.id] = nil
end

function AntennaClass:server_setName(name)
    self.sv.saved.name = name
    self.storage:save(self.sv.saved)

    self:server_updateClientName()
end

function AntennaClass:server_updateClientName()
    self.network:sendToClients("client_setName", self.sv.saved.name)
end

-- SERVER API (NOT FOR COMPUTER!) --

function AntennaClass:server_sendActualPacket(data)
    local networkPort = sm.scrapcomputers.table.getItemAt(sm.scrapcomputers.componentManager.getComponents("NetworkInterfaces", self.interactable, false, sm.interactable.connectionType.networkingIO, true), 1)
    if networkPort then
        networkPort:server_sendPacket(data)
    end
end

function AntennaClass:server_sendPacket(data)
    ---@param antenna ShapeClass
    for _, antenna in pairs(sm.scrapcomputers.dataList["NetworkInterfaces"]) do
        if antenna.sv.isAntenna == true and antenna.shape.id ~= self.shape.id then
            if antenna.sv.saved.name == self.sv.saved.name and (not isSurvival or (isSurvival and isWithinRange(self.shape, antenna.shape))) then
                antenna:server_sendActualPacket(data)
            end
        end
    end
end

-- CLIENT --

function AntennaClass:client_onCreate()
    self.cl = {
        gui = nil, ---@type GuiInterface?
        name = "",
        newName = "",
        oldName = "",
        character = nil
    }
end

function AntennaClass:client_onInteract(character, state)
    if not state then return end
    
    self.network:sendToServer("server_updateClientName")
    
    self.cl.gui = sm.scrapcomputers.gui:createGuiFromLayout("$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Gui/Layout/Antenna.layout", true)
    self.cl.gui:setText("MainHeaderText", sm.scrapcomputers.languageManager.translatable("scrapcomputers.antenna.title"))
    self.cl.gui:setText("Button", sm.scrapcomputers.languageManager.translatable("scrapcomputers.other.save_and_closebtn"))
    
    self.cl.gui:setTextRaw("Input", self.cl.name)
    
    self.cl.gui:setTextChangedCallback("Input", "client_onTextChanged")
    self.cl.gui:setButtonCallback("Button", "client_onAccepted")
    
    self.cl.gui:setOnCloseCallback("cl_onGuiClose")
    
    self.cl.gui:open()
end

function AntennaClass:client_onFixedUpdate()
    if self.cl.name ~= self.cl.oldName then
        self.cl.oldName = self.cl.name
        
        if self.cl.gui then
            self.cl.gui:setTextRaw("Input", self.cl.name)
        end
    end
end

function AntennaClass:client_onTextChanged(widget, text)
    self.cl.newName = text:gsub("#", "##")
end

function AntennaClass:client_onAccepted()
    if self.cl.gui then
        self.cl.gui:close()
    end
    
    self.network:sendToServer("server_setName", self.cl.newName)
    self.cl.newName = ""
end

function AntennaClass:client_setName(name)
    self.cl.name = name
    self.cl.newName = name
end

-- Convert the class to a component
sm.scrapcomputers.componentManager.toComponent(AntennaClass, "Antennas", true)