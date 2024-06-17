dofile("$CONTENT_DATA/Scripts/Config.lua")

---@class Radar : ShapeClass
Radar = class()
Radar.maxParentCount = 1
Radar.maxChildCount = 0
Radar.connectionInput = sm.interactable.connectionType.compositeIO
Radar.connectionOutput = sm.interactable.connectionType.none
Radar.colorNormal = sm.color.new(0xa8604cff)
Radar.colorHighlight = sm.color.new(0xe06d2bff)

-- CLIENT / SERVER --

-- Returns true of a body is in a creation
---@param body Body The body to find
---@param creation Body[] The body's creations
---@return boolean bodyInCreation If true, the body is in the creation. else not!
function isBodyInCreation(body, creation)
    -- Loop through all bodies in creation
    for _, cBody in pairs(creation) do
        -- Check if the body's creation's ID matches with the body's id we are trying to find
        if cBody.id == body.id then
            -- Return true since we found one
            return true
        end
    end

    -- Return false since it didnt find one.
    return false
end

-- SERVER --

function Radar:sv_createData()
    return {
        -- Gets its targets
        getTargets = function()
            -- Return the discovered targets
            return self.sv.targets
        end,

        -- Sets the vertical scan angle
        setVerticalScanAngle = function(angle)
            -- Perform asserts
            assert(type(angle) == "number", "bad argument #1. Expected number, got "..type(angle).." instead.")
            assert(angle > 10 and angle <= 90, "Angle must be within 10 and 90 degrees")

            -- Update the value
            self.sv.vAngle = angle
        end,

        -- Sets the horizontal scan angle
        setHorizontalScanAngle = function(angle)
            -- Perform asserts
            assert(type(angle) == "number", "bad argument #1. Expected number, got "..type(angle).." instead.")
            assert(angle > 10 and angle <= 90, "Angle must be within 10 and 90 degrees")

            -- Update the value
            self.sv.hAngle = angle
        end,
    }
end

function Radar:server_onCreate()
    self.sv = {
        vAngle = 30, -- The max vertical angle
        hAngle = 30, -- The max horizontal angle
        targets = {} -- All targetss it has detected
    }
end

