local sm_scrapcomputers_errorHandler_assertArgument = sm.scrapcomputers.errorHandler.assertArgument
local sm_physics_getGroundMaterial = sm.physics.getGroundMaterial
local sm_vec3_new = sm.vec3.new
local sm_color_new = sm.color.new
local sm_util_clamp = sm.util.clamp
local scrap_generateGradient = sm.scrapcomputers.color.generateGradient
local sm_game_getTimeOfDay = sm.game.getTimeOfDay
local sm_vec3_normalize = sm.vec3.normalize
local sm_vec3_dot = sm.vec3.dot
local math_floor = math.floor
local math_pow = math.pow
local math_min = math.min
local math_max = math.max

local bit_band = bit.band
local bit_rshift = bit.rshift
local bit_bor = bit.bor
local bit_lshift = bit.lshift

local sm_terrainpp_getColorAt = sm.terrainpp and sm.terrainpp.getColorAt or nil

---@class CameraClass : ShapeClass
CameraClass = class()
CameraClass.maxParentCount = -1
CameraClass.maxChildCount = 0
CameraClass.connectionInput = sm.interactable.connectionType.compositeIO
CameraClass.connectionOutput = sm.interactable.connectionType.none
CameraClass.colorNormal = sm_color_new(0xed0086ff)
CameraClass.colorHighlight = sm_color_new(0xf74ac1ff)

sm.scrapcomputers.backend.cameraColorCache = sm.scrapcomputers.backend.cameraColorCache or {}

-- MATERIALS

local groundMaterials = {
    ["Sand"] = sm_color_new(0.988235, 0.666667, 0.254902),
    ["Dirt"] = sm_color_new("697200"),
    ["Grass"] = sm_color_new("699e00"),
    ["Rock"] = sm_color_new(0.494118, 0.470588, 0.376471),
}

local assetMaterials = {
    ["Sand"] = sm_color_new(0.588235, 0.266667, 0.054902),
    ["Dirt"] = sm_color_new(0.588235, 0.266667, 0.054902),
    ["Grass"] = sm_color_new(0.588235, 0.266667, 0.054902),
    ["Rock"] = sm_color_new(0.494118, 0.470588, 0.376471),
}

local userdataColors = {
    ["lift"] = sm_color_new(0.921569, 0.717647, 0),
    ["character"] = sm_color_new(1, 0, 0),
    ["harvestable"] = sm_color_new("383112"),
}

local sunDir = sm_vec3_new(0.232843, 0.688331, -0.687011)
local shadowMult = 0.5
local groundColorCache = {}

local function formatVec(vec3)
    return "" .. math.floor(vec3.x * 5) .. "" .. math.floor(vec3.y * 5) .. "" .. math.floor(vec3.z * 5)
end

local function coordinateToIndex(x, y, width)
    return (y - 1) * width + x
end

local function map(value, low, high, low1, high1)
    local inputRange = high - low
    local outputRange = high1 - low1

    local normalizedValue = (value - low) / inputRange
    local mappedValue = low1 + (normalizedValue * outputRange)

    return mappedValue
end

local skyMap = {
    sm_color_new("#070716"),
    sm_color_new("#508fbc"),
    sm_color_new("#56bbcf"),
    sm_color_new("#56bbcf"),
    sm_color_new("#56bbcf"),
    sm_color_new("#56bbcf"),
    sm_color_new("#56bbcf"),
    sm_color_new("#a37858"),
    sm_color_new("#070716"),
    sm_color_new("#070716"),
}

local darknessMap = {
    0.4,
    0.7,
    1,
    1.2,
    1.2,
    1.2,
    1,
    0.7,
    0.4,
    0.4,
}

local function getSkyColor()
    return skyMap[math.floor(map(sm_game_getTimeOfDay(), 0, 1, 1, 10))] or sm_color_new("FF0000")
end

local function areColorsSimilar(color1, color2, threshold)
    local isSame = color1 == color2

    if isSame then
        return true
    end

    if threshold == 0 then 
        return isSame
    end

    local dr, dg, db = (color1.r * 255) - (color2.r * 255), (color1.g * 255) - (color2.g * 255), (color1.b * 255) - (color2.b * 255)

    return (dr * dr + dg * dg + db * db) <= (threshold * 255) ^ 2 * 3
end

