---@class NetworkPortClass : ShapeClass
NetworkPortClass = class()
NetworkPortClass.maxParentCount = 2
NetworkPortClass.maxChildCount = 1
NetworkPortClass.connectionInput = sm.interactable.connectionType.compositeIO + sm.interactable.connectionType.networkingIO
NetworkPortClass.connectionOutput = sm.interactable.connectionType.networkingIO
NetworkPortClass.colorNormal = sm.color.new(0x0c64f2ff)
NetworkPortClass.colorHighlight = sm.color.new(0x0586ffff)

-- SERVER --

function NetworkPortClass:sv_createData()
    return {
        -- Gets the connected antenna
        ---@return Antenna? antenna The connected antenna, if connected.
        getAntenna = function () return sm.scrapcomputers.table.getItemAt(sm.scrapcomputers.componentManager.getComponents("Antennas", self.interactable, true, sm.interactable.connectionType.networkingIO, true), 1) end,

        -- Returns true if theres a connection.
        ---@return boolean hasConnection If it has a connection or not.
        hasConnection = function () return (#self.interactable:getChildren(sm.interactable.connectionType.networkingIO) > 0 or #self.interactable:getParents(sm.interactable.connectionType.networkingIO) > 0)  end,

        -- Sends a packet to the connected Antenna or Network Port
        ---@param data any The data to send
        sendPacket = function (data)
            local parentInterfaces = sm.scrapcomputers.componentManager.getComponents("NetworkInterfaces", self.interactable, false, sm.interactable.connectionType.networkingIO, true)
            local childInterfaces = sm.scrapcomputers.componentManager.getComponents ("NetworkInterfaces", self.interactable, true, sm.interactable.connectionType.networkingIO, true)

            ---@type ShapeClass
            local obj = sm.scrapcomputers.table.getItemAt(parentInterfaces, 1) or sm.scrapcomputers.table.getItemAt(childInterfaces, 1)

            sm.scrapcomputers.errorHandler.assert(obj, nil, "No connection found!")

            obj:server_sendPacket(data)
        end,

        -- Sends a packet to a specified antenna. Antenna needs to be connected
        ---@param name string The antenna to send to.
        ---@param data any The data to send
        sendPacketToAntenna = function(name, data)
            sm.scrapcomputers.errorHandler.assertArgument(name, 1, {"string"})
            sm.scrapcomputers.errorHandler.assert(not (#sm.scrapcomputers.componentManager.getComponents("Antennas", self.interactable, true, sm.interactable.connectionType.networkingIO) == 0), nil, "No antenna connected!")

            ---@param antenna ShapeClass
            for _, antenna in pairs(sm.scrapcomputers.dataList["NetworkInterfaces"]) do
                if antenna.sv.isAntenna and antenna.shape.id ~= self.shape.id then
                    if antenna.sv.saved.name == name then
                        antenna:server_sendActualPacket(data)
                        return
                    end
                end
            end

            error("Antenna not found!")
        end,

        -- Gets the total packets.
        ---@return integer packets Total unreaded packets
        getTotalPackets = function () return #self.sv.packets end,

        -- Reads a packet
        ---@return any The data that it has read.
        receivePacket = function ()
            sm.scrapcomputers.errorHandler.assert(#self.sv.packets > 0, nil, "Cant receive packet! (None left!)")

            return self:server_readPacket()
        end,

        -- Clears the packets.
        clearPackets = function () self.sv.packets = {} end
}
end

function NetworkPortClass:server_onCreate()
    self.sv = {
        packets = {},
        isAntenna = false,
    }

    sm.scrapcomputers.dataList["NetworkInterfaces"][self.shape.id] = self
end

function NetworkPortClass:server_onDestroy()
    sm.scrapcomputers.dataList["NetworkInterfaces"][self.shape.id] = nil
end

-- SERVER API (NOT FOR COMPTUER) --

function NetworkPortClass:server_readPacket()
    return table.remove(self.sv.packets, 1)
end

function NetworkPortClass:server_sendPacket(data)
    table.insert(self.sv.packets, type(data) == "table" and sm.scrapcomputers.table.clone({data}) or data)
end

-- CLIENT --

function NetworkPortClass:client_getAvailableParentConnectionCount(connectionType)
	if bit.band(connectionType, sm.interactable.connectionType.compositeIO) ~= 0 then
		return 1 - #self.interactable:getParents(sm.interactable.connectionType.compositeIO)
	end

	return 1 - (#self.interactable:getChildren() + #self.interactable:getParents(sm.interactable.connectionType.networkingIO))
end

function NetworkPortClass:client_getAvailableChildConnectionCount()
	return 1 - (#self.interactable:getChildren() + #self.interactable:getParents(sm.interactable.connectionType.networkingIO))
end

-- Convert the class to a component
sm.scrapcomputers.componentManager.toComponent(NetworkPortClass, "NetworkPorts", true)