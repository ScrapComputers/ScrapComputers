-- Hopefully i can reimplement this in a less shittier way. This is absolutely discusting and must die.
--      - VeraDev

-- Had to fix this code because Vera is a noob
--      - Ben Bingo


local sm_scrapcomputers_errorHandler_assertArgument  = sm.scrapcomputers.errorHandler.assertArgument
local sm_scrapcomputers_errorHandler_assert          = sm.scrapcomputers.errorHandler.assert
local sm_scrapcomputers_languageManager_translatable = nil
local sm_scrapcomputers_utf8_getCharacterAt          = sm.scrapcomputers.utf8.getCharacterAt
local sm_color_new                                   = sm.color.new
local math_floor                                     = math.floor
local math_abs                                       = math.abs
local table_sort                                     = table.sort
local type                                           = type
local math_huge                                      = math.huge
local string_sub                                     = string.sub
local string_byte                                    = string.byte
local sm_util_clamp                                  = sm.util.clamp
local bit_bor                                        = bit.bor
local bit_band                                       = bit.band
local bit_lshift                                     = bit.lshift
local bit_rshift                                     = bit.rshift

---Virtual displays enable the emulation of additional screens, allowing you to create fake displays in any resolution.
sm.scrapcomputers.virtualdisplay = {}
sm.scrapcomputers.backend.virtualDisplayCache = {}

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

local function areColorsSimilar(color1, color2, threshold)
    local isSame = color1 == color2

    if isSame then
        return true
    end
    
    if threshold == 0 then 
        return isSame
    end
    
    local r1, g1, b1 = bit_band(bit_rshift(color1, 16), 255), bit_band(bit_rshift(color1, 8), 255), bit_band(color1, 255) 
    local r2, g2, b2 = bit_band(bit_rshift(color2, 16), 255), bit_band(bit_rshift(color2, 8), 255), bit_band(color2, 255) 
    
    local dr, dg, db = r1 - r2, g1 - g2, b1 - b2 
    
    return (dr * dr + dg * dg + db * db) <= (threshold * 255)^2 * 3 
end

local function idToColor(colorID)
    local scale = 1 / 255

    return sm_color_new(
        bit_band(bit_rshift(colorID, 16), 0xFF) * scale,
        bit_band(bit_rshift(colorID, 8), 0xFF) * scale,
        bit_band(colorID, 0xFF) * scale
    )
end

local function coordinateToIndex(x, y, width)
    return (y - 1) * width + x
end

local function round(numb)
    return math_floor(numb + 0.5)
end

local function scaledAdd(x, y, sx, sy, color, drawBuffer, width)
    local x1, y1 = x, y
    local mx = sx + x - 1

    for _ = 1, sx * sy do
        drawBuffer[coordinateToIndex(x1, y1, width)] = color

        x1 = x1 + 1
    
        if x1 > mx then
            x1 = x
            y1 = y1 + 1
        end
    end
end

local function drawLine(x0, y0, x1, y1, color, drawBuffer, width, height)
    local dx = math_abs(x1 - x0)
    local dy = math_abs(y1 - y0)
    local sx = (x0 < x1) and 1 or -1
    local sy = (y0 < y1) and 1 or -1
    local err = dx - dy

    while true do
        drawBuffer[coordinateToIndex(x0, y0, width)] = color

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

