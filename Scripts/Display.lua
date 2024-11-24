-- Ben has sacraficed his fucking soul making display's. VeraDev died commenting the entire display, its even beter because now its all gone.
-- If you ever make your own display's. You will actually kill yourself. We are NOT joking.

-- TODO

-- auto optimise

local sm_scrapcomputers_ascfManager_applyDisplayFunctions = sm.scrapcomputers.ascfManager.applyDisplayFunctions
local sm_scrapcomputers_errorHandler_assertArgument = sm.scrapcomputers.errorHandler.assertArgument
local sm_scrapcomputers_errorHandler_assert = sm.scrapcomputers.errorHandler.assert
local sm_scrapcomputers_languageManager_translatable = sm.scrapcomputers.languageManager.translatable

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
local sm_render_getScreenCoordinatesFromWorldPosition = sm.render.getScreenCoordinatesFromWorldPosition
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
local colorCache = sm.scrapcomputers.backend.cameraColorCache
local tinkerBind = sm.gui.getKeyBinding("Tinker", true)
local interactBind = sm.gui.getKeyBinding("Use", true)

local PIXEL_UUID = sm.uuid.new("cd943f04-96c7-43f0-852c-b2d68c7fc157")
local BACKPANEL_EFFECT_NAME = "ScrapComputers - ShapeRenderableBackPanel"
local effectPrefix = "ScrapComputers - ShapeRenderable"
local rePos = sm_vec3_new(0, 0, -10000)

local tableLimit = 15000
local displayHidingCooldown = 0.5
local optimiseCooldown = 1.5

local imagePath = "$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/DisplayImages/"

local networkInstructions = {
    ["DIS_VIS"] = "cl_setDisplayHidden",
    ["SET_REND"] = "cl_setRenderDistance",
    ["SET_THRESHOLD"] = "cl_setThreshold",
    ["TOUCH_STATE"] = "cl_setTouchAllowed",
    ["OPTIMIZE"] = "cl_optimizeDisplayEffects"
}

local dataCountLookup = {
    2,
    3,
    1,
    4,
    5,
    4,
    6
}

function pixelPosToShapePos(x, y, widthScale, heightScale, pixelScale)
    local xPos = -(widthScale / 2) + (pixelScale.z / 200) + (x * pixelScale.z / 100) + 0.02
    local yPos = -(heightScale / 2) + (pixelScale.y / 200) + (y * pixelScale.y / 100) + 0.02

    return xPos, yPos
end

function shapePosToPixelPos(point, widthScale, heightScale, pixelScale)
    local x = (100 / pixelScale.z) * (point.z - 0.02 + (widthScale / 2) - (pixelScale.z / 200)) + 1
    local y = (100 / pixelScale.y) * (point.y - 0.02 + (heightScale / 2) - (pixelScale.y / 200)) + 1

    return x, y
end

function round(numb)
    return math_floor(numb + 0.5)
end

function areColorsSimilar(color, color1, threshold)
    if not color or not color1 then return false end

    local dr = color1.r - color.r
    local dg = color1.g - color.g
    local db = color1.b - color.b

    return math_sqrt(dr^2 + dg^2 + db^2) <= threshold
end

-- Gets the UTF8 char from a string as string_sub messes up special characters
---@param str string The string
---@param index number The UTF8 character to select
---@return string UTF8Character The UTF8 character returned.
function getUTF8Character(str, index)
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

function getUTF8StringSize(str)
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

-- Converts 2D coordinates (x, y) to a 1D array index
function coordinateToIndex(x, y, width)
    return (y - 1) * width + x
end

-- Converts a 1D array index to 2D coordinates (x, y)
function indexToCoordinate(index, width)
    local x = (index - 1) % width + 1
    local y = math_floor((index - 1) / width) + 1
    return x, y
end

function getFirst(tbl)
    for i, v in pairs(tbl) do
        return v, i
    end
end

function splitTable(numbers, length)
    if #numbers <= length then
        return {numbers}
    end

    local result = {}
    local currentTable = {}
    local count = 0
    local resultIndex = 0

    for _, num in ipairs(numbers) do
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

function colorToID(color)
    if color then
        color = type(color) == "string" and sm_color_new(color) or color
    else
        color = sm_color_new(0, 0, 0)
    end

    local r = math_floor(color.r * 255)
    local g = math_floor(color.g * 255)
    local b = math_floor(color.b * 255)
    
    local colorID = bit_bor(bit_lshift(r, 16), bit_lshift(g, 8), b)
    return colorID
end

