sm.scrapcomputers.gui = {}

---Shows a chat message with scrapcomputer's language manger applied
---@param message string The message to send
---@param ... any? Additional arguments to send to the language manager
function sm.scrapcomputers.gui:chatMessage(message, ...)
    if select("#", ...) == 0 then
        sm.gui.chatMessage("[#3A96DDS#3b78ffC#eeeeee]: " .. sm.scrapcomputers.languageManager.translatable(message))
        return
    end

    sm.gui.chatMessage("[#3A96DDS#3b78ffC#eeeeee]: " .. sm.scrapcomputers.languageManager.translatable(message, ...))
end

---Shows a alert with scrapcomputer's language manger applied
---@param message string The message to alert
---@param ... any? Additional arguments to send to the language manager
function sm.scrapcomputers.gui:alert(message, ...)
    if select("#", ...) == 0 then
        sm.gui.displayAlertText("[#3A96DDS#3b78ffC#eeeeee]: " .. sm.scrapcomputers.languageManager.translatable(message))
        return
    end

    sm.gui.displayAlertText("[#3A96DDS#3b78ffC#eeeeee]: " .. sm.scrapcomputers.languageManager.translatable(message, ...))
end

---Creates a gui from a layout file with translation support
---@param layout string Path to the layout file
---@param destroyOnClose? boolean If true the gui is destroyed when closed, otherwise the gui can be reused.
---@param settings? GuiSettings Table with bool settings for: isHud, isInteractive, needsCursor
---@return GuiInterface
function sm.scrapcomputers.gui:createGuiFromLayout(layout, destroyOnClose, settings)
    return self:translationsForGUIInterface(sm.gui.createGuiFromLayout(layout, destroyOnClose, settings))
end

---Creates a fake GuiInterface so that translations can be applied to certain functions
---@param gui GuiInterface The GuiInterface to apply translations to
---@return GuiInterface gui A "GuiInterface" with translations applied to it
function sm.scrapcomputers.gui:translationsForGUIInterface(gui)
    sm.scrapcomputers.errorHandler.assertArgument(gui, nil, {"GuiInterface"})
    
    local function BindFunction(func)
        return function(_, ...)
            return func(gui, ...)
        end
    end

    return {
        addGridItem                = BindFunction(gui.addGridItem               ),
        addGridItemsFromFile       = BindFunction(gui.addGridItemsFromFile      ),
        addToPickupDisplay         = BindFunction(gui.addToPickupDisplay        ),
        addListItem                = BindFunction(gui.addListItem               ),
        clearGrid                  = BindFunction(gui.clearGrid                 ),
        clearList                  = BindFunction(gui.clearList                 ),
        close                      = BindFunction(gui.close                     ),
        createDropDown             = BindFunction(gui.createDropDown            ),
        createGridFromJson         = BindFunction(gui.createGridFromJson        ),
        createHorizontalSlider     = BindFunction(gui.createHorizontalSlider    ),
        createVerticalSlider       = BindFunction(gui.createVerticalSlider      ),
        destroy                    = BindFunction(gui.destroy                   ),
        isActive                   = function ()
            return sm.exists(gui) and gui:isActive()
        end,
        open                       = BindFunction(gui.open                      ),
        playEffect                 = BindFunction(gui.playEffect                ),
        playGridEffect             = BindFunction(gui.playGridEffect            ),
        setButtonCallback          = BindFunction(gui.setButtonCallback         ),
        setButtonState             = BindFunction(gui.setButtonState            ),
        setColor                   = BindFunction(gui.setColor                  ),
        setContainer               = BindFunction(gui.setContainer              ),
        setContainers              = BindFunction(gui.setContainers             ),
        setData                    = BindFunction(gui.setData                   ),
        setFadeRange               = BindFunction(gui.setFadeRange              ),
        setFocus                   = BindFunction(gui.setFocus                  ),
        setGridButtonCallback      = BindFunction(gui.setGridButtonCallback     ),
        setGridItem                = BindFunction(gui.setGridItem               ),
        setGridItemChangedCallback = BindFunction(gui.setGridItemChangedCallback),
        setGridMouseFocusCallback  = BindFunction(gui.setGridMouseFocusCallback ),
        setGridSize                = BindFunction(gui.setGridSize               ),
        setHost                    = BindFunction(gui.setHost                   ),
        setIconImage               = BindFunction(gui.setIconImage              ),
        setImage                   = BindFunction(gui.setImage                  ),
        setItemIcon                = BindFunction(gui.setItemIcon               ),
        setListSelectionCallback   = BindFunction(gui.setListSelectionCallback  ),
        setMaxRenderDistance       = BindFunction(gui.setMaxRenderDistance      ),
        setMeshPreview             = BindFunction(gui.setMeshPreview            ),
        setOnCloseCallback         = BindFunction(gui.setOnCloseCallback        ),
        setRequireLineOfSight      = BindFunction(gui.setRequireLineOfSight     ),
        setSelectedDropDownItem    = BindFunction(gui.setSelectedDropDownItem   ),
        setSelectedListItem        = BindFunction(gui.setSelectedListItem       ),
        setSliderCallback          = BindFunction(gui.setSliderCallback         ),
        setSliderData              = BindFunction(gui.setSliderData             ),
        setSliderPosition          = BindFunction(gui.setSliderPosition         ),
        setSliderRange             = BindFunction(gui.setSliderRange            ),
        setSliderRangeLimit        = BindFunction(gui.setSliderRangeLimit       ),
        setText                    = function (self, widgetName, text, ...)
            gui:setText(widgetName, sm.scrapcomputers.languageManager.translatable(text, type(...) == "table" and unpack(...) or ...))
        end,
        setTextRaw                 = BindFunction(gui.setText),
        setTextAcceptedCallback    = BindFunction(gui.setTextAcceptedCallback   ),
        setTextChangedCallback     = BindFunction(gui.setTextChangedCallback    ),
        setVisible                 = BindFunction(gui.setVisible                ),
        setWorldPosition           = BindFunction(gui.setWorldPosition          ),
        stopEffect                 = BindFunction(gui.stopEffect                ),
        stopGridEffect             = BindFunction(gui.stopGridEffect            ),
        trackQuest                 = BindFunction(gui.trackQuest                ),
        untrackQuest               = BindFunction(gui.untrackQuest              ),
    }
