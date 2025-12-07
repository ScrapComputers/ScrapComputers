local networkPort = sc.getNetworkPorts()[1]
assert(networkPort, "Network Port not found! Make sure you have connected a Network Port to the computer!")

function onLoad()
	if not networkPort.hasConnection() then
		print("No connection found!")
		return
	end

	networkPort.sendPacket("Hello World!")
	print("Sent packet!")
end