local function applySunShader(result, color, time)
    if time < 0.2 or time > 0.9 then return color end

    local distance = -(sm_vec3_dot(sunDir, result.directionWorld:normalize()))

    if distance > 0.995 then
        return sm_color_new("eeeeee")
    elseif distance > 0.992 then
        return (sm_color_new("F6F679") + color / 2.5) * 0.8
    end

    return color
end

function CameraClass:sv_getObjCol(raycastResult, advanced)
    if not raycastResult then
        return getSkyColor()
    end

    local pointWorld = raycastResult.pointWorld
    local type = raycastResult.type
    local material = sm_physics_getGroundMaterial(pointWorld)
    local returnColor = getSkyColor()

    if type == "terrainSurface" or type == "terrainAsset" then
        local materialsTable = (type == "terrainSurface") and groundMaterials or assetMaterials
        local groundColor = materialsTable[material]

        if not groundColor then
            returnColor = getSkyColor()
            goto cont
        elseif not advanced then
            returnColor = groundColor
            goto cont
        end

        local formattedPoint = formatVec(pointWorld)
        local cachedPoint = groundColorCache[formattedPoint]

        if cachedPoint then
            returnColor = cachedPoint
            goto cont
        end

        local average_r = 0
        local average_g = 0
        local average_b = 0

        local div = 1
        local x, y = -1, -1

        for _ = 1, 25 do
            local fColor

            if sm_terrainpp_getColorAt and type == "terrainSurface" then
                fColor = sm_terrainpp_getColorAt(x + pointWorld.x, y + pointWorld.y) or groundColor
            else
                fColor = materialsTable[sm_physics_getGroundMaterial(sm_vec3_new(x, y, 0) + pointWorld)] or groundColor
            end

            average_r = average_r + fColor.r
            average_g = average_g + fColor.g
            average_b = average_b + fColor.b

            div = div + 1

            x = x + 0.5

            if x == 1.5 then
                y = y + 0.5
                x = -1
            end
        end

        local new = sm_color_new(average_r / div, average_g / div, average_b / div)
        groundColorCache[formattedPoint] = new

        returnColor = new
    elseif type == "body" then
        returnColor = raycastResult:getShape().color
    elseif type == "joint" then
        returnColor = raycastResult:getJoint().color
    elseif userdataColors[type] then
        returnColor = userdataColors[type]
    end

    ::cont::

    if advanced then
        returnColor = applySunShader(raycastResult, returnColor, sm_game_getTimeOfDay())
    end

    return returnColor
end

local function getUserdata(raycastResult)
    return raycastResult:getShape() or raycastResult:getCharacter() or raycastResult:getHarvestable() or raycastResult:getJoint() or nil
end

local function makeSafe(result)
    local userData = getUserdata(result)
    local color = userData and userData:getColor()
    local material = result.type == "terrainSurface" or result.type == "terrainAsset" and sm.physics.getGroundMaterial(result.pointWorld)

    return {
        directionWorld = result.directionWorld,
        fraction = result.fraction,
        normalLocal = result.normalLocal,
        normalWorld = result.normalWorld,
        originWorld = result.originWorld,
        pointLocal = result.pointLocal,
        pointWorld = result.pointWorld,
        type = result.type,
        valid = result.valid,
        material = material,
        color = color
    }
end

-- SERVER --

