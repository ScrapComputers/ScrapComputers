local hologram = sc.getHolograms()[1]
assert(hologram, "Hologram not found! Make sure you have connected a Hologram to the computer!")

local uuid = sm.uuid.new("6ad29c0e-8209-4dca-9133-20d7a2fc2d63")
local scale = sm.vec3.new(1, 1, 1)
local position = sm.vec3.new(0, 1, 0)
local rotation = sm.vec3.new(45, 25, 15)
local color = sm.color.new("4A4A4A")

local id = -1

function onLoad()
	id = hologram.createCustomObject(uuid, position, rotation, scale, color)
end

function onDestroy()
    local object = hologram.getObject(id)
    object:delete()
end