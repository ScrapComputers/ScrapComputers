---Additional helper functions for sm.color
sm.scrapcomputers.color = {}

---Generates a random color by a range
---@param from integer The starting range
---@param to integer The ending range
---@return Color color The new color
function sm.scrapcomputers.color.random(from, to)
    sm.scrapcomputers.errorHandler.assertArgument(from, 1, {"integer"})
    sm.scrapcomputers.errorHandler.assertArgument(to, 2, {"integer"})
    sm.scrapcomputers.errorHandler.assert(from >= 0 and from <= 255, 1, "Out of range!")
    sm.scrapcomputers.errorHandler.assert(to   >= 0 and to   <= 255, 2, "Out of range!")

    local Red = math.random(from, to)
    local Green = math.random(from, to)
    local Blue = math.random(from, to)
    
    return sm.color.new(Red, Green, Blue)
end

---Creates a random color from 0 to 1
---@return Color color The new color
function sm.scrapcomputers.color.random0to1()
    return sm.color.new(math.random(), math.random(), math.random())
end

---Generates a grayscale color by rgbNumber
---@param rgbNumber integer The RGB value
---@return Color color The new color
function sm.scrapcomputers.color.newSingular(rgbNumber)
    sm.scrapcomputers.errorHandler.assertArgument(rgbNumber, nil, {"number"})

    local rgbNumber = sm.util.clamp(rgbNumber, 0, 1)
    return sm.color.new(rgbNumber, rgbNumber, rgbNumber)
end

---This generates an interpolated gradient between the colors provided and is dependent on the ammount of gradient specified.
---@param colors Color[] The table of colors to generate the gradient from.
---@param numColors integer The ammount of blending each color gets in the gradient table.
---@return Color[] colorGradient The generated gradient table.
function sm.scrapcomputers.color.generateGradient(colors, numColors)
    sm.scrapcomputers.errorHandler.assertArgument(colors, 1, {"table"}, {"Colors[]"})
    sm.scrapcomputers.errorHandler.assertArgument(numColors, 2, {"number"})

    local function interpolateColor(color1, color2, factor)
        local r = color1.r + (color2.r - color1.r) * factor
        local g = color1.g + (color2.g - color1.g) * factor
        local b = color1.b + (color2.b - color1.b) * factor
        
        return sm.color.new(r, g, b)
    end

    local gradient = {}

    for i = 1, numColors do
        local p = (i - 1) / (numColors - 1)
        local segment = math.floor(p * (#colors - 1))
        local t = (p * (#colors - 1)) - segment

        local color1 = colors[segment + 1]
        local color2 = colors[segment + 2] or color1

        local interpolatedColor = interpolateColor(color1, color2, t)
        table.insert(gradient, interpolatedColor)
    end

    return gradient
end