function CameraClass:sv_createData()
    return {
        ---Takes a frame and draws it.
        ---@param display Display The display to draw it on
        ---@param width integer? The width of the frame
        ---@param height integer? The height of the frame
        frame = function(display, width, height)
            sm_scrapcomputers_errorHandler_assertArgument(display, 1, {"table"}, {"Display"})
            sm_scrapcomputers_errorHandler_assertArgument(width, 2, {"integer", "nil"})
            sm_scrapcomputers_errorHandler_assertArgument(height, 3, {"integer", "nil"})

            local width1, height1 = display.getDimensions()

            width = width  or width1
            height = height or height1

            local displayId = display.getId()

            if not sm.scrapcomputers.backend.cameraColorCache[displayId] and not self.sv.forced[displayId] then
                self.sv.forced[displayId] = true
                sm.scrapcomputers.backend.cameraColorCache[displayId] = true
            end

            local rays, coordinateTbl = self:sv_computeFrameRays(width, height)

            self:sv_simpleDraw(rays, coordinateTbl, display.getOptimizationThreshold(), width, height, displayId, sm.scrapcomputers.backend.displayCameraDraw[displayId])
        end,

        ---Takes a frame and draws it. (Designed for video)
        ---@param display    Display The display to draw it on
        ---@param sliceWidth integer                The slice width. The bigger, the faster it is to render a frame but with more performance lost.
        ---@param width      integer?               The width of the video
        ---@param height     integer?               The height of the video
        video = function(display, sliceWidth, width, height)
            sm_scrapcomputers_errorHandler_assertArgument(display, 1, {"table"}, {"Display"})
            sm_scrapcomputers_errorHandler_assertArgument(sliceWidth, 2, {"integer"})
            sm_scrapcomputers_errorHandler_assertArgument(width, 3, {"integer", "nil"})
            sm_scrapcomputers_errorHandler_assertArgument(height, 4, {"integer", "nil"})

            local width1, height1 = display.getDimensions()

            width = width or width1
            height = height or height1

            local displayId = display.getId()

            if not sm.scrapcomputers.backend.cameraColorCache[displayId] and not self.sv.forced[displayId] then
                self.sv.forced[displayId] = true
                sm.scrapcomputers.backend.cameraColorCache[displayId] = true
            end

            if sliceWidth ~= self.sv.lastSliceWidth then
                self.sv.lastSliceWidth = sliceWidth
                self.sv.screenSection = 0
                sm.scrapcomputers.backend.cameraColorCache[displayId] = nil
                
                self:sv_clearCache()
            end

            local threshold = display.getOptimizationThreshold()

            local rays, coordinateTbl = self:sv_computeVideoRays(sliceWidth, width, height)
            self:sv_simpleDraw(rays, coordinateTbl, threshold, width, height, displayId, sm.scrapcomputers.backend.displayCameraDraw[displayId])
        end,

        ---Takes a frame and draws it. (Has shadows)
        ---@param display Display The display to draw it on
        ---@param width integer? The width of the frame
        ---@param height integer? The height of the frame
        advancedFrame = function(display, width, height)
            sm_scrapcomputers_errorHandler_assertArgument(display, 1, {"table"}, {"Display"})
            sm_scrapcomputers_errorHandler_assertArgument(width, 2, {"integer", "nil"})
            sm_scrapcomputers_errorHandler_assertArgument(height, 3, {"integer", "nil"})

            local width1, height1 = display.getDimensions()

            width = width or width1
            height = height or height1

            local displayId = display.getId()

            if not sm.scrapcomputers.backend.cameraColorCache[displayId] and not self.sv.forced[displayId] then
                self.sv.forced[displayId] = true
                sm.scrapcomputers.backend.cameraColorCache[displayId] = true
            end

            local rays, coordinateTbl = self:sv_computeFrameRays (width, height)
            local pixels = self:sv_advancedDraw(rays, coordinateTbl, display.getOptimizationThreshold(), width, height, displayId, sm.scrapcomputers.backend.displayCameraDraw[displayId])

            if #pixels > 0 then
                display.drawFromTable(pixels)
            end
        end,

        ---Takes a frame and draws it. (Designed for video & Has shadows)
        ---@param display    Display The display to draw it on
        ---@param sliceWidth integer                The slice width. The bigger, the faster it is to render a frame but with more performance lost.
        ---@param width      integer?               The width of the video
        ---@param height     integer?               The height of the video
        advancedVideo = function(display, sliceWidth, width, height)
            sm_scrapcomputers_errorHandler_assertArgument(display, 1, {"table"}, {"Display"})
            sm_scrapcomputers_errorHandler_assertArgument(sliceWidth, 2, {"integer"})
            sm_scrapcomputers_errorHandler_assertArgument(width, 3, {"integer", "nil"})
            sm_scrapcomputers_errorHandler_assertArgument(height, 4, {"integer", "nil"})

            local width1, height1 = display.getDimensions()

            width = width  or width1
            height = height or height1

            local displayId = display.getId()

            if not sm.scrapcomputers.backend.cameraColorCache[displayId] and not self.sv.forced[displayId] then
                self.sv.forced[displayId] = true
                sm.scrapcomputers.backend.cameraColorCache[displayId] = true
            end

            if sliceWidth ~= self.sv.lastSliceWidth then
                self.sv.lastSliceWidth = sliceWidth
                self.sv.screenSection = 0
                sm.scrapcomputers.backend.cameraColorCache[displayId] = nil
                
                self:sv_clearCache()
            end

            local thershold = display.getOptimizationThreshold()

            local rays, coordinateTbl = self:sv_computeVideoRays(sliceWidth, width, height)
            self:sv_advancedDraw(rays, coordinateTbl, thershold, width, height, displayId, sm.scrapcomputers.backend.displayCameraDraw[displayId])
        end,

        ---Takes a frame and draws it. This allows you to use a custom drawer if you want to modify how the result looks like
        ---@param display Display The display to draw it on
        ---@param drawer  function               The masked string
        ---@param width   integer?               The width of the frame
        ---@param height  integer?               The height of the frame
        customFrame = function(display, drawer, width, height)
            sm_scrapcomputers_errorHandler_assertArgument(display, 1, {"table"}, {"Display"})
            sm_scrapcomputers_errorHandler_assertArgument(drawer, 2, {"function"}, {"Drawer"})
            sm_scrapcomputers_errorHandler_assertArgument(width, 3, {"integer", "nil"})
            sm_scrapcomputers_errorHandler_assertArgument(height, 4, {"integer", "nil"})

            local width1, height1 = display.getDimensions()

            width = width  or width1
            height = height or height1

            local displayId = display.getId()

            if not sm.scrapcomputers.backend.cameraColorCache[displayId] and not self.sv.forced[displayId] then
                self.sv.forced[displayId] = true
                sm.scrapcomputers.backend.cameraColorCache[displayId] = true
            end

            local rays, coordinateTbl = self:sv_computeFrameRays (width, height)
            self:sv_customDraw(rays, coordinateTbl, drawer, display.getOptimizationThreshold(), width, height, displayId, sm.scrapcomputers.backend.displayCameraDraw[displayId])
        end,

        ---Takes a frame and draws it. This allows you to use a custom drawer if you want to modify how the result looks like
        ---@param display Display The display to draw it on
        ---@param drawer  function               The masked string
        ---@param sliceWidth integer             The slice width. The bigger, the faster it is to render a frame but with more performance lost.
        ---@param width   integer?               The width of the frame
        ---@param height  integer?               The height of the frame
        customVideo = function(display, drawer, sliceWidth, width, height)
            sm_scrapcomputers_errorHandler_assertArgument(display, 1, {"table"}, {"Display"})
            sm_scrapcomputers_errorHandler_assertArgument(drawer, 2, {"function"}, {"Drawer"})
            sm_scrapcomputers_errorHandler_assertArgument(sliceWidth, 3, {"integer"})
            sm_scrapcomputers_errorHandler_assertArgument(width, 4, {"integer", "nil"})
            sm_scrapcomputers_errorHandler_assertArgument(height, 5, {"integer", "nil"})

            local width1, height1 = display.getDimensions()

            width = width  or width1
            height = height or height1

            local displayId = display.getId()

            if not sm.scrapcomputers.backend.cameraColorCache[displayId] and not self.sv.forced[displayId] then
                self.sv.forced[displayId] = true
                sm.scrapcomputers.backend.cameraColorCache[displayId] = true
            end

            if sliceWidth ~= self.sv.lastSliceWidth then
                self.sv.lastSliceWidth = sliceWidth
                self.sv.screenSection = 0
                sm.scrapcomputers.backend.cameraColorCache[displayId] = nil

                self:sv_clearCache()
            end

            local rays, coordinateTbl = self:sv_computeVideoRays(sliceWidth, width, height)
            self:sv_customDraw(rays, coordinateTbl, drawer, display.getOptimizationThreshold(), width, height, displayId, sm.scrapcomputers.backend.displayCameraDraw[displayId])
        end,

        ---Takes a depth frame and draws it.
        ---@param display Display The display to draw it on
        ---@param focalLength number The focal length
        ---@param width integer? The width of the frame
        ---@param height integer? The height of the frame
        depthFrame = function(display, focalLength, width, height)
            sm_scrapcomputers_errorHandler_assertArgument(display, 1, {"table"}, {"Display"})
            sm_scrapcomputers_errorHandler_assertArgument(focalLength, 2, {"integer"})
            sm_scrapcomputers_errorHandler_assertArgument(width, 3, {"integer", "nil"})
            sm_scrapcomputers_errorHandler_assertArgument(height, 4, {"integer", "nil"})

            local width1, height1 = display.getDimensions()

            width = width  or width1
            height = height or height1

            local rays, coordinateTbl = self:sv_computeFrameRays(width, height)
            self:sv_drawDepthFrame(rays, coordinateTbl, focalLength, width, height, sm.scrapcomputers.backend.displayCameraDraw[displayId])
        end,

        ---Takes a masked frame and draws it.
        ---@param display Display The display to draw it on
        ---@param mask string The masked string
        ---@param width integer? The width of the frame
        ---@param height integer? The height of the frame
        maskedFrame = function(display, mask, width, height)
            sm_scrapcomputers_errorHandler_assertArgument(display, 1, {"table"}, {"Display"})
            sm_scrapcomputers_errorHandler_assertArgument(mask, 2, {"string", "table"})
            sm_scrapcomputers_errorHandler_assertArgument(width, 3, {"integer", "nil"})
            sm_scrapcomputers_errorHandler_assertArgument(height, 4, {"integer", "nil"})

            local width1, height1 = display.getDimensions()

            width = width  or width1
            height = height or height1

            if type(mask) == "table" then
                for index, str in pairs(mask) do
                    local strType = type(str)

                    assert(strType == "string", "Bad frame mask value at index #"..index..". Expected string, got "..strType.." instead!")
                end
            end

            local rays, coordinateTbl = self:sv_computeFrameRays(width, height)
            self:sv_drawMaskedFrame(rays, coordinateTbl, mask, width, height, sm.scrapcomputers.backend.displayCameraDraw[displayId])
        end,

        -- Sets the range, The bigger. the further you can see
        ---@param range integer The range to set it to
        setRange = function(range)
            sm_scrapcomputers_errorHandler_assertArgument(range, nil, {"integer"})
            assert(range > 0, "bad argument #1, range must be above 0")

            self.sv.range = range
            self:sv_clearCache()
        end,

        -- Sets the shadow range. The bigger the range, the further away that shadows are able to be recognised from things blocking the sun at a cost of performance.
        ---@param range integer The range to set it to
        setShadowRange = function(range)
            sm_scrapcomputers_errorHandler_assertArgument(range, nil, {"integer"})
            assert(range > 0, "bad argument #1, range must be above 0")

            self.sv.shadowRange = range
            self:sv_clearCache()
        end,

        ---Sets the FOV
        ---@param fov integer The FOV to set it to
        setFov = function(fov)
            sm_scrapcomputers_errorHandler_assertArgument(fov, nil, {"integer"})
            assert(fov > 0 and fov <= 120, "bad argument #1, fov out of range")

            self.sv.fov = math.rad(fov)
            self:sv_clearCache()
        end,

        ---The x position it would be rendered at
        ---@param xOffset integer
        setOffsetX = function(xOffset)
            sm_scrapcomputers_errorHandler_assertArgument(xOffset, nil, {"integer"})

            self.sv.xOffset = xOffset
            self:sv_clearCache()
        end,

        --The y position it would be rendered at
        ---@param yOffset integer
        setOffsetY = function(yOffset)
            sm_scrapcomputers_errorHandler_assertArgument(yOffset, nil, {"integer"})

            self.sv.yOffset = yOffset
            self:sv_clearCache()
        end,

        --Sets the raycast filter used by the camera
        ---@param raycastFilter integer
        setFilter = function(raycastFilter)
            sm_scrapcomputers_errorHandler_assertArgument(raycastFilter, nil, {"integer"})

            self.sv.raycastFilter = raycastFilter
            self:sv_clearCache()
        end
    }
