-- Hopefully i can reimplement this in a less shittier way. This is absolutely discusting and must die.
--      - VeraDev


local sm_scrapcomputers_errorHandler_assertArgument = sm.scrapcomputers.errorHandler.assertArgument
local sm_scrapcomputers_errorHandler_assert         = sm.scrapcomputers.errorHandler.assert
local sm_color_new                                  = sm.color.new
local math_floor                                    = math.floor
local math_abs                                      = math.abs
local table_sort                                    = table.sort
local type                                          = type
local math_huge                                     = math.huge
local string_sub                                    = string.sub
local string_byte                                   = string.byte
local sm_util_clamp                                 = sm.util.clamp

local sm_scrapcomputers_backend_cameraColorCache = sm.scrapcomputers.backend.cameraColorCache

---Virtual displays enable the emulation of additional screens, allowing you to create fake displays in any resolution.
sm.scrapcomputers.virtualdisplay = {}

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

local function scaledAdd(params, drawBuffer)
    for x = params.x, params.x + params.scale.x - 1, 1 do
        for y = params.y, params.y + params.scale.y - 1, 1 do
            drawBuffer[#drawBuffer+1] = {
                x     = x,
                y     = y,
                color = params.color
            }
        end
    end
end

local function drawCircle(x, y, radius, color, isFilled, drawBuffer, displayWidth, displayHeight)
    sm_scrapcomputers_errorHandler_assertArgument(x, 1, {"number"})
    sm_scrapcomputers_errorHandler_assertArgument(y, 2, {"number"})
    sm_scrapcomputers_errorHandler_assertArgument(radius, 3, {"number"})
    sm_scrapcomputers_errorHandler_assertArgument(color, 4, {"Color", "string"})

    sm_scrapcomputers_errorHandler_assert(radius, 3, "Radius is too small!")

    color = type(color) == "string" and sm_color_new(color) or color

    local f = 1 - radius
    local ddF_x = 1
    local ddF_y = -2 * radius
    local cx = 0
    local cy = radius

    local function plot(xp, yp)
        if xp >= 1 and xp <= displayWidth and yp >= 1 and yp <= displayHeight then
            drawBuffer[#drawBuffer+1] = {
                x     = xp,
                y     = yp,
                color = color
            }
        end
    end

    if isFilled then
        scaledAdd({x = x - radius, y = y, scale = {x = radius * 2 + 1, y = 1}, color = color}, drawBuffer)
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
            scaledAdd({x = x - cx, y = y + cy, scale = {x = cx * 2 + 1, y = 1}, color = color}, drawBuffer)
            scaledAdd({x = x - cy, y = y + cx, scale = {x = cy * 2 + 1, y = 1}, color = color}, drawBuffer)

            scaledAdd({x = x - cx, y = y - cy, scale = {x = cx * 2 + 1, y = 1}, color = color}, drawBuffer)
            scaledAdd({x = x - cy, y = y - cx, scale = {x = cy * 2 + 1, y = 1}, color = color}, drawBuffer)
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

local function drawLine(x0, y0, x1, y1, color, drawBuffer, displayWidth, displayHeight)
    sm_scrapcomputers_errorHandler_assertArgument(x0, 1, { "number" })
    sm_scrapcomputers_errorHandler_assertArgument(y0, 2, { "number" })

    sm_scrapcomputers_errorHandler_assertArgument(x1, 3, { "number" })
    sm_scrapcomputers_errorHandler_assertArgument(y1, 4, { "number" })

    sm_scrapcomputers_errorHandler_assertArgument(color, 5, { "Color", "string" })

    color = type(color) == "string" and sm_color_new(color) or color

    local dx = math_abs(x1 - x0)
    local dy = math_abs(y1 - y0)
    local sx = (x0 < x1) and 1 or -1
    local sy = (y0 < y1) and 1 or -1
    local err = dx - dy

    while true do
        if x0 > 0 and y0 > 0 and x0 <= displayWidth and y0 <= displayHeight then
            drawBuffer[#drawBuffer+1] = {
                x     = x0,
                y     = y0,
                color = color
            }
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

