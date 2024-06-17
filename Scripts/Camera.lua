dofile("$CONTENT_DATA/Scripts/Config.lua")

---@class Camera : ShapeClass
Camera = class()
Camera.maxParentCount = 1
Camera.maxChildCount = 0
Camera.connectionInput = sm.interactable.connectionType.compositeIO
Camera.connectionOutput = sm.interactable.connectionType.none
Camera.colorNormal = sm.color.new(0xed0086ff)
Camera.colorHighlight = sm.color.new(0xf74ac1ff)

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

local sunDir = -sm.vec3.new(-0.232843, -0.688331, 0.687011)

local function createErrorStr(type, checkType, arg)
    return "bad argument #" .. arg .. ". Expected " .. checkType .. ". Got " .. type .. " instead."
end

local function assertType(var, expectedType, argNum)
    local varType = type(var)
    assert(varType == expectedType or (fineIfNil == true and false or varType == "nil"), createErrorStr(varType, expectedType, argNum))
end

local function randomizeCol(col, fact)
    local randInt = math.random() / (fact * 10)
    return sm.color.new(col.r + randInt, col.g + randInt, col.b + randInt)
end

---@param raycastResult RaycastResult
---@param type string
local function getObjCol(raycastResult, type, randomizationEnabled, i)
    if raycastResult and type then
        local material = sm.physics.getGroundMaterial(raycastResult.pointWorld)
        if type == "areaTrigger" then
            local trigger = raycastResult:getAreaTrigger()
            local data = trigger:getUserData()

            if data then
                if data.water then
                    return sm.color.new("346eeb")
                end
            end

            return sm.color.new("699e00")
        elseif type == "terrainSurface" or type == "terrainAsset" then
            local materialsTable = (type == "terrainSurface") and groundMaterials or assetMaterials
            local tblMaterial = materialsTable[material]

            if tblMaterial then
                return randomizationEnabled and randomizeCol(tblMaterial, 3) or tblMaterial
            else
                return sm.color.new("3fadc7")
            end

        elseif type == "body" then
            local shapeCol = raycastResult:getShape().color
            return randomizationEnabled and randomizeCol(shapeCol, 5) or shapeCol

        elseif type == "joint" then
            local jointCol = raycastResult:getJoint().color
            return randomizationEnabled and randomizeCol(jointCol, 5) or jointCol

        elseif userdataColors[type] then
            return userdataColors[type]

        else

            return sm.color.new("3fadc7")
        end
    end
end

-- SERVER --

function Camera:sv_createData()
    local function validateFrameParams(width, height, fovX, fovY, xOffset, yOffset)
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
        getFrame = function(width, height, fovX, fovY, xOffset, yOffset)
            validateFrameParams(width, height, fovX, fovY, xOffset, yOffset)
            return self:sv_getFrame(width, height, fovX / 400, fovY / 400, xOffset, yOffset)
        end,

        getDepthMap = function(width, height, fovX, fovY, focalLength, xOffset, yOffset)
            validateFrameParams(width, height, fovX, fovY, xOffset, yOffset)
            assert(type(focalLength) == "number", createErrorStr(type(focalLength), "number", 5))
            assert(focalLength > 0 , "bad argument #5, focal length must be above 0")
            return self:sv_getFrame(width, height, fovX / 400, fovY / 400, xOffset, yOffset, "depthMap", focalLength)
        end,

        getVideo = function(width, height, fovX, fovY, sliceWidth, xOffset, yOffset)
            validateFrameParams(width, height, fovX, fovY, xOffset, yOffset)
            assert(type(sliceWidth) == "number", createErrorStr(type(sliceWidth), "number", 5))
            assert(sliceWidth > 0 and sliceWidth <= width, "bad argument #5, slice width out of bounds")
            return self:sv_getFrame(width, height, fovX / 400, fovY / 400, xOffset, yOffset, "video", sliceWidth)
        end,

        getAdvancedFrame = function(width, height, fovX, fovY, xOffset, yOffset)
            validateFrameParams(width, height, fovX, fovY, xOffset, yOffset)
            return self:sv_getFrame(width, height, fovX / 400, fovY / 400, xOffset, yOffset, "advanced")
        end,

        getAdvancedVideo = function(width, height, fovX, fovY, sliceWidth, xOffset, yOffset)
            validateFrameParams(width, height, fovX, fovY, xOffset, yOffset)
            assert(type(sliceWidth) == "number", createErrorStr(type(sliceWidth), "number", 5))
            assert(sliceWidth > 0 and sliceWidth <= width, "bad argument #5, slice width out of bounds")
            return self:sv_getFrame(width, height, fovX / 400, fovY / 400, xOffset, yOffset, "advanced", sliceWidth)
        end,

        toggleRandom = function(toggle)
            assertType(toggle, "boolean", 1)
            self.sv.randomizationEnabled = toggle
        end
    }
