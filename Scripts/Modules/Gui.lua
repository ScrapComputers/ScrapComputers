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
    local finalMessage = "[#3A96DDS#3b78ffC#eeeeee]: " .. sm.scrapcomputers.languageManager.translatable(message, ...)

    sm.event.sendToPlayer(sm.localPlayer.getPlayer(), "cl_n_onMessage", {message = finalMessage, displayTime = 5})
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
    
    local function bindFunction(func)
        return function(_, ...)
            return func(gui, ...)
        end
    end

    return {
        addGridItem                = bindFunction(gui.addGridItem               ),
        addGridItemsFromFile       = bindFunction(gui.addGridItemsFromFile      ),
        addToPickupDisplay         = bindFunction(gui.addToPickupDisplay        ),
        addListItem                = bindFunction(gui.addListItem               ),
        clearGrid                  = bindFunction(gui.clearGrid                 ),
        clearList                  = bindFunction(gui.clearList                 ),
        close                      = bindFunction(gui.close                     ),
        createDropDown             = bindFunction(gui.createDropDown            ),
        createGridFromJson         = bindFunction(gui.createGridFromJson        ),
        createHorizontalSlider     = bindFunction(gui.createHorizontalSlider    ),
        createVerticalSlider       = bindFunction(gui.createVerticalSlider      ),
        destroy                    = bindFunction(gui.destroy                   ),
        isActive                   = function ()
            return sm.exists(gui) and gui:isActive()
        end,
        open                       = bindFunction(gui.open                      ),
        playEffect                 = bindFunction(gui.playEffect                ),
        playGridEffect             = bindFunction(gui.playGridEffect            ),
        setButtonCallback          = bindFunction(gui.setButtonCallback         ),
        setButtonState             = bindFunction(gui.setButtonState            ),
        setColor                   = bindFunction(gui.setColor                  ),
        setContainer               = bindFunction(gui.setContainer              ),
        setContainers              = bindFunction(gui.setContainers             ),
        setData                    = bindFunction(gui.setData                   ),
        setFadeRange               = bindFunction(gui.setFadeRange              ),
        setFocus                   = bindFunction(gui.setFocus                  ),
        setGridButtonCallback      = bindFunction(gui.setGridButtonCallback     ),
        setGridItem                = bindFunction(gui.setGridItem               ),
        setGridItemChangedCallback = bindFunction(gui.setGridItemChangedCallback),
        setGridMouseFocusCallback  = bindFunction(gui.setGridMouseFocusCallback ),
        setGridSize                = bindFunction(gui.setGridSize               ),
        setHost                    = bindFunction(gui.setHost                   ),
        setIconImage               = bindFunction(gui.setIconImage              ),
        setImage                   = bindFunction(gui.setImage                  ),
        setItemIcon                = bindFunction(gui.setItemIcon               ),
        setListSelectionCallback   = bindFunction(gui.setListSelectionCallback  ),
        setMaxRenderDistance       = bindFunction(gui.setMaxRenderDistance      ),
        setMeshPreview             = bindFunction(gui.setMeshPreview            ),
        setOnCloseCallback         = bindFunction(gui.setOnCloseCallback        ),
        setRequireLineOfSight      = bindFunction(gui.setRequireLineOfSight     ),
        setSelectedDropDownItem    = bindFunction(gui.setSelectedDropDownItem   ),
        setSelectedListItem        = bindFunction(gui.setSelectedListItem       ),
        setSliderCallback          = bindFunction(gui.setSliderCallback         ),
        setSliderData              = bindFunction(gui.setSliderData             ),
        setSliderPosition          = bindFunction(gui.setSliderPosition         ),
        setSliderRange             = bindFunction(gui.setSliderRange            ),
        setSliderRangeLimit        = bindFunction(gui.setSliderRangeLimit       ),
        setText                    = function (self, widgetName, text, ...)
            gui:setText(widgetName, sm.scrapcomputers.languageManager.translatable(text, type(...) == "table" and unpack(...) or ...))
        end,
        setTextRaw                 = bindFunction(gui.setText),
        setTextAcceptedCallback    = bindFunction(gui.setTextAcceptedCallback   ),
        setTextChangedCallback     = bindFunction(gui.setTextChangedCallback    ),
        setVisible                 = bindFunction(gui.setVisible                ),
        setWorldPosition           = bindFunction(gui.setWorldPosition          ),
        stopEffect                 = bindFunction(gui.stopEffect                ),
        stopGridEffect             = bindFunction(gui.stopGridEffect            ),
        trackQuest                 = bindFunction(gui.trackQuest                ),
        untrackQuest               = bindFunction(gui.untrackQuest              ),
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
        local counter = 1

        for _, text in ipairs(tbl) do
            local parsedText

            if type(text) == "table" then
                if #text > 0 then
                    parsedText = sm.scrapcomputers.languageManager.translatable(unpack(text))
                else
                    -- fallback if empty table, e.g. empty string or some default
                    parsedText = string.rep(" ", counter)
                    counter = counter + 1
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
        sm.gui.setInteractionText(" ", "")
    end
end

function sm.scrapcomputers.gui:showInteractTextBasic(shapeUuid)
    sm.scrapcomputers.errorHandler.assertArgument(shapeUuid, 1, {"Uuid"})

    local shapeTitle = sm.shape.getShapeTitle(shapeUuid)
    shapeTitle = shapeTitle:gsub("%b[]%s*", "")

    sm.scrapcomputers.gui:showCustomInteractiveText({
        {"scrapcomputers.other.generic_interaction_text", shapeTitle}
    })
end