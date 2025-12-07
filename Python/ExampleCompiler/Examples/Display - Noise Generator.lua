local display = sc.getDisplays()[1]
assert(display, "Display not found! Make sure you have connected a Display to the computer!")

local width, height = display.getDimensions()

local function generateSeed()
	local seed = 2
	for _ = 1, 10 do
		seed = seed * math.random(2, 100)
	end

	return seed
end

function onLoad()
	local seed = generateSeed()
	for x = 1, width, 1 do
		for y = 1, height, 1 do
			display.drawPixel(x, y, sc.color.newSingular(sm.noise.octaveNoise2d(x, y, 7.5, seed)))
		end
	end
	display.update()
end

function onDestroy()
	display.clear()
	display.update()
end