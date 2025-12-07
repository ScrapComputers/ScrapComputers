local display = sc.getDisplays()[1]
assert(display, "Display not found! Make sure you have connected a Display to the computer!")

function onLoad()
	display.enableTouchScreen(true)
end

function onUpdate()
	local data = display.getTouchData()

	-- 3 = Released
	if data and data.state ~= 3 then
		display.drawPixel(data.x, data.y, sc.color.random0to1())
	end
	
	display.update()
end

function onDestroy()
	display.clear()
	display.update()
end