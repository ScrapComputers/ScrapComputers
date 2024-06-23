dofile("$CONTENT_DATA/Scripts/Config.lua")

---@class Camera : ShapeClass
Camera = class()
Camera.maxParentCount = 1
Camera.maxChildCount = 0
Camera.connectionInput = sm.interactable.connectionType.compositeIO
Camera.connectionOutput = sm.interactable.connectionType.none
Camera.colorNormal = sm.color.new(0xed0086ff)
Camera.colorHighlight = sm.color.new(0xf74ac1ff)

-- MATERIALS

local groundMaterials = {
    ["Sand"] = sm.color.new(0.988235, 0.666667, 0.254902),
    ["Dirt"] = sm.color.new("697200"),
    ["Grass"] = sm.color.new("699e00"),
    ["Rock"] = sm.color.new(0.494118, 0.470588, 0.376471)
}

local assetMaterials = {
    ["Sand"] = sm.color.new(0.588235, 0.266667, 0.054902),
    ["Dirt"] = sm.color.new(0.588235, 0.266667, 0.054902),
    ["Grass"] = sm.color.new(0.588235, 0.266667, 0.054902),
    ["Rock"] = sm.color.new(0.494118, 0.470588, 0.376471)
}

local userdataColors = {
    ["lift"] = sm.color.new(0.921569, 0.717647, 0, 1),
    ["character"] = sm.color.new(1, 0, 0),
    ["harvestable"] = sm.color.new("383112")
}

-- The direction of the sun
local sunDir = -sm.vec3.new(-0.232843, -0.688331, 0.687011)

-- Creates a error string
local function createErrorStr(type, checkType, arg)
    return "bad argument #" .. arg .. ". Expected " .. checkType .. ". Got " .. type .. " instead."
end

-- Assertion type's!
local function assertType(var, expectedType, argNum)
    local varType = type(var)
    assert(varType == expectedType or (fineIfNil == true and false or varType == "nil"), createErrorStr(varType, expectedType, argNum))
end

-- Creates a randomized color by fact
local function randomizeCol(col, fact)
    local randInt = math.random() / (fact * 10)
    return sm.color.new(col.r + randInt, col.g + randInt, col.b + randInt)
end

---@param raycastResult RaycastResult
---@param type string
local function getObjCol(raycastResult, type, randomizationEnabled, i)
    -- Check theres a result and type
    if raycastResult and type then
        -- Get the material
        local material = sm.physics.getGroundMaterial(raycastResult.pointWorld)

        -- Check if its a areatrigger
        if type == "areaTrigger" then
            -- Get the data
            local trigger = raycastResult:getAreaTrigger()
            local data = trigger:getUserData()

            -- Check if water
            if data then
                if data.water then
                    -- Return blue color
                    return sm.color.new("346eeb")
                end
            end

            -- Return grass?
            return sm.color.new("699e00")
        elseif type == "terrainSurface" or type == "terrainAsset" then -- Terrain color
            -- Get the material's table
            local materialsTable = (type == "terrainSurface") and groundMaterials or assetMaterials
            local tblMaterial = materialsTable[material]

            -- Check if theres a material, if so then do the bitch like what your farther's browser tabs contain's
            if tblMaterial then
                return randomizationEnabled and randomizeCol(tblMaterial, 3) or tblMaterial
            else
                -- THE SUN IS SKY AND MY ASS IS DYING!
                return sm.color.new("3fadc7")
            end

        elseif type == "body" then -- Body color
            local shapeCol = raycastResult:getShape().color
            return randomizationEnabled and randomizeCol(shapeCol, 5) or shapeCol
        elseif type == "joint" then -- Joint color
            local jointCol = raycastResult:getJoint().color
            return randomizationEnabled and randomizeCol(jointCol, 5) or jointCol
        elseif userdataColors[type] then -- If it exists in userdataColor, return the value for it
            return userdataColors[type]
        else
            -- Return sky color
            return sm.color.new("3fadc7")
        end
    end
end

-- SERVER --

