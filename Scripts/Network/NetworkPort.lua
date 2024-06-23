dofile("$CONTENT_DATA/Scripts/Config.lua")

---@class NetworkPort : ShapeClass
NetworkPort = class()
NetworkPort.maxParentCount = 2
NetworkPort.maxChildCount = 1
NetworkPort.connectionInput = sm.interactable.connectionType.compositeIO + sm.interactable.connectionType.networkingIO
NetworkPort.connectionOutput = sm.interactable.connectionType.networkingIO
NetworkPort.colorNormal = sm.color.new(0x0c64f2ff)
NetworkPort.colorHighlight = sm.color.new(0x0586ffff)

-- SERVER --

function NetworkPort:sv_createData()
    return {
        -- Gets the connected antenna
        getAntenna = function () return sm.scrapcomputers.table.getItemAt(sm.scrapcomputers.components.getComponents(sm.scrapcomputers.filters.dataType.Antennas, self.interactable, true, sm.interactable.connectionType.networkingIO, true), 1) end,

        -- Returns true if theres a connection.
        hasConnection = function () return (#self.interactable:getChildren(sm.interactable.connectionType.networkingIO) > 0 or #self.interactable:getParents(sm.interactable.connectionType.networkingIO) > 0)  end,

        -- Sends a packet to the connected Antenna or Network Port
        sendPacket = function (data)
            -- Get Parent's Interfaces and Children's Interfaces.
            local parentInterfaces = sm.scrapcomputers.components.getComponents(sm.scrapcomputers.filters.dataType.NetworkInterfaces, self.interactable, false, sm.interactable.connectionType.networkingIO, true)
            local childInterfaces = sm.scrapcomputers.components.getComponents(sm.scrapcomputers.filters.dataType.NetworkInterfaces, self.interactable, true, sm.interactable.connectionType.networkingIO, true)

            -- Get the first element
            ---@type ShapeClass
            local obj = sm.scrapcomputers.table.getItemAt(parentInterfaces, 1) or sm.scrapcomputers.table.getItemAt(childInterfaces, 1)

            -- If its nil. Error it since there is NO connection!
            if not obj then error("No connection found!") end

            -- Send packet to that network port.
            obj:server_sendPacket(data)
        end,

        -- Sends a packet to a specified antenna.
        sendPacketToAntenna = function(name, data)
            -- Check if theres a antenna connected. else error it!
            if sm.scrapcomputers.table.getTotalItems(sm.scrapcomputers.components.getComponents(sm.scrapcomputers.filters.dataType.Antennas, self.interactable, true, sm.interactable.connectionType.networkingIO), 1, true) == 0 then
                error("No antenna connected!")
            end

            -- Loop through the network interfaces
            ---@param antenna ShapeClass
            for _, antenna in pairs(sm.scrapcomputers.dataList["NetworkInterfaces"]) do
                -- Check if its a antenna and not the same antenna as the script running
                if antenna.sv.isAntenna and antenna.interactable:getId() ~= self.interactable:getId() then
                    -- Check if they both math
                    if antenna.sv.saved.name == name then
                        -- Send it and stop further execution
                        antenna:server_sendActualPacket(data)
                        return
                    end
                end
            end

            -- Error it because we didn't find anything
            error("Antenna not found!")
        end,

        -- Gets the total packets.
        getTotalPackets = function () return #self.sv.packets end,

        -- Reads a packet
        receivePacket = function ()
            -- Check if theres any packets. if not then error it out.
            assert(#self.sv.packets > 0, "Cant receive packet! (None left!)")

            -- Return the readed packet
            return self:server_readPacket()
        end,

        -- Clears the packets.
        clearPackets = function () self.sv.packets = {} end

        -- Creates/Overwrites the messa
    }
end

function NetworkPort:server_onCreate()
    -- Create server side variables
    self.sv = {
        -- Where all packets are stored
        packets = {},
        -- Constant variable, If its true, then its a antenna, else a network port.
        isAntenna = false,
    }

    sm.scrapcomputers.dataList["NetworkInterfaces"][self.interactable.id] = self
end

function NetworkPort:server_onDestroy()
    sm.scrapcomputers.dataList["NetworkInterfaces"][self.interactable.id] = nil
end

-- SERVER API (NOT FOR COMPTUER) --
function NetworkPort:server_readPacket()
    -- Checks if theres any packets. else error it out.
    assert(#self.sv.packets > 0)

    -- Remove the first element of the packet and return its output.
    return table.remove(self.sv.packets, 1)
end

function NetworkPort:server_sendPacket(data)
    -- Adds the data to the packets list.
    table.insert(self.sv.packets, data)
end

-- CLIENT --

function NetworkPort:client_getAvailableParentConnectionCount(connectionType)
    -- Checks if the connectionType is a compositeIO's If so then return "1 - [Total compositeIO Parents]"
	if bit.band(connectionType, sm.interactable.connectionType.compositeIO) ~= 0 then
		return 1 - #self.interactable:getParents(sm.interactable.connectionType.compositeIO)
	end

    -- Return "1 - ([Total Children] + [Total Networking IO Parents])"
	return 1 - (#self.interactable:getChildren() + #self.interactable:getParents(sm.interactable.connectionType.networkingIO))
end

function NetworkPort:client_getAvailableChildConnectionCount()
    -- Return "1 - ([Total Children] + [Total Networking IO Parents])"
	return 1 - (#self.interactable:getChildren() + #self.interactable:getParents(sm.interactable.connectionType.networkingIO))
end

-- Convert the class to a component
sm.scrapcomputers.components.ToComponent(NetworkPort, "NetworkPorts", true)