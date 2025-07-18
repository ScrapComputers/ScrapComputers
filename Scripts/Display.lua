local sm_scrapcomputers_ascfManager_applyDisplayFunctions = sm.scrapcomputers.ascfManager.applyDisplayFunctions
local sm_scrapcomputers_errorHandler_assertArgument = sm.scrapcomputers.errorHandler.assertArgument
local sm_scrapcomputers_errorHandler_assert = sm.scrapcomputers.errorHandler.assert
local sm_scrapcomputers_languageManager_translatable = sm.scrapcomputers.languageManager.translatable
local sm_scrapcomputers_fontManager_getFont = sm.scrapcomputers.fontManager.getFont
local sm_scrapcomputers_table_getTableSize = sm.scrapcomputers.table.getTableSize

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

---@class DisplayClass : ShapeClass
DisplayClass = class()
DisplayClass.maxParentCount = 1
DisplayClass.maxChildCount = 0
DisplayClass.connectionInput = sm.interactable.connectionType.compositeIO
DisplayClass.connectionOutput = sm.interactable.connectionType.none
DisplayClass.colorNormal = sm_color_new(0x696969ff)
DisplayClass.colorHighlight = sm_color_new(0x969696ff)

-- CLIENT/SERVER --

local localPlayer = sm.localPlayer
local camera = sm.camera
local tinkerBind = sm.gui.getKeyBinding("Tinker", true)
local interactBind = sm.gui.getKeyBinding("Use", true)

local PIXEL_UUID = sm.uuid.new("cd943f04-96c7-43f0-852c-b2d68c7fc157")
local BACKPANEL_EFFECT_NAME = "ScrapComputers - ShapeRenderableBackPanel"
local effectPrefix = "ScrapComputers - ShapeRenderable"
local rePos = sm_vec3_new(0, 0, -10000)

local tableLimit = 15000
local displayHidingCooldown = 0.5
local optimiseCooldown = 1
local pixelBorderMultiplier = 0.05

local imagePath = "$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/DisplayImages/"

local networkInstructions = {
    "cl_takeSnapshot",
    "cl_setColorThreshold",
    "cl_setVisibility",
    "cl_setRenderDistance",
    "cl_setTouchState"
}

local dataCountLookup = {
    3,
    5,
    1,
    5,
    8,
    6,
    7,
    2
}

local function pixelPosToShapePos(x, y, widthScale, heightScale, pixelScaleY, pixelScaleZ)
    local v1 = pixelScaleZ * 0.01
    local v2 = pixelScaleY * 0.01

    return widthScale * -0.5 + v1 * 0.5 + 0.02 + x * v1, heightScale * -0.5 + v2 * 0.5 + 0.02 + y * v2
end


local function shapePosToPixelPos(point, widthScale, heightScale, pixelScaleY, pixelScaleZ)
    return 100 / pixelScaleZ * (point.z - 0.02 + widthScale / 2 - pixelScaleZ / 200) + 1, 100 / pixelScaleY * (point.y - 0.02 + heightScale / 2 - pixelScaleY / 200) + 1
end

local function round(numb)
    return math_floor(numb + 0.5)
end

local function areColorsSimilar(color1, color2, threshold)
    if threshold == 0 then return color1 == color2 end

    local r1, g1, b1 = bit_band(bit_rshift(color1, 16), 255), bit_band(bit_rshift(color1, 8), 255), bit_band(color1, 255)
    local r2, g2, b2 = bit_band(bit_rshift(color2, 16), 255), bit_band(bit_rshift(color2, 8), 255), bit_band(color2, 255)

    local dr, dg, db = r1 - r2, g1 - g2, b1 - b2
    return (dr * dr + dg * dg + db * db) <= (threshold * 255)^2 * 3
end



-- Gets the UTF8 char from a string as string_sub messes up special characters
---@param str string The string
---@param index number The UTF8 character to select
---@return string UTF8Character The UTF8 character returned.
local function getUTF8Character(str, index)
    local byte = string_byte(str, index)
    local byteCount = 1

    if byte >= 0xC0 and byte <= 0xDF then
        byteCount = 2
    elseif byte >= 0xE0 and byte <= 0xEF then
        byteCount = 3
    elseif byte >= 0xF0 and byte <= 0xF7 then
        byteCount = 4
    end

    return string_sub(str, index, index + byteCount - 1)
end

local function getUTF8StringSize(str)
    local length = 0
    local index = 1

    while index <= #str do
        local byte = string_byte(str, index)

        if byte >= 0 and byte <= 127 then
            index = index + 1
        elseif byte >= 192 and byte <= 223 then
            index = index + 2
        elseif byte >= 224 and byte <= 239 then
            index = index + 3
        elseif byte >= 240 and byte <= 247 then
            index = index + 4
        else
            index = index + 1
        end

        length = length + 1
    end

    return length
end

local function coordinateToIndex(x, y, width)
    return (y - 1) * width + x
end

local function indexToCoordinate(index, width)
    return (index - 1) % width + 1, math_floor((index - 1) / width) + 1
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

local function colorToID(color)
    if not color then
        color = sm_color_new(0, 0, 0)
    elseif type(color) == "string" then
        color = sm_color_new(color)
    elseif type(color) == "number" then
        return color
    end

    local scale = 255
    return bit_bor(bit_lshift(math_floor(color.r * scale), 16), bit_lshift(math_floor(color.g * scale), 8), math_floor(color.b * scale))
