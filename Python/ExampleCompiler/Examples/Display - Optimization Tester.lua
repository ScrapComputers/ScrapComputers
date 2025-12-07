-- WARNING: This can get very laggy on high pixel count displays, do this at your own risk

local display = sc.getDisplays()[1]
assert(display, "Display not found! Make sure you have connected a Display to the computer!")

local width, height = display.getDimensions()

function onLoad()
	for x = 1, width do
		for y = 1, height do
			display.drawPixel(x, y, sc.color.random0to1())
		end
	end
	
	display.update()
end

function onDestroy()
	display.clear()
	display.update()
end