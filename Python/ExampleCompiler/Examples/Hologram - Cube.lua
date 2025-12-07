local hologram = sc.getHolograms()[1]
assert(hologram, "Hologram not found! Make sure you have connected a Hologram to the computer!")

local scale = sm.vec3.new(1, 1, 1)
local position = sm.vec3.new(0, 1, 0)
local rotation = sm.vec3.new(45, 25, 15)
local color = sc.color.random0to1()

local id = -1

function onLoad()
	id = hologram.createCube(position, rotation, scale, color)
end

function onUpdate()
	local object = hologram.getObject(id)
	object.setRotation(rotation)

	rotation = rotation + sm.vec3.one()
end

function onDestroy()
	local object = hologram.getObject(id)
    object.delete()
end