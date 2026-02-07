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

local function getAcceleration(velocity, lastVelocity, dt)
    return (velocity - lastVelocity) / dt
end

local function getBearing(direction)
    local angleDeg = math.deg(math.atan2(direction.y, direction.x))

    if angleDeg < 0 then return angleDeg + 360 end

    return angleDeg
end

local function quatToEuler(quat)
    local at = sm.quat.getAt(quat)
    local right = sm.quat.getRight(quat)
    local up = sm.quat.getUp(quat)

    local pitch = math.deg(math.atan2(at.z, math.sqrt(at.x * at.x + at.y * at.y)))
    local yaw = math.deg(math.atan2(at.y, at.x))
    local roll = math.deg(math.atan2(right.z, up.z))

    return sm.vec3.new(pitch, roll, yaw)
end

-- SERVER --

function GPSClass:sv_createData()
    return {
        --- Gets GPS data and returns it
        ---@return GPSData GPSData The GPS data
        getGPSData = function()
            local angularVelocity = self.shape.body:getAngularVelocity()
            local data = {
                worldPosition = self.shape.worldPosition,
                localPosition = self.shape.localPosition,
                worldRotation = self.shape.worldRotation,
                localRotation = self.shape.localRotation,

                bearing = getBearing(self.shape.worldRotation * sm.vec3.new(1, 0, 0)),
                    -- What the fuck are bearings? -VeraDev

                velocity = self.shape.velocity,
                speed = self.shape.velocity:length(),
                degreeRotation = quatToEuler(self.shape.worldRotation),

                forwardVelocity = self.sv.forwardVelocity,
                horizontalVelocity = self.sv.horizontalVelocity,
                verticalVelocity = self.sv.verticalVelocity,
                angularVelocity = angularVelocity,
                rpm = self.shape.at:dot(angularVelocity) * 9.549296585513721,

                acceleration = self.sv.acceleration,
                forwardAcceleration = self.sv.forwardAcceleration,
                horizontalAcceleration = self.sv.horizontalVelocity,
                verticalAcceleration = self.sv.verticalAcceleration,
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

                data.worldPosition = data.worldPosition + self.sv.positionDrift
            end

            return data
        end
    }
end

function GPSClass:server_onCreate()
    self.sv = {
        lastVelocity = 0,
        lastForwardVelocity = 0,
        lastHorizontalVelocity = 0,
        lastVerticalVelocity = 0,

        acceleration = 0,
        forwardAcceleration = 0,
        horizontalAcceleration = 0,
        verticalAcceleration = 0,

        forwardVelocity = 0,
        horizontalVelocity = 0,
        verticalVelocity = 0,

        positionDrift = sm.vec3.zero()
    }

    sm.scrapcomputers.powerManager.updatePowerInstance(self.shape.id, 1)
end

function GPSClass:server_onFixedUpdate(dt)
    self.sv.forwardVelocity = self.shape.velocity:dot(self.shape.worldRotation * sm.vec3.new(0, 0, -1))
    self.sv.horizontalVelocity = self.shape.velocity:dot(self.shape.worldRotation * sm.vec3.new(1, 0, 0))
    self.sv.verticalVelocity = self.shape.velocity:dot(self.shape.worldRotation * sm.vec3.new(0, 1, 0))

    self.sv.acceleration = getAcceleration(self.shape.velocity:length(), self.sv.lastVelocity, dt)
    self.sv.lastVelocity = self.shape.velocity:length()

    self.sv.forwardAcceleration = getAcceleration(self.sv.forwardVelocity, self.sv.lastForwardVelocity, dt)
    self.sv.horizontalAcceleration = getAcceleration(self.sv.horizontalVelocity, self.sv.lastHorizontalVelocity, dt)
    self.sv.verticalAcceleration = getAcceleration(self.sv.verticalVelocity, self.sv.lastVerticalVelocity, dt)

    self.sv.lastForwardVelocity = self.sv.forwardVelocity
    self.sv.lastHorizontalVelocity = self.sv.horizontalVelocity
    self.sv.lastVerticalVelocity = self.sv.verticalVelocity
end

sm.scrapcomputers.componentManager.toComponent(GPSClass, "GPSs", true, nil, true)