local function drawTriangle(x1, y1, x2, y2, x3, y3, color, isFilled, drawBuffer, displayWidth, displayHeight)
    sm_scrapcomputers_errorHandler_assertArgument(x1, 1, {"number"})
    sm_scrapcomputers_errorHandler_assertArgument(y1, 2, {"number"})
    sm_scrapcomputers_errorHandler_assertArgument(x2, 3, {"number"})
    sm_scrapcomputers_errorHandler_assertArgument(y2, 4, {"number"})
    sm_scrapcomputers_errorHandler_assertArgument(x3, 5, {"number"})
    sm_scrapcomputers_errorHandler_assertArgument(y3, 6, {"number"})

    sm_scrapcomputers_errorHandler_assertArgument(color, 7, {"Color", "string"})

    color = type(color) == "string" and sm_color_new(color) or color

    drawLine(x1, y1, x2, y2, color, drawBuffer, displayWidth, displayHeight)
    drawLine(x2, y2, x3, y3, color, drawBuffer, displayWidth, displayHeight)
    drawLine(x3, y3, x1, y1, color, drawBuffer, displayWidth, displayHeight)

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
                if x >= 1 and x <= displayWidth and y >= 1 and y <= displayHeight then
                    drawBuffer[#drawBuffer+1] = {
                        x     = x,
                        y     = y,
                        color = type(color) == "string" and sm_color_new(color) or color
                    }
                end
            end
        end
    end
end

local function drawRect(x, y, width, height, color, isFilled, drawBuffer)
    sm_scrapcomputers_errorHandler_assertArgument(x, 1, {"number"})
    sm_scrapcomputers_errorHandler_assertArgument(y, 2, {"number"})
    sm_scrapcomputers_errorHandler_assertArgument(width, 3, {"number"})
    sm_scrapcomputers_errorHandler_assertArgument(height, 4, {"number"})
    
    sm_scrapcomputers_errorHandler_assertArgument(color, 5, {"Color", "string"})

    color = type(color) == "string" and sm_color_new(color) or color

    if isFilled then
        scaledAdd({x = x, y = y, color = color, scale = {x = width, y = height}}, drawBuffer)
    end

    scaledAdd({x = x, y = y, scale = {x = width, y = 1}, color = color}, drawBuffer)
    scaledAdd({x = x + width - 1, y = y + 1, scale = {x = 1, y = height - 2}, color = color}, drawBuffer)
    scaledAdd({x = x, y = y + 1, scale = {x = 1, y = height - 2}, color = color}, drawBuffer)
    scaledAdd({x = x, y = y + height - 1, scale = {x = width, y = 1}, color = color}, drawBuffer)
end

-- Yes, this is negative and will only go into negatives, so it's seperated with actual displays.
-- Displays have camera cache built-in to them. Thanks
local idDisplayCounter = -1

