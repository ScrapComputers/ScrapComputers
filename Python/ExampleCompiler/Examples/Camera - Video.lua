local display = sc.getDisplays()[1]
assert(display, "Display not found! Make sure you have connected a Display to the computer!")

local camera = sc.getCameras()[1]
assert(display, "Camera not found! Make sure you have connected a Camera to the computer!")

function onLoad()
	camera.setFov(50) -- Fov in degrees
	camera.setRange(250) -- Range in meters

	display.setOptimizationThreshold(0.05) -- Sets the image compression
end

function onUpdate()
	camera.video(display, 4) -- 4 slices of the display will be drawn per tick
	display.update()
end

function onDestroy()
	display.clear()
	display.update()
end