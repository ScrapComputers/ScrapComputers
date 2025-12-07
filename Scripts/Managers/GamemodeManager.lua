sm.scrapcomputers.gamemodeManager = {}

function sm.scrapcomputers.gamemodeManager.isSurvival()
    return sm.scrapcomputers.backend.gameHook.isGamemodeSurvival
end

function sm.scrapcomputers.gamemodeManager.isCustomGamemode()
    return sm.scrapcomputers.backend.gameHook.gamemodeType == "Custom"
end

function sm.scrapcomputers.gamemodeManager.getCustomGamemodeLocalId()
    return sm.scrapcomputers.backend.gameHook.customGameLocalId
end