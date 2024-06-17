-- Ben has sacraficed his fucking soul making display's. VeraDev died commenting the entire display.
-- Not only did VeraDev die, When this commit was pushed (for documentation), The 2 best sentences of
-- the description were: "THIS IS ABSOLUTE DOG SHIT AND I DONT WANT TO EVER TOUCH THEM AGAIN. THIS BITCH CAN SUCK MY ASS!"

-- If you ever make your own display's. You will actually kill yourself. We are NOT joking.

dofile("$CONTENT_DATA/Scripts/Config.lua")
dofile("$CONTENT_DATA/Scripts/FontManager.lua")

---@class Display : ShapeClass
Display = class()
Display.maxParentCount = 1
Display.maxChildCount = 0
Display.connectionInput = sm.interactable.connectionType.compositeIO
Display.connectionOutput = sm.interactable.connectionType.none
Display.colorNormal = sm.color.new(0x696969ff)
Display.colorHighlight = sm.color.new(0x969696ff)

-- CLIENT/SERVER --
local localPlayer = sm.localPlayer
local camera = sm.camera

local PIXEL_UUID = sm.uuid.new("cd943f04-96c7-43f0-852c-b2d68c7fc157")                 -- The Pixel (in UUID). This is used for the backpanel since its seperate from the actual pixels themself.
local BACKPANEL_EFFECT_NAME = "ScrapComputers - ShapeRenderableBackPanel"              -- The Name of the back panel (Seperated from ShapeRenderable effect and the pixel effect's)
local width, height = sm.gui.getScreenSize()                                           -- The size of the screen from the client
local byteLimit = 65000                                                                -- This is needed so Scrap Mechanic wont give us a error because of a packet limit size.
local displayHidingCooldown = 0.5                                                      -- Cooldown for pixel showing/hiding (This is in secconds, Aka 20 Ticks!)

-- Buffer instruction's (Generaly instructions that update pixel's)
-- Any instructions that start with DRAW_ and isnt DRAW_PIXEL has a additional argument for fill and no fill! We are saving instructions bois!
local bufferInstructions = {
    ["DRAW_PIXEL"] = "cl_addPixel",
    ["DRAW_LINE"] = "cl_drawLine",
    ["DRAW_TEXT"] = "cl_drawText",
    ["DRAW_CIRCLE"] = "cl_drawCircle",
    ["DRAW_TRIANGLE"] = "cl_drawTriangle",
    ["DRAW_RECT"] = "cl_drawRect",

    ["OPTIMIZE"] = "cl_optimizeDisplayEffects",
    ["CLEAR_DISPLAY"] = "cl_clearDisplay"
}

-- Optimization instruction's (For optimization ofcourse)
local networkInstructions = {
    ["DIS_VIS"] = "cl_setDisplayHidden",
    ["SET_REND"] = "cl_setRenderDistance",
    ["SET_THRESHOLD"] = "cl_setThreshold",
    ["TOUCH_STATE"] = "cl_setTouchAllowed"
}

-- Selects a random ShapeRenderable from 0 to 199. Why not use ShapeRenderable? If were to use that. We would reach the effect limit pretty easly.
-- So we do someting VERY janky and Iliegal by making 200 clone's of shaperenderable due to some fuckery on Scrap Mechanic so we can bypass the limit.
---@return string PixelShapeRenderableName The shape renderable to use for the pixel
function SelectShapeRenderable()
    return "ScrapComputers - ShapeRenderable"..math.random(0, 199)
end

-- Split a string into chunks.
-- Used for networking so you can send a ton of instructions (over 1000+) and you wont get the network packet limit error. Fuck you Scrap Mechanic!
---@param inputString string The string to split into
---@param chunkSize number The size per chunk
---@return string[] inputStringChunks The inputString's splitted chunks by chunkSize
function splitString(inputString, chunkSize)
    -- Our output
    local chunks = {}

    -- Loop through the string for each chunkSize and create a new chunk
    for i = 1, #inputString, chunkSize do
        local chunk = string.sub(inputString, i, i + chunkSize - 1)
        table.insert(chunks, chunk)
    end

    -- Return the chunks table.
    return chunks
end

-- Converts a Pixel's position into local shape position.
function pixelPosToShapePos(x, y, widthScale, heightScale, pixelScale, borderOffsetX, borderOffsetY)
    -- Math that VeraDev is scared to explain
    local xPos = -(widthScale / 2) + (pixelScale.z / 200) + borderOffsetX + (x * pixelScale.z / 100)
    local yPos = -(heightScale / 2) + (pixelScale.y / 200) + borderOffsetY + (y * pixelScale.y / 100)

    -- Return the new X and Y position's
    return xPos, yPos
end

-- Like pixelPosToShapePos but reversed. Convert's a local shape position to a pixel position.
function shapePosToPixelPos(point, widthScale, heightScale, pixelScale, borderOffsetX, borderOffsetY)
    -- Math that VeraDev is scared to explain
    local x = (100 / pixelScale.z) * (point.z - borderOffsetX + (widthScale / 2) - (pixelScale.z / 200)) + 1
    local y = (100 / pixelScale.y) * (point.y - borderOffsetY + (heightScale / 2) - (pixelScale.y / 200)) + 1

    -- Return the new X and Y position's
    return x, y
end