end

function CameraClass:server_onCreate()
    self.sv = {
        sliceIndex = 1,

        range = 250,
        shadowRange = 100,
        fov = math.rad(90),
        xOffset = 0,
        yOffset = 0,

        raycastPreCache = {},
        cachedCoordinates = {},
        cachedColors = {},
        cachedShadows = {},

        screenSection = 0,
        raycastFilter = sm.physics.filter.all,

        forced = {}
    }

    sm.scrapcomputers.powerManager.updatePowerInstance(self.shape.id, 1)
end

function CameraClass:server_onFixedUpdate()
    local pos = self.shape.worldPosition
    local rot = self.shape.worldRotation

    if self.sv.lastPos ~= pos then
        self.sv.lastPos = pos

        self:sv_clearCache()
    end

    if self.sv.lastRot ~= rot then
        self.sv.lastRot = rot

        self:sv_clearCache()
    end

    for displayId in pairs(self.sv.forced) do
        if not sm.scrapcomputers.backend.cameraColorCache[displayId] then
            self.sv.cachedColors[displayId] = {}
            self.sv.forced[displayId] = nil
        end
    end
end


function CameraClass:sv_computeFrameRays(width, height)
    local rayTbl = {}
    local coordinateTbl = {}

    local aspectRatio = width / height

    local position = self.shape.worldPosition
    local rotation = self.shape.worldRotation

    local tanHalfFovX = math.tan(self.sv.fov / 2)
    local tanHalfFovY = tanHalfFovX / aspectRatio

    local x, y = 1, 1
    local range = self.sv.range
    local filter = self.sv.raycastFilter
    local type = "ray"

    for i = 1, width * height do
        local x1 = (2 * (x - 0.5) / width - 1) * tanHalfFovX
        local y1 = (2 * (y - 0.5) / height - 1) * tanHalfFovY

        local direction = rotation * sm_vec3_normalize(sm_vec3_new(-x1, -y1, 1))

        rayTbl[i] = {
            type = type,
            startPoint = position,
            endPoint = position + direction * range,
            mask = filter,
        }

        coordinateTbl[i] = {x, y}

        x = x + 1

        if x > width then
            y = y + 1
            x = 1
        end
    end

    return sm.physics.multicast(rayTbl), coordinateTbl
