---@class MotorClass : ShapeClass
MotorClass = class()
MotorClass.maxParentCount = -1
MotorClass.maxChildCount = -1
MotorClass.connectionInput = sm.interactable.connectionType.compositeIO
MotorClass.connectionOutput = sm.interactable.connectionType.bearing + sm.interactable.connectionType.piston
MotorClass.colorNormal = sm.color.new(0xaaaa00ff)
MotorClass.colorHighlight = sm.color.new(0xffff00ff)

local math = math

local DEG_TO_RAD = math.rad(1)
local RAD_TO_RPM = 30 / math.pi
local BEARING_POWER_COEFF = 30000 / math.pi
local PISTON_POWER_COEFF = BEARING_POWER_COEFF * 6
local EFFICIENCY = 1 / 0.85

-- SERVER --

function MotorClass:sv_createData()
    return {
        ---Sets the bearing(s) speed
        ---@param speed number The speed to set to bearing(s)
        setBearingSpeed = function(speed)
            sm.scrapcomputers.errorHandler.assertArgument(speed, nil, {"number"})
            sm.scrapcomputers.errorHandler.assert(math.abs(speed) ~= math.huge, nil, "Cannot set a non-finite bearing speed!")

            self.sv.bearingSpeed = math.rad(speed)
            self.sv.updateBearings = true
        end,

        ---Sets the bearing(s) angle
        ---@param angle number The angle to set to bearing(s)
        setBearingAngle = function(angle)
            sm.scrapcomputers.errorHandler.assertArgument(angle, nil, {"number", "nil"})

            if angle then
                sm.scrapcomputers.errorHandler.assert(math.abs(angle) ~= math.huge, nil, "Cannot set a non-finite bearing angle!")
            end

            self.sv.targetAngle = angle and math.rad(angle) or nil
            self.sv.updateBearings = true
        end,

        ---Sets the bearing(s) torque
        ---@param torque number The torque to set to bearing(s)
        setTorque = function(torque)
            sm.scrapcomputers.errorHandler.assertArgument(torque, nil, {"number"})
            sm.scrapcomputers.errorHandler.assert(math.abs(torque) ~= math.huge, nil, "Cannot set a non-finite bearing torque!")
            sm.scrapcomputers.errorHandler.assert(torque >= 0, nil, "Torque cannot be negative!")

            self.sv.torque = torque
            self.sv.updateBearings = true
        end,

        ---Sets the piston(s) speed
        ---@param speed number The speed to set to piston(s)
        setPistonSpeed = function(speed)
            sm.scrapcomputers.errorHandler.assertArgument(speed, nil, {"number"})
            sm.scrapcomputers.errorHandler.assert(math.abs(speed) ~= math.huge, nil, "Cannot set a non-finite piston speed!")

            self.sv.pistonSpeed = math.abs(speed)
            self.sv.updatePistons = true
        end,

        ---Sets the piston(s) length
        ---@param length number The length to set to piston(s)
        setLength = function(length)
            sm.scrapcomputers.errorHandler.assertArgument(length, nil, {"number"})
            sm.scrapcomputers.errorHandler.assert(math.abs(length) ~= math.huge, nil, "Cannot set a non-finite piston length!")
            sm.scrapcomputers.errorHandler.assert(length >= 0, nil, "Piston length cannot be negative!")

            self.sv.length = length
            self.sv.updatePistons = true
        end,

        ---Sets the piston(s) force
        ---@param force number The force to set to
        setForce = function(force)
            sm.scrapcomputers.errorHandler.assertArgument(force, nil, {"number"})
            sm.scrapcomputers.errorHandler.assert(math.abs(force) ~= math.huge, nil, "Cannot set a non-finite piston force!")

            self.sv.force = math.abs(force)
            self.sv.updatePistons = true
        end,
        
        ---Gets the bearing's current angle. Note that only 1 bearing can be connected!
        ---@return number angle The current angle
        getCurrentAngle = function ()
            local totalBearings = #self.sv.bearings + #self.sv.springs
            sm.scrapcomputers.errorHandler.assert(totalBearings == 1, nil, "Only 1 bearing can be connected!")

            local joint = self.sv.bearings[1] or self.sv.springs[1]
            return math.deg(joint:getAngle())
        end,

        ---Gets the pistons's current length. Note that only 1 piston can be connected!
        ---@return number length The current length
        getCurrentLength = function ()
            sm.scrapcomputers.errorHandler.assert(#self.sv.pistons == 1, nil, "Only 1 piston can be connected!")

            return self.sv.pistons[1]:getLength()
        end
    }
end

function MotorClass:server_onCreate()
    self.sv = {
        bearings = {}, springs = {}, pistons = {}, bearingsReversed = {},
        bearingSpeed = 0, torque = 1000, targetAngle = nil,
        pistonSpeed = 0, force = 1000, length = 0,
        updateBearings = true, updatePistons = true, wasPowered = true,
        jointCount = 0,
    }

    self:sv_cacheJoints()
end

function MotorClass:server_onFixedUpdate()
    local joints = self.interactable:getJoints()

    if #joints ~= self.sv.jointCount then
        self:sv_cacheJoints(joints)
    else
        for _, joint in ipairs(joints) do
            local id = joint.id
            local prevReversed = self.sv.bearingsReversed[id]
        
            if prevReversed ~= nil then
                local isReversed = joint:isReversed()
                if prevReversed ~= isReversed then
                    self.sv.bearingsReversed[id] = isReversed
                    self.sv.updateBearings = true
                end
            end
        end
    end

    local hasPower = false
    for _, parent in ipairs(self.interactable:getParents()) do
        if parent.active then
            hasPower = true
            break
        end
    end

    if not hasPower and self.sv.wasPowered then
        self:sv_onPowerLoss()
    end

    if hasPower and not self.sv.wasPowered then
        self.sv.wasPowered = true
        self.sv.updateBearings = true
        self.sv.updatePistons = true
    end

    if self.sv.updateBearings then
        for _, bearing in ipairs(self.sv.bearings) do
            if not self.sv.targetAngle then
                bearing:setMotorVelocity(self.sv.bearingSpeed, self.sv.torque)
            else
                bearing:setTargetAngle(self.sv.targetAngle, self.sv.bearingSpeed, self.sv.torque)
            end
        end

        self.sv.updateBearings = false
    end

    if self.sv.updatePistons then
        for _, piston in ipairs(self.sv.pistons) do
            piston:setTargetLength(self.sv.length, self.sv.pistonSpeed, self.sv.force)
        end

        self.sv.updatePistons = false
    end

    for _, spring in ipairs(self.sv.springs) do
        if not self.sv.targetAngle then
            spring:setMotorVelocity(self.sv.bearingSpeed, self.sv.torque)
        else
            local currentAngle = spring:getAngle()

            if not spring:isReversed() then
                currentAngle = -currentAngle
            end

            local error = self.sv.targetAngle - currentAngle
            error = (error + math.pi) % (2 * math.pi) - math.pi

            local absSpeed = math.abs(self.sv.bearingSpeed)
            local calculatedSpeed = sm.util.clamp(error * 5.0, -absSpeed, absSpeed)

            spring:setMotorVelocity(calculatedSpeed, self.sv.torque)
        end
    end

    local totalPower = 0

    if self.sv.torque > 0 then
        local absSpeed = math.abs(self.sv.bearingSpeed)
        local powerSpeed = (absSpeed < DEG_TO_RAD) and DEG_TO_RAD or absSpeed
        local bearingRpm = powerSpeed * RAD_TO_RPM
        local bearingPower = (bearingRpm * self.sv.torque / BEARING_POWER_COEFF) * EFFICIENCY

        totalPower = totalPower + (bearingPower * (#self.sv.bearings + #self.sv.springs))
    end

    if self.sv.force > 0 then
        local pistonPowerSpeed = (self.sv.pistonSpeed < 1) and 1 or self.sv.pistonSpeed
        local pistonPower = (pistonPowerSpeed * self.sv.force / PISTON_POWER_COEFF) * EFFICIENCY

        totalPower = totalPower + (pistonPower * #self.sv.pistons)
    end

    sm.scrapcomputers.powerManager.updatePowerInstance(self.shape.id, totalPower)
end

function MotorClass:sv_cacheJoints(joints)
    joints = joints or self.interactable:getJoints()

    self.sv.bearings, self.sv.springs, self.sv.pistons = {}, {}, {}
    self.sv.bearingsReversed = {}

    for _, joint in ipairs(joints) do
        if joint:getBearingEnabled() then
            self.sv.bearingsReversed[joint.id] = joint:isReversed()

            if joint.type == "bearing" then
                table.insert(self.sv.bearings, joint)
            else
                table.insert(self.sv.springs, joint)
            end
        else
            table.insert(self.sv.pistons, joint)
        end
    end

    self.sv.jointCount = #joints
    self.sv.updateBearings = true
    self.sv.updatePistons = true
end

function MotorClass:sv_onPowerLoss()
    self.sv.wasPowered = false

    self.sv.bearingSpeed = 0
    self.sv.torque = 0
    self.sv.pistonSpeed = 0
    self.sv.force = 0

    for _, bearing in ipairs(self.sv.bearings) do bearing:setMotorVelocity(0, 0) end
    for _, spring in ipairs(self.sv.springs) do spring:setMotorVelocity(0, 0) end
    for _, piston in ipairs(self.sv.pistons) do piston:setTargetLength(0, 0, 0) end
end

sm.scrapcomputers.componentManager.toComponent(MotorClass, "Motors", true, nil, true)