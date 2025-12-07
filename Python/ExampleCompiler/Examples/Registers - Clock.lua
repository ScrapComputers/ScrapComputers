-- You need a output register with the name "output" for this!

local isEnabled = false

function onUpdate()
	sc.setReg("output", isEnabled)
	isEnabled = not isEnabled
end