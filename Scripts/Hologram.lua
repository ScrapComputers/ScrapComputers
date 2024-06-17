dofile("$CONTENT_DATA/Scripts/Config.lua")

---@class Hologram : ShapeClass
Hologram = class()
Hologram.maxParentCount = 1
Hologram.maxChildCount = 0
Hologram.connectionInput = sm.interactable.connectionType.compositeIO
Hologram.connectionOutput = sm.interactable.connectionType.none
Hologram.colorNormal = sm.color.new(0x4d2694ff)
Hologram.colorHighlight = sm.color.new(0x4126f0ff)

-- CLIENT/SERVER --
local SPHERE_UUID = sm.uuid.new("7e293356-7c15-4238-bb73-467cd80b7558")
local CUBE_UUID = sm.uuid.new("0a331ed9-2bc8-4c5b-a523-20cefe1dd8e8")

-- SERVER --

function Hologram:server_createObjectData(data, index)
    return {
        ---Gets the ID of the object
        ---@return number id The ID of the object
        getId = function ()
            -- Check if object exists, if not then error it out. if it exists. return the id.
            assert(self.sv.rawObjects[index] ~= nil, "Object dosen't exist!")

            return index
        end,

        ---Gets the UUID of the object
        ---@return Uuid uuid The UUID of the object
        getUUID = function ()
            -- Check if object exists, if not then error it out. if it exists. return the uuid.
            assert(self.sv.rawObjects[index] ~= nil, "Object dosen't exist!")

            return data[1]
        end,

        ---Gets the Position of the object
        ---@return Vec3 position The Position of the object
        getPosition = function ()
            -- Check if object exists, if not then error it out. if it exists. return the position.
            assert(self.sv.rawObjects[index] ~= nil, "Object dosen't exist!")

            return data[2]
        end,

        ---Gets the Rotation of the object
        ---@return Vec3 rosition The Rotation of the object
        getRotation = function ()
            -- Check if object exists, if not then error it out. if it exists. return the rotation.
            assert(self.sv.rawObjects[index] ~= nil, "Object dosen't exist!")

            return data[3]
        end,

        ---Gets the Scale of the object
        ---@return Vec3 scale The Scale of the object
        getScale = function ()
            -- Check if object exists, if not then error it out. if it exists. return the scale.

            assert(self.sv.rawObjects[index] ~= nil, "Object dosen't exist!")
            return data[4]
        end,

        ---Gets the Color of the object
        ---@return Color color The Color of the object
        getColor = function ()
            -- Check if object exists, if not then error it out. if it exists. return the color.
            assert(self.sv.rawObjects[index] ~= nil, "Object dosen't exist!")

            return data[5]
        end,

        ---Sets the object's UUID to be the argument.
        ---@param value string|Uuid The new UUID
        setUUID = function (value)
            assert(self.sv.rawObjects[index] ~= nil, "Object dosen't exist!") -- Check if object exists. if not then error it out
            assert((type(value) == "string" or type(value) == "Uuid"), "Expected Uuid or string, Got "..type(value).." instead!") -- Check if the argument has the correct type, If not then error it out.

            -- Check if the value is a string
            if type(value) == "string" then
                -- Since it is. change it to be a actual UUID
                local uuid = sm.uuid.new(value)

                -- Check if nil and check if the uuid does exist via shape. else error it
                if uuid:isNil() then error("UUID cannot be Nil!") end
                if not sm.shape.uuidExists(uuid) then error("Shape not found!") end

                -- Set the value
                self.sv.rawObjects[index][1] = uuid
            else
                -- Set the value
                self.sv.rawObjects[index][1] = value
            end
            self:server_setObject(self.sv.rawObjects[index], index)
        end,

        ---Sets the object's Position to be the argument.
        ---@param value Vec3 The new Position
        setPosition = function (value)
            assert(self.sv.rawObjects[index] ~= nil, "Object dosen't exist!") -- Check if object exists. if not then error it out
            assert(type(value) == "Vec3", "Expected Vec3, Got "..type(value).." instead!") -- Check if the argument has the correct type, If not then error it out.

            -- Set the value
            self.sv.rawObjects[index][2] = value
            self:server_setObject(self.sv.rawObjects[index], index)
        end,

        ---Sets the object's Position to be the argument.
        ---@param value Vec3 The new Position
        setRotation = function (value)
            assert(self.sv.rawObjects[index] ~= nil, "Object dosen't exist!") -- Check if object exists. if not then error it out
            assert(type(value) == "Vec3", "Expected Vec3, Got "..type(value).." instead!") -- Check if the argument has the correct type, If not then error it out.

            -- Set the value
            self.sv.rawObjects[index][3] = value
            self:server_setObject(self.sv.rawObjects[index], index)
        end,

        ---Sets the object's Position to be the argument.
        ---@param value Vec3 The new Position
        setScale = function (value)
            assert(self.sv.rawObjects[index] ~= nil, "Object dosen't exist!") -- Check if object exists. if not then error it out
            assert(type(value) == "Vec3", "Expected Vec3, Got "..type(value).." instead!") -- Check if the argument has the correct type, If not then error it out.

            -- Set the value
            self.sv.rawObjects[index][4] = value
            self:server_setObject(self.sv.rawObjects[index], index)
        end,

        ---Sets the object's Color to be the argument.
        ---@param value Color The new Color
        setColor = function (value)
            assert(self.sv.rawObjects[index] ~= nil, "Object dosen't exist!") -- Check if object exists. if not then error it out
            assert((type(value) == "Color" or type(value) == "string"), "Expected Color or string, Got "..type(value).." instead!") -- Check if the argument has the correct type, If not then error it out.

            -- Set the value (if value is a color type, then convert it to a string)
            self.sv.rawObjects[index][5] = (type(value) == "Color" and value:getHexStr() or value)
            self:server_setObject(self.sv.rawObjects[index], index)
        end,

        ---Deletes the object
        delete = function ()
            -- Check if it exists. if not then error it out.
            assert(self.sv.rawObjects[index] ~= nil, "Object already dosen't exist!")

            -- Destroy it.
            self.sv.rawObjects[index] = nil
            self:server_deleteObject(index)
        end,

        ---Returns true if the object has been de;eted
        ---@return boolean beenDeleted If true, the object is deleted. else its false and its NOT deleted.
        isDeleted = function ()
            return self.sv.rawObjects[index] == nil
        end
    }
