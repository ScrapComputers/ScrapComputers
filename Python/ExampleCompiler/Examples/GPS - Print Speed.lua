local gps  = sc.getGPSs()[1]

function onUpdate()
	local data = gps.getGPSData()

	print("Current Speed: " .. math.floor(data.speed) .. " m/s")
end
