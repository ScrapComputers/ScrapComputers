---@class RadarClass : ShapeClass
RadarClass = class()
RadarClass.maxParentCount = -1
RadarClass.maxChildCount = 0
RadarClass.connectionInput = sm.interactable.connectionType.compositeIO
RadarClass.connectionOutput = sm.interactable.connectionType.none
RadarClass.colorNormal = sm.color.new(0xa8604cff)
RadarClass.colorHighlight = sm.color.new(0xe06d2bff)

-- CLIENT / SERVER --
local body_getAllBodies = sm.body.getAllBodies
local player_getAllPlayers = sm.player.getAllPlayers
local unit_getAllUnits = sm.unit.getAllUnits
local physics_raycast = sm.physics.raycast

local math_abs = math.abs
local math_asin = math.asin
local math_acos = math.acos
local math_sqrt = math.sqrt

local isSurvival = sm.scrapcomputers.gamemodeManager.isSurvival() or sm.scrapcomputers.config.getConfig("scrapcomputers.global.survivalBehavior").selectedOption == 2

-- SERVER --

function RadarClass:sv_createData()
    return {
        -- Gets its targets and returns them.
        ---@return RadarTarget[] targets The list of detected targets
        getTargets = function() return self:sv_calculateTargets() end,

        -- Sets the vertical scan angle
        ---@param angle number The angle
        setVerticalScanAngle = function(angle)
            sm.scrapcomputers.errorHandler.assertArgument(angle, nil, {"number"})
            sm.scrapcomputers.errorHandler.assert(angle >= 10 and angle <= 90, nil, "Angle must be within 10 and 90 degrees")

            self.sv.vAngle = angle
        end,

        -- Sets the horizontal scan angle
        ---@param angle number The angle
        setHorizontalScanAngle = function(angle)
            -- Type check
            sm.scrapcomputers.errorHandler.assertArgument(angle, nil, {"number"})
            sm.scrapcomputers.errorHandler.assert(angle >= 10 and angle <= 90, nil, "Angle must be within 10 and 90 degrees")

            self.sv.hAngle = angle
        end,
}
end

function RadarClass:server_onCreate()
    self.sv = {
        vAngle = 30,
        hAngle = 30,
        targets = {},
    }
end

function RadarClass:server_onFixedUpdate()
    if not self.sv.lastCheck or self.sv.lastCheck + 2 < os.clock() then
        self.sv.lastCheck = os.clock()

        sm.scrapcomputers.backend.radarTargets = {}
    end

    sm.scrapcomputers.powerManager.updatePowerInstance(self.shape.id, 30)
end

local function getCreationPosition(body)
    local bodies = body:getCreationBodies()
    local totalMass = 0
    local comSum = sm.vec3.zero()

    for _, b in pairs(bodies) do
        local mass = b.mass
        local pos = b:getCenterOfMassPosition()
        comSum = comSum + pos * mass
        totalMass = totalMass + mass
    end

    if totalMass == 0 then
        return sm.vec3.zero()
    end

    return comSum / totalMass
end

