local sm_scrapcomputers_errorHandler_assertArgument = sm.scrapcomputers.errorHandler.assertArgument
local sm_physics_getGroundMaterial = sm.physics.getGroundMaterial
local sm_vec3_new = sm.vec3.new
local sm_color_new = sm.color.new
local sm_physics_multicast = sm.physics.multicast
local sm_game_getTimeOfDay = sm.game.getTimeOfDay
local sm_vec3_normalize = sm.vec3.normalize
local sm_vec3_dot = sm.vec3.dot
local math_floor = math.floor
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
local groundMaterialCache = {}
local cachedShadows = {}
local serverColorCache = {}

local function formatVec(vec3)
    return math_floor(vec3.x) + (math_floor(vec3.y) * 3000)
end

local function coordinateToIndex(x, y, width)
    return (y - 1) * width + x
end

local function colorToID(color)
    local scale = 255
    return bit_bor(bit_lshift(math_floor(color.r * scale), 16), bit_lshift(math_floor(color.g * scale), 8), math_floor(color.b * scale))
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
    if color1 == color2 then return true end

    local dr = math_floor(color1 / 65536) - math_floor(color2 / 65536)
    local dg = (math_floor(color1 / 256) % 256) - (math_floor(color2 / 256) % 256)
    local db = (color1 % 256) - (color2 % 256)

    return dr * dr + dg * dg + db * db <= (threshold * 255) ^ 2 * 3
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

local function getObjCol(raycastResult, advanced)
    local skyColor = getSkyColor()

    if not raycastResult then
        return skyColor
    end

    local pointWorld = raycastResult.pointWorld
    local pkey = formatVec(pointWorld)

    local rtype = raycastResult.type
    local material = groundMaterialCache[pkey]

    if not material then
        material = sm_physics_getGroundMaterial(pointWorld)
        groundMaterialCache[pkey] = material
    end

    local returnColor = skyColor

    -- TERRAIN
    if rtype == "terrainSurface" or rtype == "terrainAsset" then
        local materialsTable =
            (rtype == "terrainSurface") and groundMaterials or assetMaterials

        local groundColor = materialsTable[material]
        if not groundColor then
            returnColor = skyColor
        elseif not advanced then
            returnColor = groundColor
        else
            local cached = groundColorCache[pkey]
            if cached then
                returnColor = cached
            else
                local ar, ag, ab = 0, 0, 0
                local count = 0

                local x, y = -1, -1

                for _ = 1, 25 do
                    local fColor

                    if sm_terrainpp_getColorAt and rtype == "terrainSurface" then
                        fColor = sm_terrainpp_getColorAt(
                            x + pointWorld.x,
                            y + pointWorld.y
                        ) or groundColor
                    else
                        local wp = sm_vec3_new(x, y, 0) + pointWorld
                        local k = formatVec(wp)

                        local m = groundMaterialCache[k]
                        if not m then
                            m = sm_physics_getGroundMaterial(wp)
                            groundMaterialCache[k] = m
                        end

                        fColor = materialsTable[m] or groundColor
                    end

                    ar = ar + fColor.r
                    ag = ag + fColor.g
                    ab = ab + fColor.b
                    count = count + 1

                    x = x + 0.5
                    if x == 1.5 then
                        x = -1
                        y = y + 0.5
                    end
                end

                local avg = sm_color_new(ar / count, ag / count, ab / count)
                groundColorCache[pkey] = avg
                returnColor = avg
            end
        end

    -- BODY
    elseif rtype == "body" then
        returnColor = raycastResult:getShape().color

    -- JOINT
    elseif rtype == "joint" then
        returnColor = raycastResult:getJoint().color

    -- OTHER USERDATA
    else
        local ucol = userdataColors[rtype]
        if ucol then
            returnColor = ucol
        end
    end

    if advanced then
        return applySunShader(
            raycastResult,
            returnColor,
            sm_game_getTimeOfDay()
        )
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