function idToColor(colorID)
    local r = bit_band(bit_rshift(colorID, 16), 0xFF)
    local g =  bit_band(bit_rshift(colorID, 8), 0xFF)
    local b = bit_band(colorID, 0xFF)
    
    return sm_color_new(r / 255, g / 255, b / 255)
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
        sm_scrapcomputers_errorHandler_assertArgument(color, 4, {"Color", "string"})

        sm_scrapcomputers_errorHandler_assert(radius, 3, "Radius is too small!")

        dataIndex = dataIndex + 1
        dataBuffer[dataIndex] = 4
        dataIndex = dataIndex + 1
        dataBuffer[dataIndex] = coordinateToIndex(round(x), round(y), data_width)
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
        dataBuffer[dataIndex] = coordinateToIndex(round(x1), round(y1), data_width)
        dataIndex = dataIndex + 1
        dataBuffer[dataIndex] = coordinateToIndex(round(x2), round(y2), data_width)
        dataIndex = dataIndex + 1
        dataBuffer[dataIndex] = coordinateToIndex(round(x3), round(y3), data_width)
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
        dataBuffer[dataIndex] = coordinateToIndex(round(x), round(y), data_width)
        dataIndex = dataIndex + 1
        dataBuffer[dataIndex] = coordinateToIndex(round(width), round(height), data_width)
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
            dataBuffer[dataIndex] = coordinateToIndex(round(x), round(y), data_width)
            dataIndex = dataIndex + 1
            dataBuffer[dataIndex] = colorToID(color)

            clearCache = true
        end,

        ---Draws pixels from a table
        ---@param tbl PixelTable The table of pixels
        drawFromTable = function (tbl)
            sm_scrapcomputers_errorHandler_assertArgument(tbl, nil, {"table"}, {"PixelTable"})

            for i, pixel in pairs(tbl) do
                local pixel_x = pixel.x
                local pixel_y = pixel.y
                local pixel_color = pixel.color

                local xType = type(pixel_x)
                local yType = type(pixel_y)

                sm_scrapcomputers_errorHandler_assert(pixel_x and pixel_y and pixel_color, "missing data at index "..i..".")

                sm_scrapcomputers_errorHandler_assert(xType == "number", nil, "bad x value at index "..i..". Expected number. Got "..xType.." instead!")
                sm_scrapcomputers_errorHandler_assert(yType == "number", nil, "bad y value at index "..i..". Expected number. Got "..yType.." instead!")
            
                dataIndex = dataIndex + 1
                dataBuffer[dataIndex] = 1
                dataIndex = dataIndex + 1
                dataBuffer[dataIndex] = coordinateToIndex(round(pixel_x), round(pixel_y), data_width)
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

            dataBuffer[dataIndex] = clearColor

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
            dataBuffer[dataIndex] = coordinateToIndex(round(x), round(y), data_width)
            dataIndex = dataIndex + 1
            dataBuffer[dataIndex] = coordinateToIndex(round(x1), round(y1), data_width)
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
        ---@param wordWrappingEnabled boolean? If it should do word wrapping or not.
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
                dataBuffer[dataIndex] = coordinateToIndex(round(x), round(y), data_width)
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

        loadImage = function(width, height, path)
            sm_scrapcomputers_errorHandler_assertArgument(width, 1, {"integer"})
            sm_scrapcomputers_errorHandler_assertArgument(height, 2, {"integer"})

            sm_scrapcomputers_errorHandler_assertArgument(path, 3, {"string"})

            local fileLocation = imagePath..path
            sm_scrapcomputers_errorHandler_assert(sm.json.fileExists(fileLocation), 3, "Image doesnt exist")

            local imageTbl = sm.json.open(fileLocation)
            local x, y = 1, 1
            
            for _, color in pairs(imageTbl) do
                dataIndex = dataIndex + 1
                dataBuffer[dataIndex] = 1
                dataIndex = dataIndex + 1
                dataBuffer[dataIndex] = coordinateToIndex(x, y, data_width)
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

        -- Returns the dimensions of the display
        ---@return number width The width of the display
        ---@return number height height height of the display
        getDimensions = function ()
            return data_width, data_height
        end,

        -- Hides the display, Makes all players unable to see it.
        hide = function ()
            self.sv.buffer.network[#self.sv.buffer.network + 1] = {"DIS_VIS", {true}}
        end,

        -- Shows the display. All players will be able to see it
        show = function ()
            self.sv.buffer.network[#self.sv.buffer.network + 1] = {"DIS_VIS", {false}}
        end,

        -- Set the render distance for the display. If you go out of this range, the display will hide itself automaticly, else it will show itself.
        ---@param distance number The new render distance to set
        setRenderDistance = function (distance)
            sm_scrapcomputers_errorHandler_assertArgument(distance, nil, {"number"})

            self.sv.buffer.network[#self.sv.buffer.network + 1] = {"SET_REND", {distance}}
        end,

        -- Enables/Disables touchscreen. Makes getTouchData usable
        ---@param bool boolean If true, Touchscreen mode is enabled and the end-user can interact with it.
        enableTouchScreen = function(bool)
            sm_scrapcomputers_errorHandler_assertArgument(bool, nil, {"boolean"})

            self.sv.buffer.network[#self.sv.buffer.network + 1] = {"TOUCH_STATE", {bool}}
            self.sv.display.touchAllowed = bool
        end,

        -- Gets the latest touch data.
        getTouchData = function()
            return self.sv.display.touchData
        end,

        -- Gets a table touch data to accomodate multiple players pressing the screen.
        getTouchTable = function()
            return self.sv.display.touchTbl
        end,

        -- Renders the pixels to the display.
        update = function ()
            local self_sv = self.sv
            local lastBuffer = self_sv.lastBuffer
            local lastLength = self_sv.lastBufferLen
            local update = not lastLength or not lastBuffer

            if clearCache and colorCache then
                colorCache[shapeId] = nil
                clearCache = false
            end

            if not update then
                if lastLength ~= dataIndex then
                    update = true
                end
            end

            if not update then
                local maxLen = math_max(lastLength, dataIndex)

                for i = 1, maxLen do
                    local currData, lastData = dataBuffer[i], lastBuffer[i]

                    if currData ~= lastData then
                        update = true
                        break
                    end
                end
            end

            if update then
                local currBuffer = self_sv.buffer.data

                if currBuffer[1] then
                    local selIndex = #currBuffer

                    for _, data in pairs(dataBuffer) do
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

        -- Always update's the display. We highly do not suggest doing this as its VERY laggy.
        ---@param bool boolean Toggle the autoUpdate system.
        autoUpdate = function (bool)
            sm_scrapcomputers_errorHandler_assertArgument(bool, nil, {"boolean"})

            self.sv.autoUpdate = bool
        end,

        -- Optimizes the display to the extreme. Will be costy during the optimization but will be a massive performance increase after it.
        optimize = function ()
            --self.sv.buffer.network[#self.sv.buffer.network + 1] = {"OPTIMIZE", {}}
        end,

        -- Sets the optimization threshold. The lower, the less optimization it does but with better quality, the higher, the better optimization it does but with worser quality.
        -- You must set this value in decimals, Default optimization threshold when placing it is 0.05
        ---@param int number The new threshold
        setOptimizationThreshold = function (int)
            sm_scrapcomputers_errorHandler_assertArgument(int, nil, {"number"})

            self.sv.buffer.network[#self.sv.buffer.network + 1] = {"SET_THRESHOLD", {int}}
            self.sv.display.threshold = int
        end,

        ---Sets the max buffer size
        ---@param buffer integer The max buffer size
        setMaxBuffer = function (buffer)
            -- Func deprecated
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

        -- Calculates the text size.
        ---@param text string The text to be calculated
        ---@param font string The font to use.
        ---@param maxWidth integer? The max width before it wraps around
        ---@param wordWrappingEnabled boolean? If it should do word wrapping or not.
        ---@param dynamicHeight boolean? If the height should be dynamic towards the actual text instead of the font's height. Only works if word wrapping is disabled.
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
        end
    }

    sm_scrapcomputers_ascfManager_applyDisplayFunctions(display)

    return display
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
            local instruction, params = unpack(data)
            local dest = networkInstructions[instruction]

            sendToClients(self_network, dest, params)

            if instruction == "DIS_VIS" then
                sendToClients(self_network, "cl_setUserHidden", params[1])
            end
        end

        if colorCache then
            colorCache[self.shape.id] = nil
        end

        self_sv_buffer.network = {}
    end

    if self_sv.allowUpdate or self_sv.autoUpdate then
        local dataBuffer = self.sv.buffer.data

        if #sm_player_getAllPlayers() > 1 then
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

        sendToClients(self_network, "cl_setTouchAllowed", {self_sv_display.touchAllowed})
        sendToClients(self_network, "cl_setRenderDistance", {self_sv_display.renderDistance})
        sendToClients(self_network, "cl_setThreshold", {self_sv_display.threshold})

        self_sv_buffer.syncBuffer = {}
    end
end

function DisplayClass:server_onCreate()
    self.sv = {
        display = {
            threshold = 0,
            touchTbl = {}
        },

        pixel = {
            pixelData = {},
            backPanel = sm_color_new("000000")
        },

        buffer = {
            data = {},
            network = {},
            syncBuffer = {}
        },
    }
end

function DisplayClass:server_onDestroy()
    if colorCache then
        colorCache[self.shape.id] = nil
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

function DisplayClass:sv_setTertiaryData(data)
    self.sv.backPanel = data.backPanel
    self.sv.display.touchAllowed = data.touchAllowed
    self.sv.display.renderDistance = data.renderDistance
    self.sv.display.threshold = data.threshold
end

function DisplayClass:sv_setTouchData(data)
    self.sv.display.touchData = data[1]
    self.sv.display.touchTbl[data[2]] = data[1]
end

-- CLIENT --

-- Sets display render distance client side
---@param params table The parameters
function DisplayClass:cl_setRenderDistance(params)
    self.cl.display.renderDistance = params[1]
end

-- Sets display optimisation threshold client side
---@param params table The parameters
function DisplayClass:cl_setThreshold(params)
    self.cl.display.threshold = params[1]
end

-- Sets the touch bool client side
---@param params table The parameters
function DisplayClass:cl_setTouchAllowed(params)
    self.cl.display.touchAllowed = params[1]
end

-- Sets the user hidden bool client side
---@param bool boolean If enabled or not
function DisplayClass:cl_setUserHidden(bool)
    self.cl.display.userHidden = bool
end

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
            defaultColor = sm_color_new("000000"),
            currentColor = sm_color_new("000000")
        },

        display = {
            renderDistance = 10,
            visTimer = 0,
            threshold = 0
        },

        pixels = {},
        startBuffer = {},
        stopBuffer = {},
        newBuffer = {},
        oldBuffer = {},
        updatedPoints = {},
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
    local bgScale = sm_vec3_new(0, (self.cl.display.heightScale - offset) * 100, (self.cl.display.widthScale - offset) * 100)

    self.cl.pixel.pixelScale = sm_vec3_new(0, bgScale.y / height, bgScale.z / width)

    effect_setParameter(self.cl.backPanel.effect, "uuid", PIXEL_UUID)
    effect_setParameter(self.cl.backPanel.effect,"color", self.cl.backPanel.defaultColor)

    effect_setOffsetPosition(self.cl.backPanel.effect, sm_vec3_new(self.data.panelOffset or 0.115, 0, 0))
    effect_setScale(self.cl.backPanel.effect, bgScale)

    effect_start(self.cl.backPanel.effect)
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

    local lockingInt = character:getLockingInteractable()
    local ignoreFlags = lockingInt and lockingInt:hasSeat()
    local lastLangUpdt = sm.scrapcomputers.languageManager.lastLanguageUpdate
    local currTick = sm_game_getCurrentTick()

    self_cl.characterSeated = ignoreFlags

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
            if not ignoreFlags and shouldHide and not self_cl.prevHidden then
                self:cl_setDisplayHidden({shouldHide})
                self_cl.prevHidden = true
            elseif (not shouldHide or ignoreFlags) and self_cl.prevHidden then
                self:cl_setDisplayHidden({shouldHide})
                self_cl.prevHidden = false
            end
        end
    end

    if sm.isHost then
        local players = sm.player.getAllPlayers()
        local len = #players

        if len ~= self_cl.lastLen then
            if (not self_cl.lastLen or len > self_cl.lastLen) and #players > 1 then
                local dataTbl = {3, colorToID(self_cl_backPanel.currentColor)}
                local dataIndex = 2

                for index, data in pairs(self_cl.pixels) do
                    dataIndex = dataIndex + 1
                    dataTbl[dataIndex] = 1
                    dataIndex = dataIndex + 1
                    dataTbl[dataIndex] = index
                    dataIndex = dataIndex + 1
                    dataTbl[dataIndex] = colorToID(data[6])
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
        end
    end

    local hit, res = sm_physics_raycast(pos, pos + dir * 7.5, nil, sm.physics.filter.dynamicBody + sm.physics.filter.staticBody)

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


    if self_cl.raycastValid and self_cl.display.touchAllowed then
        if self_cl.lastLangUpdate ~= lastLangUpdt or self_cl.seatState ~= self_cl.characterSeated then
            self_cl.lastLangUpdate = lastLangUpdt
            self_cl.seatState = self_cl.characterSeated

            self_cl.interactionText = sm_scrapcomputers_languageManager_translatable("scrapcomputers.display.touchscreen", self_cl.characterSeated and tinkerBind or interactBind)
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
            local x, y = shapePosToPixelPos(self_cl.transformedPoint, self_cl_display.widthScale, self_cl_display.heightScale, self_cl.pixel.pixelScale)

            self_cl.lastX = round(sm_util_clamp(x, 1, self_data.width))
            self_cl.lastY = round(sm_util_clamp(y, 1, self_data.height))
        end

        self.network:sendToServer("sv_setTouchData", {{state = self_cl.interactState, x = self_cl.lastX, y = self_cl.lastY}, playerName})

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

    if (not self_cl.lastOptimise or self_cl.lastOptimise + optimiseCooldown <= clock) and self_cl.doOptimise and self_cl.hasUpdated then
        self_cl.lastOptimise = clock
        self_cl.hasUpdated = false

        self:cl_optimiseDisplay()
    end
end

function DisplayClass:client_onUpdate()
    local self_cl = self.cl

    if self_cl.raycastValid and self_cl.display.touchAllowed and self_cl.interactionText then
        sm.gui.setInteractionText("", self_cl.interactionText, "")
        sm.gui.setInteractionText("")
    elseif self_cl.isRaycasted then
        sm.gui.setInteractionText("")
        sm.gui.setInteractionText("")
    end
end

function DisplayClass:client_onInteract(character, state)
    local self_cl = self.cl

    if state and not self_cl.characterSeated and self_cl.raycastValid then
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

    if state and self_cl.characterSeated and self_cl.raycastValid then
        self_cl.interacting = true
    elseif (not state or not self_cl.raycastValid) and self_cl.wasInteracting then
        self_cl.interacting = false
    end
end

function DisplayClass:client_canTinker()
    return true
end

function DisplayClass:cl_pushData()
    local newBuffer = {}
    local hasCleared = false
    local self_cl = self.cl
    local self_cl_backPanel = self_cl.backPanel
    local self_data = self.data
    local width = self_data.width
    local height = self_data.height
    local updatedPoints = self_cl.updatedPoints

    local function boundsAssert(x, y)
        return x > 0 and x <= width and y > 0 and y <= height
    end

    local function addToTable(params)
        local index = params[1]
        newBuffer[index] = idToColor(params[2])

        updatedPoints[index] = true
    end

    local function scaledAdd(params)
        local x, y = params[1], params[2]
        local sx, sy = params[3], params[4]
        local color = params[5]
    
        local x1, y1 = x, y
        local mx = sx + x - 1
    
        for _ = 1, sx * sy do
            if boundsAssert(x1, y1) then
                local index = coordinateToIndex(x1, y1, width)

                updatedPoints[index] = true
                newBuffer[index] = color
            end

            x1 = x1 + 1
        
            if x1 > mx then
                x1 = x
                y1 = y1 + 1
            end
        end
    end

    local function drawLine(params)
        local x0, y0 = indexToCoordinate(params[1], width)
        local x1, y1 = indexToCoordinate(params[2], width)
        local color = params[3]
        color =  type(color) == "Color" and color or idToColor(color)
    
        local dx = math_abs(x1 - x0)
        local dy = math_abs(y1 - y0)
        local sx = (x0 < x1) and 1 or -1
        local sy = (y0 < y1) and 1 or -1
        local err = dx - dy
    
        while true do
            if boundsAssert(x0, y0) then
                local index = coordinateToIndex(x0, y0, width)

                updatedPoints[index] = true
                newBuffer[index] = color
            end
    
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

    local function clearDisplay(params)
        hasCleared = true
        newBuffer = {}
    
        local color = params[1] and idToColor(params[1])
    
        if color and color ~= self_cl_backPanel.currentColor then
            effect_setParameter(self_cl_backPanel.effect, "color", color)
            self_cl_backPanel.currentColor = color
        end
    end

    local function drawCircle(params)
        local x, y = indexToCoordinate(params[1], width)
        local radius = params[2]
        local color = idToColor(params[3])
        local isFilled = params[4]
    
        local f = 1 - radius
        local ddF_x = 1
        local ddF_y = -2 * radius
        local cx = 0
        local cy = radius
    
        local function plot(xp, yp)
            if boundsAssert(xp, yp) then
                local index = coordinateToIndex(xp, yp, width)

                newBuffer[index] = color
                updatedPoints[index] = true
            end
        end
    
        if isFilled then
            scaledAdd({x - radius, y, radius * 2 + 1, 1, color})
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
                scaledAdd({x - cx, y + cy, cx * 2 + 1, 1, color})
                scaledAdd({x - cy, y + cx, cy * 2 + 1, 1, color})
    
                scaledAdd({x - cx, y - cy, cx * 2 + 1, 1, color})
                scaledAdd({x - cy, y - cx, cy * 2 + 1, 1, color})
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
    end

    local function drawTriangle(params)
        local x1, y1 = indexToCoordinate(params[1], width)
        local x2, y2 = indexToCoordinate(params[2], width)
        local x3, y3 = indexToCoordinate(params[3], width)
        local color = idToColor(params[4])
        local isFilled = params[5]
    
        local idx1 = coordinateToIndex(x1, y1, width)
        local idx2 = coordinateToIndex(x2, y2, width)
        local idx3 = coordinateToIndex(x3, y3, width)
        drawLine({idx1, idx2, color})
        drawLine({idx2, idx3, color})
        drawLine({idx3, idx1, color})
    
        if isFilled then
            local points = {{x = x1, y = y1}, {x = x2, y = y2}, {x = x3, y = y3}}
            table_sort(points, function(a, b) return a.y < b.y end)
    
            local x0, y0 = points[1].x, points[1].y
            local x1, y1 = points[2].x, points[2].y
            local x2, y2 = points[3].x, points[3].y
    
            local invSlope1 = (y1 ~= y0) and ((x1 - x0) / (y1 - y0)) or 0
            local invSlope2 = (y2 ~= y0) and ((x2 - x0) / (y2 - y0)) or 0
            local invSlope3 = (y2 ~= y1) and ((x2 - x1) / (y2 - y1)) or 0
    
            local function fillSpan(y, xStart, xEnd)
                local startX = math_floor(xStart + 0.5)
                local endX = math_floor(xEnd + 0.5)
                if startX > endX then startX, endX = endX, startX end
    
                for x = startX, endX do
                    if boundsAssert(x, y) then
                        local index = coordinateToIndex(x, y, width)

                        newBuffer[index] = color
                        updatedPoints[index] = true
                    end
                end
            end
    
            for y = y0, y1 - 1 do
                local xa = x0 + invSlope1 * (y - y0)
                local xb = x0 + invSlope2 * (y - y0)
                fillSpan(y, xa, xb)
            end
    
            for y = y1, y2 do
                local xa = x1 + invSlope3 * (y - y1)
                local xb = x0 + invSlope2 * (y - y0)
                fillSpan(y, xa, xb)
            end
        end
    end    

    local function drawRect(params)
        local x, y = indexToCoordinate(params[1], width)
        local rWidth, rHeight = indexToCoordinate(params[2], width)
        local color = idToColor(params[3])
        local isFilled = params[4]
    
        if isFilled then
            scaledAdd({x, y, rWidth, rHeight, color})
            return
        end
    
        scaledAdd({x, y, rWidth, 1, color})
        scaledAdd({x + rWidth - 1, y + 1, 1, rHeight - 2, color})
        scaledAdd({x, y + 1, 1, rHeight - 2, color})
        scaledAdd({x, y + rHeight - 1, rWidth, 1,  color})
    end

    local function drawText(params)
        local params_x, params_y = indexToCoordinate(params[1], width)
        local params_text = params[2]
        local params_color = idToColor(params[3])
        local params_font = params[4]
        local params_maxWidth  = params[5]
        local params_wordWrappingEnabled = params[6]
    
        local font, err = sm.scrapcomputers.fontManager.getFont(params_font)
    
        if not font then
            sm.log.error("Fatal error! Failed to get the font! Error message: "..err)
            sm.gui.chatMessage("[#3A96DDS#3b78ffC#eeeeee]: " .. sm.scrapcomputers.languageManager.translatable("scrapcomputers.display.failed_to_find_font"))
    
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
                ySpacing = ySpacing + font.fontHeight
            else
                local fontLetter = font.charset[char] or font.errorChar
    
                if (params_x + xSpacing) + font.fontWidth > width then
                    xSpacing = 0
                    ySpacing = ySpacing + font.fontHeight
                end
    
                for yPosition, row in pairs(fontLetter) do
                    for xPosition = 1, #row, 1 do
                        if string_sub(row, xPosition, xPosition) == "#" then
                            local x, y = params_x + xSpacing + (xPosition - 1), params_y + ySpacing + (yPosition - 1)
    
                            if boundsAssert(x, y) then
                                local index = coordinateToIndex(x, y, width)

                                newBuffer[index] = params_color
                                updatedPoints[index] = true
                            end
                        end
                    end
    
                end
    
                xSpacing = xSpacing + font.fontWidth
            end
    
            i = i + #char
        end
    end

    local data = self_cl.buffer.data
    local totalLen = #data
    local searchIndex = 0
    local hasUpdated = false

    while searchIndex < totalLen do
        searchIndex = searchIndex + 1

        local instruction = data[searchIndex]
        local dataCount = dataCountLookup[instruction]
        local currentParam = {}

        if dataCount > 0 then
            for i = 1, dataCount do
                searchIndex = searchIndex + 1
                currentParam[i] = data[searchIndex]
            end
        end

        if instruction == 1 then
            addToTable(currentParam)
            hasUpdated = true
        elseif instruction == 2 then
            drawLine(currentParam)
            hasUpdated = true
        elseif instruction == 3 then
            clearDisplay(currentParam)
        elseif instruction == 4 then
            drawCircle(currentParam)
            hasUpdated = true
        elseif instruction == 5 then
            drawTriangle(currentParam)
            hasUpdated = true
        elseif instruction == 6 then
            drawRect(currentParam)
            hasUpdated = true
        else
            drawText(currentParam)
            hasUpdated = true
        end
    end

    self_cl.buffer.data = {}

    local self_interactable = self.interactable
    local self_cl_display = self_cl.display
    local self_cl_pixel = self_cl.pixel
    local oldBuffer = self_cl.oldBuffer
    local pixels = self_cl.pixels
    local stoppedIndex = self_cl.stoppedIndex
    local stoppedEffects = self_cl_pixel.stoppedEffects
    local threshold = self_cl_display.threshold
    local backpanelColor = self_cl.backPanel.currentColor
    local dataChange = {}
    local colorChange = {}
    local isHidden = self_cl_display.isHidden
    local widthScale = self_cl_display.widthScale
    local heightScale = self_cl_display.heightScale
    local selectionIndex = self_cl_pixel.selectionIndex
    local clock = os.clock()

    local self_data_panelOffset = self_data.panelOffset
    local pixel_scale = self_cl_pixel.pixelScale
    local pixel_scale_y = pixel_scale.y
    local pixel_scale_z = pixel_scale.z
    local pixelDepth = self_data_panelOffset and self_data_panelOffset + 0.001 or 0.116

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

    local function createBasicData(index, color)
        local x, y = indexToCoordinate(index, width)
        local effect = createEffect()
    
        return {
            effect,
            1,
            1,
            x, 
            y,
            color
        }
    end

    local function setEffectParameters(effectData)
        local x, y = effectData[4], effectData[5]
        local effect = effectData[1]
        local sx, sy = effectData[2], effectData[3]
    
        local centerX, centerY
    
        if sx == 1 and sy == 1 then
            effect_setScale(effect, sm_vec3_new(0, pixel_scale_y, pixel_scale_z))
    
            centerX = x - 1
            centerY = y - 1
        else
            effect_setScale(effect, sm_vec3_new(0, pixel_scale_y * sy, pixel_scale_z * sx))
    
            centerX = ((sx / 2) + x - 1) - 0.5
            centerY = ((sy / 2) + y - 1) - 0.5
        end
    
        local xPos, yPos = pixelPosToShapePos(centerX, centerY, widthScale, heightScale, pixel_scale)
        effect_setOffsetPosition(effect, sm_vec3_new(pixelDepth, yPos, xPos))
    end

    local function stopEffect(effect)
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
                pixels[coordinateToIndex(x1, y1, width)] = originReplace
                x1 = x1 + 1
                if x1 > mx then
                    x1 = originOx
                    y1 = y1 + 1
                end
            end
        end
    
        local originData = pixels[index]
        local originSx, originSy, originOx, originOy = 1, 1, indexToCoordinate(index, width)
        
        if originData then
            originSx, originSy = originData[2], originData[3]
            originOx, originOy = originData[4], originData[5]
            index = coordinateToIndex(originOx, originOy, width)
        end
    
        local nxData = pixels[coordinateToIndex(originOx - 1, originOy, width)]
        local pxData = pixels[coordinateToIndex(originOx + originSx, originOy, width)]
        local nAvail = nxData and nxData[3] == originSy and nxData[5] == originOy and areColorsSimilar(sendColor, nxData[6], threshold)
        local pAvail = pxData and pxData[3] == originSy and pxData[5] == originOy and areColorsSimilar(sendColor, pxData[6], threshold)
    
        local originReplace = nil
        if nAvail and pAvail then
            local sx = pxData[2]
            local ox = pxData[4]
            local x1, y1 = ox, pxData[5]
            local mx = ox + sx - 1
            for _ = 1, sx * pxData[3] do
                pixels[coordinateToIndex(x1, y1, width)] = nxData
                x1 = x1 + 1
                if x1 > mx then
                    x1 = ox
                    y1 = y1 + 1
                end
            end
            nxData[2] = nxData[2] + pxData[2] + originSx
            originReplace, success = nxData, true
            dataChange[nxData] = true
            dataChange[pxData] = nil
            stopEffect(pxData[1])
        elseif nAvail then
            nxData[2] = nxData[2] + originSx
            originReplace, success = nxData, true
            dataChange[nxData] = true
        elseif pAvail then
            pxData[2] = pxData[2] + originSx
            pxData[4] = pxData[4] - originSx
            originReplace, success = pxData, true
            dataChange[pxData] = true
        end
    
        if originReplace then
            if originData then
                stopEffect(originData[1])
                dataChange[originData] = nil
            end
            assignPixelsToFill(originReplace, originSx, originSy, originOx, originOy)
            originSx, originSy = originReplace[2], originReplace[3]
            originOx, originOy = originReplace[4], originReplace[5]
        end

        local nyData = pixels[coordinateToIndex(originOx, originOy - 1, width)]
        local pyData = pixels[coordinateToIndex(originOx, originOy + originSy, width)]
        local nAvailY = nyData and nyData[2] == originSx and nyData[4] == originOx and areColorsSimilar(sendColor, nyData[6], threshold)
        local pAvailY = pyData and pyData[2] == originSx and pyData[4] == originOx and areColorsSimilar(sendColor, pyData[6], threshold)
    
        local originReplace1 = nil
        if nAvailY and pAvailY then
            local sx = pyData[2]
            local ox = pyData[4]
            local x1, y1 = ox, pyData[5]
            local mx = ox + sx - 1
            for _ = 1, sx * pyData[3] do
                pixels[coordinateToIndex(x1, y1, width)] = nyData
                x1 = x1 + 1
                if x1 > mx then
                    x1 = ox
                    y1 = y1 + 1
                end
            end
            nyData[3] = nyData[3] + pyData[3] + originSy
            originReplace1, success = nyData, true
            dataChange[nyData] = true
            dataChange[pyData] = nil
            stopEffect(pyData[1])
        elseif nAvailY then
            nyData[3] = nyData[3] + originSy
            originReplace1, success = nyData, true
            dataChange[nyData] = true
        elseif pAvailY then
            pyData[3] = pyData[3] + originSy
            pyData[5] = pyData[5] - originSy
            originReplace1, success = pyData, true
            dataChange[pyData] = true
        end
    
        if originReplace1 then
            originData = pixels[coordinateToIndex(originOx, originOy, width)]
            if originData then
                stopEffect(originData[1])
                dataChange[originData] = nil
            end
            assignPixelsToFill(originReplace1, originSx, originSy, originOx, originOy)
        end
    
        return success
    end

    local function splitX(index)
        local effectData = pixels[index]
        local _, y = indexToCoordinate(index, width)
        local ex, ey, sx, sy, color = effectData[4], effectData[5], effectData[2], effectData[3], effectData[6]
        local end_y = ey + sy - 1
        local createIndex
    
        if y == ey or y == end_y then
            local edgeY = (y == ey) and ey or end_y
            createIndex = coordinateToIndex(ex, edgeY, width)
            
            local newData = createBasicData(createIndex, color)
            newData[2] = sx
    
            for i = 0, sx - 1 do
                pixels[createIndex + i] = newData
            end
    
            dataChange[newData] = true

            local effect = newData[1]
            colorChange[effect.id] = {effect, color}
    
            if y == ey then
                effectData[5] = ey + 1
            end
            effectData[3] = sy - 1
            dataChange[effectData] = true
        else
            local centerIndex = coordinateToIndex(ex, y, width)
            local centerData = createBasicData(centerIndex, color)
            centerData[2] = sx
    
            for i = 0, sx - 1 do
                pixels[centerIndex + i] = centerData
            end
    
            dataChange[centerData] = true
            
            local effect = centerData[1]
            colorChange[effect.id] = {effect, color}

            local remainingHeight = end_y - y
            local endData = createBasicData(coordinateToIndex(ex, y + 1, width), color)
            endData[2], endData[3] = sx, remainingHeight
    
            for row = 0, remainingHeight - 1 do
                local rowIndex = coordinateToIndex(ex, y + 1 + row, width)
                for i = 0, sx - 1 do
                    pixels[rowIndex + i] = endData
                end
            end
    
            dataChange[endData] = true

            local effect = endData[1]
            colorChange[effect.id] = {effect, color}
    
            effectData[3] = y - ey
            dataChange[effectData] = true
        end
    end
    
    local function splitXY(index)
        local effectData = pixels[index]
        local x, _ = indexToCoordinate(index, width)
        local ex, sx, color = effectData[4], effectData[2], effectData[6]
        local edgeX = ex + sx - 1
    
        local newData = createBasicData(index, color)
        pixels[index] = newData
        dataChange[newData] = true

        local effect = newData[1]
        colorChange[effect.id] = {effect, color}
    
        if x == ex then
            effectData[4] = ex + 1
            effectData[2] = sx - 1
        elseif x == edgeX then
            effectData[2] = sx - 1
        else
            local endXOffset = edgeX - x
            local endIndex = index + 1
            local endData = createBasicData(endIndex, color)
            endData[2] = endXOffset
    
            for i = 0, endXOffset - 1 do
                pixels[endIndex + i] = endData
            end
    
            dataChange[endData] = true

            local effect = endData[1]
            colorChange[effect.id] = {effect, color}
    
            effectData[2] = x - ex
        end
        
        dataChange[effectData] = true
    end

    if (not hasUpdated and hasCleared) or not getFirst(self_cl.updatedPoints) then
        local deleted = {}

        for _, effectData in pairs(self_cl.pixels) do
            local effect = effectData[1]
            local id = effect.id

            if sm_exists(effect) and not deleted[id] then
                effect_destroy(effect)
                deleted[id] = true
            end
        end

        dataChange = {}
        colorChange = {}
        pixels = {}
        oldBuffer = {}
        updatedPoints = {}

        self_cl.pixels = {}
        self_cl.oldBuffer = {}
        self_cl.updatedPoints = {}
    elseif hasUpdated then
        local doOptimise = width * height > 4096

        self_cl.hasUpdated = true
        self_cl.doOptimise = doOptimise

        for i, _ in pairs(updatedPoints) do
            local colNew = newBuffer[i] or (hasCleared and backpanelColor) or nil
            
            if colNew and (colNew ~= oldBuffer[i] or colNew == backpanelColor) then
                local effectPos = pixels[i]

                if not effectPos and colNew ~= backpanelColor and (not doOptimise or not meshNeighbours(i, colNew)) then
                    local data = createBasicData(i, colNew)
                    pixels[i] = data
                    dataChange[data] = true

                    local effect = data[1]
                    colorChange[effect.id] = {effect, colNew}
                elseif effectPos then
                    if effectPos[3] > 1 then splitX(i); effectPos = pixels[i] end
                    if effectPos[2] > 1 then splitXY(i); effectPos = pixels[i] end
                    if colNew == backpanelColor then
                        stopEffect(effectPos[1])

                        updatedPoints[i] = nil
                        dataChange[effectPos] = nil
                        pixels[i] = nil
                    elseif not doOptimise or not meshNeighbours(i, colNew) then
                        effectPos[6] = colNew

                        local effect = effectPos[1]
                        colorChange[effect.id] = {effect, colNew}
                    end
                end
            end
            
            oldBuffer[i] = colNew
        end
        
        for effectData, _ in pairs(dataChange) do
            setEffectParameters(effectData)
        end

        for _, data in pairs(colorChange) do
            effect_setParameter(data[1], "color", data[2])
        end
    end

    self_cl.pixels = pixels
    self_cl.oldBuffer = oldBuffer
    self_cl.stoppedIndex = stoppedIndex
    self_cl.updatedPoints = updatedPoints
    self_cl_pixel.stoppedEffects = stoppedEffects
    self_cl_pixel.selectionIndex = selectionIndex
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
        local x, y = effectData[4], effectData[5]
        local effect = effectData[1]
        local sx, sy = effectData[2], effectData[3]
    
        local centerX, centerY
    
        if sx == 1 and sy == 1 then
            effect_setScale(effect, sm_vec3_new(0, pixel_scale_y, pixel_scale_z))
    
            centerX = x - 1
            centerY = y - 1
        else
            effect_setScale(effect, sm_vec3_new(0, pixel_scale_y * sy, pixel_scale_z * sx))
    
            centerX = ((sx / 2) + x - 1) - 0.5
            centerY = ((sy / 2) + y - 1) - 0.5
        end
    
        local xPos, yPos = pixelPosToShapePos(centerX, centerY, widthScale, heightScale, pixel_scale)
        effect_setOffsetPosition(effect, sm_vec3_new(pixelDepth, yPos, xPos))

        effect_setParameter(effect, "color", effectData[6])
    end

    local function createBasicData(index, color)
        local x, y = indexToCoordinate(index, width)
        local effect = createEffect()
    
        return {
            effect,
            1,
            1,
            x, 
            y,
            color
        }
    end

    local processed = {}

    local function findMaxDimensions(startIndex, color)
        local maxWidth, maxHeight = 1, 1
        local x, y = indexToCoordinate(startIndex, width)
        processed[startIndex] = true
    
        
        for i = x + 1, width do
            local j = coordinateToIndex(i, y, width)
            local pixel = pixels[j]
    
            if not pixel or processed[j] or not areColorsSimilar(pixel[6], color, threshold) then
                break
            end
    
            processed[j] = true
            maxWidth = maxWidth + 1
        end
   
        for j = y + 1, height do
            local rowIsUniform = true
            local tempIndices = {}
            local tempIndex = 0
    
            for i = x, x + maxWidth - 1 do
                local j = coordinateToIndex(i, j, width)
                local pixel = pixels[j]
    
                if not pixel or processed[j] or not areColorsSimilar(pixel[6], color, threshold) then
                    rowIsUniform = false
                    break
                end
    
                tempIndex = tempIndex + 1
                tempIndices[tempIndex] = j
            end
    
            if not rowIsUniform then
                break
            end
    
            for _, index in ipairs(tempIndices) do
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

            local newData = createBasicData(index, effectData[6])
            newData[2] = sx
            newData[3] = sy

            local x, y = newData[4], newData[5]
            local x1, y1 = x, y
            local mx = x + sx - 1

            for _ = 1, sx * sy do
                newPixels[coordinateToIndex(x1, y1, width)] = newData

                x1 = x1 + 1

                if x1 > mx then
                    x1 = x
                    y1 = y1 + 1
                end
            end

            setEffectParameters(newData)
        end
    end

    self_cl.pixels = newPixels
    self_cl.stoppedIndex = stoppedIndex
    self_cl_pixel.stoppedEffects = stoppedEffects
    self_cl_pixel.selectionIndex = selectionIndex
end

function DisplayClass:cl_setDisplayHidden(params)
    local setHidden = params[1]
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