-- Rounds a number based on normal math norms. math.floor doesn't do that.
function round(numb)
    local ceil = math.ceil(numb)   -- Get the lowest interger value
    local floor = math.floor(numb) -- Get the highest interger value

    local v1 = math.abs(numb - ceil)  -- Get the absolute value of (numb - celi)
    local v2 = math.abs(numb - floor) -- Get the absolute value of (numb - floor)

    -- Check if v1 is higher then v2. if so then numb (only decimal's!) is 0.5+ so return floor
    if v1 > v2 then
        return floor
    end

    -- Since v2 is higher. That means celi is under (only decimal's!) 0.5
    return ceil
end

-- Returns true if the 2 colors are similar given via a threshold
---@param color Color The first color
---@param color1 Color The seccond color
---@param threshold number (Optional) The threshold of how accruate it should be. By default its 0 aka exactly same color.
---@return boolean colorSame If this is true. then the 2 colors are similar from the threshold.
function areColorsSimilar(color, color1, threshold)
    threshold = threshold or 0 -- Threshold is optional. by default,

    -- Get the distance between 2 colors
    local distance = colorDistance(color.r, color.g, color.b, color1.r, color1.g, color1.b)

    -- Return true if the distance is lower than the threshold.
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
    -- Perform (Color2 - Color1). This is just in RGB.
    local dr = r2 - r1
    local dg = g2 - g1
    local db = b2 - b1

    -- Square the dr, dg, db by 2 and combine them. Then square root the fucking bitch
    return math.sqrt(dr^2 + dg^2 + db^2)
end

-- Gets the UTF8 char from a string as string.sub messes up special characters
---@param str string The string
---@param index number The UTF8 character to select
---@return string UTF8Character The UTF8 character returned.
function getUTF8Character(str, index)
    -- Retrieve the byte representation of the character at the specified index.
    local byte = string.byte(str, index)
    -- Variable to store the number of bytes the character occupies in UTF-8 encoding.
    local byteCount = 1

    -- Determine the number of bytes the character occupies based on its byte value.
    if byte >= 0xC0 and byte <= 0xDF then
        byteCount = 2
    elseif byte >= 0xE0 and byte <= 0xEF then
        byteCount = 3
    elseif byte >= 0xF0 and byte <= 0xF7 then
        byteCount = 4
    end

    -- Extract the UTF-8 character from the string using string.sub.
    -- Adjust the substring range to include the complete character.
    return string.sub(str, index, index + byteCount - 1)
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
    local optimizedStack = {} -- Resulting optimized stack of pixel instructions
    local processed = {} -- Set to track processed pixels

    -- Helper function to find the maximum dimensions of a block
    local function findMaxDimensions(x, y, color)
        local maxWidth, maxHeight = 1, 1

        -- Find the maximum width
        for i = x + 1, width do
            if indexedStack[i] and indexedStack[i][y] and (not processed[i] or not processed[i][y]) and areColorsSimilar(indexedStack[i][y], color, threshold) then
                maxWidth = maxWidth + 1
            else
                break
            end
        end

        -- Find the maximum height while ensuring the width is consistent
        for j = y + 1, height do
            local rowIsUniform = true
            for i = x, x + maxWidth - 1 do
                if not (indexedStack[i] and indexedStack[i][j] and (not processed[i] or not processed[i][j]) and areColorsSimilar(indexedStack[i][j], color, threshold)) then
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

    -- Mark the processed pixels
    local function markBlockAsProcessed(x, y, width, height)
        for i = x, x + width - 1 do
            processed[i] = processed[i] or {}
            for j = y, y + height - 1 do
                processed[i][j] = true
            end
        end
    end

    -- Merge adjacent pixels of the same color into larger blocks
    for x = 1, width do
        if indexedStack[x] then
            for y = 1, height do
                if indexedStack[x][y] and not (processed[x] and processed[x][y]) then
                    local color = indexedStack[x][y]
                    local maxWidth, maxHeight = findMaxDimensions(x, y, color)

                    -- Store the optimized block in the stack
                    table.insert(optimizedStack, {
                        x = x,
                        y = y,
                        color = color,
                        scale = { x = maxWidth, y = maxHeight }
                    })

                    -- Mark the merged pixels as processed
                    markBlockAsProcessed(x, y, maxWidth, maxHeight)
                end
            end
        end
    end

    -- Return the optimized stack, ensuring minimum number of grouped effects
    return optimizedStack
end


-- SERVER --

-- Creates all functions for the display
function Display:sv_createData()
    -- Draw Circle function
    ---@param x number The center X cordinates
    ---@param y number The center Y cordinates
    ---@param radius number The radius of the circle
    ---@param color Color The color of the circle
    ---@param isFilled boolean If true, the circle is filled. else not.
    local function drawCricle(x, y, radius, color, isFilled)
        -- Check if x and y are number's.
        assert(type(x) == "number", "bad argument #1. Expected number. Got "..type(x).." instead!")
        assert(type(y) == "number", "bad argument #2. Expected number. Got "..type(y).." instead!")

        -- Check if the radius is a number
        assert(type(radius) == "number", "bad argument #3. Expected number. Got "..type(radius).." instead!")

        -- Check if the radius isnt negative.
        assert(radius > 0, "bad argument #3, Radius too small!")

        -- Check x and y cordinates are in-bounds
        assert(math.floor(x) > 0 and x <= self.data.width, "bad argument #1, Out of bounds (x-Axis)")
        assert(math.floor(y) > 0 and y <= self.data.height, "bad argument #2, Out of bounds (y-Axis)")

        -- Check if the color is actually a Color or string
        assert((type(color) == "Color" or type(color) == "string"), "bad argument #4. Expected Color or string. Got "..type(color).." instead!")

        -- Add a instruction to the buffer
        table.insert(self.sv.buffer, {
            "DRAW_CIRCLE", -- Type of instruction
            {
                x = math.floor(x), -- The x cordinates
                y = math.floor(y), -- The y cordiantes

                radius = radius, -- The radius of the circle

                color = type(color) == "Color" and color or sm.color.new(color), -- The color (as sm.color.new)

                isFilled = isFilled -- If its filled or not
            }
        })
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
        -- Check if the 1st point are number's and are in-bounds
        assert(type(x1) == "number", "bad argument #1. Expected number. Got "..type(x1).." instead!")
        assert(type(y1) == "number", "bad argument #2. Expected number. Got "..type(y1).." instead!")
        assert(math.floor(x1) > 0 and x1 <= self.data.width, "bad argument #1, Out of bounds (x-Axis)")
        assert(math.floor(y1) > 0 and y1 <= self.data.height, "bad argument #2, Out of bounds (y-Axis)")

        -- Check if the 2nd point are number's and are in-bounds
        assert(type(x2) == "number", "bad argument #3. Expected number. Got "..type(x2).." instead!")
        assert(type(y2) == "number", "bad argument #4. Expected number. Got "..type(y2).." instead!")
        assert(math.floor(x2) > 0 and x2 <= self.data.width, "bad argument #3, Out of bounds (x-Axis)")
        assert(math.floor(y2) > 0 and y2 <= self.data.height, "bad argument #4, Out of bounds (y-Axis)")

        -- Check if the 3rd point are number's and are in-bounds
        assert(type(x3) == "number", "bad argument #5. Expected number. Got "..type(x3).." instead!")
        assert(type(y3) == "number", "bad argument #6. Expected number. Got "..type(y3).." instead!")
        assert(math.floor(x3) > 0 and x3 <= self.data.width, "bad argument #5, Out of bounds (x-Axis)")
        assert(math.floor(y3) > 0 and y3 <= self.data.height, "bad argument #6, Out of bounds (y-Axis)")

        -- Check if the color is actually a Color or string.
        assert((type(color) == "Color" or type(color) == "string"), "bad argument #7. Expected Color or string. Got "..type(color).." instead!")

        -- Add a instruction to the buffer
        table.insert(self.sv.buffer, {
            "DRAW_TRIANGLE", -- The type
            {
                x1 = math.floor(x1),  -- The 1st point on the X-axis
                y1 = math.floor(y1),  -- The 1st point on the Y-axis

                x2 = math.floor(x2), -- The 2nd point on the X-axis
                y2 = math.floor(y2), -- The 2nd point on the Y-axis

                x3 = math.floor(x3), -- The 3rd point on the X-axis
                y3 = math.floor(y3), -- The 3rd point on the Y-axis

                color = type(color) == "Color" and color or sm.color.new(color), -- The color of the triangle

                isFilled = isFilled -- If its filled or not.
            }
        })
    end

    ---Draw Rectangle Function
    ---@param x number The x-cordinate
    ---@param y number The y-cordinate
    ---@param width number The width of the rectangle
    ---@param height number The height of the triangle
    ---@param color Color|string The color of the rectangle
    ---@param isFilled boolean If true, The rectangle is filled. else it will just draw 4 fucking lines.
    local function drawRect(x, y, width, height, color, isFilled)
        -- Check if the x and y cordinates are numbers and are in-bounds
        assert(type(x) == "number", "bad argument #1. Expected number. Got "..type(x).." instead!")
        assert(type(y) == "number", "bad argument #2. Expected number. Got "..type(y).." instead!")
        assert(math.floor(x) > 0 and x <= self.data.width, "bad argument #1, Out of bounds (x-Axis)")
        assert(math.floor(y) > 0 and y <= self.data.height, "bad argument #2, Out of bounds (y-Axis)")

        -- Check if the width or height are numbers and are in-bounds
        assert(type(width) == "number", "bad argument #3. Expected number. Got "..type(width).." instead!")
        assert(type(height) == "number", "bad argument #4. Expected number. Got "..type(height).." instead!")
        assert(math.floor(x + width - 1) > 0 and (x + width - 1) <= self.data.width, "bad argument #3, Out of bounds (x-Axis)")
        assert(math.floor(y + height - 1) > 0 and (y + height - 1) <= self.data.height, "bad argument #4, Out of bounds (y-Axis)")

        -- Check if the color is actually a Color or string.
        assert((type(color) == "Color" or type(color) == "string"), "bad argument #5. Expected Color or string. Got "..type(color).." instead!")

        -- Add a instruction to the buffer
        table.insert(self.sv.buffer, {
            "DRAW_RECT", -- The type
            {
                x = math.floor(x), -- The x cordinate
                y = math.floor(y), -- The y cordinate

                width = math.floor(width),   -- The width of the rectangluar shape
                height = math.floor(height), -- The height of the rectangluar shape

                color = type(color) == "Color" and color or sm.color.new(color), -- The color of the rectangle

                isFilled = isFilled -- If its filled or not.
            }
        })
    end

    return {
        ---Draws a pixel
        ---@param x number
        ---@param y number
        ---@param color Color
        drawPixel = function (x, y, color)
            -- Check if x and y are number's and are in-bounds
            assert(type(x) == "number", "bad argument #1. Expected number. Got "..type(x).." instead!")
            assert(type(y) == "number", "bad argument #2. Expected number. Got "..type(y).." instead!")
            assert(math.floor(x) > 0 and x <= self.data.width, "bad argument #1, Out of bounds (x-Axis)")
            assert(math.floor(y) > 0 and y <= self.data.height, "bad argument #2, Out of bounds (y-Axis)")

            -- Check if the color is actually a Color or string.
            assert((type(color) == "Color" or type(color) == "string"), "bad argument #3. Expected Color or string. Got "..type(color).." instead!")

            -- Add a instruction to the buffer
            table.insert(self.sv.buffer, {
                "DRAW_PIXEL",
                {
                    x = x,  -- The x cordinate
                    y = y,  -- The y cordinate
                    scale = {x = 1, y = 1}, -- The pixel scale
                    color = type(color) == "Color" and color or sm.color.new(color) -- The color of the pixel
                }
            })
        end,

        ---Draws pixels from a table
        ---@param tbl table The table of pixels
        drawFromTable = function (tbl)
            -- Check if the tbl is a table
            assert(type(tbl) == "table", "bad argument #1. Expected table. Got "..type(tbl).." instead!")

            -- Loop through them
            for i, pixel in pairs(tbl) do
                -- Check if the pixel has the correct shit
                assert(pixel.x and pixel.y and pixel.scale and pixel.color, "missing data at index "..i..".")

                -- Check if x and y are number's and if they are in-bounds
                assert(type(pixel.x) == "number", "bad x value at index "..i..". Expected number. Got "..type(pixel.x).." instead!")
                assert(type(pixel.y) == "number", "bad y value at index "..i..". Expected number. Got "..type(pixel.y).." instead!")
                assert(math.floor(pixel.x) > 0 and pixel.x <= self.data.width, "bad x value at index "..i..", Out of bounds (x-Axis)")
                assert(math.floor(pixel.y) > 0 and pixel.y <= self.data.width, "bad y value at index "..i..", Out of bounds (y-Axis)")

                -- Check if the color is actually a color or string.
                assert((type(pixel.color) == "Color" or type(pixel.color) == "string"), "bad color at index "..i..". Expected Color or string. Got "..type(pixel.color).." instead!")
            end

            -- Add a instruction.
            table.insert(self.sv.buffer, {"DRAW_TABLE", tbl})
        end,

        -- Clear the display
        ---@param color Color|string|nil The new background color or 000000
        clear = function (color)
            -- Check if the color is a Color, string or nil.
            assert((type(color) == "Color" or type(color) == "string" or type(color) == "nil"), "bad argument #3. Expected Color, string or nil. Got "..type(color).." instead!")

            -- If color is Color, dont do funny conversions and add a new instruction to the buffer
            if type(color) == "Color" then
                table.insert(self.sv.buffer, {"CLEAR_DISPLAY", {color}})
            else -- Since its ether a string or nil. Do conversion and if its nil. default it to 000000
                table.insert(self.sv.buffer, {"CLEAR_DISPLAY", {sm.color.new(color or "000000")}})
            end
        end,

        -- Draws a line
        ---@param x number  -- The 1st point on x-axis
        ---@param y number  -- The 1st point on y-axis
        ---@param x1 number -- The 2nd point on x-axis
        ---@param y1 number -- The 2nd point on y-axis
        ---@param color Color The line's color
        drawLine = function (x, y, x1, y1, color)
            -- Check if the 1st and 2nd point's are number's
            assert(type(x) == "number", "bad argument #1. Expected number. Got "..type(x).." instead!")
            assert(type(y) == "number", "bad argument #2. Expected number. Got "..type(y).." instead!")
            assert(type(x1) == "number", "bad argument #3. Expected number. Got "..type(x1).." instead!")
            assert(type(y1) == "number", "bad argument #4. Expected number. Got "..type(y1).." instead!")

            -- Check if the 1st and 2nd point's are in-bounds
            assert(math.floor(x) > 0 and x <= self.data.width, "bad argument #1, Out of bounds (x-Axis)")
            assert(math.floor(y) > 0 and y <= self.data.height, "bad argument #2, Out of bounds (y-Axis)")
            assert(math.floor(x1) > 0 and x1 <= self.data.width, "bad argument #3, Out of bounds (x-Axis)")
            assert(math.floor(y1) > 0 and y1 <= self.data.height, "bad argument #4, Out of bounds (y-Axis)")

            -- Check if the color is actually a color or string.
            assert((type(color) == "Color" or type(color) == "string"), "bad argument #5. Expected Color or string. Got "..type(color).." instead!")

            -- Add a instruction to the buffer
            table.insert(self.sv.buffer, {
                "DRAW_LINE", -- The type
                {
                    x = math.floor(x),   -- The 1st point on x-axis
                    y = math.floor(y),   -- The 1st point on y-axis
                    x1 = math.floor(x1), -- The 2nd point on x-axis
                    y1 = math.floor(y1), -- The 2nd point on y-axis

                    color = type(color) == "Color" and color or sm.color.new(color) -- The color of the line
                }
            })
        end,

        -- Draws a circle
        ---@param x number The x-cordinate
        ---@param y number The y-cordinate
        ---@param radius number The radius of the circle
        ---@param color number The color of the circle
        drawCircle         = function (x, y, radius, color) drawCricle(x, y, radius, color, false) end,

        -- Draws a filled circle
        ---@param x number The x-cordinate
        ---@param y number The y-cordinate
        ---@param radius number The radius of the circle
        ---@param color number The color of the circle
        drawFilledCircle   = function (x, y, radius, color) drawCricle(x, y, radius, color, true) end,

        -- Draws a triangle
        ---@param x1 number The 1st point on X-axis
        ---@param y1 number The 1st point on Y-axis
        ---@param x2 number The 2nd point on X-axis
        ---@param y2 number The 2nd point on Y-axis
        ---@param x3 number The 3rd point on X-axis
        ---@param y3 number The 3rd point on Y-axis
        ---@param color Color The color of the triangle
        drawTriangle       = function (x1, y1, x2, y2, x3, y3, color) drawTriangle(x1, y1, x2, y2, x3, y3, color, false) end,

        -- Draws a filled triangle
        ---@param x1 number The 1st point on X-axis
        ---@param y1 number The 1st point on Y-axis
        ---@param x2 number The 2nd point on X-axis
        ---@param y2 number The 2nd point on Y-axis
        ---@param x3 number The 3rd point on X-axis
        ---@param y3 number The 3rd point on Y-axis
        ---@param color Color The color of the triangle
        drawFilledTriangle = function (x1, y1, x2, y2, x3, y3, color) drawTriangle(x1, y1, x2, y2, x3, y3, color, true) end,

        -- Draws a rectangle
        ---@param x number The x-cordinate
        ---@param y number The y-cordinate
        ---@param width number The width of the rectangle
        ---@param height number The height of the triangle
        ---@param color Color|string The color of the rectangle
        drawRect           = function (x, y, width, height, color) drawRect(x, y, width, height, color, false) end,

        -- Draws a filled rectangle
        ---@param x number The x-cordinate
        ---@param y number The y-cordinate
        ---@param width number The width of the rectangle
        ---@param height number The height of the triangle
        ---@param color Color|string The color of the rectangle
        drawFilledRect     = function (x, y, width, height, color) drawRect(x, y, width, height, color, true) end,

        ---Draws text to the display
        ---@param x number The x-cordinate
        ---@param y number The y-cordinate
        ---@param text string The text to show
        ---@param color Color the color of the text
        drawText = function (x, y, text, color, fontName)
            -- Check if the x and y are number's and are in-bounds
            assert(type(x) == "number", "bad argument #1. Expected number. Got "..type(x).." instead!")
            assert(type(y) == "number", "bad argument #2. Expected number. Got "..type(y).." instead!")
            assert(math.floor(x) > 0 and x <= self.data.width, "bad argument #1, Out of bounds (x-Axis)")
            assert(math.floor(y) > 0 and y <= self.data.height, "bad argument #2, Out of bounds (y-Axis)")

            -- Check if the text is a string
            assert(type(text) == "string", "bad argument #3. Expected string. Got "..type(text).." instead!")

            -- Check if the color is actually a color or string.
            assert(type(color) == "Color" or type(color) == "string", "bad argument #4. Expected Color or string. Got "..type(color).." instead!")

            local font, _ = sc.fontmanager.getFont(fontName)
            if not font then
                fontName = sc.fontmanager.getDefaultFontName()
            end

            -- Add instruction to buffer
            table.insert(self.sv.buffer, {
                "DRAW_TEXT", -- The type
                {
                    x = math.floor(x), -- The x-cordinate
                    y = math.floor(y), -- The y-cordinate

                    string = text, -- The text to show

                    color = type(color) == "Color" and color or sm.color.new(color), -- The color of the text

                    font = fontName
                }
            })
        end,

        -- Returns the dimensions of the display
        ---@return number width The width of the display
        ---@return number height height height of the display
        getDimensions = function ()
            return self.data.width, self.data.height
        end,

        -- Hides the display
        hide = function ()
            -- Send a instruction to the network buffer
            table.insert(self.sv.networkBuffer, {"DIS_VIS", {true}})
        end,

        -- Shows the display
        show = function ()
            -- Send a instruction to the network buffer
            table.insert(self.sv.networkBuffer, {"DIS_VIS", {false}})
        end,

        -- Set the render distance for the display before it doesn't render.
        ---@param distance number The new render distance
        setRenderDistance = function (distance)
            -- Check if its a number.
            assert(type(distance) == "number", "bad argument #1. Expected number. Got "..type(distance).." instead!")

            -- Set's the render-distance.
            table.insert(self.sv.networkBuffer, {"SET_REND", {distance}})
        end,

        -- Enables/Disables touchscreen.
        ---@param bool boolean If true, Touchscreen mode is enabled and the end-user can interact with it.
        enableTouchScreen = function(bool)
            assert(type(bool) == "boolean", "bad argument #1. Expected boolean. Got "..type(bool).." instead!")

            -- Send a instruction to the network buffer
            table.insert(self.sv.networkBuffer, {"TOUCH_STATE", {bool}})

            -- Update the touchAllowed
            self.sv.display.touchAllowed = bool
        end,

        -- Gets the touched latest data
        getTouchData = function()
            -- Check if touchscreen mode is enabled
            assert(self.sv.display.touchAllowed, "Touch Screen currently disabled for this display")

            -- Return the touch data
            return self.sv.display.touchData
        end,

        -- Update the display
        update = function ()
            self.sv.allowUpdate = true
        end,

        -- Always update's the display. We highly do not suggest doing this as its VERY laggy.
        ---@param bool boolean Toggle the autoUpdate system.
        autoUpdate = function (bool)
            -- Check if its a boolean
            assert(type(bool) == "boolean", "bad argument #1. Expected boolean. Got "..type(bool).." instead!")

            -- Update the value
            self.sv.autoUpdate = bool
        end,

        -- Optimizes the display
        optimize = function ()
            table.insert(self.sv.buffer, {"OPTIMIZE", {}})
        end,

        -- Sets the optimization threshold
        ---@param int number The new threshold
        setOptimizationThreshold = function (int)
            assert(type(int) == "number", "bad argument #1. Expected number. Got "..type(int).." instead!")

            table.insert(self.sv.networkBuffer, {"SET_THRESHOLD", {int}})
        end,

        -- Calculates the text size.
        ---@param text string The text to be calculated
        ---@param font string The font to use.
        ---@return number width The width of the text that it will use
        ---@return number height The height of the text that it will use
        calcTextSize = function (text, font)
            font = font or sc.fontmanager.getDefaultFontName()

            -- Check if text is string.
            assert(type(text) == "string", "bad argument #1. Expected string. Got " .. type(text) .. " instead!")

            -- Get the font
            local font, err = sc.fontmanager.getFont(font)
            if not font then
                -- Send a fucking error message
                error("Failed getting font! Error message: "..err)
            end

            -- Do some math fuckery to calculate the text size.
            local usedWidth = sc.math.clamp(#text * font.fontWidth, 0, 256)
            local usedHeight = (1 + math.floor((#text * font.fontWidth) / self.data.width)) * font.fontHeight

            -- Return the usedWidth and usedHeight
            return usedWidth, usedHeight
        end,
    }
end

function Display:server_onFixedUpdate()
    -- Check if it has any data on the network buffer
    if #self.sv.networkBuffer > 0 then
        -- Loop through the bitches
        for _, data in pairs(self.sv.networkBuffer) do
            local instruction, params = unpack(data) -- Unpack the bitch
            local dest = networkInstructions[instruction] -- Get the destination

            self.network:sendToClients(dest, params) -- Send the bitch!

            -- Check if it is a visibility toggle instruction
            if instruction == "DIS_VIS" then
                -- Send message to all assholes in the shitty world.
                self.network:sendToClients("cl_setUserHidden", params[1])
            end
        end

        self.sv.networkBuffer = {} -- Clear the asshole!
    end

    -- Checks to see if display.update() has been called or if autoUpdate has been enabled, also if there is actually instructions in the stack
    if (self.sv.allowUpdate or self.sv.autoUpdate) and #self.sv.buffer > 0 then
        -- Loop through the buffer
        for _, data in pairs(self.sv.buffer) do
            -- Unpack the data
            local instruction, params = unpack(data)

            -- If the instrcution is draw table then we have to split the string as it could be larger than the packet limit
            if instruction == "DRAW_TABLE" then
                -- Loop through the param's and check if pixel.color is not a string
                for _, pixel in pairs(params) do
                    if type(pixel.color) ~= "string" then
                        -- Its not a string so convert it to be one!
                        pixel.color = tostring(pixel.color)
                    end
                end

                -- Convert it to json and split it by bitelimit chunks.
                local jsonStr = sm.json.writeJsonString(params)
                local strings = splitString(jsonStr, byteLimit)

                -- Loop through them and send them to the client's ass.
                for i, string in pairs(strings) do
                    local finished = i == #strings -- Is true when i is the size of the string
                    self.network:sendToClients("cl_rebuildParams", {string = string, finished = finished, i = i})
                end
            else -- Sends data to the correct func with the required params
                local dest = bufferInstructions[instruction]
                self.network:sendToClients(dest, params)
            end
        end

        self.network:sendToClients("cl_drawBuffer") -- Calls the func that draws the pixels that have been processed
        --self.network:sendToClients("cl_optimizeDisplayEffects")

        self.sv.buffer = {} -- Clear the buffer
        self.sv.allowUpdate = false -- Disable allowUpdate
    end
end

function Display:server_onCreate()
    -- Create server-side variables
    self.sv = {
        buffer = {},        -- The buffer for all draw shit
        networkBuffer = {}, -- The optimized related buffer shit.
        display = {}        -- Display information
    }
end

function Display:sv_setTouchData(data) -- Sets the touch data server side
    -- Update the asshole
    self.sv.display.touchData = data
end

-- CLIENT --

-- Sets display render distance client side
---@param params table The parameters
function Display:cl_setRenderDistance(params)
    self.cl.display.renderDistance = params[1] -- Update it
end

-- Sets display optimisation threshold client side
---@param params table The parameters
function Display:cl_setThreshold(params)
    self.cl.display.threshold = params[1] -- Update it
end

-- Sets the touch bool client side
---@param params table The parameters
function Display:cl_setTouchAllowed(params)
    self.cl.display.touchAllowed = params[1] -- Update it
end

-- Sets the user hidden bool client side
---@param bool boolean If enabled or not
function Display:cl_setUserHidden(bool)
    self.cl.display.userHidden = bool -- Update it
end

-- Optimises the table of ready to draw pixels and draws them
function Display:cl_drawBuffer()
    -- Optimize it
    local optimisedBuffer = optimizeDisplayPixelStack(self.cl.drawBuffer, self.data.width, self.data.height, self.cl.display.threshold)

    -- Loop through them all and draw all the pixels
    for i, pixel in pairs(optimisedBuffer) do
        --print(pixel, i)

        self:cl_drawPixel(pixel)
    end

    -- Clear the draw buffer.
    self.cl.drawBuffer = {}
end

-- Adds a pixel to the drawBuffer
---@param params table The parameters
function Display:cl_addPixel(params)
    self:cl_addToDraw(params)
end

function Display:cl_addToDraw(params)
    local x, y = params.x, params.y

    if params.scale.x == 1 and params.scale.y == 1 then
        self.cl.drawBuffer[x] = self.cl.drawBuffer[x] or {}
        self.cl.drawBuffer[x][y] = params.color
    else
        for x1 = x, x + params.scale.x - 1 do
            for y1 = y, y + params.scale.y - 1 do
                self.cl.drawBuffer[x1] = self.cl.drawBuffer[x1] or {}
                self.cl.drawBuffer[x1][y1] = params.color
            end
        end
    end
end

function Display:client_onCreate()
    -- Client-side variables
    self.cl = {
        -- Pixels catagory
        pixel = {
            -- Contains all pixel and it's data
            pixels = {},
            pixelData = {},

            -- The scale of the pixel
            pixelScale = sm.vec3.zero()
        },

        -- The back pannel itself
        backPannel = {
            -- The effect itself.
            effect = sm.effect.createEffect(BACKPANEL_EFFECT_NAME, self.interactable),
            defaultColor = sm.color.new("000000"), -- The default color
            currentColor = sm.color.new("000000") -- The current color
        },

        -- The display information
        display = {
            renderDistance = 10, -- The render distance of the current display
            visTimer = 0, -- The visibility timer.

        },

        drawBuffer = {}, -- The drawing buffer
        destroyBuffer = {}, -- The destryoing buffer
        startBuffer = {}, -- The starting buffer
        stopBuffer = {}, -- The stopping buffer
        tblParams = {} -- The paramaters of the table
    }

    -- Get the width and height of the display
    local width = self.data.width
    local height = self.data.height

    -- Get the scale's
    local widthScale = self.data.scale
    local heightScale = self.data.scale

    -- Check if its a rectangle
    if width ~= height then
        -- Check if height is bigger than width
        if height > width then
            -- Set height scale to be the math below
            heightScale = (height / width) * self.data.scale
        else
            -- Set width scale to be the math below
            widthScale = (width / height) * self.data.scale
        end
    end

    -- Update the width and height scale to the new one.
    self.cl.display.widthScale = widthScale
    self.cl.display.heightScale = heightScale

    -- The background's scale.
    local bgScale = sm.vec3.new(0, (self.cl.display.heightScale / 1.362) * 128, (self.cl.display.widthScale / 1.362) * 128)

    -- The scale of the pixel
    self.cl.pixel.pixelScale = sm.vec3.new(0, bgScale.y / height, bgScale.z / width)

    -- Set the parameters of the backpannel
    self.cl.backPannel.effect:setParameter("uuid", PIXEL_UUID)
    self.cl.backPannel.effect:setParameter("color",  self.cl.backPannel.defaultColor)

    -- Offset the backpannel
    self.cl.backPannel.effect:setOffsetPosition(sm.vec3.new(0.115, 0, 0))

    -- Update the scale of the backpannel
    self.cl.backPannel.effect:setScale(bgScale)

    -- Loop and start it.
    self.cl.backPannel.effect:setAutoPlay(true)
    self.cl.backPannel.effect:start()
end

function Display:client_onFixedUpdate() --checks to see if the display needs to hide, also runs hte destroy buffer to destroy effects, also does display touch screen checks
    local clock = os.clock() -- Get the current clock
    local pos = camera.getPosition() -- Get cameras current position
    local dir = camera.getDirection() -- Get cameras current direction
    local character = localPlayer.getPlayer().character -- Get character

    -- Check if the visibility timer + the hiding cooldown is smaller than the color
    if self.cl.display.visTimer + displayHidingCooldown <= clock then -- run the checks if the hiding cooldown has passed
        self.cl.display.visTimer = clock -- Update the visiblilty timer

        local worldPosition = self.shape.worldPosition -- Get the world position of the display
        local shouldHide = false -- If true, it should hide itself

        -- Checks to see if the player is close enough
        if (worldPosition - character.worldPosition):length() > self.cl.display.renderDistance then
            -- It should hide so set it to true
            shouldHide = true
        end

        -- Check if it shouldnt hide
        if not shouldHide then
            -- Get the bounding box of the dispaly
            local bb = self.shape:getBoundingBox()

            -- Get the quanterninon of at and up of the rotation
            local at = sm.quat.getAt(self.shape.worldRotation)
            local up = sm.quat.getUp(self.shape.worldRotation)

            -- Get the bounderies
            local boundry = {}

            -- VeraDev doesnt know wtf this does
            boundry[1] = worldPosition + at * bb.z / 2 -- The right edge
            boundry[2] = worldPosition - at * bb.z / 2 -- The left  edge

            boundry[3] = worldPosition + up * bb.y / 2 -- The bottom edge
            boundry[4] = worldPosition - up * bb.y / 2 -- The top    edge

            boundry[5] = boundry[4] + at * bb.z / 2    -- The top right corner
            boundry[6] = boundry[4] - at * bb.z / 2    -- The top left  corner

            boundry[7] = boundry[3] + at * bb.z / 2    -- The bottom right corner
            boundry[8] = boundry[3] - at * bb.z / 2    -- The bottom left  corner

            -- Enable shouldHide
            shouldHide = true

            -- Get the direction dot
            local dirDot = dir:dot(worldPosition - pos)

            -- Check if its higher than 0
            if dirDot > 0 then
                -- Loop through the bondaries
                for i, bound in pairs(boundry) do
                    -- Get the screen cordinates from the world position
                    local x, y = sm.render.getScreenCoordinatesFromWorldPosition(bound, width, height)

                    -- Do some checks and if so then dont hide the display (by setting shouldHide to false)
                    if not ((x < 0 or x > width) or (y < 0 or y > height)) then
                        shouldHide = false
                        break
                    end
                end
            end
        end

        -- Check if it shouldnt hide
        if not shouldHide then
            -- Calculate the starting, diffirence and end position.
            local startPos = worldPosition + sm.quat.getRight(self.shape.worldRotation) * 0.15
            local diff = pos - worldPosition
            local endPos = startPos + diff:normalize() * diff:length()

            -- Perform a raycast
            local hit, res = sm.physics.raycast(startPos, endPos)

            -- Check if hit someting
            if hit then
                -- Check if its a character
                if res.type ~= "character" then
                    shouldHide = true -- It should hide
                end
            end
        end

        -- Check if it should hide
        if not self.cl.display.userHidden then
            if shouldHide then
                -- Hide the asshole and update the previous state
                self:cl_setDisplayHidden({shouldHide})
                self.cl.prevHidden = true
            elseif not shouldHide and self.cl.prevHidden then
                -- Reveal the asshole and update the previous state
                self:cl_setDisplayHidden({shouldHide})
                self.cl.prevHidden = false
            end
        end
    end


    for i, data in pairs(self.cl.destroyBuffer) do
        local effect, created, lastStarted, lastStopped = unpack(data) -- Unpack it.
        local tick = sm.game.getCurrentTick() -- Get the current tick

        -- Check if it exists
        if sm.exists(effect) then
            -- Check if the createdTick + 1 is smaller than the tick
            if created + 1 <= tick and lastStarted + 1 <= tick and lastStopped + 1 <= tick then
                self.cl.startBuffer[effect.id] = nil
                self.cl.stopBuffer[effect.id] = nil

                effect:destroy() -- Commit manslaughter to the effect

                self.cl.destroyBuffer[i] = nil -- Delete the bitch
            end
        else
            self.cl.destroyBuffer[i] = nil -- Delete the bitch
        end
    end

    -- Loop through the starting buffer
    for i, data in pairs(self.cl.startBuffer) do
        -- Unpack the bitch
        local x, y = unpack(data)

        self.cl.pixel.pixels[x] = self.cl.pixel.pixels[x] or {}
        self.cl.pixel.pixelData[x] = self.cl.pixel.pixelData[x] or {}

        local effect = self.cl.pixel.pixels[x][y]
        local effectData = self.cl.pixel.pixelData[x][y]

        -- Check if the effect exist's
        if sm.exists(effect) then
            -- Get the current game tick
            local tick = sm.game.getCurrentTick()

            -- Check if it isn't hidden and check if the lastStoopedTick + 1 is smaller than tick.
            if not self.cl.display.isHidden and effectData.lastStoppedTick + 1 <= tick then
                -- Start the effect
                effect:start()
                effect:setAutoPlay(true)

                -- Update the pixel data's lastStartedTick
                self.cl.pixel.pixelData[x][y].lastStartedTick = tick

                -- Clear it out the buffer
                self.cl.startBuffer[i] = nil
            end
        else
            -- Clear it out the buffer
            self.cl.startBuffer[i] = nil
        end
    end

    -- Loop through the stop buffer
    for i, data in pairs(self.cl.stopBuffer) do
        -- Unpack the asshole
        local x, y = unpack(data)

        self.cl.pixel.pixels[x] = self.cl.pixel.pixels[x] or {}
        self.cl.pixel.pixelData[x] = self.cl.pixel.pixelData[x] or {}

        local effect = self.cl.pixel.pixels[x][y]
        local effectData = self.cl.pixel.pixelData[x][y]

        -- Get the current tick
        local tick = sm.game.getCurrentTick()

        -- Check if it exist's
        if sm.exists(effect) then
            -- Check if lastStartedTick + 1 is lower than tick
            if effectData.lastStartedTick + 1 <= tick then
                -- Sstop the effect
                effect:stop()
                effect:setAutoPlay(false)

                -- Update the pixel data's lastStoppedTick
                self.cl.pixel.pixelData[x][y].lastStoppedTick = tick

                -- Remove it from my ass
                self.cl.stopBuffer[i] = nil
            end
        else
            -- Remove it
            self.cl.stopBuffer[i] = nil
        end
    end

    -- Check if its interacting and the state is 1. if so then its holding so set interactState it to 2
    if self.cl.display.interacting and self.cl.display.interactState == 1 then -- sets the touch state of the touch data
        self.cl.display.interactState = 2
    -- Check if it stopped interacting, if so then set it to 3 (Release)
    elseif not self.cl.display.interacting and self.cl.wasInteracting then
        self.cl.wasInteracting = nil
        self.cl.display.interactState = 3
    end

    -- Check if it has to delete touching data and check if (+1) is lower than the current game tick.
    if self.cl.deleteTouchData and self.cl.deleteTouchData + 1 <= sm.game.getCurrentTick() then -- deletes touch data
        self.cl.deleteTouchData = nil -- Set it to nil
        self.network:sendToServer("sv_setTouchData", nil) -- Clear it
    end

    -- Check if it's interacting and its releasing
    if self.cl.display.interacting or self.cl.display.interactState == 3 then --raycast to get touch position on display
        -- Create a distanced raycast
        local hit, res = localPlayer.getRaycast(7.5)

        -- Check if hit someting
        if hit then
            -- Transforn the pointing world from shape
            local point = self.shape:transformPoint(res.pointWorld)

            -- Get the border offset on X and y
            local borderOffsetX = 0.03 * self.cl.display.widthScale
            local borderOffsetY = 0.03 * self.cl.display.heightScale

            -- Convert the shape position to pixel position
            local x, y = shapePosToPixelPos(point, self.cl.display.widthScale, self.cl.display.heightScale, self.cl.pixel.pixelScale, borderOffsetX, borderOffsetY)
            x = sc.math.clamp(x, 1, self.data.width)
            y = sc.math.clamp(y, 1, self.data.height)

            -- Check if theres no interaction state. if so then set it to 1
            if not self.cl.display.interactState then self.cl.display.interactState = 1 end

            -- Create touch data.
            local touchData = {
                x = round(x), -- The pixel x cordinate
                y = round(y), -- The pixel y cordinate

                state = self.cl.display.interactState -- The state.
            }

            -- Update it
            self.network:sendToServer("sv_setTouchData", touchData)

            -- Check if it is releasing
            if self.cl.display.interactState == 3 then
                -- Clear the interaction state
                self.cl.display.interactState = nil
                self.cl.deleteTouchData = sm.game.getCurrentTick() -- Set self.cl.deleteTouchData to the current game tick
            end
        end
    end
end

function Display:client_onUpdate()
    local pos = camera.getPosition() -- Get camera's current position
    local dir = camera.getDirection() -- Get camera's current direction
    local character = localPlayer.getPlayer().character -- Get character

    local hit, res = sm.physics.raycast(pos, pos + dir * 7.5, character, 3) -- Do body raycas

    -- Check if it hit
    if hit then
        -- Try to get raycasts shape
        local shape = res:getShape()

        -- Check if the shape exists and the shapes id is the same as the displays
        if shape and shape.id == self.shape.id then
            -- Try to get characters locking interactable
            local lockingInt = character:getLockingInteractable()

            -- Check if the locking interactable exists and if its a seat
            if lockingInt and lockingInt:hasSeat() then
                -- Check if raycast valid
                self:cl_checkRaycastValidity(res, true)

                -- Set the character as seated
                self.cl.isSeated = true
            else
                -- Check if raycast valid
                self:cl_checkRaycastValidity(res)
                
                -- Set the character as not seated
                self.cl.isSeated = false
            end
        end
    end
end

function Display:cl_checkRaycastValidity(res, isTinker)
    -- Check if it allows touching the display
    if self.cl.display.touchAllowed then
        -- Round the normal local.
        local roundedNorm = sm.vec3.new(round(res.normalLocal.x), round(res.normalLocal.y), round(res.normalLocal.z))

        -- Check if the XAxis is the same as the roundedNorm and store result on self.cl.display.raycastValid
        self.cl.display.raycastValid = self.shape:getXAxis() == roundedNorm

        -- Check if its true
        if self.cl.display.raycastValid then
            -- Check if its a tinker
            if isTinker then
                -- Update interaction text to show it can interact
                sm.gui.setInteractionText("", "Press "..sm.gui.getKeyBinding("Tinker", true).." for touch screen", "")
                sm.gui.setInteractionText("")
            else
                -- Update interaction text to show it can interact
                sm.gui.setInteractionText("", "Press "..sm.gui.getKeyBinding("Use", true).." for touch screen", "")
                sm.gui.setInteractionText("")
            end
        else
            -- Clear the interaction text
            sm.gui.setInteractionText("")
            sm.gui.setInteractionText("")
        end
    else
        -- Clear the interaction text
        sm.gui.setInteractionText("")
        sm.gui.setInteractionText("")
    end
end

function Display:cl_onTouch(state)
    -- Check if the raycast is valid
    if self.cl.display.raycastValid then
        -- Play the sound
        sm.audio.play(state and "Button on" or "Button off")

        -- Set the interacting state
        self.cl.display.interacting = state

        -- Check if it wasent interacting, if so then set it to true
        if not self.cl.wasInteracting then
            self.cl.wasInteracting = true
        end
    end
end

function Display:client_onInteract(character, state)
    -- Check to see if character is not in a seat
    if not self.cl.isSeated then
        -- Call touch function
        self:cl_onTouch(state)
    end
end

function Display:client_onTinker(character, state)
    -- Check to see if character is in a seat
    if self.cl.isSeated then
        -- Call touch function
        self:cl_onTouch(state)
    end
end

-- Draws a pixel, takes everything into account
---@param params table The parameters
function Display:cl_drawPixel(params)
    -- Clamp X and Y
    params.x = sc.math.clamp(params.x, 1, self.data.width)
    params.y = sc.math.clamp(params.y, 1, self.data.height)

    -- Create table's on pixels and pixelData
    self.cl.pixel.pixels[params.x] = self.cl.pixel.pixels[params.x] or {}
    self.cl.pixel.pixelData[params.x] = self.cl.pixel.pixelData[params.x] or {}

    -- The location of the effect and it's data
    local effect = self.cl.pixel.pixels[params.x][params.y]
    local effectData = self.cl.pixel.pixelData[params.x][params.y]

    -- Check if its 1x1
    if params.scale.x == 1 and params.scale.y == 1 then
        -- Check if it exists
        if not sm.exists(effect) then
            -- Check if it isnt the same as the backpannel color
            if params.color ~= self.cl.backPannel.currentColor then
                -- Create it
                self:cl_createPixelEffect(params.x, params.y, params.scale, params.color)
            end
        else
            -- Check if the scale isn't 1x1
            if (effectData.scale.x ~= 1 or effectData.scale.y ~= 1) and params.color ~= effectData.color then
                -- Split the effect
                self:cl_splitEffect(effectData.host.x, effectData.host.y, params.x, params.y, params.scale)

                if params.color ~= self.cl.backPannel.currentColor then
                    self:cl_createPixelEffect(params.x, params.y, params.scale, params.color)
                end
            else
                -- Check if it isnt the same as the backpannel color
                if params.color ~= self.cl.backPannel.currentColor then
                    -- Check if the paramerter's color isnt the same as effectData's color
                    if params.color ~= effectData.color then
                        -- Update the color
                        effect:setParameter("color", params.color)

                        -- Update the data
                        self.cl.pixel.pixelData[params.x][params.y].color = params.color
                    end

                    -- Start it up
                    self:cl_startEffect(effect, effectData)
                else
                    -- Check if it exists
                    if sm.exists(effect) then
                        -- Stop it
                        self:cl_destroyEffect(effect, effectData)
                    end
                end
            end
        end
    else
        -- Create variable called set
        local set = false

        -- Check if theres effectData
        if effectData then
            -- Check if (all must be true):
            --      The effect data's scale is the same as the parameter's scale
            --      The cordinates of effectData are the same as the parameter's cordinates
            if effectData.scale.x == params.scale.x and effectData.scale.y == params.scale.y and effectData.host.x == params.x and effectData.host.y == params.y then
                -- Check if the color from the backpanel mismatches.
                if params.color ~= self.cl.backPannel.currentColor then
                    -- Check if the parameter's color isnt the same as effectData's color
                    if params.color ~= effectData.color then
                        -- Update the color
                        effect:setParameter("color", params.color)

                        -- Update the data
                        self.cl.pixel.pixelData[params.x][params.y].color = params.color
                    end

                    -- Start the effect up
                    self:cl_startEffect(effect, effectData)
                else
                    -- Check if it exists
                    if sm.exists(effect) then
                        -- Stop it
                        self:cl_destroyEffect(effect, effectData)
                    end
                end

                -- Change set to true
                set = true
            end
        end

        -- Check if set is not true
        if not set then
            -- Loop through from params.x to (params.x + params.scale.x - 1)
            for x1 = params.x, params.x + params.scale.x - 1 do
                -- Loop through from params.y to (params.y + params.scale.y - 1)
                for y1 = params.y, params.y + params.scale.y - 1 do
                    -- Create the needed tables if they do NOT exist
                    self.cl.pixel.pixels[x1] = self.cl.pixel.pixels[x1] or {}
                    self.cl.pixel.pixelData[x1] = self.cl.pixel.pixelData[x1] or {}

                    -- Get the effectData
                    local effectData = self.cl.pixel.pixelData[x1][y1]

                    -- Check if it exists
                    if effectData then
                        -- Check if it isnt 1x1
                        if effectData.scale.x ~= 1 or effectData.scale.y ~= 1 then
                            -- Get the existing min and max values for X and Y
                            local existingMinX, existingMaxX = effectData.host.x, effectData.host.x + effectData.scale.x - 1
                            local existingMinY, existingMaxY = effectData.host.y, effectData.host.y + effectData.scale.y - 1

                            -- Get the drawing min and max values for X and Y
                            local drawingMinX, drawingMaxX = params.x, params.x + params.scale.x - 1
                            local drawingMinY, drawingMaxY = params.y, params.y + params.scale.y - 1

                            -- Check if (atleast one or more can be true to be valid):
                            --  - The existing axis on X and Y on min is smaller than the drawing ones for max
                            --  - The existing axis on X and Y on max is bigger than the drawing ones for max
                            if existingMinX < drawingMinX or existingMinY < drawingMinY or existingMaxX > drawingMaxX or existingMaxY > drawingMaxY then
                                -- Split the effect
                                self:cl_splitEffect(effectData.host.x, effectData.host.y, params.x, params.y, params.scale)
                            end
                        end
                    end

                    -- Update the effectData
                    local effect = self.cl.pixel.pixels[x1][y1]
                    effectData = self.cl.pixel.pixelData[x1][y1]

                    -- Check if the effect exists
                    if sm.exists(effect) then
                        -- Stop it.
                        self:cl_destroyEffect(effect, effectData)
                    end
                end
            end

            -- Create a new effect pixel.
            if params.color ~= self.cl.backPannel.currentColor then
                self:cl_createPixelEffect(params.x, params.y, params.scale, params.color)
            end
        end
    end
end

-- Other end of split string, only used for DRAW_TABLE as it has the ability to be larger than the network packet size limit
---@param data table The data
function Display:cl_rebuildParams(data)
    -- Check if data. i is 1
    if data.i == 1 then
        -- Update the tblParams to be data.string
        self.cl.tblParams = data.string
    else
        -- Append data.string to tblParams
        self.cl.tblParams = self.cl.tblParams..data.string
    end

    -- Check if it finished
    if data.finished then
        -- Convert it back to a lua table and draw it
        local params = sm.json.parseJsonString(self.cl.tblParams)
        self:cl_drawTable(params)

        -- Clear it
        self.cl.tblParams = {}
    end
end

-- Function that gets called to draw pixels based on a table
---@param tbl table The pixel table to be drawn.
function Display:cl_drawTable(tbl)
    -- Loop through the table
    for _, pixel in pairs(tbl) do
        -- Check if the pixel.color is a string, if so then convert it back to a Color
        if type(pixel.color) == "string" then
            pixel.color = sm.color.new(pixel.color)
        end

        -- Add it to the buffer
        self:cl_addToDraw(pixel)
    end
end

-- Creates a pixel effect
---@param x number The x-cordinate of the pixel
---@param y number The y-cordinate of the pixel
---@param scale {x : number, y : number} The scale of the pixe;
---@param color Color The color of it
function Display:cl_createPixelEffect(x, y, scale, color)
    -- The new effect data parameter's
    local newEffectData = {
        scale = { -- The scale of the pixel
            x = scale.x,
            y = scale.y
        },

        lastStoppedTick = 0, -- The last stopped tick
        lastStartedTick = 0, -- The last started tick

        color = color, -- The color of it
        createdTick = sm.game.getCurrentTick() -- The time it was created
    }

    -- Create the effect
    local newEffect = sm.effect.createEffect(SelectShapeRenderable(), self.interactable)

    -- Update the UUID
    newEffect:setParameter("uuid", PIXEL_UUID)

    -- Is true if it is 1x1
    local is1x1 = scale.x == 1 and scale.y == 1

    -- The center of the pixel
    local centerX = 0
    local centerY = 0

    -- Check if its 1x1
    if is1x1 then
        -- Update the scale to be the pixelScale
        newEffect:setScale(sm.vec3.new(0, self.cl.pixel.pixelScale.y, self.cl.pixel.pixelScale.z))

        -- Update the center cordinates
        centerX = x - 1
        centerY = y - 1
    else
        -- Update the scale to be the pixelScale * scale
        newEffect:setScale(sm.vec3.new(0, self.cl.pixel.pixelScale.y * scale.y, self.cl.pixel.pixelScale.z * scale.x))

        -- Update the center cordinates (with mathing)
        centerX = ((scale.x / 2) + x - 1) - 0.5
        centerY = ((scale.y / 2) + y - 1) - 0.5
    end

    -- Get the border offset's
    local borderOffsetX = 0.03 * self.cl.display.widthScale
    local borderOffsetY = 0.03 * self.cl.display.heightScale

    -- Convert a pixel position to a shape position
    local xPos, yPos = pixelPosToShapePos(centerX, centerY, self.cl.display.widthScale, self.cl.display.heightScale, self.cl.pixel.pixelScale, borderOffsetX, borderOffsetY)

    -- Update the offset position
    newEffect:setOffsetPosition(sm.vec3.new(0.116, yPos, xPos))

    -- Update the color of the effect
    newEffect:setParameter("color", color)

    -- Create table's if they don't exist
    self.cl.pixel.pixels[x] = self.cl.pixel.pixels[x] or {}
    self.cl.pixel.pixelData[x] = self.cl.pixel.pixelData[x] or {}

    -- Check if it isn't 1x1
    if not is1x1 then
        -- Loop through from x to (x + scale.x - 1)
        for x1 = x, x + scale.x - 1 do
            -- Loop through from yto (y + scale.y - 1)
            for y1 = y, y + scale.y - 1 do
                -- Add the newEffect and newEffectData to the matrix's

                self.cl.pixel.pixels[x1][y1] = newEffect
                self.cl.pixel.pixelData[x1][y1] = newEffectData

                -- Update the host for pixelData to have x and y cordinates.
                self.cl.pixel.pixelData[x1][y1].host = {x = x, y = y}
            end
        end
    else
        -- Add the newEffect and newEffectData to the matrix's
        self.cl.pixel.pixels[x][y] = newEffect
        self.cl.pixel.pixelData[x][y] = newEffectData

        -- Update the host for pixelData to have x and y cordinates.
        self.cl.pixel.pixelData[x][y].host = {x = x, y = y}
    end

    self:cl_startEffect(newEffect, newEffectData)
end

-- Splits a effect
---@param x number The 1st x-cordinates
---@param y number The 1st y-cordinates
---@param x1 number The 2nd x-cordinates
---@param y1 number The 2nd y-cordinates
---@param newScale Vec3 The new scale.
function Display:cl_splitEffect(x, y, x1, y1, newScale)
    -- Create the tables if they dont exist
    self.cl.pixel.pixels[x] = self.cl.pixel.pixels[x] or {}
    self.cl.pixel.pixelData[x] = self.cl.pixel.pixelData[x] or {}

    local effect = self.cl.pixel.pixels[x][y]          -- Get the effect
    local effectData = self.cl.pixel.pixelData[x][y]   -- Get the effect data
    local oldScale = effectData.scale                  -- The old scale
    local oldColor = effectData.color                  -- The old color

    -- Destroy the effect
    self:cl_destroyEffect(effect, effectData)

    -- Get the mininum and maximum X and Y values
    local minX, maxX = x1 - x, (x + oldScale.x - 1) - (x1 + newScale.x - 1)
    local minY, maxY = y1 - y, (y + oldScale.y - 1) - (y1 + newScale.y - 1)

    local minDrawn -- Is true if the minX is bigger than 0
    local maxDrawn -- Is true if the minY is bigger than 0

    -- Check if minX is higher than 0
    if minX > 0 then
        -- Create a effect
        self:cl_createPixelEffect(x, y, {x = minX, y = oldScale.y}, oldColor)
        minDrawn = true -- Update it
    end

    -- Check if minY is higher than 0
    if maxX > 0 then
        -- Get the start position on X-axis
        local startPosX = x + oldScale.x - maxX

        -- Create a effect
        self:cl_createPixelEffect(startPosX, y, {x = maxX, y = oldScale.y}, oldColor)
        maxDrawn = true -- Update it
    end

    -- Check if minY is bigger than 0
    if minY > 0 then
        -- Get the start position on X-axis
        local startPosX = minDrawn and x + minX or x
        local scaleX = oldScale.x -- Get the old scale on the X-axis

        -- Check if min is drawn. if so the reduce scaleX by minX
        if minDrawn then
            scaleX = scaleX - minX
        end

        -- Check if max is drawn. if so the reduce scaleX by maxX
        if maxDrawn then
            scaleX = scaleX - maxX
        end

        -- Create the effect
        self:cl_createPixelEffect(startPosX, y, {x = scaleX, y = minY}, oldColor)
    end

    if maxY > 0 then
        -- Get the start position on X-axis
        local startPosX = minDrawn and x + minX or x

        -- Get the start position on Y-axis
        local startPosY = y1 + newScale.y
        local scaleX = oldScale.x -- Get the old scale on the X-axis

        -- Check if min is drawn. if so the reduce scaleX by minX
        if minDrawn then
            scaleX = scaleX - minX
        end

        -- Check if max is drawn. if so the reduce scaleX by maxX
        if maxDrawn then
            scaleX = scaleX - maxX
        end

        -- Create the effect
        self:cl_createPixelEffect(startPosX, startPosY, {x = scaleX, y = maxY}, oldColor)
    end
end

-- Optimise effects that are currently on the display, also does max optimisation, very expensive and weird
function Display:cl_optimizeDisplayEffects()
    local processed = {} -- Set to track processed pixels

    -- Helper function to find the maximum dimensions of a block
    local function findMaxDimensions(x, y, color, originalScaleX, originalScaleY)
        local maxWidth, maxHeight = originalScaleX, originalScaleY

        -- Find the maximum width
        for i = x + originalScaleX, self.data.width do
            local canExtendWidth = true
            for j = y, y + maxHeight - 1 do
                if not (self.cl.pixel.pixelData[i] and self.cl.pixel.pixelData[i][j] and 
                        (not processed[i] or not processed[i][j]) and 
                        areColorsSimilar(self.cl.pixel.pixelData[i][j].color, color, self.cl.display.threshold)) then
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

        -- Find the maximum height while ensuring the width is consistent
        for j = y + originalScaleY, self.data.height do
            local rowIsUniform = true
            for i = x, x + maxWidth - 1 do
                if not (self.cl.pixel.pixelData[i] and self.cl.pixel.pixelData[i][j] and 
                        (not processed[i] or not processed[i][j]) and 
                        areColorsSimilar(self.cl.pixel.pixelData[i][j].color, color, self.cl.display.threshold)) then
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

    -- Mark the processed pixels
    local function markBlockAsProcessed(x, y, width, height)
        for i = x, x + width - 1 do
            processed[i] = processed[i] or {}
            for j = y, y + height - 1 do
                processed[i][j] = true
            end
        end
    end

    -- Merge adjacent pixels of the same color into larger blocks
    for x = 1, self.data.width do
        if self.cl.pixel.pixelData[x] then
            for y = 1, self.data.height do
                if self.cl.pixel.pixelData[x][y] and not (processed[x] and processed[x][y]) then
                    local color = self.cl.pixel.pixelData[x][y].color
                    local scale = self.cl.pixel.pixelData[x][y].scale

                    local maxWidth, maxHeight = findMaxDimensions(x, y, color, scale.x, scale.y)

                    -- Draw the new pixel
                    self:cl_drawPixel({
                        x = x,
                        y = y,
                        color = color,
                        scale = { x = maxWidth, y = maxHeight }
                    })

                    -- Mark the merged pixels as processed
                    markBlockAsProcessed(x, y, maxWidth, maxHeight)
                end
            end
        end
    end
end

-- Draws a line, uses draw pixel to draw final pixels
-- This uses Bresenham's line algorithm.
---@param params {x0: number, y0: number, x1: number, y1: number, color: Color} The parameters
function Display:cl_drawLine(params)
    -- Decode the parameters
    local x0 = params.x
    local y0 = params.y
    local x1 = params.x1
    local y1 = params.y1
    local color = params.color

    -- Calculate the differences and determine the direction of the line
    local dx = math.abs(x1 - x0)
    local dy = math.abs(y1 - y0)
    local sx = (x0 < x1) and 1 or -1
    local sy = (y0 < y1) and 1 or -1
    local err = dx - dy

    -- Iterate over each pixel along the line
    while true do
        -- Add the current pixel to the draw buffer
        self:cl_addToDraw({x = x0, y = y0, scale = {x = 1, y = 1}, color = color})

        -- Check if the end of the line is reached
        if x0 == x1 and y0 == y1 then
            break
        end

        -- Calculate error and move to the next pixel
        local e2 = 2 * err
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

---Draws a circle by using Bresenhams circle drawing algorithm
---@param params {x: number, y: number, radius: number, color: Color, isFilled: boolean} The parameters
function Display:cl_drawCircle(params)
    -- Decode the parameters
    local x = params.x
    local y = params.y
    local radius = params.radius
    local color = params.color
    local isFilled = params.isFilled

    -- Draw a pixel at a given position with scale
    local function drawPixel(px, py, scaleX, scaleY)
        self:cl_addToDraw({x = math.floor(px), y = math.floor(py), color = color, scale = {x = scaleX, y = scaleY}})
    end

    local f = 1 - radius -- The initial decision parameter for the midpoint circle algorithm
    local ddF_x = 1      -- The x differential of the decision parameter
    local ddF_y = -2 * radius -- The y differential of the decision parameter
    local cx = 0         -- The current x position on the circle's circumference
    local cy = radius    -- The current y position on the circle's circumference

    -- Draw the initial points or lines
    if isFilled then
        -- Draw a filled line across the diameter
        drawPixel(x - radius, y, radius * 2 + 1, 1)
    else
        -- Draw the initial outline points at the extreme points of the circle
        drawPixel(x, y + radius, 1, 1)
        drawPixel(x, y - radius, 1, 1)
        drawPixel(x + radius, y, 1, 1)
        drawPixel(x - radius, y, 1, 1)
    end

    -- Iterate over the circle's circumference using the midpoint algorithm
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
            -- Draw horizontal lines filling the circle
            drawPixel(x - cx, y + cy, cx * 2 + 1, 1)
            drawPixel(x - cx, y - cy, cx * 2 + 1, 1)
            drawPixel(x - cy, y + cx, cy * 2 + 1, 1)
            drawPixel(x - cy, y - cx, cy * 2 + 1, 1)
        else
            -- Draw the outline points of the circle
            drawPixel(x + cx, y + cy, 1, 1)
            drawPixel(x - cx, y + cy, 1, 1)
            drawPixel(x + cx, y - cy, 1, 1)
            drawPixel(x - cx, y - cy, 1, 1)
            drawPixel(x + cy, y + cx, 1, 1)
            drawPixel(x - cy, y + cx, 1, 1)
            drawPixel(x + cy, y - cx, 1, 1)
            drawPixel(x - cy, y - cx, 1, 1)
        end
    end
end

-- Draws a triangle, filled or not, uses draw pixel to draw final pixels
---@param params {x1: number, y1: number, x2: number, y2: number, x3: number, y3: number, color: Color, isFilled: boolean} The parameters
function Display:cl_drawTriangle(params)
    -- Decode the parameters
    local x1 = params.x1
    local y1 = params.y1
    local x2 = params.x2
    local y2 = params.y2
    local x3 = params.x3
    local y3 = params.y3
    local color = params.color
    local isFilled = params.isFilled

    -- Draw the outline by drawing lines between the vertices
    self:cl_drawLine({x = x1, y = y1, x1 = x2, y1 = y2, color = color})
    self:cl_drawLine({x = x2, y = y2, x1 = x3, y1 = y3, color = color})
    self:cl_drawLine({x = x3, y = y3, x1 = x1, y1 = y1, color = color})

    -- Check if the triangle needs to be filled
    if isFilled then
        -- Sort vertices based on y-coordinate to determine the top, middle, and bottom points
        local sortedPoints = {
            {x = params.x1, y = params.y1},
            {x = params.x2, y = params.y2},
            {x = params.x3, y = params.y3}
        }
        table.sort(sortedPoints, function(a, b) return a.y < b.y end)

        -- Assign the sorted vertices to variables
        local x0, y0 = sortedPoints[1].x, sortedPoints[1].y
        local x1, y1 = sortedPoints[2].x, sortedPoints[2].y
        local x2, y2 = sortedPoints[3].x, sortedPoints[3].y

        -- Function to interpolate between two points
        local function interpolate(x0, y0, x1, y1, x)
            return x0 + (x - y0) * (x1 - x0) / (y1 - y0)
        end

        -- Iterate through each scanline between the top and bottom points
        for y = y0, y2 do
            local xa, xb

            -- Calculate the interpolated x-values for the left and right edges of the triangle
            if y < y1 then
                xa = interpolate(x0, y0, x1, y1, y)
                xb = interpolate(x0, y0, x2, y2, y)
            else
                xa = interpolate(x1, y1, x2, y2, y)
                xb = interpolate(x0, y0, x2, y2, y)
            end

            -- Ensure xa is less than xb
            if xa > xb then xa, xb = xb, xa end

            -- Iterate through each pixel on the scanline
            for x = math.floor(xa), math.ceil(xb) do
                -- Check if x it is in-bounds
                if x > 0 and x <= self.data.width and y > 0 and y <= self.data.height then
                    -- Add it to the draw buffer
                    self:cl_addToDraw({x = x, y = y, color = color, scale = {x = 1, y = 1}})
                end
            end
        end
    end
end


-- Draws a cuboid, filled or not, uses draw pixel to draw final pixels
---@param params {x: number, y: number, width: number, height: number, color: Color, isFilled: boolean} The parameters
function Display:cl_drawRect(params)
    -- Decode the parameters
    local x = params.x
    local y = params.y
---@diagnostic disable-next-line: redefined-local
    local width = params.width
---@diagnostic disable-next-line: redefined-local
    local height = params.height
    local color = params.color
    local isFilled = params.isFilled

    -- Check it has to be filled
    if isFilled then
        -- Add it to self.cl.drawBuffer
        self:cl_addToDraw({x = x, y = y, color = color, scale = {x = width, y = height}})
    else
        -- Basicly do drawLine but cheaper
        self:cl_addToDraw({x = x,             y = y,              scale = {x = width, y = 1         }, color = color})
        self:cl_addToDraw({x = x + width - 1, y = y + 1,          scale = {x = 1    , y = height - 2}, color = color})
        self:cl_addToDraw({x = x,             y = y + 1,          scale = {x = 1    , y = height - 2}, color = color})
        self:cl_addToDraw({x = x,             y = y + height - 1, scale = {x = width, y = 1         }, color = color})
    end
end

-- Draws text, uses the font in ConfigFont.lua, uses draw pixel to draw final pixels
---@param params {x: number, y: number, string: string, color: Color, font: string} The parameters
function Display:cl_drawText(params)
    -- Get the font
    local font, err = sc.fontmanager.getFont(params.font)

    -- Check if it doesn't exist's
    if not font then
        -- Log the message
        sm.log.error("Fatal error! Failed to get the font! Error message: "..err)
        sm.gui.chatMessage("[#3A96DDS#3b78ffC#eeeeee]: A unexpected error occured trying to get a font!")

        -- Stop further execution since shit will break no-matter what.
        return
    end

    local xSpacing = 0 -- The x's spacing
    local ySpacing = 0 -- The y's spacing

    local i = 1 -- Character Index

    -- Loop through all characters
    while i <= #params.string do
        -- Get the UTF8 character
        local char = getUTF8Character(params.string, i)

        -- Check if it is a new line character
        if char == "\n" then
            -- Reset xSpacing and add ySpacing by fontHeight
            xSpacing = 0
            ySpacing = ySpacing + font.fontHeight
        else
            -- Get the character. If not found then be the error character
            local fontLetter = font.charset[char] or font.errorChar

            -- Check if it has to wrap around, if so then do the \n code
            if (params.x + xSpacing) + font.fontWidth > self.data.width then
                -- Reset xSpacing and add ySpacing by fontHeight
                xSpacing = 0
                ySpacing = ySpacing + font.fontHeight
            end

            -- Loop through all characters
            for yPosition, row in pairs(fontLetter) do
                for xPosition = 1, #row, 1 do
                    -- Check if it is a # (Aka a pixel)
                    if row:sub(xPosition, xPosition) == "#" then
                        -- Draw it to the drawing buffer
                        self:cl_addToDraw({x = params.x + xSpacing + (xPosition - 1), y = params.y + ySpacing + (yPosition - 1), color = params.color, scale = {x = 1, y = 1}})
                    end
                end

            end

            -- Add spacing to the xSpacing by fontWidth
            xSpacing = xSpacing + font.fontWidth
        end

        -- Increase i by #char (UTF8 is a pussy!)
        i = i + #char
    end
end

-- Clears display
---@param params [Color]
function Display:cl_clearDisplay(params)
    -- Get the color
    local color = params[1]

    -- Loop through all axis's
    for x, axis in pairs(self.cl.pixel.pixels) do
        -- Loop through all pixel effects inside the axis
        for y, effect in pairs(axis) do
            -- Check if it exist's
            if sm.exists(effect) then
                -- Get the effect data and stop it
                local effectData = self.cl.pixel.pixelData[x][y]
                self:cl_destroyEffect(effect, effectData)
            end
        end
    end

    -- Clear the pixels and the data
    self.cl.pixel.pixels = {}
    self.cl.pixel.pixelData = {}

    -- Updat the backpanel's color
    self.cl.backPannel.effect:setParameter("color",  color)

    -- Update the current color
    self.cl.backPannel.currentColor = color

    -- Play it again.
    self.cl.backPannel.effect:setAutoPlay(true)
    self.cl.backPannel.effect:start()
end

-- Loops through pixels to hide/show them
---@param params [boolean]
function Display:cl_setDisplayHidden(params)
    local setHidden = params[1]

    -- If setHidden isnt the same as the current state
    if setHidden ~= self.cl.display.isHidden then
        -- Update it
        self.cl.display.isHidden = setHidden

        -- Loop through all axis's
        for x, axis in pairs(self.cl.pixel.pixels) do
            -- Get all pixel's effects
            for y, effect in pairs(axis) do
                -- Check if it exist's
                if sm.exists(effect) then
                    -- Get effects data
                    local effectData = self.cl.pixel.pixelData[x][y]
                    -- Check if it should hide
                    if setHidden then
                        -- Stop the effect
                        self:cl_stopEffect(effect, effectData)
                    else
                        -- Start the effect
                        self:cl_startEffect(effect, effectData)
                    end
                end
            end
        end
    end
end

-- Starts an effect
---@param effect Effect The effect
---@param effectData {createdTick: number, lastStartedTick: number, lastStoppedTick: number, host: {x: number, y:number}, scale: {x: number, y:number}} The effect's data
function Display:cl_startEffect(effect, effectData)
    -- Get the current tick
    local tick = sm.game.getCurrentTick()

    local x, y = effectData.host.x, effectData.host.y

    -- Check if it exists
    if sm.exists(effect) then
        if not self.cl.startBuffer[effect.id] then
            -- Check if it is the correct pixel and is not playing
            if not effect:isPlaying() then
                -- Check if it is not hidden and the lastStoppedTick + 1 is lower than tick
                if not self.cl.display.isHidden and effectData.lastStoppedTick + 1 <= tick then
                    -- Start it
                    effect:start()
                    effect:setAutoPlay(true)

                    -- Update the lastStartedTick
                    self.cl.pixel.pixelData[x][y].lastStartedTick = tick
                else
                    -- Add it to startBuffer
                    self.cl.startBuffer[effect.id] = {x, y}
                end
            end
        end
    end
end

-- Stops an effect
---@param effect Effect The effect
---@param effectData {createdTick: number, lastStartedTick: number, lastStoppedTick: number, host: {x: number, y:number}, scale: {x: number, y:number}} The effect's data
function Display:cl_stopEffect(effect, effectData)
    -- Get the current tick
    local tick = sm.game.getCurrentTick()

    local x, y = effectData.host.x, effectData.host.y

    -- Check if it exists
    if sm.exists(effect) then
        if not self.cl.stopBuffer[effect.id] then
            -- Check if the effect is playing
            if effect:isPlaying() then
                -- Check if lastStartedTick + 1 is lower than tick
                if effectData.lastStartedTick + 1 <= tick then
                    -- Stop the bitch
                    effect:stop()
                    effect:setAutoPlay(false)

                    -- Update the bitch's data
                    self.cl.pixel.pixelData[x][y].lastStoppedTick = tick
                else
                    -- Add it to the STOP STOP FACKA buffer
                    self.cl.stopBuffer[effect.id] = {x, y}
                end
            end
        end
    end
end

-- Destroy's a effect from fucking life (Or remove it's life support)
---@param effect Effect The effect to delete
---@param effectData {createdTick: number, lastStartedTick: number, lastStoppedTick: number, host: {x: number, y:number}, scale: {x: number, y:number}} The data for the deleted effect
function Display:cl_destroyEffect(effect, effectData)
    -- Check if the effect exists
    if sm.exists(effect) then
        if not self.cl.destroyBuffer[effect.id] then
            -- Get current tick
            local tick = sm.game.getCurrentTick()

            -- Get the created, lastStarted and lastStopped Tick
            local created = effectData.createdTick
            local lastStarted = effectData.lastStartedTick
            local lastStopped = effectData.lastStoppedTick

            -- Check if it is allowed to destroy by checking if the next tick of createdTick is higher than sm.game.getCurrentTick
            if created + 1 <= tick and lastStarted + 1 <= tick and lastStopped + 1 <= tick then
                self.cl.startBuffer[effect.id] = nil
                self.cl.stopBuffer[effect.id] = nil

                effect:destroy() -- Destroy it
            else
                --effect:stop() -- stop effect to avoid the pixels ghosting
                --effect:setAutoPlay(false)

                -- Add it to the buffer
                self.cl.destroyBuffer[effect.id] = {effect, created, lastStarted, lastStopped}
            end

            -- Check if theres data
            if effectData then
                local x, y = effectData.host.x, effectData.host.y
                -- Check if it isn't 1x1
                if effectData.scale.x ~= 1 or effectData.scale.y ~= 1 then
                    -- Loop through from x to (x + EffectData's scale's x - 1)
                    for x1 = x, x + effectData.scale.x - 1 do
                        -- Loop through from y to (y + EffectData's scale's y - 1)
                        for y1 = y, y + effectData.scale.y - 1 do
                            -- Set the pixels and data to nil
                            self.cl.pixel.pixels[x1][y1] = nil
                            self.cl.pixel.pixelData[x1][y1] = nil
                        end
                    end
                else
                    -- Wipe its ass like what your maid does to you (you pervert)
                    self.cl.pixel.pixels[x][y] = nil
                    self.cl.pixel.pixelData[x][y] = nil
                end
            end
        end
    end
end

-- Convert the class to a component
dofile("$CONTENT_DATA/Scripts/ComponentManager.lua")
sc.componentManager.ToComponent(Display, "Displays", true)