local lineSpacing = 1.33

local sm_scrapcomputers_string_toCharacters = sm.scrapcomputers.string.toCharacters
local sm_scrapcomputers_table_clone = sm.scrapcomputers.table.clone
local sm_scrapcomputers_errorHandler_assertArgument = sm.scrapcomputers.errorHandler.assertArgument
local sm_scrapcomputers_errorHandler_assert = sm.scrapcomputers.errorHandler.assert

local math_huge = math.huge
local math_pi = math.pi
local math_max = math.max
local math_min = math.min
local math_rad = math.rad
local math_cos = math.cos
local math_sin = math.sin
local string_byte = string.byte
local string_sub = string.sub

local pairs = pairs
local type = type

sm.scrapcomputers.ascfManager = sm.scrapcomputers.ascfManager or {
    ---@type table<string, ASCFont> A array of loaded fonts.
    fonts = {},
}

local ascfManager = sm.scrapcomputers.ascfManager

ascfManager.backend = ascfManager.backend or {
    notFoundFonts = {},
    builtInFontsLoaded = false
}

local ascfManagerBackend = ascfManager.backend

-- Some fonts stupidly dont have space character
---@param font ASCFont
---@param character string
local function spaceGylphIfNotThere(font, character)
    local glyph = font.glyphs[character]
    if character ~= " " then return glyph end

    return glyph or {
        advanceWidth = (font.metadata.boundingBox.xMax - font.metadata.boundingBox.xMin) / 2,
        metrics = font.metadata.boundingBox,
        triangles = {}
    }
end

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

---@param fontName string
---@return ASCFont?
---@return integer
local function findOrLoadFont(fontName)
    for tblFontName, font in pairs(ascfManager.fonts) do
        if tblFontName == fontName and type(font) == "table" then
            return font, 0
        end
    end

    local path = ascfManager.fonts[fontName]
    if not path then
        ascfManagerBackend.notFoundFonts[fontName] = true
        return nil, -1
    end

    if ascfManagerBackend.notFoundFonts[fontName] then
        return nil, -1
    end

    sm.scrapcomputers.logger.info("ASCFManager.lua", "Loading font:", path)

    if not sm.json.fileExists(path) then
        sm.scrapcomputers.logger.fatal("ASCFManager.lua",
            "Font does not exist! This shouldn't be possble. Mod may be unstable!")
        ascfManagerBackend.notFoundFonts[fontName] = true
        return nil, -2
    end

    ascfManager.fonts[fontName] = sm.json.open(path)
    return ascfManager.fonts[fontName], 1
end

