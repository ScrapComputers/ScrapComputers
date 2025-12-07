local laser = sc.getLasers()[1]
local distance = 100 -- Distance that the laser can detect (in meters, 1m = 4 blocks)

function onLoad()
	laser.setDistance(distance)
end

function onUpdate()
	local hit, result = laser.getLaserData()

	if hit then
		local roundedDistance = math.floor(result.fraction * distance)
	
		print("Hit! Distance is "..roundedDistance.. " Meter(s)")
	end
end