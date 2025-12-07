local display = sc.getDisplays()[1]
assert(display, "Display not found! Make sure you have connected a Display to the computer!")

local width, height = display.getDimensions()

local cubeSize = math.min(width, height) / 2  -- Scale of the cube size
local angleX, angleY = 0, 0  -- Initial angles for rotation
local centerX, centerY = width / 2, height / 2  -- Center of the display
local rotationSpeed = 0.02  -- Speed of rotation
local color = sc.color.random0to1()

local vertices = {
	sm.vec3.new(-1, -1, -1),
	sm.vec3.new(1, -1, -1),
	sm.vec3.new(1, 1, -1),
	sm.vec3.new(-1, 1, -1),
	sm.vec3.new(-1, -1, 1),
	sm.vec3.new(1, -1, 1),
	sm.vec3.new(1, 1, 1),
	sm.vec3.new(-1, 1, 1)
}

local edges = {
	{1, 2}, {2, 3}, {3, 4}, {4, 1},  -- Edges of the front face
	{5, 6}, {6, 7}, {7, 8}, {8, 5},  -- Edges of the back face
	{1, 5}, {2, 6}, {3, 7}, {4, 8}   -- Connecting edges between front and back faces
}

function projectVertex(vertex)
	local scale = cubeSize / (vertex.z + 3)
	local x = vertex.x * scale + centerX
	local y = vertex.y * scale + centerY

	x = sm.util.clamp(math.floor(x + 0.5), 1, width)
	y = sm.util.clamp(math.floor(y + 0.5), 1, height)

	return x, y
end

function onUpdate()
	display.clear()

	local projectedVertices = {}
	
	-- Loop through each verticy
	for i = 1, #vertices do
		-- Get the current verticy and rotate it based on the x and y angles
		local rotatedVertex = vertices[i]:rotateX(angleX):rotateY(angleY)
		
		-- Project the rotated vertex to 2D screen space and add to the table
		local x, y = projectVertex(rotatedVertex)
		projectedVertices[i] = {x, y}
	end
	
	-- Loop through each edge and draw a line btween the 2 vertices
	for i = 1, #edges do
		local v1 = projectedVertices[edges[i][1]]
		local v2 = projectedVertices[edges[i][2]]
		
		display.drawLine(v1[1], v1[2], v2[1], v2[2], color)
	end

	display.update()

	angleX = angleX + rotationSpeed
	angleY = angleY + rotationSpeed
end