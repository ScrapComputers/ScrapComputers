PlayerOwnership = {}

---@param klass ShapeClass
function PlayerOwnership:init(klass)
    if sm.isServerMode() then
        ---@class PlayerOwnership.Server
        klass.sv.playerOwnership = {
            ownerId = -1,

            ---@param id integer
            setPlayerId = function (self, id)
                self.ownerId = id
                klass.network:sendToClients("cl_playerOwnership_syncResponse", {self.ownerId == id, self.ownerId ~= -1})
            end,

            getPlayerId = function (self)
                return self.ownerId
            end,
        }

        klass.sv_playerOwnership_syncRequest = function (self, _, player)
            self.network:sendToClient(player, "cl_playerOwnership_syncResponse", {self.sv.playerOwnership.ownerId == player:getId(), self.sv.playerOwnership.ownerId ~= -1})
        end

        ---@param player Player
        local function isPlayerClose(self, player)
            if not player.character then
                return false
            end

            local worldPos = player.character.worldPosition
            local distance = (worldPos - self.shape.worldPosition):length()

            return distance <= 7.5
        end

        klass.sv_playerOwnership_tryOwning = function (self, _, player)
            if self.sv.playerOwnership.ownerId == player:getId() then
                return
            end

            if isPlayerClose(self, player) and self.sv.playerOwnership.ownerId == -1 then
                local allowed = true
                if self.server_onPlayerOwnershipRequested then
                    allowed = self:server_onPlayerOwnershipRequested(player)
                end

                if allowed then
                    self.sv.playerOwnership.ownerId = player:getId()
                end

                for _, player in pairs(sm.player.getAllPlayers()) do
                    self:sv_playerOwnership_syncRequest(nil, player)
                end
                
                return
            end
            
            self:sv_playerOwnership_syncRequest(nil, player)
            sm.scrapcomputers.logger.warn("Player \"" .. player:getName() .. "\" (ID: " .. player:getId() .. ") has attempted to update the ownership of a computer iliegally!")
        end

        klass.sv_playerOwnership_removeOwner = function (self, _, player)
            if isPlayerClose(self, player) and self.sv.playerOwnership.ownerId == player:getId() then
                self.sv.playerOwnership.ownerId = -1

                for _, player in pairs(sm.player.getAllPlayers()) do
                    self:sv_playerOwnership_syncRequest(nil, player)
                end
                return
            end
            
            self:sv_playerOwnership_syncRequest(nil, player)
            sm.scrapcomputers.logger.warn("Player \"" .. player:getName() .. "\" (ID: " .. player:getId() .. ") has attempted to remove the ownership of a computer iliegally!")
        end
    else
        ---@class PlayerOwnership.Client
        klass.cl.playerOwnership = {
            owner = false,
            hOwner = false,

            ownInteractable = function (self)
                klass.network:sendToServer("sv_playerOwnership_tryOwning")
                self.owner = true
                self.hOwner = true
            end,

            stopOwningInteractable = function (self)
                klass.network:sendToServer("sv_playerOwnership_removeOwner")
                self.owner = false
                self.hOwner = false
            end,

            isOwner = function (self)
                return self.owner
            end,

            hasOwner = function (self)
                return self.hOwner
            end
        }

        local old = klass.client_onFixedUpdate
        klass.client_onFixedUpdate = function(self, dt)
            old(self, dt)

            if sm.game.getCurrentTick() % 40 == 0 then
                local localPlayer = sm.localPlayer.getPlayer()
                local distance = (localPlayer.character.worldPosition - self.shape.worldPosition):length()

                if distance <= 7.5 then
                    self.network:sendToServer("sv_playerOwnership_syncRequest")
                end
            end
        end

        klass.cl_playerOwnership_syncResponse = function (self, tbl)
            self.cl.playerOwnership.owner = tbl[1]
            self.cl.playerOwnership.hOwner = tbl[2]
        end
    end
end