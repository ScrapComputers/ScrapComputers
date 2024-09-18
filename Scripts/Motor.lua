---@class MotorClass : ShapeClass
MotorClass = class()
MotorClass.maxParentCount = 1
MotorClass.maxChildCount = -1
MotorClass.connectionInput = sm.interactable.connectionType.compositeIO
MotorClass.connectionOutput = sm.interactable.connectionType.bearing + sm.interactable.connectionType.piston
MotorClass.colorNormal = sm.color.new(0xaaaa00ff)
MotorClass.colorHighlight = sm.color.new(0xffff00ff)

-- SERVER --

function MotorClass:sv_createData()
    return {
        ---Sets the bearing(s) speed
        ---@param speed number The speed to set to bearing(s)
        setBearingSpeed = function(speed)
            sm.scrapcomputers.errorHandler.assertArgument(speed, nil, {"number"})

            self.sv.bearingSpeed = speed
            self.sv.updateBearingValues = true
        end,

        ---Sets the bearing(s) angle
        ---@param angle number The angle to set to bearing(s)
        setBearingAngle = function(angle)
            sm.scrapcomputers.errorHandler.assertArgument(angle, nil, {"number", "nil"})

            self.sv.targetAngle = angle
            self.sv.updateBearingValues = true
        end,

        ---Sets the piston(s) speed
        ---@param speed number The speed to set to piston(s)
        setPistonSpeed = function(speed)
            sm.scrapcomputers.errorHandler.assertArgument(speed, nil, {"number"})

            self.sv.pistonSpeed = speed
            self.sv.updateBearingValues = true
        end,

        ---Sets the bearing(s) torque
        ---@param torque number The torque to set to bearing(s)
        setTorque = function(torque)
            sm.scrapcomputers.errorHandler.assertArgument(torque, nil, {"number"})

            self.sv.torque = torque
            self.sv.updateBearingValues = true
        end,

        ---Sets the piston(s) length
        ---@param length number The length to set to piston(s)
        setLength = function(length)
            sm.scrapcomputers.errorHandler.assertArgument(length, nil, {"number"})

            self.sv.length = length
            self.sv.updatePistonValues = true
        end,

        ---Sets the piston(s) force
        ---@param force number The force to set to
        setForce = function(force)
            sm.scrapcomputers.errorHandler.assertArgument(force, nil, {"number"})

            self.sv.force = force
            self.sv.updatePistonValues = true
        end,
    }
end

function MotorClass:server_onFixedUpdate()
    self.sv.bearings = self.interactable:getBearings()
    self.sv.pistons = self.interactable:getPistons()

    local bearingLen = #self.sv.bearings
    local pistonLen = #self.sv.pistons

    if bearingLen ~= self.sv.lastBearingCount then
        self.sv.updateBearingValues = true
        self.sv.lastBearingCount = bearingLen
    end

    if pistonLen ~= self.sv.lastPistonCount then
        self.sv.updatePistonValues = true
        self.sv.lastPistonCount = pistonLen
    end

    if self.sv.updateBearingValues then
        for i, bearing in pairs(self.sv.bearings) do
            if not self.sv.targetAngle then
                bearing:setMotorVelocity(math.rad(self.sv.bearingSpeed), self.sv.torque)
            else
                bearing:setTargetAngle(math.rad(self.sv.targetAngle), math.rad(self.sv.bearingSpeed), self.sv.torque)
            end
        end

        self.sv.updateBearingValues = false
    end

    if self.sv.updatePistonValues then
        for _, piston in pairs(self.sv.pistons) do
            piston:setTargetLength(self.sv.length, self.sv.pistonSpeed, self.sv.force)
        end

        self.sv.updatePistonValues = false
    end
end

function MotorClass:server_onCreate()
    self.sv = {
        bearingSpeed = 0,
        torque = 1000,

        pistonSpeed = 0,
        length = 0,
        force = 1000,

        updateBearingValues = false,
        updatePistonValues = false,

        bearings = {},
        lastBearingCount = 0,
        pistons = {},
        lastPistonCount = 0,
    }
end

sm.scrapcomputers.componentManager.toComponent(MotorClass, "Motors", true)