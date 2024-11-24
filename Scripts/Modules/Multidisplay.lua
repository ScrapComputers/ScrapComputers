-- Lets you group up displays into 1 massive display
sm.scrapcomputers.multidisplay = {}

local math_sqrt = math.sqrt
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

    sm.scrapcomputers.errorHandler.assert(columns * rows == #displays, nil, "Iliegal MultiDisplay creation (Rows * Columns does NOT match with the amount of displays)")
    sm.scrapcomputers.errorHandler.assert(#displays > 0, 1, "Atleast 1 or more displays are required.")

    local firstDisplayWidth, firstDisplayHeight = displays[1].getDimensions()
    local mainDisplay = sm.scrapcomputers.virtualdisplay.new(firstDisplayWidth * columns, firstDisplayHeight * rows)

    local renderFunc = mainDisplay.render
    mainDisplay.render = function () end

    local function runForAll(funcName)
        return function (param) for _, display in pairs(displays) do display[funcName](param) end end
    end


    local clearFunc = mainDisplay.clear
    mainDisplay.clear = function (color)
        sm.scrapcomputers.errorHandler.assertArgument(color, nil, {"Color", "string", "nil"})

        clearFunc(color)
        runForAll("clear")()
    end

    mainDisplay.update = function()
        local output = renderFunc()
        local maxBorderFactor = 0.08
    
        for _, pixel in pairs(output) do
            local selectedColumn = math_min(math_floor((pixel.x - 1) / firstDisplayWidth) + 1, columns)
            local selectedRow = math_min(math_floor((pixel.y - 1) / firstDisplayHeight) + 1, rows)
            
            local selectedIndex = (selectedRow - 1) * columns + selectedColumn
            if displays[selectedIndex] then
                local localX = (pixel.x - 1) % firstDisplayWidth + 1
                local localY = (pixel.y - 1) % firstDisplayHeight + 1
    
                local centerRow = (rows + 1) / 2
                local centerColumn = (columns + 1) / 2
                local distanceToCenter = math_sqrt((selectedRow - centerRow) ^ 2 + (selectedColumn - centerColumn) ^ 2)
                local maxDistance = math_sqrt((centerRow - 1) ^ 2 + (centerColumn - 1) ^ 2)
                local offsetFactor = maxBorderFactor * (1 - (distanceToCenter / maxDistance))
    
                local offsetX, offsetY = 0, 0
    
                if selectedColumn == 1 then
                    offsetX = offsetFactor * firstDisplayWidth
                elseif selectedColumn == columns then
                    offsetX = -offsetFactor * firstDisplayWidth
                end
    
                if selectedRow == 1 then
                    offsetY = offsetFactor * firstDisplayHeight
                elseif selectedRow == rows then
                    offsetY = -offsetFactor * firstDisplayHeight
                end
    
                if (selectedColumn == 1 or selectedColumn == columns) and (selectedRow == 1 or selectedRow == rows) then
                    offsetX = offsetX * 2
                    offsetY = offsetY * 2
                end
    
                localX = localX + offsetX
                localY = localY + offsetY
    
                displays[selectedIndex].drawPixel(localX, localY, pixel.color)
            end
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

    mainDisplay.optimize = runForAll("optimize")

    mainDisplay.setOptimizationThreshold = function (threshold)
        sm.scrapcomputers.errorHandler.assertArgument(threshold, nil, {"number"})
        runForAll("setOptimizationThreshold")(threshold)
    end

    mainDisplay.getOptimizationThreshold = function ()
        return displays[1].getOptimizationThreshold()
    end

    mainDisplay.autoUpdate = function (bool)
        sm.scrapcomputers.errorHandler.assertArgument(bool, nil, {"boolean"})
        runForAll("autoUpdate")(bool)
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