end

local function getMyGuiScreenSize()
    local screenWidth, screenHeight = sm.gui.getScreenSize()

    -- 720p, 1080p, 1440p, 4k

    if screenWidth >= 3840 and screenHeight >= 2160 then
        return 3840, 2160 -- 4K
    elseif screenWidth >= 2560 and screenHeight >= 1440 then
        return 2560, 1440 -- 1440p
    elseif screenWidth >= 1920 and screenHeight >= 1080 then
        return 1920, 1080 -- 1080p
    else
        return 1280, 720 -- 720p
    end
end


function sm.scrapcomputers.gui:showCustomInteractiveText(top, bottom)
    sm.scrapcomputers.errorHandler.assertArgument(top, 1, { "table" }, { "string[]" })
    sm.scrapcomputers.errorHandler.assertArgument(bottom, 2, { "table", "nil" }, { "string[]" })

    ---@param tbl string[]
    local function runInteractiveText(tbl)
        local output = ""

        for _, text in ipairs(tbl) do
            local parsedText

            if type(text) == "table" then
                if #text > 0 then
                    parsedText = sm.scrapcomputers.languageManager.translatable(unpack(text))
                else
                    -- fallback if empty table, e.g. empty string or some default
                    parsedText = ""
                end
            else
                parsedText = sm.scrapcomputers.languageManager.translatable(text)
            end

            parsedText = parsedText
                :gsub("#%[(.-)%]", function (path)
                    local _, height  = getMyGuiScreenSize()
                    local size = (height / 30) - 4

                    return string.format("<p textShadow='true' bg='PanelEmpty' color='#eeeeee' spacing='-15'>               <img width='%d' height='%d'>$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Gui/Icons/%s.png</img>  ", size, size, path)
                end)
                :gsub("#%{(.-)%} ", function(match)
                    return sm.gui.getKeyBinding(match, true)
                end)
                :gsub("#%((.-)%)", function(match)
                    local colors = {
                        ERROR   = "#F14C4C",
                        WARN    = "#F5F543",
                        SUCCESS = "#23d18b"
                    }
                    return colors[match] or ("#(" .. match .. ")")
                end)

            output = output .. "<p textShadow='true' bg='gui_keybinds_bg' color='#eeeeee' spacing='9'>" .. parsedText .. "</p> "
        end

        sm.gui.setInteractionText(output)
    end

    runInteractiveText(top)
    if bottom and #bottom > 0 then
        runInteractiveText(bottom)
    else
        sm.gui.setInteractionText("", "")
    end
end
