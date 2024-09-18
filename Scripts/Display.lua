-- Ben has sacraficed his fucking soul making display's. VeraDev died commenting the entire display.
-- Not only did VeraDev die, When this commit was pushed (for documentation), The 2 best sentences of
-- the description were: "THIS IS ABSOLUTE DOG SHIT AND I DONT WANT TO EVER TOUCH THEM AGAIN. THIS BITCH CAN SUCK MY ASS!"

-- If you ever make your own display's. You will actually kill yourself. We are NOT joking.

---@class DisplayClass : ShapeClass
DisplayClass = class()
DisplayClass.maxParentCount = 1
DisplayClass.maxChildCount = 0
DisplayClass.connectionInput = sm.interactable.connectionType.compositeIO
DisplayClass.connectionOutput = sm.interactable.connectionType.none
DisplayClass.colorNormal = sm.color.new(0x696969ff)
DisplayClass.colorHighlight = sm.color.new(0x969696ff)

-- CLIENT/SERVER --

local localPlayer = sm.localPlayer
local camera = sm.camera

local PIXEL_UUID = sm.uuid.new("cd943f04-96c7-43f0-852c-b2d68c7fc157")
local BACKPANEL_EFFECT_NAME = "ScrapComputers - ShapeRenderableBackPanel"
local width, height = sm.gui.getScreenSize()
local byteLimit = 65000
local displayHidingCooldown = 0.1

local bufferInstructions = {
    ["DRAW_PIXEL"] = "cl_addToTable",
    ["DRAW_LINE"] = "cl_drawLine",
    ["DRAW_TEXT"] = "cl_drawText",
    ["DRAW_CIRCLE"] = "cl_drawCircle",
    ["DRAW_TRIANGLE"] = "cl_drawTriangle",
    ["DRAW_RECT"] = "cl_drawRect",

    ["OPTIMIZE"] = "cl_optimizeDisplayEffects",
    ["CLEAR_DISPLAY"] = "cl_clearDisplay"
}

local networkInstructions = {
    ["DIS_VIS"] = "cl_setDisplayHidden",
    ["SET_REND"] = "cl_setRenderDistance",
    ["SET_THRESHOLD"] = "cl_setThreshold",
    ["TOUCH_STATE"] = "cl_setTouchAllowed"
}

function pixelPosToShapePos(x, y, widthScale, heightScale, pixelScale)
    local xPos = -(widthScale / 2) + (pixelScale.z / 200) +(x * pixelScale.z / 100) + 0.02
    local yPos = -(heightScale / 2) + (pixelScale.y / 200) +(y * pixelScale.y / 100) + 0.02

    return xPos, yPos
end

function shapePosToPixelPos(point, widthScale, heightScale, pixelScale)
    local x = (100 / pixelScale.z) * (point.z - 0.02 + (widthScale / 2) - (pixelScale.z / 200)) + 1
    local y = (100 / pixelScale.y) * (point.y - 0.02 + (heightScale / 2) - (pixelScale.y / 200)) + 1

    return x, y
end

function round(numb)
    return math.floor(numb + 0.5)
end

-- Returns true if the 2 colors are similar given via a threshold
---@param color Color The first color
---@param color1 Color The seccond color
---@param threshold number (Optional) The threshold of how accruate it should be. By default its 0 aka exactly same color.
---@return boolean colorSame If this is true. then the 2 colors are similar from the threshold.
function areColorsSimilar(color, color1, threshold)
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

    return math.sqrt(dr^2 + dg^2 + db^2)
end

-- Gets the UTF8 char from a string as string.sub messes up special characters
---@param str string The string
---@param index number The UTF8 character to select
---@return string UTF8Character The UTF8 character returned.
function getUTF8Character(str, index)
    local byte = string.byte(str, index)
    local byteCount = 1

    if byte >= 0xC0 and byte <= 0xDF then
        byteCount = 2
    elseif byte >= 0xE0 and byte <= 0xEF then
        byteCount = 3
    elseif byte >= 0xF0 and byte <= 0xF7 then
        byteCount = 4
    end

    return string.sub(str, index, index + byteCount - 1)
end

-- Converts 2D coordinates (x, y) to a 1D array index
function coordinateToIndex(x, y, width)
    return (y - 1) * width + x
end

-- Converts a 1D array index to 2D coordinates (x, y)
function indexToCoordinate(index, width)
    local x = (index - 1) % width + 1
    local y = math.floor((index - 1) / width) + 1
    return x, y
end

local function getFirst(tbl)
    for i, v in pairs(tbl) do
        return v, i
    end
end

-- The torture. Someone please give us a soul. Espessally Ben Bingo, He wrote the entire display. PLEASE GIVE US SOME FUCKING WATER, WE HAVENT DRANK WATER SINCE DAY 1.
-- SOME ONE PLEASE FUCKING HELP US. WE DONT WANNA DIE. PLEASE PLEASE AAAAAAAAAAAAAAAA
--
-- Anyways, This optimizes the stack of pixels ready to get drawn, reduces the instructiuon count massivley
---@param indexedStack table The instruction Set
---@param width number The width of the display
---@param height number The height of the display
---@param threshold number The optimization threshold
---@return table TooMuchOptimizedInstructionSet The reduced instruction set afther it was slaughtered.
function optimizeDisplayPixelStack(indexedStack, width, height, threshold)
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

    local keys = {}
    for index in pairs(indexedStack) do
        table.insert(keys, index)
    end

    table.sort(keys, function(a, b)
        local x1, y1 = indexToCoordinate(a, width)
        local x2, y2 = indexToCoordinate(b, width)
        if y1 == y2 then
            return x1 < x2
        else
            return y1 < y2
        end
    end)

    local cahcedIndex = #optimizedStack

    for _, index in ipairs(keys) do
        if not processed[index] then
            local x, y = indexToCoordinate(index, width)
            local pixelIndex = indexedStack[index]

            cahcedIndex = cahcedIndex + 1

            if not scale then
                local maxWidth, maxHeight = findMaxDimensions(x, y, pixelIndex)

                optimizedStack[cahcedIndex] = {
                    x = x,
                    y = y,
                    color = pixelIndex,
                    scale = {x = maxWidth, y = maxHeight}
                }

                -- Mark the merged pixels as processed
                markBlockAsProcessed(x, y, maxWidth, maxHeight)
            else
                optimizedStack[cahcedIndex] = {
                    x = x,
                    y = y,
                    color = pixelIndex,
                    scale = {x = scale.x, y = scale.y}
                }
            end
        end
    end

    return optimizedStack
