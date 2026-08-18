dofile("$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Scripts/Config.lua")

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

sm.scrapcomputers.backend.gameHook = {}


GameHookClass = class()

function GameHookClass:server_onCreate()
    GameHookClass.sv_toolInstance = self.tool
    
    sm.gui.chatMessage("#00c0e0NOTICE:#eeeeee Certain features with ScrapComputers have either been degraded or removed due to Chapter 2. More information can be found in the Discord Server.")
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

function GameHookClass:client_onCreate()
    sm.scrapcomputers.backend.thisPlayer = sm.localPlayer.getPlayer()
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


local oldBindCommand = sm.game.bindChatCommand

local function newBindCommand(command, params, callback, help)
    if not sm.scrapcomputers.backend.commandsHooked then
        sm.scrapcomputers.backend.commandsHooked = true

        oldBindCommand("/setconfig", {{"string", "configId"}, {"int", "configOption"}}, "cl_onChatCommand", "Allows a user to set ScrapComputers config settings via a command.")
        oldBindCommand("/getconfigs", {}, "cl_onChatCommand", "Returns a list of the loaded config data sets, used for the /setconfig command.")
    end

    if not sm.scrapcomputers.backend.fetched then
        sm.scrapcomputers.backend.fetched = true

        local backend = sm.scrapcomputers.backend.gameHook

        if pcall(sm.json.fileExists, "$CONTENT_DATA/description.json") then
            backend.gamemodeType = "Custom"

            local descExists, description = pcall(sm.json.open, "$CONTENT_DATA/description.json")
            local confExists, config = pcall(sm.json.open, "$CONTENT_DATA/config.json")

            if descExists and description and description.localId then
                backend.customGameLocalId = description.localId
            else
                backend.customGameLocalId = "DATA"
            end

            if confExists and config and config.baseGameContent then
                backend.isGamemodeSurvival = (config.baseGameContent == "Survival")
            else
                backend.isGamemodeSurvival = sm.game.getLimitedInventory()
            end

            backend.updateConfigs = true
        else
            backend.gamemodeType = "Vanilla"
            backend.customGameLocalId = "DATA"
            
            local foundSurvival = false
            for level = 3, 15 do
                local _, trace = pcall(error, "", level)

                if string.find(trace, "$SURVIVAL_DATA/") and string.find(trace, "SurvivalGame.lua") then
                    foundSurvival = true
                    break
                elseif string.find(trace, "$GAME_DATA/") and string.find(trace, "CreativeGame.lua") then
                    foundSurvival = false
                    break
                end
            end
            
            backend.isGamemodeSurvival = foundSurvival
            backend.updateConfigs = true
        end
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