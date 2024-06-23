dofile("$CONTENT_DATA/Scripts/Config.lua")

---@class Laser : ShapeClass
Laser = class()
Laser.maxParentCount = 1
Laser.maxChildCount = 0
Laser.connectionInput = sm.interactable.connectionType.compositeIO
Laser.connectionOutput = sm.interactable.connectionType.none
Laser.colorNormal = sm.color.new(0x696969ff)
Laser.colorHighlight = sm.color.new(0x969696ff)

-- CLIENT / SERVER --

local function createErrorStr(type, checkType, arg)
    return "bad argument #" .. arg .. ". Expected " .. checkType .. ". Got " .. type .. " instead."
end

-- SERVER --

function Laser:sv_createData()
    return {
        setDistance = function(distance)
            local type_ = type(distance)
            assert(type_ == "number", createErrorStr(type_, "number", 1))
            assert(distance > 0 and distance < 100000, "bad argument #1, laser distance out of bounds")

            self.sv.distance = distance
        end,

        getLaserData = function()
            return self:sv_laserRaycast()
        end 
    }
end

function Laser:server_onCreate()
    self.sv = {
        distance = 1000
    }
end

function Laser:sv_laserRaycast()
    local startPos = self.shape.worldPosition
    local laserDir = self.shape.worldRotation * sm.vec3.new(0, 0, 1)
    local endPos = startPos + laserDir * self.sv.distance

    local hit, res = sm.physics.raycast(startPos, endPos)

    local dataTbl = {
        directionWorld = res.directionWorld,
        fraction = res.fraction,
        normalLocal = res.normalLocal,
        normalWorld = res.normalWorld,
        originWorld = res.originWorld,
        pointLocal = res.pointLocal,
        pointWorld = res.pointWorld,
        type = res.type,
        valid = res.valid
    }

    return hit, dataTbl
end

-- Convert the class to a component
sm.scrapcomputers.components.ToComponent(Laser, "Lasers", true)