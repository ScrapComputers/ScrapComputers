dofile("$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Scripts/Config.lua")

---@class LanguageReloaderClass : ToolClass
LanguageReloaderClass = class()

function LanguageReloaderClass:client_onCreate()
end

function LanguageReloaderClass:client_onFixedUpdate()
    if sm.game.getCurrentTick() % 40 == 0 then
        sm.scrapcomputers.languageManager.reloadLanguages()
    end
end

function LanguageReloaderClass:client_onRefresh()
    self:client_onCreate()
end