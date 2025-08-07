---@class HologramClass : ShapeClass
HologramClass = class()
HologramClass.maxParentCount = 1
HologramClass.maxChildCount = 0
HologramClass.connectionInput = sm.interactable.connectionType.compositeIO
HologramClass.connectionOutput = sm.interactable.connectionType.none
HologramClass.colorNormal = sm.color.new(0x4d2694ff)
HologramClass.colorHighlight = sm.color.new(0x4126f0ff)

-- CLIENT/SERVER --

local SPHERE_UUID = sm.uuid.new("7e293356-7c15-4238-bb73-467cd80b7558")
local CUBE_UUID = sm.uuid.new("0a331ed9-2bc8-4c5b-a523-20cefe1dd8e8")

-- SERVER --

function HologramClass:sv_createObjectData(index)
    return {
        ---Gets the ID of the object
        ---@return number id The ID of the object
        getId = function ()
            sm.scrapcomputers.errorHandler.assert(self.sv.rawObjects[index] ~= nil, nil, "Object dosen't exist!")
            return index
        end,

        ---Gets the UUID of the object
        ---@return Uuid uuid The UUID of the object
        getUUID = function ()
            sm.scrapcomputers.errorHandler.assert(self.sv.rawObjects[index] ~= nil, nil, "Object dosen't exist!")
            return self.sv.rawObjects[index][1]
        end,

        ---Gets the Position of the object
        ---@return Vec3 position The Position of the object
        getPosition = function ()
            sm.scrapcomputers.errorHandler.assert(self.sv.rawObjects[index] ~= nil, nil, "Object dosen't exist!")
            return self.sv.rawObjects[index][2]
        end,

        ---Gets the Rotation of the object
        ---@return Quat rosition The Rotation of the object
        getRotation = function ()
            sm.scrapcomputers.errorHandler.assert(self.sv.rawObjects[index] ~= nil, nil, "Object dosen't exist!")
            return self.sv.rawObjects[index][3]
        end,

        ---Gets the Scale of the object
        ---@return Vec3 scale The Scale of the object
        getScale = function ()
            sm.scrapcomputers.errorHandler.assert(self.sv.rawObjects[index] ~= nil, nil, "Object dosen't exist!")
            return self.sv.rawObjects[index][4]
        end,

        ---Gets the Color of the object
        ---@return Color color The Color of the object
        getColor = function ()
            sm.scrapcomputers.errorHandler.assert(self.sv.rawObjects[index] ~= nil, nil, "Object dosen't exist!")
            return self.sv.rawObjects[index][5]
        end,

        ---Sets the object's UUID to be the argument.
        ---@param value string|Uuid The new UUID
        setUUID = function (value)
            sm.scrapcomputers.errorHandler.assert(self.sv.rawObjects[index] ~= nil, nil, "Object dosen't exist!")
            sm.scrapcomputers.errorHandler.assertArgument(value, nil, {"Uuid", "string"})

            uuid = type(uuid) == "Uuid" and uuid or sm.uuid.new(uuid)

            sm.scrapcomputers.errorHandler.assert(not uuid:isNil(), nil, "UUID cannot be nil!")
            sm.scrapcomputers.errorHandler.assert(sm.shape.uuidExists(uuid), nil, "UUID doesnt exist! (Or its not a shape!)")

            self.sv.rawObjects[index][1] = uuid
            self:sv_updateObj(self.sv.rawObjects[index], index)
        end,

        ---Sets the object's Position to be the argument.
        ---@param value Vec3 The new Position
        setPosition = function (value)
            sm.scrapcomputers.errorHandler.assert(self.sv.rawObjects[index] ~= nil, nil, "Object dosen't exist!")
            sm.scrapcomputers.errorHandler.assertArgument(value, nil, {"Vec3"})

            self.sv.rawObjects[index][2] = value
            self:sv_updateObj(self.sv.rawObjects[index], index)
        end,

        ---Sets the object's Rotation to be the argument.
        ---@param value MultiRotationType The new Rotation
        setRotation = function (value)
            sm.scrapcomputers.errorHandler.assert(self.sv.rawObjects[index] ~= nil, nil, "Object dosen't exist!")
            sm.scrapcomputers.errorHandler.assertArgument(value, nil, {"Vec3", "Quat"})
            
            self.sv.rawObjects[index][3] = type(value) == "Quat" and value or sm.quat.fromEuler(value)
            self:sv_updateObj(self.sv.rawObjects[index], index)
        end,

        ---Sets the object's Scale to be the argument.
        ---@param value Vec3 The new Scale
        setScale = function (value)
            sm.scrapcomputers.errorHandler.assert(self.sv.rawObjects[index] ~= nil, nil, "Object dosen't exist!")
            sm.scrapcomputers.errorHandler.assertArgument(value, nil, {"Vec3"})

            self.sv.rawObjects[index][4] = value
            self:sv_updateObj(self.sv.rawObjects[index], index)
        end,

        ---Sets the object's Color to be the argument.
        ---@param value MultiColorTypeNonNil The new Color
        setColor = function (value)
            sm.scrapcomputers.errorHandler.assert(self.sv.rawObjects[index] ~= nil, nil, "Object dosen't exist!")
            sm.scrapcomputers.errorHandler.assertArgument(value, nil, {"Color", "string"})

            self.sv.rawObjects[index][5] = type(value) == "string" and value or value:getHexStr()
            self:sv_updateObj(self.sv.rawObjects[index], index)
        end,

        ---Deletes this hologram object, youl be nolonger able to use any of its functions other than isDeleted then.
        delete = function ()
            sm.scrapcomputers.errorHandler.assert(self.sv.rawObjects[index] ~= nil, nil, "Object already dosen't exist!")

            self.sv.rawObjects[index] = nil
            self:sv_deleteObject(index)
        end,

        ---Returns true if the object has been deleted
        ---@return boolean isDeleted If true, the object is deleted. else its false and its NOT deleted.
        isDeleted = function ()
            return self.sv.rawObjects[index] == nil
        end
}
end

