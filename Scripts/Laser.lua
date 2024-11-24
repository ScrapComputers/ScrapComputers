---@class LaserClass : ShapeClass
LaserClass = class()
LaserClass.maxParentCount = 1
LaserClass.maxChildCount = 0
LaserClass.connectionInput = sm.interactable.connectionType.compositeIO
LaserClass.connectionOutput = sm.interactable.connectionType.none
LaserClass.colorNormal = sm.color.new(0x696969ff)
LaserClass.colorHighlight = sm.color.new(0x969696ff)

---@return Shape|Character|Harvestable|Joint?
local function getUserdata(raycastResult)
    return raycastResult:getShape() or raycastResult:getCharacter() or raycastResult:getHarvestable() or raycastResult:getJoint() or nil
end

-- SERVER --

function LaserClass:sv_createData()
    return {
        ---Sets the laser's distance
        ---@param distance integer The distance
        setDistance = function(distance)
            sm.scrapcomputers.errorHandler.assertArgument(distance, nil, {"number"})
            sm.scrapcomputers.errorHandler.assert(distance > 0 and distance < 100000, "Laser distance out of bounds")

            self.sv.distance = distance
        end,

        ---Gets laser data
        ---@return boolean hit If it has hit something
        ---@return LaserData data The laser data
        getLaserData = function()
            return self:sv_laserRaycast()
        end,

        ---Toggles the laser's visiblity
        ---@param bool boolean To enable or disable the visibility
        toggleLaser = function(bool)
            self.sv.laserVisibility = bool
        end,

        -- Returns true if the beam is visible or false if invisible
        ---@return boolean bool If the laser is visible or invisible
        isBeamEnabled = function ()
            return self.sv.laserVisibility
        end,

        ---Sets if the laser ignores the current body its placed on
        ---@param bool boolean The boolean
        ignoreCurrentBody = function(bool)
            self.sv.ignoreCurrentBody = bool
        end
    }
end

function LaserClass:server_onCreate()
    -- Server side variables
    self.sv = {
        distance = 1000,
        laserVisibility = true,
        lastVisible = true,
        ignoreCurrentBody = false,
        hit = false,
        res = nil, ---@type RaycastResult 
    }
end

function LaserClass:server_onFixedUpdate()
    local startPos = self.shape.worldPosition
    local laserDir = self.shape.worldRotation * sm.vec3.new(0, 0, 1)

    local endPos = startPos + laserDir * self.sv.distance

    self.sv.hit, self.sv.res = sm.physics.raycast(startPos, endPos, self.sv.ignoreCurrentBody and self.shape.body)

    if self.sv.hit then
        local dist = self.sv.res.fraction * self.sv.distance

        if self.sv.lastDist ~= dist then
            self.sv.lastDist = dist
            self.network:sendToClients("cl_updateEffect", {scale = sm.vec3.new(0.01, 0.01, dist), offset = sm.vec3.new(0, 0, dist / 2)})
        end
    else
        if self.sv.distance ~= self.sv.lastDist then
            self.sv.lastDist = self.sv.distance
            self.network:sendToClients("cl_updateEffect", {scale = sm.vec3.new(0.01, 0.01, self.sv.distance), offset = sm.vec3.new(0, 0, self.sv.distance / 2)})
        end
    end

    if self.sv.laserVisibility ~= self.sv.lastVisible then
        self.sv.lastVisible = self.sv.laserVisibility

        self.network:sendToClients("cl_setVis", self.sv.laserVisibility)
    end
end

---@return boolean hit If it has hit something
---@return LaserData data The data 
function LaserClass:sv_laserRaycast()
    local userdata = getUserdata(self.sv.res)
    local color = userdata and userdata:getColor() or nil

    local dataTable = {
        directionWorld = self.sv.res.directionWorld,
        fraction = self.sv.res.fraction,
        normalLocal = self.sv.res.normalLocal,
        normalWorld = self.sv.res.normalWorld,
        originWorld = self.sv.res.originWorld,
        pointLocal = self.sv.res.pointLocal,
        pointWorld = self.sv.res.pointWorld,
        type = self.sv.res.type,
        valid = self.sv.res.valid,
        color = color
    }

    return self.sv.hit, dataTable
end

-- CLIENT --

function LaserClass:client_onCreate()
    self.cl = {
        effect = sm.effect.createEffect("ShapeRenderable", self.interactable),
        laserVisibility = true
    }

    self.cl.effect:setParameter("color", sm.color.new("ee0000"))
    self.cl.effect:setParameter("uuid", sm.uuid.new("628b2d61-5ceb-43e9-8334-a4135566df7a"))
    self.cl.effect:setScale(sm.vec3.new(0.01, 0.01, 0.01))

    self.cl.effect:start()
end

function LaserClass:cl_updateEffect(data)
    self.cl.effect:setScale(data.scale)
    self.cl.effect:setOffsetPosition(data.offset)
end

function LaserClass:cl_setVis(bool)
    if not self.cl.effect:isPlaying() and bool then
        self.cl.effect:start()
        return
    end
    self.cl.effect:stop()
end

sm.scrapcomputers.componentManager.toComponent(LaserClass, "Lasers", true)