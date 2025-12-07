local CHAR_ANIM_TIME = 0.01
local TICK_RATE = 40

sm.scrapcomputers.fancyInfoLogger = {}

---Creates a new instance
---@return self instance The created instance
function sm.scrapcomputers.fancyInfoLogger:new()
    return sm.scrapcomputers.table.merge(self, {
        currentLog = {text = "", color = ""},
        lastTick = 0,
        animating = false,
        defaultText = ""
    })
end

---Gets the default text
---@return string defaultText The default text
function sm.scrapcomputers.fancyInfoLogger:getDefaultText()
    return self.defaultText
end

---Sets the default text, Note that the `text` and variadic arguments get passed through `sm.scrapcomputers.languageManager.translatable`
---@param text string The translation text to set
---@param ... any[] Arguments for the translation text
function sm.scrapcomputers.fancyInfoLogger:setDefaultText(text, ...)
    self.defaultText = sm.scrapcomputers.languageManager.translatable(text, ...)
end

---Creates a instance from data of a SharedTable
---@param data table The data
---@return self instance The created instance
function sm.scrapcomputers.fancyInfoLogger:newFromSharedTable(data)
    return sm.scrapcomputers.table.merge(self, data)
end

---Sends a log, Note that the `text` and variadic arguments get passed through `sm.scrapcomputers.languageManager.translatable`
---@param text string The translation text to set
---@param color string? The color of the log
---@param ... any[] Arguments for the translation text
function sm.scrapcomputers.fancyInfoLogger:showLog(text, color, ...)
    self.currentLog = {
        text = sm.scrapcomputers.languageManager.translatable(text, ...),
        color = (color or "#eeeeee")
    }

    self.lastTick = sm.game.getCurrentTick()
    self.animating = true
end

---Gets the current log with the animation, you should put the return value into a text widget every tick.
---@return string log The current log
function sm.scrapcomputers.fancyInfoLogger:getLog()
    local currentTick = sm.game.getCurrentTick()
    if not self.animating then
        return self.defaultText
    end

    local elapsedTicks = currentTick - self.lastTick

    local log, color = self.currentLog.text, self.currentLog.color
    local logLength = #log
    local charAnimTicks = CHAR_ANIM_TIME * TICK_RATE

    if elapsedTicks < charAnimTicks then
        return ""
    end

    if elapsedTicks < charAnimTicks * logLength then
        -- Animation: characters appear left to right
        local charsToShow = math.floor(elapsedTicks / charAnimTicks)
        return color .. log:sub(1, charsToShow)
    elseif elapsedTicks < TICK_RATE * 4 then
        -- Fully shown for 4 seconds
        return color .. log
    elseif elapsedTicks < TICK_RATE * 4 + charAnimTicks * logLength then
        -- Animation: characters disappear right to left
        local charsToShow = math.floor((charAnimTicks * logLength - (elapsedTicks - TICK_RATE * 4)) / charAnimTicks)
        return color .. log:sub(1, math.max(charsToShow, 0))
    else
        -- Animation finished
        self.animating = false
        self.currentLog = {text = "", color = ""}
        return ""
    end
end