end

local function idToColor(colorID)
    local scale = 1 / 255

    return sm_color_new(
        bit_band(bit_rshift(colorID, 16), 0xFF) * scale,
        bit_band(bit_rshift(colorID, 8), 0xFF) * scale,
        bit_band(colorID, 0xFF) * scale
    )
end


-- SERVER --

-- Creates all functions for the display
function DisplayClass:sv_createData()
    local shapeId = self.shape.id
    local clearCache = false
    local data = self.data
    local data_width = data.width
    local data_height = data.height
    local dataBuffer = {}
    local dataIndex = 0

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

        sm_scrapcomputers_errorHandler_assert(radius, 3, "Radius is too small!")

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

        clearCache = true
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

        clearCache = true
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

        clearCache = true
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
        end,

        -- Clear the display
        ---@param color MultiColorType The new background color or 000000
        clear = function (color)
            local clearColor = colorToID(color)
            
            dataBuffer = {}
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
        drawCircle = function (x, y, radius, color) drawCricle(x, y, radius, color, false) end,

        -- Draws a filled circle
        ---@param x number The x-coordinate
        ---@param y number The y-coordinate
        ---@param radius number The radius of the circle
        ---@param color MultiColorType The color of the circle
        drawFilledCircle = function (x, y, radius, color) drawCricle(x, y, radius, color, true) end,

        -- Draws a triangle
        ---@param x1 number The 1st point on X-axis
        ---@param y1 number The 1st point on Y-axis
        ---@param x2 number The 2nd point on X-axis
        ---@param y2 number The 2nd point on Y-axis
        ---@param x3 number The 3rd point on X-axis
        ---@param y3 number The 3rd point on Y-axis
        ---@param color MultiColorType The color of the triangle
        drawTriangle = function (x1, y1, x2, y2, x3, y3, color) drawTriangle(x1, y1, x2, y2, x3, y3, color, false) end,

        -- Draws a filled triangle
        ---@param x1 number The 1st point on X-axis
        ---@param y1 number The 1st point on Y-axis
        ---@param x2 number The 2nd point on X-axis
        ---@param y2 number The 2nd point on Y-axis
        ---@param x3 number The 3rd point on X-axis
        ---@param y3 number The 3rd point on Y-axis
        ---@param color MultiColorType The color of the triangle
        drawFilledTriangle = function (x1, y1, x2, y2, x3, y3, color) drawTriangle(x1, y1, x2, y2, x3, y3, color, true) end,

        -- Draws a rectangle
        ---@param x number The x-coordinate
        ---@param y number The y-coordinate
        ---@param width number The width of the rectangle
        ---@param height number The height of the triangle
        ---@param color MultiColorType The color of the rectangle
        drawRect = function (x, y, width, height, color) drawRect(x, y, width, height, color, false) end,

        -- Draws a filled rectangle
        ---@param x number The x-coordinate
        ---@param y number The y-coordinate
        ---@param width number The width of the rectangle
        ---@param height number The height of the triangle
        ---@param color MultiColorType The color of the rectangle
        drawFilledRect = function (x, y, width, height, color) drawRect(x, y, width, height, color, true) end,

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

            sm_scrapcomputers_errorHandler_assertArgument(maxWidth, 5, {"boolean", "nil"})
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
        ---@param tbl PointTable The table of points
        ---@param color color The color of the created shape
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

            local stringSize = getUTF8StringSize(text)

            if not wordWrappingEnabled then
                if dynamicHeight then
                    local height = 0
                    local index = 1
                    while index <= #text do
                        local char = getUTF8Character(text, index)
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

        -- Gets the latest touch data.
        getTouchData = function()
            return self.sv.display.touchData
        end,

        -- Gets a table touch data to accomodate multiple players pressing the screen.
        getTouchTable = function()
            return self.sv.display.touchTbl
        end,

        -- Returns display's id
        ---@return integer id The display's shape id.
        getId = function()
            return self.shape.id
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
            local self_sv = self.sv

            local lastBuffer = self_sv.lastBuffer
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
                local maxLen = math_max(lastLength, dataIndex)
                local i = 0

                while not update and i < maxLen do
                    i = i + 1
                    update = dataBuffer[i] ~= lastBuffer[i]
                end
            end

            if update then
                local currBuffer = self_sv.buffer.data

                if currBuffer[1] then
                    local selIndex = #currBuffer

                    for i = 1, #dataBuffer do
                        local data = dataBuffer[i]

                        selIndex = selIndex + 1
                        currBuffer[selIndex] = data
                    end
                else
                    currBuffer = dataBuffer
                end

                self_sv.buffer.data = currBuffer
                self_sv.lastBuffer = currBuffer
                self_sv.lastBufferLen = #currBuffer
                self_sv.allowUpdate = true
            end

            dataBuffer = {}
            dataIndex = 0
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
            threshold = 0.005,
            touchTbl = {}
        },

        pixel = {
            pixelData = {},
            backPanel = sm_color_new("000000")
        },

        buffer = {
            data = {},
            network = {},
            syncBuffer = {},
            snapshotBuild = {}
        },

        snapshotTable = {},
        totalPlayers = 1
    }
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
            self.cl.buffer.data = dataBuffer
            sendToClients(self_network, "cl_pushData")
        end

        self_sv_buffer.data = {}
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
    self.cl = {
        pixel = {
            stoppedEffects = {},
            selectionIndex = 0,

            pixelScale = sm.vec3.zero()
        },

        buffer = {
            data = {},
            indexes = {},
            instructions = {},
            tables = {}
        },

        backPanel = {
            effect = sm_effect_createEffect(BACKPANEL_EFFECT_NAME, self.interactable),
            defaultColor = 0,
            currentColor = 0
        },

        display = {
            renderDistance = 10,
            visTimer = 0,
            threshold =  0.005
        },

        pixels = {},
        startBuffer = {},
        stopBuffer = {},
        newBuffer = {},
        updatedPoints = {},
        stoppedIndex = 0,
        totalEffects = 0,
        lastLen = 1
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
    local bgScale = sm_vec3_new(0, (self.cl.display.heightScale - offset) * 100, (self.cl.display.widthScale - offset) * 100)

    self.cl.pixel.pixelScale = sm_vec3_new(0, bgScale.y / height, bgScale.z / width)

    effect_setParameter(self.cl.backPanel.effect, "uuid", PIXEL_UUID)
    effect_setParameter(self.cl.backPanel.effect,"color", idToColor(self.cl.backPanel.defaultColor))

    effect_setOffsetPosition(self.cl.backPanel.effect, sm_vec3_new(self.data.panelOffset or 0.115, 0, 0))
    effect_setScale(self.cl.backPanel.effect, bgScale)

    effect_start(self.cl.backPanel.effect)
end

function DisplayClass:cl_setRenderDistance(param)
    self.cl.display.renderDistance = param
end

function DisplayClass:cl_setColorThreshold(param)
    self.cl.display.threshold = param
end

function DisplayClass:cl_setTouchState(param)
    self.cl.display.touchAllowed = param
end

function DisplayClass:cl_setUserHidden(bool)
    self.cl.display.userHidden = bool
end

function DisplayClass:cl_takeSnapshot()
    local colorTbl = {}
    local self_network = self.network
    local sendToServer = self_network.sendToServer
    
    for i, effectData in pairs(self.cl.pixels) do
        colorTbl[i] = effectData[6]
    end

    if self.cl.lastLen > 1 then
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
            if (not self_cl.lastLen or len > self_cl.lastLen) and #players > 1 then
                local dataTbl = {3, self_cl_backPanel.currentColor}
                local dataIndex = 2

                for index, data in pairs(self_cl.pixels) do
                    local x, y = indexToCoordinate(index, self_data.width)

                    dataIndex = dataIndex + 1
                    dataTbl[dataIndex] = 1
                    dataIndex = dataIndex + 1
                    dataTbl[dataIndex] = x
                    dataIndex = dataIndex + 1
                    dataTbl[dataIndex] = y
                    dataIndex = dataIndex + 1
                    dataTbl[dataIndex] = data[6]
                end

                local chunks = splitTable(dataTbl, tableLimit)
                local self_network = self.network
                local sendToServer = self_network.sendToServer

                local len = #chunks

                for i, chunk in pairs(chunks) do
                    sendToServer(self_network, "sv_mpScreenSync", {chunk, i == len})
                end

                local tertiaryData = {
                    threshold = self_cl_display.threshold,
                    touchAllowed = self_cl_display.touchAllowed,
                    renderDistance = self_cl_display.renderDistance,
                    backPanel = self_cl_backPanel.currentColor
                }

                sendToServer(self_network, "sv_setTertiaryData", tertiaryData)
            end

            self_cl.lastLen = len

            self.network:sendToServer("sv_setTotalPlayers", len)
        end
    end

    if self_cl.raycastValid and self_cl.display.touchAllowed then
        if self_cl.lastLangUpdate ~= lastLangUpdt or self_cl.seatState ~= self_cl.characterSeated then
            self_cl.lastLangUpdate = lastLangUpdt
            self_cl.seatState = self_cl.characterSeated

            if self_cl.characterSeated then
                self_cl.interactionText = sm_scrapcomputers_languageManager_translatable("scrapcomputers.display.touchscreen", tinkerBind)
            else
                self_cl.interactionText = sm_scrapcomputers_languageManager_translatable("scrapcomputers.display.touchscreen_multi", interactBind, tinkerBind)
            end
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
        if self_cl.doOptimise and self_cl.hasUpdated then
            self_cl.lastOptimise = clock
            self_cl.hasUpdated = false

            self:cl_optimiseDisplay()
        end

        self_cl.backPanelCheck = true
    end

    self_cl.lastCamPos = pos
end

function DisplayClass:client_onUpdate(dt)
    local self_cl = self.cl
    local self_shape = self.shape

    if self_cl.raycastValid and self_cl.display.touchAllowed and self_cl.interactionText then
        sm.gui.setInteractionText("", self_cl.interactionText, "")
        sm.gui.setInteractionText("")
    elseif self_cl.isRaycasted then
        sm.gui.setInteractionText("")
        sm.gui.setInteractionText("")
    end

    local pos = camera.getPosition()
    local dir = camera.getDirection()
    local projectedOffset = localPlayer.getPlayer().character.velocity * dt
    local hit, res = sm_physics_raycast(pos + projectedOffset, (pos + dir * 7.5) + projectedOffset , nil, sm.physics.filter.dynamicBody + sm.physics.filter.staticBody)

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

function DisplayClass:client_canInteract()
    return true
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
    return true
end

function DisplayClass:cl_pushData()
    local newBuffer = {}
    local knownRects = {}
    local hasCleared = false
    local self_cl = self.cl
    local self_cl_backPanel = self_cl.backPanel
    local self_data = self.data
    local width = self_data.width
    local height = self_data.height
    local updatedPoints = self_cl.updatedPoints
    local hasUpdated = false
    local newBufferLen = 0

    local function addPixel(x, y, color)
        if x > 0 and x <= width and y > 0 and y <= height then
            index = (y - 1) * width + x

            newBufferLen = newBufferLen + 1
            newBuffer[index] = color
            updatedPoints[index] = true
        end
    end

    local function addToTable(params)
        addPixel(params[1], params[2], params[3])

        hasUpdated = true
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
        
        hasUpdated = true
    end

    local function drawLine(params)
        local x0, y0 = params[1], params[2]
        local x1, y1 = params[3], params[4]
        local color = params[5]
    
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
        
        hasUpdated = true
    end

    local function clearDisplay(params)
        hasCleared = true
        newBuffer = {}

        local param_color = params[1]
    
        if param_color and param_color ~= self_cl_backPanel.currentColor then
            local color = idToColor(param_color)

            effect_setParameter(self_cl_backPanel.effect, "color", color)
            self_cl_backPanel.currentColor = color
        end
    end

    local function drawCircle(params)
        local x, y = params[1], params[2]
        local radius = params[3]
        local color = params[4]
        local isFilled = params[5]
    
        local f = 1 - radius
        local ddF_x = 1
        local ddF_y = -2 * radius
        local cx = 0
        local cy = radius
    
        local function plot(xp, yp)
            addPixel(xp, yp, color)
        end
    
        if isFilled then
            scaledAdd(x - radius, y, radius * 2 + 1, 1, color)
        else
            plot(x, y + radius)
            plot(x, y - radius)
            plot(x + radius, y)
            plot(x - radius, y)
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
                plot(x + cx, y + cy)
                plot(x - cx, y + cy)
                plot(x + cx, y - cy)
                plot(x - cx, y - cy)
                plot(x + cy, y + cx)
                plot(x - cy, y + cx)
                plot(x + cy, y - cx)
                plot(x - cy, y - cx)
            end
        end
        
        hasUpdated = true
    end

    local function drawTriangle(params)
        local x1, y1 = params[1], params[2]
        local x2, y2 = params[3], params[4]
        local x3, y3 = params[5], params[6]
        local color = params[7]
        local isFilled = params[8]
    
        drawLine({x1, y1, x2, y2, color})
        drawLine({x2, y2, x3, y3, color})
        drawLine({x3, y3, x1, y1, color})
    
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
    
        hasUpdated = true
    end
       

    local function drawRect(params)
        local x, y = params[1], params[2]
        local rWidth, rHeight = params[3], params[4]
        local color = params[5]
        local isFilled = params[6]
    
        if isFilled then
            knownRects[coordinateToIndex(x, y, width)] = {rWidth, rHeight}
            scaledAdd(x, y, rWidth, rHeight, color)
            return
        end
    
        scaledAdd(x, y, rWidth, 1, color)
        scaledAdd(x + rWidth - 1, y + 1, 1, rHeight - 2, color)
        scaledAdd(x, y + 1, 1, rHeight - 2, color)
        scaledAdd(x, y + rHeight - 1, rWidth, 1,  color)
        
        hasUpdated = true
    end

    local function drawText(params)
        local params_x, params_y = params[1], params[2]
        local params_text = params[3]
        local params_color = params[4]
        local params_font = params[5]
        local params_maxWidth  = params[6]
        local params_wordWrappingEnabled = params[7]
    
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
            local char = getUTF8Character(params_text, i)
    
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
        
        hasUpdated = true
    end

    local function drawWithPoints(params)
        local flatPoints, color = params[1], params[2]
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
                        drawTriangle({px, py, cx, cy, nx, ny, color, true})

                        table.remove(indices, i)
                        earFound = true

                        break
                    end
                end
            end
    
            if not earFound then break end
        end
    end
    

    local data = self_cl.buffer.data
    local totalLen = #data
    local searchIndex = 0

    local lookup = {
        addToTable,
        drawLine,
        clearDisplay,
        drawCircle,
        drawTriangle,
        drawRect,
        drawText,
        drawWithPoints
    }

    while searchIndex < totalLen do
        searchIndex = searchIndex + 1

        local instruction = data[searchIndex]
        local currentParam = {}

        for i = 1, dataCountLookup[instruction] do
            searchIndex = searchIndex + 1
            currentParam[i] = data[searchIndex]
        end

        lookup[instruction](currentParam)
    end

    self_cl.buffer.data = {}

    local self_interactable = self.interactable
    local self_cl_pixel = self_cl.pixel
    local self_cl_display = self_cl.display
    local backpanelColor = self_cl_backPanel.currentColor
    local pixels = self_cl.pixels
    local stoppedIndex = self_cl.stoppedIndex
    local stoppedEffects = self_cl_pixel.stoppedEffects
    local threshold = self_cl_display.threshold
    local dataChange = {}
    local colorChange = {}
    local isHidden = self_cl_display.isHidden
    local widthScale = self_cl_display.widthScale
    local heightScale = self_cl_display.heightScale
    local selectionIndex = self_cl_pixel.selectionIndex
    local totalEffects = self_cl.totalEffects

    local self_data_panelOffset = self_data.panelOffset
    local pixel_scale = self_cl_pixel.pixelScale
    local pixel_scale_y = pixel_scale.y
    local pixel_scale_z = pixel_scale.z
    local pixelDepth = self_data_panelOffset and self_data_panelOffset + 0.001 or 0.116

    local function createEffect()
        totalEffects = totalEffects + 1
        local effect 
        
        if stoppedIndex > 0 then
            effect = stoppedEffects[stoppedIndex]
    
            stoppedEffects[stoppedIndex] = nil
            stoppedIndex = stoppedIndex - 1

            if not isHidden and not effect_isPlaying(effect) then
                effect_start(effect)
            end
        else
            effect = sm_effect_createEffect(effectPrefix..selectionIndex, self_interactable)
            effect_setParameter(effect, "uuid", PIXEL_UUID)

            selectionIndex = (selectionIndex + 1) % 256

            if not isHidden then
                effect_start(effect)
            end
        end
    
        return effect
    end

    local function setEffectParameters(effectData)
        local x, y, effect, sx, sy = effectData[4], effectData[5], effectData[1], effectData[2], effectData[3]
    
        local scaleY, scaleX = pixel_scale_y * sy, pixel_scale_z * sx
        local centerX = x - 1 + ((sx > 1) and (sx / 2 - 0.5) or 0)
        local centerY = y - 1 + ((sy > 1) and (sy / 2 - 0.5) or 0)
    
        effect_setScale(effect, sm_vec3_new(0, scaleY + (pixelBorderMultiplier * pixel_scale_y), scaleX + (pixelBorderMultiplier * pixel_scale_z)))
    
        local xPos, yPos = pixelPosToShapePos(centerX, centerY, widthScale, heightScale, pixel_scale_y, pixel_scale_z)
        effect_setOffsetPosition(effect, sm_vec3_new(pixelDepth, yPos, xPos))
    end

    local function stopEffect(effect)
        totalEffects = totalEffects - 1
        stoppedIndex = stoppedIndex + 1
        stoppedEffects[stoppedIndex] = effect

        effect_setOffsetPosition(effect, rePos)
    end

    local function meshNeighbours(index, sendColor)
        local success = false
    
        local function assignPixelsToFill(originReplace, originSx, originSy, originOx, originOy)
            local x1, y1 = originOx, originOy
            local mx = originOx + originSx - 1

            for _ = 1, originSx * originSy do
                pixels[(y1 - 1) * width + x1] = originReplace

                x1 = x1 + 1
                if x1 > mx then
                    x1 = originOx
                    y1 = y1 + 1
                end
            end
        end
    
        local originData = pixels[index]
        local originSx, originSy = originData and originData[2] or 1, originData and originData[3] or 1
        local originOx, originOy = indexToCoordinate(index, width)

        local nxData = pixels[coordinateToIndex(originOx - 1, originOy, width)]

        if nxData and nxData[3] == originSy and nxData[5] == originOy and areColorsSimilar(sendColor, nxData[6], threshold) then
            nxData[2] = nxData[2] + originSx
            success = true

            dataChange[nxData] = true

            if originData then
                stopEffect(originData[1])
                dataChange[originData] = nil
            end

            originData, originSx, originSy, originOx, originOy = nxData, nxData[2], nxData[3], nxData[4], nxData[5]
        end

        local nyData = pixels[coordinateToIndex(originOx, originOy - 1, width)]

        if nyData and nyData[2] == originSx and nyData[4] == originOx and areColorsSimilar(sendColor, nyData[6], threshold) then
            nyData[3] = nyData[3] + originSy
            success = true

            dataChange[nyData] = true

            if originData then
                stopEffect(originData[1])
                dataChange[originData] = nil
            end

            originData, originSx, originSy, originOx, originOy = nyData, nyData[2], nyData[3], nyData[4], nyData[5]
        end

        if success then
            assignPixelsToFill(originData, originSx, originSy, originOx, originOy)

            return true
        else
            return false
        end
    end
    

    local function splitX(index, ncheck, ncolor)
        local effectData = pixels[index]
        local _, y = indexToCoordinate(index, width)
        local ex, ey, sx, sy, color = effectData[4], effectData[5], effectData[2], effectData[3], effectData[6]
        local end_y = ey + sy - 1
        local createIndex
        local returnData
    
        if y == ey or y == end_y then
            if y == ey then
                effectData[5] = ey + 1
            end

            effectData[3] = sy - 1
            dataChange[effectData] = true

            if not ncheck or (ncheck and ncolor) then
                local edgeY = (y == ey) and ey or end_y
                createIndex = coordinateToIndex(ex, edgeY, width)
                
                local newData = {
                    createEffect(),
                    sx,
                    1,
                    ex, 
                    edgeY,
                    color
                }

                returnData = newData
        
                for i = 0, sx - 1 do
                    pixels[createIndex + i] = newData
                end
        
                dataChange[newData] = true
                colorChange[newData[1]] = color
            else
                pixels[index] = nil
            end
        else
            local remainingHeight = end_y - y

            local endData = {
                createEffect(),
                sx,
                remainingHeight,
                ex, 
                y + 1,
                color
            }
    
            for row = 0, remainingHeight - 1 do
                local rowIndex = coordinateToIndex(ex, y + 1 + row, width)
                for i = 0, sx - 1 do
                    pixels[rowIndex + i] = endData
                end
            end
    
            dataChange[endData] = true
            colorChange[endData[1]] = color
    
            effectData[3] = y - ey
            dataChange[effectData] = true

            if not ncheck or (ncheck and ncolor) then
                local centerData = {
                    createEffect(),
                    sx,
                    1,
                    ex,
                    y,
                    color
                }
                
                returnData = centerData
        
                local centerIndex = coordinateToIndex(ex, y, width)

                for i = 0, sx - 1 do
                    pixels[centerIndex + i] = centerData
                end
        
                dataChange[centerData] = true
                colorChange[centerData[1]] = color
            else
                pixels[index] = nil
            end
        end

        return returnData
    end
    
    local function splitXY(index, ncolor)
        local effectData = pixels[index]
        local x, _ = indexToCoordinate(index, width)
        local ex, sx, color = effectData[4], effectData[2], effectData[6]
        local edgeX = ex + sx - 1
        local returnData
    
        if x == ex then
            effectData[4] = ex + 1
            effectData[2] = sx - 1
        elseif x == edgeX then
            effectData[2] = sx - 1
        else
            local endXOffset = edgeX - x
            local endIndex = index + 1

            local endx, endy = indexToCoordinate(endIndex, width)
            local endData = {
                createEffect(),
                endXOffset,
                1,
                endx,
                endy,
                color
            }
    
            for i = 0, endXOffset - 1 do
                pixels[endIndex + i] = endData
            end
    
            dataChange[endData] = true
            colorChange[endData[1]] = color
    
            effectData[2] = x - ex
        end
        
        dataChange[effectData] = true

        if ncolor then
            local newx, newy = indexToCoordinate(index, width)
            local newData = {
                createEffect(),
                1,
                1,
                newx,
                newy,
                color
            }

            returnData = newData
            pixels[index] = newData
            dataChange[newData] = true
            colorChange[newData[1]] = color
        else
            pixels[index] = nil
        end

        return returnData
    end


    local function findMaxDimensions(startIndex, colNew, newBuffer, checkProcessed)
        local maxWidth, maxHeight = 1, 1
        checkProcessed[startIndex] = true
        
        local rowEnd = startIndex + (width - (startIndex - 1) % width) - 1
        local i = startIndex + 1

        while i <= rowEnd and newBuffer[i] == colNew do
            checkProcessed[i] = true
            maxWidth = maxWidth + 1
            i = i + 1
        end
    
        for i = startIndex + width, startIndex + (height - math_floor((startIndex - 1) / width)) * width, width do
            local tempIndex = 0
            local tempIndices = {}
            local rowIsUniform = true

            for j = i, i + maxWidth - 1 do
                local pixel = newBuffer[j]
    
                if not pixel or checkProcessed[j] or pixel ~= colNew then
                    rowIsUniform = false
                    break
                end

                tempIndex = tempIndex + 1
                tempIndices[tempIndex] = j
            end

            if not rowIsUniform then
                return maxWidth, maxHeight
            end

            for _, index in pairs(tempIndices) do
                checkProcessed[index] = true
            end
    
            maxHeight = maxHeight + 1
        end
    
        return maxWidth, maxHeight
    end


    if (not hasUpdated and hasCleared) or not next(updatedPoints) then
        local deleted = {}

        for _, effectData in pairs(pixels) do
            local effect = effectData[1]
            local id = effect.id

            if sm_exists(effect) and not deleted[id] then
                effect_destroy(effect)
                deleted[id] = true
            end
        end

        if stoppedIndex > 1 then
            local itterated = {}

            for _, effect in pairs(stoppedEffects) do
                if not itterated[effect.id] then
                    effect_destroy(effect)
                    itterated[effect.id] = true
                end
            end

            stoppedEffects = {}
            stoppedIndex = 0
        end

        dataChange = {}
        colorChange = {}
        pixels = {}
        updatedPoints = {}
    elseif hasUpdated then
        -- if totalEffects == width * height then
        --     local votes = {}
        --     local currMaxNumb = 0
        --     local currMaxCol

        --     for _, colNew in pairs(newBuffer) do
        --         local vote = votes[colNew] or 0

        --         vote = vote + 1

        --         if vote > currMaxNumb then
        --             currMaxNumb = vote
        --             currMaxCol = colNew
        --         end

        --         votes[colNew] = vote
        --     end

        --     if votes[currMaxCol] > 10 and currMaxCol ~= backpanelColor then
        --         effect_setParameter(self_cl_backPanel.effect, "color", idToColor(currMaxCol))

        --         self_cl_backPanel.currentColor = currMaxCol
        --         backpanelColor = currMaxCol

        --         local effectsToStop = {}

        --         for i, pixel in pairs(pixels) do
        --             if areColorsSimilar(pixel[6], currMaxCol, threshold) then
        --                 effectsToStop[pixel[1]] = true

        --                 dataChange[pixel] = nil
        --                 colorChange[pixel[1]] = nil
        --                 pixels[i] = nil
        --             end
        --         end

        --         for effect in pairs(effectsToStop) do
        --             stopEffect(effect)
        --         end
        --     end
        -- end

        -- self_cl.backPanelCheck = false

        local doOptimise = totalEffects > 2048 or newBufferLen > 2048
        local checkProcessed = {}

        self_cl.hasUpdated = true
        self_cl.doOptimise = doOptimise

        if hasCleared then
            for i in pairs(updatedPoints) do
                local colNew = newBuffer[i]
                local effectPos = pixels[i]
                local notEqual = colNew and colNew ~= backpanelColor
            
                if not effectPos then
                    if notEqual and not (doOptimise and meshNeighbours(i, colNew)) then
                        local datax, datay = indexToCoordinate(i, width)
                        local data = {
                            createEffect(),
                            1,
                            1,
                            datax,
                            datay,
                            colNew
                        }

                        pixels[i] = data
                        dataChange[data] = true
                        colorChange[data[1]] = colNew
                    end
                elseif effectPos[6] ~= colNew then
                    local sx, sy = effectPos[2], effectPos[3]
                    local foundRect = knownRects[i]
                    local sxa, sya = sx > 1, sy > 1

                    if foundRect and (foundRect[1] == sx and foundRect[2] == sy) then
                        sxa = false
                        sya = false
                    end

                    if sxa and sya then
                        splitX(i)
                        effectPos = splitXY(i, notEqual)
                    elseif sya then
                        effectPos = splitX(i, true, notEqual)
                    elseif sxa then
                        effectPos = splitXY(i, notEqual)
                    elseif not notEqual then
                        stopEffect(effectPos[1])
                        updatedPoints[i] = nil
                        dataChange[effectPos] = nil
                        pixels[i] = nil
                        effectPos = nil
                    end
        
                    if effectPos and (not (doOptimise and meshNeighbours(i, colNew))) then
                        effectPos[6] = colNew
                        colorChange[effectPos[1]] = colNew
                    end
                end
            end
        else
            for i, colNew in pairs(newBuffer) do
                local effectPos = pixels[i]
                local notEqual = colNew ~= backpanelColor
            
                if not effectPos then
                    if notEqual and not (doOptimise and meshNeighbours(i, colNew)) then
                        local datax, datay = indexToCoordinate(i, width)
                        local data = {
                            createEffect(),
                            1,
                            1,
                            datax,
                            datay,
                            colNew
                        }

                        pixels[i] = data
                        dataChange[data] = true
                        colorChange[data[1]] = colNew
                    end
                elseif effectPos[6] ~= colNew then
                    local sx, sy = effectPos[2], effectPos[3]
                    local foundRect = knownRects[i]
                    local sxa, sya = sx > 1, sy > 1

                    if foundRect and (foundRect[1] == sx and foundRect[2] == sy) then
                        sxa = false
                        sya = false
                    end
  
                    if sxa and sya then
                        splitX(i)
                        effectPos = splitXY(i, notEqual)
                    elseif sya then
                        effectPos = splitX(i, true, notEqual)
                    elseif sxa then
                        effectPos = splitXY(i, notEqual)
                    elseif not notEqual then
                        stopEffect(effectPos[1])
                        dataChange[effectPos] = nil
                        pixels[i] = nil
                        effectPos = nil
                    end

                    if effectPos and (not (doOptimise and meshNeighbours(i, colNew))) then
                        effectPos[6] = colNew
                        colorChange[effectPos[1]] = colNew
                    end
                end
            end
            
        end
        
        for effectData, _ in pairs(dataChange) do
            setEffectParameters(effectData)
        end

        for effect, color in pairs(colorChange) do
            effect_setParameter(effect, "color", idToColor(color))
        end
    end

    self_cl.pixels = pixels
    self_cl.stoppedIndex = stoppedIndex
    self_cl.updatedPoints = updatedPoints
    self_cl_pixel.stoppedEffects = stoppedEffects
    self_cl_pixel.selectionIndex = selectionIndex
    self_cl.totalEffects = totalEffects
    self_cl.newBuffer = {}
end

function DisplayClass:cl_optimiseDisplay()
    local self_cl = self.cl
    local self_cl_pixel = self_cl.pixel
    local self_cl_display = self_cl.display
    local self_interactable = self.interactable
    local self_data = self.data
    local width, height = self_data.width, self_data.height
    local threshold = self_cl_display.threshold
    local pixels = self_cl.pixels
    local stoppedIndex = self_cl.stoppedIndex
    local stoppedEffects = self_cl_pixel.stoppedEffects
    local selectionIndex = self_cl_pixel.selectionIndex
    local isHidden = self_cl_display.isHidden

    local self_data_panelOffset = self_data.panelOffset
    local pixel_scale = self_cl_pixel.pixelScale
    local pixel_scale_y = pixel_scale.y
    local pixel_scale_z = pixel_scale.z
    local pixelDepth = self_data_panelOffset and self_data_panelOffset + 0.001 or 0.116
    local widthScale = self_cl_display.widthScale
    local heightScale = self_cl_display.heightScale
   
    local function stopEffect(effect)
        stoppedIndex = stoppedIndex + 1
        stoppedEffects[stoppedIndex] = effect

        effect_setOffsetPosition(effect, rePos)
    end

    local function createEffect()
        local effect 
        
        if stoppedIndex > 0 then
            effect = stoppedEffects[stoppedIndex]
    
            stoppedEffects[stoppedIndex] = nil
            stoppedIndex = stoppedIndex - 1

            if not isHidden and not effect_isPlaying(effect) then
                effect_start(effect)
            end
        else
            effect = sm_effect_createEffect(effectPrefix..selectionIndex, self_interactable)
            effect_setParameter(effect, "uuid", PIXEL_UUID)

            selectionIndex = (selectionIndex + 1) % 256

            if not isHidden then
                effect_start(effect)
            end
        end
    
        return effect
    end

    local function setEffectParameters(effectData)
        local x, y, effect, sx, sy, color = effectData[4], effectData[5], effectData[1], effectData[2], effectData[3], effectData[6]
    
        local scaleY, scaleX = pixel_scale_y * sy, pixel_scale_z * sx
        local centerX = x - 1 + ((sx > 1) and (sx / 2 - 0.5) or 0)
        local centerY = y - 1 + ((sy > 1) and (sy / 2 - 0.5) or 0)
    
        effect_setScale(effect, sm_vec3_new(0, scaleY + (pixelBorderMultiplier * pixel_scale_y), scaleX + (pixelBorderMultiplier * pixel_scale_z)))

        local xPos, yPos = pixelPosToShapePos(centerX, centerY, widthScale, heightScale, pixel_scale_y, pixel_scale_z)
        effect_setOffsetPosition(effect, sm_vec3_new(pixelDepth, yPos, xPos))

        effect_setParameter(effect, "color", idToColor(color))
    end

    local processed = {}

    local function findMaxDimensions(startIndex, color)
        local maxWidth, maxHeight = 1, 1
        processed[startIndex] = true

    
        for i = startIndex + 1, startIndex + (width - (startIndex - 1) % width) - 1 do
            local pixel = pixels[i]
    
            if not pixel or processed[i] or not areColorsSimilar(pixel[6], color, threshold) then
                break
            end
    
            processed[i] = true
            maxWidth = maxWidth + 1
        end
   
        for i = startIndex + width, startIndex + (height - math_floor((startIndex - 1) / width)) * width, width do
            local tempIndex = 0
            local tempIndices = {}
            local rowIsUniform = true

            for j = i, i + maxWidth - 1 do
                local pixel = pixels[j]
    
                if not pixel or processed[j] or not areColorsSimilar(pixel[6], color, threshold) then
                    rowIsUniform = false
                    break
                end

                tempIndex = tempIndex + 1
                tempIndices[tempIndex] = j
            end

            if not rowIsUniform then
                return maxWidth, maxHeight
            end

            for _, index in pairs(tempIndices) do
                processed[index] = true
            end
    
            maxHeight = maxHeight + 1
        end
    
        return maxWidth, maxHeight
    end

    local itterated = {}
    local newPixels = {}
    local keyIndex = 0
    local sortedKeys = {}

    for index, effectData in pairs(pixels) do
        local effect = effectData[1]
        local effectId = effect.id

        if not itterated[effectId] then
            itterated[effectId] = true
            stopEffect(effect)
        end

        local x, y = indexToCoordinate(index, width)

        keyIndex = keyIndex + 1
        sortedKeys[keyIndex] = {index, effectData, x, y}
    end

    table_sort(sortedKeys, function(a, b)
        local ay = a[4]
        local by = b[4]

        if ay == by then
            return a[3] < b[3]
        else
            return ay < by
        end
    end)

    for _, keyData in pairs(sortedKeys) do
        local index, effectData = keyData[1], keyData[2]
        local effect = effectData[1]
        local effectId = effect.id

        if not itterated[effectId] then
            itterated[effectId] = true
            stopEffect(effect)
        end

        if not processed[index] then
            local sx, sy = findMaxDimensions(index, effectData[6])

            local x, y = indexToCoordinate(index, width)
            local newData = {
                createEffect(),
                sx,
                sy,
                x,
                y,
                effectData[6]
            }

            local x1, y1 = x, y
            local mx = x + sx - 1

            for _ = 1, sx * sy do
                newPixels[(y1 - 1) * width + x1] = newData

                x1 = x1 + 1

                if x1 > mx then
                    x1 = x
                    y1 = y1 + 1
                end
            end

            setEffectParameters(newData)
        end
    end

    if stoppedIndex > 500 then
        for i = 501, stoppedIndex do
            effect_destroy(stoppedEffects[i])
            stoppedEffects[i] = nil
        end

        stoppedIndex = 500
    end

    self_cl.pixels = newPixels
    self_cl.stoppedIndex = stoppedIndex
    self_cl_pixel.stoppedEffects = stoppedEffects
    self_cl_pixel.selectionIndex = selectionIndex
end

function DisplayClass:cl_setVisibility(setHidden)
    local self_cl = self.cl

    if setHidden ~= self_cl.display.isHidden then
        self_cl.display.isHidden = setHidden

        local itterated = {}
        for _, effectData in pairs(self_cl.pixels) do
            local effect = effectData[1]
            local id = effect.id

            if sm_exists(effect) and not itterated[id] then
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

            itterated[id] = true
        end

        if setHidden then
            for _, effect in pairs(self_cl.pixel.stoppedEffects) do
                if effect_isPlaying(effect) then
                    effect_stop(effect)
                end
            end
        end
    end
end

sm.scrapcomputers.componentManager.toComponent(DisplayClass, "Displays", true)