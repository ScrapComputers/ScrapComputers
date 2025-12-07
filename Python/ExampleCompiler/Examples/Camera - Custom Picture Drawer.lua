local display = sc.getDisplays()[1]
assert(display, "Display not found! Make sure you have connected a Display to the computer!")

local camera = sc.getCameras()[1]
assert(display, "Camera not found! Make sure you have connected a Camera to the computer!")

local function drawer(hit, result, x, y)
	if hit then
		return sm.color.new(1, 1, 1) * (1 - result.fraction)
	end

	return sm.color.new("000000")
end

function onLoad()
	camera.setFov(50) -- Fov in degrees
	camera.setRange(1000) -- Range in meters

	camera.customFrame(display, drawer)
	display.update()
end

function onDestroy()
	display.clear()
	display.update()
end