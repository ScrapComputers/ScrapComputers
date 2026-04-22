---@class GPSClass : ShapeClass
GPSClass = class()
GPSClass.maxParentCount = -1
GPSClass.maxChildCount = 0
GPSClass.connectionInput = sm.interactable.connectionType.compositeIO
GPSClass.connectionOutput = sm.interactable.connectionType.none
GPSClass.colorNormal = sm.color.new(0x696969ff)
GPSClass.colorHighlight = sm.color.new(0x969696ff)

-- CLIENT / SERVER --

local isSurvival = sm.scrapcomputers.gamemodeManager.isSurvival() or sm.scrapcomputers.config.getConfig("scrapcomputers.global.survivalBehavior").selectedOption == 2

local function getBearing(direction)
    local angleDeg = math.deg(math.atan2(direction.x, direction.y))

    if angleDeg < 0 then return angleDeg + 360 end

    return angleDeg
end

local function quatToEuler(quat)
    local right = quat * sm.vec3.new(1, 0, 0)
    local forward = quat * sm.vec3.new(0, 1, 0)
    local up = quat * sm.vec3.new(0, 0, 1)

    local yaw = math.atan2(forward.x, forward.y)
    local pitch = math.atan2(-forward.z, math.sqrt(forward.x^2 + forward.y^2))
    local roll = math.atan2(right.z, up.z)

    return sm.vec3.new(
        math.deg(pitch),
        math.deg(roll),
        math.deg(yaw)
    )
end

-- SERVER --

function GPSClass:sv_createData()
    return {
        --- Gets GPS data and returns it
        ---@return GPSData GPSData The GPS data
        getGPSData = function()
            local shape = self.shape
            local angularVelocity = shape.body:getAngularVelocity()
            local velocity = shape.velocity

            local worldPosition = shape.worldPosition

            local worldRotation = shape.worldRotation
            local right = worldRotation * sm.vec3.new(1, 0, 0)
            local at = worldRotation * sm.vec3.new(0, 1, 0)
            local up = worldRotation * sm.vec3.new(0, 0, 1)

            local acceleration = self.sv.acceleration
            local data = {
                worldPosition = worldPosition,
                localPosition = shape.localPosition,
                worldRotation = worldRotation,
                localRotation = shape.localRotation,

                bearing = getBearing(at),
                    -- What the fuck are bearings? -VeraDev

                velocity = velocity,
                speed = velocity:length(),
                degreeRotation = quatToEuler(worldRotation),

                horizontalVelocity = velocity:dot(right),
                forwardVelocity = velocity:dot(at),
                verticalVelocity = velocity:dot(up),
                angularVelocity = angularVelocity,
                rpm = up:dot(angularVelocity) * 9.549296585513721,

                acceleration = acceleration,
                horizontalAcceleration = acceleration:dot(right),
                forwardAcceleration = acceleration:dot(at),
                verticalAcceleration = acceleration:dot(up),
            }
            
            if isSurvival then
                self.sv.positionDrift = self.sv.positionDrift + sm.vec3.new(
                    (math.random() * 2 - 1) * 0.05,
                    (math.random() * 2 - 1) * 0.05,
                    (math.random() * 2 - 1) * 0.05
                )

                local maxDrift = 5
                self.sv.positionDrift.x = sm.util.clamp(self.sv.positionDrift.x, -maxDrift, maxDrift)
                self.sv.positionDrift.y = sm.util.clamp(self.sv.positionDrift.y, -maxDrift, maxDrift)
                self.sv.positionDrift.z = sm.util.clamp(self.sv.positionDrift.z, -maxDrift, maxDrift)

                data.worldPosition = worldPosition + self.sv.positionDrift
            end

            return data
        end
    }
end

function GPSClass:server_onCreate()
    self.sv = {
        lastVelocity = sm.vec3.zero(),
        acceleration = sm.vec3.zero(),
        positionDrift = sm.vec3.zero()
    }

    sm.scrapcomputers.powerManager.updatePowerInstance(self.shape.id, 1)
end

function GPSClass:server_onFixedUpdate(dt)
    local velocity = self.shape.velocity

    self.sv.acceleration = (velocity - self.sv.lastVelocity) / dt
    self.sv.lastVelocity = velocity
end

sm.scrapcomputers.componentManager.toComponent(GPSClass, "GPSs", true, nil, true)