local function drawCircle(x, y, radius, color, isFilled , drawBuffer, width, height)
    local f = 1 - radius
    local ddF_x = 1
    local ddF_y = -2 * radius
    local cx = 0
    local cy = radius

    if isFilled then
        scaledAdd(x - radius, y, radius * 2 + 1, 1, color, width)
    else
        drawBuffer[coordinateToIndex(x, y + radius, width)] = color
        drawBuffer[coordinateToIndex(x, y - radius, width)] = color
        drawBuffer[coordinateToIndex(x + radius, y, width)] = color
        drawBuffer[coordinateToIndex(x - radius, y, width)] = color
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
            scaledAdd(x - cx, y + cy, cx * 2 + 1, 1, color, drawBuffer, width)
            scaledAdd(x - cy, y + cx, cy * 2 + 1, 1, color, drawBuffer, width)

            scaledAdd(x - cx, y - cy, cx * 2 + 1, 1, color, drawBuffer, width)
            scaledAdd(x - cy, y - cx, cy * 2 + 1, 1, color, drawBuffer, width)
        else
            drawBuffer[coordinateToIndex(x + cx, y + cy, width)] = color
            drawBuffer[coordinateToIndex(x - cx, y + cy, width)] = color
            drawBuffer[coordinateToIndex(x + cx, y - cy, width)] = color
            drawBuffer[coordinateToIndex(x - cx, y - cy, width)] = color
            drawBuffer[coordinateToIndex(x + cy, y + cx, width)] = color
            drawBuffer[coordinateToIndex(x - cy, y + cx, width)] = color
            drawBuffer[coordinateToIndex(x + cy, y - cx, width)] = color
            drawBuffer[coordinateToIndex(x - cy, y - cx, width)] = color
        end
    end
end

local function drawTriangle(x1, y1, x2, y2, x3, y3, color, isFilled, drawBuffer, width, height)
    drawLine(x1, y1, x2, y2, color, drawBuffer, width, height)
    drawLine(x2, y2, x3, y3, color, drawBuffer, width, height)
    drawLine(x3, y3, x1, y1, color, drawBuffer, width, height)

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
                    drawBuffer[coordinateToIndex(x, y, width)] = color
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
    

local function drawRect(x, y, rWidth, rHeight, color, isFilled, drawBuffer, width, height)
    if rWidth == 1 and rHeight == 1 then
        drawBuffer[coordinateToIndex(x, y, width)] = color
        return
    end

    if isFilled then
        scaledAdd(x, y, rWidth, rHeight, color, drawBuffer, width)
        return
    end

    scaledAdd(x, y, rWidth, 1, color, drawBuffer, width)
    scaledAdd(x + rWidth - 1, y + 1, 1, rHeight - 2, color, drawBuffer, width)
    scaledAdd(x, y + 1, 1, rHeight - 2, color, drawBuffer, width)
    scaledAdd(x, y + rHeight - 1, rWidth, 1,  color, drawBuffer, width)
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

-- Yes, this is negative and will only go into negatives, so it's seperated with actual displays.
-- Displays have camera cache built-in to them, so we can imitate a display by doing this.
local idDisplayCounter = -1