function RadarClass:sv_calculateTargets()
    local bodies = body_getAllBodies()
    local players = player_getAllPlayers()
    local units = unit_getAllUnits()

    local losCreations = {}
    local creationPoss = {}
    local losUnits = {}

    local shape = self.shape
    local interp = shape.worldPosition - shape:getInterpolatedWorldPosition()
    local radarPos = shape.worldPosition + interp
    local radarRot = shape.worldRotation
    local radarAt = sm.quat.getAt(radarRot)
    local radarUp = sm.quat.getUp(radarRot)

    local vAngleRad = math.rad(self.sv.vAngle * 0.5)
    local hAngleRad = math.rad(self.sv.hAngle * 0.5)
    local surfaceAreaBound = self.sv.hAngle * self.sv.vAngle / 80

    local localCreationId = shape.body:getCreationId()

    for i = 1, #bodies do
        local body = bodies[i]
        local creationId = body:getCreationId()

        if creationId ~= localCreationId and not losCreations[creationId] then
            local creationPos = getCreationPosition(body)
            local diff = creationPos - radarPos
            local dist = diff:length()

            if dist > 0 then
                local dir = diff / dist

                if radarAt:dot(dir) <= 0 then
                    goto continue
                end

                local vDot = dir:dot(radarUp)
                local vAngle = math_abs(math_asin(vDot))

                if vAngle <= vAngleRad then
                    local hDir = dir - radarUp * vDot
                    local hLen = hDir:length()

                    if hLen > 0 then
                        hDir = hDir / hLen
                        if math_acos(radarAt:dot(hDir)) <= hAngleRad then
                            local shape0 = body:getShapes()[1]
                            local bInterp = shape0.worldPosition - shape0:getInterpolatedWorldPosition()

                            local hit, res = physics_raycast(
                                radarPos,
                                creationPos + bInterp,
                                shape.body
                            )

                            if hit and res.type == "body" then
                                local resBody = res:getBody()
                                local cid = resBody:getCreationId()

                                if not losCreations[cid] then
                                    losCreations[cid] = resBody:getCreationBodies()
                                    creationPoss[cid] = creationPos
                                    losCreationsCheck = true
                                end
                            end
                        end
                    end
                end
            end
        end

        ::continue::
    end

    local function unitCheck(unit)
        local character = unit.character
        if not character then return end

        local diff = character.worldPosition - radarPos
        local dist = diff:length()
        if dist <= 0 then return end

        local dir = diff / dist

        if radarAt:dot(dir) <= 0 then return end

        local vDot = dir:dot(radarUp)
        if math_abs(math_asin(vDot)) > vAngleRad then return end

        local hDir = dir - radarUp * vDot
        local hLen = hDir:length()
        if hLen <= 0 then return end

        hDir = hDir / hLen
        if math_acos(radarAt:dot(hDir)) > hAngleRad then return end

        local hit, res = physics_raycast(radarPos, radarPos + dir * dist, shape.body)
        if hit and res.type == "character" then
            losUnits[unit.id] = unit
        end
    end

    for i = 1, #players do unitCheck(players[i]) end
    for i = 1, #units do unitCheck(units[i]) end

    local finalTargets = {}

    for creationId, creation in pairs(losCreations) do
        local minBound, maxBound
        local isDynamic = true
        local mass = 0

        for i = 1, #creation do
            local body = creation[i]
            if sm.exists(body) then
                local min, max = body:getLocalAabb()
                minBound = minBound and minBound:min(min) or min
                maxBound = maxBound and maxBound:max(max) or max

                if isDynamic and body:isStatic() then
                    isDynamic = false
                end

                mass = mass + body.mass
            end
        end

        local position = creationPoss[creationId]
        local distance = (shape.worldPosition - position):length()
        local bb = maxBound - minBound

        local surfaceArea =
            ((bb.x * bb.z + bb.x * bb.y + bb.z * bb.y) / 2 / math_sqrt(distance)) * 8

        if surfaceArea > surfaceAreaBound or distance < 200 then
            if not sm.scrapcomputers.backend.radarTargets[creationId] then
                sm.scrapcomputers.backend.radarTargets[creationId] = {}
            end

            local sPosition = shape.worldPosition
            if isSurvival then
                local noise = sm.scrapcomputers.vector3.randomNoise(20)
                sPosition = sPosition + (noise - noise / 2)
            end

            sm.scrapcomputers.backend.radarTargets[creationId][shape.id] = sPosition

            finalTargets[#finalTargets + 1] = {
                position = position,
                velocity = creation[1].velocity,
                isDynamic = isDynamic,
                mass = mass,
                surfaceArea = surfaceArea,
                type = "creation",
                id = creationId
            }
        end
    end

    for _, unit in pairs(losUnits) do
        local c = unit.character
        local pos = c.worldPosition
        local dist = (shape.worldPosition - pos):length()
        local surfaceArea = (c:getHeight() * c.mass) / math_sqrt(dist)

        if surfaceArea > surfaceAreaBound or dist < 200 then
            finalTargets[#finalTargets + 1] = {
                position = pos,
                velocity = c.velocity,
                isDynamic = true,
                mass = c.mass,
                surfaceArea = surfaceArea,
                type = "unit",
                id = unit.id
            }
        end
    end

    return finalTargets
end



sm.scrapcomputers.componentManager.toComponent(RadarClass, "Radars", true, nil, true)