-- The example image used is 256x256, please use a 256x256 display!

local display = sc.getDisplays()[1]
assert(display, "Display not found! Make sure you have connected a Display to the computer!")

local width, height = display.getDimensions()
assert(width == 256 and height == 256, "Invalid Display Resolution! Please use a 256x256 display for this example")

function onLoad()
	display.setOptimizationThreshold(0.02)
	display.loadImage(width, height, "example.json")
	display.update()
end

function onDestroy()
	display.clear()
	display.update()
end