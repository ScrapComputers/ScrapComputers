dofile("$CONTENT_DATA/Scripts/Config.lua")

---@class Radar : ShapeClass
Radar = class()
Radar.maxParentCount = 1
Radar.maxChildCount = 0
Radar.connectionInput = sm.interactable.connectionType.compositeIO
Radar.connectionOutput = sm.interactable.connectionType.none
Radar.colorNormal = sm.color.new(0xa8604cff)
Radar.colorHighlight = sm.color.new(0xe06d2bff)

-- SERVER --

---@param shape Shape
---@return table
function Radar:server_generateLimitedShape(shape)
    return {
        id = shape:getId(), -- ID of the Shape
        uuid = shape:getShapeUuid(), -- UUID of the Shape
        
        getMaterial = function () return shape:getMaterial() end, -- Gets the Shape's Material
        getMaterialId = function () return shape:getMaterialId() end, -- Gets the material id of the Shape
        getBounds = function () return shape:getBoundingBox() end, -- Gets the bounding box of that shape
        getColor = function () return shape:getColor() end, -- Gets the color of the shape
        getMass = function () return shape:getMass() end, -- Gets the mass of the shape

        getLocalPosition = function () return shape:getLocalPosition() end, -- Gets the local position of the shape
        getLocalRotation = function () return shape:getLocalRotation() end, -- Gets the local rotation of the shape

        getWorldPosition = function () return shape:getWorldPosition() end, -- Gets the world position of the shape
        getWorldRotation = function () return shape:getWorldRotation() end ,-- Gets the world rotation of the shape

        getUvFrameIndex = function () return shape:getUvFrameIndex() end, -- Gets the current UV index of the shape

        getState = function () -- Gets the states of the shape
            return {
                Buildable = shape.buildable, -- True if buildable
                Connectable = shape.connectable, -- True if connectable
                ConvertibleToDynamic = shape.convertableToDynamic, -- True if convertable to Dyamic
                Destructable = shape.destructable, -- True if destructable
                Erasable = shape.erasable, -- True if Erasable
                Liftable = shape.liftable, -- True if Liftable
                Paintable = shape.paintable, -- True if Paintable
                Usable = shape.usable -- True if Usable
            }
        end,
    }
end

---@param harvestable Harvestable
---@return table
function Radar:server_generateLimitedHarvestable(harvestable)
    return {
        id = harvestable:getId(), -- ID of the Harvestable
        type = harvestable:getType(), -- Type of Harvestable
        uuid = harvestable:getUuid(), -- UUID of Harvestable

        isKinematic = function () return harvestable:isKinematic() end, -- Returns true if its Kinematic

        getMaterial = function () return harvestable:getMaterial() end, -- Get the material of the Harvestable
        getMaterialId = function () return harvestable:getMaterialId() end, -- Get the material ID of the Harvestable
        getAabb = function () return harvestable:getAabb() end, -- Get the Aabb of the Harvestable
        getColor = function () return harvestable:getColor() end, -- Gets the color of the Harvestable
        getMass = function () return harvestable:getMass() end, -- Gets the mass of the Harvestable
        getName = function () return harvestable:getName() end, -- Gets the name of the Harvestable

        getPosition = function () return harvestable:getPosition() end, -- Gets the position of the harvestable
        getRotation = function () return harvestable:getRotation() end, -- Gets the rotation of the harvestable
        getScale = function () return harvestable:getScale() end, -- Gets the scale of the harvestable
        getType = function () return harvestable:getType() end, -- Gets the type of the harvestable
        getUvFrameIndex = function () return harvestable:getUvFrameIndex() end, -- Gets the UV index of the harvestable
    }
end

---@param lift Lift
---@return table
function Radar:server_generateLimitedLift(lift)
    return {
        id = lift:getId(), -- ID of the lift
        
        getLevel = function () return lift:getLevel() end, -- Gets the level of the lift
        getPosition = function () return lift:getWorldPosition() end, -- Gets the position of the lift
        hasBodies = function () return lift:hasBodies() end -- Returns true if it has any bodies.
    }
end

---@param character Character
---@return table
function Radar:server_generateLimitedCharacter(character)
    return {
        id = character:getId(), -- ID of the character
        nickname = character:getPlayer():getName(), -- ID of the player's name

        getGender = function () return character:getPlayer():isMale() and "Male" or "Female" end, -- Returns Male if its a male, else Female

        getPosition = function () return character:getWorldPosition() end, -- Gets the position of the character
        getLookingDirection = function () return character:getDirection() end, -- Gets the looking direction of the character

        getMovementSpeed = function () return character:getCurrentMovementSpeed() end, -- Gets the current movement speed of the character.
        getMovementNoiseRadius = function () return character:getCurrentMovementNoiseRadius() end, -- Gets the noise radius of the movement of the character/
        
        getColor = function () return character:getColor() end, -- Gets the color of the character
        
        getState = function () -- Gets the states of the character
            return {
                Aiming = character:isAiming(), -- Returns true if aiming
                Climbing = character:isClimbing(), -- Returns true if Climbing
                Crouching = character:isCrouching(), -- Returns true if Crouching
                DefaultColor = character:isDefaultColor(), -- Returns true if its a default color.
                Diving = character:isDiving(), -- Returns true if its Diving
                Downed = character:isDowned(), -- Returns true if Downed
                OnGround = character:isOnGround(), -- Returns true if its on the ground
                Player = character:isPlayer(), -- Returns true if its a player
                Sprinting = character:isSprinting(), -- Returns true if its sprinting
                Swimming = character:isSwimming(), -- Returns true if its swimming
                Tumbling = character:isTumbling() -- Returns true if its nocked out or Tumbling.
            }
        end
    }
