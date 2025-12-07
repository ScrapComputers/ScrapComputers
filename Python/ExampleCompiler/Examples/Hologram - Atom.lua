local hologram = sc.getHolograms()[1]
assert(hologram, "Hologram not found! Make sure you have connected a Hologram to the computer!")

local protonColor = sm.color.new("ff0000")
local neutronColor = sm.color.new("00ff00")
local electronColor = sm.color.new("ffffff")
local datumPosition = sm.vec3.new(0, 1, 0)

local nucleusObjects = {}
local electronObjects = {}

-- Get the ammount of protons and neutrons in the nucleus
local nucleusCount = math.random(2, 5)
local electronCount = math.random(1, 3)

-- Create average position used for centering the rotation of the electrons
local averagePosition = sm.vec3.zero()

-- Generates a random rotation direction for electrons
local function generateRandom()
    if math.random(0, 1) == 1 then
        return sm.vec3.new(0, math.rad(10), 0)
    end

	return sm.vec3.new(0, math.rad(-10), 0)
end

function onLoad()
	-- Loop for every nucleus object
	for i = 1, nucleusCount do
		-- Generates a random bool to make the object a proton and generates a random offset position
		local isProton = math.random(0, 1) == 1
		local randOffset = sm.vec3.new(math.random(), math.random(), math.random())
	
		-- Set the objects parameters
		local position = datumPosition + randOffset - randOffset / 2
		local rotation = sm.vec3.zero()
		local scale = sm.vec3.one()
		local color = isProton and protonColor or neutronColor

		-- Create the object and add it to its respective table, along with data needed for modifications
		nucleusObjects[#nucleusObjects + 1] = {
			id = hologram.createSphere(position, rotation, scale, color),
			position = position
		}

		-- Update the average position with the random offset
		averagePosition = averagePosition + position
	end

	-- Complete the average
	averagePosition = averagePosition / nucleusCount

	-- Loop for every electron object
	for i = 1, electronCount do
		-- Set the objects parameters
		local position = sm.vec3.new(i + 0.5, 0, 0) + averagePosition
		local rotation = sm.vec3.zero()
		local scale = sm.vec3.one() / 10
	
		-- Create the object and add it to its respective table, along with data needed for modifications
		electronObjects[#electronObjects + 1] = {
			id = hologram.createSphere(position, rotation, scale, electronColor),
			position = position,
			orbitDirection = generateRandom() -- dictates the direction of rotation
		}
	end
end

function onUpdate()
	-- Loop through every nucleus object
	for i, objectData in pairs(nucleusObjects) do
		-- Get the object and create a noise offset for vibration
		local object = hologram.getObject(objectData.id)
		local noiseOffset = sm.vec3.new(math.random() / 10, math.random() / 10, math.random() / 10)

		-- Set the new position
		object.setPosition(objectData.position + noiseOffset - noiseOffset / 2)
	end

	-- Loop through every electron object
	for i, objectData in pairs(electronObjects) do
		local object = hologram.getObject(objectData.id)

		-- Get the direction from the current position to the average position and rotate based on the orbit direction
		local direction = averagePosition - objectData.position
		local newDirection = direction:rotateY(objectData.orbitDirection.y)

		-- Create the new electron position with the new direction
		local newPosition = averagePosition - newDirection

		-- Update the objects position and update the tables saved position
		object.setPosition(newPosition)
		objectData.position = newPosition
	end
end