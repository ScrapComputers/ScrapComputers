dofile("$CONTENT_DATA/Scripts/Config.lua")

---@class GPS : ShapeClass
GPS = class()
GPS.maxParentCount = 1
GPS.maxChildCount = 0
GPS.connectionInput = sm.interactable.connectionType.compositeIO
GPS.connectionOutput = sm.interactable.connectionType.none
GPS.colorNormal = sm.color.new(0x696969ff)
GPS.colorHighlight = sm.color.new(0x969696ff)

-- CLIENT / SERVER --

function getAcceleration(velocity, lastVelocity)
    return (velocity - lastVelocity) * 40
end

function getBearing(direction)
    local angleDeg = math.deg(math.atan2(direction.y, direction.x))
    
    if angleDeg < 0 then
        angleDeg = angleDeg + 360
    end
    
    return angleDeg
end

-- SERVER --

function GPS:sv_createData()
    return {
        getGPSData = function()
            return self:sv_getGPSData()
        end 
    }
end

function GPS:server_onCreate()
    self.sv = {
        lastVelocity = 0,
        lastForwardVelocity = 0,
        lasthorizontalVelocity = 0,
        lastVerticalVelocity = 0,

        acceleration = 0,
        forwardAcceleration = 0,
        horizontalAcceleration = 0,
        verticalAcceleration = 0
    }
end

function GPS:server_onFixedUpdate()
    local shape = self.shape

    local worldRotation = shape.worldRotation
    local velocity = shape.velocity

    self.sv.forwardVelocity = velocity:dot(worldRotation * sm.vec3.new(0, 0, -1))
    self.sv.horizontalVelocity = velocity:dot(worldRotation * sm.vec3.new(1, 0, 0))
    self.sv.verticalVelocity = velocity:dot(worldRotation * sm.vec3.new(0, 1, 0))

    self.sv.acceleration = getAcceleration(velocity:length(), self.sv.lastVelocity)
    self.sv.lastVelocity = velocity:length()

    self.sv.forwardAcceleration = getAcceleration(self.sv.forwardVelocity, self.sv.lastForwardVelocity)
    self.sv.lastForwardVelocity = self.sv.forwardVelocity

    self.sv.horizontalAcceleration = getAcceleration(self.sv.horizontalVelocity, self.sv.lasthorizontalVelocity)
    self.sv.lasthorizontalVelocity = self.sv.horizontalVelocity

    self.sv.verticalAcceleration = getAcceleration(self.sv.verticalVelocity, self.sv.lastVerticalVelocity)
    self.sv.lastVerticalVelocity = self.sv.verticalVelocity
end

function GPS:sv_getGPSData()
    local shape = self.shape
    local velocity = shape.velocity
    local angularVelocity = shape.body:getAngularVelocity()

    local worldRotation = shape.worldRotation

    local GPSdata = {
        worldPosition = shape.worldPosition,
        worldRotation = worldRotation,
        bearing = getBearing(worldRotation * sm.vec3.new(1, 0, 0)),

        velocity = velocity,
        speed = velocity:length(),

        forwardVelocity = self.sv.forwardVelocity,
        horizontalVelocity = self.sv.horizontalVelocity,
        verticalVelocity = self.sv.verticalVelocity,
        angularVelocity = angularVelocity,
        rpm = self.shape.at:dot(angularVelocity) * 9.549296585513721,

        acceleration = self.sv.acceleration,
        forwardAcceleration = self.sv.forwardAcceleration,
        horizontalAcceleration = self.sv.horizontalVelocity,
        verticalAcceleration = self.sv.verticalAcceleration
    }

    return GPSdata
end

-- Convert the class to a component
dofile("$CONTENT_DATA/Scripts/ComponentManager.lua")
sc.componentManager.ToComponent(GPS, "GPSs", true)