end

function CameraClass:sv_computeVideoRays(sliceWidth, width, height)
    if width ~= self.sv.lastWidth then
        self.sv.lastWidth = width
        self:sv_clearCache()
    end

    if height ~= self.sv.lastHeight then
        self.sv.lastHeight = height
        self:sv_clearCache()
    end

    self.sv.screenSection = self.sv.screenSection % (width / sliceWidth) + 1

    if self.sv.raycastPreCache[self.sv.screenSection] then
        return sm.physics.multicast(self.sv.raycastPreCache[self.sv.screenSection]), self.sv.cachedCoordinates[self.sv.screenSection]
    end

    local rays = {}
    local coordinateTbl = {}

    local aspectRatio = width / height
    local position = self.shape.worldPosition
    local rotation = self.shape.worldRotation

    local tanHalfFovX = math.tan(self.sv.fov / 2)
    local tanHalfFovY = tanHalfFovX / aspectRatio
    local range = self.sv.range

    local filter = self.sv.raycastFilter
    local type = "ray"
    local sliceIndex = self.sv.sliceIndex

    local x, y = 1, 1

    for i = 1, sliceWidth * height do
        local x1 = (2 * (sliceIndex + x - 1.5) / width - 1) * tanHalfFovX
        local y1 = (2 * (y - 0.5) / height - 1) * tanHalfFovY

        local direction = sm_vec3_normalize(rotation * sm_vec3_new(-x1, -y1, 1))

        rays[i] = {
            type = type,
            startPoint = position,
            endPoint = position + direction * range,
            mask = filter
        }

        coordinateTbl[i] = {sliceIndex + x - 1, y}

        x = x + 1

        if x > sliceWidth then
            x = 1
            y = y + 1
        end
    end

    self.sv.sliceIndex = self.sv.sliceIndex + sliceWidth
    if self.sv.sliceIndex > width then
        self.sv.sliceIndex = 1
    end

    self.sv.raycastPreCache[self.sv.screenSection] = rays
    self.sv.cachedCoordinates[self.sv.screenSection] = coordinateTbl

    return sm.physics.multicast(rays), coordinateTbl
