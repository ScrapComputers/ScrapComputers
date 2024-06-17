-- Prevent hooking (hopefully)
local __pairs = pairs
local __pcall = pcall

dofile("$CONTENT_40639a2c-bb9f-4d4f-b88c-41bfe264ffa8/Scripts/ModDatabase.lua")
dofile("$CONTENT_DATA/Scripts/Config.lua")

---@class BanSystem : ToolClass
BanSystem = class()

local bannedMods = {
    -- {Mod Name, Mod local id, BanLevel}
    -- If BanLevel is 1. Then you get the popup once in your world.
    -- If BanLevel is 2. You get the popup every 30 secconds
    -- If BanLevel is 3. You nolonger be able to use ScrapComputers on this world unless that mod/addon gets removed from the world
    -- If BanLevel is 4. Your game will crash on load of world.
}

-- SERVER --

function BanSystem:server_onCreate()
    -- Load the shapesets and toolsets
    ModDatabase.loadShapesets()
    ModDatabase.loadToolsets()

    -- Create the needed variables
    self.isBanned = 0
    self.bannedInstalledMods = {}

    -- Loop through all banned mods
    for _, bannedModData in __pairs(bannedMods) do
        -- Get the data and put them into variables
        ---@type string, string, boolean
        local modname = bannedModData[1]
        local localId = bannedModData[2]
        local banLevel = bannedModData[3]

        -- Check if the mod is loaded
        if ModDatabase.isModLoaded(localId) then
            -- If banLevel is 4. crash the game in 3 ways.
            if banLevel == 4 then
                __pcall(sm.json.writeJsonString, ({1, test = "a"}))
                __pcall(sm.util.positiveModulo , 4, 0)

                while true do end
            else
                -- If banLevel is higher than self.isBanned, update it
                if banLevel > self.isBanned then
                    self.isBanned = banLevel
                end

                -- Add the banned mod name and level to the self.bannedInstalledMods
                self.bannedInstalledMods[#self.bannedInstalledMods + 1] = {modname, banLevel}
            end
        end
    end

    -- Unload the shapesets and toolsets
    ModDatabase.unloadShapesets()
    ModDatabase.unloadToolsets()
end

function BanSystem:server_onFixedUpdate()
    -- Check if its 3
    if self.isBanned == 3 then
        -- Loop through sc.dataList and clear it
        for index, _ in pairs(sc.dataList) do
            sc.dataList[index] = {}
        end

        -- Change sc.modDisabled to true if it isnt true
        if sc.modDisabled ~= true then
            sc.modDisabled = true
        end
    end
end

-- Dev mode related
function BanSystem:server_onRefresh() self:server_onCreate() end

-- Ban checking for clients
function BanSystem:sv_banCheck(_, player)
    -- If self.isBanned isnt 0. send packet to the player.
    if self.isBanned ~= 0 then
        self.network:sendToClient(player, "cl_preventUserFromPlaying", sm.json.writeJsonString({self.bannedInstalledMods, self.isBanned}))
    end
end

-- CLIENT --

function BanSystem:client_onCreate()
    -- Create variables
    self.bannedLevel = 0
    self.bannedMods = {}
    self.timer = -1

    -- Perform a check
    self.network:sendToServer("sv_banCheck")

    -- Scrap Mechanic sucks! So this states when the gui is active or not
    self.isGuiActive = false
end

function BanSystem:cl_preventUserFromPlaying(bannedLevel)
    -- If its a string, convert it back to a table and update self.bannedMods
    if type(bannedLevel) == "string" then
        bannedLevel = sm.json.parseJsonString(bannedLevel)

        -- Update bannedMods and bannedLevel
        self.bannedMods = bannedLevel[1]
        self.bannedLevel = bannedLevel[2]
    end

    -- Set self.isGuiActive to true
    self.isGuiActive = true
    
    -- Create the gui
    self.gui = sm.gui.createGuiFromLayout(sc.layoutFiles.Banned)

    -- Create the callbacks
    self.gui:setButtonCallback("ExitButton", "cl_exitButton")
    self.gui:setOnCloseCallback("cl_exit")

    -- The starting text
    local text = "ScrapComputers has detected that a Addon/Mod has been installed but disallowed by ScrapComputers\n\nMods that are loaded into your world that are banned. (Modname and then what happens when you load that mod)"
    
    -- Loop through all banned mods that were detected
    for _, bannedMod in pairs(self.bannedMods) do
        -- Unpack it to get it's banned mod name and level
        local bannedModName, bannedModLevel = unpack(bannedMod)

        -- Add the mod name to it
        text = text.."\n\t#eeeeee"..bannedModName..": "

        -- Add the level text to it

        -- Why not sort this into ranks?
        if bannedModLevel == 2 then
            text = text.."#eeee22Show this Popup every 30 secconds" -- Annoying rank
        elseif bannedModLevel == 3 then
            text = text.."#ee2222ScrapComputers is disabled entirly!" -- "Your a disapointment to your family" rank
        else
            text = text.."#22ee22Nothing happens!" -- Good bad rank??
        end
    end

    -- Send the chat message
    sm.gui.chatMessage(text)

    -- Update the text
    self.gui:setText("Message", text)

    -- Open it
    self.gui:open()
end

function BanSystem:cl_exit()
    -- Set this to false
    self.isGuiActive = false

    -- If ban level is 2, set self.timer to 30 secconds
    if self.bannedLevel == 2 then
        self.timer = 30 * 40
    end 
end

function BanSystem:cl_exitButton()
    -- Close the gui
    self.gui:close()

    self:cl_exit() -- We can reuse the cl_exit callback 
end

function BanSystem:client_onFixedUpdate()
    -- Check if timer is not -1
    if self.timer ~= -1 then
        -- Decrease timer by 1
        self.timer = self.timer - 1

        -- If its 0, open the gui again!
        if self.timer == 0 then
            self:cl_preventUserFromPlaying()
        end
    end
    
    -- Check if the gui exists
    if self.gui and sm.exists(self.gui) then
        -- Check if the gui is not active even tho it should be, Open it.
        if not self.gui:isActive() and self.isGuiActive then
            self.gui:open()
        end
    end
end

-- Dev mode related
function BanSystem:client_onRefresh() self:client_onCreate() end