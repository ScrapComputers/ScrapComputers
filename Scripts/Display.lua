dofile("$CONTENT_DATA/Scripts/Tools/Auto/PowerManager.lua")

local sm_scrapcomputers_ascfManager_applyDisplayFunctions = sm.scrapcomputers.ascfManager.applyDisplayFunctions
local sm_scrapcomputers_errorHandler_assertArgument = sm.scrapcomputers.errorHandler.assertArgument
local sm_scrapcomputers_errorHandler_assert = sm.scrapcomputers.errorHandler.assert
local sm_scrapcomputers_languageManager_translatable = sm.scrapcomputers.languageManager.translatable
local sm_scrapcomputers_fontManager_getFont = sm.scrapcomputers.fontManager.getFont
local sm_scrapcomputers_table_getTableSize = sm.scrapcomputers.table.getTableSize
local sm_scrapcomputers_utf8_getCharacterAt = sm.scrapcomputers.utf8.getCharacterAt
local sm_scrapcomputers_utf8_getStringSize = sm.scrapcomputers.utf8.getStringSize

local sm_effect_createEffect = sm.effect.createEffect
local shellEffect = sm_effect_createEffect("ShapeRenderable")
local effect_start = shellEffect.start
local effect_stop = shellEffect.stop
local effect_destroy = shellEffect.destroy
local effect_setScale = shellEffect.setScale
local effect_setParameter = shellEffect.setParameter
local effect_setOffsetPosition = shellEffect.setOffsetPosition
local effect_isPlaying = shellEffect.isPlaying
effect_destroy(shellEffect)

local sm_color_new = sm.color.new
local sm_vec3_new = sm.vec3.new
local sm_vec3_length = sm.vec3.length
local sm_vec3_dot = sm.vec3.dot
local sm_vec3_normalize = sm.vec3.normalize
local sm_exists = sm.exists
local sm_player_getAllPlayers = sm.player.getAllPlayers
local sm_util_clamp = sm.util.clamp
local sm_game_getCurrentTick = sm.game.getCurrentTick
local sm_physics_raycast = sm.physics.raycast

local bit_bor = bit.bor
local bit_band = bit.band
local bit_lshift = bit.lshift
local bit_rshift = bit.rshift

local math_floor = math.floor
local math_ceil = math.ceil
local math_sqrt = math.sqrt
local math_max = math.max
local math_min = math.min
local math_abs = math.abs

local string_byte = string.byte
local string_sub = string.sub

local table_sort = table.sort
local pairs = pairs

---@class DisplayClass : ShapeClass
DisplayClass = class()
DisplayClass.maxParentCount = -1
DisplayClass.maxChildCount = 0
DisplayClass.connectionInput = sm.interactable.connectionType.compositeIO
DisplayClass.connectionOutput = sm.interactable.connectionType.none
DisplayClass.colorNormal = sm_color_new(0x696969ff)
DisplayClass.colorHighlight = sm_color_new(0x969696ff)

-- CLIENT/SERVER --

sm.scrapcomputers.backend.displayCameraDraw = sm.scrapcomputers.backend.displayCameraDraw or {}
sm.scrapcomputers.backend.displayRawAdd = sm.scrapcomputers.backend.displayRawAdd or {}

local localPlayer = sm.localPlayer
local camera = sm.camera
local tinkerBind = sm.gui.getKeyBinding("Tinker", true)
local interactBind = sm.gui.getKeyBinding("Use", true)

local BACKPANEL_EFFECT_NAME = "ScrapComputers - ShapeRenderableBackPanel"
local effectPrefix = "ScrapComputers - ShapeRenderable"
local rePos = sm_vec3_new(0, 0, -10000)

local tableLimit = 15000
local displayHidingCooldown = 0.5
local optimiseCooldown = 1
local pixelBorderMultiplier = 0.05
local pixelEffect = "ScrapComputers - ShapeRenderablePixel"

local imagePath = "$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/DisplayImages/"

local networkInstructions = {
    "cl_takeSnapshot",
    "cl_setColorThreshold",
    "cl_setVisibility",
    "cl_setRenderDistance",
    "cl_setTouchState"
}

local function pixelPosToShapePos(x, y, widthScale, heightScale, pixelScaleY, pixelScaleZ)
    local v1 = pixelScaleZ
    local v2 = pixelScaleY

    return widthScale * -0.5 + v1 * 0.5 + 0.02 + x * v1, heightScale * -0.5 + v2 * 0.5 + 0.02 + y * v2
end

local function shapePosToPixelPos(point, widthScale, heightScale, pixelScaleY, pixelScaleZ)
    return 1 / pixelScaleZ * (point.z - 0.02 + widthScale / 2 - pixelScaleZ / 2) + 1, 1 / pixelScaleY * (point.y - 0.02 + heightScale / 2 - pixelScaleY / 2) + 1
end

local function round(numb)
    return math_floor(numb + 0.5)
end

local function coordinateToIndex(x, y, width)
    return (y - 1) * width + x
end

local function indexToCoordinate(index, width)
    return (index - 1) % width + 1, math_floor((index - 1) / width) + 1
end

local function clearTable(tbl)
    for i in pairs(tbl) do
        tbl[i] = nil
    end
end

local function splitTable(numbers, length)
    local numbLen = #numbers

    if numbLen <= length then
        return {numbers}
    end

    local result = {}
    local currentTable = {}
    local count = 0
    local resultIndex = 0

    for i = 1, numbLen do
        local num = numbers[i]

        count = count + 1
        currentTable[count] = num

        if count == length then
            resultIndex = resultIndex + 1
            result[resultIndex] = currentTable

            currentTable = {}
            count = 0
        end
    end

    if #currentTable > 0 then
        resultIndex = resultIndex + 1
        result[resultIndex] = currentTable
    end

    return result  
end

local inv255 = 1 / 255

local function colorToID(color) 
    local colorType = type(color)
    if colorType == "number" then 
        return color 
    elseif colorType == "string" then 
        local r = tonumber(string_sub(color, 1, 2), 16) or 0
        local g = tonumber(string_sub(color, 3, 4), 16) or 0
        local b = tonumber(string_sub(color, 5, 6), 16) or 0

        return bit_bor(bit_lshift(r, 16), bit_lshift(g, 8), b)
    elseif colorType == "Color" then
        local r = math_floor(color.r * 255)
        local g = math_floor(color.g * 255)
        local b = math_floor(color.b * 255)

        return bit_bor(bit_lshift(r, 16), bit_lshift(g, 8), b)
    end

    return 0
end

local function idToColor(colorID)
    local r = bit_rshift(colorID, 16)
    local g = bit_band(bit_rshift(colorID, 8), 255)
    local b = bit_band(colorID, 255)

    return sm_color_new(
        r * inv255,
        g * inv255,
        b * inv255
    )
end

local function areColorsSimilar(color1, color2, threshold)
    if color1 == color2 then return true end

    local dr = bit_rshift(color1, 16) - bit_rshift(color2, 16)
    local dg = bit_band(bit_rshift(color1, 8), 0xFF) - bit_band(bit_rshift(color2, 8), 0xFF)
    local db = bit_band(color1, 0xFF) - bit_band(color2, 0xFF)

    return dr * dr + dg * dg + db * db <= (threshold * 255) ^ 2 * 3
end

-- SERVER --

