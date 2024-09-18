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
local function getAcceleration(velocity, lastVelocity)
    return (velocity - lastVelocity) * 40
end

--- Gets a bearing of a direction
local function getBearing(direction)
    local angleDeg = math.deg(math.atan2(direction.y, direction.x))

    if angleDeg < 0 then return angleDeg + 360 end

    return angleDeg
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
                worldRotation = self.shape.worldRotation,
                bearing = getBearing(self.shape.worldRotation * sm.vec3.new(1, 0, 0)),

                velocity = self.shape.velocity,
                speed = self.shape.velocity:length(),

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

function GPSClass:server_onFixedUpdate()
    self.sv.forwardVelocity = self.shape.velocity:dot(self.shape.worldRotation * sm.vec3.new(0, 0, -1))
    self.sv.horizontalVelocity = self.shape.velocity:dot(self.shape.worldRotation * sm.vec3.new(1, 0, 0))
    self.sv.verticalVelocity = self.shape.velocity:dot(self.shape.worldRotation * sm.vec3.new(0, 1, 0))

    self.sv.acceleration = getAcceleration(self.shape.velocity:length(), self.sv.lastVelocity)
    self.sv.lastVelocity = self.shape.velocity:length()

    self.sv.forwardAcceleration = getAcceleration(self.sv.forwardVelocity, self.sv.lastForwardVelocity)
    self.sv.horizontalAcceleration = getAcceleration(self.sv.horizontalVelocity, self.sv.lastHorizontalVelocity)
    self.sv.verticalAcceleration = getAcceleration(self.sv.verticalVelocity, self.sv.lastVerticalVelocity)

    self.sv.lastForwardVelocity = self.sv.forwardVelocity
    self.sv.lastHorizontalVelocity = self.sv.horizontalVelocity
    self.sv.lastVerticalVelocity = self.sv.verticalVelocity
end

sm.scrapcomputers.componentManager.toComponent(GPSClass, "GPSs", true)