end

function Hologram:sv_createData()
    -- Creates a object
    local function createObject(uuid, position, rotation, scale, color)
        -- Check if it has a limit
        if sc.config.configurations[3].selectedOption ~= 1 then
            -- It has one! Convert the selected option from string to number.
            local maxStr = sc.config.configurations[3].options[sc.config.configurations[3].selectedOption]:gsub(" Max", "")
            
            if self.sv.index == tonumber(maxStr) then
                error("Too many objects! (Max is: "..maxStr.."! Change in Configurator to increase it or setting it to Unlimited!)")
            end
        end
        self.sv.index = self.sv.index + 1 -- Increase index by 1

        -- Add it to self.sv.rawObjects with the positon as self.sv.index, it will contain the uuid, position, rotation, scale and color.
        table.insert(self.sv.rawObjects, self.sv.index, {uuid, position, rotation, scale, color})
        
        -- Set its object so it's effect gets created
        self:server_setObject(self.sv.rawObjects[self.sv.index], self.sv.index)

        -- Return the id of the object
        return self.sv.index
    end

    return {
        ---Creates a cube object
        ---@param position Vec3 The position of the object
        ---@param rotation Vec3 The rotation of the object
        ---@param scale Vec3 The scale of the object
        ---@param color Color|string The color of the object
        ---@return integer id The id of the object
        createCube = function (position, rotation, scale, color)
            -- Do a ton of error checking
            assert(type(position) == "Vec3", "Bad argument #1. Expected Vec3, got "..type(position).." instead!")
            assert(type(rotation) == "Vec3", "Bad argument #2. Expected Vec3, got "..type(rotation).." instead!")
            assert(type(scale) == "Vec3", "Bad argument #3. Expected Vec3, got "..type(scale).." instead!")
            assert((type(color) == "Color" or type(color) == "string"), "Bad argument #4. Expected Color or string, got "..type(color).." instead!")

            -- Create it and return its output
            return createObject(CUBE_UUID, position, sm.quat.fromEuler(rotation), scale, (type(color) == "Color" and color:getHexStr() or color))
        end,

        ---Creates a sphere object
        ---@param position Vec3 The position of the object
        ---@param rotation Vec3 The rotation of the object
        ---@param scale Vec3 The scale of the object
        ---@param color Color|string The color of the object
        ---@return integer id The id of the object
        createSphere = function (position, rotation, scale, color)
             -- Do a ton of error checking
            assert(type(position) == "Vec3", "Bad argument #1. Expected Vec3, got "..type(position).." instead!")
            assert(type(rotation) == "Vec3", "Bad argument #2. Expected Vec3, got "..type(rotation).." instead!")
            assert(type(scale) == "Vec3", "Bad argument #3. Expected Vec3, got "..type(scale).." instead!")
            assert((type(color) == "Color" or type(color) == "string"), "Bad argument #4. Expected Color or string, got "..type(color).." instead!")

            -- Create it and return its output
            return createObject(SPHERE_UUID, position, sm.quat.fromEuler(rotation), scale, (type(color) == "Color" and color:getHexStr() or color))
        end,

        ---Like createCube or createSphere but u can pass any kind of object from whatever loaded mod! (Via UUID)
        ---@param uuid Uuid The uuid of the object
        ---@param position Vec3 The position of the object
        ---@param rotation Vec3 The rotation of the object
        ---@param scale Vec3 The scale of the object
        ---@param color Color|string The color of the object
        ---@return integer id The id of the object
        createCustomObject = function (uuid, position, rotation, scale, color)
            -- Do a ton of error checking
            assert(type(rotation) == "Vec3", "Bad argument #2. Expected Vec3, got "..type(rotation).." instead!")
            assert(type(scale) == "Vec3", "Bad argument #3. Expected Vec3, got "..type(scale).." instead!")
            assert((type(color) == "Color" or type(color) == "string"), "Bad argument #4. Expected Color or string, got "..type(color).." instead!")
            assert((type(uuid) == "string" or type(uuid) == "Uuid"), "Expected Uuid or string, Got "..type(uuid).." instead!")

            local newUuid = uuid

            -- Check if the value is a string
            if type(uuid) == "string" then
                 -- Since it is. change it to be a actual UUID
                local newIshuuid = sm.uuid.new(uuid)

                -- Check if nil and check if the uuid does exist via shape. else error it
                if newIshuuid:isNil() then error("UUID cannot be Nil!") end
                if not sm.shape.uuidExists(newIshuuid) then error("Shape not found!") end

                -- Set the value
                newUuid = newIshuuid
            end
             
            -- Create it and return its output
            return createObject(newUuid, position, sm.quat.fromEuler(rotation), scale, (type(color) == "Color" and color:getHexStr() or color))
        end,

        ---Gets the object via Object id and returns a table containing the data of that object or nil since it dosen't exist.
        ---@param index number The object u wanna get its data.
        ---@return table? object Ether u get a table (so the object exists) or nil (so the object dose NOT exist)
        getObject = function (index)
            -- Check if the object even exists. if not then return nil since we know it dosent exist
            if not self.sv.rawObjects[index] then return nil end

            -- Create the data for that object id and return it's output.
            return self:server_createObjectData(self.sv.rawObjects[index], index)
        end
    }
