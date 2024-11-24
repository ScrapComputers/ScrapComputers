---@class GPSClass : ShapeClass
GPSClass = class()
GPSClass.maxParentCount = 1
GPSClass.maxChildCount = 0
GPSClass.connectionInput = sm.interactable.connectionType.compositeIO
GPSClass.connectionOutput = sm.interactable.connectionType.none
GPSClass.colorNormal = sm.color.new(0x696969ff)
GPSClass.colorHighlight = sm.color.new(0x969696ff)

-- CLIENT / SERVER --

---Get the acceleration between 2 velocities
---@param  velocity     number The current velocity
---@param  lastVelocity number The previous velocity
---@return number acceleration The acceleration
local function getAcceleration(velocity, lastVelocity, dt)
    return (velocity - lastVelocity) / dt
end

--- Gets a bearing of a direction
local function getBearing(direction)
    local angleDeg = math.deg(math.atan2(direction.y, direction.x))

    if angleDeg < 0 then return angleDeg + 360 end

    return angleDeg
end

local function quatToEuler(quat)
    local x, y, z, w = quat.x, quat.y, quat.z, quat.w

    -- Correct Roll (x-axis rotation)
    local sinr_cosp = 2 * (w * x + y * z)
    local cosr_cosp = 1 - 2 * (x * x + y * y)
    local roll = math.atan2(sinr_cosp, cosr_cosp)

    -- Correct Pitch (y-axis rotation)
    local sinp = 2 * (w * y - z * x)
    local pitch
    if math.abs(sinp) >= 1 then
        pitch = math.pi / 2 * (sinp > 0 and 1 or -1)
    else
        pitch = math.asin(sinp)
    end

    -- Correct Yaw (z-axis rotation)
    local siny_cosp = 2 * (w * z + x * y)
    local cosy_cosp = 1 - 2 * (y * y + z * z)
    local yaw = math.atan2(siny_cosp, cosy_cosp)

    -- Adjust roll to account for the offset
    roll = roll - math.rad(90)

    -- Convert radians to degrees and normalize to range -180 to 180
    local function normalizeAngle(angle)
        local degAngle = math.deg(angle)
        if degAngle > 180 then
            degAngle = degAngle - 360
        elseif degAngle <= -180 then
            degAngle = degAngle + 360
        end
        return degAngle
    end

    -- Normalize angles
    roll = normalizeAngle(roll)
    pitch = normalizeAngle(pitch)
    yaw = normalizeAngle(yaw)

    -- Return angles as sm.vec3 (swap roll and pitch for proper mapping)
    return sm.vec3.new(pitch, roll, yaw)
end

-- SERVER --

function GPSClass:sv_createData()
    return {
        --- Gets GPS data and returns it
        ---@return GPSData GPSData The GPS data
        getGPSData = function()
            local angularVelocity = self.shape.body:getAngularVelocity()

            return {
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
}
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

sm.scrapcomputers.componentManager.toComponent(GPSClass, "GPSs", true)