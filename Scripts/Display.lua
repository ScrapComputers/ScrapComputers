-- Ben has sacraficed his fucking soul making display's. VeraDev died commenting the entire display, its even beter because now its all gone.
-- If you ever make your own display's. You will actually kill yourself. We are NOT joking.

local sm_scrapcomputers_errorHandler_assertArgument = sm.scrapcomputers.errorHandler.assertArgument
local sm_scrapcomputers_errorHandler_assert = sm.scrapcomputers.errorHandler.assert
local sm_scrapcomputers_string_splitString = sm.scrapcomputers.string.splitString

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

local bit_bor = bit.bor
local bit_band = bit.band
local bit_lshift = bit.lshift
local bit_rshift = bit.rshift

local math_floor = math.floor
local math_ceil = math.ceil
local math_sqrt = math.sqrt
local math_max = math.max

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

local PIXEL_UUID = sm.uuid.new("cd943f04-96c7-43f0-852c-b2d68c7fc157")
local BACKPANEL_EFFECT_NAME = "ScrapComputers - ShapeRenderableBackPanel"
local width, height = sm.gui.getScreenSize()

local byteLimit = 65000
local tableLimit = 15000
local displayHidingCooldown = 0.1

local imagePath = "$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/DisplayImages/"

local networkInstructions = {
    ["DIS_VIS"] = "cl_setDisplayHidden",
    ["SET_REND"] = "cl_setRenderDistance",
    ["SET_THRESHOLD"] = "cl_setThreshold",
    ["TOUCH_STATE"] = "cl_setTouchAllowed"
}

