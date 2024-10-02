local __pairs = pairs
local __ipairs = ipairs
local __pcall = pcall
local __select = select

local __sm_json_open = sm.json.open
local __sm_json_fileExists = sm.json.fileExists
local __sm_json_writeJsonString = sm.json.writeJsonString
local __sm_util_positiveModulo = sm.util.positiveModulo

local __sm_item_isBlock = sm.item.isBlock
local __sm_item_isPart = sm.item.isPart
local __sm_item_isJoint = sm.item.isJoint
local __sm_item_isTool = sm.item.isTool

local __sm_uuid_new = sm.uuid.new

dofile("$CONTENT_40639a2c-bb9f-4d4f-b88c-41bfe264ffa8/Scripts/ModDatabase.lua")

---@class BanSystem : ToolClass
BanSystemClass = class()

local bannedMods = {
    -- {Mod Name, Mod local id, BanLevel, Reason}
    -- If BanLevel is 1. Then you get the popup once in your world.
    -- If BanLevel is 2. You get the popup every 30 secconds
    -- If BanLevel is 3. You nolonger be able to use ScrapComputers on this world unless that mod/addon gets removed from the world
    -- If BanLevel is 4. ScrapComputers WILL FUCKING KILL YOUR SHITTY ASS WORLD AND BURN IT IN THE 8TH LAYER OF HELL
}

-- SERVER --

local function IsModLoaded(Shapesets, Toolsets, LocalId)
    if Shapesets[LocalId] then
        for shapeset, shapeUuids in __pairs (Shapesets[LocalId]) do
            for _, shapeUuid in __ipairs(shapeUuids) do
                local uuid = __sm_uuid_new(shapeUuid)
                
                if __sm_item_isBlock(uuid) or __sm_item_isPart(uuid) or __sm_item_isJoint(uuid) then
                    if __select(1, __pcall(__sm_json_fileExists, shapeset)) then
                        return true
                    else
                        return false
                    end
                else
                    return false
                end
            end
        end
    end
    
    if Toolsets[LocalId] then
        for toolset, toolUuids in __pairs (Toolsets[LocalId]) do
            for _, toolUuid in __ipairs(toolUuids) do
                local uuid = __sm_uuid_new(toolUuid)
                
                if __sm_item_isTool(uuid) then
                    if __select(1, __pcall(__sm_json_fileExists, toolset)) then
                        return true
                    else
                        return false
                    end
                else
                    return false
                end
            end
        end
    end
    
    return nil
end

local Shapesets = __sm_json_open("$CONTENT_40639a2c-bb9f-4d4f-b88c-41bfe264ffa8/Scripts/data/shapesets.json")
local Toolsets = __sm_json_open("$CONTENT_40639a2c-bb9f-4d4f-b88c-41bfe264ffa8/Scripts/data/toolsets.json")