local function simpleDraw(rays, coordinateTbl, xOffset, yOffset, drawPixel, width, cacheTable, threshold, fromVD)
    local pixelCount = #rays
    local timeModifier = darknessMap[math.floor(map(sm_game_getTimeOfDay(), 0, 1, 1, #darknessMap))]
    local defaultColor = getSkyColor()

    for i = 1, pixelCount do
        local data = rays[i]
        local hit, result = data[1], data[2]
        local color = defaultColor
        local normalModifier = 1

        if hit then
            if result.type ~= "limiter" then
                normalModifier = sm_vec3_dot(-sunDir, result.normalWorld) * 0.4 + 0.4
            end

            color = getObjCol(result) * timeModifier * normalModifier
        end

        local coord = coordinateTbl[i]
        local x, y = coord[1] + xOffset, coord[2] + yOffset
        local index = (y - 1) * width + x
        local dColor = cacheTable[index]
        local cColor = colorToID(color)

        if not dColor or not areColorsSimilar(dColor, cColor, threshold) then
            drawPixel(x, y, cColor)

            if fromVD then
                cacheTable[index] = cColor
            end
        end
    end
end

local function advancedDraw(rays, coordinateTbl, xOffset, yOffset, drawPixel, width, cacheTable, threshold, shadowRange, filter, fromVD)
    local pixelCount = #rays
    local pointTbl = {}
    local shadowRays = {}
    local time = sm_game_getTimeOfDay()
    local timeModifier = darknessMap[math.floor(map(time, 0, 1, 1, #darknessMap))]
    local defaultColor = getSkyColor()
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

            color = getObjCol(result, true) * timeModifier * modifier
         
            if (resultType == "terrainSurface" or resultType == "terrainAsset") and cachedShadows[formatVec(pointWorld)] then
                color = color * shadowMult

                local coordinate = coordinateTbl[i]
                local x, y = coordinate[1] + xOffset, coordinate[2] + yOffset
                local coordIndex = coordinateToIndex(x, y, width)
                local dColor = cacheTable[coordIndex]
                local cColor = colorToID(color)

                if not dColor or not areColorsSimilar(dColor, cColor, threshold) then
                    drawPixel(x, y, cColor)

                    if fromVD then
                        cacheTable[coordIndex] = cColor
                    end
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
            local dColor = cacheTable[coordIndex]
            local cColor = colorToID(finalColor)

            if not dColor or not areColorsSimilar(dColor, cColor, threshold) then
                drawPixel(x, y, cColor)

                if fromVD then
                    cacheTable[coordIndex] = cColor
                end
            end
        end
    end

    local shadowResults = sm_physics_multicast(shadowRays)

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
        local dColor = cacheTable[coordIndex]
        local cColor = colorToID(pointDataColor)

        if not dColor or not areColorsSimilar(dColor, cColor, threshold) then
            drawPixel(x, y, cColor)

            if fromVD then
                cacheTable[coordIndex] = cColor
            end
        end
    end
end

sm.scrapcomputers.backend.cameraVideoHooks = sm.scrapcomputers.backend.cameraVideoHooks or {}
sm.scrapcomputers.backend.cameraFrameHooks = sm.scrapcomputers.backend.cameraFrameHooks or {}

-- SERVER --

local bufferDodger = 0

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

            width = width or width1
            height = height or height1

            local displayId = display.getId()

            if displayId > 0 then
                local rawAdd = sm.scrapcomputers.backend.displayRawAdd[displayId]

                if rawAdd then
                    rawAdd({101, bufferDodger, "frame", width, height, self.shape.id})
                    bufferDodger = bufferDodger + 1
                end
            else
                if not sm.scrapcomputers.backend.cameraColorCache[displayId] then
                    sm.scrapcomputers.backend.cameraColorCache[displayId] = true
                    self.sv.attachedDisplays[displayId] = true
                    serverColorCache[displayId] = {}
                end

                local rays, coordinateTbl = self:cl_sv_computeFrameRays(width, height)
                simpleDraw(rays, coordinateTbl, self.drawData.xOffset, self.drawData.yOffset, sm.scrapcomputers.backend.displayCameraDraw[displayId], width, serverColorCache[displayId], display.getOptimizationThreshold(), true)
            end
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

            if displayId > 0 then
                local rawAdd = sm.scrapcomputers.backend.displayRawAdd[displayId]

                if rawAdd then
                    rawAdd({101, bufferDodger, "advancedFrame", width, height, self.shape.id})
                    bufferDodger = bufferDodger + 1
                end
            else
                if not sm.scrapcomputers.backend.cameraColorCache[displayId] then
                    sm.scrapcomputers.backend.cameraColorCache[displayId] = true
                    self.sv.attachedDisplays[displayId] = true
                    serverColorCache[displayId] = {}
                end

                local rays, coordinateTbl = self:cl_sv_computeFrameRays(width, height)
                advancedDraw(rays, coordinateTbl, self.drawData.xOffset, self.drawData.yOffset, sm.scrapcomputers.backend.displayCameraDraw[displayId], width, serverColorCache[displayId], display.getOptimizationThreshold(), self.drawData.shadowRange, self.drawData.raycastFilter, true)
            end
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

            if not sm.scrapcomputers.backend.cameraColorCache[displayId] then
                sm.scrapcomputers.backend.cameraColorCache[displayId] = true
                self.sv.attachedDisplays[displayId] = true
                serverColorCache[displayId] = {}
            end

            local rays, coordinateTbl = self:cl_sv_computeFrameRays(width, height)
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

            local displayId = display.getId()

            if not sm.scrapcomputers.backend.cameraColorCache[displayId] then
                sm.scrapcomputers.backend.cameraColorCache[displayId] = true
                self.sv.attachedDisplays[displayId] = true
                serverColorCache[displayId] = {}
            end

            local range = self.drawData.range

            local function drawer(hit, result, x, y)
                if hit then
                    return sm.color.new(1, 1, 1) * (focalLength / range / result.fraction)
                end

                return sm.color.new("000000")
            end

            local rays, coordinateTbl = self:cl_sv_computeFrameRays(width, height)
            self:sv_customDraw(rays, coordinateTbl, drawer, display.getOptimizationThreshold(), width, height, displayId, sm.scrapcomputers.backend.displayCameraDraw[displayId])
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

            local displayId = display.getId()

            if not sm.scrapcomputers.backend.cameraColorCache[displayId] then
                sm.scrapcomputers.backend.cameraColorCache[displayId] = true
                self.sv.attachedDisplays[displayId] = true
                serverColorCache[displayId] = {}
            end

            local defaultColor = sm_color_new("000000")
            local blackColor = sm_color_new("222222")
            local whiteColor = sm_color_new("ffffff")
            local range = self.drawData.range
            local rangeFactor = range * 1.1

            local drawer = function(hit, result, x, y)
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

                return color
            end

            local rays, coordinateTbl = self:cl_sv_computeFrameRays(width, height)
            self:sv_customDraw(rays, coordinateTbl, drawer, display.getOptimizationThreshold(), width, height, displayId, sm.scrapcomputers.backend.displayCameraDraw[displayId])
        end,

        ---Draws a video to the given display.
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

            if displayId > 0 then
                local rawAdd = sm.scrapcomputers.backend.displayRawAdd[displayId]

                if rawAdd then
                    rawAdd({100, bufferDodger, "video", sliceWidth, width, height, self.shape.id})
                    bufferDodger = bufferDodger + 1
                end
            else
                if not sm.scrapcomputers.backend.cameraColorCache[displayId] then
                    sm.scrapcomputers.backend.cameraColorCache[displayId] = true
                    self.sv.attachedDisplays[displayId] = true
                    serverColorCache[displayId] = {}
                end

                if sliceWidth ~= self.sv.lastSliceWidth then
                    self.lastSliceWidth = sliceWidth
                    self.screenSection = 0

                    self:cl_sv_clearCache()
                end

                local rays, coordinateTbl = self:cl_sv_computeVideoRays(sliceWidth, width, height, displayId)
                simpleDraw(rays, coordinateTbl, self.drawData.xOffset, self.drawData.yOffset, sm.scrapcomputers.backend.displayCameraDraw[displayId], width, serverColorCache[displayId], display.getOptimizationThreshold(), true)
            end
        end,

        ---Draws a video to the given display.
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

            width = width or width1
            height = height or height1

            local displayId = display.getId()

            if displayId > 0 then
                local rawAdd = sm.scrapcomputers.backend.displayRawAdd[displayId]

                if rawAdd then
                    rawAdd({100, bufferDodger, "advancedVideo", sliceWidth, width, height, self.shape.id})
                    bufferDodger = bufferDodger + 1
                end
            else
                if not sm.scrapcomputers.backend.cameraColorCache[displayId] then
                    sm.scrapcomputers.backend.cameraColorCache[displayId] = true
                    self.sv.attachedDisplays[displayId] = true
                    serverColorCache[displayId] = {}
                end

                if sliceWidth ~= self.sv.lastSliceWidth then
                    self.lastSliceWidth = sliceWidth
                    self.screenSection = 0

                    self:cl_sv_clearCache()
                end

                local rays, coordinateTbl = self:cl_sv_computeVideoRays(sliceWidth, width, height, displayId)
                advancedDraw(rays, coordinateTbl, self.drawData.xOffset, self.drawData.yOffset, sm.scrapcomputers.backend.displayCameraDraw[displayId], width, serverColorCache[displayId], display.getOptimizationThreshold(), self.drawData.shadowRange, self.drawData.raycastFilter, true)
            end
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

            if not sm.scrapcomputers.backend.cameraColorCache[displayId] then
                sm.scrapcomputers.backend.cameraColorCache[displayId] = true
                self.sv.attachedDisplays[displayId] = true
                serverColorCache[displayId] = {}
            end

            if sliceWidth ~= self.sv.lastSliceWidth then
                self.lastSliceWidth = sliceWidth
                self.screenSection = 0

                self:cl_sv_clearCache()
            end

            local rays, coordinateTbl = self:cl_sv_computeVideoRays(sliceWidth, width, height, displayId)
            self:sv_customDraw(rays, coordinateTbl, drawer, display.getOptimizationThreshold(), width, height, displayId, sm.scrapcomputers.backend.displayCameraDraw[displayId])
        end,

        -- Sets the range, The bigger. the further you can see
        ---@param range integer The range to set it to
        setRange = function(range)
            sm_scrapcomputers_errorHandler_assertArgument(range, nil, {"integer"})
            assert(range > 0, "bad argument #1, range must be above 0")

            self.drawData.range = range
            self.sv.drawDataUpdate = true
        end,

        -- Sets the shadow range. The bigger the range, the further away that shadows are able to be recognised from things blocking the sun at a cost of performance.
        ---@param shadowRange integer The range to set it to
        setShadowRange = function(shadowRange)
            sm_scrapcomputers_errorHandler_assertArgument(range, nil, {"integer"})
            assert(range > 0, "bad argument #1, range must be above 0")

            self.drawData.shadowRange = shadowRange
            self.sv.drawDataUpdate = true
        end,

        ---Sets the FOV
        ---@param fov integer The FOV to set it to
        setFov = function(fov)
            sm_scrapcomputers_errorHandler_assertArgument(fov, nil, {"integer"})
            assert(fov > 0 and fov <= 120, "bad argument #1, fov out of range")

            self.drawData.fov = math.rad(fov)
            self.sv.drawDataUpdate = true
        end,

        ---The x position it would be rendered at
        ---@param xOffset integer
        setOffsetX = function(xOffset)
            sm_scrapcomputers_errorHandler_assertArgument(xOffset, nil, {"integer"})

            self.drawData.xOffset = xOffset
            self.sv.drawDataUpdate = true
        end,

        --The y position it would be rendered at
        ---@param yOffset integer
        setOffsetY = function(yOffset)
            sm_scrapcomputers_errorHandler_assertArgument(yOffset, nil, {"integer"})

            self.drawData.yOffset = yOffset
            self.sv.drawDataUpdate = true
        end,

        --Sets the raycast filter used by the camera
        ---@param raycastFilter integer
        setFilter = function(raycastFilter)
            sm_scrapcomputers_errorHandler_assertArgument(raycastFilter, nil, {"integer"})

            self.drawData.raycastFilter = raycastFilter
            self.sv.drawDataUpdate = true
        end
    }
end

function CameraClass:server_onCreate()
    self.drawData = {
        range = 250,
        shadowRange = 100,
        fov = math.rad(50),
        xOffset = 0,
        yOffset = 0,
        raycastFilter = sm.physics.filter.all,
    }

    self.rayData = {}

    self.sliceIndex = 1

    self.sv = {
        attachedDisplays = {}
    }

    sm.scrapcomputers.powerManager.updatePowerInstance(self.shape.id, 1)
end

function CameraClass:server_onFixedUpdate()
    self:cl_sv_checkShapeDelta()

    if self.sv.drawDataUpdate then
        self:cl_sv_clearCache()
        self.sv.drawDataUpdate = false

        self.network:sendToClients("cl_drawDataUpdate", self.drawData)
    end

    for displayId in pairs(self.sv.attachedDisplays) do
        if not sm.scrapcomputers.backend.cameraColorCache[displayId] then
            serverColorCache[displayId] = {}
            self.sv.attachedDisplays[displayId] = nil
        end
    end
end

function CameraClass:sv_customDraw(rays, coordinateTbl, drawer, threshold, width, height, displayId, drawPixel)
    local xOffset = self.drawData.xOffset
    local yOffset = self.drawData.xOffset
    
    local pixelCount = #rays
    local isUnsafeENV = sm.scrapcomputers.config.getConfig("scrapcomputers.computer.safe_or_unsafe_env").selectedOption == 2

    local assert = assert
    local localCache = serverColorCache[displayId]

    for i = 1, pixelCount do
        local data = rays[i]
        local hit, result = data[1], data[2]

        local coordinates = coordinateTbl[i]
        local x, y = coordinates[1], coordinates[2]
        local coordIndex = coordinateToIndex(x, y, width)

        result = isUnsafeENV and result or makeSafe(result)

        local color = drawer(hit, result, x, y) or sm_color_new("000000")
        local colorType = type(color)
        local cColor = colorToID(color)
        local dColor = localCache[coordIndex]

        assert(colorType == "Color", "Bad color value at "..x..", "..y..". Expected Color, got "..colorType.." instead!")

        if not dColor or not areColorsSimilar(dColor, cColor, threshold) then
            drawPixel(x + xOffset, y + yOffset, cColor)
            localCache[coordIndex] = cColor
        end
    end
end

-- CLIENT --

function CameraClass:client_onCreate()
    self.drawData = {
        range = 250,
        shadowRange = 100,
        fov = math.rad(50),
        xOffset = 0,
        yOffset = 0,
        raycastFilter = sm.physics.filter.all
    }

    self.rayData = {}
    self.cl = {}

    sm.scrapcomputers.backend.cameraVideoHooks[self.shape.id] = function(data, drawPixel, fullBuffer, threshold, displayId)
        local _, _type, sliceWidth, width, height = unpack(data)
        local xOffset, yOffset = self.drawData.xOffset, self.drawData.yOffset
        local rays, coordinateTbl = self:cl_sv_computeVideoRays(sliceWidth, width, height, displayId)

        if _type == "video" then
            simpleDraw(rays, coordinateTbl, xOffset, yOffset, drawPixel, width, fullBuffer, threshold)
        elseif _type == "advancedVideo" then
            advancedDraw(rays, coordinateTbl, xOffset, yOffset, drawPixel, width, fullBuffer, threshold, self.drawData.shadowRange, self.drawData.raycastFilter)
        end
    end

    sm.scrapcomputers.backend.cameraFrameHooks[self.shape.id] = function(data, drawPixel, fullBuffer, threshold, displayId)
        local _, _type, width, height = unpack(data)
        local xOffset, yOffset = self.drawData.xOffset, self.drawData.yOffset
        local rays, coordinateTbl = self:cl_sv_computeFrameRays(width, height)

        if _type == "frame" then
            simpleDraw(rays, coordinateTbl, xOffset, yOffset, drawPixel, width, fullBuffer, threshold)
        elseif _type == "advancedFrame" then
            advancedDraw(rays, coordinateTbl, xOffset, yOffset, drawPixel, width, fullBuffer, threshold, self.drawData.shadowRange, self.drawData.raycastFilter)
        end
    end
end

function CameraClass:client_onFixedUpdate()
    self:cl_sv_checkShapeDelta()
end

function CameraClass:cl_drawDataUpdate(tbl)
    self.drawData = tbl
    self:cl_sv_clearCache()
end

function CameraClass:cl_sv_checkShapeDelta()
    if self.shape.worldPosition ~= self.lastPos then
        self.lastPos = self.shape.worldPosition
        self:cl_sv_clearCache()
    end

    if self.shape.worldRotation ~= self.lastRot then
        self.lastRot = self.shape.worldRotation
        self:cl_sv_clearCache()
    end
end

function CameraClass:cl_sv_clearCache(displayId)
    if displayId then
        self.rayData[displayId].raycastPreCache = {}
        self.rayData[displayId].cachedCoordinates = {}
    else
        for _, data in pairs(self.rayData) do
            data.raycastPreCache = {}
            data.cachedCoordinates = {}
        end
    end
end

-- CLIENT/SERVER --

function CameraClass:cl_sv_computeVideoRays(sliceWidth, width, height, displayId)
    if not self.rayData[displayId] then
        self.rayData[displayId] = {
            sliceIndex = 1,
            raycastPreCache = {},
            cachedCoordinates = {},
            cachedColors = {},
            cachedShadows = {},
            screenSection = 0,
            totalSlices = math.ceil(width / sliceWidth)
        }
    end

    local rayData = self.rayData[displayId]

    if width ~= rayData.lastWidth then
        rayData.lastWidth = width
        rayData.totalSlices = math.ceil(width / sliceWidth)
        self:cl_sv_clearCache(displayId)
    end

    if height ~= rayData.lastHeight then
        rayData.lastHeight = height
        self:cl_sv_clearCache(displayId)
    end

    rayData.screenSection = rayData.screenSection % rayData.totalSlices + 1

    if rayData.raycastPreCache[rayData.screenSection] then
        return sm_physics_multicast(rayData.raycastPreCache[rayData.screenSection]),
               rayData.cachedCoordinates[rayData.screenSection]
    end

    local rays = {}
    local coordinateTbl = {}

    local aspectRatio = width / height
    local position = self.shape.worldPosition + self.shape.up * 0.125
    local rotation = self.shape.worldRotation

    local tanHalfFovX = math.tan(self.drawData.fov / 2)
    local tanHalfFovY = tanHalfFovX / aspectRatio
    local range = self.drawData.range

    local filter = self.drawData.raycastFilter
    local type = "ray"

    local sliceStart = rayData.sliceIndex
    local sliceEnd = math.min(sliceStart + sliceWidth - 1, width)
    local actualSliceWidth = sliceEnd - sliceStart + 1

    local x, y = 1, 1

    for i = 1, actualSliceWidth * height do
        local screenX = sliceStart + x - 1

        local x1 = (2 * (screenX - 0.5) / width - 1) * tanHalfFovX
        local y1 = (2 * (y - 0.5) / height - 1) * tanHalfFovY

        local direction = sm_vec3_normalize(rotation * sm_vec3_new(-x1, -y1, 1))

        rays[i] = {
            type = type,
            startPoint = position,
            endPoint = position + direction * range,
            mask = filter
        }

        coordinateTbl[i] = { screenX, y }

        x = x + 1
        if x > actualSliceWidth then
            x = 1
            y = y + 1
        end
    end

    rayData.sliceIndex = rayData.sliceIndex + sliceWidth
    if rayData.sliceIndex > width then
        rayData.sliceIndex = 1
    end

    rayData.raycastPreCache[rayData.screenSection] = rays
    rayData.cachedCoordinates[rayData.screenSection] = coordinateTbl

    return sm_physics_multicast(rays), coordinateTbl
end


function CameraClass:cl_sv_computeFrameRays(width, height)
    local rayTbl = {}
    local coordinateTbl = {}

    local aspectRatio = width / height

    local position = self.shape.worldPosition + self.shape.up * 0.125
    local rotation = self.shape.worldRotation

    local tanHalfFovX = math.tan(self.drawData.fov / 2)
    local tanHalfFovY = tanHalfFovX / aspectRatio

    local x, y = 1, 1
    local range = self.drawData.range
    local filter = self.drawData.raycastFilter
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

    return sm_physics_multicast(rayTbl), coordinateTbl
end



sm.scrapcomputers.componentManager.toComponent(CameraClass, "Cameras", true, nil, true)
