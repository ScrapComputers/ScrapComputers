-- The fontmanager lets you manage fonts and get them.
sm.scrapcomputers.fontManager = sm.scrapcomputers.fontManager or {
    fonts = {}, ---@type SCFont[] Table that will hold all available fonts.
}

if not next(sm.scrapcomputers.fontManager.fonts) then
    local builtInFonts = sm.json.open("$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/JSON/fonts.json")
    for _, fontName in pairs(builtInFonts) do
        dofile("$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Scripts/Fonts/" .. fontName .. ".lua")
    end
end

--- Retrieves a font by name.
---@param fontName string The name of the font to retrieve.
---@return SCFont? font The requested font, or nil if not found.
---@return string? errorMessage The error message, or nil if the font was found successfully.
function sm.scrapcomputers.fontManager.getFont(fontName)
    sm.scrapcomputers.errorHandler.assertArgument(fontName, nil, {"string"})
    
    local font = sm.scrapcomputers.fontManager.fonts[fontName]

    return font, (font and nil or "Font not found!")
end

--- Retrieves all font names currently loaded.
---@return string[] fontNames A list of all font names currently loaded.
function sm.scrapcomputers.fontManager.getFontNames()
    local fontNames = {}

    for fontName, _ in pairs(sm.scrapcomputers.fontManager.fonts) do
        table.insert(fontNames, fontName)
    end

    return fontNames
end

--- Retrieves the name of the default font.
---@return string defaultFontName The name of the default font.
function sm.scrapcomputers.fontManager.getDefaultFontName()
    return "Lexis"
end

--- Retrieves the default font used by ScrapComputers.
---@return SCFont font The default font.
function sm.scrapcomputers.fontManager.getDefaultFont()
    return sm.scrapcomputers.fontManager.fonts[sm.scrapcomputers.fontManager.getDefaultFontName()]
end