---Creates a virtual display
---@param displayWidth integer The width of the virtual display
---@param displayHeight integer The height of the virtual display
---@return VirtualDisplay virtualDisplay The created virtual display
function sm.scrapcomputers.virtualdisplay.new(displayWidth, displayHeight)
    sm_scrapcomputers_errorHandler_assertArgument(displayWidth, 1, { "integer" })
    sm_scrapcomputers_errorHandler_assertArgument(displayHeight, 2, { "integer" })

    local sm_scrapcomputers_fontManager_getDefaultFontName = sm.scrapcomputers.fontManager.getDefaultFontName
    local sm_scrapcomputers_fontManager_getFont            = sm.scrapcomputers.fontManager.getFont

    local output = {}
    local drawBuffer = {}

    local displayID = idDisplayCounter
    idDisplayCounter = idDisplayCounter - 1

    local clearColor = nil

    output.drawPixel = function(x, y, color)
        sm_scrapcomputers_errorHandler_assertArgument(x, 1, { "number" })
        sm_scrapcomputers_errorHandler_assertArgument(y, 2, { "number" })

        if x < 1 or x > displayWidth or y < 1 or y > displayHeight then return end

        sm_scrapcomputers_errorHandler_assertArgument(color, 3, { "Color", "string" })

        color = type(color) == "string" and sm_color_new(color) or color

        drawBuffer[#drawBuffer + 1] = {
            x     = x,
            y     = y,
            color = color
        }
    end

    output.drawFromTable = function(tbl)
        sm_scrapcomputers_errorHandler_assertArgument(tbl, nil, { "table" }, { "PixelTable" })

        for i, pixel in pairs(tbl) do
            local pixel_x = pixel.x
            local pixel_y = pixel.y
            local pixel_color = pixel.color

            local xType = type(pixel_x)
            local yType = type(pixel_y)
            local colorType = type(pixel_color)

            sm_scrapcomputers_errorHandler_assert(pixel_x and pixel_y and pixel_color, "missing data at index " .. i ..
            ".")

            sm_scrapcomputers_errorHandler_assert(xType == "number", nil,
                "bad x value at index " .. i .. ". Expected number. Got " .. xType .. " instead!")
            sm_scrapcomputers_errorHandler_assert(yType == "number", nil,
                "bad y value at index " .. i .. ". Expected number. Got " .. yType .. " instead!")
            sm_scrapcomputers_errorHandler_assert(colorType == "Color" or colorType == "string", nil,
                "bad color at index " .. i .. ". Expected Color or string. Got " .. colorType .. " instead!")

            drawBuffer[#drawBuffer + 1] = {
                x     = pixel_x,
                y     = pixel_y,
                color = type(pixel_color) == "string" and sm_color_new(pixel_color) or pixel_color
            }
        end
    end

    output.clear = function(color)
        sm_scrapcomputers_errorHandler_assertArgument(color, nil, { "Color", "string", "nil" })

        if sm_scrapcomputers_backend_cameraColorCache then
            sm_scrapcomputers_backend_cameraColorCache[displayID] = nil
        end

        drawBuffer = {}
        clearColor = color and (type(color) == "string" and sm_color_new(color) or color) or nil
    end

    output.drawLine = function(x, y, x1, y1, color) drawLine(x, y, x1, y1, color, drawBuffer, displayWidth, displayHeight) end

    output.drawFilledCircle = function (x, y, radius, color) drawCircle(x, y, radius, color, true , drawBuffer, displayWidth, displayHeight) end
    output.drawCircle       = function (x, y, radius, color) drawCircle(x, y, radius, color, false, drawBuffer, displayWidth, displayHeight) end

    output.drawFilledTriangle = function (x1, y1, x2, y2, x3, y3, color) drawTriangle(x1, y1, x2, y2, x3, y3, color, true , drawBuffer, displayWidth, displayHeight) end
    output.drawTriangle       = function (x1, y1, x2, y2, x3, y3, color) drawTriangle(x1, y1, x2, y2, x3, y3, color, false, drawBuffer, displayWidth, displayHeight) end

    output.drawFilledRect = function(x, y, width, height, color) drawRect(x, y, width, height, color, true , drawBuffer) end
    output.drawRect       = function(x, y, width, height, color) drawRect(x, y, width, height, color, false, drawBuffer) end

    output.drawText = function (x, y, text, color, fontName, maxWidth, wordWrappingEnabled)
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

        local xSpacing = 0
        local ySpacing = 0
        
        local i = 1
        
        local width = maxWidth or displayWidth
        
        if not wordWrappingEnabled then
            width = math_huge
        end
    
        while i <= #text do
            local char = getUTF8Character(text, i)
        
            if char == "\n" then
                xSpacing = 0
                ySpacing = ySpacing + font.fontHeight
            else
                local fontLetter = font.charset[char] or font.errorChar
            
                if (x + xSpacing) + font.fontWidth > width then
                    x = 0
                    ySpacing = ySpacing + font.fontHeight
                end
            
                for yPosition, row in pairs(fontLetter) do
                    for xPosition = 1, #row, 1 do
                        if row:sub(xPosition, xPosition) == "#" then
                            drawBuffer[#drawBuffer+1] = {
                                x = x + xSpacing + (xPosition - 1),
                                y = x + ySpacing + (yPosition - 1),
                                color = color
                            }
                        end
                    end
                
                end
            
                xSpacing = xSpacing + font.fontWidth
            end
        
            i = i + #char
        end
    end

    output.loadImage = function (width, height, path)
        sm_scrapcomputers_errorHandler_assertArgument(width, 1, {"integer"})
        sm_scrapcomputers_errorHandler_assertArgument(height, 2, {"integer"})

        sm_scrapcomputers_errorHandler_assertArgument(path, 3, {"string"})

        local fileLocation = imagePath..path
        sm_scrapcomputers_errorHandler_assert(sm.json.fileExists(fileLocation), 3, "Image doesnt exist")

        local imageTbl = sm.json.open(fileLocation)
        local x, y = 1, 1

        for i, color in pairs(imageTbl) do
            local rgb = sm_color_new(color)
            output.drawPixel(x, y, rgb)

            y = y + 1

            if y > height then
                y = 1
                x = x + 1
            end
        end
    end

    output.getDimensions = function ()
        return displayWidth, displayHeight
    end

    output.render = function (xOffset, yOffset)
        -- Yes, this is complicated but this is to save table storage improving performace because this will be sended over
        -- the network.
        --
        -- If your wondering, Ive tried 2D greedy meshing, was no fps diffierence back then but this fucking madlad (Ben Bingo)
        -- made it not needed. So i don't even have to optimize this!

        sm_scrapcomputers_errorHandler_assertArgument(xOffset, 1, {"number", "nil"})
        sm_scrapcomputers_errorHandler_assertArgument(yOffset, 2, {"number", "nil"})

        xOffset = xOffset or 0
        yOffset = yOffset or 0
        
        local matrixBuffer = {} -- Woohoo! 2D Matrixes!
        for _, pixel in pairs(drawBuffer) do
            matrixBuffer[pixel.x] = matrixBuffer[pixel.x] or {}
            matrixBuffer[pixel.x][pixel.y] = pixel.color
        end

        drawBuffer = {}

        local trueOutput = {}
        for x = 1, displayWidth, 1 do
            for y = 1, displayHeight, 1 do
                -- Jank, but this entire script is already full of spaggeti, so do i care??
                if not (not clearColor and not (matrixBuffer[x] and matrixBuffer[x][y])) then
                    local isSafe = true

                    if x < 1 or x > displayWidth then
                        isSafe = false
                    end

                    if y < 1 or y > displayHeight then
                        isSafe = false
                    end
                    
                    if isSafe then
                        trueOutput[#trueOutput+1] = {
                            x     = x + xOffset,
                            y     = y + yOffset,
                            color = (matrixBuffer[x] and matrixBuffer[x][y]) and matrixBuffer[x][y] or clearColor
                        }
                    end
                end
            end
        end

        return trueOutput
    end

    output.getId = function ()
        return displayID
    end

    output.calcTextSize = function (text, font, maxWidth, wordWrappingEnabled)
        sm_scrapcomputers_errorHandler_assertArgument(text, 1, {"string"})
        sm_scrapcomputers_errorHandler_assertArgument(font, 2, {"string", "nil"})
        sm_scrapcomputers_errorHandler_assertArgument(maxWidth, 1, {"integer", "nil"})
        sm_scrapcomputers_errorHandler_assertArgument(wordWrappingEnabled, 2, {"boolean", "nil"})

        font = font or sm_scrapcomputers_fontManager_getDefaultFontName()

        local trueFont, err = sm_scrapcomputers_fontManager_getFont(font)
        if not trueFont then
            error("Failed getting font! Error message: " .. err)
        end

        wordWrappingEnabled = type(wordWrappingEnabled) == "nil" and true or wordWrappingEnabled
        maxWidth            = maxWidth or displayWidth

        -- Optimization!!!!
        if not wordWrappingEnabled then
            return #text * trueFont.fontWidth, trueFont.fontHeight
        end

        local usedWidth = sm_util_clamp(#text * trueFont.fontWidth, 0, maxWidth)
        local usedHeight = (1 + math_floor((#text * trueFont.fontWidth) / maxWidth)) * trueFont.fontHeight

        return usedWidth, usedHeight
    end

    -- VirtualDisplay specific functions
    output.setDimensions = function (newWidth, newHeight)
        sm_scrapcomputers_errorHandler_assertArgument(newWidth, 1, { "integer" })
        sm_scrapcomputers_errorHandler_assertArgument(newHeight, 2, { "integer" })

        displayWidth = newWidth
        displayHeight = newHeight
    end

    sm.scrapcomputers.ascfManager.applyDisplayFunctions(output)
    
    return output
end
