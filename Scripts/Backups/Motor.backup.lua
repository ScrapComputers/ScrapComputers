dofile("$CONTENT_DATA/Scripts/Config.lua")

---@class Motor : ShapeClass
Motor = class()
Motor.maxParentCount = 1
Motor.maxChildCount = 1
Motor.connectionInput = sm.interactable.connectionType.compositeIO
Motor.connectionOutput = sm.interactable.connectionType.bearing
Motor.colorNormal = sm.color.new(0xaaaa00ff)
Motor.colorHighlight = sm.color.new(0xffff00ff)

-- SERVER --

function Motor:sv_createData()
    return {
        -- Returns true if it has a connection.
        hasConnection = function () return self:svcl_hasConnection() end,

        -- Returns true if the block placement is correct.
        isValid = function ()
            -- Check if it has a connection.
            assert(self:svcl_hasConnection(), "No connection with a bearing or piston!")

            -- Return the check if its valid.
            return self.sv.valid
        end,

        -- Gets the angle of the bearing (in radians)
        getAngleRad = function ()
            -- Check if it has a connection and if its a valid placement
            assert(self:svcl_hasConnection(), "No connection with a bearing!")
            assert(self.sv.valid, "Invalid bearing placement!")

            -- Return the angle (in degrees)
            return self:svcl_getJoint():getAngle()
        end,

        -- Gets the angle of the bearing (in degrees)
        getAngle = function ()
            -- Check if it has a connection and if its a valid placement
            assert(self:svcl_hasConnection(), "No connection with a bearing!")
            assert(self.sv.valid, "Invalid bearing placement!")

            -- Return the angle (in degrees)
            local angle = math.deg(self:svcl_getJoint():getAngle()) -- This range is -180 to 180

            -- Since the range is -180 to 180. If its below 0. we add 360, eg: -168 becomes 192
            return (angle > 0 and angle + 360 or angle)
        end,

        -- Gets the angle of the bearing (in degrees and in range of -180 to 180)
        getAngle180 = function ()
            -- Check if it has a connection and if its a valid placement
            assert(self:svcl_hasConnection(), "No connection with a bearing!")
            assert(self.sv.valid, "Invalid bearing placement!")

            -- Return the angle (in degrees)
            return self:svcl_getJoint():getAngle()
        end,

        -- Gets the angluar velocity of the bearing or piston
        getVelocity = function ()
            -- Check if it has a connection and if its a valid placement
            assert(self:svcl_hasConnection(), "No connection with a bearing!")
            assert(self.sv.valid, "Invalid bearing placement!")
            
            -- Return the angle
            return self:svcl_getJoint():getAngularVelocity()
        end,

        -- Sets the angle's bearing.
        setAngle = function (angle, velocity, maxImpulse)
            -- Argument Validation
            assert(type(angle)       == "number", "bad argument #1, Expected number, got "..type(angle     ).." instead!")
            assert(type(velocity)    == "number", "bad argument #2, Expected number, got "..type(velocity  ).." instead!")
            assert(type(maxImpulse)  == "number", "bad argument #3, Expected number, got "..type(maxImpulse).." instead!")

            -- Check if it has a connection and if its a valid placement
            assert(self:svcl_hasConnection(), "No connection with a bearing!")
            assert(self.sv.valid, "Invalid bearing placement!")
            
            -- Set the angle
            self:svcl_getJoint():setTargetAngle(math.rad(angle), velocity, maxImpulse)
        end,

        -- Sets the angle's bearing.
        setVelocity = function (velocity, maxImpulse)
            -- Argument Validation
            assert(type(velocity)   == "number", "bad argument #1, Expected number, got "..type(velocity  ).." instead!")
            assert(type(maxImpulse) == "number", "bad argument #2, Expected number, got "..type(maxImpulse).." instead!")

            -- Check if it has a connection and if its a valid placement
            assert(self:svcl_hasConnection(), "No connection with a bearing!")
            assert(self.sv.valid, "Invalid bearing placement!")
            
            -- Set the velocity
            self:svcl_getJoint():setMotorVelocity(velocity, maxImpulse)
        end,

        -- locks the current angle
        lockAngle = function (toggle)
            -- Optional argument, If its nil then set it to be true
            local isEnabled = true
            if type(toggle) ~= "nil" then
                isEnabled = toggle
            end

            -- Argument Validation
            assert(type(isEnabled) == "boolean", "Expected boolean or nil, got "..type(isEnabled).." instead!")

            -- Check if it has a connection and if its a valid placement
            assert(self:svcl_hasConnection(), "No connection with a bearing!")
            assert(self.sv.valid, "Invalid bearing placement!")

            -- Get the joint
            local joint = self:svcl_getJoint()

            -- If its enabled. get its current angle and lock it's ass!
            -- Else set the velocity as velocity of 0 and impulse of 0, Why? Because theres
            -- NO function to unlock it so this is the solution.
            if isEnabled then
                joint:setTargetAngle(joint:getAngle(), 8 ^ 8, 8 ^ 8)
            else
                joint:setMotorVelocity(0, 0)
            end
        end,

        -- Makes it so that the motor will be unsticked allowing other bearing's to rotate.
        cancelOverwrites = function ()
            -- Check if it has a connection and if its a valid placement
            assert(self:svcl_hasConnection(), "No connection with a bearing!")
            assert(self.sv.valid, "Invalid bearing placement!")

            -- Get the joint
            local joint = self:svcl_getJoint()

            -- Cancel all overwrites by doping the trick that lockAngle(false) does!
            joint:setMotorVelocity(0, 0)
        end
    }