end

-- Used when u have to update a object
function Hologram:server_setObject(data, index)
    -- Add {data, index} to self.sv.pendingObjects
    table.insert(self.sv.pendingObjects, {data, index})
end

-- Used to delete a object
function Hologram:server_deleteObject(index)
    -- Add index to self.sv.pendingDeletingObjects
    table.insert(self.sv.pendingDeletingObjects, index)
end

function Hologram:server_onCreate()
    -- Create the server-side only variables
    self.sv = { rawObjects = {}, pendingObjects = {}, pendingDeletingObjects = {}, index = 0 }
end

function Hologram:server_onFixedUpdate()
    -- Check if theres contents inside the table
    if self.sv.pendingObjects ~= {} then
        -- Loop through them and call function to all clients with that object
        for _, obj in pairs(self.sv.pendingObjects) do
            self.network:sendToClients("client_setObject", obj)
        end

        -- Clear it
        self.sv.pendingObjects = {}
    end

    -- Check if theres contents inside the table
    if self.sv.pendingDeletingObjects ~= {} then
        -- Loop through them and call function to all clients to delete it.
        for _, index in pairs(self.sv.pendingDeletingObjects) do
            self.network:sendToClients("client_deleteObject", index)
        end

        -- Clear it
        self.sv.pendingDeletingObjects = {}
    end

    -- Get all parents
    local parents = self.interactable:getParents()

    -- Check if there are parents connected
    if #parents > 0 then
        -- Loop through them
        for _, parent in pairs(parents) do
            -- Check if it is NOT active
            if not parent:isActive() then
                -- Reset the index counter
                self.sv.index = 0
            end
        end
    end
