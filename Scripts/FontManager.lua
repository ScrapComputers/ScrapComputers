---@diagnostic disable: duplicate-doc-field
-- This if statement only exists so you dont have to reload your fucking world
if not sc.fontmanager then
    -- This manages SCF (ScrapComputers Font) font's. They are used in displays.
    sc.fontmanager = {}

    -- All fonts that the font manager has access to
    ---@type SCFont[]
    sc.fontmanager.fonts = {}
end

-- Built in fonts
local bultInFonts = sm.json.open(sc.jsonFiles.BuiltInFonts)

-- Loop through all built in fonts and load them
for _, fontName in pairs(bultInFonts) do
    dofile("$CONTENT_DATA/Scripts/Fonts/"..fontName..".lua")
end

-- Gets a font.
---@return SCFont? font The font
---@return string? errorMsg Tells you a error message if there is a error
function sc.fontmanager.getFont(fontName)
    local font = sc.fontmanager.fonts[fontName] -- Get it

    -- If it doesn't exist. return no font and the error message stating that it didnt find one.
    if not font then
        return nil, "Font not found!"
    end

    -- Return the font with no error message
    return font, nil
end

-- Gets all fonts and return's there names
---@return string[] fontNames All font name's
function sc.fontmanager.getFontNames()
    -- All font names stored
    local fontNames = {}

    -- Loop through them, and only put the index to fontNames
    for fontName, _ in pairs(sc.fontmanager.fonts) do
        table.insert(fontNames, fontName)
    end

    -- return fontNames
    return fontNames
end


-- Returns the default font name used.
---@return string font The font name that is used by default.
function sc.fontmanager.getDefaultFontName()
    return "Lexis"
end

-- Returns the default font used.
---@return SCFont font The font that is used by default.
function sc.fontmanager.getDefaultFont()
    return sc.fontmanager.fonts[sc.fontmanager.getDefaultFontName()]
end

---@class SCFont
---@field fontWidth integer The width of the font
---@field fontHeight integer The height of the font
---@field characters string All characters used on the font
---@field errorChar string[] The error character font
---@field charset string[][] All character's gylphs. On the first array. The index is the character! The seccond is the row number!