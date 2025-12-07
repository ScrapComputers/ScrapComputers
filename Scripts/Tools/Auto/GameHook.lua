local function createConfig()
    if not sm.scrapcomputers.config.configExists("scrapcomputers.global.power") then
        sm.scrapcomputers.logger.warn("GameHook.lua", "Config not found!")
        return
    end
    
    local backend = sm.scrapcomputers.backend.gameHook
    backend.updateConfigs = false
    
    local config = sm.scrapcomputers.config.getConfig("scrapcomputers.global.power")
    if not config.userUsed_we_need_to_have_configs_v3 then
        sm.scrapcomputers.logger.info("GameHook.lua", "Updating the Power config...")
        
        config.userUsed_we_need_to_have_configs_v3 = true
        config.selectedOption = backend.isGamemodeSurvival and 2 or 1

        sm.scrapcomputers.config.saveConfig()
    end
end

local function hookRun()
    ---@class GameHook_Backend
    local backend = sm.scrapcomputers.backend.gameHook

    local function fallback()
        sm.scrapcomputers.logger.warn("GameHook.lua", "Well uhhhh pray that sm.game.getLimitedInventory being true means its survival :sob:")
        backend.isGamemodeSurvival = sm.game.getLimitedInventory()

        backend.updateConfigs = true
    end

    sm.scrapcomputers.logger.info("GameHook.lua", "Running GameHook...")
    if pcall(sm.json.fileExists, "$CONTENT_DATA/description.json") then
        sm.scrapcomputers.logger.info("GameHook.lua", "World Gamemode: Custom Gamemode")
        backend.gamemodeType = "Custom"

        local descSuccess  , descData   = pcall(sm.json.open, "$CONTENT_DATA/description.json")
        local configSuccess, configData = pcall(sm.json.open, "$CONTENT_DATA/config.json")

        if not (descSuccess or configSuccess) then
            sm.scrapcomputers.logger.warn("GameHook.lua", "What the fuck? Custom gamemode with a unopenable config.json OR/AND description.json???")
            fallback()
            return
        end

        sm.scrapcomputers.logger.info("GameHook.lua", "Read description.json & config.json")
        if not descData.localId or not configData.baseGameContent then
            sm.scrapcomputers.logger.info("GameHook.lua", "Invalid description.json OR/AND invalid config.json?? (Shouldn't be possible)")
            fallback()
            return
        end

        backend.customGameLocalId = descData.localId
        backend.isGamemodeSurvival = configData.baseGameContent == "Survival"

        sm.scrapcomputers.logger.info("GameHook.lua", "Hook finished!")

        backend.updateConfigs = true
        return
    end

    sm.scrapcomputers.logger.info("GameHook.lua", "World Gamemode: Vanilla")

    backend.gamemodeType = "Vanilla"
    backend.customGameLocalId = "DATA"

    local output = {
        isCreative = false,
        isSurvival = false
    }

    local function classCheck(name, tbl)
        for _, tblName in pairs(tbl) do
            if _G[tblName] then
                output[name] = true
                break
            end
        end
    end

    sm.scrapcomputers.logger.info("GameHook.lua", "Running class discovery checks...")
    classCheck("isCreative", {"CreativeFlatGame", "ClassicCreativeGame", "CreativeCustomGame", "CreativeTerrainGame", "CreativeGame"})
    classCheck("isSurvival", {"SurvivalGame"})

    if output.isCreative and output.isSurvival then
        sm.scrapcomputers.logger.warn("GameHook.lua", "Creative & Survival classes discovered in enviroment? (WTF)")
        fallback()
        return
    end

    if not output.isCreative and not output.isSurvival then
        sm.scrapcomputers.logger.warn("GameHook.lua", "No Creative & Survival classes discovered in enviroment? (WTF)")
        fallback()
        return
    end

    sm.scrapcomputers.logger.info("GameHook.lua", "Found classes! (Gamemode should be \"" .. (output.isCreative and "Creative" or "Survival") .. "\")")
    backend.isGamemodeSurvival = output.isSurvival

    sm.scrapcomputers.logger.info("GameHook.lua", "Hook finished!")

    backend.updateConfigs = true
end

if sm.scrapcomputers and sm.scrapcomputers.backend and sm.scrapcomputers.backend.gameHook then
    hookRun()
    return
end

dofile("$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Scripts/Config.lua")

sm.scrapcomputers.backend.gameHook = {} ---@type GameHook_Backend

local gameHookRan = false
local function runHook()
    if gameHookRan or not sm.isServerMode() then return end
    gameHookRan = true

    dofile("$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Scripts/Tools/Auto/GameHook.lua")
end