local function parseText(text)
    local outputText = ""

    local indexColorChange = {}

    local colorMode = false
    local colorText = ""

    local appliedColors = 0
    local reducedOffset = 0

    local index = 1
    while index <= #text do
        local character = getUTF8Character(text, index)

        if colorMode then
            colorText = colorText .. character

            if #colorText == 6 then
                colorMode = false
                appliedColors = appliedColors + 1

                indexColorChange[index - (7 * appliedColors) + 1 - reducedOffset] = colorText
                colorText = ""
            end
        else
            if character == "#" then
                if getUTF8Character(text, index + #character) == "#" then
                    outputText = outputText .. "#"
                    index = index + 1
                    reducedOffset = reducedOffset + 1
                else
                    colorMode = true
                    colorText = ""
                end
            else
                outputText = outputText .. character
            end
        end

        index = index + #character
    end

    return outputText, indexColorChange
end

---Adds a font.
---
---NOTE 1, This would cache the font path and not load it!
---NOTE 2, FontPath should be the full path where the font your adding would be, and do not use $CONTENT_DATA but instead $CONTENT_[YOUR_MOD_UUID] to prevent confusion!
---@param fontPath string Path to the font
function ascfManager.addFont(fontPath)
    sm_scrapcomputers_errorHandler_assertArgument(fontPath, nil, { "string" })
    sm_scrapcomputers_errorHandler_assert(sm.json.fileExists(fontPath), nil, "File not found!")

    local filename = fontPath:match("([^/]+)%.%w+$")
    ascfManager.fonts[filename] = fontPath
    sm.scrapcomputers.logger.info("ASCFManager.lua", "Cached font", fontPath)
end

---Gets information/data about the font
---@param fontName string The name of the font
---@return ASCFont? font Information of the font
---@return string? errMsg The error message if it failed getting the font
function ascfManager.getFontInfo(fontName)
    sm_scrapcomputers_errorHandler_assertArgument(fontName, nil, { "string" })

    local font = ascfManager.fonts[fontName]
    if not font then
        return nil, "Font not found!"
    end

    if type(font) == "string" then
        return nil, "Font is not loaded!"
    end

    return font, nil
end

---Loads a font.
---@param fontName string The name of the font
---@return boolean success If it succeeded
---@return string? errMsg The error message
function ascfManager.loadFont(fontName)
    sm_scrapcomputers_errorHandler_assertArgument(fontName, nil, { "string" })
    local _, status = findOrLoadFont(fontName)

    if status == -1 then
        return false, "Font not found"
    elseif status == -2 then
        return false, "Font path not found! (Unstability Warning)"
    end

    return true, nil
end

---Calculates text size, No error handling provided.
---@param fontName string The name of the font
---@param text string The text
---@param fontSize number The size of the font
---@param rotation number? The rotation
---@return number width The width the font consumes
---@return number hegiht The height the font consumes
function ascfManager.calcTextSize(fontName, text, fontSize, rotation, maxWidth, coloredMode)
    rotation = rotation or 0
    local radians = rotation * math_pi / 180

    local font, status = findOrLoadFont(fontName)
    sm_scrapcomputers_errorHandler_assert(font, 5,
        status == -1 and "Font not found!" or "Font not found! (Unstable Mod Warning)")

    local scale = fontSize / font.metadata.resolution

    local text = text
    if coloredMode then
        text, _ = parseText(text)
    end

    local characters = sm_scrapcomputers_string_toCharacters(text)

    local minX, maxX, minY, maxY = math_huge, -math_huge, math_huge, -math_huge

    local currentX, currentY = 0, 0
    for _, char in ipairs(characters) do
        local gylph = spaceGylphIfNotThere(font, char)
        if char == "\t" then
            gylph = sm_scrapcomputers_table_clone(spaceGylphIfNotThere(font, " "))
            if gylph then
                gylph.advanceWidth = gylph.advanceWidth * 4
            end
        elseif char == "\n" or (maxWidth and (currentX + (gylph.advanceWidth * scale)) >= maxWidth) then
            currentX = 0
            currentY = currentY + (fontSize * lineSpacing)
        end

        if gylph then
            for _, triangle in pairs(gylph.triangles) do
                local vertices = {
                    { currentX + (triangle[1][1] * scale), currentY + -(triangle[1][2] * scale) + fontSize },
                    { currentX + (triangle[2][1] * scale), currentY + -(triangle[2][2] * scale) + fontSize },
                    { currentX + (triangle[3][1] * scale), currentY + -(triangle[3][2] * scale) + fontSize }
                }

                for _, vertex in ipairs(vertices) do
                    local x, y = vertex[1], vertex[2]
                    local dx, dy = x, y
                    local rotatedX = math_cos(radians) * dx - math_sin(radians) * dy
                    local rotatedY = math_sin(radians) * dx + math_cos(radians) * dy

                    minX = math_min(minX, rotatedX)
                    maxX = math_max(maxX, rotatedX)
                    minY = math_min(minY, rotatedY)
                    maxY = math_max(maxY, rotatedY)
                end
            end
            currentX = currentX + (gylph.advanceWidth * scale)
        end
    end

    return (maxX - minX), (maxY - minY)
end

---Draws text to a display, Does not provide any error handling!
---@param display Display The display
---@param xOffset number The x-coordinate
---@param yOffset number The y-coordinate
---@param text string The text to draw
---@param fontName string The name of the font
---@param color string|Color The color of the text to set
---@param rotation number? The rotation
---@param fontSize number The size of the font to use
---@param colorToggled boolean? If it should support colors or not in text.
function ascfManager.drawText(display, xOffset, yOffset, text, fontName, color, rotation, fontSize, colorToggled)
    local font, status = findOrLoadFont(fontName)
    sm_scrapcomputers_errorHandler_assert(font, 5,
        status == -1 and "Font not found!" or "Font not found! (Unstable Mod Warning)")

    local displayWidth, displayHeight = display.getDimensions()
    local scale = fontSize / font.metadata.resolution

    local text, colorIndexes = text, {}

    if colorToggled then
        text, colorIndexes = parseText(text)
    end

    -- Measure text block size to find the center
    local totalWidth, totalHeight = 0, fontSize
    local currentLineWidth = 0

    local textSize = #text

    local characterIndex1 = 1
    while characterIndex1 <= textSize do
        local char = getUTF8Character(text, characterIndex1)
        local gylph = spaceGylphIfNotThere(font, char, fontSize)
        if char == "\t" then
            gylph = sm_scrapcomputers_table_clone(spaceGylphIfNotThere(font, " ", fontSize))
            if gylph then
                gylph.advanceWidth = gylph.advanceWidth * 4
            end
        elseif char == "\n" then
            totalHeight = totalHeight + (fontSize * lineSpacing)
            totalWidth = math_max(totalWidth, currentLineWidth)
            currentLineWidth = 0
        elseif gylph then
            currentLineWidth = currentLineWidth + (gylph.advanceWidth * scale)
        end

        characterIndex1 = characterIndex1 + #char
    end

    totalWidth = math_max(totalWidth, currentLineWidth)
    local centerX = xOffset + (totalWidth / 2)
    local centerY = yOffset + (totalHeight / 2)

    local currentX = xOffset
    local currentY = yOffset
    local currentColor = color
    local cosR = math_cos(rotation)
    local sinR = math_sin(rotation)

    local display_drawFilledTriangle = display.drawFilledTriangle

    local characterIndex2 = 1
    while characterIndex2 <= textSize do
        local char = getUTF8Character(text, characterIndex2)

        local newColor = colorIndexes[characterIndex2]
        if newColor then
            currentColor = newColor
        end

        local gylph = spaceGylphIfNotThere(font, char, fontSize)
        if char == "\t" then
            currentX = currentX + (font.metadata.boundingBox.xMax - font.metadata.boundingBox.xMin) * scale
        end

        if char == "\n" or (gylph and (currentX + (gylph.advanceWidth * scale)) >= displayWidth) then
            currentX = xOffset
            currentY = currentY + (fontSize * lineSpacing)
        end
        
        if gylph then
            if currentY >= displayHeight then return end
            for _, triangle in pairs(gylph.triangles) do
                local vertices = {
                    { currentX + (triangle[1][1] * scale), currentY + -(triangle[1][2] * scale) + fontSize },
                    { currentX + (triangle[2][1] * scale), currentY + -(triangle[2][2] * scale) + fontSize },
                    { currentX + (triangle[3][1] * scale), currentY + -(triangle[3][2] * scale) + fontSize }
                }

                local rotatedVertices = {}
                for _, vertex in pairs(vertices) do
                    local x, y = vertex[1], vertex[2]
                    local dx, dy = x - centerX, y - centerY
                    local rotatedX = cosR * dx - sinR * dy + centerX
                    local rotatedY = sinR * dx + cosR * dy + centerY

                    rotatedVertices[#rotatedVertices + 1] = rotatedX
                    rotatedVertices[#rotatedVertices + 1] = rotatedY
                end

                display_drawFilledTriangle(
                    rotatedVertices[1], rotatedVertices[2],
                    rotatedVertices[3], rotatedVertices[4],
                    rotatedVertices[5], rotatedVertices[6],

                    currentColor
                )
            end

            currentX = currentX + (gylph.advanceWidth * scale)
        end

        characterIndex2 = characterIndex2 + #char
    end
end

local sm_scrapcomputers_ascfManager_drawText = ascfManager.drawText

---Draws text to a display.
---@param display Display The display
---@param xOffset number The x-coordinate
---@param yOffset number The y-coordinate
---@param text string The text to draw
---@param fontName string The name of the font
---@param color string|Color The color of the text to set
---@param rotation number? The rotation
---@param fontSize number The size of the font to use
---@param colorToggled boolean? If it should support colors or not in text.
function ascfManager.drawTextSafe(display, xOffset, yOffset, text, fontName, color, rotation, fontSize, colorToggled)
    sm_scrapcomputers_errorHandler_assertArgument(display, 1, { "table" }, { "Display" })
    sm_scrapcomputers_errorHandler_assertArgument(xOffset, 2, { "number" })
    sm_scrapcomputers_errorHandler_assertArgument(yOffset, 3, { "number" })
    sm_scrapcomputers_errorHandler_assertArgument(text, 4, { "string" })
    sm_scrapcomputers_errorHandler_assertArgument(color, 5, { "Color", "string" })
    sm_scrapcomputers_errorHandler_assertArgument(rotation, 6, { "number", "nil" })
    sm_scrapcomputers_errorHandler_assertArgument(fontSize, 7, { "number" })
    sm_scrapcomputers_errorHandler_assertArgument(colorToggled, 8, { "boolean", "nil" })

    colorToggled = type(colorToggled) == "nil" and true or colorToggled
    rotation = math_rad(rotation) or 0

    sm_scrapcomputers_ascfManager_drawText(display, xOffset, yOffset, text, fontName, color, rotation, fontSize,
        colorToggled)
end

---Applies functions to displays, You shouldn't use this generally.
---No error handling provided
---@param display Display The display.
function ascfManager.applyDisplayFunctions(display)
    display.drawASCFText     = function(...) ascfManager.drawTextSafe(display, ...) end  -- Remove "Safe" to remove error handling & nil checking!
    display.calcASCFTextSize = ascfManager.calcTextSize
end

function ascfManager.getFontNames()
    local fontNames = {}

    for fontName, _ in pairs(ascfManager.fonts) do
        table.insert(fontNames, fontName)
    end

    return fontNames
end

------------------------------------------------------------------------------------------------------------------------------

if sm.scrapcomputers.table.getTableSize(ascfManager.fonts) > 0 then
    return
end

local installedFonts = { "BebasNeue-Regular", "CALIBRI", "ComicSans-Bold", "ComicSans-BoldItalic", "ComicSans-Italic",
    "ComicSans-Regular", "Courier New", "DejaVuSans", "DINEngschriftStd", "DINMittelschriftStd", "FiraCode-Bold",
    "FiraCode-Light", "FiraCode-Medium", "FiraCode-Regular", "FiraCode-Retina", "FiraCode-SemiBold", "Futura-Bold",
    "Futura-Oblique", "Futura", "GRUPO3", "Helvetica Black Condensed Oblique", "Helvetica Black Condensed",
    "Helvetica Black Oblique", "helvetica black", "Helvetica Bold Condensed", "Helvetica Bold Narrow Oblique",
    "Helvetica Condensed Bold Oblique", "Helvetica Condensed Oblique", "Helvetica Condensed Regular",
    "Helvetica Extra Compressed Regular", "Helvetica Inserat Roman", "Helvetica Light Condensed", "Helvetica Roman",
    "Helvetica Rounded Black", "Helvetica Rounded Bold Oblique", "Helvetica Rounded Bold",
    "Helvetica Rounded Condensed Bold", "Helvetica Rounded LT Std Bold Condensed Oblique", "Helvetica Ultra Compressed",
    "Helvetica-Bold Oblique", "Helvetica-Bold", "helvetica-compressed", "helvetica-light", "Helvetica-LightOblique",
    "Helvetica-Narrow Bold", "Helvetica-Narrow Roman", "Helvetica-Narrow-Oblique", "Helvetica-Oblique",
    "helvetica-rounded-bold", "Helvetica", "helvetica_condensed", "JetBrainsMono-Bold", "JetBrainsMono-BoldItalic",
    "JetBrainsMono-ExtraBold", "JetBrainsMono-ExtraBoldItalic", "JetBrainsMono-ExtraLight",
    "JetBrainsMono-ExtraLightItalic", "JetBrainsMono-Italic", "JetBrainsMono-Light", "JetBrainsMono-LightItalic",
    "JetBrainsMono-Medium", "JetBrainsMono-MediumItalic", "JetBrainsMono-Regular", "JetBrainsMono-SemiBold",
    "JetBrainsMono-SemiBoldItalic", "JetBrainsMono-Thin", "JetBrainsMono-ThinItalic", "JetBrainsMonoNL-Bold",
    "JetBrainsMonoNL-BoldItalic", "JetBrainsMonoNL-ExtraBold", "JetBrainsMonoNL-ExtraBoldItalic",
    "JetBrainsMonoNL-ExtraLight", "JetBrainsMonoNL-ExtraLightItalic", "JetBrainsMonoNL-Italic", "JetBrainsMonoNL-Light",
    "JetBrainsMonoNL-LightItalic", "JetBrainsMonoNL-Medium", "JetBrainsMonoNL-MediumItalic", "JetBrainsMonoNL-Regular",
    "JetBrainsMonoNL-SemiBold", "JetBrainsMonoNL-SemiBoldItalic", "JetBrainsMonoNL-Thin", "JetBrainsMonoNL-ThinItalic",
    "Lato-Heavy", "Lato-Medium", "Lato-MediumItalic", "NotoSans-Bold", "NotoSans-Italic", "NotoSans-Medium",
    "NotoSans-Regular", "NotoSans-SemiBold", "NotoSansCJKsc-Regular", "Oswald-Bold", "Oswald-ExtraLight", "Oswald-Light",
    "Oswald-Medium", "Oswald-Regular", "Oswald-SemiBold", "Raleway-Black", "Raleway-BlackItalic", "Raleway-Bold",
    "Raleway-BoldItalic", "Raleway-ExtraBold", "Raleway-ExtraBoldItalic", "Raleway-ExtraLight",
    "Raleway-ExtraLightItalic", "Raleway-Italic", "Raleway-Light", "Raleway-LightItalic", "Raleway-Medium",
    "Raleway-MediumItalic", "Raleway-Regular", "Raleway-SemiBold", "Raleway-SemiBoldItalic", "Raleway-Thin",
    "Raleway-ThinItalic", "Santa Catalina1", "SourceCodePro-Black", "SourceCodePro-BlackIt", "SourceCodePro-Bold",
    "SourceCodePro-BoldIt", "SourceCodePro-ExtraLight", "SourceCodePro-ExtraLightIt", "SourceCodePro-It",
    "SourceCodePro-Light", "SourceCodePro-LightIt", "SourceCodePro-Medium", "SourceCodePro-MediumIt",
    "SourceCodePro-Regular", "SourceCodePro-Semibold", "SourceCodePro-SemiboldIt", "SovjetBox", "TimesNewRoman-Bold",
    "TimesNewRoman-BoldItalic", "TimesNewRoman-Italic", "TimesNewRoman-Regular", "Xolonium-Bold" }
for _, installedFont in pairs(installedFonts) do
    local path = "$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/JSON/AdvancedFonts/" .. installedFont .. ".ascf"

    ascfManager.addFont(path)
end