function HologramClass:sv_createData()
    local function createObject(uuid, position, rotation, scale, color)
        local maxObjectsConfig = sm.scrapcomputers.config.getConfig("scrapcomputers.hologram.max_objects")
        
        if maxObjectsConfig.selectedOption ~= 1 then
            local maxStr = maxObjectsConfig.options[maxObjectsConfig.selectedOption]:gsub(" Max", "")

            sm.scrapcomputers.errorHandler.assert(not (self.sv.index == tonumber(maxStr)), "Too many objects! (Max is: " .. maxStr .. "! Change in Configurator to increase it or setting it to Unlimited!)")
        end

        self.sv.index = self.sv.index + 1
        table.insert(self.sv.rawObjects, self.sv.index, {uuid, position, rotation, scale, color})
        
        self:sv_updateObj(self.sv.rawObjects[self.sv.index], self.sv.index)

        return self.sv.index
    end

    return {
        ---Creates a cube object
        ---@param position Vec3 The position of the object
        ---@param rotation MultiRotationType The rotation of the object
        ---@param scale Vec3 The scale of the object
        ---@param color Color|string The color of the object
        ---@return integer id The id of the object
        createCube = function (position, rotation, scale, color)
            sm.scrapcomputers.errorHandler.assertArgument(position, 1, {"Vec3"})
            sm.scrapcomputers.errorHandler.assertArgument(rotation, 2, {"Vec3", "Quat"})
            sm.scrapcomputers.errorHandler.assertArgument(scale, 3, {"Vec3"})
            sm.scrapcomputers.errorHandler.assertArgument(color, 4, {"Color", "string"})
            
            return createObject(CUBE_UUID, position, type(rotation) == "Quat" and rotation or sm.quat.fromEuler(rotation), scale, (type(color) == "Color" and color:getHexStr() or color))
        end,

        ---Creates a sphere object
        ---@param position Vec3 The position of the object
        ---@param rotation MultiRotationType The rotation of the object
        ---@param scale Vec3 The scale of the object
        ---@param color Color|string The color of the object
        ---@return integer id The id of the object
        createSphere = function (position, rotation, scale, color)
            sm.scrapcomputers.errorHandler.assertArgument(position, 1, {"Vec3"})
            sm.scrapcomputers.errorHandler.assertArgument(rotation, 2, {"Vec3", "Quat"})
            sm.scrapcomputers.errorHandler.assertArgument(scale, 3, {"Vec3"})
            sm.scrapcomputers.errorHandler.assertArgument(color, 4, {"Color", "string"})
            
            return createObject(SPHERE_UUID, position, type(rotation) == "Quat" and rotation or sm.quat.fromEuler(rotation), scale, (type(color) == "Color" and color:getHexStr() or color))
        end,

        ---Like createCube or createSphere but u can pass any kind of object from whatever loaded mod! (Via UUID)
        ---@param uuid Uuid The uuid of the object
        ---@param position Vec3 The position of the object
        ---@param rotation MultiRotationType The rotation of the object
        ---@param scale Vec3 The scale of the object
        ---@param color Color|string The color of the object
        ---@return integer id The id of the object
        createCustomObject = function (uuid, position, rotation, scale, color)
            sm.scrapcomputers.errorHandler.assertArgument(uuid, 1, {"Uuid", "string"})
            sm.scrapcomputers.errorHandler.assertArgument(position, 2, {"Vec3"})
            sm.scrapcomputers.errorHandler.assertArgument(rotation, 3, {"Vec3", "Quat"})
            sm.scrapcomputers.errorHandler.assertArgument(scale, 4, {"Vec3"})
            sm.scrapcomputers.errorHandler.assertArgument(color, 5, {"Color", "string"})

            uuid = type(uuid) == "Uuid" and uuid or sm.uuid.new(uuid)

            sm.scrapcomputers.errorHandler.assert(not uuid:isNil(), nil, "UUID cannot be nil!")
            sm.scrapcomputers.errorHandler.assert(sm.shape.uuidExists(uuid), nil, "UUID doesnt exist! (Or its not a shape!)")

            return createObject(uuid, position, type(rotation) == "Quat" and rotation or sm.quat.fromEuler(rotation), scale, (type(color) == "Color" and color:getHexStr() or color))
        end,

        ---Gets the object via Object id and returns a table containing the data of that object or nil since it dosen't exist.
        ---@param index number The object u wanna get its data.
        ---@return HologramObject? object Ether u get a table (so the object exists) or nil (so the object dose NOT exist)
        getObject = function (index)
            if not self.sv.rawObjects[index] then return nil end

            return self:sv_createObjectData(index)
        end
}
end

