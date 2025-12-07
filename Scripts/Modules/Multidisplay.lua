-- Lets you group up displays into 1 massive display
sm.scrapcomputers.multidisplay = {}

local math_abs = math.abs
local math_min = math.min
local math_floor = math.floor
local pairs = pairs

---Creates a multidisplay
---@param displays Display[]
---@param columns integer Total columns
---@param rows integer Total rows
---@return Display display A Multidisplay instance. (Display type because its 100% compattable)
function sm.scrapcomputers.multidisplay.new(displays, columns, rows)
    sm.scrapcomputers.errorHandler.assertArgument(displays, 1, {"table"}, {"Display[]"})
    sm.scrapcomputers.errorHandler.assertArgument(columns , 2, {"integer"})
    sm.scrapcomputers.errorHandler.assertArgument(rows    , 3, {"integer"})

    sm.scrapcomputers.errorHandler.assert(columns * rows == #displays, 1, "Iliegal MultiDisplay creation (Rows * Columns does NOT match with the amount of displays)")
    sm.scrapcomputers.errorHandler.assert(#displays > 0, 1, "At least 1 or more displays are required.")

    local firstDisplayWidth, firstDisplayHeight = displays[1].getDimensions()
    local firstDispalySizeX, firstDispalySizeY = displays[1].getSize()

    for i, display in pairs(displays) do
        local displayWidth, displayHeight = display.getDimensions()
        local displaySizeX, dispalySizeY = display.getSize()

        sm.scrapcomputers.errorHandler.assert(displayWidth == firstDisplayWidth, 1, "Iliegal MultiDisplay creation (Display index " .. i .. " has a different resolution than the first specified)")
        sm.scrapcomputers.errorHandler.assert(displayHeight == firstDisplayHeight, 1, "Iliegal MultiDisplay creation (Display index " .. i .. " has a different resolution than the first specified)")
        sm.scrapcomputers.errorHandler.assert(displaySizeX == firstDispalySizeX, 1, "Iliegal MultiDisplay creation (Display index " .. i .. " has a different size than the first specified)")
        sm.scrapcomputers.errorHandler.assert(dispalySizeY == firstDispalySizeY, 1, "Iliegal MultiDisplay creation (Display index " .. i .. " has a different size than the first specified)")
    end

    local mainDisplay = sm.scrapcomputers.virtualdisplay.new(firstDisplayWidth * columns, firstDisplayHeight * rows)

    local renderFunc = mainDisplay.render
    mainDisplay.render = function () end

    local function runForAll(funcName)
        return function (...) for _, display in pairs(displays) do display[funcName](...) end end
    end


    local clearFunc = mainDisplay.clear
    mainDisplay.clear = function (color)
        sm.scrapcomputers.errorHandler.assertArgument(color, nil, {"Color", "string", "integer", "nil"})

        clearFunc(color)
        runForAll("clear")()
    end

    mainDisplay.update = function()
        local output = renderFunc(0, 0, true)
        local len = #output

        for i = 1, len do
            local pixel = output[i]
            local pixel_x, pixel_y = pixel.x, pixel.y
            local column = math_floor((firstDisplayWidth + pixel_x - 1) / firstDisplayWidth)
            local row = math_floor((firstDisplayHeight + pixel_y - 1) / firstDisplayHeight)

            displays[(row - 1) * columns + column].drawPixel(
                pixel_x - (column - 1) * firstDisplayWidth, 
                pixel_y - (row - 1) * firstDisplayHeight, 
                pixel.color
            )
        end

        runForAll("update")()
    end

    mainDisplay.enableTouchScreen = function (bool)
        sm.scrapcomputers.errorHandler.assertArgument(bool, nil, {"boolean"})
        runForAll("enableTouchScreen")(bool)
    end

    mainDisplay.hide = runForAll("hide")
    mainDisplay.show = runForAll("show")

    mainDisplay.setRenderDistance = function (distance)
        sm.scrapcomputers.errorHandler.assertArgument(distance, nil, {"number"})
        runForAll("setRenderDistance")(distance)
    end

    mainDisplay.setOptimizationThreshold = function (threshold)
        sm.scrapcomputers.errorHandler.assertArgument(threshold, nil, {"number"})
        runForAll("setOptimizationThreshold")(threshold)
    end

    mainDisplay.getOptimizationThreshold = function ()
        return displays[1].getOptimizationThreshold()
    end

    mainDisplay.getTouchData = function ()
        for index, display in pairs(displays) do
            local touchData = display.getTouchData()
            if touchData then
                local row = math_floor((index - 1) / columns)
                local col = (index - 1) % columns

                return {
                    x = touchData.x + (col * firstDisplayWidth),
                    y = touchData.y + (row * firstDisplayHeight),
                    state = touchData.state
                }
            end
        end
    end

    mainDisplay.getTouchTable = function ()
        local output = {}
        for index, display in pairs(displays) do
            local touchTable = display.getTouchTable()
            for name, touchData in pairs(touchTable) do
                local row = math_floor((index - 1) / columns)
                local col = (index - 1) % columns

                output[name] = {
                    x = touchData.x + (col * firstDisplayWidth),
                    y = touchData.y + (row * firstDisplayHeight),
                    state = touchData.state
                }
            end
        end

        return output
    end

    return mainDisplay
end