end

-- DRAWERS --

function CameraClass:sv_simpleDraw(rays, coordinateTbl, threshold, width, height, displayId, drawPixel)
    local pixelCount = #rays
    local pixels = {}
    local timeModifier = darknessMap[math.floor(map(sm_game_getTimeOfDay(), 0, 1, 1, #darknessMap))]

    local defaultColor = getSkyColor()

    local xOffset = self.sv.xOffset
    local yOffset = self.sv.yOffset

    self.sv.cachedColors[displayId] = self.sv.cachedColors[displayId] or {}
    local cachedColors = self.sv.cachedColors[displayId]

    for i = 1, pixelCount do
        local data = rays[i]
        local hit, result = data[1], data[2]

        local color = defaultColor
        local normalModifier = 1

        if hit then
            if result.type ~= "limiter" then
                normalModifier = sm_vec3_dot(-sunDir, result.normalWorld) * 0.4 + 0.4
            end

            color = self:sv_getObjCol(result) * timeModifier * normalModifier
        end

        local coord = coordinateTbl[i]
        local x, y = coord[1] + xOffset, coord[2] + yOffset
        local coordIndex = coordinateToIndex(x, y, width)

        if not (cachedColors[coordIndex] and areColorsSimilar(cachedColors[coordIndex], color, threshold)) then
            drawPixel(x, y, color)
            cachedColors[coordIndex] = color
        end
    end

    self.sv.cachedColors[displayId] = cachedColors
end

function CameraClass:sv_advancedDraw(rays, coordinateTbl, threshold, width, height, displayId, drawPixel)
    local pixelCount = #rays

    self.sv.cachedColors[displayId] = self.sv.cachedColors[displayId] or {}
    self.sv.cachedShadows[displayId] = self.sv.cachedShadows[displayId] or {}

    cachedColors = self.sv.cachedColors[displayId]
    cachedShadows = self.sv.cachedShadows[displayId]

    local pointTbl = {}
    local shadowRays = {}

    local time = sm_game_getTimeOfDay()
    local timeModifier = darknessMap[math.floor(map(time, 0, 1, 1, #darknessMap))]
    local defaultColor = getSkyColor()

    local shadowRange = self.sv.shadowRange
    local xOffset = self.sv.xOffset
    local yOffset = self.sv.yOffset
    local filter = self.sv.raycastFilter
    local type = "ray"

    local tblIndex = 0

    for i = 1, pixelCount do
        local data = rays[i]
        local hit, result = data[1], data[2]
        local pointWorld = result.pointWorld
        local resultType = result.type
        local color = defaultColor
        local modifier = 1

        if hit then
            if resultType ~= "limiter" then
                modifier = sm_vec3_dot(-sunDir, result.normalWorld) * 0.3 + 0.5
            end

            color = self:sv_getObjCol(result, true) * timeModifier * modifier
         
            if (resultType == "terrainSurface" or resultType == "terrainAsset") and cachedShadows[formatVec(pointWorld)] then
                local coordinate = coordinateTbl[i]
                local x, y = coordinate[1] + xOffset, coordinate[2] + yOffset
                local coordIndex = coordinateToIndex(x, y, width)

                if not (cachedColors[coordIndex] and areColorsSimilar(cachedColors[coordIndex], color, threshold)) then
                    drawPixel(x, y, color)
                    cachedColors[coordIndex] = color
                end
            else
                tblIndex = tblIndex + 1
                pointTbl[tblIndex] = {point = pointWorld, color = color, index = i}

                local startPos = pointWorld + -sunDir * shadowRange

                shadowRays[tblIndex] = {
                    type = type,
                    startPoint = startPos,
                    endPoint = startPos + sunDir * shadowRange,
                    mask = filter,
                }
            end
        else
            local coordinate = coordinateTbl[i]
            local x, y = coordinate[1] + xOffset, coordinate[2] + yOffset
            local coordIndex = coordinateToIndex(x, y, width)

            local finalColor = applySunShader(result, color, time)

            if not (cachedColors[coordIndex] and areColorsSimilar(cachedColors[coordIndex], finalColor, threshold)) then
                drawPixel(x, y, finalColor)
                cachedColors[coordIndex] = finalColor
            end
        end
    end

    local shadowResults = sm.physics.multicast(shadowRays)

    for i = 1, tblIndex, 1 do
        local data = shadowResults[i]
        local hit, result = data[1], data[2]
        local pointWorld = result.pointWorld
        local pointData = pointTbl[i]
        local pointDataPoint = pointData.point
        local pointDataColor = pointData.color

        if hit and (pointWorld - pointDataPoint):length() > 0.05 then
            local type_ = pointData.type

            if type_ == "terrainSurface" or type_ == "terrainAsset" then
                cachedShadows[formatVec(pointDataPoint)] = true
            end

            pointDataColor = pointDataColor * shadowMult
        end

        local coordinate = coordinateTbl[pointData.index]
        local x, y = coordinate[1] + xOffset, coordinate[2] + yOffset
        local coordIndex = coordinateToIndex(x, y, width)

        if not (cachedColors[coordIndex] and areColorsSimilar(cachedColors[coordIndex], pointDataColor, threshold)) then
            drawPixel(x, y, pointDataColor)
            cachedColors[coordIndex] = pointDataColor
        end
    end

    self.sv.cachedColors[displayId] = cachedColors
    self.sv.cachedShadows[displayId] = cachedShadows
end

function CameraClass:sv_customDraw(rays, coordinateTbl, drawer, threshold, width, height, displayId, drawPixel)
    local xOffset = self.sv.xOffset
    local yOffset = self.sv.yOffset
    
    local pixelCount = #rays
    local isUnsafeENV = sm.scrapcomputers.config.getConfig("scrapcomputers.computer.safe_or_unsafe_env").selectedOption == 2
    
    self.sv.cachedColors[displayId] = self.sv.cachedColors[displayId] or {}
    local cachedColors = self.sv.cachedColors[displayId]

    local assert = assert

    for i = 1, pixelCount do
        local data = rays[i]
        local hit, result = data[1], data[2]

        local coordinates = coordinateTbl[i]
        local x, y = coordinates[1], coordinates[2]
        local coordIndex = coordinateToIndex(x, y, width)

        result = isUnsafeENV and result or makeSafe(result)

        local color = drawer(hit, result, x, y) or sm_color_new("000000")
        local colorType = type(color)

        assert(colorType == "Color", "Bad color value at "..x..", "..y..". Expected Color, got "..colorType.." instead!")

        if not (cachedColors[coordIndex] and areColorsSimilar(cachedColors[coordIndex], color, threshold)) then
            drawPixel(x + xOffset, y + yOffset, color)
            cachedColors[coordIndex] = color
        end
    end

    self.sv.cachedColors[displayId] = cachedColors
end

function CameraClass:sv_drawMaskedFrame(rays, coordinateTbl, mask, width, height, drawPixel)
    local pixelCount = #rays

    local defaultColor = sm_color_new("000000")
    local blackColor = sm_color_new("222222")
    local whiteColor = sm_color_new("ffffff")

    local range = self.sv.range
    local rangeFactor = range * 1.1
    local xOffset = self.sv.xOffset
    local yOffset = self.sv.xOffset

    for i = 1, pixelCount do
        local data = rays[i]
        local hit, result = data[1], data[2]

        local color = defaultColor

        if hit then
            if result.type ~= "limiter" then
                local modifier = sm_vec3_dot(-sunDir, result.normalWorld) * 0.6 + 0.6

                if type(mask) == "table" then
                    color = blackColor

                    for _, string in pairs(mask) do
                        if result.type == string then
                            color = whiteColor
                            break
                        end
                    end
                else
                    color = result.type == mask and whiteColor or blackColor
                end

                color = color * modifier * (1 - (result.fraction * range / rangeFactor))
            end
        end

        local coord = coordinateTbl[i]
        local x, y = coord[1] + xOffset, coord[2] + yOffset

        drawPixel(x, y, color)
    end
end

function CameraClass:sv_drawDepthFrame(rays, coordinateTbl, focalLength, width, height, drawPixel)
    local pixelCount = #rays
    local pixels = {}
    local defaultColor = sm_color_new("000000")
    local whiteColor = sm_color_new(1, 1, 1)

    local rangeFactor = self.sv.range * 1.1
    local div = focalLength / rangeFactor

    local xOffset = self.sv.xOffset
    local yOffset = self.sv.yOffset

    for i = 1, pixelCount do
        local data = rays[i]
        local hit, result = data[1], data[2]

        local color = defaultColor

        if hit and result.type ~= "limiter" then
            color = whiteColor * (1 - (result.fraction / div))
        end

        local coord = coordinateTbl[i]
        local x, y = coord[1] + xOffset, coord[2] + yOffset

        drawPixel(x, y, color)
    end

    return pixels
end

function CameraClass:sv_clearCache()
    self.sv.raycastPreCache = {}
    self.sv.cachedCoordinates = {}
end


sm.scrapcomputers.componentManager.toComponent(CameraClass, "Cameras", true, nil, true)