local dataCountLookup = {
    2,
    3,
    1,
    4,
    5,
    4,
    6,
    0,
    3
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

-- Returns true if the 2 colors are similar given via a threshold
---@param color Color The first color
---@param color1 Color The seccond color
---@param threshold number (Optional) The threshold of how accruate it should be. By default its 0 aka exactly same color.
---@return boolean colorSame If this is true. then the 2 colors are similar from the threshold.
function areColorsSimilar(color, color1, threshold)
    if not color or not color1 then return false end

    threshold = threshold or 0
    local distance = colorDistance(color.r, color.g, color.b, color1.r, color1.g, color1.b)

    return distance <= threshold
end

-- Returns the distance between 2 colors (R1, G1, B1, R2, G2, B2)
---@param r1 number The first color for Red
---@param g1 number The first color for Green
---@param b1 number The first color for Blue
---@param r2 number The seccond color for Red
---@param g2 number The seccond color for Green
---@param b2 number The seccond color for Blue
---@return number colorDistance The distance between the 2 color's.
function colorDistance(r1, g1, b1, r2, g2, b2)
    local dr = r2 - r1
    local dg = g2 - g1
    local db = b2 - b1

    return math_sqrt(dr^2 + dg^2 + db^2)
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

    for i, num in ipairs(numbers) do
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

-- The torture. Someone please give us a soul. Espessally Ben Bingo, He wrote the entire display. PLEASE GIVE US SOME FUCKING WATER, WE HAVENT DRANK WATER SINCE DAY 1.
-- SOME ONE PLEASE FUCKING HELP US. WE DONT WANNA DIE. PLEASE PLEASE AAAAAAAAAAAAAAAA
--
-- Anyways, This optimizes the stack of pixels ready to get drawn, reduces the instructiuon count massivley
---@param indexedStack table The instruction Set
---@param width number The width of the display
---@param height number The height of the display
---@param threshold number The optimization threshold
---@param formatToNetwork boolean If the function is formatting the result to netowrk or not
---@return table TooMuchOptimizedInstructionSet The reduced instruction set afther it was slaughtered.
function optimizeDisplayPixelStack(indexedStack, width, height, threshold, formatToNetwork)
    local optimizedStack = {}
    local processed = {}

    local function findMaxDimensions(x, y, color)
        local maxWidth, maxHeight = 1, 1

        for i = x + 1, width do
            local index = coordinateToIndex(i, y, width)
            local pixelIndex = indexedStack[index]

            if not pixelIndex or processed[index] or not areColorsSimilar(pixelIndex, color, threshold) then
                break
            end
            maxWidth = maxWidth + 1
        end

        for j = y + 1, height do
            local rowIsUniform = true
            for i = x, x + maxWidth - 1 do
                local index = coordinateToIndex(i, j, width)
                local pixelIndex = indexedStack[index]

                if not pixelIndex or processed[index] or not areColorsSimilar(pixelIndex, color, threshold) then
                    rowIsUniform = false
                    break
                end
            end
            if not rowIsUniform then break end
            maxHeight = maxHeight + 1
        end

        return maxWidth, maxHeight
    end

    local function markBlockAsProcessed(x, y, maxWidth, maxHeight)
        local i, j = x, y

        for _ = 1, maxWidth * maxHeight do
            processed[coordinateToIndex(i, j, width)] = true

            i = i + 1

            if i > x + maxWidth - 1 then
                j = j + 1
                i = x
            end
        end
    end

    local cahcedIndex = 0
    local optimizedStack = {}
    local keys = {}
    local keyIndex = 0

    for index in pairs(indexedStack) do
        local x, y = indexToCoordinate(index, width)

        keyIndex = keyIndex + 1
        keys[keyIndex] = {index, x, y}
    end

    if keyIndex == width * height and not formatToNetwork then
        for _, keyData in ipairs(keys) do
            local index = keyData[1]

            cahcedIndex = cahcedIndex + 1
            optimizedStack[cahcedIndex] = {
                keyData[2],
                keyData[3],
                1,
                1,
                indexedStack[index]
            }
        end

        return optimizedStack
    end

    table_sort(keys, function(a, b)
        local ay = a[3]
        local by = b[3]

        if ay == by then
            return a[2] < b[2]
        else
            return ay < by
        end
    end)

    for _, keyData in ipairs(keys) do
        local index = keyData[1]

        if not processed[index] then
            local x, y = keyData[2], keyData[3]
            local pixelIndex = indexedStack[index]

            local maxWidth, maxHeight = findMaxDimensions(x, y, pixelIndex)

            cahcedIndex = cahcedIndex + 1

            if formatToNetwork then
                optimizedStack[cahcedIndex] = 9
                cahcedIndex = cahcedIndex + 1
                optimizedStack[cahcedIndex] = index
                cahcedIndex = cahcedIndex + 1
                optimizedStack[cahcedIndex] = coordinateToIndex(maxWidth, maxHeight, width)
                cahcedIndex = cahcedIndex + 1
                optimizedStack[cahcedIndex] = colorToID(pixelIndex)
            else
                optimizedStack[cahcedIndex] = {
                    x,
                    y,
                    maxWidth,
                    maxHeight,
                    pixelIndex
                }
            end

            markBlockAsProcessed(x, y, maxWidth, maxHeight)
        end
    end

    return optimizedStack
end


-- SERVER --

-- Creates all functions for the display
function DisplayClass:sv_createData()
    local shapeId = self.shape.id
    local colorCache = sm.scrapcomputers.backend.cameraColorCache
    local data = self.data
    local data_width = data.width
    local data_height = data.height

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

        
        local dataBuffer = self.sv.buffer.data
        local len = #dataBuffer

        dataBuffer[len + 1] = 4
        dataBuffer[len + 2] = coordinateToIndex(round(x), round(y), data_width)
        dataBuffer[len + 3] = round(radius)
        dataBuffer[len + 4] = colorToID(type(color) == "string" and sm_color_new(color) or color)
        dataBuffer[len + 5] = isFilled

        if colorCache then
            colorCache[shapeId] = nil
        end
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

        sm_scrapcomputers_errorHandler_assertArgument(color, 7, {"Color", "string"})

        
        local dataBuffer = self.sv.buffer.data
        local len = #dataBuffer

        dataBuffer[len + 1] = 5
        dataBuffer[len + 2] = coordinateToIndex(round(x1), round(y1), data_width)
        dataBuffer[len + 3] = coordinateToIndex(round(x2), round(y2), data_width)
        dataBuffer[len + 4] = coordinateToIndex(round(x3), round(y3), data_width)
        dataBuffer[len + 5] = colorToID(type(color) == "string" and sm_color_new(color) or color)
        dataBuffer[len + 6] = isFilled

        if colorCache then
            colorCache[shapeId] = nil
        end
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

        sm_scrapcomputers_errorHandler_assertArgument(color, 4, {"Color", "string"})

        local dataBuffer = self.sv.buffer.data
        local len = #dataBuffer

        dataBuffer[len + 1] = 6
        dataBuffer[len + 2] = coordinateToIndex(round(x), round(y), data_width)
        dataBuffer[len + 3] = coordinateToIndex(round(width), round(height), data_width)
        dataBuffer[len + 4] = colorToID(type(color) == "string" and sm_color_new(color) or color)
        dataBuffer[len + 5] = isFilled

        if colorCache then
            colorCache[shapeId] = nil
        end
    end

    return {
        ---Draws a pixel
        ---@param x number
        ---@param y number
        ---@param color Color
        drawPixel = function (x, y, color)
            sm_scrapcomputers_errorHandler_assertArgument(x, 1, {"number"})
            sm_scrapcomputers_errorHandler_assertArgument(y, 2, {"number"})

            if x < 1 or x > data_width or y < 1 or y > data_height then return end

            sm_scrapcomputers_errorHandler_assertArgument(color, 3, {"Color", "string"})
            
            local dataBuffer = self.sv.buffer.data
            local len = #dataBuffer
            
            dataBuffer[len + 1] = 1
            dataBuffer[len + 2] = coordinateToIndex(round(x), round(y), data_width)
            dataBuffer[len + 3] = colorToID(type(color) == "string" and sm_color_new(color) or color)

            if colorCache then
                colorCache[shapeId] = nil
            end
        end,

        ---Draws pixels from a table
        ---@param tbl PixelTable The table of pixels
        drawFromTable = function (tbl)
            sm_scrapcomputers_errorHandler_assertArgument(tbl, nil, {"table"}, {"PixelTable"})

            local tableBuffer = self.sv.buffer.drawTable
            local index = #tableBuffer + 1

            tableBuffer[index] = {}

            local backpannel = self.sv.backPanel

            for i, pixel in pairs(tbl) do
                local pixel_x = pixel.x
                local pixel_y = pixel.y
                local pixel_color = pixel.color

                local xType = type(pixel_x)
                local yType = type(pixel_y)
                local colorType = type(pixel_color)

                sm_scrapcomputers_errorHandler_assert(pixel_x and pixel_y and pixel_color, "missing data at index "..i..".")

                sm_scrapcomputers_errorHandler_assert(xType == "number", nil, "bad x value at index "..i..". Expected number. Got "..xType.." instead!")
                sm_scrapcomputers_errorHandler_assert(yType == "number", nil, "bad y value at index "..i..". Expected number. Got "..yType.." instead!")
                sm_scrapcomputers_errorHandler_assert(colorType == "Color" or colorType == "string", nil, "bad color at index "..i..". Expected Color or string. Got ".. colorType.." instead!")

                if pixel_color ~= backpannel then
                    tableBuffer[index][coordinateToIndex(pixel_x, pixel_y, data_width)] = type(pixel_color) == "string" and sm_color_new(pixel_color) or pixel_color
                end
            end
        end,

        -- Clear the display
        ---@param color MultiColorType The new background color or 000000
        clear = function (color)
            sm_scrapcomputers_errorHandler_assertArgument(color, nil, {"Color", "string", "nil"})
            

            self.sv.buffer.data = {}

            local dataBuffer = self.sv.buffer.data
            local clearColor = colorToID(color and (type(color) == "string" and sm_color_new(color) or color) or sm_color_new(0, 0, 0))

            dataBuffer[1] = 3
            dataBuffer[2] = clearColor

            self.sv.backPanel = clearColor

            if colorCache then
                colorCache[shapeId] = nil
            end
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

            sm_scrapcomputers_errorHandler_assertArgument(color, 5, {"Color", "string"})

            
            local dataBuffer = self.sv.buffer.data
            local len = #dataBuffer
            
            dataBuffer[len + 1] = 2
            dataBuffer[len + 2] = coordinateToIndex(round(x), round(y), data_width)
            dataBuffer[len + 3] = coordinateToIndex(round(x1), round(y1), data_width)
            dataBuffer[len + 4] = colorToID(type(color) == "string" and sm_color_new(color) or color)

            if colorCache then
                colorCache[shapeId] = nil
            end
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

            sm_scrapcomputers_errorHandler_assertArgument(text, 3, {"string"})
            sm_scrapcomputers_errorHandler_assertArgument(color, 4, {"Color", "string", "nil"})
            
            sm_scrapcomputers_errorHandler_assertArgument(fontName, 5, {"string", "nil"})

            sm_scrapcomputers_errorHandler_assertArgument(maxWidth, 5, {"boolean", "nil"})
            sm_scrapcomputers_errorHandler_assertArgument(wordWrappingEnabled, 5, {"boolean", "nil"})
            
            fontName = fontName or sm.scrapcomputers.fontManager.getDefaultFontName()

            local font, errMsg = sm.scrapcomputers.fontManager.getFont(fontName)
            sm_scrapcomputers_errorHandler_assert(font, 5, errMsg)

            
            local data_width = self.data.width

            if text ~= "" then
                color = color or "EEEEEE"
                maxWidth = maxWidth or data_width
                wordWrappingEnabled = type(wordWrappingEnabled) == "boolean" and wordWrappingEnabled or true

                local dataBuffer = self.sv.buffer.data
                local len = #dataBuffer

                dataBuffer[len + 1] = 7
                dataBuffer[len + 2] = coordinateToIndex(round(x), round(y), data_width)
                dataBuffer[len + 3] = text
                dataBuffer[len + 4] = colorToID(type(color) == "string" and sm_color_new(color) or color)
                dataBuffer[len + 5] = fontName
                dataBuffer[len + 6] = maxWidth
                dataBuffer[len + 7] = wordWrappingEnabled
            end

            if colorCache then
                colorCache[shapeId] = nil
            end
        end,

        loadImage = function(width, height, path)
            sm_scrapcomputers_errorHandler_assertArgument(width, 1, {"integer"})
            sm_scrapcomputers_errorHandler_assertArgument(height, 2, {"integer"})

            sm_scrapcomputers_errorHandler_assertArgument(path, 3, {"string"})

            local fileLocation = imagePath..path
            sm_scrapcomputers_errorHandler_assert(sm.json.fileExists(fileLocation), 3, "Image doesnt exist")

            local imageTbl = sm.json.open(fileLocation)

            local tableBuffer = self.sv.buffer.drawTable
            local index = #tableBuffer + 1

            tableBuffer[index] = {}

            local x, y = 1, 1
            local backpannel = self.sv.backPanel
            

            for i, color in pairs(imageTbl) do
                local rgb = sm_color_new(color)

                if rgb ~= backpannel then
                    tableBuffer[index][coordinateToIndex(x, y, width)] = rgb
                end

                y = y + 1

                if y > height then
                    y = 1
                    x = x + 1
                end
            end

            if colorCache then
                colorCache[shapeId] = nil
            end
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

        -- Gets the touched latest data. Will error if touchscreen is disabled
        getTouchData = function()
            return self.sv.display.touchData
        end,

        -- Renders the pixels to the display.
        update = function ()
            self.sv.allowUpdate = true
        end,

        -- Always update's the display. We highly do not suggest doing this as its VERY laggy.
        ---@param bool boolean Toggle the autoUpdate system.
        autoUpdate = function (bool)
            sm_scrapcomputers_errorHandler_assertArgument(bool, nil, {"boolean"})

            self.sv.autoUpdate = bool
        end,

        -- Optimizes the display to the extreme. Will be costy during the optimization but will be a massive performance increase after it.
        optimize = function ()
            self.sv.buffer.data[#self.sv.buffer.data + 1] = 8
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
end

function DisplayClass:server_onFixedUpdate()
    local self_data = self.data
    local data_width = self_data.width
    local data_height = self_data.height
    local self_network = self.network
    local sendToClients = self_network.sendToClients
    local sendToClient = self_network.sendToClient

    if #self.sv.buffer.network > 0 then
        for _, data in pairs(self.sv.buffer.network) do
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

        self.sv.buffer.network = {}
    end

    local drawTable = self.sv.buffer.drawTable
    local tableBuffer = #drawTable > 0

    if self.sv.allowUpdate or self.sv.autoUpdate then
        local dataBuffer = self.sv.buffer.data

        if tableBuffer then
            for _, table in pairs(drawTable) do
                local optimisedTable = optimizeDisplayPixelStack(table, data_width, data_height, self.sv.display.threshold, true)
                local dataBufferInd = #dataBuffer

                for i, pixel in pairs(optimisedTable) do
                    dataBufferInd = dataBufferInd + 1
                    dataBuffer[dataBufferInd] = pixel
                end
            end
        end

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

        self.sv.buffer.data = {}
        self.sv.buffer.drawTable = {}

        self.sv.allowUpdate = false
    end

    if self.sv.needSync and self.sv.synced and self.sv.pixel.pixelData then
        self.sv.synced = false

        local player = self.sv.needSync
        for index, pixel in pairs(self.sv.pixel.pixelData) do
            pixel[5] = idToColor(pixel[5])

            sendToClient(self_network, player, "cl_drawPixel", pixel)
        end

        sendToClient(self_network, player, "cl_syncDisplay", {color = self.sv.pixel.backPanel, touch = self.sv.display.touchAllowed})
        sendToClient(self_network, player, "cl_pushPixels")

        self.sv.pixel.pixelData = {}
        self.sv.needSync = nil
    end
end

function DisplayClass:server_onCreate()
    self.sv = {
        display = {
            threshold = 0
        },

        pixel = {
            pixelData = {},
            backPanel = sm_color_new("000000")
        },

        buffer = {
            data = {},
            drawTable = {},
            network = {}
        },
    }
end

function DisplayClass:sv_setTouchData(data)
    self.sv.display.touchData = data
end

function DisplayClass:sv_syncDisplay(_, player)
    self.sv.needSync = player
end

function DisplayClass:sv_syncData(data)
    if data.i == 1 then
        self.sv.rebuildStr = data.string
    else
        self.sv.rebuildStr = self.sv.rebuildStr..data.string
    end

    if data.finished then 
        self.sv.pixel.pixelData = sm.json.parseJsonString(self.sv.rebuildStr)

        self.sv.rebuildStr = nil
        self.sv.synced = true
    end
end

function DisplayClass:server_onDestroy()
    if sm.scrapcomputers.backend.cameraColorCache then
        sm.scrapcomputers.backend.cameraColorCache[self.shape.id] = nil
    end
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

-- Selects a random ShapeRenderable from 0 to 255. Why not just use ShapeRenderable? If were to use that. We would reach the effect limit pretty easly.
-- So we do someting VERY janky and Iliegal by making 256 clone's of shaperenderable due to some fuckery on Scrap Mechanic so we can bypass the limit.
---@return string PixelShapeRenderableName The shape renderable to use for the pixel
function DisplayClass:cl_selectShapeRenderable()
    local str = "ScrapComputers - ShapeRenderable"..self.cl.pixel.selectionIndex

    self.cl.pixel.selectionIndex = self.cl.pixel.selectionIndex + 1
    if self.cl.pixel.selectionIndex == 256 then self.cl.pixel.selectionIndex = 0 end

    return str
end

function DisplayClass:client_onCreate()
    self.cl = {
        pixel = {
            pixels = {},
            pixelData = {},
            occupied = {},
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

        startBuffer = {},
        stopBuffer = {},
        tblParams = {},
        optimiseBuffer = {},
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

    if not sm.isHost then
        self.network:sendToServer("sv_syncDisplay")
    end
end

function DisplayClass:cl_syncDisplay(data)
    effect_setParameter(self.cl.backPanel.effect, "color", data.color)
    self.cl.display.touchAllowed = data.touch
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
    local width = self.data.width
    local clock = os.clock()
    local pos = camera.getPosition()
    local dir = camera.getDirection()
    local character = localPlayer.getPlayer().character

    if self.cl.display.visTimer + displayHidingCooldown <= clock and character then
        self.cl.display.visTimer = clock

        local worldPosition = self.shape.worldPosition
        local shouldHide = false

        if sm_vec3_length(worldPosition - character.worldPosition) > self.cl.display.renderDistance then
            shouldHide = true
        end

        if not shouldHide then
            local bb = self.shape:getBoundingBox()

            local at = sm.quat.getAt(self.shape.worldRotation)
            local up = sm.quat.getUp(self.shape.worldRotation)

            local boundry = {}

            boundry[1] = worldPosition + at * bb.z / 2
            boundry[2] = worldPosition - at * bb.z / 2

            boundry[3] = worldPosition + up * bb.y / 2
            boundry[4] = worldPosition - up * bb.y / 2

            boundry[5] = boundry[4] + at * bb.z / 2
            boundry[6] = boundry[4] - at * bb.z / 2

            boundry[7] = boundry[3] + at * bb.z / 2
            boundry[8] = boundry[3] - at * bb.z / 2

            shouldHide = true

            local dirDot = sm_vec3_dot(dir, sm_vec3_normalize(worldPosition - pos))

            if dirDot > 0 then
                local sm_render_getScreenCoordinatesFromWorldPosition = sm.render.getScreenCoordinatesFromWorldPosition

                for i, bound in pairs(boundry) do
                    local x, y = sm_render_getScreenCoordinatesFromWorldPosition(bound, width, height)

                    if not ((x < 0 or x > width) or (y < 0 or y > height)) then
                        shouldHide = false
                        break
                    end
                end
            end
        end

        if not shouldHide then
            local startPos = worldPosition + sm.quat.getRight(self.shape.worldRotation) * 0.15
            local diff = pos - worldPosition
            local endPos = startPos + sm_vec3_normalize(diff) * sm_vec3_length(diff)

            local hit, res = sm.physics.raycast(startPos, endPos)

            if hit and res.type ~= "character" then
                shouldHide = true
            end
        end

        if not self.cl.display.userHidden then
            if shouldHide then
                self:cl_setDisplayHidden({shouldHide})
                self.cl.prevHidden = true
            elseif not shouldHide and self.cl.prevHidden then
                self:cl_setDisplayHidden({shouldHide})
                self.cl.prevHidden = false
            end
        end
    end

    if sm.isHost then
        local players = sm.player.getAllPlayers()
        local len = #players

        if len ~= self.cl.lastLen then
            if not self.cl.lastLen or len > self.cl.lastLen then
                local sendTbl = {}
                local sendIndex = 0

                for index, pixelData in pairs(self.cl.pixel.pixelData) do
                    local x, y = indexToCoordinate(index, width)
                    local data = {
                        x,
                        y,
                        pixelData[1],
                        pixelData[2],
                        colorToID(pixelData[3])
                    }

                    sendIndex = sendIndex + 1
                    sendTbl[sendIndex] = data
                end

                local json = sm.json.writeJsonString(sendTbl)
                local strings = sm_scrapcomputers_string_splitString(json, byteLimit)
                local self_network = self.network

                for i, string in pairs(strings) do
                    self_network:sendToServer("sv_syncData", {string = string, i = i, finished = i == #strings})
                end
            end

            self.cl.lastLen = len
        end
    end

    if self.cl.display.interacting and self.cl.display.interactState == 1 then
        self.cl.display.interactState = 2
    elseif not self.cl.display.interacting and self.cl.wasInteracting then
        self.cl.wasInteracting = nil
        self.cl.display.interactState = 3
    end

    if self.cl.deleteTouchData and self.cl.deleteTouchData + 1 <= sm.game.getCurrentTick() then
        self.cl.deleteTouchData = nil
        self.network:sendToServer("sv_setTouchData", nil)
    end

    if self.cl.display.interacting or self.cl.display.interactState == 3 then
        local hit, res = localPlayer.getRaycast(7.5)
        local shape = res:getShape()

        if (hit and shape and shape.id == self.shape.id) or self.cl.display.interactState == 3 then
            if self.cl.display.interactState ~= 3 then
                self.cl.point = self.shape:transformPoint(res.pointWorld)
            end

            local x, y = shapePosToPixelPos(self.cl.point, self.cl.display.widthScale, self.cl.display.heightScale, self.cl.pixel.pixelScale)
            x = sm.util.clamp(x, 1, self.data.width)
            y = sm.util.clamp(y, 1, self.data.height)

            if not self.cl.display.interactState then self.cl.display.interactState = 1 end

            local touchData = {
                x = round(x),
                y = round(y),

                state = self.cl.display.interactState
            }

            self.network:sendToServer("sv_setTouchData", touchData)

            if self.cl.display.interactState == 3 then
                self.cl.display.interactState = nil
                self.cl.deleteTouchData = sm.game.getCurrentTick()
            end
        else
            self.cl.display.interacting = false
            self.cl.wasInteracting = nil
            self.cl.display.interactState = 3
        end
    end
end

function DisplayClass:client_onUpdate()
    local pos = camera.getPosition()
    local dir = camera.getDirection()
    local character = localPlayer.getPlayer().character

    local hit, res = sm.physics.raycast(pos, pos + dir * 7.5, character, 3)

    if hit then
        local shape = res:getShape()

        if shape and shape.id == self.shape.id then
            local lockingInt = character:getLockingInteractable()

            if lockingInt and lockingInt:hasSeat() then
                self:cl_checkRaycastValidity(res, true)
                self.cl.isSeated = true
            else
                self:cl_checkRaycastValidity(res)
                self.cl.isSeated = false
            end
        else
            self.cl.raycastValid = false
        end
    else
        self.cl.raycastValid = false
    end
end

function DisplayClass:cl_checkRaycastValidity(res, isTinker)
    if self.cl.display.touchAllowed then
        local roundedNorm = sm_vec3_new(round(res.normalLocal.x), round(res.normalLocal.y), round(res.normalLocal.z))
        self.cl.display.raycastValid = self.shape:getXAxis() == roundedNorm

        if self.cl.display.raycastValid then
            local isTinkerText = isTinker and sm.gui.getKeyBinding("Tinker", true) or sm.gui.getKeyBinding("Use", true)
            sm.gui.setInteractionText("", sm.scrapcomputers.languageManager.translatable("scrapcomputers.display.touchscreen", isTinkerText), "")
            sm.gui.setInteractionText("")
        else
            sm.gui.setInteractionText("")
            sm.gui.setInteractionText("")
        end
    else
        sm.gui.setInteractionText("")
        sm.gui.setInteractionText("")
    end
end

function DisplayClass:cl_onTouch(state)
    if self.cl.display.raycastValid then
        sm.audio.play(state and "Button on" or "Button off")

        self.cl.display.interacting = state

        if not self.cl.wasInteracting then
            self.cl.wasInteracting = true
        end
    end
end

function DisplayClass:client_onInteract(character, state)
    if self.cl.isSeated then return end
    self:cl_onTouch(state)
end

function DisplayClass:client_onTinker(character, state)
    if not self.cl.isSeated then return end
    self:cl_onTouch(state)
end

---@param params table The parameters
function DisplayClass:cl_drawPixel(params)
    local self_cl = self.cl
    local self_data = self.data
    local self_cl_pixel = self_cl.pixel
    local pixels = self_cl_pixel.pixels
    local pixelData = self_cl_pixel.pixelData
    local occupiedTbl = self_cl_pixel.occupied

    local params_x = params[1]
    local params_y = params[2]
    local params_color = params[5]
    params_color = type(params_color) == "Color" and params_color or sm_color_new(params_color)
    local params_scale_x = params[3]
    local params_scale_y = params[4]

    local data_width = self_data.width
    local data_height = self_data.height
    local backpanel_color = self_cl.backPanel.currentColor

    if params_x > data_width or params_y > data_height or params_x + params_scale_x - 1 < 1 or params_y + params_scale_y - 1 < 1 then return end

    if params_x < 1 then
        params_scale_x = params_scale_x + params_x - 1
        params_x = 1
    end

    if params_x + params_scale_x - 1 > data_width then
        params_scale_x = data_width - params_x + 1
    end

    if params_y < 1 then
        params_scale_y = params_scale_y + params_y - 1
        params_y = 1
    end

    if params_y + params_scale_y - 1 > data_height then
        params_scale_y = data_height - params_y + 1
    end

    local dataIndex = coordinateToIndex(params_x, params_y, data_width)
    local occupied = occupiedTbl[dataIndex]
    local effect = pixels[occupied]
    local effectData = pixelData[occupied]

    if params_scale_x == 1 and params_scale_y == 1 then
        if not sm_exists(effect) then
            if params_color ~= backpanel_color then
                self:cl_createPixelEffect(params_x, params_y, params_scale_x, params_scale_y, params_color)
            end
            return
        end

        local effectData_x, effectData_y = indexToCoordinate(occupied, data_width)
        local effectData_scale_x = effectData[1]
        local effectData_scale_y = effectData[2]
        local effectData_color = effectData[3]

        if (effectData_scale_x ~= 1 or effectData_scale_y ~= 1) and params_color ~= effectData_color then
            self:cl_splitEffect(effectData_x, effectData_y, params_x, params_y, params_scale_x, params_scale_y)
            if params_color ~= backpanel_color then
                self:cl_createPixelEffect(params_x, params_y, params_scale_x, params_scale_y, params_color)
            end
            return
        end

        if params_color ~= effectData_color then
            effect_setParameter(effect, "color", params_color)
            effectData[3] = params_color
        end

        if params_color ~= backpanel_color then
            self:cl_startEffect(effect)
        else
            self:cl_stopEffect(effect, effectData, occupied)
        end

        return
    end

    local set = false
    if effectData then
        local effectData_x, effectData_y = indexToCoordinate(occupied, data_width)
        local effectData_scale_x = effectData[1]
        local effectData_scale_y = effectData[2]
        local effectData_color = effectData[3]

        if effectData_scale_x == params_scale_x and effectData_scale_y == params_scale_y and effectData_x == params_x and effectData_y == params_y then
            if params_color ~= effectData_color then
                effect_setParameter(effect, "color", params_color)

                effectData[3] = params_color
            end

            if params_color ~= backpanel_color then
                self:cl_startEffect(effect)
            else
                self:cl_stopEffect(effect, effectData, occupied)
            end

            set = true
        end
    end

    if not set then
        local x1, y1 = params_x, params_y

        for _ = 1, params_scale_x * params_scale_y do
            local dataIndex = coordinateToIndex(x1, y1, data_width)
            local occupiedIndex = occupiedTbl[dataIndex]

            if occupiedIndex then
                local effectData = pixelData[occupiedIndex]
                local split = false

                if effectData then
                    local effectData_x, effectData_y = indexToCoordinate(occupiedIndex, data_width)
                    local effectData_scale_x = effectData[1]
                    local effectData_scale_y = effectData[2]
                    local effectData_color = effectData[3]

                    if effectData_scale_x ~= 1 or effectData_scale_y ~= 1 then

                        local existingMinX, existingMaxX = effectData_x, effectData_x + effectData_scale_x - 1
                        local existingMinY, existingMaxY = effectData_y, effectData_y + effectData_scale_y - 1

                        local drawingMinX, drawingMaxX = params_x, params_x + params_scale_x - 1
                        local drawingMinY, drawingMaxY = params_y, params_y + params_scale_y - 1

                        if existingMinX < drawingMinX or existingMinY < drawingMinY or existingMaxX > drawingMaxX or existingMaxY > drawingMaxY then
                            self:cl_splitEffect(effectData_x, effectData_y, params_x, params_y, params_scale_x, params_scale_y)

                            split = true
                        end
                    end
                end

                if not split then
                    self:cl_stopEffect(pixels[occupiedIndex], effectData, occupiedIndex)
                end
            end

            x1 = x1 + 1

            if x1 > params_x + params_scale_x - 1 then
                y1 = y1 + 1
                x1 = params_x
            end
        end

        if params_color ~= backpanel_color then
            self:cl_createPixelEffect(params_x, params_y, params_scale_x, params_scale_y, params_color)
        end
    end
end

function DisplayClass:cl_scaledAdd(params)
    local x, y = params[1], params[2]
    local sx, sy = params[3], params[4]
    local optimisedBuffer = self.cl.optimiseBuffer
    local width = self.data.width
    local x1, y1 = x, y
    
    for i = 1, sx * sy do
        local index = coordinateToIndex(x1, y1, width)

        optimisedBuffer[index] = nil

        x1 = x1 + 1

        if x1 > x + sx - 1 then
            y1 = y1 + 1
            x1 = x
        end
    end

    self:cl_drawPixel(params)
end

function DisplayClass:cl_addToTable(params)
    self.cl.optimiseBuffer[params[1]] = idToColor(params[2])
end

function DisplayClass:cl_formatDraw(params)
    local width = self.data.width
    local x, y = indexToCoordinate(params[1], width)
    local sx, sy = indexToCoordinate(params[2], width)

    self:cl_drawPixel({x, y, sx, sy, idToColor(params[3])})
end

function DisplayClass:cl_pushData()
    local self_cl = self.cl
    local data = self_cl.buffer.data
    local totalLen = #data
    local searchIndex = 0

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
            self:cl_addToTable(currentParam)
        elseif instruction == 2 then
            self:cl_drawLine(currentParam)
        elseif instruction == 3 then
            self:cl_clearDisplay(currentParam)
        elseif instruction == 4 then
            self:cl_drawCircle(currentParam)
        elseif instruction == 5 then
            self:cl_drawTriangle(currentParam)
        elseif instruction == 6 then
            self:cl_drawRect(currentParam)
        elseif instruction == 7 then
            self:cl_drawText(currentParam)
        elseif instruction == 8 then
            self:cl_optimizeDisplayEffects()
        elseif instruction == 9 then
            self:cl_formatDraw(currentParam)
        end
    end

    local self_data = self.data
    local optimisedBuffer = optimizeDisplayPixelStack(self_cl.optimiseBuffer, self_data.width, self_data.height, self_cl.display.threshold)

    for i, pixel in pairs(optimisedBuffer) do
        self:cl_drawPixel(pixel)
    end

    self_cl.optimiseBuffer = {}
    self_cl.buffer.data = {}

    self:cl_pushPixels()
end

function DisplayClass:cl_pushPixels()
    local self_cl = self.cl
    local startBuffer = self_cl.startBuffer

    if not self_cl.display.isHidden then
        for i, effect in pairs(startBuffer) do
            if sm_exists(effect) then
                effect_start(effect)
            else
                startBuffer[i] = nil
            end
        end
    end

    for i, effect in pairs(self_cl.stopBuffer) do
        effect_stop(effect)
    end

    self_cl.startBuffer = {}
    self_cl.stopBuffer = {}
end

function DisplayClass:cl_cacheCheck(index, color)
    local self_cl = self.cl
    local self_cl_pixel = self_cl.pixel
    local occupied = self_cl_pixel.occupied[index]

    if not occupied or not areColorsSimilar(self_cl_pixel.pixelData[occupied][3], color, self_cl.display.threshold) then
        return true
    end

    return false
end

-- Creates a pixel effect
---@param x number The x-coordinate of the pixel
---@param y number The y-coordinate of the pixel
---@param scale {x : number, y : number} The scale of the pixe;
---@param color Color The color of it
function DisplayClass:cl_createPixelEffect(x, y, scale_x, scale_y, color)
    local self_data = self.data
    local self_cl = self.cl
    local self_cl_pixel = self_cl.pixel
    local self_cl_display = self_cl.display
    local self_data_panelOffset = self_data.panelOffset
    local data_width = self_data.width

    local pixel_scale = self_cl_pixel.pixelScale
    local pixel_scale_y = pixel_scale.y
    local pixel_scale_z = pixel_scale.z

    local pixelDepth = self_data_panelOffset and self_data_panelOffset + 0.001 or 0.116

    local newEffectData = {
        scale_x,
        scale_y,
        color,
    }

    local newEffect
    local effectId, cachedEffect = next(self_cl_pixel.stoppedEffects)

    if cachedEffect then
        newEffect = cachedEffect
        self_cl_pixel.stoppedEffects[effectId] = nil
        self_cl.stoppedIndex = self_cl.stoppedIndex - 1
    else
        newEffect = sm_effect_createEffect(self:cl_selectShapeRenderable(), self.interactable)
        effectId = newEffect.id
        effect_setParameter(newEffect,"uuid", PIXEL_UUID)
    end

    local is1x1 = scale_x == 1 and scale_y == 1

    local centerX = 0
    local centerY = 0

    if is1x1 then
        effect_setScale(newEffect, sm_vec3_new(0, pixel_scale_y, pixel_scale_z))

        centerX = x - 1
        centerY = y - 1
    else
        effect_setScale(newEffect, sm_vec3_new(0, pixel_scale_y * scale_y, pixel_scale_z * scale_x))

        centerX = ((scale_x / 2) + x - 1) - 0.5
        centerY = ((scale_y / 2) + y - 1) - 0.5
    end

    local xPos, yPos = pixelPosToShapePos(centerX, centerY, self_cl_display.widthScale, self_cl_display.heightScale, pixel_scale)
    effect_setOffsetPosition(newEffect, sm_vec3_new(pixelDepth, yPos, xPos))
    effect_setParameter(newEffect, "color", color)

    local dataIndex = coordinateToIndex(x, y, data_width)
    self_cl_pixel.pixels[dataIndex] = newEffect
    self_cl_pixel.pixelData[dataIndex] = newEffectData

    local occupiedTbl = self_cl_pixel.occupied

    if scale_x ~= 1 or scale_y ~= 1 then
        local x1, y1 = x, y

        for _ = 1, scale_x * scale_y do
            local occupiedIndex = coordinateToIndex(x1, y1, data_width)
            occupiedTbl[occupiedIndex] = dataIndex

            x1 = x1 + 1

            if x1 > x + scale_x - 1 then
                y1 = y1 + 1
                x1 = x
            end
        end
    else
        occupiedTbl[dataIndex] = dataIndex
    end

    self:cl_startEffect(newEffect)
end

-- Splits a effect
---@param x number The 1st x-coordinates
---@param y number The 1st y-coordinates
---@param x1 number The 2nd x-coordinates
---@param y1 number The 2nd y-coordinates
---@param newScale Vec3 The new scale.
function DisplayClass:cl_splitEffect(x, y, x1, y1, sx, sy)
    local dataIndex = coordinateToIndex(x, y, self.data.width)
    local self_cl_pixel = self.cl.pixel
    local effect = self_cl_pixel.pixels[dataIndex]
    local effectData = self_cl_pixel.pixelData[dataIndex]
    local oldScale_x = effectData[1]
    local oldScale_y = effectData[2]
    local oldColor = effectData[3]

    self:cl_stopEffect(effect, effectData, dataIndex)

    local minX, maxX = x1 - x, (x + oldScale_x - 1) - (x1 + sx - 1)
    local minY, maxY = y1 - y, (y + oldScale_y - 1) - (y1 + sy - 1)

    local minDrawn = false
    local maxDrawn = false

    if minX > 0 then
        self:cl_createPixelEffect(x, y, minX, oldScale_y, oldColor)
        minDrawn = true
    end

    if maxX > 0 then
        local startPosX = x + oldScale_x - maxX
        self:cl_createPixelEffect(startPosX, y, maxX, oldScale_y, oldColor)

        maxDrawn = true
    end

    if minY > 0 then
        local startPosX = minDrawn and x + minX or x
        local scaleX = oldScale_x

        if minDrawn then scaleX = scaleX - minX end
        if maxDrawn then scaleX = scaleX - maxX end

        self:cl_createPixelEffect(startPosX, y, scaleX, minY, oldColor)
    end

    if maxY > 0 then
        local startPosX = minDrawn and x + minX or x

        local startPosY = y1 + sy
        local scaleX = oldScale_x

        if minDrawn then scaleX = scaleX - minX end
        if maxDrawn then scaleX = scaleX - maxX end

        self:cl_createPixelEffect(startPosX, startPosY, scaleX, maxY, oldColor)
    end
end

-- Optimise effects that are currently on the display, also does max optimisation, very expensive and weird
function DisplayClass:cl_optimizeDisplayEffects()
    local self_cl = self.cl
    local self_cl_pixel = self_cl.pixel
    local occupied = self_cl_pixel.occupied
    local pixelData = self_cl_pixel.pixelData

    local width, height = self.data.width, self.data.height

    local threshold = self_cl.display.threshold
    local processed = {}

    local function findMaxDimensions(x, y, color, originalScaleX, originalScaleY)
        local maxWidth, maxHeight = originalScaleX, originalScaleY

        for i = x + originalScaleX, width do
            local canExtendWidth = true
            for j = y, y + maxHeight - 1 do
                local occupiedIndex = occupied[coordinateToIndex(i, j, width)]

                if not (occupiedIndex and not processed[occupiedIndex] and areColorsSimilar(pixelData[occupiedIndex][3], color, threshold)) then
                    canExtendWidth = false
                    break
                end
            end

            if canExtendWidth then 
                maxWidth = maxWidth + 1
            else
                break
            end
        end

        for j = y + originalScaleY, height do
            local rowIsUniform = true
            for i = x, x + maxWidth - 1 do
                local occupiedIndex = occupied[coordinateToIndex(i, j, width)]

                if not (occupiedIndex and not processed[occupiedIndex] and areColorsSimilar(pixelData[occupiedIndex][3], color, threshold)) then
                    rowIsUniform = false
                    break
                end
            end

            if rowIsUniform then 
                maxHeight = maxHeight + 1
            else
                break
            end
        end

        return maxWidth, maxHeight
    end

    local function markBlockAsProcessed(x, y, maxWidth, maxHeight)
        local i, j = x, y

        for _ = 1, maxWidth * maxHeight do
            processed[coordinateToIndex(i, j, width)] = true

            i = i + 1

            if i > x + maxWidth - 1 then
                j = j + 1
                i = x
            end
        end
    end

    local x, y = 1, 1

    for _ = 1, width * height do
        local occupiedIndex = occupied[coordinateToIndex(x, y, width)]

        if occupiedIndex and not processed[occupiedIndex] then
            local selectedPixel = pixelData[occupiedIndex]

            local color = selectedPixel[3]
            local maxWidth, maxHeight = findMaxDimensions(x, y, color, selectedPixel[1], selectedPixel[2])

            self:cl_drawPixel({
                x,
                y,
                maxWidth, 
                maxHeight,
                color,
            })

            markBlockAsProcessed(x, y, maxWidth, maxHeight)
        end

        x = x + 1

        if x > width then
            y = y + 1
            x = 1
        end
    end
end

function DisplayClass:cl_drawLine(params)
    local self_data = self.data
    local width = self_data.width
    local height = self_data.height

    local x0, y0 = indexToCoordinate(params[1], width)
    local x1, y1 = indexToCoordinate(params[2], width)
    local color = params[3]
    color =  type(color) == "Color" and color or idToColor(color)

    local dx = math.abs(x1 - x0)
    local dy = math.abs(y1 - y0)
    local sx = (x0 < x1) and 1 or -1
    local sy = (y0 < y1) and 1 or -1
    local err = dx - dy

    local optimiseBuffer = self.cl.optimiseBuffer

    while true do
        if x0 > 0 and y0 > 0 and x0 <= width and y0 <= height then
            local index = coordinateToIndex(x0, y0, width)

            if self:cl_cacheCheck(index, color) then
                optimiseBuffer[index] = color
            end
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

function DisplayClass:cl_drawCircle(params)
    local width = self.data.width
    local height = self.data.height

    local x, y = indexToCoordinate(params[1], width)
    local radius = params[2]
    local color = idToColor(params[3])
    local isFilled = params[4]

    local f = 1 - radius
    local ddF_x = 1
    local ddF_y = -2 * radius
    local cx = 0
    local cy = radius

    local optimiseBuffer = self.cl.optimiseBuffer

    local function plot(xp, yp)
        local index = coordinateToIndex(xp, yp, width)

        if xp >= 1 and xp <= width and yp >= 1 and yp <= height and self:cl_cacheCheck(index, color) then
            optimiseBuffer[index] = color
        end
    end

    if isFilled then
        self:cl_scaledAdd({x - radius, y, radius * 2 + 1, 1, color})
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
            self:cl_scaledAdd({x - cx, y + cy, cx * 2 + 1, 1, color})
            self:cl_scaledAdd({x - cy, y + cx, cy * 2 + 1, 1, color})

            self:cl_scaledAdd({x - cx, y - cy, cx * 2 + 1, 1, color})
            self:cl_scaledAdd({x - cy, y - cx, cy * 2 + 1, 1, color})
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

function DisplayClass:cl_drawTriangle(params)
    local width = self.data.width
    local height = self.data.height
    local optimiseBuffer = self.cl.optimiseBuffer

    local x1, y1 = indexToCoordinate(params[1], width)
    local x2, y2 = indexToCoordinate(params[2], width)
    local x3, y3 = indexToCoordinate(params[3], width)
    local color = idToColor(params[4])
    local isFilled = params[5]

    self:cl_drawLine({coordinateToIndex(x1, y1, width), coordinateToIndex(x2, y2, width), color})
    self:cl_drawLine({coordinateToIndex(x2, y2, width), coordinateToIndex(x3, y3, width), color})
    self:cl_drawLine({coordinateToIndex(x3, y3, width), coordinateToIndex(x1, y1, width), color})

    if isFilled then
        local sortedPoints = {
            {x = x1, y = y1},
            {x = x2, y = y2},
            {x = x3, y = y3}
        }
        table_sort(sortedPoints, function(a, b) return a.y < b.y end)

        local x0, y0 = sortedPoints[1].x, sortedPoints[1].y
        local x1, y1 = sortedPoints[2].x, sortedPoints[2].y
        local x2, y2 = sortedPoints[3].x, sortedPoints[3].y

        local function interpolate(x0, y0, x1, y1, x)
            return x0 + (x - y0) * (x1 - x0) / (y1 - y0)
        end

        for y = y0, y2 do
            local xa = y < y1 and interpolate(x0, y0, x1, y1, y) or interpolate(x1, y1, x2, y2, y)
            local xb = y < y1 and interpolate(x0, y0, x2, y2, y) or interpolate(x0, y0, x2, y2, y)

            if xa > xb then xa, xb = xb, xa end

            for x = math_floor(xa + 0.5), math_floor(xb + 0.5) do
                if x >= 1 and x <= width and y >= 1 and y <= height then
                    local index = coordinateToIndex(x, y, width)

                    if self:cl_cacheCheck(index, color) then
                        optimiseBuffer[index] = color
                    end
                end
            end
        end
    end
end

function DisplayClass:cl_drawRect(params)
    local screenWidth = self.data.width
    local x, y = indexToCoordinate(params[1], screenWidth)
    local width, height = indexToCoordinate(params[2], screenWidth)
    local color = idToColor(params[3])
    local isFilled = params[4]

    if isFilled then
        self:cl_scaledAdd({x, y, width, height, color})
        return
    end

    self:cl_scaledAdd({x,             y, width,    1,             color})
    self:cl_scaledAdd({x + width - 1, y + 1,       1, height - 2, color})
    self:cl_scaledAdd({x,             y + 1,       1, height - 2, color})
    self:cl_scaledAdd({x,             y + height - 1, width, 1,   color})
end

function DisplayClass:cl_drawText(params)
    local data_width = self.data.width
    local params_x, params_y = indexToCoordinate(params[1], self.data.width)
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

    local width = params_maxWidth or data_width
    local optimiseBuffer = self.cl.optimiseBuffer

    -- Hacky way but it reduces the amount of code to write
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
                    if row:sub(xPosition, xPosition) == "#" then
                        local index = coordinateToIndex(params_x + xSpacing + (xPosition - 1), params_y + ySpacing + (yPosition - 1), width)

                        if self:cl_cacheCheck(index, params_color) then
                            optimiseBuffer[index] = params_color
                        end
                    end
                end

            end

            xSpacing = xSpacing + font.fontWidth
        end

        i = i + #char
    end
end

function DisplayClass:cl_clearDisplay(params)
    local self_cl = self.cl
    local self_cl_pixel = self_cl.pixel
    local self_cl_backPanel = self_cl.backPanel
    local pixelData = self_cl.pixel.pixelData

    for i, effect in pairs(self_cl_pixel.pixels) do
        self:cl_stopEffect(effect, pixelData[i], i)
    end

    self_cl_pixel.pixels = {}
    self_cl_pixel.pixelData = {}
    self_cl_pixel.occupied = {}

    local color = params[1] and idToColor(params[1])

    if color then
        effect_setParameter(self_cl_backPanel.effect, "color", color)
        self_cl_backPanel.currentColor = color
    end
end

function DisplayClass:cl_setDisplayHidden(params)
    local setHidden = params[1]

    if setHidden ~= self.cl.display.isHidden then
        self.cl.display.isHidden = setHidden

        for i, effect in pairs(self.cl.pixel.pixels) do
            if sm_exists(effect) then
                if setHidden then
                    effect_stop(effect)
                else
                    effect_start(effect)
                end
            end
        end
    end
end

function DisplayClass:cl_startEffect(effect)
    local self_cl = self.cl
    local effectId = effect.id
    self_cl.stopBuffer[effectId] = nil

    if not effect_isPlaying(effect) then
        self_cl.startBuffer[effectId] = effect
    end
end

function DisplayClass:cl_stopEffect(effect, effectData, dataIndex, temporary)
    local self_cl = self.cl
    local self_cl_pixel = self_cl.pixel
    local effectId = effect.id
    self_cl.startBuffer[effectId] = nil

    if effect_isPlaying(effect) then
        self_cl.stopBuffer[effectId] = effect
    end
    
    if not temporary then
        if self_cl.stoppedIndex < 65537 then
            self_cl.stoppedIndex = self_cl.stoppedIndex + 1
            self_cl_pixel.stoppedEffects[effectId] = effect
        else
            effect_destroy(effect)
        end

        local occupiedTbl = self_cl_pixel.occupied
        local width = self.data.width

        if effectData then
            local effectData_x, effectData_y = indexToCoordinate(dataIndex, width)
            local xScale, yScale = effectData[1], effectData[2]

            if xScale ~= 1 or yScale ~= 1 then
                local x1, y1 = effectData_x, effectData_y

                for _ = 1, xScale * yScale do
                    local occupiedIndex = coordinateToIndex(x1, y1, width)

                    occupiedTbl[occupiedIndex] = nil

                    x1 = x1 + 1

                    if x1 > effectData_x + xScale - 1 then
                        y1 = y1 + 1
                        x1 = effectData_x
                    end
                end
            else
                occupiedTbl[dataIndex] = nil
            end

            self_cl_pixel.pixels[dataIndex] = nil
            self_cl_pixel.pixelData[dataIndex] = nil
        end
    end
    
end

sm.scrapcomputers.componentManager.toComponent(DisplayClass, "Displays", true)