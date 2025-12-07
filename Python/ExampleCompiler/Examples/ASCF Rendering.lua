-- CONFIG --

local fontName = "Futura"
local text = "Hello World!"
local fontSize = 50

-- SOURCE CODE --

local display = sc.getDisplays()[1]
assert(display, "Display not found! Make sure you have connected a Display to the computer!")

local displayWidth, displayHeight = display.getDimensions()

local rainbowColors = {
	sm.color.new(1, 0, 0), -- Red
	sm.color.new(1, 0.5, 0), -- Orange
	sm.color.new(1, 1, 0), -- Yellow
	sm.color.new(0, 1, 0), -- Green
	sm.color.new(0, 0, 1), -- Blue
	sm.color.new(0.29, 0, 0.51), -- Indigo
	sm.color.new(0.56, 0, 1)  -- Violet
}

table.insert(rainbowColors, rainbowColors[1])

local rotationSinWave = 0
local fontSizeSinWave = 0

local gradient = sc.color.generateGradient(rainbowColors, 100)
local gradientIndex = 1

function onUpdate()
	rotationSinWave = rotationSinWave + 0.1
	fontSizeSinWave = fontSizeSinWave + 0.2

	local rotation = math.sin(rotationSinWave) * 11
	local sizeOffset = math.sin(fontSizeSinWave) * 7.5

	gradientIndex = gradientIndex + 1
	if gradientIndex > #gradient then
		gradientIndex = 1
	end

	local textWidth, textHeight = display.calcASCFTextSize(fontName, text, fontSize + sizeOffset, 0)
	local color = gradient[gradientIndex]

	local xPos = (displayWidth / 2) - (textWidth / 2)
	local yPos = (displayHeight / 2) - (textHeight / 2)

	display.clear("0A0A0A")
	display.drawASCFText(xPos, yPos, text, fontName, color, rotation, fontSize + sizeOffset)
	display.update()
end

function onDestroy()
	display.clear()
	display.update()
end

-- Configurations at the top!