function Radar:server_onFixedUpdate()
    -- Get all bodies
    local bodies = sm.body.getAllBodies()

    -- Contains all bodies in range
    local losCreations = {} ---@type Body[][]
    
    local radarPos = self.shape.worldPosition -- The Radar's world position
    local radarAt = sm.quat.getAt(self.shape.worldRotation) -- The AT's from the radar's world rotation
    local radarUp = sm.quat.getUp(self.shape.worldRotation) -- The UP's from the radar's world rotation

    local vAngleRad = math.rad(self.sv.vAngle / 2) -- The vertical angle divided by 2 in radians
    local hAngleRad = math.rad(self.sv.hAngle / 2) -- The horizontal angle divided by 2 in radians

    -- Loop through all bodies
    for _, body in pairs(bodies) do
        -- Get result if the body is in a creation
        local bool = isBodyInCreation(body, self.shape.body:getCreationBodies())

        -- Check if it isnt in a creation
        if not bool then
            -- Loop through all losCreations
            for _, creation in pairs(losCreations) do
                -- Get result if the body is in a creation
                bool = isBodyInCreation(body, creation)

                -- If it is in a creation. stop the loop
                if bool then break end
            end
        end

        -- Check if it isnt in a creation
        if not bool then
            -- Get it's world position
            local bodyPos = body:getShapes()[1].worldPosition
            local dir = bodyPos - radarPos -- Get it's direction length

            -- Check if the length of the vector is NOT 0
            if dir:length() ~= 0 then
                local distance = dir:length() -- Get the direction's length
                dir = dir:normalize() -- Convert the direction to be normalized

                -- Get the vertical angle by dotting the radar's up direction and asin it.
                local verticalAngle = math.asin(dir:dot(radarUp))

                -- Check if the absolute value of verticalAngle is bigger than the vAngleRad.
                if math.abs(verticalAngle) > vAngleRad then
                    goto continue -- Go to the next iteration of the loop
                end

                -- Get the horizontal directioon
                local horizontalDir = dir - radarUp * dir:dot(radarUp)

                -- Get the horizontal angle by absoluting a value that is a dotted version of a normalized value of horizontalDir
                local horizontalAngle = math.acos(radarAt:dot(horizontalDir:normalize()))

                -- CHeck if horizontalAngle is bigger than hAngleRad
                if horizontalAngle > hAngleRad then
                    goto continue -- Go to the next iteration of the loop
                end

                -- Perform a raycast
                local hit, res = sm.physics.raycast(radarPos, radarPos + dir * distance, self.shape.body)

                -- Check if it has hitted someting
                if hit then
                    -- Check if the result type is a body
                    if res.type == "body" then
                        -- Get the body
                        local resBody = res:getBody()

                        -- Get the rsult if the body is in a creation
                        local bool1 = isBodyInCreation(resBody, body:getCreationBodies())

                        -- Get the creation ID
                        local creationId = resBody:getCreationId()

                        -- Check if it is in a creation and does NOT exist in losCreations
                        if bool1 and not losCreations[creationId] then
                            -- Add it!
                            losCreations[creationId] = resBody:getCreationBodies()
                        end 
                    end
                end
            end
        end

        ::continue::
    end

    -- Contains all valid targets
    local validTargets = {}

    -- Check if losCreations isnt empty
    if losCreations ~= {} then
        -- Loop throough all losCreations
        for _, creation in pairs(losCreations) do
            local minBound ---@type Vec3? The mininum bound
            local maxBound ---@type Vec3? The maximun bound

            -- Loop through all creations
            for _, body in pairs(creation) do
                -- Check if it exists
                if sm.exists(body) then
                    -- Get it's local AABB
                    local min, max = body:getLocalAabb()

                    minBound = minBound or min -- Update minBound if it is nil to min
                    maxBound = maxBound or max -- Update maxBound if it is nil to max

                    minBound = minBound:min(min) -- Set the min value for minBound of them to be min
                    maxBound = maxBound:min(max) -- Set the min value for maxBound of them to be max
                end
            end

            -- Check if minBound and maxBound exists
            if maxBound and minBound then

                -- Get the distance between the creation's position and self.shape.worldPosition
                local distance = (self.shape.worldPosition - creation[1]:getShapes()[1].worldPosition):length() ---@type number
                
                -- Get the BB value by subtracting maxBound from minBound
                local bb = maxBound - minBound

                -- Get it's surface area
                local surfaceArea = ((bb.x * bb.z + bb.x * bb.y + bb.z * bb.y) / 2 ) * 1 / distance * 1000
                
                -- Get its bounding area
                local surfaceAreaBound = self.sv.hAngle * self.sv.vAngle / 40

                -- Check if the surfaceArea is higher than the surfaceArea's bounding or the distance is lower than 200
                if surfaceArea > surfaceAreaBound or distance < 200 then
                    -- Add the creation and surface area to validTargets
                    table.insert(validTargets, {creation, surfaceArea})
                end
            end
        end
    end

    -- Contains the targets to be setted on self.sv.targets
    local finalTargets = {}

    -- Check if there is any targets
    if #validTargets > 0 then
        -- Loop through them all
        for _, data in pairs(validTargets) do
            -- Get the creation and surfaceArea from data
            local creation, surfaceArea = unpack(data) ---@type Body[], number
            
            -- Create a vector3 of (0, 0, 0)
            local averagePos = sm.vec3.zero()

            -- Loop through all creations and get its center of mass and add it to averagePos
            for _, body in pairs(creation) do
                averagePos = averagePos + body:getCenterOfMassPosition()
            end

            -- Set averagePos to itself divided by the total creations
            averagePos = averagePos / #creation

            -- Add to finalTargets its averagePos and surfaceArea
            table.insert(finalTargets, {position = averagePos, surfaceArea = surfaceArea})
        end
    end

    -- Set the targets to the final targets
    self.sv.targets = finalTargets
end

-- Convert the class to a component
dofile("$CONTENT_DATA/Scripts/ComponentManager.lua")
sc.componentManager.ToComponent(Radar, "Radars", true)