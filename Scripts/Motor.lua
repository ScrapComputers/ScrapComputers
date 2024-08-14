dofile("$CONTENT_DATA/Scripts/Config.lua")

---@class Motor : ShapeClass
Motor = class()
Motor.maxParentCount = 1
Motor.maxChildCount = -1
Motor.connectionInput = sm.interactable.connectionType.compositeIO
Motor.connectionOutput = sm.interactable.connectionType.bearing + sm.interactable.connectionType.piston
Motor.colorNormal = sm.color.new(0xaaaa00ff)
Motor.colorHighlight = sm.color.new(0xffff00ff)

-- SERVER --

function Motor:sv_createData()
    return {
        ---Sets the bearing(s) speed
        ---@param speed number The speed to set to bearing(s)
        setBearingSpeed = function(speed)
            assert(type(speed) == "number",  "bad argument #1. Expected number, got "..type(speed).." instead!") -- Assert my ass!

            -- Update the value and tell that bearings need updating.
            self.sv.bearingSpeed = speed
            self.sv.updateBearingValues = true
        end,

        ---Sets the bearing(s) angle
        ---@param angle number The angle to set to bearing(s)
        setBearingAngle = function(angle)
            assert(type(angle) == "number" or type(angle) == "nil",  "bad argument #1. Expected number or nil, got "..type(angle).." instead!") -- Assert my ass!

            -- Update the value and tell that bearings need updating.
            if not angle then
                self.sv.targetAngle = nil
            else
                self.sv.targetAngle = angle
            end

            self.sv.updateBearingValues = true
        end,

        ---Sets the piston(s) speed
        ---@param speed number The speed to set to piston(s)
        setPistonSpeed = function(speed)
            assert(type(speed) == "number",  "bad argument #1. Expected number, got "..type(speed).." instead!") -- Assert my ass!

            -- Update the value and tell that pistions need updating.
            self.sv.pistonSpeed = speed
            self.sv.updateBearingValues = true
        end,

        ---Sets the bearing(s) torque
        ---@param torque number The torque to set to bearing(s)
        setTorque = function(torque)
            assert(type(torque) == "number",  "bad argument #1. Expected number, got "..type(torque).." instead!") -- Assert my ass!

            -- Update the value and tell that bearings need updating.
            self.sv.torque = torque
            self.sv.updateBearingValues = true
        end,

        ---Sets the pistin(s) length
        ---@param length number The length to set to piston(s)
        setLength = function(length)
            assert(type(length) == "number",  "bad argument #1. Expected number, got "..type(length).." instead!") -- Assert my ass!

            -- Update the value and tell that pistions need updating.
            self.sv.length = length
            self.sv.updatePistonValues = true
        end,

        ---Sets the piston(s) force
        ---@param force any
        setForce = function(force)
            assert(type(force) == "number",  "bad argument #1. Expected number, got "..type(force).." instead!") -- Assert my ass!

            -- Update the value and tell that pistions need updating.
            self.sv.force = force
            self.sv.updatePistonValues = true
        end,
    }
end

function Motor:server_onFixedUpdate()
    self.sv.bearings = self.interactable:getBearings() -- Gets all connected bearings
    self.sv.pistons = self.interactable:getPistons() -- Gets all connected pistins
    
    local bearingLen = #self.sv.bearings -- Get the total amount of connected bearings
    local pistonLen = #self.sv.pistons -- Get the total amount of connected pistons

    if bearingLen ~= self.sv.lastBearingCount then -- Check if there was a diffirence
        -- It needs updating! Tell it to update and update the last total bearings count!
        self.sv.updateBearingValues = true
        self.sv.lastBearingCount = bearingLen
    end

    if pistonLen ~= self.sv.lastPistonCount then -- Check if there was a diffirence
        -- It needs updating! Tell it to update and update the last total pistions count!
        self.sv.updatePistonValues = true
        self.sv.lastPistonCount = pistonLen
    end

    -- Check if it needs bearing updating.
    if self.sv.updateBearingValues then
        -- Loop through all bearings
        for i, bearing in pairs(self.sv.bearings) do
            -- Check if the targetAngle is 0 (Which means if true, We need to change it via velocity)
            if not self.sv.targetAngle then
                -- Since we are changing by velocitry, Convert the bearing speed to radians (Scrap Mechanic loves Radians, Such a stupid bitch) and update the velocity with the amount of torque to use. 
                bearing:setMotorVelocity(math.rad(self.sv.bearingSpeed), self.sv.torque)
            else
                -- Since we are changing it by angle, Update the angle by speed and torque
                bearing:setTargetAngle(math.rad(self.sv.targetAngle), math.rad(self.sv.bearingSpeed), self.sv.torque)
            end
        end

        -- Change it to false
        self.sv.updateBearingValues = false
    end

    if self.sv.updatePistonValues then
        -- Loop through all pistions and update it's length. The speed is determined by self.sv.pistonSpeed and the force to use is by self.sv.force
        for i, piston in pairs(self.sv.pistons) do
            piston:setTargetLength(self.sv.length, self.sv.pistonSpeed, self.sv.force)
        end

        -- Change it to false
        self.sv.updatePistonValues = false
    end
end

function Motor:server_onCreate()
    -- Server-side variables
    self.sv = {
        bearingSpeed = 0, -- (BEARING) The bearing speed
        torque = 1000,      -- (BEARING) The torque to use

        pistonSpeed = 0, -- (PISTON) The piston speed
        length = 0,      -- (PISTON) The length to set
        force = 1000,    -- (PISTON) The force to use

        updateBearingValues = false, -- If true, it will update the bearing's values
        updatePistonValues = false,  -- If true, it will update the piston's values

        bearings = {},        -- (BEARING) All connected bearings are stored here
        lastBearingCount = 0, -- (BEARING) The previous total bearings used
        pistons = {},         -- (PISTON) All connected pistons are stored here
        lastPistonCount = 0   -- (PISTON) The previous total pistons used
    }
end

-- Convert the class to a component
sm.scrapcomputers.components.ToComponent(Motor, "Motors", true)