end

function Motor:server_onFixedUpdate()
    -- Check if it has a connection
    if self:svcl_hasConnection() then
        -- Check if its the first tick since it has been connected.
        if not self.sv.firstTickSinceConnection then
            local joint = self:svcl_getJoint() -- Get the joint

            local shapeLookingDirection = self.shape:getAt() -- Get the shape's looking direction
            local jointLookingDirection = sm.quat.getAt(joint:getWorldRotation()) -- Get the joint's direction

            -- This is such a bad method but it works.
            -- Checks if the shape's looking direction is the same as the joint.
            self.sv.valid = sc.toString(shapeLookingDirection) == sc.toString(jointLookingDirection)
            self.sv.firstTickSinceConnection = true -- Toggle this
        end
    else
        -- Reset it
        self.sv.firstTickSinceConnection = false
    end

    -- Get the parent
    local parent = self.interactable:getSingleParent()

    -- Check if it exists
    if parent then
        -- Check if it is NOT active, has a connection and is valid
        if not parent:isActive() and self:svcl_hasConnection() and self.sv.valid then
            -- Check if it is active. and if so, Stop the motor from doing anything
            if not isInactive then
                self:svcl_getJoint():setMotorVelocity(0, 0)
                isInactive = true -- Update the inactivity
            end
        else
            isInactive = false -- Update the inactivity
        end
    end

    -- Check if it's invalid, has a connection and the configuration allows it. If so then send a iliegal joint message to all players.
    if not self.sv.valid and sc.config.configurations[4].selectedOption == 1 and self:svcl_hasConnection() then
        self.network:sendToClients("client_sendIliegalJointMsg")
    end
end

function Motor:server_onCreate()
    -- Server-side variables
    self.sv = {
        -- If this is true. Then the joint is placed correctly. else its false and isn't placed correctly.
        valid = false,
        -- This is used so the validation check get's only executed once!
        firstTickSinceConnection = false,
        -- This is to make it so it only stops the motor ONCE when in-active. Removing this would cause issues!
        isInactive = false
    }
end

-- CLIENT --

-- Sends a alert message saying that the bearing/piston sould be on the front-side of the interactable for 1 seccond.
function Motor:client_sendIliegalJointMsg()
    sm.gui.displayAlertText("[#3A96DDScrap#3b78ffComputers#eeeeee]: Please connect the bearing/piston on the front-side of the Motor!", 1)
end

-- CLIENT/SERVER --

function Motor:svcl_isDegrees(value)
    return not ((value >= 0) and (value <= 2 * math.pi))
end

function Motor:svcl_getJoint()            return self:svcl_getSingleChild     (sm.interactable.connectionType.bearing)        end -- Gets the connected joint child.
function Motor:svcl_hasConnection()       return self:svcl_getSingleChild     (sm.interactable.connectionType.bearing) ~= nil end -- Returns true if it has a connection.
function Motor:svcl_getSingleChild(flags) return self.interactable:getChildren(flags                                 )[1]     end -- Get the first child thats connected.

-- Convert the class to a component
dofile("$CONTENT_DATA/Scripts/ComponentManager.lua")
sc.componentManager.ToComponent(Motor, "Motors", true)