local sm_storage_load = sm.storage.load
function sm.storage.load(...)
    runHook()
    return sm_storage_load(...)
end

local sm_world_createWorld = sm.world.createWorld
function sm.world.createWorld(...)
    runHook()
    return sm_world_createWorld(...)
end

local sm_world_loadWorld = sm.world.loadWorld
function sm.world.loadWorld(...)
    runHook()
    return sm_world_loadWorld(...)
end

---@class GameHookClass : ToolClass
GameHookClass = class()

function GameHookClass:server_onCreate()
    GameHookClass.sv_toolInstance = self.tool
end

function GameHookClass:server_onFixedUpdate()
    if sm.scrapcomputers.backend.gameHook.updateConfigs then
        createConfig()
    end
end

function GameHookClass:sv_setConfig(args, player)
    local hostOnly = sm.scrapcomputers.config.getConfig("scrapcomputers.configurator.admin_only").selectedOption == 1

    if (player == sm.scrapcomputers.backend.thisPlayer and hostOnly) or not hostOnly then
        local status, err = pcall(function ()
            sm.scrapcomputers.config.setConfig(args[2], args[3])
        end)

        if status then
            self.network:sendToClient(args.player, "cl_chatMessage", "#ffa000Success!")
        else
            local s1 = err:gsub("#", "##")
            local s2 = s1:sub(63, #s1)
            
            self.network:sendToClient(args.player, "cl_chatMessage", "Error: #ff0000"..s2)
        end
    else
        sm.scrapcomputers.logger.warn("Player \"" .. player:getName() .. "\" (ID: " .. player:getId() .. ") has attempted to iliegally set a config (admin only enabled)")
    end
end

function GameHookClass:sv_onConfigCommand(args)
    local hostOnly = sm.scrapcomputers.config.getConfig("scrapcomputers.configurator.admin_only").selectedOption == 1

    if (args.player == sm.scrapcomputers.backend.thisPlayer and hostOnly) or not hostOnly then
        self.network:sendToClient(args.player, "cl_onConfigCommand", args)
    else
        self.network:sendToClient(args.player, "cl_permissionDenied")
    end
end

function GameHookClass:cl_onConfigCommand(args)
    local command = args[1]

    if command == "/getconfigs" then
        local configString = ""

        for _, config in pairs(sm.scrapcomputers.config.configurations) do
            local configId = config.id
            local optionsString = "\n\t\t"

            for i, option in pairs(config.options) do
                local indexPrefix = "["..i.."] = "

                if option == "TRANSLATABLE_TEXT_ONLY" then
                    optionsString = optionsString..indexPrefix..sm.scrapcomputers.languageManager.translatable("config."..configId.."=option="..i).."\n\t\t"
                else
                    optionsString = optionsString..indexPrefix..option.."\n\t\t"
                end
            end

            local configName = config.name

            if configName == "TRANSLATABLE_TEXT_ONLY" then
                configName = sm.scrapcomputers.languageManager.translatable("config."..configId.."=name")
            end

            configString = configString.. "name: #ffa000"..configName.."#eeeeee\n\tid: "..configId.."\n\toptions: "..optionsString.."\n"
        end

        sm.gui.chatMessage(configString)
    elseif command == "/setconfig" then
        self.network:sendToServer("sv_setConfig", args)
    end
end

function GameHookClass:cl_permissionDenied()
    sm.gui.chatMessage("#ff0000Permission denied.")
end

function GameHookClass:cl_chatMessage(message)
    sm.gui.chatMessage(message)
end

function GameHookClass:client_onCreate()
    sm.scrapcomputers.backend.thisPlayer = sm.localPlayer.getPlayer()
end

local oldBindCommand = sm.game.bindChatCommand

local function newBindCommand(command, params, callback, help)
    if not sm.scrapcomputers.backend.commandsHooked then
        sm.scrapcomputers.backend.commandsHooked = true

        oldBindCommand("/setconfig", {{"string", "configId"}, {"int", "configOption"}}, "cl_onChatCommand", "Allows a user to set ScrapComputers config settings via a command.")
        oldBindCommand("/getconfigs", {}, "cl_onChatCommand", "Returns a list of the loaded config data sets, used for the /setconfig command.")
    end

    oldBindCommand(command, params, callback, help)
end

sm.game.bindChatCommand = newBindCommand

local oldSendToWorld = sm.event.sendToWorld

local function newSendToWorld(world, callback, args)
    if callback == "sv_e_onChatCommand" then
        sm.event.sendToTool(GameHookClass.sv_toolInstance, "sv_onConfigCommand", args)
    end
    
    oldSendToWorld(world, callback, args)
end

sm.event.sendToWorld = newSendToWorld