function HologramClass:server_onCreate()
    self.sv = {
        rawObjects = {},
        pendingObjects = {},
        pendingDeletingObjects = {},
        index = 0,
    }
end

function HologramClass:server_onFixedUpdate()
    if self.sv.pendingObjects ~= {} then
        for _, object in pairs(self.sv.pendingObjects) do
            self.network:sendToClients("cl_setOrCreateObject", object)
        end

        self.sv.pendingObjects = {}
    end

    if self.sv.pendingDeletingObjects ~= {} then
        for _, index in pairs(self.sv.pendingDeletingObjects) do
            self.network:sendToClients("cl_deleteObject", index)
        end

        self.sv.pendingDeletingObjects = {}
    end

    local parent = self.interactable:getSingleParent()
    if parent and not parent.active then
        self.sv.index = 0
    end
end

function HologramClass:sv_updateObj(data, index)
    table.insert(self.sv.pendingObjects, {data, index})
end

function HologramClass:sv_deleteObject(index)
    table.insert(self.sv.pendingDeletingObjects, index)
end

-- CLIENT --

function HologramClass:client_onCreate()
    if self.cl then
        self:cl_killEmAll()
    end

    self.cl = {  effects = {} }
end

function HologramClass:client_onFixedUpdate()
    local parents = self.interactable:getParents()

    if #parents > 0 then
        for _, parent in pairs(parents) do
            if not parent.active then
                self:cl_killEmAll()
                break
            end
        end
    end
end

function HologramClass:cl_killEmAll()
    for _, effect in pairs(self.cl.effects) do
        if sm.exists(effect) then
            effect:destroy()
        end
    end

    self.cl.effects = {}
end

---@param data {[1]: table, [2]: integer} The data
function HologramClass:cl_setOrCreateObject(data)
    local data, index = unpack(data)

    if not self.cl.effects[index] then
        local effect = sm.effect.createEffect("ScrapComputers - HologramEffect", self.interactable)
        effect:setAutoPlay(true)
        effect:start()

        self.cl.effects[index] = effect
    end

    local effect = self.cl.effects[index]
    effect:setParameter("uuid", data[1])
    effect:setParameter("color", sm.color.new(data[5]))
    
    effect:setOffsetPosition(sm.vec3.new(data[2].x, data[2].y + 2, data[2].z) / 4)
    effect:setOffsetRotation(data[3])

    effect:setScale(data[4] / 4)
end

---@param index integer The object id
function HologramClass:cl_deleteObject(index)
    if sm.exists(self.cl.effects[index]) then
        self.cl.effects[index]:destroy()
    end
    
    self.cl.effects[index] = nil
end

-- Convert the class to a component
sm.scrapcomputers.componentManager.toComponent(HologramClass, "Holograms", true)