end

function Camera:server_onCreate()
    self.sv = {
        randomizationEnabled = false,
        sliceIndex = 1
    }
end

local brightness = 1

function Camera:sv_getFrame(width, height, fovX, fovY, xOffset, yOffset, type, data)
    local worldPos = self.shape.worldPosition
    local worldRot = self.shape.worldRotation

    local right = worldRot * sm.vec3.new(1, 0, 0)
    local up = worldRot * sm.vec3.new(0, 1, 0)
    local at = worldRot * sm.vec3.new(0, 0, 1)

    local multicastTbl = {}
    local indexTbl = {}
    local pointTbl = {}

    local v1 = worldPos + (up * fovY / 2) + (right * fovX / 2) + at * 0.15
    local v2 = -up * fovY / height
    local v3 = -right * fovX / width

    if (type == "video" or type == "advanced") and data then
        for i = 1, data do 
            for y = 1, height do
                local startPos = v1 + v2 * (y - 1) + v3 * (self.sv.sliceIndex - 1)
                local endPos = startPos + (startPos - worldPos) * 20000
                table.insert(multicastTbl, {type = "ray", startPoint = startPos, endPoint = endPos, mask = -1})
                table.insert(indexTbl, {self.sv.sliceIndex, y})
            end

            self.sv.sliceIndex = self.sv.sliceIndex % width + 1
        end
    else
        for x = 1, width do
            for y = 1, height do
                local startPos = v1 + v2 * (y - 1) + v3 * (x - 1)
                local endPos = startPos + (startPos - worldPos) * 20000
                table.insert(multicastTbl, {type = "ray", startPoint = startPos, endPoint = endPos, mask = -1})
                table.insert(indexTbl, {x, y})
            end
        end
    end

    xOffset = xOffset or 0
    yOffset = yOffset or 0
    
    local resultTbl = sm.physics.multicast(multicastTbl)
    local highestFrac, lowestFrac

    if type ~= "depthMap" then
        for _, data in ipairs(resultTbl) do
            if data[1] then
                local fraction = data[2].fraction
                highestFrac = highestFrac and math.max(fraction, highestFrac) or fraction
                lowestFrac = lowestFrac and math.min(fraction, lowestFrac) or fraction
            end
        end
    end

    local diffBig

    if not depthMap then
        diffBig = math.abs(lowestFrac - highestFrac) > 0.2
    end

    local pixelTbl = {}
    local time = math.abs(sm.game.getTimeOfDay() + 0.5)
    local pointTbl = {}

    for i, data in ipairs(resultTbl) do
        local hit, result = unpack(data)
        if hit then
            local color

            if type == "depthMap" then
                color = sm.color.new(1, 1, 1, 1) * (1 - (result.fraction / (data / 20000)))
            else
                color = getObjCol(result, result.type, self.sv.randomizationEnabled, i) * brightness * time 
                local modifier = (math.abs(sm.vec3.new(0, 0, 1):dot(result.normalWorld)) * 0.5) + 0.5

                if result.type ~= "limiter" then
                    if diffBig or type == "video" then
                        color = color * modifier * (1 - (result.fraction / highestFrac))
                    else
                        color = color * modifier
                    end
                end
            end

            if type == "advanced" and result.type ~= "limiter" then
                table.insert(pointTbl, {point = result.pointWorld, color = color, index = i})
            else
                local x, y = unpack(indexTbl[i])
                table.insert(pixelTbl, {x = x + xOffset, y = y + yOffset, scale = {x = 1, y = 1}, color = color})
            end
        end
    end

    if type ~= "advanced" then
        return pixelTbl
    end

    local rayTraceTbl = {}

    if #pointTbl > 0 then
        local offset = 500

        for i, tbl in pairs(pointTbl) do
            local startPos = tbl.point + -sunDir * offset
            table.insert(rayTraceTbl, {type = "ray", startPoint = startPos, endPoint = startPos + sunDir * offset})
        end
    end

    local rayTraceResults = sm.physics.multicast(rayTraceTbl)
    local shadowMult = 0.4

    for i, raycast in pairs(rayTraceResults) do
        local hit, result = unpack(raycast)

        if hit then
            if (result.pointWorld - pointTbl[i].point):length() > 0.025 then
                pointTbl[i].color = pointTbl[i].color * shadowMult
            end
        end

        local x, y = unpack(indexTbl[pointTbl[i].index])

        table.insert(pixelTbl, {x = x + xOffset, y = y + yOffset, scale = {x = 1, y = 1}, color = pointTbl[i].color})
    end

    return pixelTbl
end


-- Convert the class to a component
dofile("$CONTENT_DATA/Scripts/ComponentManager.lua")
sc.componentManager.ToComponent(Camera, "Cameras", true)