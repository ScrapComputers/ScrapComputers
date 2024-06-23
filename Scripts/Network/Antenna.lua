dofile("$CONTENT_DATA/Scripts/Config.lua")

---@class ObjectTemplate : ShapeClass
Antenna = class()
Antenna.maxParentCount = 1
Antenna.maxChildCount = 0
Antenna.connectionInput = sm.interactable.connectionType.networkingIO
Antenna.connectionOutput = sm.interactable.connectionType.none
Antenna.colorNormal = sm.color.new(0x1dded1ff)
Antenna.colorHighlight = sm.color.new(0x0cdff2ff)

-- SERVER --

function Antenna:sv_createData()
    return {
        -- Gets the name of the antenna
        getName = function ()
            return self.sv.saved.name
        end,

        -- Sets the name of the antenna
        setName = function (name)
            -- Check if the name variable is a string. else error it.
            assert(type(name) == "string", "Expected string, got "..type(name).." instead!")

            -- Update the current name with the new one and save it.
            self.sv.saved.name = name
            self.storage:save(self.sv.saved)

            -- Update the client's name's to match with the server one.
            self.sv.updateClientsComputer = true
        end,

        -- Returns true if theres a connection with another antenna.
        hasConnection = function ()
            -- Loop through the network interfaces
            ---@param antenna ShapeClass
            for _, antenna in pairs(sm.scrapcomputers.dataList["NetworkInterfaces"]) do
                -- Check if its a antenna and not the same antenna as the script running
                if antenna.sv.isAntenna and antenna.interactable:getId() ~= self.interactable:getId() then
                    -- Check if the antenna that its looking at has the same name as this antenna's name
                    if antenna.sv.saved.name == self.sv.saved.name then
                        -- Return true since there is a connection
                        return true
                    end
                end
            end

            -- Since there is no anntena's that can comminucate between this one. return false
            return false
        end,

        -- Scan for all antennas and return them
        scanAntennas = function ()
            -- Contains all antenna's
            local names = {}
            
            -- Loop through the network interfaces
            ---@param antenna ShapeClass
            for _, antenna in pairs(sm.scrapcomputers.dataList["NetworkInterfaces"]) do
                -- Check if its a antenna and not the same antenna as the script running
                if antenna.sv.isAntenna and antenna.interactable:getId() ~= self.interactable:getId() then
                    table.insert(names, antenna.sv.saved.name)
                end
            end

            return names
        end
    }
end

function Antenna:server_onFixedUpdate()
    -- Check if it has to update the client names
    if self.sv.updateClientsComputer == true then
        -- Since it is, Update it and set it back to false
        self:server_updateClientName()
        self.sv.updateClientsComputer = false
    end
end

function Antenna:server_onCreate()
    -- Create server side variables
    self.sv = {
        -- Used to store the name in the interactable
        saved = self.storage:load(),
        -- Constant variable, If its true, then its a antenna, else a network port.
        isAntenna = true,
    }

    -- Check if theres no saved data.
    if not self.sv.saved then
        -- Update the saved data.
        self.sv.saved = {
            -- Name is a random number between 0 up to 100
            name = sm.scrapcomputers.toString(math.random(0,100))
        }

        -- Save it.
        self.storage:save(self.sv.saved)
    end

    -- Add api to the dataList
    sm.scrapcomputers.dataList["NetworkInterfaces"][self.interactable:getId()] = self
end

function Antenna:server_onDestroy()
    -- Remove api from the dataList
    sm.scrapcomputers.dataList["NetworkInterfaces"][self.interactable:getId()] = nil
end

function Antenna:server_setName(name)
    -- Update name and save it
    self.sv.saved.name = name
    self.storage:save(self.sv.saved)

    -- Update all client's names to match with the server one's.
    self:server_updateClientName()
end

function Antenna:server_updateClientName()
    -- Send message to all clients to update the name
    self.network:sendToClients("client_setName", self.sv.saved.name)
end


-- SERVER API (NOT FOR COMPUTER!) --
function Antenna:server_sendActualPacket(data)
    -- Get connected Network Interface.
    local networkPort = sm.scrapcomputers.table.getItemAt(sm.scrapcomputers.components.getComponents(sm.scrapcomputers.filters.dataType.NetworkInterfaces, self.interactable, false, sm.interactable.connectionType.networkingIO, true), 1)
    
    -- Send a packet to it.
    networkPort:server_sendPacket(data)
end

function Antenna:server_sendPacket(data)
    -- Loop through the network interfaces
    ---@param antenna ShapeClass
    for _, antenna in pairs(sm.scrapcomputers.dataList["NetworkInterfaces"]) do
        -- Check if its a antenna and not the same antenna as the script running
        if antenna.sv.isAntenna == true and antenna.interactable:getId() ~= self.interactable:getId() then
            -- Check if the antenna that its looking at has the same name as this antenna's name
            if antenna.sv.saved.name == self.sv.saved.name then
                -- Send the actual packet to that antenna
                antenna:server_sendActualPacket(data)
            end
        end
    end
end

-- CLIENT --

function Antenna:client_onCreate()
    -- Create Client side only variables
    self.cl = {
        -- The main GUI
        ---@type GuiInterface?
        gui = nil,

        -- The saved name
        name = "",

        -- The new unsaved name
        newName = "",

        -- The old name
        oldName = ""
    }
end

function Antenna:client_onInteract(character, state)
    -- If state is not true, return nothing
    if not state then return end

    -- Send message to server to keep the clients updated.
    self.network:sendToServer("server_updateClientName")

    -- Create the GUI
    self.cl.gui = sm.gui.createGuiFromLayout(sm.scrapcomputers.layoutFiles.Register, true, { backgroundAlpha = 0.5 })
    self.cl.gui:setText("Title", "Antenna") -- Update the title to be "Antenna"
    self.cl.gui:setText("Input", self.cl.name) -- Update the Input to be the self.cl.name

    -- Add callbacks
    self.cl.gui:setTextChangedCallback("Input", "client_onTextChanged")
    self.cl.gui:setButtonCallback("Button", "client_onAccepted")

    -- Open the GUI.
    self.cl.gui:open()
end

function Antenna:client_onFixedUpdate()
    -- Check if the current name doesn't match with the old name.
    if self.cl.name ~= self.cl.oldName then
        -- Update old name to be the current one.
        self.cl.oldName = self.cl.name

        -- Check if the gui exists. If so then update it's input to be latest
        if sm.exists(self.cl.gui) then
            self.cl.gui:setText("Input", self.cl.name)
        end
    end
end

function Antenna:client_onTextChanged(widget, text)
    -- Update newName to be the new text. And also replace # with ## so it dosent format color
    self.cl.newName = text:gsub("#", "##")
end

function Antenna:client_onAccepted()
    -- Check if GUI exists. If so then close it.
    if sm.exists(self.cl.gui) then
        self.cl.gui:close()
    end

    -- Send message to server to update it's name
    self.network:sendToServer("server_setName", self.cl.newName)

    -- set the new name to be empty
    self.cl.newName = ""
end

function Antenna:client_setName(name)
    -- Update client side name to be the new one from argument.
    self.cl.name = name
end

-- Convert the class to a component
sm.scrapcomputers.components.ToComponent(Antenna, "Antennas", true)