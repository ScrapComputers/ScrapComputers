local radar = sc.getRadars()[1]
assert(radar, "Radar not found! Make sure you have connected a Radar to the computer!")

local vAngle = 35 -- The vertical angle
local hAngle = 35 -- The horizontal angle

function onLoad()
	radar.setVerticalScanAngle(vAngle)
	radar.setHorizontalScanAngle(hAngle)
end

function onUpdate()
	local targets = radar.getTargets()
	print("Total Targets: " .. tostring(#targets))
	
	for _, target in pairs(targets) do
		local roundedPosition = sm.vec3.new(
			math.floor(target.position.x),
			math.floor(target.position.y),
			math.floor(target.position.z)
		)

		print(tostring(roundedPosition) .. " | " .. tostring(target.surfaceArea))
	end
end