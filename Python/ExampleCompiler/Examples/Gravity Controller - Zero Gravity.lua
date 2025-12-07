local gravityController = sc.getGravityControllers()[1]
local multiplier = 0 -- Setting it to 0 makes it no gravity! 2 for double the gravitiy.

function onLoad()
	gravityController.setGravityEnabled(true)
	gravityController.setMultiplier(multiplier)
end

function onDestroy()
	gravityController.setGravityEnabled(false)
end