---Creates a virtual display
---@param displayWidth integer The width of the virtual display
---@param displayHeight integer The height of the virtual display
---@return VirtualDisplay virtualDisplay The created virtual display
function sm.scrapcomputers.virtualdisplay.new(displayWidth, displayHeight)
    sm_scrapcomputers_languageManager_translatable = sm.scrapcomputers.languageManager.translatable
    
    sm_scrapcomputers_errorHandler_assertArgument(displayWidth, 1, { "integer" })
    sm_scrapcomputers_errorHandler_assertArgument(displayHeight, 2, { "integer" })

    local sm_scrapcomputers_fontManager_getDefaultFontName = sm.scrapcomputers.fontManager.getDefaultFontName
    local sm_scrapcomputers_fontManager_getFont            = sm.scrapcomputers.fontManager.getFont

    local output = {}
    local drawBuffer = {}

    local displayID = idDisplayCounter
    idDisplayCounter = idDisplayCounter - 1

    local clearColor = 0
    local clearCache

    local optimisationThreshold = 0.02

    local lastOffsetX = 0
    local lastOffsetY = 0

    if sm.scrapcomputers.backend.cameraColorCache[displayID] then
        sm.scrapcomputers.backend.cameraColorCache[displayID] = nil
    end

    -- Super duper cool camera only function, (and maybe addon posibilities)
    sm.scrapcomputers.backend.displayCameraDraw[displayID] = function(x, y, color)
        drawBuffer[(y - 1) * displayWidth + x] = color
    end

    output.drawPixel = function(x, y, color)
        sm_scrapcomputers_errorHandler_assertArgument(x, 1, { "number" })
        sm_scrapcomputers_errorHandler_assertArgument(y, 2, { "number" })

        drawBuffer[coordinateToIndex(round(x), round(y), displayWidth)] = colorToID(color)
        clearCache = true
    end

    output.drawFromTable = function(tbl)
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
        
            drawBuffer[coordinateToIndex(round(pixel_x), round(pixel_y), displayWidth)] = colorToID(pixel_color)
        end

        clearCache = true
    end

    output.clear = function(color)
        drawBuffer = {}
        clearColor = colorToID(color)
        clearCache = true

        sm.scrapcomputers.backend.virtualDisplayCache[displayID] = {}
    end

    output.drawLine = function(x, y, x1, y1, color)
        sm_scrapcomputers_errorHandler_assertArgument(x, 1, {"number"})
        sm_scrapcomputers_errorHandler_assertArgument(y, 2, {"number"})

        sm_scrapcomputers_errorHandler_assertArgument(x1, 3, {"number"})
        sm_scrapcomputers_errorHandler_assertArgument(y1, 4, {"number"})

        drawLine(round(x), round(y), round(x1), round(y1), colorToID(color), drawBuffer, displayWidth, displayHeight) 
        clearCache = true
    end

    output.drawFilledCircle = function (x, y, radius, color)
        sm_scrapcomputers_errorHandler_assertArgument(x, 1, {"number"})
        sm_scrapcomputers_errorHandler_assertArgument(y, 2, {"number"})
        sm_scrapcomputers_errorHandler_assertArgument(radius, 3, {"number"})

        drawCircle(round(x), round(y), round(radius), colorToID(color), true, drawBuffer, displayWidth, displayHeight) 
        clearCache = true
    end

    output.drawCircle = function (x, y, radius, color)
        sm_scrapcomputers_errorHandler_assertArgument(x, 1, {"number"})
        sm_scrapcomputers_errorHandler_assertArgument(y, 2, {"number"})
        sm_scrapcomputers_errorHandler_assertArgument(radius, 3, {"number"})
        
        drawCircle(round(x), round(y), round(radius), colorToID(color), false, drawBuffer, displayWidth, displayHeight) 
        clearCache = true
    end

    output.drawFilledTriangle = function (x1, y1, x2, y2, x3, y3, color)
        sm_scrapcomputers_errorHandler_assertArgument(x1, 1, {"number"})
        sm_scrapcomputers_errorHandler_assertArgument(y1, 2, {"number"})
        sm_scrapcomputers_errorHandler_assertArgument(x2, 3, {"number"})
        sm_scrapcomputers_errorHandler_assertArgument(y2, 4, {"number"})
        sm_scrapcomputers_errorHandler_assertArgument(x3, 5, {"number"})
        sm_scrapcomputers_errorHandler_assertArgument(y3, 6, {"number"})

        drawTriangle(round(x1), round(y1), round(x2), round(y2), round(x3), round(y3), colorToID(color), true, drawBuffer, displayWidth, displayHeight) 
        clearCache = true  
    end

    output.drawTriangle = function (x1, y1, x2, y2, x3, y3, color)
        sm_scrapcomputers_errorHandler_assertArgument(x1, 1, {"number"})
        sm_scrapcomputers_errorHandler_assertArgument(y1, 2, {"number"})
        sm_scrapcomputers_errorHandler_assertArgument(x2, 3, {"number"})
        sm_scrapcomputers_errorHandler_assertArgument(y2, 4, {"number"})
        sm_scrapcomputers_errorHandler_assertArgument(x3, 5, {"number"})
        sm_scrapcomputers_errorHandler_assertArgument(y3, 6, {"number"})

        drawTriangle(round(x1), round(y1), round(x2), round(y2), round(x3), round(y3), colorToID(color), false, drawBuffer, displayWidth, displayHeight) 
        clearCache = true
    end

    output.drawFilledRect = function(x, y, rWidth, rHeight, color)
        sm_scrapcomputers_errorHandler_assertArgument(x, 1, {"number"})
        sm_scrapcomputers_errorHandler_assertArgument(y, 2, {"number"})

        sm_scrapcomputers_errorHandler_assertArgument(rWidth, 3, {"number"})
        sm_scrapcomputers_errorHandler_assertArgument(rHeight, 4, {"number"})

        drawRect(round(x), round(y), round(rWidth), round(rHeight), colorToID(color), true, drawBuffer, displayWidth, displayHeight) 
        clearCache = true
    end

    output.drawRect = function(x, y, rWidth, rHeight, color)
        sm_scrapcomputers_errorHandler_assertArgument(x, 1, {"number"})
        sm_scrapcomputers_errorHandler_assertArgument(y, 2, {"number"})

        sm_scrapcomputers_errorHandler_assertArgument(rWidth, 3, {"number"})
        sm_scrapcomputers_errorHandler_assertArgument(rHeight, 4, {"number"})

        drawRect(round(x), round(y), round(rWidth), round(rHeight), colorToID(color), false, drawBuffer, displayWidth, displayHeight) 
        clearCache = true
    end

    output.drawWithPoints = function (points, color)
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

        drawWithPoints(points, colorToID(color))

        clearCache = true
    end

    output.drawText = function (params_x, params_y, params_text, params_color, params_font, params_maxWidth, params_wordWrappingEnabled)
        sm_scrapcomputers_errorHandler_assertArgument(params_x, 1, {"number"})
        sm_scrapcomputers_errorHandler_assertArgument(params_y, 2, {"number"})

        sm_scrapcomputers_errorHandler_assertArgument(params_text, 3, {"string", "number"})
        sm_scrapcomputers_errorHandler_assertArgument(params_color, 4, {"Color", "string", "nil"})
        
        sm_scrapcomputers_errorHandler_assertArgument(params_font, 5, {"string", "nil"})

        sm_scrapcomputers_errorHandler_assertArgument(params_maxWidth, 5, {"boolean", "nil"})
        sm_scrapcomputers_errorHandler_assertArgument(params_wordWrappingEnabled, 5, {"boolean", "nil"})
        
        params_font = params_font or sm_scrapcomputers_fontManager_getDefaultFontName()
    
        local font, errMsg = sm_scrapcomputers_fontManager_getFont(params_font)
        sm_scrapcomputers_errorHandler_assert(font, 5, errMsg)

        params_x = round(params_x)
        params_y = round(params_y)
        params_text = tostring(params_text)

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

        local width = params_maxWidth and round(params_maxWidth) or width

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

                            drawBuffer[coordinateToIndex(x, y, displayWidth)] = colorToID(params_color)
                        end
                    end

                end

                xSpacing = xSpacing + font_width
            end

            i = i + #char
        end

        clearCache = true
    end

    output.loadImage = function (width, height, path)
        sm_scrapcomputers_errorHandler_assertArgument(width, 1, {"integer"})
        sm_scrapcomputers_errorHandler_assertArgument(height, 2, {"integer"})
        sm_scrapcomputers_errorHandler_assertArgument(path, 3, {"string"})

        local fileLocation = customSearch and path or imagePath..path
        sm_scrapcomputers_errorHandler_assert(sm.json.fileExists(fileLocation), 3, "Image doesnt exist")

        local imageTbl = sm.json.open(fileLocation)
        local x, y = 1, 1
        
        for i = 1, #imageTbl do
            local color = imageTbl[i]
            drawBuffer[coordinateToIndex(x, y, displayWidth)] = colorToID(color)

            y = y + 1

            if y > height then
                y = 1
                x = x + 1
            end
        end

        clearCache = true
    end

    output.getDimensions = function ()
        return displayWidth, displayHeight
    end

    output.render = function (xOffset, yOffset, cacheBased)
        sm_scrapcomputers_errorHandler_assertArgument(xOffset, 1, {"number", "nil"})
        sm_scrapcomputers_errorHandler_assertArgument(yOffset, 2, {"number", "nil"})
        sm_scrapcomputers_errorHandler_assertArgument(cacheBased, 3, {"boolean", "nil"})

        xOffset = xOffset or 0
        yOffset = yOffset or 0

        local formatted = {}
        local index = 1

        if cacheBased and lastOffsetX == xOffset and lastOffsetY == yOffset then
            local cache = sm.scrapcomputers.backend.virtualDisplayCache[displayID] or {}

            for dIndex, color in pairs(drawBuffer) do
                local cachePoint = cache[dIndex]

                if not cachePoint or not areColorsSimilar(cachePoint, color, optimisationThreshold) then
                    formatted[index] = {x = (dIndex - 1) % displayWidth + 1 + xOffset, y = math_floor((dIndex - 1) / displayWidth) + 1 + yOffset, color = idToColor(color)}
                    index = index + 1

                    cache[dIndex] = color
                end
            end

            sm.scrapcomputers.backend.virtualDisplayCache[displayID] = cache
        else
            lastOffsetX = xOffset
            lastOffsetY = yOffset

            for i = 1, displayWidth * displayHeight do
                local color = drawBuffer[i]

                if not color then 
                    drawBuffer[i] = clearColor 
                end
                
                formatted[index] = {x = (i - 1) % displayWidth + 1 + xOffset, y = math_floor((i - 1) / displayWidth) + 1 + yOffset, color = idToColor(color or clearColor)}
                index = index + 1
            end

            sm.scrapcomputers.backend.virtualDisplayCache[displayID] = {}
        end

        if clearCache and sm.scrapcomputers.backend.cameraColorCache then
            sm.scrapcomputers.backend.cameraColorCache[displayID] = nil

            clearCache = nil
        end

        return formatted
    end

    output.getId = function ()
        return displayID
    end

    output.calcTextSize = function (text, font, maxWidth, wordWrappingEnabled, dynamicHeight)
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

        local stringSize = sm.scrapcomputers.utf8.getStringSize(text)

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
    end

    output.setDimensions = function (newWidth, newHeight)
        sm_scrapcomputers_errorHandler_assertArgument(newWidth, 1, { "integer" })
        sm_scrapcomputers_errorHandler_assertArgument(newHeight, 2, { "integer" })

        local newBuffer = {}
        local newCache = {}
        local currentCache = sm.scrapcomputers.backend.virtualDisplayCache[displayID]

        for i, color in pairs(drawBuffer) do
            if i <= newWidth * newHeight then
                local x, y = (i - 1) % displayWidth + 1, math_floor((i - 1) / displayWidth) + 1
                newBuffer[(y - 1) * newWidth + x] = color
            end
        end

        drawBuffer = newBuffer

        if currentCache then
            for i, color in pairs(currentCache) do
                if i <= newWidth * newHeight then
                    local x, y = (i - 1) % displayWidth + 1, math_floor((i - 1) / displayWidth) + 1
                    newCache[(y - 1) * newWidth + x] = color
                end
            end

            sm.scrapcomputers.backend.virtualDisplayCache[displayID] = newCache
        end

        displayWidth = newWidth
        displayHeight = newHeight
    end

    output.setOptimizationThreshold = function (threshold)
        sm_scrapcomputers_errorHandler_assertArgument(threshold, 1, { "number" })
        optimisationThreshold = threshold
    end

    output.getOptimizationThreshold = function ()
        return optimisationThreshold
    end

    output.clearCache = function ()
        sm.scrapcomputers.backend.virtualDisplayCache[displayID] = {}

        if sm.scrapcomputers.backend.cameraColorCache[displayID] then
            sm.scrapcomputers.backend.cameraColorCache[displayID] = nil
        end
    end

    sm.scrapcomputers.ascfManager.applyDisplayFunctions(output)
    
    return output
end