function Camera:sv_createData()
    -- Code duplication moment.
    local function validateFrameParams(width, height, fovX, fovY, xOffset, yOffset)
        -- Assert more than the amount of rounds you fucked your girlfriend that one time. We know it :)
        assertType(width, "number", 1)
        assert(width > 0, "bad argument #1, width must be larger than 0")
        
        assertType(height, "number", 2)
        assert(height > 0, "bad argument #2, height must be larger than 0")
        
        assertType(fovX, "number", 3)
        assert(fovX > 0, "bad argument #3, X area must be larger than 0")
        
        assertType(fovY, "number", 4)
        assert(fovY > 0, "bad argument #4, Y area must be larger than 0")

        if type(xOffset) ~= "nil" then
            assertType(xOffset, "number", 5)
            assert(xOffset > 0, "bad argument #5, X offset must be bigger than 0")
        end
        
        if type(yOffset) ~= "nil" then
            assertType(yOffset, "number", 6)
            assert(yOffset > 0, "bad argument #5, Y offset must be bigger than 0")
        end
    end

    return {
        ----Takes a frame (aka a screenshot)
        ---@param width integer The width of the frame
        ---@param height integer The height of the frame
        ---@param fovX number The FOV on x-axis
        ---@param fovY number The FOV on y-axis
        ---@param xOffset integer The applied x offset for the frame. By default, it’s at 0 so at the left, it would be rendered there
        ---@param yOffset integer The applied y offset for the frame. By default, it’s at 0 so at the top, it would be rendered there
        ---@return table frame The pixels of the frame
        getFrame = function(width, height, fovX, fovY, xOffset, yOffset)
            validateFrameParams(width, height, fovX, fovY, xOffset, yOffset)                 -- Validate
            return self:sv_getFrame(width, height, fovX / 400, fovY / 400, xOffset, yOffset) -- Do bitch!
        end,
        
        ---Takes a depth map frame (aka a screenshot) and returns it
        ---@param width integer The width of the frame
        ---@param height integer The height of the frame
        ---@param fovX number The FOV on x-axis
        ---@param fovY number The FOV on y-axis
        ---@param sliceWidth  integer The width for each slice
        ---@param xOffset integer The applied x offset for the frame. By default, it’s at 0 so at the left, it would be rendered there
        ---@param yOffset integer The applied y offset for the frame. By default, it’s at 0 so at the top, it would be rendered there
        ---@return table frame The pixels of the frame
        getVideo = function(width, height, fovX, fovY, sliceWidth, xOffset, yOffset)
            -- Validate
            validateFrameParams(width, height, fovX, fovY, xOffset, yOffset)
            assert(type(sliceWidth) == "number", createErrorStr(type(sliceWidth), "number", 5))
            assert(sliceWidth > 0 and sliceWidth <= width, "bad argument #5, slice width out of bounds")

            return self:sv_getFrame(width, height, fovX / 400, fovY / 400, xOffset, yOffset, "video", sliceWidth) -- Do bitch!
        end,

        ---Takes a depth map frame (aka a screenshot) and returns it
        ---@param width integer The width of the frame
        ---@param height integer The height of the frame
        ---@param fovX number The FOV on x-axis
        ---@param fovY number The FOV on y-axis
        ---@param focalLength integer The focal’s length
        ---@param xOffset integer The applied x offset for the frame. By default, it’s at 0 so at the left, it would be rendered there
        ---@param yOffset integer The applied y offset for the frame. By default, it’s at 0 so at the top, it would be rendered there
        ---@return table frame The pixels of the frame
        getDepthFrame = function(width, height, fovX, fovY, focalLength, xOffset, yOffset)
            -- Validate
            validateFrameParams(width, height, fovX, fovY, xOffset, yOffset)
            assert(type(focalLength) == "number", createErrorStr(type(focalLength), "number", 5))
            assert(focalLength > 0 , "bad argument #5, focal length must be above 0")

            return self:sv_getFrame(width, height, fovX / 400, fovY / 400, xOffset, yOffset, "depthMap", focalLength) -- Do bitch!
        end,

        ---Takes a masked map frame (aka a screenshot) and returns it
        ---**In case `mask` is a `string[]`**: Each string is a raycast result type. If a raycast's type matches the pixel, it will be white or else black.
        ---**In case `mask` is a `string`**: If a raycast's type matches with the mask, the pixel's color would be white and else black.
        ---
        ---If you do not know what the value(s) for the mask should be, (Find them by [clicking this](https://scrapmechanicdocs.com/docs/Game-Script-Environment/Constants#smphysicstypes)) URL.
        ---@param width integer The width of the frame
        ---@param height integer The height of the frame
        ---@param fovX number The FOV on x-axis
        ---@param fovY number The FOV on y-axis
        ---@param mask string|string[] The mask for the raycast's to set.
        ---@param xOffset integer The applied x offset for the frame. By default, it's at 0 so at the left, it would be rendered there
        ---@param yOffset integer The applied y offset for the frame. By default, it's at 0 so at the top, it would be rendered there
        ---@return table frame The pixels of the frame
        getMaskedFrame = function(width, height, fovX, fovY, mask, xOffset, yOffset)
            -- Validate
            validateFrameParams(width, height, fovX, fovY, xOffset, yOffset)
            assert(type(mask) == "string" or type(mask) == "table", createErrorStr(type(mask), "string or table", 5))

            return self:sv_getFrame(width, height, fovX / 400, fovY / 400, xOffset, yOffset, "masked", mask) -- Do bitch!
        end,

        ---Takes a advanced frame (aka a screenshot)
        ---@param width integer The width of the frame
        ---@param height integer The height of the frame
        ---@param fovX number The FOV on x-axis
        ---@param fovY number The FOV on y-axis
        ---@param xOffset integer The applied x offset for the frame. By default, it’s at 0 so at the top, it would be rendered there
        ---@param yOffset integer The applied y offset for the frame. By default, it’s at 0 so at the left, it would be rendered there
        ---@return table frame The pixels of the frame
        getAdvancedFrame = function(width, height, fovX, fovY, xOffset, yOffset)
            validateFrameParams(width, height, fovX, fovY, xOffset, yOffset)                             -- Validate
            return self:sv_getFrame(width, height, fovX / 400, fovY / 400, xOffset, yOffset, "advanced") -- Do bitch!
        end,

        ---Like getFrame but it’s as slices meaning you could make CCTV cameras without lagging a lot! It’s just that the refresh rate would be lower.
        ---@param width integer The width of the frame
        ---@param height integer The height of the frame
        ---@param fovX number The FOV on x-axis
        ---@param fovY number The FOV on y-axis
        ---@param sliceWidth  integer The width for each slice
        ---@param xOffset integer The applied x offset for the frame. By default, it’s at 0 so at the top, it would be rendered there
        ---@param yOffset integer The applied y offset for the frame. By default, it’s at 0 so at the left, it would be rendered there
        ---@return table frame The pixels of the frame
        getAdvancedVideo = function(width, height, fovX, fovY, sliceWidth, xOffset, yOffset)
            -- Validate
            validateFrameParams(width, height, fovX, fovY, xOffset, yOffset)
            assert(type(sliceWidth) == "number", createErrorStr(type(sliceWidth), "number", 5))
            assert(sliceWidth > 0 and sliceWidth <= width, "bad argument #5, slice width out of bounds")

            return self:sv_getFrame(width, height, fovX / 400, fovY / 400, xOffset, yOffset, "advanced", sliceWidth) -- Do bitch!
        end,

        ---Toggles the randomization shader. This is very simple but adds a lot of detail to the frame at a cost of performance when used in displays as the optimization would be gone.
        ---
        ---This randomization of the colors of a frame’s pixels a tiny bit.
        ---@param toggle boolean To enable or disable the randomization shader
        toggleRandom = function(toggle)
            assertType(toggle, "boolean", 1)
            self.sv.randomizationEnabled = toggle
        end
    }
end

function Camera:server_onCreate()
    -- Create server-side variables
    self.sv = {
        -- If true, a shader gets applied for more detail at a cost of display optimization
        randomizationEnabled = false,

        -- The slice index
        sliceIndex = 1
    }
end

-- Any documentation afther here is done by A.I because VeraDev is tired of documenting this shit

-- Initialize a brightness variable, which will be used to adjust the color intensity.
local brightness = 1

-- Define a method for the Camera class to capture a frame.
-- The method parameters are:
--   - width: Width of the frame.
--   - height: Height of the frame.
--   - fovX: Field of view along the X-axis.
--   - fovY: Field of view along the Y-axis.
--   - xOffset: X-axis offset for the frame.
--   - yOffset: Y-axis offset for the frame.
--   - type_: Type of frame to capture (e.g., "video", "advanced", "depthMap").
--   - data: Additional data needed for frame capture.
function Camera:sv_getFrame(width, height, fovX, fovY, xOffset, yOffset, type_, data)
    -- Get the world position and rotation of the camera shape.
    local worldPos = self.shape.worldPosition
    local worldRot = self.shape.worldRotation

    -- Calculate the right, up, and forward vectors based on the world rotation.
    local right = worldRot * sm.vec3.new(1, 0, 0)
    local up = worldRot * sm.vec3.new(0, 1, 0)
    local at = worldRot * sm.vec3.new(0, 0, 1)

    -- Initialize tables to store multicast rays, index positions, and points.
    local multicastTbl, indexTbl, pointTbl = {}, {}, {}

    -- Calculate the starting vertex for the raycasting grid.
    local v1 = worldPos + (up * fovY / 2) + (right * fovX / 2) + at * 0.25
    local v2, v3 = -up * fovY / height, -right * fovX / width

    -- Local function to add a ray for raycasting.
    -- Parameters:
    --   - x: X coordinate of the ray in the grid.
    --   - y: Y coordinate of the ray in the grid.
    --   - sliceIndex: Index of the current slice in the grid.
    local function addRay(x, y, sliceIndex)
        -- Calculate the starting position of the ray.
        local startPos = v1 + v2 * (y - 1) + v3 * (sliceIndex - 1)
        -- Calculate the end position of the ray (far away to ensure collision detection).
        local endPos = startPos + (startPos - worldPos) * 20000
        -- Insert the ray into the multicast table.
        table.insert(multicastTbl, {type = "ray", startPoint = startPos, endPoint = endPos, mask = -1})
        -- Insert the index position into the index table.
        table.insert(indexTbl, {sliceIndex, y})
    end

    -- Determine how to add rays based on the type of frame.
    if (type_ == "video" or type_ == "advanced") and data then
        -- For "video" or "advanced" types with additional data, add rays slice by slice.
        for i = 1, data do 
            for y = 1, height do
                addRay(self.sv.sliceIndex, y, self.sv.sliceIndex)
            end
            self.sv.sliceIndex = (self.sv.sliceIndex % width) + 1
        end
    else
        -- For other types, add rays for the entire grid.
        for x = 1, width do
            for y = 1, height do
                addRay(x, y, x)
            end
        end
    end

    -- Set default offsets if they are not provided.
    xOffset, yOffset = xOffset or 0, yOffset or 0

    -- Perform a physics multicast with the rays to get collision results.
    local resultTbl = sm.physics.multicast(multicastTbl)

    -- Initialize variables to track the highest and lowest collision fractions.
    local highestFrac, lowestFrac
    if type_ ~= "depthMap" then
        -- Calculate the highest and lowest collision fractions.
        for _, data in ipairs(resultTbl) do
            if data[1] then
                local fraction = data[2].fraction
                highestFrac = highestFrac and math.max(fraction, highestFrac) or fraction
                lowestFrac = lowestFrac and math.min(fraction, lowestFrac) or fraction
            end
        end
    end

    -- Determine if there is a significant difference in collision fractions.
    local diffBig = type_ ~= "depthMap" and (math.abs(lowestFrac - highestFrac) > 0.2)

    -- Initialize a table to store pixel information.
    local pixelTbl = {}
    local time = math.abs(sm.game.getTimeOfDay() + 0.5)

    -- Process the results of the raycasting.
    for i, data_ in ipairs(resultTbl) do
        local hit, result = unpack(data_)
        if hit then
            local color
            local modifier = (math.abs(sm.vec3.new(0, 0, 1):dot(result.normalWorld)) * 0.5) + 0.5

            -- Handle different types of frame captures.
            if type_ == "depthMap" then
                -- For "depthMap", calculate color based on distance fraction.
                color = sm.color.new(1, 1, 1, 1) * (1 - (result.fraction / (data / 20000)))
            elseif type_ == "masked" then
                -- For "masked", determine if the result matches a mask.
                local maskMatch = false
                if type(data) == "table" then
                    for _, mask in ipairs(data) do
                        if mask == result.type then
                            maskMatch = true
                            break
                        end
                    end
                else
                    maskMatch = (result.type == data)
                end
                color = sm.color.new(maskMatch and 1 or 0.133, maskMatch and 1 or 0.133, maskMatch and 1 or 0.133, 1) * modifier * (1 - (result.fraction / highestFrac))
            else
                -- For other types, get the object color and adjust it.
                color = getObjCol(result, result.type, self.sv.randomizationEnabled, i) * brightness * time
                if result.type ~= "limiter" then
                    color = color * modifier * (diffBig and (1 - (result.fraction / highestFrac)) or 1)
                end
            end

            -- For "advanced" type, store the point and color information.
            if type_ == "advanced" and result.type ~= "limiter" then
                table.insert(pointTbl, {point = result.pointWorld, color = color, index = i})
            else
                -- For other types, store the pixel information.
                local x, y = unpack(indexTbl[i])
                table.insert(pixelTbl, {x = x + xOffset, y = y + yOffset, scale = {x = 1, y = 1}, color = color})
            end
        end
    end

    -- Return the pixel table if the frame type is not "advanced".
    if type_ ~= "advanced" then
        return pixelTbl
    end

    -- For "advanced" type, calculate shadows and finalize pixel colors.
    if #pointTbl > 0 then
        local offset = 100
        local rayTraceTbl = {}
        for _, tbl in ipairs(pointTbl) do
            local startPos = tbl.point + -sunDir * offset
            table.insert(rayTraceTbl, {type = "ray", startPoint = startPos, endPoint = startPos + sunDir * offset})
        end

        local rayTraceResults = sm.physics.multicast(rayTraceTbl)
        local shadowMult = 0.4

        for i, raycast in ipairs(rayTraceResults) do
            local hit, result = unpack(raycast)
            if hit and (result.pointWorld - pointTbl[i].point):length() > 0.025 then
                pointTbl[i].color = pointTbl[i].color * shadowMult
            end
            local x, y = unpack(indexTbl[pointTbl[i].index])
            table.insert(pixelTbl, {x = x + xOffset, y = y + yOffset, scale = {x = 1, y = 1}, color = pointTbl[i].color})
        end
    end

    -- Return the pixel table with final colors.
    return pixelTbl
end

-- Convert the Camera class to a component in the Scrap Mechanic engine.
sm.scrapcomputers.components.ToComponent(Camera, "Cameras", true)