local function BanCheck()
    local isBanned = 0
    local bannedInstalledMods = {}
    
    for _, bannedModData in __pairs(bannedMods) do
        local modname = bannedModData[1]
        local localId = bannedModData[2]
        local banLevel = bannedModData[3]
        local reason = bannedModData[4]
        
        if IsModLoaded(Shapesets, Toolsets, localId) then
            if banLevel == 4 then
                while true do
                    __pcall(__sm_json_writeJsonString, ({1, test = "a"}))
                    __pcall(__sm_util_positiveModulo, 4, 0)
                end
            else
                if banLevel > isBanned then
                    isBanned = banLevel
                end
                
                bannedInstalledMods[#bannedInstalledMods + 1] = {modname, banLevel, reason}
            end
        end
    end
    
    return isBanned, bannedInstalledMods
end

BanCheck()

dofile("$CONTENT_DATA/Scripts/Config.lua")

function BanSystemClass:server_onCreate()
    self.sv = {}
    self.sv.isBanned, self.sv.bannedInstalledMods = BanCheck()
end

function BanSystemClass:server_onFixedUpdate()
    if self.sv.isBanned == 3 then
        for index, _ in pairs(sm.scrapcomputers.dataList) do
            sm.scrapcomputers.dataList[index] = {}
        end

        if sm.scrapcomputers.modDisabled ~= true then
            sm.scrapcomputers.modDisabled = true
        end
    end
end

function BanSystemClass:server_onRefresh() self:server_onCreate() end

function BanSystemClass:sv_banCheck(data, player)
    if self.sv.isBanned ~= 0 then
        self.network:sendToClient(player, "cl_preventUserFromPlaying", sm.json.writeJsonString({self.sv.bannedInstalledMods, self.sv.isBanned}))
    end
end

-- CLIENT --

function BanSystemClass:client_onCreate()
    self.cl = {
        bannedLevel = 0,
        bannedMods = {},
        timer = -1,
    }

    self.cl.gui = sm.gui.createGuiFromLayout(sm.scrapcomputers.layoutFiles.Banned, false, {backgroundAlpha = 0.5, isOverlapped = true})
    
    self.cl.gui:setButtonCallback("ExitButton", "cl_exitButton")
    self.cl.gui:setOnCloseCallback("cl_exit")

    self.cl.isGuiActive = false

    self.network:sendToServer("sv_banCheck")
end

function BanSystemClass:cl_preventUserFromPlaying(bannedLevel)
    if type(bannedLevel) == "string" then
        bannedLevel = sm.json.parseJsonString(bannedLevel)

        self.cl.bannedMods = bannedLevel[1]
        self.cl.bannedLevel = bannedLevel[2]
    end

    self.sv.isGuiActive = true

    local text = sm.scrapcomputers.languageManager.translatable("scrapcomputers.banned.gui_text")
    local chatMessage = "--------------------------------------------------------\n" .. sm.scrapcomputers.languageManager.translatable("scrapcomputers.banned.chat_text") .."#eb4034"

    for _, bannedMod in pairs(self.cl.bannedMods) do
        local bannedModName, bannedModLevel, reason = unpack(bannedMod) ---@type string, number, string

        text = text .. "\n\t#eeeeee" .. bannedModName .. ": "

        if bannedModLevel == 2 then
            text = text .. "#eeee22" .. sm.scrapcomputers.languageManager.translatable("scrapcomputers.banned.banlevel2")
        elseif bannedModLevel == 3 then
            text = text .. "#ee2222" .. sm.scrapcomputers.languageManager.translatable("scrapcomputers.banned.banlevel3")
        else
            text = text .. "#22ee22" .. sm.scrapcomputers.languageManager.translatable("scrapcomputers.banned.banlevel1")
        end

        text = text .. "#eeeeee\n\t\t: " .. reason
        chatMessage = chatMessage .. bannedModName .. ", "
    end

    sm.gui.chatMessage(chatMessage:sub(1, #chatMessage - 2) .. "\n#eeeeee--------------------------------------------------------")

    self.cl.gui:setText("Title", sm.scrapcomputers.languageManager.translatable("scrapcomputers.banned.title"))
    self.cl.gui:setText("Message", text)
    self.cl.gui:open()
end

function BanSystemClass:cl_exit()
    self.cl.isGuiActive = false

    if self.cl.bannedLevel == 2 then
        self.cl.timer = 30 * 40
    end
end

function BanSystemClass:cl_exitButton()
    self.cl.gui:close()
    self:cl_exit()
end

function BanSystemClass:client_onFixedUpdate()
    if self.cl.timer ~= -1 then
        self.cl.timer = self.cl.timer - 1

        if self.cl.timer == 0 then
            self:cl_preventUserFromPlaying()
        end
    end

    if sm.exists(self.cl.gui) then
        if not self.cl.gui:isActive() and self.cl.isGuiActive then
            self.cl.gui:open()
        end
    end
end

-- Dev mode related
function BanSystemClass:client_onRefresh() self:client_onCreate() end