local light = sc.getLights()[1]

local rainbowColors = {
	sm.color.new(1, 0, 0), -- Red
	sm.color.new(1, 0.5, 0), -- Orange
	sm.color.new(1, 1, 0), -- Yellow
	sm.color.new(0, 1, 0), -- Green
	sm.color.new(0, 0, 1), -- Blue
	sm.color.new(0.29, 0, 0.51), -- Indigo
	sm.color.new(0.56, 0, 1) -- Violet
}
table.insert(rainbowColors, rainbowColors[1])

local gradient = sc.color.generateGradient(rainbowColors, 40 * 5)
local gradientIndex = 1

function onUpdate()
	gradientIndex = gradientIndex + 1
	if gradientIndex > #gradient then
		gradientIndex = 1
	end

	light.setColor(gradient[gradientIndex])
end

function onDestroy()
	light.setColor(sm.color.new(0, 0, 0))
end