local networkPort = sc.getNetworkPorts()[1]
assert(networkPort, "Network Port not found! Make sure you have connected a Network Port to the computer!")

function onLoad()
	if not networkPort.hasConnection() then
		print("No connection found!")
		return
	end

	if networkPort.getTotalPackets() > 0 then
		local packet = networkPort.receivePacket()
		print("Received " .. tostring(packet))
	else
		print("No packets received!")
	end
end