-- Creates all functions for the display
function DisplayClass:sv_createData()
    local shapeId = self.shape.id
    local clearCache = false
    local data = self.data
    local data_width = data.width
    local data_height = data.height
    local self_sv = self.sv
    local dataBuffer = self_sv.buffer.data
    local lastBuffer = self_sv.lastBuffer
    local dataIndex = 0

    self_sv.resetBuffer = function()
        for i = 1, dataIndex do
            dataBuffer[i] = nil
        end

        dataIndex = 0
    end

    -- Draw Circle function
    ---@param x number The center X coordinates
    ---@param y number The center Y coordinates
    ---@param radius number The radius of the circle
    ---@param color Color The color of the circle
    ---@param isFilled boolean If true, the circle is filled. else not.
    local function drawCricle(x, y, radius, color, isFilled)
        sm_scrapcomputers_errorHandler_assertArgument(x, 1, {"number"})
        sm_scrapcomputers_errorHandler_assertArgument(y, 2, {"number"})
        sm_scrapcomputers_errorHandler_assertArgument(radius, 3, {"number"})

        dataIndex = dataIndex + 1
        dataBuffer[dataIndex] = 4
        dataIndex = dataIndex + 1
        dataBuffer[dataIndex] = round(x)
        dataIndex = dataIndex + 1
        dataBuffer[dataIndex] = round(y)
        dataIndex = dataIndex + 1
        dataBuffer[dataIndex] = round(radius)
        dataIndex = dataIndex + 1
        dataBuffer[dataIndex] = colorToID(color)
        dataIndex = dataIndex + 1
        dataBuffer[dataIndex] = isFilled
    end

    ---Draw Triangle function
    ---@param x1 number The 1st point on X-axis
    ---@param y1 number The 1st point on Y-axis
    ---@param x2 number The 2nd point on X-axis
    ---@param y2 number The 2nd point on Y-axis
    ---@param x3 number The 3rd point on X-axis
    ---@param y3 number The 3rd point on Y-axis
    ---@param color Color The color of the triangle
    ---@param isFilled boolean If true, Triangle is filled. else its just 3 fucking lines.
    local function drawTriangle(x1, y1, x2, y2, x3, y3, color, isFilled)
        sm_scrapcomputers_errorHandler_assertArgument(x1, 1, {"number"})
        sm_scrapcomputers_errorHandler_assertArgument(y1, 2, {"number"})
        sm_scrapcomputers_errorHandler_assertArgument(x2, 3, {"number"})
        sm_scrapcomputers_errorHandler_assertArgument(y2, 4, {"number"})
        sm_scrapcomputers_errorHandler_assertArgument(x3, 5, {"number"})
        sm_scrapcomputers_errorHandler_assertArgument(y3, 6, {"number"})

        dataIndex = dataIndex + 1
        dataBuffer[dataIndex] = 5
        dataIndex = dataIndex + 1
        dataBuffer[dataIndex] = round(x1)
        dataIndex = dataIndex + 1
        dataBuffer[dataIndex] = round(y1)
        dataIndex = dataIndex + 1
        dataBuffer[dataIndex] = round(x2)
        dataIndex = dataIndex + 1
        dataBuffer[dataIndex] = round(y2)
        dataIndex = dataIndex + 1
        dataBuffer[dataIndex] = round(x3)
        dataIndex = dataIndex + 1
        dataBuffer[dataIndex] = round(y3)
        dataIndex = dataIndex + 1
        dataBuffer[dataIndex] = colorToID(color)
        dataIndex = dataIndex + 1
        dataBuffer[dataIndex] = isFilled
    end

    ---Draw Rectangle Function
    ---@param x number The x-coordinate
    ---@param y number The y-coordinate
    ---@param width number The width of the rectangle
    ---@param height number The height of the triangle
    ---@param color Color|string The color of the rectangle
    ---@param isFilled boolean If true, The rectangle is filled. else it will just draw 4 fucking lines.
    local function drawRect(x, y, width, height, color, isFilled)
        sm_scrapcomputers_errorHandler_assertArgument(x, 1, {"number"})
        sm_scrapcomputers_errorHandler_assertArgument(y, 2, {"number"})

        sm_scrapcomputers_errorHandler_assertArgument(width, 3, {"number"})
        sm_scrapcomputers_errorHandler_assertArgument(height, 4, {"number"})

        dataIndex = dataIndex + 1
        dataBuffer[dataIndex] = 6
        dataIndex = dataIndex + 1
        dataBuffer[dataIndex] = round(x)
        dataIndex = dataIndex + 1
        dataBuffer[dataIndex] = round(y)
        dataIndex = dataIndex + 1
        dataBuffer[dataIndex] = round(width)
        dataIndex = dataIndex + 1
        dataBuffer[dataIndex] = round(height)
        dataIndex = dataIndex + 1
        dataBuffer[dataIndex] = colorToID(color)
        dataIndex = dataIndex + 1
        dataBuffer[dataIndex] = isFilled
    end

    sm.scrapcomputers.backend.displayRawAdd[self.shape.id] = function (tbl)
        for i = 1, #tbl do
            dataIndex = dataIndex + 1
            dataBuffer[dataIndex] = tbl[i]
        end
    end

    sm.scrapcomputers.backend.displayCameraDraw[self.shape.id] = function (x, y, color)
        dataIndex = dataIndex + 1
        dataBuffer[dataIndex] = 1
        dataIndex = dataIndex + 1
        dataBuffer[dataIndex] = x
        dataIndex = dataIndex + 1
        dataBuffer[dataIndex] = y
        dataIndex = dataIndex + 1
        dataBuffer[dataIndex] = color
    end

    local display = {
        ---Draws a pixel
        ---@param x number
        ---@param y number
        ---@param color Color
        drawPixel = function (x, y, color)
            local typeX = type(x)
            local typeY = type(y)
            
            assert(typeX == "number", "Bad argument #1! Expected number, got "..typeX.." instead!")
            assert(typeY == "number", "Bad argument #2! Expected number, got "..typeY.." instead!")

            dataIndex = dataIndex + 1
            dataBuffer[dataIndex] = 1
            dataIndex = dataIndex + 1
            dataBuffer[dataIndex] = round(x)
            dataIndex = dataIndex + 1
            dataBuffer[dataIndex] = round(y)
            dataIndex = dataIndex + 1
            dataBuffer[dataIndex] = colorToID(color)

            clearCache = true
        end,

        ---Draws pixels from a table
        ---@param tbl PixelTable The table of pixels
        drawFromTable = function (tbl)
            sm_scrapcomputers_errorHandler_assertArgument(tbl, nil, {"table"}, {"PixelTable"})

            for i = 1, #tbl do
                local pixel = tbl[i]
                local pixel_x = pixel.x
                local pixel_y = pixel.y
                local pixel_color = pixel.color

                local xType = type(pixel_x)
                local yType = type(pixel_y)

                sm_scrapcomputers_errorHandler_assert(pixel_x and pixel_y and pixel_color, "missing data at index "..i)

                sm_scrapcomputers_errorHandler_assert(xType == "number", nil, "bad x value at index "..i..". Expected number. Got "..xType.." instead!")
                sm_scrapcomputers_errorHandler_assert(yType == "number", nil, "bad y value at index "..i..". Expected number. Got "..yType.." instead!")
            
                dataIndex = dataIndex + 1
                dataBuffer[dataIndex] = 1
                dataIndex = dataIndex + 1
                dataBuffer[dataIndex] = round(pixel_x)
                dataIndex = dataIndex + 1
                dataBuffer[dataIndex] = round(pixel_y)
                dataIndex = dataIndex + 1
                dataBuffer[dataIndex] = colorToID(pixel_color)
            end

            clearCache = true
        end,

        -- Clear the display
        ---@param color MultiColorType The new background color or 000000
        clear = function (color)
            local clearColor = colorToID(color)

            for i = 1, dataIndex do
                dataBuffer[i] = nil
            end

            dataBuffer[1] = 3
            dataBuffer[2] = clearColor
            dataIndex = 2

            self.sv.backPanel = clearColor

            clearCache = true
        end,

        -- Draws a line
        ---@param x number  -- The 1st point on x-axis
        ---@param y number  -- The 1st point on y-axis
        ---@param x1 number -- The 2nd point on x-axis
        ---@param y1 number -- The 2nd point on y-axis
        ---@param color MultiColorType The line's color
        drawLine = function (x, y, x1, y1, color)
            sm_scrapcomputers_errorHandler_assertArgument(x, 1, {"number"})
            sm_scrapcomputers_errorHandler_assertArgument(y, 2, {"number"})

            sm_scrapcomputers_errorHandler_assertArgument(x1, 3, {"number"})
            sm_scrapcomputers_errorHandler_assertArgument(y1, 4, {"number"})
            
            dataIndex = dataIndex + 1
            dataBuffer[dataIndex] = 2
            dataIndex = dataIndex + 1
            dataBuffer[dataIndex] = round(x)
            dataIndex = dataIndex + 1
            dataBuffer[dataIndex] = round(y)
            dataIndex = dataIndex + 1
            dataBuffer[dataIndex] = round(x1)
            dataIndex = dataIndex + 1
            dataBuffer[dataIndex] = round(y1)
            dataIndex = dataIndex + 1
            dataBuffer[dataIndex] = colorToID(color)

            clearCache = true
        end,

        -- Draws a circle
        ---@param x number The x-coordinate
        ---@param y number The y-coordinate
        ---@param radius number The radius of the circle
        ---@param color MultiColorType The color of the circle
        drawCircle = function (x, y, radius, color) 
            drawCricle(x, y, radius, color, false) 
            clearCache = true
        end,

        -- Draws a filled circle
        ---@param x number The x-coordinate
        ---@param y number The y-coordinate
        ---@param radius number The radius of the circle
        ---@param color MultiColorType The color of the circle
        drawFilledCircle = function (x, y, radius, color) 
            drawCricle(x, y, radius, color, true) 
            clearCache = true
        end,

        -- Draws a triangle
        ---@param x1 number The 1st point on X-axis
        ---@param y1 number The 1st point on Y-axis
        ---@param x2 number The 2nd point on X-axis
        ---@param y2 number The 2nd point on Y-axis
        ---@param x3 number The 3rd point on X-axis
        ---@param y3 number The 3rd point on Y-axis
        ---@param color MultiColorType The color of the triangle
        drawTriangle = function (x1, y1, x2, y2, x3, y3, color) 
            drawTriangle(x1, y1, x2, y2, x3, y3, color, false) 
            clearCache = true
        end,

        -- Draws a filled triangle
        ---@param x1 number The 1st point on X-axis
        ---@param y1 number The 1st point on Y-axis
        ---@param x2 number The 2nd point on X-axis
        ---@param y2 number The 2nd point on Y-axis
        ---@param x3 number The 3rd point on X-axis
        ---@param y3 number The 3rd point on Y-axis
        ---@param color MultiColorType The color of the triangle
        drawFilledTriangle = function (x1, y1, x2, y2, x3, y3, color) 
            drawTriangle(x1, y1, x2, y2, x3, y3, color, true) 
            clearCache = true
        end,

        -- Draws a rectangle
        ---@param x number The x-coordinate
        ---@param y number The y-coordinate
        ---@param width number The width of the rectangle
        ---@param height number The height of the triangle
        ---@param color MultiColorType The color of the rectangle
        drawRect = function (x, y, width, height, color) 
            drawRect(x, y, width, height, color, false) 
            clearCache = true
        end,

        -- Draws a filled rectangle
        ---@param x number The x-coordinate
        ---@param y number The y-coordinate
        ---@param width number The width of the rectangle
        ---@param height number The height of the triangle
        ---@param color MultiColorType The color of the rectangle
        drawFilledRect = function (x, y, width, height, color) 
            drawRect(x, y, width, height, color, true) 
            clearCache = true
        end,

        ---Draws text to the display
        ---@param x number The x-coordinate
        ---@param y number The y-coordinate
        ---@param text string The text to show
        ---@param color MultiColorType the color of the text
        ---@param fontName string? The name of the font to use
        ---@param maxWidth integer? The max width before it wraps around
        ---@param wordWrappingEnabled boolean? If it should do word wrapping or not
        drawText = function (x, y, text, color, fontName, maxWidth, wordWrappingEnabled)
            sm_scrapcomputers_errorHandler_assertArgument(x, 1, {"number"})
            sm_scrapcomputers_errorHandler_assertArgument(y, 2, {"number"})
            
            sm_scrapcomputers_errorHandler_assertArgument(fontName, 5, {"string", "nil"})

            sm_scrapcomputers_errorHandler_assertArgument(maxWidth, 5, {"integer", "nil"})
            sm_scrapcomputers_errorHandler_assertArgument(wordWrappingEnabled, 5, {"boolean", "nil"})
            
            fontName = fontName or sm.scrapcomputers.fontManager.getDefaultFontName()

            local font, errMsg = sm.scrapcomputers.fontManager.getFont(fontName)
            sm_scrapcomputers_errorHandler_assert(font, 5, errMsg)

            text = tostring(text)

            if text ~= "" then
                color = color or "EEEEEE"
                maxWidth = maxWidth or data_width
                wordWrappingEnabled = type(wordWrappingEnabled) == "boolean" and wordWrappingEnabled or true

                dataIndex = dataIndex + 1
                dataBuffer[dataIndex] = 7
                dataIndex = dataIndex + 1
                dataBuffer[dataIndex] = round(x)
                dataIndex = dataIndex + 1
                dataBuffer[dataIndex] = round(y)
                dataIndex = dataIndex + 1
                dataBuffer[dataIndex] = text
                dataIndex = dataIndex + 1
                dataBuffer[dataIndex] = colorToID(color)
                dataIndex = dataIndex + 1
                dataBuffer[dataIndex] = fontName
                dataIndex = dataIndex + 1
                dataBuffer[dataIndex] = maxWidth
                dataIndex = dataIndex + 1
                dataBuffer[dataIndex] = wordWrappingEnabled
            end

            clearCache = true
        end,

        ---Draws a shape based on coordinates given
        ---@param points PointTable The table of points
        ---@param color MultiColorType The color of the created shape
        drawWithPoints = function (points, color)
            sm_scrapcomputers_errorHandler_assertArgument(points, 1, {"table"}, {"PointTable"})

            local pointLength = #points
            sm_scrapcomputers_errorHandler_assert(pointLength <= 64, 1, "PointTable length larger than 64")
            sm_scrapcomputers_errorHandler_assert(pointLength % 2 == 0, 1, "PointTable length should be divisible by 2")

            for i = 1, pointLength do
                local coordinate = points[i]
                local coordinateType = type(coordinate)

                assert(coordinateType == "number", "bad value at index "..i..". Expected number. Got "..coordinateType.." instead!")
                points[i] = round(coordinate)
            end

            dataIndex = dataIndex + 1
            dataBuffer[dataIndex] = 8
            dataIndex = dataIndex + 1
            dataBuffer[dataIndex] = points
            dataIndex = dataIndex + 1
            dataBuffer[dataIndex] = colorToID(color)

            clearCache = true
        end,

        -- Draws an image to the display
        ---@param width integer The width of the display
        ---@param height integer The height of the display
        ---@param path string The max width before it wraps around
        ---@param customSearch boolean If the path is a custom path or not
        loadImage = function(width, height, path, customSearch)
            sm_scrapcomputers_errorHandler_assertArgument(width, 1, {"integer"})
            sm_scrapcomputers_errorHandler_assertArgument(height, 2, {"integer"})
            sm_scrapcomputers_errorHandler_assertArgument(path, 3, {"string"})

            local fileLocation = customSearch and path or imagePath..path
            sm_scrapcomputers_errorHandler_assert(sm.json.fileExists(fileLocation), 3, "Image doesnt exist")

            local imageTbl = sm.json.open(fileLocation)
            local x, y = 1, 1
            
            for i = 1, #imageTbl do
                local color = imageTbl[i]

                dataIndex = dataIndex + 1
                dataBuffer[dataIndex] = 1
                dataIndex = dataIndex + 1
                dataBuffer[dataIndex] = x
                dataIndex = dataIndex + 1
                dataBuffer[dataIndex] = y
                dataIndex = dataIndex + 1
                dataBuffer[dataIndex] = colorToID(color)

                y = y + 1

                if y > height then
                    y = 1
                    x = x + 1
                end
            end

            clearCache = true
        end,

        -- Calculates the text size
        ---@param text string The text to be calculated
        ---@param font string The font to use
        ---@param maxWidth integer? The max width before it wraps around
        ---@param wordWrappingEnabled boolean? If it should do word wrapping or not
        ---@param dynamicHeight boolean? If the height should be dynamic towards the actual text instead of the font's height. Only works if word wrapping is disabled
        ---@return number width The width of the text that it will use
        ---@return number height The height of the text that it will use
        calcTextSize = function (text, font, maxWidth, wordWrappingEnabled, dynamicHeight)
            sm_scrapcomputers_errorHandler_assertArgument(text, 1, {"string"})
            sm_scrapcomputers_errorHandler_assertArgument(font, 2, {"string", "nil"})
            sm_scrapcomputers_errorHandler_assertArgument(maxWidth, 1, {"integer", "nil"})
            sm_scrapcomputers_errorHandler_assertArgument(wordWrappingEnabled, 2, {"boolean", "nil"})

            font = font or sm.scrapcomputers.fontManager.getDefaultFontName()

            local trueFont, err = sm.scrapcomputers.fontManager.getFont(font)
            if not trueFont then
                error("Failed getting font! Error message: " .. err)
            end

            wordWrappingEnabled = type(wordWrappingEnabled) == "nil" and true or wordWrappingEnabled
            maxWidth            = maxWidth or self.data.width
            dynamicHeight       = type(dynamicHeight) == "nil" and false or dynamicHeight

            local stringSize = sm_scrapcomputers_utf8_getStringSize(text)

            if not wordWrappingEnabled then
                if dynamicHeight then
                    local height = 0
                    local index = 1
                    while index <= #text do
                        local char = sm_scrapcomputers_utf8_getCharacterAt(text, index)
                        local charset = trueFont.charset[char]

                        if charset and #charset > height then
                            height = #charset
                        end

                        index = index + #char
                    end

                    return stringSize * trueFont.fontWidth, height
                end

                return stringSize * trueFont.fontWidth, trueFont.fontHeight
            end

            local usedWidth = sm.util.clamp(stringSize * trueFont.fontWidth, 0, maxWidth)
            local usedHeight = (1 + math_floor((stringSize * trueFont.fontWidth) / maxWidth)) * trueFont.fontHeight

            return usedWidth, usedHeight
        end,

        -- Translates a world position to a 2D screen position
        ---@param cameraPosition Vec3 The cameras position in world space
        ---@param worldPosition Vec3 The target position in world space
        ---@return number|nil x The x coordinate
        ---@return number|nil y The y coordinate
        screenCoordinateFromWorldPosition = function(cameraPosition, worldPosition)
            sm_scrapcomputers_errorHandler_assertArgument(cameraPosition, 1, {"Vec3"})
            sm_scrapcomputers_errorHandler_assertArgument(worldPosition, 2, {"Vec3"})

            local screenNormal = self.shape.right
            local screenPos = self.shape.worldPosition + screenNormal * 0.125

            local rayDir = (worldPosition - cameraPosition):normalize()
            local denom = screenNormal:dot(rayDir)
            local t = screenNormal:dot(screenPos - cameraPosition) / denom
            local hitPoint = self.shape:transformPoint(cameraPosition + rayDir * t) + self.shape:transformPoint(self.shape:getInterpolatedWorldPosition())

            local width = self.data.width
            local height = self.data.height

            local widthScale = self.data.scale
            local heightScale = self.data.scale

            if width ~= height then
                if height > width then
                    heightScale = (height / width) * self.data.scale
                else
                    widthScale = (width / height) * self.data.scale
                end
            end

            local offset = 0.04
            local bgScale = sm.vec3.new(0, (heightScale - offset) * 100, (widthScale - offset) * 100)
            local pixelScale = sm.vec3.new(0, bgScale.y / height, bgScale.z / width)

            local x, y = shapePosToPixelPos(
                hitPoint,
                widthScale,
                heightScale,
                pixelScale.y,
                pixelScale.z
            )

            return x, y
        end,


        -- Takes a snapshot of the display
        takeSnapshot = function()
            self.sv.buffer.network[#self.sv.buffer.network + 1] = {1}
        end,

        -- Sets the optimization threshold. The lower, the less optimization it does but with better quality, the higher, the better optimization it does but with worser quality.
        -- You must set this value in decimals, Default optimization threshold when placing it is 0
        ---@param int number The new threshold
        setOptimizationThreshold = function (int)
            sm_scrapcomputers_errorHandler_assertArgument(int, nil, {"number"})

            self.sv.buffer.network[#self.sv.buffer.network + 1] = {2, int}
            self.sv.display.threshold = int
        end,

        -- Hides the display, Makes all players unable to see it.
        hide = function ()
            self.sv.buffer.network[#self.sv.buffer.network + 1] = {3, true}
        end,

        -- Shows the display. All players will be able to see it
        show = function ()
            self.sv.buffer.network[#self.sv.buffer.network + 1] = {3, false}
        end,

        -- Set the render distance for the display. If you go out of this range, the display will hide itself automaticly, else it will show itself.
        ---@param distance number The new render distance to set
        setRenderDistance = function (distance)
            sm_scrapcomputers_errorHandler_assertArgument(distance, nil, {"number"})

            self.sv.buffer.network[#self.sv.buffer.network + 1] = {4, distance}
        end,

        -- Enables/Disables touchscreen.
        ---@param bool boolean If true, Touchscreen mode is enabled and the end-user can interact with it.
        enableTouchScreen = function(bool)
            assert(not self.data.isAircraftDisplay, "Aircraft displays do not support touch screen!")
            sm_scrapcomputers_errorHandler_assertArgument(bool, nil, {"boolean"})

            self.sv.buffer.network[#self.sv.buffer.network + 1] = {5, bool}
            self.sv.display.touchAllowed = bool
        end,

        -- Always update's the display. We highly do not suggest doing this as its VERY laggy.
        ---@param bool boolean Toggle the autoUpdate system.
        autoUpdate = function (bool)
            sm_scrapcomputers_errorHandler_assertArgument(bool, nil, {"boolean"})

            self.sv.autoUpdate = bool
        end,

        -- Returns the dimensions of the display
        ---@return number width The width of the display
        ---@return number height height height of the display
        getDimensions = function ()
            return data_width, data_height
        end,

        -- Returns the size of the display.
        ---@return number width The width of the display in blocks.
        ---@return number height The height of the display in blocks.
        getSize = function ()
            return self.data.width / self.data.height * self.data.scale, self.data.scale
        end,


        -- Gets the latest touch data.
        getTouchData = function()
            return self.sv.display.touchData
        end,

        -- Gets a table touch data to accomodate multiple players pressing the screen.
        getTouchTable = function()
            return self.sv.display.touchTbl
        end,

        -- Returns displays optimization threshold (0 - 1)
        ---@return number threshold The current optimization threshold
        getOptimizationThreshold = function ()
            return self.sv.display.threshold
        end,

        -- Gets a pixel from the screen snapshot
        ---@param x integer The x coordinate
        ---@param y integer The y coordinate
        ---@return Color Color The color of the pixel in the x, y position
        getPixel = function(x, y)
            local colorId = self.sv.snapshotTable[coordinateToIndex(x, y, data_width)]

            return colorId and idToColor(colorId) or nil
        end,

        -- Renders the pixels to the display.
        update = function ()
            local lastLength = self_sv.lastBufferLen
            local update = not lastLength or not lastBuffer

            if clearCache and sm.scrapcomputers.backend.cameraColorCache then
                sm.scrapcomputers.backend.cameraColorCache[shapeId] = nil
                clearCache = false
            end

            if not update then
                if lastLength ~= dataIndex then
                    update = true
                end
            end

            if not update then
                for i = 1, dataIndex do
                    if dataBuffer[i] ~= lastBuffer[i] then
                        update = true
                        break
                    end  
                end
            end

            if update then
                local loopIndex = lastLength > dataIndex and lastLength or dataIndex

                for i = 1, loopIndex do
                    lastBuffer[i] = dataBuffer[i]
                end

                self_sv.lastBufferLen = dataIndex
                self_sv.allowUpdate = true
            end
        end,

        ---Sets the max buffer size
        ---@param buffer integer The max buffer size
        setMaxBuffer = function (buffer)
            -- Func deprecated
        end,

        -- Optimizes the display to the extreme. Will be costy during the optimization but will be a massive performance increase after it.
        optimize = function ()
            -- Func deprecated
        end
    }

    sm_scrapcomputers_ascfManager_applyDisplayFunctions(display)

    return display
end

function DisplayClass:server_onCreate()
    self.sv = {
        display = {
            threshold = 0.01,
            touchTbl = {}
        },

        buffer = {
            data = {},
            network = {},
            syncBuffer = {},
            snapshotBuild = {}
        },

        snapshotTable = {},
        totalPlayers = 1,

        lastBufferLen = 0,
        lastBuffer = {}
    }

    sm.scrapcomputers.powerManager.updatePowerInstance(self.shape.id, self.data.scale / 10)
end

function DisplayClass:sv_onPowerLoss()
    local currBuffer = {3, colorToID(sm_color_new(0, 0, 0))} -- clear

    self.sv.buffer.data = currBuffer
    self.sv.lastBuffer = currBuffer
    self.sv.lastBufferLen = #currBuffer
    self.sv.allowUpdate = true
end

function DisplayClass:server_onDestroy()
    if sm.scrapcomputers.backend.cameraColorCache then
        sm.scrapcomputers.backend.cameraColorCache[self.shape.id] = nil
    end
end

function DisplayClass:server_onFixedUpdate()
    local self_sv = self.sv
    local self_sv_buffer = self_sv.buffer
    local self_sv_display = self_sv.display
    local self_network = self.network
    local sendToClients = self_network.sendToClients

    local networkBuffer = self_sv_buffer.network

    if #networkBuffer > 0 then
        for _, data in pairs(networkBuffer) do
            local instruction, param = unpack(data)
            local dest = networkInstructions[instruction]

            sendToClients(self_network, dest, param)

            if instruction == 3 then
                sendToClients(self_network, "cl_setUserHidden", param)
            end
        end

        if sm.scrapcomputers.backend.cameraColorCache then
            sm.scrapcomputers.backend.cameraColorCache[self.shape.id] = nil
        end

        self_sv_buffer.network = {}
    end

    if self_sv.allowUpdate or self_sv.autoUpdate then
        local dataBuffer = self_sv_buffer.data

        if self_sv.totalPlayers > 1 then
            local dataChunks = splitTable(dataBuffer, tableLimit)
            local len = #dataChunks

            for i, chunk in pairs(dataChunks) do
                sendToClients(self_network, "cl_buildData", {chunk, i == len})
            end
        else
            local clientBuffer = self.cl.buffer.data

            for i = 1, #dataBuffer do
                clientBuffer[i] = dataBuffer[i]
            end

            sendToClients(self_network, "cl_pushData", true)
        end

        self_sv.resetBuffer()
        self_sv.allowUpdate = false
    end

    if self_sv.synced and self_sv_buffer.syncBuffer then
        self_sv.synced = false
        self_sv.allowUpdate = true
        self_sv_buffer.data = self_sv_buffer.syncBuffer

        sendToClients(self_network, "cl_setTouchState", self_sv_display.touchAllowed)
        sendToClients(self_network, "cl_setRenderDistance", self_sv_display.renderDistance)
        sendToClients(self_network, "cl_setColorThreshold", self_sv_display.threshold)

        self_sv_buffer.syncBuffer = {}
    end
end

function DisplayClass:sv_mpScreenSync(data)
    local sv_dataTbl = data[1]
    local dataTbl = self.sv.buffer.syncBuffer
    local len = #dataTbl

    for i = 1, #sv_dataTbl do
        len = len + 1
        dataTbl[len] = sv_dataTbl[i]
    end

    if data[2] then
        self.sv.synced = true
    end
end

function DisplayClass:sv_buildSnapshot(data)
    local sv_dataTbl = data[1]
    local snapshotTable = self.sv.buffer.snapshotBuild
    local len = #snapshotTable

    for i = 1, #sv_dataTbl do
        len = len + 1
        snapshotTable[len] = sv_dataTbl[i]
    end

    if not data[2] then return end

    self.sv.snapshotTable = snapshotTable
end

function DisplayClass:sv_setTertiaryData(data)
    self.sv.backPanel = data.backPanel
    self.sv.display.touchAllowed = data.touchAllowed
    self.sv.display.renderDistance = data.renderDistance
    self.sv.display.threshold = data.threshold
end

function DisplayClass:sv_setTouchData(data)
    self.sv.display.touchTbl[data[2]] = data[1]
    self.sv.display.touchData = data[1]
end

function DisplayClass:sv_setTotalPlayers(len)
    self.sv.totalPlayers = len
end

-- CLIENT --

function DisplayClass:client_onCreate()
    local isAircraftDisplay = self.data.isAircraftDisplay

    self.cl = {
        pixel = {
            stoppedEffects = {},
            pixelScale = sm.vec3.zero()
        },

        buffer = {
            data = {},
            indexes = {},
            instructions = {},
            tables = {}
        },

        backPanel = {
            currentColor = 0
        },

        display = {
            renderDistance = 10,
            visTimer = 0,
            threshold =  0.005
        },

        indexToOrigin = {},
        originToArray = {},
        arrayIndex = 0,
        effectArray = {},
        scaleXArray = {},
        scaleYArray = {},
        coordXArray = {},
        coordYArray = {},
        colorArray = {},
        indexArray = {},

        newBuffer = {},
        fullBuffer = {},
        updatedPoints = {},
        offsetBuffer = {},
        stoppedIndex = 0
    }

    local width = self.data.width
    local height = self.data.height

    local widthScale = self.data.scale
    local heightScale = self.data.scale

    if width ~= height then
        if height > width then
            heightScale = (height / width) * self.data.scale
        else
            widthScale = (width / height) * self.data.scale
        end
    end

    self.cl.display.widthScale = widthScale
    self.cl.display.heightScale = heightScale

    local offset = 0.04
    local bgScale = sm_vec3_new(0, self.cl.display.heightScale - offset, self.cl.display.widthScale - offset)

    self.cl.pixel.pixelScale = sm_vec3_new(0, bgScale.y / height, bgScale.z / width)

    if not isAircraftDisplay then
        self.cl.backPanel.effect = sm_effect_createEffect(BACKPANEL_EFFECT_NAME, self.interactable)

        effect_setParameter(self.cl.backPanel.effect,"color", idToColor(self.cl.backPanel.currentColor))

        effect_setOffsetPosition(self.cl.backPanel.effect, sm_vec3_new(self.data.panelOffset or 0.115, 0, 0))
        effect_setScale(self.cl.backPanel.effect, bgScale)

        effect_start(self.cl.backPanel.effect)
    end
end

function DisplayClass:client_onRefresh()
    print("-----------------------")
    print("CONSOLE SEPARATION")
    print("-----------------------")
end

function DisplayClass:cl_setRenderDistance(param)
    self.cl.display.renderDistance = param
end

function DisplayClass:cl_setColorThreshold(param)
    self.cl.display.threshold = param
end

function DisplayClass:cl_setTouchState(param)
    if param and not self.data.isAircraftDisplay then
        self.cl.display.touchAllowed = param
    end
end

function DisplayClass:cl_setUserHidden(bool)
    self.cl.display.userHidden = bool
end

function DisplayClass:cl_takeSnapshot()
    local colorTbl = {}
    local self_network = self.network
    local sendToServer = self_network.sendToServer
    
    local originToArray = self.cl.originToArray
    local colorArray = self.cl.colorArray

    for index, origin in pairs(self.cl.indexToOrigin) do
        colorTbl[index] = colorArray[originToArray[origin]]
    end

    local lastPlayerLen = self.cl.lastLen

    if lastPlayerLen and lastPlayerLen > 1 then
        local chunks = splitTable(colorTbl, tableLimit)

        for i, chunk in pairs(chunks) do
            sendToServer(self_network, "sv_buildSnapshot", {chunk, i == len})
        end
    else
        self.sv.snapshotTable = colorTbl
    end
end

function DisplayClass:cl_buildData(data)
    local sv_dataTbl = data[1]
    local dataTbl = self.cl.buffer.data
    local len = #dataTbl

    for i = 1, #sv_dataTbl do
        len = len + 1
        dataTbl[len] = sv_dataTbl[i]
    end

    if data[2] then 
        self:cl_pushData()
    end
end

function DisplayClass:client_onFixedUpdate()
    local self_cl = self.cl
    local self_cl_display = self_cl.display
    local self_cl_backPanel = self_cl.backPanel
    local self_data = self.data
    local self_shape = self.shape

    local clock = os.clock()
    local pos = camera.getPosition()
    local dir = camera.getDirection()
    local player = localPlayer.getPlayer()
    local playerName = player.name
    local character = player.character

    local lastLangUpdt = sm.scrapcomputers.languageManager.lastLanguageUpdate
    local currTick = sm_game_getCurrentTick()

    local lockingInt = character and character:getLockingInteractable()
    self_cl.characterSeated = lockingInt and lockingInt:hasSeat()

    if self_cl_display.visTimer + displayHidingCooldown <= clock and character then
        self_cl_display.visTimer = clock

        local worldPosition = self_shape.worldPosition
        local shouldHide = ignoreFlags

        if sm_vec3_length(worldPosition - character.worldPosition) > self_cl_display.renderDistance then
            shouldHide = true
        end

        if not shouldHide then
            if sm_vec3_dot(dir, sm_vec3_normalize(worldPosition - pos)) < 0 then
                shouldHide = true
            end
        end

        if not self_cl_display.userHidden then
            if shouldHide and not self_cl.prevHidden then
                self:cl_setVisibility(shouldHide)
                self_cl.prevHidden = true
            elseif not shouldHide and self_cl.prevHidden then
                self:cl_setVisibility(shouldHide)
                self_cl.prevHidden = false
            end
        end
    end

    if sm.isHost then
        local players = sm_player_getAllPlayers()
        local len = #players

        if len ~= self_cl.lastLen then
            if self_cl.lastLen and len > self_cl.lastLen and #players > 1 then
                local dataTbl = {3, self_cl_backPanel.currentColor}
                local dataIndex = 2

                local scaleXArray = self.cl.scaleXArray
                local scaleYArray = self.cl.scaleYArray
                local coordXArray = self.cl.coordXArray
                local coordYArray = self.cl.coordYArray
                local colorArray = self.cl.colorArray

                for i = 1, self.cl.arrayIndex do
                    dataIndex = dataIndex + 1
                    dataBuffer[dataIndex] = 6
                    dataIndex = dataIndex + 1
                    dataBuffer[dataIndex] = coordXArray[i]
                    dataIndex = dataIndex + 1
                    dataBuffer[dataIndex] = coordYArray[i]
                    dataIndex = dataIndex + 1
                    dataBuffer[dataIndex] = scaleXArray[i]
                    dataIndex = dataIndex + 1
                    dataBuffer[dataIndex] = scaleYArray[i]
                    dataIndex = dataIndex + 1
                    dataBuffer[dataIndex] = colorArray[i]
                    dataIndex = dataIndex + 1
                    dataBuffer[dataIndex] = true
                end

                local self_network = self.network
                local sendToServer = self_network.sendToServer

                local tertiaryData = {
                    threshold = self_cl_display.threshold,
                    touchAllowed = self_cl_display.touchAllowed,
                    renderDistance = self_cl_display.renderDistance,
                    backPanel = self_cl_backPanel.currentColor
                }

                sendToServer(self_network, "sv_setTertiaryData", tertiaryData)

                local chunks = splitTable(dataTbl, tableLimit)
                local len = #chunks

                for i, chunk in pairs(chunks) do
                    sendToServer(self_network, "sv_mpScreenSync", {chunk, i == len})
                end
            end

            self_cl.lastLen = len

            self.network:sendToServer("sv_setTotalPlayers", len)
        end
    end

    if self_cl.raycastValid and self_cl.display.touchAllowed then
        if self_cl.lastLangUpdate ~= lastLangUpdt or self_cl.seatState ~= self_cl.characterSeated then
            self_cl.lastLangUpdate = lastLangUpdt
            self_cl.seatState = self_cl.characterSeated
        end
    end

    if (self_cl.interacting or self_cl.interactState == 3) and not self_cl.clearTick then
        self_cl.wasInteracting = true

        if not self_cl.interactState then
            self_cl.interactState = 1
        elseif self_cl.interactState == 1 then
            self_cl.interactState = 2
        end

        if self_cl.transformedPoint then
            local x, y = shapePosToPixelPos(self_cl.transformedPoint, self_cl_display.widthScale, self_cl_display.heightScale, self_cl.pixel.pixelScale.y, self_cl.pixel.pixelScale.z)

            self_cl.lastX = round(sm_util_clamp(x, 1, self_data.width))
            self_cl.lastY = round(sm_util_clamp(y, 1, self_data.height))
        end

        self.network:sendToServer("sv_setTouchData", {{state = self_cl.interactState, x = self_cl.lastX, y = self_cl.lastY, pressType = self_cl.isTinkering and 2 or 1, name = playerName}, playerName})

        if self_cl.interactState == 3 then
            self_cl.interactState = nil
            self_cl.clearTick = currTick
        end
    elseif self_cl.wasInteracting then
        self_cl.wasInteracting = false
        if self_cl.interactState then self_cl.interactState = 3 end
    end

    if self_cl.clearTick and self_cl.clearTick + 1 <= currTick then
        self.network:sendToServer("sv_setTouchData", {nil, playerName})
        self_cl.clearTick = nil
    end

    if not self_cl.lastOptimise or self_cl.lastOptimise + optimiseCooldown <= clock then
        if self_cl.hasUpdated then
            self_cl.lastOptimise = clock
            self_cl.hasUpdated = false

            self:cl_optimiseDisplay()
        end
    end
end

function DisplayClass:client_onUpdate(dt)
    local self_cl = self.cl
    local self_shape = self.shape

    local interpolation = self.shape.worldPosition - self.shape:getInterpolatedWorldPosition()
    local start = localPlayer.getRaycastStart() + interpolation
    local hit, res = sm_physics_raycast(start, start + localPlayer.getDirection() * 7.5, nil, sm.physics.filter.dynamicBody + sm.physics.filter.staticBody)

    if hit and res:getShape() == self_shape then
        self_cl.isRaycasted = true

        if self_cl.display.touchAllowed then
            local roundedNorm = sm_vec3_new(round(res.normalLocal.x), round(res.normalLocal.y), round(res.normalLocal.z))

            self_cl.raycastValid = self_shape:getXAxis() == roundedNorm
            self_cl.transformedPoint = self_shape:transformPoint(res.pointWorld)
        else
            self_cl.raycastValid = false
            self_cl.transformedPoint = nil
        end
    else
        self_cl.isRaycasted = false
        self_cl.raycastValid = false
        self_cl.transformedPoint = nil
    end
end

function DisplayClass:client_onInteract(character, state)
    local self_cl = self.cl

    if state and self_cl.raycastValid then
        self_cl.interacting = true
    elseif (not state or not self_cl.raycastValid) and self_cl.wasInteracting then
        self_cl.interacting = false
    end

    return false
end

function DisplayClass:cl_updateInteractionText()
    local self_cl = self.cl
    if self_cl.raycastValid and self_cl.display.touchAllowed then
        if self_cl.characterSeated then
            sm.scrapcomputers.gui:showCustomInteractiveText({{"scrapcomputers.display.touchscreen", tinkerBind}})
        else
            sm.scrapcomputers.gui:showCustomInteractiveText({{"scrapcomputers.display.touchscreen_multi", interactBind, tinkerBind}})
        end
    elseif self_cl.isRaycasted then
        sm.gui.setInteractionText(" ")
        sm.gui.setInteractionText("")
    end
end

function DisplayClass:client_canInteract()
    self:cl_updateInteractionText()
    return self.shape.usable
end

function DisplayClass:client_onTinker(character, state)
    local self_cl = self.cl

    if state and self_cl.raycastValid then
        self_cl.interacting = true
        self_cl.isTinkering = true
    elseif (not state or not self_cl.raycastValid) and self_cl.wasInteracting then
        self_cl.interacting = false
        self_cl.isTinkering = false
    end
end

function DisplayClass:client_canTinker()
    self:cl_updateInteractionText()
    return true
end

function DisplayClass:cl_pushData(clearDataTable)
    local newBuffer = {}
    local hasCleared = false
    local self_cl = self.cl
    local self_cl_backPanel = self_cl.backPanel
    local self_data = self.data
    local isAircraftDisplay = self_data.isAircraftDisplay
    local width = self_data.width
    local height = self_data.height
    local fullBuffer = self_cl.fullBuffer
    local updatedPoints = self_cl.updatedPoints
    --local offsetBuffer = self_cl.offsetBuffer
    local hasUpdated = false
    local self_cl_display = self_cl.display
    local threshold = self_cl_display.threshold

    local function addPixel(x, y, color)
        if x > 0 and x <= width and y > 0 and y <= height then
            index = (y - 1) * width + x

            newBuffer[index] = color
            updatedPoints[index] = true
        end
    end

    local function scaledAdd(x, y, sx, sy, color)
        local x1, y1 = x, y
        local mx = sx + x - 1
    
        for _ = 1, sx * sy do
            addPixel(x1, y1, color)

            x1 = x1 + 1
        
            if x1 > mx then
                x1 = x
                y1 = y1 + 1
            end
        end
    end

    local function drawLine(x0, y0, x1, y1, color)
        local dx = math_abs(x1 - x0)
        local dy = math_abs(y1 - y0)
        local sx = (x0 < x1) and 1 or -1
        local sy = (y0 < y1) and 1 or -1
        local err = dx - dy
    
        while true do
            addPixel(x0, y0, color)
    
            if x0 == x1 and y0 == y1 then break end
    
            local e2 = err * 2
            if e2 > -dy then
                err = err - dy
                x0 = x0 + sx
            end
    
            if e2 < dx then
                err = err + dx
                y0 = y0 + sy
            end
        end
    end

    local function clearDisplay(color)
        hasCleared = true

        clearTable(newBuffer)
        clearTable(fullBuffer)
        
        if not isAircraftDisplay then
            if color and color ~= self_cl_backPanel.currentColor then
                effect_setParameter(self_cl_backPanel.effect, "color", idToColor(color))
                self_cl_backPanel.currentColor = color
            end
        end
    end

    local function drawCircle(x, y, radius, color, isFilled)
        local f = 1 - radius
        local ddF_x = 1
        local ddF_y = -2 * radius
        local cx = 0
        local cy = radius
    
        if isFilled then
            scaledAdd(x - radius, y, radius * 2 + 1, 1, color)
        else
            addPixel(x, y + radius, color)
            addPixel(x, y - radius, color)
            addPixel(x + radius, y, color)
            addPixel(x - radius, y, color)
        end
    
        while cx < cy do
            if f >= 0 then
                cy = cy - 1
                ddF_y = ddF_y + 2
                f = f + ddF_y
            end
            cx = cx + 1
            ddF_x = ddF_x + 2
            f = f + ddF_x
    
            if isFilled then
                scaledAdd(x - cx, y + cy, cx * 2 + 1, 1, color)
                scaledAdd(x - cy, y + cx, cy * 2 + 1, 1, color)
    
                scaledAdd(x - cx, y - cy, cx * 2 + 1, 1, color)
                scaledAdd(x - cy, y - cx, cy * 2 + 1, 1, color)
            else
                addPixel(x + cx, y + cy, color)
                addPixel(x - cx, y + cy, color)
                addPixel(x + cx, y - cy, color)
                addPixel(x - cx, y - cy, color)
                addPixel(x + cy, y + cx, color)
                addPixel(x - cy, y + cx, color)
                addPixel(x + cy, y - cx, color)
                addPixel(x - cy, y - cx, color)
            end
        end
    end

    local function drawTriangle(x1, y1, x2, y2, x3, y3, color, isFilled)
        drawLine(x1, y1, x2, y2, color)
        drawLine(x2, y2, x3, y3, color)
        drawLine(x3, y3, x1, y1, color)
    
        if isFilled then
            local points = {{x = x1, y = y1}, {x = x2, y = y2}, {x = x3, y = y3}}
            table_sort(points, function(a, b) return a.y < b.y end)
    
            local x0, y0 = points[1].x, points[1].y
            local x1, y1 = points[2].x, points[2].y
            local x2, y2 = points[3].x, points[3].y
    
            local function drawScanlineSection(yStart, yEnd, xA, yA, xB, yB)
                local dy = yB - yA
                if dy == 0 then return end
                local invSlopeA = (xB - xA) / dy
    
                dy = yEnd - yStart
                for i = 0, dy - 1 do
                    local y = yStart + i
                    local xa = xA + invSlopeA * (y - yA)
                    local xb = x0 + ((x2 - x0) / (y2 - y0)) * (y - y0)
    
                    local sx, ex = xa, xb
                    if sx > ex then sx, ex = ex, sx end
                    sx = math_floor(sx + 0.5)
                    ex = math_floor(ex + 0.5)
    
                    for x = sx, ex do
                        addPixel(x, y, color)
                    end
                end
            end
    
            if y1 ~= y0 then
                drawScanlineSection(y0, y1, x0, y0, x1, y1)
            end
            if y2 ~= y1 then
                drawScanlineSection(y1, y2 + 1, x1, y1, x2, y2)
            end
        end
    end
       

    local function drawRect(x, y, rWidth, rHeight, color, isFilled)
        if rWidth == 1 and rHeight == 1 then
            addPixel(x, y, color)
            return
        end
    
        if isFilled then
            scaledAdd(x, y, rWidth, rHeight, color)
            return
        end
    
        scaledAdd(x, y, rWidth, 1, color)
        scaledAdd(x + rWidth - 1, y + 1, 1, rHeight - 2, color)
        scaledAdd(x, y + 1, 1, rHeight - 2, color)
        scaledAdd(x, y + rHeight - 1, rWidth, 1,  color)
    end

    local function drawText(params_x, params_y, params_text, params_color, params_font, params_maxWidth, params_wordWrappingEnabled)
        local font, err = sm_scrapcomputers_fontManager_getFont(params_font)
        local font_width = font.fontWidth
        local font_height = font.fontHeight
        local font_charset = font.charset
        local font_errorchar = font.errorChar
    
        if not font then
            sm.log.error("Fatal error! Failed to get the font! Error message: "..err)
            sm.gui.chatMessage("[#3A96DDS#3b78ffC#eeeeee]: " .. sm_scrapcomputers_languageManager_translatable("scrapcomputers.display.failed_to_find_font"))
    
            return
        end
    
        local xSpacing = 0
        local ySpacing = 0
    
        local i = 1
    
        local width = params_maxWidth or width
    
        if not params_wordWrappingEnabled then
            width = math.huge
        end
    
        while i <= #params_text do
            local char = sm_scrapcomputers_utf8_getCharacterAt(params_text, i)
    
            if char == "\n" then
                xSpacing = 0
                ySpacing = ySpacing + font_height
            else
                local fontLetter = font_charset[char] or font_errorchar
    
                if (params_x + xSpacing) + font_width > width then
                    xSpacing = 0
                    ySpacing = ySpacing + font_height
                end
    
                for yPosition, row in pairs(fontLetter) do
                    for xPosition = 1, #row, 1 do
                        if string_sub(row, xPosition, xPosition) == "#" then
                            local x, y = params_x + xSpacing + (xPosition - 1), params_y + ySpacing + (yPosition - 1)
    
                            addPixel(x, y, params_color)
                        end
                    end
    
                end
    
                xSpacing = xSpacing + font_width
            end
    
            i = i + #char
        end
    end

    local function drawWithPoints(flatPoints, color)
        local function area(points)
            local sum = 0
            local count = math_floor(#points / 2)

            for i = 1, count do
                local xi, yi = points[i * 2 - 1], points[i * 2]
                local j = (i % count) + 1
                local xj, yj = points[j * 2 - 1], points[j * 2]
                sum = sum + (xi * yj - xj * yi)
            end

            return sum * 0.5
        end
    
        local function isConvex(px, py, cx, cy, nx, ny, isCCW)
            local dx1, dy1 = cx - px, cy - py
            local dx2, dy2 = nx - cx, ny - cy

            return (dx1 * dy2 - dy1 * dx2) > 0 == isCCW
        end
    
        local function pointInTriangle(px, py, ax, ay, bx, by, cx, cy)
            local function sign(x1, y1, x2, y2, x3, y3)
                return (x1 - x3) * (y2 - y3) - (x2 - x3) * (y1 - y3)
            end

            local b1 = sign(px, py, ax, ay, bx, by) < 0
            local b2 = sign(px, py, bx, by, cx, cy) < 0
            local b3 = sign(px, py, cx, cy, ax, ay) < 0

            return b1 == b2 and b2 == b3
        end

        local count = math_floor(#flatPoints / 2)
        local indices = {}

        for i = 1, count do indices[i] = i end
    
        local isCCW = area(flatPoints) > 0
        local safety = 0
    
        while #indices >= 3 and safety < 1000 do
            safety = safety + 1

            local earFound = false
    
            for i = 1, #indices do
                local iPrev = indices[(i - 2) % #indices + 1]
                local iCurr = indices[i]
                local iNext = indices[i % #indices + 1]
    
                local px, py = flatPoints[iPrev * 2 - 1], flatPoints[iPrev * 2]
                local cx, cy = flatPoints[iCurr * 2 - 1], flatPoints[iCurr * 2]
                local nx, ny = flatPoints[iNext * 2 - 1], flatPoints[iNext * 2]
    
                if isConvex(px, py, cx, cy, nx, ny, isCCW) then
                    local ear = true

                    for j = 1, #indices do
                        local test = indices[j]

                        if test ~= iPrev and test ~= iCurr and test ~= iNext then
                            local tx, ty = flatPoints[test * 2 - 1], flatPoints[test * 2]

                            if pointInTriangle(tx, ty, px, py, cx, cy, nx, ny) then
                                ear = false
                                break
                            end
                        end
                    end
    
                    if ear then
                        drawTriangle(px, py, cx, cy, nx, ny, color, true)

                        table.remove(indices, i)
                        earFound = true

                        break
                    end
                end
            end
    
            if not earFound then break end
        end
    end

    local dataCountLookup = {
        [1] = 3,
        [2] = 5,
        [3] = 1,
        [4] = 5,
        [5] = 8,
        [6] = 6,
        [7] = 7,
        [8] = 2,
        [100] = 6,
        [101] = 5
    }

    local data = self_cl.buffer.data
    local totalLen = #data
    local searchIndex = 1

    local videoHook, frameHook = sm.scrapcomputers.backend.cameraVideoHooks, sm.scrapcomputers.backend.cameraFrameHooks
    local shapeId = self.shape.id

    while searchIndex < totalLen do
        local action = data[searchIndex]

        if action == 1 then
            addPixel(data[searchIndex + 1], data[searchIndex + 2], data[searchIndex + 3])
            hasUpdated = true
        elseif action == 2 then
            drawLine(data[searchIndex + 1], data[searchIndex + 2], data[searchIndex + 3], data[searchIndex + 4], data[searchIndex + 5])
            hasUpdated = true
        elseif action == 3 then
            clearDisplay(data[searchIndex + 1])
        elseif action == 4 then
            drawCircle(data[searchIndex + 1], data[searchIndex + 2], data[searchIndex + 3], data[searchIndex + 4], data[searchIndex + 5])
            hasUpdated = true
        elseif action == 5 then
            drawTriangle(data[searchIndex + 1], data[searchIndex + 2], data[searchIndex + 3], data[searchIndex + 4], data[searchIndex + 5], data[searchIndex + 6], data[searchIndex + 7], data[searchIndex + 8])
            hasUpdated = true
        elseif action == 6 then
            drawRect(data[searchIndex + 1], data[searchIndex + 2], data[searchIndex + 3], data[searchIndex + 4], data[searchIndex + 5], data[searchIndex + 6])
            hasUpdated = true
        elseif action == 7 then
            drawText(data[searchIndex + 1], data[searchIndex + 2], data[searchIndex + 3], data[searchIndex + 4], data[searchIndex + 5], data[searchIndex + 6], data[searchIndex + 7])
            hasUpdated = true
        elseif action == 8 then
            drawWithPoints(data[searchIndex + 1], data[searchIndex + 2])
            hasUpdated = true
        elseif action == 100 then
            videoHook[data[searchIndex + 6]](
                {
                    data[searchIndex + 1], 
                    data[searchIndex + 2], 
                    data[searchIndex + 3], 
                    data[searchIndex + 4], 
                    data[searchIndex + 5]
                }, 
                addPixel, 
                fullBuffer, 
                threshold, 
                shapeId
            )
            hasUpdated = true
        elseif action == 101 then
            frameHook[data[searchIndex + 5]](
                {
                    data[searchIndex + 1], 
                    data[searchIndex + 2],
                    data[searchIndex + 3], 
                    data[searchIndex + 4]
                }, 
                addPixel, 
                fullBuffer, 
                threshold, 
                shapeId
            )
            hasUpdated = true
        end

        searchIndex = searchIndex + dataCountLookup[action] + 1
    end

    if clearDataTable then
        clearTable(data)
    end

    local self_interactable = self.interactable
    local self_cl_pixel = self_cl.pixel
    local backpanelColor = self_cl_backPanel.currentColor

    local indexToOrigin = self_cl.indexToOrigin
    local originToArray = self_cl.originToArray
    local arrayIndex = self_cl.arrayIndex
    local effectArray = self_cl.effectArray
    local scaleXArray = self_cl.scaleXArray
    local scaleYArray = self_cl.scaleYArray
    local coordXArray = self_cl.coordXArray
    local coordYArray = self_cl.coordYArray
    local colorArray = self_cl.colorArray
    local indexArray = self_cl.indexArray

    local stoppedIndex = self_cl.stoppedIndex
    local stoppedEffects = self_cl_pixel.stoppedEffects
    local dataChange = {}
    local colorChange = {}
    local isHidden = self_cl_display.isHidden
    local widthScale = self_cl_display.widthScale
    local heightScale = self_cl_display.heightScale

    local self_data_panelOffset = self_data.panelOffset
    local pixel_scale = self_cl_pixel.pixelScale
    local pixel_scale_y = pixel_scale.y
    local pixel_scale_z = pixel_scale.z
    local pixelDepth = self_data_panelOffset and self_data_panelOffset + 0.001 or 0.116

    local function createEffect()
        local effect 
        
        if stoppedIndex > 0 then
            effect = stoppedEffects[stoppedIndex]
            --offsetBuffer[effect] = nil
            stoppedEffects[stoppedIndex] = nil
            stoppedIndex = stoppedIndex - 1
        else
            effect = sm_effect_createEffect(pixelEffect, self_interactable)
        end
    
        return effect
    end

    local function suspendEffect(arrayPointer)
        local effect = effectArray[arrayPointer]
        local originIndex = indexArray[arrayPointer] 

        stoppedIndex = stoppedIndex + 1
        stoppedEffects[stoppedIndex] = effect
        --offsetBuffer[effect] = true
        --effect_setOffsetPosition(effect, rePos)
        effect_stop(effect)

        if arrayPointer ~= arrayIndex then
            local popIndex = indexArray[arrayIndex]

            effectArray[arrayPointer] = effectArray[arrayIndex]
            scaleXArray[arrayPointer] = scaleXArray[arrayIndex]
            scaleYArray[arrayPointer] = scaleYArray[arrayIndex]
            coordXArray[arrayPointer] = coordXArray[arrayIndex]
            coordYArray[arrayPointer] = coordYArray[arrayIndex]
            colorArray[arrayPointer]  = colorArray[arrayIndex]
            indexArray[arrayPointer]  = popIndex
            
            dataChange[arrayPointer]  = dataChange[arrayIndex]
            colorChange[arrayPointer] = colorChange[arrayIndex]

            originToArray[originIndex] = nil
            originToArray[popIndex] = arrayPointer

            effectArray[arrayIndex] = nil
            scaleXArray[arrayIndex] = nil
            scaleYArray[arrayIndex] = nil
            coordXArray[arrayIndex] = nil
            coordYArray[arrayIndex] = nil
            colorArray[arrayIndex]  = nil
            indexArray[arrayIndex]  = nil
            
            dataChange[arrayIndex]  = nil
            colorChange[arrayIndex] = nil
        else
            effectArray[arrayPointer] = nil
            scaleXArray[arrayPointer] = nil
            scaleYArray[arrayPointer] = nil
            coordXArray[arrayPointer] = nil
            coordYArray[arrayPointer] = nil
            colorArray[arrayPointer]  = nil
            indexArray[arrayPointer]  = nil
            
            dataChange[arrayPointer]  = nil
            colorChange[arrayPointer] = nil
            
            originToArray[originIndex] = nil
        end

        arrayIndex = arrayIndex - 1
    end

    local function meshNeighbours(index, originColor)
        local success
        local originIndex = indexToOrigin[index]
        local arrayPointer = originIndex and originToArray[originIndex]
        local originEffect, originSx, originSy, originX, originY

        if arrayPointer then
            originEffect, originSx, originSy, originX, originY = 
            effectArray[arrayPointer], scaleXArray[arrayPointer], scaleYArray[arrayPointer], 
            coordXArray[arrayPointer], coordYArray[arrayPointer]

            index = originIndex
        else
            originSx, originSy, originX, originY = 
            1, 1, (index - 1) % width + 1, math_floor((index - 1) / width) + 1
        end

        -- local nxOriginIndex = indexToOrigin[index - 1]
        -- local nxArrayPointer = nxOriginIndex and originToArray[nxOriginIndex]

        -- local pxOriginIndex = indexToOrigin[index + originSx]
        -- local pxArrayPointer = pxOriginIndex and originToArray[pxOriginIndex]

        -- local nxPossible = nxArrayPointer and scaleYArray[nxArrayPointer] == originSy and coordYArray[nxArrayPointer] == originY and areColorsSimilar(colorArray[nxArrayPointer], originColor, threshold)
        -- local pxPossible = pxArrayPointer and scaleYArray[pxArrayPointer] == originSy and coordYArray[pxArrayPointer] == originY and areColorsSimilar(colorArray[pxArrayPointer], originColor, threshold)
        
        -- if nxPossible and pxPossible then
        --     originX = coordXArray[nxArrayPointer]
        --     originSx = originSx + scaleXArray[nxArrayPointer] + scaleXArray[pxArrayPointer]

        --     suspendEffect(nxArrayPointer)
        --     pxArrayPointer = originToArray[pxOriginIndex]
        --     suspendEffect(pxArrayPointer)

        --     success = true
        -- elseif nxPossible then
        --     originX = coordXArray[nxArrayPointer]
        --     originSx = originSx + scaleXArray[nxArrayPointer]

        --     suspendEffect(nxArrayPointer)

        --     success = true
        -- elseif pxPossible then
        --     originSx = originSx + scaleXArray[pxArrayPointer]

        --     suspendEffect(pxArrayPointer)

        --     success = true
        -- end

        -- index = (originY - 1) * width + originX

        local nyOriginIndex = indexToOrigin[index - width]
        local nyArrayPointer = nyOriginIndex and originToArray[nyOriginIndex]

        local pyOriginIndex = indexToOrigin[index + width * originSy]
        local pyArrayPointer = pyOriginIndex and originToArray[pyOriginIndex]

        local nyPossible = nyArrayPointer and scaleXArray[nyArrayPointer] == originSx and coordXArray[nyArrayPointer] == originX and areColorsSimilar(colorArray[nyArrayPointer], originColor, threshold)
        local pyPossible = pyArrayPointer and scaleXArray[pyArrayPointer] == originSx and coordXArray[pyArrayPointer] == originX and areColorsSimilar(colorArray[pyArrayPointer], originColor, threshold)

        if nyPossible and pyPossible then
            originY = coordYArray[nyArrayPointer]
            originSy = originSy + scaleYArray[nyArrayPointer] + scaleYArray[pyArrayPointer]

            suspendEffect(nyArrayPointer)
            pyArrayPointer = originToArray[pyOriginIndex]
            suspendEffect(pyArrayPointer)

            success = true
        elseif nyPossible then
            originY = coordYArray[nyArrayPointer]
            originSy = originSy + scaleYArray[nyArrayPointer]

            suspendEffect(nyArrayPointer)

            success = true
        elseif pyPossible then
            originSy = originSy + scaleYArray[pyArrayPointer]

            suspendEffect(pyArrayPointer)

            success = true
        end

        if success then
            local appendIndex = originToArray[originIndex]

            if not appendIndex then
                arrayIndex = arrayIndex + 1
                appendIndex = arrayIndex
            end

            local startIndex = (originY - 1) * width + originX
            effectArray[appendIndex] = originEffect or createEffect()
            scaleXArray[appendIndex] = originSx
            scaleYArray[appendIndex] = originSy
            coordXArray[appendIndex] = originX
            coordYArray[appendIndex] = originY
            colorArray[appendIndex] = originColor
            indexArray[appendIndex] = startIndex
            originToArray[startIndex] = appendIndex

            dataChange[appendIndex] = true
            --colorChange[appendIndex] = originColor

            local x1, y1, mx = originX, originY, originX + originSx - 1

            for _ = 1, originSx * originSy do
                indexToOrigin[(y1 - 1) * width + x1] = startIndex

                x1 = x1 + 1

                if x1 > mx then
                    x1 = originX
                    y1 = y1 + 1
                end
            end
        end

        return success
    end

    local function splitEffect(index, createAtRoot)
        local x, y = (index - 1) % width + 1, math_floor((index - 1) / width) + 1
        local originIndex = indexToOrigin[index]
        local arrayPointer = originToArray[originIndex]
        local eSx = scaleXArray[arrayPointer]
        local eSy = scaleYArray[arrayPointer]
        local ex = coordXArray[arrayPointer]
        local ey = coordYArray[arrayPointer]
        local color = colorArray[arrayPointer]
        local eMx, eMy = ex + eSx - 1, ey + eSy - 1
        local rootAvaliable = not createAtRoot

        if ex < x then
            local sx = x - ex
            local startIndex = (y - 1) * width + ex

            if rootAvaliable then
                scaleXArray[arrayPointer] = sx
                scaleYArray[arrayPointer] = 1
                coordXArray[arrayPointer] = ex
                coordYArray[arrayPointer] = y
                colorArray[arrayPointer] = color
                indexArray[arrayPointer] = startIndex
                originToArray[startIndex] = arrayPointer

                dataChange[arrayPointer] = true
                --colorChange[arrayPointer] = color
            else
                arrayIndex = arrayIndex + 1
                effectArray[arrayIndex] = createEffect()
                scaleXArray[arrayIndex] = sx
                scaleYArray[arrayIndex] = 1
                coordXArray[arrayIndex] = ex
                coordYArray[arrayIndex] = y
                colorArray[arrayIndex] = color
                indexArray[arrayIndex] = startIndex
                originToArray[startIndex] = arrayIndex

                dataChange[arrayIndex] = false
                --colorChange[arrayIndex] = color
            end

            for i = 0, sx - 1 do
                indexToOrigin[startIndex + i] = startIndex
            end

            rootAvaliable = false
        end

        if eMx > x then
            local nx, sx = x + 1, eMx - x
            local startIndex = (y - 1) * width + nx

            if rootAvaliable then
                scaleXArray[arrayPointer] = sx
                scaleYArray[arrayPointer] = 1
                coordXArray[arrayPointer] = nx
                coordYArray[arrayPointer] = y
                colorArray[arrayPointer] = color
                indexArray[arrayPointer] = startIndex
                originToArray[startIndex] = arrayPointer

                dataChange[arrayPointer] = true
                --colorChange[arrayPointer] = color
            else
                arrayIndex = arrayIndex + 1
                effectArray[arrayIndex] = createEffect()
                scaleXArray[arrayIndex] = sx
                scaleYArray[arrayIndex] = 1
                coordXArray[arrayIndex] = nx
                coordYArray[arrayIndex] = y
                colorArray[arrayIndex] = color
                indexArray[arrayIndex] = startIndex
                originToArray[startIndex] = arrayIndex

                dataChange[arrayIndex] = false
                --colorChange[arrayIndex] = color
            end
            
            for i = 0, sx - 1 do
                indexToOrigin[startIndex + i] = startIndex
            end

            rootAvaliable = false
        end

        if ey < y then
            local sy = y - ey
            local startIndex = (ey - 1) * width + ex

            if rootAvaliable then
                scaleXArray[arrayPointer] = eSx
                scaleYArray[arrayPointer] = sy
                coordXArray[arrayPointer] = ex
                coordYArray[arrayPointer] = ey
                colorArray[arrayPointer] = color
                indexArray[arrayPointer] = startIndex
                originToArray[startIndex] = arrayPointer

                dataChange[arrayPointer] = true
                --colorChange[arrayPointer] = color
            else
                arrayIndex = arrayIndex + 1
                effectArray[arrayIndex] = createEffect()
                scaleXArray[arrayIndex] = eSx
                scaleYArray[arrayIndex] = sy
                coordXArray[arrayIndex] = ex
                coordYArray[arrayIndex] = ey
                colorArray[arrayIndex] = color
                indexArray[arrayIndex] = startIndex
                originToArray[startIndex] = arrayIndex

                dataChange[arrayIndex] = false
                --colorChange[arrayIndex] = color
            end

            local x1, y1 = ex, ey
            local mx = ex + eSx - 1
            
            for _ = 1, eSx * sy do
                indexToOrigin[(y1 - 1) * width + x1] = startIndex

                x1 = x1 + 1

                if x1 > mx then
                    x1 = ex
                    y1 = y1 + 1
                end
            end

            rootAvaliable = false
        end

        if eMy > y then
            local ny, sy = y + 1, eMy - y
            local startIndex = (ny - 1) * width + ex

            if rootAvaliable then
                scaleXArray[arrayPointer] = eSx
                scaleYArray[arrayPointer] = sy
                coordXArray[arrayPointer] = ex
                coordYArray[arrayPointer] = ny
                colorArray[arrayPointer] = color
                indexArray[arrayPointer] = startIndex
                originToArray[startIndex] = arrayPointer

                dataChange[arrayPointer] = true
                --colorChange[arrayPointer] = color
            else
                arrayIndex = arrayIndex + 1
                effectArray[arrayIndex] = createEffect()
                scaleXArray[arrayIndex] = eSx
                scaleYArray[arrayIndex] = sy
                coordXArray[arrayIndex] = ex
                coordYArray[arrayIndex] = ny
                colorArray[arrayIndex] = color
                indexArray[arrayIndex] = startIndex
                originToArray[startIndex] = arrayIndex

                dataChange[arrayIndex] = false
                --colorChange[arrayIndex] = color
            end

            local x1, y1 = ex, ny
            local mx = ex + eSx - 1
            
            for _ = 1, eSx * sy do
                indexToOrigin[(y1 - 1) * width + x1] = startIndex

                x1 = x1 + 1

                if x1 > mx then
                    x1 = ex
                    y1 = y1 + 1
                end
            end

            rootAvaliable = false
        end

        if createAtRoot then
            local startIndex = (y - 1) * width + x
            scaleXArray[arrayPointer] = 1
            scaleYArray[arrayPointer] = 1
            coordXArray[arrayPointer] = x
            coordYArray[arrayPointer] = y
            indexArray[arrayPointer] = startIndex
            originToArray[startIndex] = arrayPointer

            indexToOrigin[startIndex] = startIndex
            dataChange[arrayPointer] = true

            return arrayPointer
        else
            if rootAvaliable then
                suspendEffect(arrayPointer)
            end

            indexToOrigin[index] = nil
        end

        updatedPoints[index] = nil
    end

    local function meshBufferPC(index, color)
        local mSx = 1
        local x, y = (index - 1) % width + 1, math_floor((index - 1) / width) + 1

        for x1 = 1, width - x do
            local cIndex = index + x1

            if indexToOrigin[cIndex] or newBuffer[cIndex] ~= color then
                break
            end

            mSx = mSx + 1
        end

        local x1, y1, mx = x, y + 1, x + mSx - 1 
        local mSy = 1

        for _ = 1, mSx * (height - y) do
            local cIndex = (y1 - 1) * width + x1

            if indexToOrigin[cIndex] or newBuffer[cIndex] ~= color then
                return mSx, mSy
            end

            x1 = x1 + 1

            if x1 > mx then
                x1 = x
                y1 = y1 + 1
                mSy = mSy + 1
            end
        end

        return mSx, y1 - y
    end

    local function meshBuffer(index, color)
        local mSx = 1
        local x, y = (index - 1) % width + 1, math_floor((index - 1) / width) + 1

        for x1 = 1, width - x do
            if newBuffer[index + x1] ~= color then
                break
            end

            mSx = mSx + 1
        end

        local x1, y1, mx = x, y + 1, x + mSx - 1 
        local mSy = 1

        for _ = 1, mSx * (height - y) do
            if newBuffer[(y1 - 1) * width + x1] ~= color then
                return mSx, mSy
            end

            x1 = x1 + 1

            if x1 > mx then
                x1 = x
                y1 = y1 + 1
                mSy = mSy + 1
            end
        end

        return mSx, y1 - y
    end

    if not hasUpdated and hasCleared then
        for i = 1, arrayIndex do
            local effect = effectArray[i]
            
            if sm_exists(effect) then
                effect_destroy(effect)
            end

            effectArray[i] = nil
            scaleXArray[i] = nil
            scaleYArray[i] = nil
            coordXArray[i] = nil
            coordYArray[i] = nil
            colorArray[i] = nil
            indexArray[i] = nil
        end

        arrayIndex = 0

        if stoppedIndex > 1 then
            local itterated = {}

            for _, effect in pairs(stoppedEffects) do
                if not itterated[effect.id] then
                    effect_destroy(effect)
                    itterated[effect.id] = true
                end
            end

            --clearTable(offsetBuffer)
            clearTable(stoppedEffects)
            stoppedIndex = 0
        end

        clearTable(indexToOrigin)
        clearTable(originToArray)
        clearTable(dataChange)
        clearTable(colorChange)
        clearTable(updatedPoints)
    elseif hasUpdated then
        self_cl.hasUpdated = true

        if hasCleared then
            for i in pairs(updatedPoints) do
                local originIndex = indexToOrigin[i]
                local arrayPointer = originIndex and originToArray[originIndex]
                local colNew = newBuffer[i]
                local notEqual = colNew and colNew ~= backpanelColor
                fullBuffer[i] = colNew

                if arrayPointer and colorArray[arrayPointer] ~= colNew then
                    local sx, sy = scaleXArray[arrayPointer], scaleYArray[arrayPointer]
                    
                    local bsx, bsy = 1, 1
                    if notEqual then
                        bsx, bsy = meshBuffer(originIndex, colNew)
                    end

                    local equalCheck = bsx == sx and bsy == sy

                    if not equalCheck and (sx > 1 or sy > 1) then
                        arrayPointer = splitEffect(i, notEqual, colNew)
                    elseif equalCheck and not notEqual then
                        local x, y = (i - 1) % width + 1, math_floor((i - 1) / width) + 1
                        local x1, y1, mx = x, y, x + sx - 1

                        for _ = 1, sx * sy do
                            local index = (y1 - 1) * width + x1

                            updatedPoints[index] = nil
                            indexToOrigin[index] = nil

                            if x1 > mx then
                                x1 = x
                                y1 = y1 + 1
                            end
                        end

                        suspendEffect(arrayPointer)
                        arrayPointer = nil
                    end
                    
                    if arrayPointer and (equalCheck or not meshNeighbours(i, colNew)) then
                        colorArray[arrayPointer] = colNew
                        colorChange[arrayPointer] = colNew
                    end
                elseif not arrayPointer and notEqual and not meshNeighbours(i, colNew) then
                    local effect = createEffect()
                    local x, y = (i - 1) % width + 1, math_floor((i - 1) / width) + 1
                    local sx, sy = meshBufferPC(i, colNew)

                    arrayIndex = arrayIndex + 1
                    effectArray[arrayIndex] = effect
                    scaleXArray[arrayIndex] = sx
                    scaleYArray[arrayIndex] = sy
                    coordXArray[arrayIndex] = x
                    coordYArray[arrayIndex] = y
                    colorArray[arrayIndex] = colNew
                    indexArray[arrayIndex] = i

                    originToArray[i] = arrayIndex

                    if sx == 1 and sy == 1 then
                        indexToOrigin[i] = i
                    else
                        local x1, y1, mx = x, y, x + sx - 1

                        for _ = 1, sx * sy do
                            indexToOrigin[(y1 - 1) * width + x1] = i

                            x1 = x1 + 1

                            if x1 > mx then
                                x1 = x
                                y1 = y1 + 1
                            end
                        end
                    end

                    dataChange[arrayIndex] = false
                    --colorChange[arrayIndex] = colNew
                end
            end
        else
            for i, colNew in pairs(newBuffer) do
                local originIndex = indexToOrigin[i]
                local arrayPointer = originIndex and originToArray[originIndex]
                local notEqual = colNew ~= backpanelColor
                fullBuffer[i] = colNew

                if arrayPointer and colorArray[arrayPointer] ~= colNew then
                    local sx, sy = scaleXArray[arrayPointer], scaleYArray[arrayPointer]
                    
                    local bsx, bsy = 1, 1
                    if notEqual then
                        bsx, bsy = meshBuffer(originIndex, colNew)
                    end

                    local equalCheck = bsx == sx and bsy == sy

                    if not equalCheck and (sx > 1 or sy > 1) then
                        arrayPointer = splitEffect(i, notEqual, colNew)
                    elseif equalCheck and not notEqual then
                        local x, y = (i - 1) % width + 1, math_floor((i - 1) / width) + 1
                        local x1, y1, mx = x, y, x + sx - 1

                        for _ = 1, sx * sy do
                            local index = (y1 - 1) * width + x1

                            updatedPoints[index] = nil
                            indexToOrigin[index] = nil

                            if x1 > mx then
                                x1 = x
                                y1 = y1 + 1
                            end
                        end

                        suspendEffect(arrayPointer)
                        arrayPointer = nil
                    end
                    
                    if arrayPointer and (equalCheck or not meshNeighbours(i, colNew)) then
                        colorArray[arrayPointer] = colNew
                        colorChange[arrayPointer] = colNew
                    end
                elseif not arrayPointer and notEqual and not meshNeighbours(i, colNew) then
                    local effect = createEffect()
                    local x, y = (i - 1) % width + 1, math_floor((i - 1) / width) + 1
                    local sx, sy = meshBufferPC(i, colNew)

                    arrayIndex = arrayIndex + 1
                    effectArray[arrayIndex] = effect
                    scaleXArray[arrayIndex] = sx
                    scaleYArray[arrayIndex] = sy
                    coordXArray[arrayIndex] = x
                    coordYArray[arrayIndex] = y
                    colorArray[arrayIndex] = colNew
                    indexArray[arrayIndex] = i

                    originToArray[i] = arrayIndex

                    if sx == 1 and sy == 1 then
                        indexToOrigin[i] = i
                    else
                        local x1, y1, mx = x, y, x + sx - 1

                        for _ = 1, sx * sy do
                            indexToOrigin[(y1 - 1) * width + x1] = i

                            x1 = x1 + 1

                            if x1 > mx then
                                x1 = x
                                y1 = y1 + 1
                            end
                        end
                    end

                    dataChange[arrayIndex] = false
                    --colorChange[arrayIndex] = colNew
                end
            end
        end

        for arrayPointer, initCheck in pairs(dataChange) do
            local effect = effectArray[arrayPointer]
            local sx     = scaleXArray[arrayPointer]
            local sy     = scaleYArray[arrayPointer]
            local x      = coordXArray[arrayPointer]
            local y      = coordYArray[arrayPointer]
            local color  = colorArray[arrayPointer]

            if initCheck and effect_isPlaying(effect) then
                effect_stop(effect)
            end

            local scaleY = pixel_scale_y * sy
            local scaleX = pixel_scale_z * sx

            local centerX = x - 1 + (sx - 1) * 0.5
            local centerY = y - 1 + (sy - 1) * 0.5
            
            local scaleYFinal = scaleY + pixelBorderMultiplier * pixel_scale_y
            local scaleXFinal = scaleX + pixelBorderMultiplier * pixel_scale_z

            effect_setScale(effect, sm_vec3_new(0, scaleYFinal, scaleXFinal))

            local xPos, yPos = pixelPosToShapePos(centerX, centerY, widthScale, heightScale, pixel_scale_y, pixel_scale_z)
            effect_setOffsetPosition(effect, sm_vec3_new(pixelDepth, yPos, xPos))

            effect_setParameter(effect, "color", idToColor(color))

            if not isHidden then
                effect_start(effect)
            end
        end

        for arrayPointer, color in pairs(colorChange) do
            local effect = effectArray[arrayPointer]

            -- if effect_isPlaying(effect) then
            --     effect_stop(effect)
            -- end

            effect_setParameter(effect, "color", idToColor(color))

            if not (isHidden or effect_isPlaying(effect)) then
                effect_start(effect)
            end
        end
    end

    self_cl.arrayIndex = arrayIndex
    self_cl.stoppedIndex = stoppedIndex
end

function DisplayClass:cl_optimiseDisplay()
    local self_cl = self.cl
    local self_cl_pixel = self_cl.pixel
    local self_cl_display = self_cl.display
    local self_interactable = self.interactable
    local self_data = self.data
    local width, height = self_data.width, self_data.height
    local threshold = self_cl_display.threshold
    local stoppedIndex = self_cl.stoppedIndex
    local stoppedEffects = self_cl_pixel.stoppedEffects
    local isHidden = self_cl_display.isHidden

    local self_data_panelOffset = self_data.panelOffset
    local pixel_scale = self_cl_pixel.pixelScale
    local pixel_scale_y = pixel_scale.y
    local pixel_scale_z = pixel_scale.z
    local pixelDepth = self_data_panelOffset and self_data_panelOffset + 0.001 or 0.116
    local widthScale = self_cl_display.widthScale
    local heightScale = self_cl_display.heightScale

    local indexToOrigin = self_cl.indexToOrigin
    local originToArray = self_cl.originToArray
    local arrayIndex = self_cl.arrayIndex
    local effectArray = self_cl.effectArray
    local colorArray = self_cl.colorArray
    local indexArray = self_cl.indexArray

    local function createEffect()
        local effect

        if stoppedIndex > 0 then
            effect = stoppedEffects[stoppedIndex]
            stoppedEffects[stoppedIndex] = nil
            stoppedIndex = stoppedIndex - 1
        else
            effect = sm_effect_createEffect(pixelEffect, self_interactable)
        end

        return effect
    end

    local function setEffectParameters(effect, sx, sy, x, y, color)
        local scaleY = pixel_scale_y * sy
        local scaleX = pixel_scale_z * sx

        local centerX = x - 1 + (sx - 1) * 0.5
        local centerY = y - 1 + (sy - 1) * 0.5
        
        local scaleYFinal = scaleY + pixelBorderMultiplier * pixel_scale_y
        local scaleXFinal = scaleX + pixelBorderMultiplier * pixel_scale_z

        effect_setScale(effect, sm_vec3_new(0, scaleYFinal, scaleXFinal))

        local xPos, yPos = pixelPosToShapePos(centerX, centerY, widthScale, heightScale, pixel_scale_y, pixel_scale_z)
        effect_setOffsetPosition(effect, sm_vec3_new(pixelDepth, yPos, xPos))
        effect_setParameter(effect, "color", idToColor(color))

        if not (isHidden or effect_isPlaying(effect)) then
            effect_start(effect)
        end
    end

    local processed = {}

    local function meshBuffer(index, color)
        local mSx = 1
        local x, y = (index - 1) % width + 1, math_floor((index - 1) / width) + 1

        processed[index] = true

        for x1 = 1, width - x do
            local testIndex = index + x1
            local originIndex = indexToOrigin[testIndex]
            local arrayPointer = originIndex and originToArray[originIndex]

            if processed[testIndex] or not arrayPointer or not areColorsSimilar(colorArray[arrayPointer], color, threshold) then
                break
            end

            processed[testIndex] = true
            mSx = mSx + 1
        end

        local x1, y1, mx = x, y + 1, x + mSx - 1 

        for _ = 1, mSx * (height - y) do
            local testIndex = (y1 - 1) * width + x1
            local originIndex = indexToOrigin[testIndex]
            local arrayPointer = originIndex and originToArray[originIndex]

            if processed[testIndex] or not arrayPointer or not areColorsSimilar(colorArray[arrayPointer], color, threshold) then
                return mSx, y1 - y 
            end

            x1 = x1 + 1

            if x1 > mx then
                local rowIndex = (y1 - 1) * width + x
                for i = 0, mSx - 1 do
                    processed[rowIndex + i] = true
                end

                x1 = x
                y1 = y1 + 1
            end
        end

        return mSx, y1 - y 
    end

    for i = 1, arrayIndex do
        local effect = effectArray[i]

        stoppedIndex = stoppedIndex + 1
        stoppedEffects[stoppedIndex] = effect
        --effect_setOffsetPosition(effect, rePos)
        effect_stop(effect)
    end

    local newArrayIndex = 0
    local newEffectArray = {}
    local newScaleXArray = {}
    local newScaleYArray = {}
    local newCoordXArray = {}
    local newCoordYArray = {}
    local newColorArray = {}
    local newIndexArray = {}
    local newOriginToArray = {}
    local newIndexToOrigin = {}

    local totalPixels = width * height
    for testIndex = 1, totalPixels do
        if not processed[testIndex] then
            local originIndex = indexToOrigin[testIndex]
            local arrayPointer = originIndex and originToArray[originIndex]

            if arrayPointer then
                local color = colorArray[arrayPointer]
                local sx, sy = meshBuffer(testIndex, color)

                local effect = createEffect()
                local x, y = (testIndex - 1) % width + 1, math_floor((testIndex - 1) / width) + 1

                newArrayIndex = newArrayIndex + 1
                newEffectArray[newArrayIndex] = effect
                newScaleXArray[newArrayIndex] = sx
                newScaleYArray[newArrayIndex] = sy
                newCoordXArray[newArrayIndex] = x
                newCoordYArray[newArrayIndex] = y
                newColorArray[newArrayIndex] = color
                newIndexArray[newArrayIndex] = testIndex
                newOriginToArray[testIndex] = newArrayIndex

                if sx == 1 and sy == 1 then
                    newIndexToOrigin[testIndex] = testIndex
                else
                    local x1, y1, mx = x, y, x + sx - 1
                    for _ = 1, sx * sy do
                        newIndexToOrigin[(y1 - 1) * width + x1] = testIndex
                        x1 = x1 + 1
                        if x1 > mx then
                            x1 = x
                            y1 = y1 + 1
                        end
                    end
                end

                setEffectParameters(effect, sx, sy, x, y, color)
            end
        end
    end

    if stoppedIndex > 500 then
        for i = 501, stoppedIndex do
            effect_destroy(stoppedEffects[i])
            stoppedEffects[i] = nil
        end

        stoppedIndex = 500
    end

    self_cl.effectArray = newEffectArray
    self_cl.scaleXArray = newScaleXArray
    self_cl.scaleYArray = newScaleYArray
    self_cl.coordXArray = newCoordXArray
    self_cl.coordYArray = newCoordYArray
    self_cl.colorArray = newColorArray
    self_cl.indexArray = newIndexArray
    self_cl.originToArray = newOriginToArray
    self_cl.indexToOrigin = newIndexToOrigin

    self_cl.arrayIndex = newArrayIndex
    self_cl.stoppedIndex = stoppedIndex
end

function DisplayClass:cl_setVisibility(setHidden)
    local self_cl = self.cl

    if setHidden ~= self_cl.display.isHidden then
        self_cl.display.isHidden = setHidden

        for _, effect in pairs(self_cl.effectArray) do
            if sm_exists(effect) then
                if setHidden then
                    if effect_isPlaying(effect) then
                        effect_stop(effect)
                    end
                else
                    if not effect_isPlaying(effect) then
                        effect_start(effect)
                    end
                end
            end
        end

        -- if setHidden then
        --     for _, effect in pairs(self_cl.pixel.stoppedEffects) do
        --         if effect_isPlaying(effect) then
        --             effect_stop(effect)
        --         end
        --     end

        --     --self_cl.offsetBuffer = {}
        -- end
    end
end

sm.scrapcomputers.componentManager.toComponent(DisplayClass, "Displays", true, nil, true)