end

---@param body Body
---@return table
function Radar:server_generateLimitedBody(body)
    return {
        id = body:getId(), -- ID of the Body
        creationId = body:getCreationId(), -- Creation ID of the Body
        mass = body:getMass(), -- Mass of the Body

        getPosition = function() return body:getWorldPosition() end, -- Gets the position of the body
        getRotation = function() return body.worldRotation end, -- Gets the rotation of the body
        
        getCOMPosition = function() return body:getCenterOfMassPosition() end, -- Gets the Center of mass position of the body

        getLinearVelocity = function () return body:getVelocity() end, -- Get's its velocity
        getAngularVelocity = function () return body:getAngularVelocity() end, -- Gets its angluar velocity
        
        getAABB = function () return body:getLocalAabb() end, -- Gets the AABB of the body.

        getShapes = function () -- Gets all shapes of the body
            local output = {}

            -- Loop through all shapes and limit it and add it to output.
            for index, v in pairs(body:getShapes()) do
                output[index] = self:server_generateLimitedShape(v)
            end

            -- Return it
            return output
        end,

        getCreationShapes = function () -- Gets all creation shapes of the body
            local output = {}

            -- Loop through all creation shapes and limit it and add it to output.
            for index, v in pairs(body:getCreationShapes()) do
                output[index] = self:server_generateLimitedShape(v)
            end

            -- Return it
            return output
        end,

        getCreationBodies = function () -- Gets all creation bodies of the body
            local output = {}

            -- Loop through all creation bodies and limit it and add it to output.
            for index, v in pairs(body:getCreationBodies()) do
                output[index] = self:server_generateLimitedBody(v)
            end

            -- Return it
            return output
        end,
        
        getState = function () -- Get the state of the body.
            return {
                Buildable = body:isBuildable(), -- True if its buildable
                Connectable = body:isConnectable(), -- True if its Connectable
                ConvertibleToDynamic = body:isConvertibleToDynamic(), -- True if its Convertible To Dynamic
                Destructable = body:isDestructable(), -- True if its Destructable
                Dynamic = body:isDynamic(), -- True if its Dyamic
                Erasable = body:isErasable(), -- True if its Erasable
                Liftable = body:isLiftable(), -- True if its Liftable
                OnLift = body:isOnLift(), -- True if its on a lift
                Paintable = body:isPaintable(), -- True if its Paintable
                Static = body:isStatic(), -- True if its Static
                Usable = body:isUsable() -- True if its Usable
            }
        end
    }
end

function Radar:sv_createData()
    return {
        -- Returns the range of the areaTrigger
        getRange = function () return self.sv.radius end,

        -- Sets the range of the areaTrigger
        setRange = function (radius)
            -- Errors it out if the radius argument isn't a number
            assert(type(radius) == "number", "Expected number, got "..type(radius).." instead.")

            -- Update it.
            self.sv.radius = radius
            self.sv.areaTrigger:setSize(sc.vec3.newSingluar(radius))
        end,

        -- Get the objects inside the areaTrigger
        getObjects = function ()
            local output = {}

            -- Loop through all of them
            for _, item in pairs(self.sv.areaTriggerObjects) do
                -- Check if it exists
                if sm.exists(item) then
                    -- Check if its a character, if so then generate a limited version of that and add it to output
                    if type(item) == "Character" then table.insert(output, {"Character", self:server_generateLimitedCharacter(item)})
                    -- Check if its a Body, if so then generate a limited version of that and add it to output
                    elseif type(item) == "Body" then table.insert(output, {"Body", self:server_generateLimitedBody(item)})
                    -- Check if its a Lift, if so then generate a limited version of that and add it to output
                    elseif type(item) == "Lift" then table.insert(output, {"Lift", self:server_generateLimitedLift(item)})
                     -- Check if its a Haverstable, if so then generate a limited version of that and add it to output
                    elseif type(item) == "Harvestable" then table.insert(output, {"Harvestable", self:server_generateLimitedHarvestable(item)}) end
                end
            end

            -- Return the output
            return output
        end
    }
end

function Radar:server_onCreate()
    -- Craete server-side variables
    self.sv = {
        -- The radius of the areaTrigger
        ---@type number
        radius = 100,

        -- The filters applied to the areaTrigger (only here so when the areaTrigger gets created, it won't be a long line)
        ---@type number
        filters = sm.areaTrigger.filter.character + sm.areaTrigger.filter.dynamicBody + sm.areaTrigger.filter.harvestable + sm.areaTrigger.filter.lift + sm.areaTrigger.filter.staticBody + sm.areaTrigger.filter.voxelTerrain,
        
        -- The areatrigger itself
        ---@type AreaTrigger?
        areaTrigger = nil,

        -- Where all stored objects are.
        ---@type table
        areaTriggerObjects = {}
    }
    
    -- Create the areaTrigger
    self.sv.areaTrigger = sm.areaTrigger.createAttachedSphere(self.interactable, self.sv.radius / 100, sm.vec3.zero(), sm.quat.identity(), self.sv.filters)
    self.sv.areaTrigger:bindOnStay("server_onAreaTriggerStay") -- Add a bind
end

function Radar:server_onAreaTriggerStay(_, results)
    -- Clear the table
    self.sv.areaTriggerObjects = {}

    -- Loop through results and add it to the table.
    for index, result in pairs(results) do
        self.sv.areaTriggerObjects[index] = result
    end
end

-- Convert the class to a component
dofile("$CONTENT_DATA/Scripts/ComponentManager.lua")
ComponentManager.ToComponent(Radar, "Radars", true)