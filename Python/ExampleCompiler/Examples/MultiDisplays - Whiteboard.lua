local display = sc.multidisplay.new(sc.getDisplays(), 3, 2)
local prevTouchTable = nil
local usernameToColor = {}

function onLoad()
	display.clear()
	display.update()
	display.enableTouchScreen(true)
end

function onUpdate()
	local touchTable = display.getTouchTable()

	if sc.getReg("clear") == 1 then
		display.clear()
		display.update()
	end

	if next(touchTable) ~= nil then
		for username, data in pairs(touchTable) do
			usernameToColor[username] = usernameToColor[username] or sc.color.random0to1()

			if prevTouchTable and prevTouchTable[username] then
				local prevTouchData = prevTouchTable[username]

				display.drawLine(data.x, data.y, prevTouchData.x, prevTouchData.y, usernameToColor[username])
			else
				display.drawPixel(data.x, data.y, usernameToColor[username])
			end
		end

		prevTouchTable = touchTable
		display.update()
	else
		prevTouchTable = nil
	end
end

function onDestroy()
	display.clear()
	display.update()
end

-- Connect a input register called "clear" & a button should be connected to it. Its so you can
-- clear the whiteboard!

-- NOTE: Expects a 2x3 display grid in this format. Left top right, Top to bottom.