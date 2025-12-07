-- Config --

-- Tick this when using a custom video. This just enforces 64x64 display resolution only.
local ignoreDimensionAsserts = false

-- File path to video here, check out DisplayVideos folder!
local videoData = sm.json.open("$CONTENT_DATA/DisplayVideos/BadApple64x64_BW.json")

-- The frame rate the videoData is at.
local fps = 30

-- Source Code --

local math_floor = math.floor

local display = sc.getDisplays()[1]
assert(display, "Display not found! Make sure you have connected a Display to the computer!")

local width, height = display.getDimensions()
if not ignoreDimensionAsserts then
    assert(width == 64 and height == 64, "Invalid Display Resolution! Expected 64x64 for Bad Apple Black & White!")
end

local frameCount = 0
local frameIncrementAmount = fps / 40
local pixelCounter = 1

local whiteColor = sm.color.new(1, 1, 1)

-- Turns a coordinate number that is stored in the json into x and y
function indexToCoordinate(index, width)
	return (index - 1) % width + 1, math_floor((index - 1) / width) + 1
end

-- Renders a frame by parsing video data structure
function renderFrame()
	local drawFilledRect = display.drawFilledRect

	local length = videoData[pixelCounter]
	if not length then
		pixelCounter = 1
		length = videoData[pixelCounter]
	end

	pixelCounter = pixelCounter + 1

	if length == 0 then return end

	for _ = 1, length do
		local x, y = indexToCoordinate(videoData[pixelCounter], width)
		pixelCounter = pixelCounter + 1

		local sx, sy = indexToCoordinate(videoData[pixelCounter], width)
		pixelCounter = pixelCounter + 1

		drawFilledRect(x, y, sx, sy, whiteColor)
	end
end

function onUpdate()
	-- Times the update according with the fps specified
	if math_floor(frameCount) ~= math_floor(frameCount - frameIncrementAmount) then
		display.clear()
		renderFrame()
		display.update()
	end

	frameCount = frameCount + frameIncrementAmount
end

function onDestroy()
	display.clear()
	display.update()
end

-- Scroll up to put ur Video Data & Video FPS inside!