end


-- CLIENT --

function Hologram:client_onCreate()
    -- Create client-side only variables
    self.cl = {
        ---@type Effect[]
        effects = {},
    }
end

-- Used to destroy all effects
function Hologram:client_destroyEffects()
    -- Loop through them
    for _, effect in pairs(self.cl.effects) do
        -- Check if it exists, if so then destroy it
        if sm.exists(effect) then effect:destroy() end
    end

    -- Clear it.
    self.cl.effects = {}
end

function Hologram:client_onFixedUpdate()
    -- Get all parents
    local parents = self.interactable:getParents()

    -- Check if there are parents connected
    if #parents > 0 then
        -- Loop through them
        for _, parent in pairs(parents) do
            -- Check if it is NOT active
            if not parent:isActive() then
                -- Destroy all effects and break the loop.
                self:client_destroyEffects()
                break
            end
        end
    end
end

-- 2 things it does:
--
-- If its brand new object: Create the effect and then set its parameters
--
-- Else just set its parameters
function Hologram:client_setObject(data)
    -- Unpack the data variable
    local data, index = unpack(data)

    -- Check if the effect dosen't exist
    if not self.cl.effects[index] then
        -- Since it dosen't. Create and start it.
        local effect = sm.effect.createEffect("ScrapComputers - HologramEffect", self.interactable)
        effect:setAutoPlay(true)
        effect:start()

        -- Add it to the list
        self.cl.effects[index] = effect
    end

    -- Get the effect
    local effect = self.cl.effects[index]

    -- Set parameters
    effect:setParameter("uuid", data[1])
    effect:setParameter("color", sm.color.new(data[5]))
    
    -- Set offset stuff.
    effect:setOffsetPosition(sm.vec3.new(data[2].x, data[2].y + 2, data[2].z) / 4)
    effect:setOffsetRotation(data[3])

    -- Set scale
    effect:setScale(data[4] / 4)
end

-- Used to delete a object (for real)
function Hologram:client_deleteObject(index)
    -- Check if effect exists.
    if sm.exists(self.cl.effects[index]) then
        -- Destroy it since it exists
        self.cl.effects[index]:destroy()
    end
    
    -- Remove it from the table.
    table.remove(self.cl.effects, index)
end

-- Convert the class to a component
dofile("$CONTENT_DATA/Scripts/ComponentManager.lua")
sc.componentManager.ToComponent(Hologram, "Holograms", true)