end

-- SERVER --

-- Creates all functions for the display
function DisplayClass:sv_createData()
    -- Draw Circle function
    ---@param x number The center X coordinates
    ---@param y number The center Y coordinates
    ---@param radius number The radius of the circle
    ---@param color Color The color of the circle
    ---@param isFilled boolean If true, the circle is filled. else not.
    local function drawCricle(x, y, radius, color, isFilled)
        sm.scrapcomputers.errorHandler.assertArgument(x, 1, {"number"})
        sm.scrapcomputers.errorHandler.assertArgument(y, 2, {"number"})
        sm.scrapcomputers.errorHandler.assertArgument(radius, 3, {"number"})
        sm.scrapcomputers.errorHandler.assertArgument(color, 4, {"Color", "string"})

        sm.scrapcomputers.errorHandler.assert(radius, 3, "Radius is too small!")

        self.sv.buffer[#self.sv.buffer + 1] = {
            "DRAW_CIRCLE",
            {
                x = round(x),
                y = round(y),

                radius = round(radius),

                color = type(color) == "Color" and color or sm.color.new(color),

                isFilled = isFilled
            }
        }
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
        sm.scrapcomputers.errorHandler.assertArgument(x1, 1, {"number"})
        sm.scrapcomputers.errorHandler.assertArgument(y1, 2, {"number"})
        sm.scrapcomputers.errorHandler.assertArgument(x2, 3, {"number"})
        sm.scrapcomputers.errorHandler.assertArgument(y2, 4, {"number"})
        sm.scrapcomputers.errorHandler.assertArgument(x3, 5, {"number"})
        sm.scrapcomputers.errorHandler.assertArgument(y3, 6, {"number"})

        sm.scrapcomputers.errorHandler.assertArgument(color, 7, {"Color", "string"})

        self.sv.buffer[#self.sv.buffer + 1] = {
            "DRAW_TRIANGLE", -- The type
            {
                x1 = round(x1),
                y1 = round(y1),

                x2 = round(x2),
                y2 = round(y2),

                x3 = round(x3),
                y3 = round(y3),

                color = type(color) == "Color" and color or sm.color.new(color),

                isFilled = isFilled
            }
        }
    end

    ---Draw Rectangle Function
    ---@param x number The x-coordinate
    ---@param y number The y-coordinate
    ---@param width number The width of the rectangle
    ---@param height number The height of the triangle
    ---@param color Color|string The color of the rectangle
    ---@param isFilled boolean If true, The rectangle is filled. else it will just draw 4 fucking lines.
    local function drawRect(x, y, width, height, color, isFilled)
        sm.scrapcomputers.errorHandler.assertArgument(x, 1, {"number"})
        sm.scrapcomputers.errorHandler.assertArgument(y, 2, {"number"})

        sm.scrapcomputers.errorHandler.assertArgument(width, 3, {"number"})
        sm.scrapcomputers.errorHandler.assertArgument(height, 4, {"number"})

        sm.scrapcomputers.errorHandler.assertArgument(color, 4, {"Color", "string"})

        self.sv.buffer[#self.sv.buffer + 1] = {
            "DRAW_RECT",
            {
                x = round(x),
                y = round(y),

                width = round(width),
                height = round(height),

                color = type(color) == "Color" and color or sm.color.new(color),

                isFilled = isFilled
            }
        }
    end

    return {
        ---Draws a pixel
        ---@param x number
        ---@param y number
        ---@param color Color
        drawPixel = function (x, y, color)
            sm.scrapcomputers.errorHandler.assertArgument(x, 1, {"number"})
            sm.scrapcomputers.errorHandler.assertArgument(y, 2, {"number"})

            if x < 1 or x > self.data.width or y < 1 or y > self.data.height then return end

            sm.scrapcomputers.errorHandler.assertArgument(color, 3, {"Color", "string"})

            self.sv.buffer[#self.sv.buffer + 1] = {
                "DRAW_PIXEL",
                {
                    x = round(x),
                    y = round(y),
                    scale = {x = 1, y = 1},
                    color = type(color) == "Color" and color or sm.color.new(color)
                }
            }
        end,

        ---Draws pixels from a table
        ---@param tbl PixelTable The table of pixels
        drawFromTable = function (tbl)
            sm.scrapcomputers.errorHandler.assertArgument(tbl, nil, {"table"}, {"PixelTable"})

            for i, pixel in pairs(tbl) do
                sm.scrapcomputers.errorHandler.assert(pixel.x and pixel.y and pixel.scale and pixel.color, "missing data at index "..i..".")

                sm.scrapcomputers.errorHandler.assert(type(pixel.x) == "number", nil, "bad x value at index "..i..". Expected number. Got "..type(pixel.x).." instead!")
                sm.scrapcomputers.errorHandler.assert(type(pixel.y) == "number", nil, "bad y value at index "..i..". Expected number. Got "..type(pixel.y).." instead!")

                sm.scrapcomputers.errorHandler.assert((type(pixel.color) == "Color" or type(pixel.color) == "string"), nil, "bad color at index "..i..". Expected Color or string. Got "..type(pixel.color).." instead!")
            end

            self.sv.buffer[#self.sv.buffer + 1] = {"DRAW_TABLE", tbl}
        end,

        -- Clear the display
        ---@param color MultiColorType The new background color or 000000
        clear = function (color)
            sm.scrapcomputers.errorHandler.assertArgument(color, nil, {"Color", "string", "nil"})

            if sm.scrapcomputers.backend.cameraColorCache then
                sm.scrapcomputers.backend.cameraColorCache[self.shape.id] = nil
            end

            self.sv.buffer = {}

            local clearColor = type(color) == "Color" and color or sm.color.new(color or "000000")

            self.sv.buffer[#self.sv.buffer + 1] = {
                "CLEAR_DISPLAY",
                {
                    clearColor
                }
            }

            self.sv.backPannel = clearColor
        end,

        -- Draws a line
        ---@param x number  -- The 1st point on x-axis
        ---@param y number  -- The 1st point on y-axis
        ---@param x1 number -- The 2nd point on x-axis
        ---@param y1 number -- The 2nd point on y-axis
        ---@param color MultiColorType The line's color
        drawLine = function (x, y, x1, y1, color)
            sm.scrapcomputers.errorHandler.assertArgument(x, 1, {"number"})
            sm.scrapcomputers.errorHandler.assertArgument(y, 2, {"number"})

            sm.scrapcomputers.errorHandler.assertArgument(x1, 3, {"number"})
            sm.scrapcomputers.errorHandler.assertArgument(y1, 4, {"number"})

            sm.scrapcomputers.errorHandler.assertArgument(color, 5, {"Color", "string"})

            self.sv.buffer[#self.sv.buffer + 1] = {
                "DRAW_LINE",
                {
                    x = round(x),
                    y = round(y),
                    x1 = round(x1),
                    y1 = round(y1),

                    color = type(color) == "Color" and color or sm.color.new(color)
                }
            }
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
        drawText = function (x, y, text, color, fontName)
            sm.scrapcomputers.errorHandler.assertArgument(x, 1, {"number"})
            sm.scrapcomputers.errorHandler.assertArgument(y, 2, {"number"})

            sm.scrapcomputers.errorHandler.assertArgument(text, 3, {"string"})
            sm.scrapcomputers.errorHandler.assertArgument(color, 4, {"Color", "string", "nil"})
            
            sm.scrapcomputers.errorHandler.assertArgument(fontName, 5, {"string", "nil"})
            
            fontName = fontName or sm.scrapcomputers.fontManager.getDefaultFontName()

            local font, errMsg = sm.scrapcomputers.fontManager.getFont(fontName)
            sm.scrapcomputers.errorHandler.assert(font, 5, errMsg)

            color = color or "FFFFFF"

            self.sv.buffer[#self.sv.buffer + 1] = {
                "DRAW_TEXT",
                {
                    x = round(x),
                    y = round(y),

                    string = text,

                    color = type(color) == "Color" and color or sm.color.new(color),

                    font = fontName
                }
            }
        end,

        -- Returns the dimensions of the display
        ---@return number width The width of the display
        ---@return number height height height of the display
        getDimensions = function ()
            return self.data.width, self.data.height
        end,

        -- Hides the display, Makes all players unable to see it.
        hide = function ()
            self.sv.networkBuffer[#self.sv.networkBuffer + 1] = {"DIS_VIS", {true}}
        end,

        -- Shows the display. All players will be able to see it
        show = function ()
            self.sv.networkBuffer[#self.sv.networkBuffer + 1] = {"DIS_VIS", {false}}
        end,

        -- Set the render distance for the display. If you go out of this range, the display will hide itself automaticly, else it will show itself.
        ---@param distance number The new render distance to set
        setRenderDistance = function (distance)
            sm.scrapcomputers.errorHandler.assertArgument(distance, nil, {"number"})

            self.sv.networkBuffer[#self.sv.networkBuffer + 1] = {"SET_REND", {distance}}
        end,

        -- Enables/Disables touchscreen. Makes getTouchData usable
        ---@param bool boolean If true, Touchscreen mode is enabled and the end-user can interact with it.
        enableTouchScreen = function(bool)
            sm.scrapcomputers.errorHandler.assertArgument(bool, nil, {"boolean"})

            self.sv.networkBuffer[#self.sv.networkBuffer+1] = {"TOUCH_STATE", {bool}}
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
            sm.scrapcomputers.errorHandler.assertArgument(bool, nil, {"boolean"})

            self.sv.autoUpdate = bool
        end,

        -- Optimizes the display to the extreme. Will be costy during the optimization but will be a massive performance increase after it.
        optimize = function ()
            self.sv.buffer[#self.sv.buffer+1] = {"OPTIMIZE", {}}
        end,

        -- Sets the optimization threshold. The lower, the less optimization it does but with better quality, the higher, the better optimization it does but with worser quality.
        -- You must set this value in decimals, Default optimization threshold when placing it is 0.05
        ---@param int number The new threshold
        setOptimizationThreshold = function (int)
            sm.scrapcomputers.errorHandler.assertArgument(int, nil, {"number"})

            self.sv.networkBuffer[#self.sv.networkBuffer + 1] = {"SET_THRESHOLD", {int}}
            self.sv.display.threshold = int
        end,

        ---Sets the max buffer size
        ---@param buffer integer The max buffer size
        setMaxBuffer = function (buffer)
            sm.scrapcomputers.errorHandler.assertArgument(buffer, nil, {"integer"})
            sm.scrapcomputers.errorHandler.assert(buffer > 0, nil, "bad argument #1. Buffer must be positive")

            self.sv.maxBuffer = buffer
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
        ---@return number width The width of the text that it will use
        ---@return number height The height of the text that it will use
        calcTextSize = function (text, font)
            sm.scrapcomputers.errorHandler.assertArgument(text, 1, {"string"})
            sm.scrapcomputers.errorHandler.assertArgument(font, 2, {"string", "nil"})

            font = font or sm.scrapcomputers.fontManager.getDefaultFontName()

            local trueFont, err = sm.scrapcomputers.fontManager.getFont(font)
            if not trueFont then
                error("Failed getting font! Error message: " .. err)
            end

            local usedWidth = sm.util.clamp(#text * trueFont.fontWidth, 0, self.data.width)
            local usedHeight = (1 + math.floor((#text * trueFont.fontWidth) / self.data.width)) * trueFont.fontHeight

            return usedWidth, usedHeight
        end,
}
end

function DisplayClass:server_onFixedUpdate()
    if #self.sv.networkBuffer > 0 then
        for _, data in pairs(self.sv.networkBuffer) do
            local instruction, params = unpack(data)
            local dest = networkInstructions[instruction]

            self.network:sendToClients(dest, params)

            if instruction == "DIS_VIS" then
                self.network:sendToClients("cl_setUserHidden", params[1])
            end
        end

        if sm.scrapcomputers.backend.cameraColorCache then
            sm.scrapcomputers.backend.cameraColorCache[self.shape.id] = false
        end

        self.sv.networkBuffer = {}
    end

    if (self.sv.allowUpdate or self.sv.autoUpdate) and #self.sv.buffer > 0 then
        local broke = false
        local processedCount = 0

        local shape_id = self.shape.id
        local maxBuffer = self.sv.maxBuffer
        local width, height = self.data.width, self.data.height
        local threshold = self.sv.display.threshold
        local sm_color_new = sm.color.new
        local sm_json_writeJsonString = sm.json.writeJsonString
        local scrap_splitString = sm.scrapcomputers.string.splitString
        local self_network = self.network

        for i, data in pairs(self.sv.buffer) do
            if processedCount < maxBuffer or maxBuffer == 0 then
                local instruction, params = data[1], data[2]

                if instruction == "DRAW_TABLE" then
                    local drawBuffer = {}
                    local extras = {}

                    local cachedExtras = 0

                    for _, pixel in pairs(params) do
                        local pixel_x = pixel.x
                        local pixel_y = pixel.y
                        local pixel_color = pixel.color
                        local pixel_scale = pixel.scale
                        local pixel_scale_x = pixel_scale.x
                        local pixel_scale_y = pixel_scale.y

                        if pixel_scale_x == 1 and pixel_scale_y == 1 then
                            local color = type(pixel_color) == "string" and sm_color_new(pixel_color) or pixel_color

                            drawBuffer[coordinateToIndex(pixel_x, pixel_y, width)] = color
                        else
                            cachedExtras = cachedExtras + 1
                            extras[cachedExtras] = pixel
                        end
                    end

                    local optimisedBuffer = optimizeDisplayPixelStack(drawBuffer, width, height, threshold)
                    local cachedOptimise = #optimisedBuffer

                    for _, extra in pairs(extras) do
                        cachedOptimise = cachedOptimise + 1
                        optimisedBuffer[cachedOptimise] = extra
                    end

                    if cachedOptimise > 500 then
                        for _, pixel in pairs(optimisedBuffer) do
                            pixel.color = tostring(pixel.color)
                        end

                        local jsonStr = sm_json_writeJsonString(optimisedBuffer)
                        local strings = scrap_splitString(jsonStr, byteLimit)

                        local cachedStrings = #strings

                        for i, string in pairs(strings) do
                            local finished = i == cachedStrings
                            self_network:sendToClients("cl_rebuildParams", {string = string, finished = finished, i = i})
                        end
                    else
                        self_network:sendToClients("cl_drawTable", optimisedBuffer)
                    end
                else
                    if sm.scrapcomputers.backend.cameraColorCache and instruction ~= "OPTIMIZE" then
                        sm.scrapcomputers.backend.cameraColorCache[shape_id] = false
                    end

                    local dest = bufferInstructions[instruction]
                    self_network:sendToClients(dest, params)
                end

                self.sv.buffer[i] = nil
                processedCount = processedCount + 1
            else
                broke = true
                break
            end
        end

        self.network:sendToClients("cl_pushPixels")

        if not broke then
            self.sv.allowUpdate = false
        end
    end

    if self.sv.needSync and self.sv.synced and self.sv.pixel.pixelData then
        self.sv.synced = false

        for _, pixel in pairs(self.sv.pixel.pixelData) do
            pixel.color = sm.color.new(pixel.color)

            self.network:sendToClient(self.sv.needSync, "cl_drawPixel", pixel)
        end

        self.network:sendToClient(self.sv.needSync, "cl_syncDisplay", {color = self.sv.pixel.backPannel, touch = self.sv.display.touchAllowed})
        self.network:sendToClient(self.sv.needSync, "cl_pushPixels")

        self.sv.pixel.pixelData = {}
        self.sv.needSync = nil
    end
end

function DisplayClass:server_onCreate()
    self.sv = {
        display = {
            threshold = 0.01
        },
        pixel = {
            pixelData = {},
            backPannel = sm.color.new("000000")
        },
        buffer = {},
        networkBuffer = {},
        maxBuffer = 0
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
            stoppedEffectData = {},
            selectionIndex = 0,

            pixelScale = sm.vec3.zero()
        },

        backPannel = {
            effect = sm.effect.createEffect(BACKPANEL_EFFECT_NAME, self.interactable),
            defaultColor = sm.color.new("000000"),
            currentColor = sm.color.new("000000")
        },

        display = {
            renderDistance = 10,
            visTimer = 0,
            threshold = 0.01
        },

        startBuffer = {},
        stopBuffer = {},
        tblParams = {},
        optimiseBuffer = {}
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
    local bgScale = sm.vec3.new(0, (self.cl.display.heightScale - offset) * 100, (self.cl.display.widthScale - offset) * 100)

    self.cl.pixel.pixelScale = sm.vec3.new(0, bgScale.y / height, bgScale.z / width)

    self.cl.backPannel.effect:setParameter("uuid", PIXEL_UUID)
    self.cl.backPannel.effect:setParameter("color", self.cl.backPannel.defaultColor)

    self.cl.backPannel.effect:setOffsetPosition(sm.vec3.new(0.115, 0, 0))
    self.cl.backPannel.effect:setScale(bgScale)

    self.cl.backPannel.effect:start()

    if not sm.isHost then
        self.network:sendToServer("sv_syncDisplay")
    end
end

function DisplayClass:cl_syncDisplay(data)
    self.cl.backPannel.effect:setParameter("color", data.color)
    self.cl.display.touchAllowed = data.touch
end

function DisplayClass:client_onDestroy()
    if sm.scrapcomputers.backend.cameraColorCache then
        sm.scrapcomputers.backend.cameraColorCache[self.shape.id] = nil
    end
end

function DisplayClass:client_onFixedUpdate()
    local clock = os.clock()
    local pos = camera.getPosition()
    local dir = camera.getDirection()
    local character = localPlayer.getPlayer().character

    if self.cl.display.visTimer + displayHidingCooldown <= clock and character then
        self.cl.display.visTimer = clock

        local worldPosition = self.shape.worldPosition
        local shouldHide = false

        if (worldPosition - character.worldPosition):length() > self.cl.display.renderDistance then
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

            local dirDot = dir:dot((worldPosition - pos):normalize())

            if dirDot > 0 then
                for i, bound in pairs(boundry) do
                    local x, y = sm.render.getScreenCoordinatesFromWorldPosition(bound, width, height)

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
            local endPos = startPos + diff:normalize() * diff:length()

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
            self.cl.lastLen = len

            local sendTbl = {}

            for i, data in pairs(self.cl.pixel.pixelData) do
                data.color = tostring(data.color)

                table.insert(sendTbl, data)
            end

            local json = sm.json.writeJsonString(sendTbl)
            local strings = sm.scrapcomputers.string.splitString(json, byteLimit)

            for i, string in pairs(strings) do
                self.network:sendToServer("sv_syncData", {string = string, i = i, finished = i == #strings})
            end
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
        local roundedNorm = sm.vec3.new(round(res.normalLocal.x), round(res.normalLocal.y), round(res.normalLocal.z))
        self.cl.display.raycastValid = self.shape:getXAxis() == roundedNorm

        if self.cl.display.raycastValid then
            if isTinker then
                sm.gui.setInteractionText("", "Press "..sm.gui.getKeyBinding("Tinker", true).." for touch screen", "")
                sm.gui.setInteractionText("")
            else
                sm.gui.setInteractionText("", "Press "..sm.gui.getKeyBinding("Use", true).." for touch screen", "")
                sm.gui.setInteractionText("")
            end
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
    local pixels = self.cl.pixel.pixels
    local pixelData = self.cl.pixel.pixelData
    local occupiedTbl = self.cl.pixel.occupied

    local params_x = params.x
    local params_y = params.y
    local params_color = type(params.color) == "Color" and params.color or sm.color.new(params.color)
    local params_scale = params.scale
    local params_scale_x = params_scale.x
    local params_scale_y = params_scale.y

    local data_width = self.data.width
    local data_height = self.data.height
    local backpannel_color = self.cl.backPannel.currentColor

    if params_x > data_width or params_y > data_height or params_x + params_scale_x - 1 < 1 or params_y + params_scale_y - 1 < 1 then return end

    if params_x < 1 then
        params_scale_x = params_scale_x + params_x - 1
        params_scale.x = params_scale_x
        params_x = 1
    end

    if params_x + params_scale_x - 1 > data_width then
        params_scale_x = data_width - params_x + 1
        params_scale.x = params_scale_x
    end

    if params_y < 1 then
        params_scale_y = params_scale_y + params_y - 1
        params_scale.y = params_scale_y
        params_y = 1
    end

    if params_y + params_scale_y - 1 > data_height then
        params_scale_y = data_height - params_y + 1
        params_scale.y = params_scale_y
    end

    local dataIndex = coordinateToIndex(params_x, params_y, data_width)
    local occupied = occupiedTbl[dataIndex]
    local effect = pixels[occupied]
    local effectData = pixelData[occupied]

    if params_scale_x == 1 and params_scale_y == 1 then
        if not sm.exists(effect) then
            if params_color ~= backpannel_color then
                self:cl_createPixelEffect(params_x, params_y, params_scale, params_color)
            end
            return
        end

        local effectData_x = effectData.x
        local effectData_y = effectData.y
        local effectData_color = effectData.color
        local effectData_scale = effectData.scale
        local effectData_scale_x = effectData_scale.x
        local effectData_scale_y = effectData_scale.y

        if (effectData_scale_x ~= 1 or effectData_scale_y ~= 1) and params_color ~= effectData_color then
            self:cl_splitEffect(effectData_x, effectData_y, params_x, params_y, params_scale)
            if params_color ~= backpannel_color then
                self:cl_createPixelEffect(params_x, params_y, params_scale, params_color)
            end
            return
        end

        if params_color ~= effectData_color then
            effect:setParameter("color", params_color)
            pixelData[occupied].color = params_color
        end

        if params_color ~= backpannel_color then
            self:cl_startEffect(effect)
        else
            self:cl_stopEffect(effect, effectData)
        end

        return
    end

    local set = false
    if effectData then
        local effectData_x = effectData.x
        local effectData_y = effectData.y
        local effectData_color = effectData.color
        local effectData_scale = effectData.scale
        local effectData_scale_x = effectData_scale.x
        local effectData_scale_y = effectData_scale.y

        if effectData_scale_x == params_scale_x and effectData.scale.y == params_scale_y and effectData_x == params_x and effectData_y == params_y then
            if params_color ~= effectData_color then
                effect:setParameter("color", params_color)

                pixelData[occupied].color = params_color
            end

            if params_color ~= backpannel_color then
                self:cl_startEffect(effect)
            else
                self:cl_stopEffect(effect, effectData)
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
                    local effectData_x = effectData.x
                    local effectData_y = effectData.y
                    local effectData_scale = effectData.scale
                    local effectData_scale_x = effectData_scale.x
                    local effectData_scale_y = effectData_scale.y

                    if effectData_scale_x ~= 1 or effectData_scale_y ~= 1 then

                        local existingMinX, existingMaxX = effectData_x, effectData_x + effectData_scale_x - 1
                        local existingMinY, existingMaxY = effectData_y, effectData_y + effectData_scale_y - 1

                        local drawingMinX, drawingMaxX = params_x, params_x + params_scale_x - 1
                        local drawingMinY, drawingMaxY = params_y, params_y + params_scale_y - 1

                        if existingMinX < drawingMinX or existingMinY < drawingMinY or existingMaxX > drawingMaxX or existingMaxY > drawingMaxY then
                            self:cl_splitEffect(effectData_x, effectData_y, params_x, params_y, params_scale)

                            split = true
                        end
                    end
                end

                if not split then
                    self:cl_stopEffect(pixels[occupiedIndex], effectData)
                end
            end

            x1 = x1 + 1

            if x1 > params_x + params_scale_x - 1 then
                y1 = y1 + 1
                x1 = params_x
            end
        end

        if params_color ~= backpannel_color then
            self:cl_createPixelEffect(params_x, params_y, params_scale, params_color)
        end
    end
end

function DisplayClass:cl_scaledAdd(params)
    local x, y = params.x, params.y

    for i = 1, params.scale.x * params.scale.y do
        local index = coordinateToIndex(x, y, self.data.width)

        self.cl.optimiseBuffer[index] = nil

        x = x + 1

        if x > params.x + params.scale.x - 1 then
            y = y + 1
            x = params.x
        end
    end

    self:cl_drawPixel(params)
end

function DisplayClass:cl_addToTable(params)
    self.cl.optimiseBuffer[coordinateToIndex(params.x, params.y, self.data.width)] = params.color
end

function DisplayClass:cl_pushPixels()
    local optimisedBuffer = optimizeDisplayPixelStack(self.cl.optimiseBuffer, self.data.width, self.data.height, self.cl.display.threshold)

    for i, pixel in pairs(optimisedBuffer) do
        self:cl_drawPixel(pixel)
    end

    self.cl.optimiseBuffer = {}

    if not self.cl.display.isHidden then
        for i, effect in pairs(self.cl.startBuffer) do
            if sm.exists(effect) then
                self:cl_forceStart(effect)
            else
                self.cl.startBuffer[i] = nil
            end
        end
    end

    for _, effect in pairs(self.cl.stopBuffer) do
        self:cl_forceStop(effect)
    end

    self.cl.startBuffer = {}
    self.cl.stopBuffer = {}
end

function DisplayClass:cl_cacheCheck(index, color)
    local occupied = self.cl.pixel.occupied[index]

    if not occupied or not areColorsSimilar(self.cl.pixel.pixelData[occupied].color, color, self.cl.display.threshold) then
        return true
    end

    return false
end

-- Other end of split string, only used for DRAW_TABLE as it has the ability to be larger than the network packet size limit
---@param data table The data
function DisplayClass:cl_rebuildParams(data)
    self.cl.tblParams = data.i == 1 and data.string or self.cl.tblParams .. data.string

    if data.finished then 
        local params = sm.json.parseJsonString(self.cl.tblParams)
        self:cl_drawTable(params)

        self.cl.tblParams = {}
    end
end

-- Function that gets called to draw pixels based on a table
---@param tbl table The pixel table to be drawn.
function DisplayClass:cl_drawTable(tbl)
    for _, pixel in pairs(tbl) do
        pixel.color = type(pixel.color) == "string" and sm.color.new(pixel.color) or pixel.color

        self:cl_drawPixel(pixel)
    end
end

-- Creates a pixel effect
---@param x number The x-coordinate of the pixel
---@param y number The y-coordinate of the pixel
---@param scale {x : number, y : number} The scale of the pixe;
---@param color Color The color of it
function DisplayClass:cl_createPixelEffect(x, y, scale, color)
    local data_width = self.data.width

    local pixel_scale = self.cl.pixel.pixelScale
    local pixel_scale_y = pixel_scale.y
    local pixel_scale_z = pixel_scale.z

    local scale_x = scale.x
    local scale_y = scale.y

    local newEffectData = {
        x = x,
        y = y,

        scale = {
            x = scale_x,
            y = scale_y
        },

        color = color,
    }

    -- Create the effect
    local newEffect
    local cachedEffect, _ = getFirst(self.cl.pixel.stoppedEffects)

    if cachedEffect then
        newEffect = cachedEffect
    else
        newEffect = sm.effect.createEffect(self:cl_selectShapeRenderable(), self.interactable)
        newEffect:setParameter("uuid", PIXEL_UUID)
    end

    local is1x1 = scale_x == 1 and scale_y == 1

    local centerX = 0
    local centerY = 0

    if is1x1 then
        newEffect:setScale(sm.vec3.new(0, pixel_scale_y, pixel_scale_z))

        centerX = x - 1
        centerY = y - 1
    else
        newEffect:setScale(sm.vec3.new(0, pixel_scale_y * scale_y, pixel_scale_z * scale_x))

        centerX = ((scale_x / 2) + x - 1) - 0.5
        centerY = ((scale_y / 2) + y - 1) - 0.5
    end

    local xPos, yPos = pixelPosToShapePos(centerX, centerY, self.cl.display.widthScale, self.cl.display.heightScale, pixel_scale)
    newEffect:setOffsetPosition(sm.vec3.new(0.116, yPos, xPos))
    newEffect:setParameter("color", color)

    local dataIndex = coordinateToIndex(x, y, data_width)
    self.cl.pixel.pixels[dataIndex] = newEffect
    self.cl.pixel.pixelData[dataIndex] = newEffectData

    self.cl.pixel.stoppedEffects[newEffect.id] = nil
    self.cl.pixel.stoppedEffectData[newEffect.id] = nil

    local occupiedTbl = self.cl.pixel.occupied

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
function DisplayClass:cl_splitEffect(x, y, x1, y1, newScale)
    local dataIndex = coordinateToIndex(x, y, self.data.width)

    local effect = self.cl.pixel.pixels[dataIndex]
    local effectData = self.cl.pixel.pixelData[dataIndex]
    local oldScale = effectData.scale
    local oldColor = effectData.color

    self:cl_stopEffect(effect, effectData)

    local minX, maxX = x1 - x, (x + oldScale.x - 1) - (x1 + newScale.x - 1)
    local minY, maxY = y1 - y, (y + oldScale.y - 1) - (y1 + newScale.y - 1)

    local minDrawn = false
    local maxDrawn = false

    if minX > 0 then
        self:cl_createPixelEffect(x, y, {x = minX, y = oldScale.y}, oldColor)
        minDrawn = true
    end

    if maxX > 0 then
        local startPosX = x + oldScale.x - maxX
        self:cl_createPixelEffect(startPosX, y, {x = maxX, y = oldScale.y}, oldColor)

        maxDrawn = true
    end

    if minY > 0 then
        local startPosX = minDrawn and x + minX or x
        local scaleX = oldScale.x

        if minDrawn then scaleX = scaleX - minX end
        if maxDrawn then scaleX = scaleX - maxX end

        self:cl_createPixelEffect(startPosX, y, {x = scaleX, y = minY}, oldColor)
    end

    if maxY > 0 then
        local startPosX = minDrawn and x + minX or x

        local startPosY = y1 + newScale.y
        local scaleX = oldScale.x

        if minDrawn then scaleX = scaleX - minX end
        if maxDrawn then scaleX = scaleX - maxX end

        self:cl_createPixelEffect(startPosX, startPosY, {x = scaleX, y = maxY}, oldColor)
    end
end

-- Optimise effects that are currently on the display, also does max optimisation, very expensive and weird
function DisplayClass:cl_optimizeDisplayEffects()
    local occupied = self.cl.pixel.occupied
    local pixelData = self.cl.pixel.pixelData

    local width, height = self.data.width, self.data.height

    local threshold = self.cl.display.threshold
    local processed = {}

    local function findMaxDimensions(x, y, color, originalScaleX, originalScaleY)
        local maxWidth, maxHeight = originalScaleX, originalScaleY

        for i = x + originalScaleX, width do
            local canExtendWidth = true
            for j = y, y + maxHeight - 1 do
                local occupiedIndex = occupied[coordinateToIndex(i, j, width)]

                if not (occupiedIndex and not processed[occupiedIndex] and areColorsSimilar(pixelData[occupiedIndex].color, color, threshold)) then
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

                if not (occupiedIndex and not processed[occupiedIndex] and areColorsSimilar(pixelData[occupiedIndex].color, color, threshold)) then
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

            local color = selectedPixel.color
            local scale = selectedPixel.scale

            local maxWidth, maxHeight = findMaxDimensions(x, y, color, scale.x, scale.y)

            self:cl_drawPixel({
                x = x,
                y = y,
                color = color,
                scale = {x = maxWidth, y = maxHeight}
            })

            -- Mark the merged pixels as processed
            markBlockAsProcessed(x, y, maxWidth, maxHeight)
        end

        x = x + 1

        if x > width then
            y = y + 1
            x = 1
        end
    end
end

-- Draws a line, uses draw pixel to draw final pixels
-- This uses Bresenham's line algorithm.
---@param params {x0: number, y0: number, x1: number, y1: number, color: Color} The parameters
function DisplayClass:cl_drawLine(params)
    local x0 = params.x
    local y0 = params.y
    local x1 = params.x1
    local y1 = params.y1
    local color = params.color

    local dx = math.abs(x1 - x0)
    local dy = math.abs(y1 - y0)
    local sx = (x0 < x1) and 1 or -1
    local sy = (y0 < y1) and 1 or -1
    local err = dx - dy

    local width = self.data.width

    while true do
        if x0 >= 1 and y0 >= 1 and x0 < width and y0 < self.data.height then
            local index = coordinateToIndex(x0, y0, width)

            if self:cl_cacheCheck(index, color) then
                self.cl.optimiseBuffer[index] = color
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

---@param params {x: number, y: number, radius: number, color: Color, isFilled: boolean} The parameters
function DisplayClass:cl_drawCircle(params)
    local x = params.x
    local y = params.y
    local radius = params.radius
    local color = params.color
    local isFilled = params.isFilled

    local f = 1 - radius
    local ddF_x = 1
    local ddF_y = -2 * radius
    local cx = 0
    local cy = radius

    local function plot(xp, yp)
        local index = coordinateToIndex(xp, yp, self.data.width)

        if xp >= 1 and xp <= self.data.width and yp >= 1 and yp <= self.data.height and self:cl_cacheCheck(index, color) then
            self.cl.optimiseBuffer[index] = color
        end
    end

    if isFilled then
        self:cl_scaledAdd({x = x - radius, y = y, scale = {x = radius * 2 + 1, y = 1}, color = color})
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
            self:cl_scaledAdd({x = x - cx, y = y + cy, scale = {x = cx * 2 + 1, y = 1}, color = color})
            self:cl_scaledAdd({x = x - cy, y = y + cx, scale = {x = cy * 2 + 1, y = 1}, color = color})

            self:cl_scaledAdd({x = x - cx, y = y - cy, scale = {x = cx * 2 + 1, y = 1}, color = color})
            self:cl_scaledAdd({x = x - cy, y = y - cx, scale = {x = cy * 2 + 1, y = 1}, color = color})
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

---@param params {x1: number, y1: number, x2: number, y2: number, x3: number, y3: number, color: Color, isFilled: boolean} The parameters
function DisplayClass:cl_drawTriangle(params)
    local x1 = params.x1
    local y1 = params.y1
    local x2 = params.x2
    local y2 = params.y2
    local x3 = params.x3
    local y3 = params.y3
    local color = params.color
    local isFilled = params.isFilled

    self:cl_drawLine({x = x1, y = y1, x1 = x2, y1 = y2, color = color})
    self:cl_drawLine({x = x2, y = y2, x1 = x3, y1 = y3, color = color})
    self:cl_drawLine({x = x3, y = y3, x1 = x1, y1 = y1, color = color})

    if isFilled then
        local sortedPoints = {
            {x = params.x1, y = params.y1},
            {x = params.x2, y = params.y2},
            {x = params.x3, y = params.y3}
        }
        table.sort(sortedPoints, function(a, b) return a.y < b.y end)

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

            for x = math.floor(xa), math.ceil(xb) do
                if x >= 1 and x <= self.data.width and y >= 1 and y <= self.data.height then
                    local index = coordinateToIndex(x, y, self.data.width)

                    if self:cl_cacheCheck(index, color) then
                        self.cl.optimiseBuffer[index] = color
                    end
                end
            end
        end
    end
end


-- Draws a cuboid, filled or not, uses draw pixel to draw final pixels
---@param params {x: number, y: number, width: number, height: number, color: Color, isFilled: boolean} The parameters
function DisplayClass:cl_drawRect(params)
    local x = params.x
    local y = params.y
    local width = params.width
    local height = params.height
    local color = params.color
    local isFilled = params.isFilled

    if isFilled then
        self:cl_scaledAdd({x = x, y = y, color = color, scale = {x = width, y = height}})
        return
    end

    self:cl_scaledAdd({x = x, y = y, scale = {x = width, y = 1}, color = color})
    self:cl_scaledAdd({x = x + width - 1, y = y + 1, scale = {x = 1, y = height - 2}, color = color})
    self:cl_scaledAdd({x = x, y = y + 1, scale = {x = 1, y = height - 2}, color = color})
    self:cl_scaledAdd({x = x, y = y + height - 1, scale = {x = width, y = 1}, color = color})
end

-- Draws text, uses the font in ConfigFont.lua, uses draw pixel to draw final pixels
---@param params {x: number, y: number, string: string, color: Color, font: string} The parameters
function DisplayClass:cl_drawText(params)
    local font, err = sm.scrapcomputers.fontManager.getFont(params.font)

    if not font then
        sm.log.error("Fatal error! Failed to get the font! Error message: "..err)
        sm.gui.chatMessage("[#3A96DDS#3b78ffC#eeeeee]: A unexpected error occured trying to get a font!")

        return
    end

    local xSpacing = 0
    local ySpacing = 0

    local i = 1

    while i <= #params.string do
        local char = getUTF8Character(params.string, i)

        if char == "\n" then
            xSpacing = 0
            ySpacing = ySpacing + font.fontHeight
        else
            local fontLetter = font.charset[char] or font.errorChar

            if (params.x + xSpacing) + font.fontWidth > self.data.width then
                xSpacing = 0
                ySpacing = ySpacing + font.fontHeight
            end

            for yPosition, row in pairs(fontLetter) do
                for xPosition = 1, #row, 1 do
                    if row:sub(xPosition, xPosition) == "#" then
                        local index = coordinateToIndex(params.x + xSpacing + (xPosition - 1), params.y + ySpacing + (yPosition - 1), self.data.width)

                        if self:cl_cacheCheck(index, params.color) then
                            self.cl.optimiseBuffer[index] = params.color
                        end
                    end
                end

            end

            xSpacing = xSpacing + font.fontWidth
        end

        i = i + #char
    end
end

-- Clears display
---@param params [Color]
function DisplayClass:cl_clearDisplay(params)
    for i, effect in pairs(self.cl.pixel.pixels) do
        if sm.exists(effect) then
            self:cl_stopEffect(effect, self.cl.pixel.pixelData[i])
        end
    end

    self.cl.pixel.pixels = {}
    self.cl.pixel.pixelData = {}
    self.cl.pixel.occupied = {}

    local color = params[1]

    if color then
        self.cl.backPannel.effect:setParameter("color", color)
        self.cl.backPannel.currentColor = color
    end
end

-- Loops through pixels to hide/show them
---@param params [boolean]
function DisplayClass:cl_setDisplayHidden(params)
    local setHidden = params[1]

    if setHidden ~= self.cl.display.isHidden then
        self.cl.display.isHidden = setHidden

        for i, effect in pairs(self.cl.pixel.pixels) do
            if sm.exists(effect) then
                if setHidden then
                    self:cl_forceStop(effect)
                else
                    self:cl_forceStart(effect)
                end
            end
        end
    end
end

function DisplayClass:cl_forceStop(effect, culling)
    if sm.exists(effect) and effect:isPlaying() then effect:stop() end
end

function DisplayClass:cl_forceStart(effect)
    if sm.exists(effect) and not effect:isPlaying() then effect:start() end
end

function DisplayClass:cl_destroyEffect(effect)
    if sm.exists(effect) then effect:destroy() end
end

function DisplayClass:cl_startEffect(effect)
    self.cl.stopBuffer[effect.id] = nil
    self.cl.startBuffer[effect.id] = effect
end

function DisplayClass:cl_stopEffect(effect, effectData, temporary)
    self.cl.startBuffer[effect.id] = nil
    self.cl.stopBuffer[effect.id] = effect

    if not temporary then
        self.cl.pixel.stoppedEffects[effect.id] = effect
        self.cl.pixel.stoppedEffectData[effect.id] = effectData

        if effectData then
            local dataIndex = coordinateToIndex(effectData.x, effectData.y, self.data.width)
            local xScale, yScale = effectData.scale.x, effectData.scale.y

            if xScale ~= 1 or yScale ~= 1 then
                local x1, y1 = effectData.x, effectData.y

                for _ = 1, xScale * yScale do
                    local occupiedIndex = coordinateToIndex(x1, y1, self.data.width)

                    self.cl.pixel.occupied[occupiedIndex] = nil

                    x1 = x1 + 1

                    if x1 > effectData.x + xScale - 1 then
                        y1 = y1 + 1
                        x1 = effectData.x
                    end
                end
            else
                self.cl.pixel.occupied[dataIndex] = nil
            end

            self.cl.pixel.pixels[dataIndex] = nil
            self.cl.pixel.pixelData[dataIndex] = nil
        end
    end
end

sm.scrapcomputers.componentManager.toComponent(DisplayClass, "Displays", true)