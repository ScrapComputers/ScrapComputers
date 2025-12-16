---@class HologramClass : ShapeClass
HologramClass = class()
HologramClass.maxParentCount = -1
HologramClass.maxChildCount = 0
HologramClass.connectionInput = sm.interactable.connectionType.compositeIO
HologramClass.connectionOutput = sm.interactable.connectionType.none
HologramClass.colorNormal = sm.color.new(0x4d2694ff)
HologramClass.colorHighlight = sm.color.new(0x4126f0ff)

-- CLIENT/SERVER --

local SPHERE_UUID = sm.uuid.new("7e293356-7c15-4238-bb73-467cd80b7558")
local CUBE_UUID = sm.uuid.new("0a331ed9-2bc8-4c5b-a523-20cefe1dd8e8")

local function axisToVec3(axis)
    if axis == -3 then
        return sm.vec3.new(0, 0, -1)
    elseif axis == -2 then
        return sm.vec3.new(0, -1, 0)
    elseif axis == -1 then
        return sm.vec3.new(-1, 0, 0)
    elseif axis == 1 then
        return sm.vec3.new(1, 0, 0)
    elseif axis == 2 then
        return sm.vec3.new(0, 1, 0)
    elseif axis == 3 then
        return sm.vec3.new(0, 0, 1)
    end
end

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

        ---Creates a hologram of the given blueprint JSON.
        ---@param blueprintJson table | string The blueprint json.
        ---@param scale number The scale of the blueprint relative to the real size, 1 is 1:1.
        ---@param offsetPosition Vec3 The offset position from the hologram to place the hologram.
        ---@param offsetRotation Quat The offset rotation from the hologram to place the hologram.
        ---@return table ids ids of the effects of the created blueprint.
        createBlueprint = function (blueprintJson, scale, offsetPosition, offsetRotation)
            sm.scrapcomputers.errorHandler.assertArgument(blueprintJson, 1, {"table", "string"})
            sm.scrapcomputers.errorHandler.assertArgument(scale, 2, {"nil", "number"})
            sm.scrapcomputers.errorHandler.assertArgument(offsetPosition, 3, {"nil", "Vec3"})
            sm.scrapcomputers.errorHandler.assertArgument(offsetRotation, 4, {"nil", "Vec3", "Quat"})

            scale = scale or 0.25
            offsetPosition = offsetPosition or sm.vec3.zero()
            
            offsetRotation = offsetRotation and (type(offsetRotation) == "Quat" and offsetRotation or sm.quat.fromEuler(offsetRotation)) or sm.quat.identity()
            offsetRotation = offsetRotation * sm.quat.angleAxis(math.rad(90), sm.vec3.new(1, 0, 0)) * sm.quat.angleAxis(math.rad(180), sm.vec3.new(0, 1, 0))

            local hologramEffects = {}
            
            local blueprintTable = type(blueprintJson) == "table" and blueprintJson or sm.json.parseJsonString(blueprintJson)
            local smallestCorner, largestCorner

            if type(blueprintTable) ~= "table" then
                error("Blueprint could not be parsed into LUA table, possible malformed structure")
            end

            blueprintTable.bodies = blueprintTable.bodies or {}
            blueprintTable.joints = blueprintTable.joints or {}

            for _, body in pairs(blueprintTable.bodies) do
                for _, child in pairs(body.childs) do
                    local pos = child.pos
                    local uuid = sm.uuid.new(child.shapeId)
                    local isBlock = sm.item.isBlock(uuid)
                    local worldPos

                    if isBlock then
                        local blockScale = sm.vec3.new(child.bounds.x, child.bounds.y, child.bounds.z)

                        worldPos = offsetRotation * (sm.vec3.new(pos.x, pos.y, pos.z) + blockScale / 2) * scale 

                        table.insert(hologramEffects, 
                            createObject(
                                uuid,
                                worldPos,
                                offsetRotation * sm.util.axesToQuat(axisToVec3(child.xaxis), axisToVec3(child.zaxis)),
                                blockScale * scale,
                                child.color
                            )
                        )
                    else
                        local xaxis = axisToVec3(child.xaxis)
                        local zaxis = axisToVec3(child.zaxis)
                        local rotation = sm.util.axesToQuat(xaxis, zaxis)
                        local bounds = child.bounds and sm.vec3.new(child.bounds.x, child.bounds.y, child.bounds.z)
                        local bb = rotation * (bounds or sm.item.getShapeSize(uuid))

                        worldPos = offsetRotation * (sm.vec3.new(pos.x, pos.y, pos.z) + bb / 2) * scale
        
                        table.insert(hologramEffects, 
                            createObject(
                                uuid,
                                worldPos,
                                offsetRotation * rotation,
                                (bounds or sm.vec3.one()) * scale,
                                child.color
                            )
                        )
                    end

                    if not smallestCorner then
                        smallestCorner = worldPos
                        largestCorner = worldPos
                    else
                        smallestCorner = smallestCorner:min(worldPos)
                        largestCorner = largestCorner:max(worldPos)
                    end
                end
            end

            for _, joint in pairs(blueprintTable.joints) do
                local tablePos = joint.posA
                local pos = sm.vec3.new(tablePos.x, tablePos.y, tablePos.z)
                local uuid = sm.uuid.new(joint.shapeId)
                local rotation = sm.util.axesToQuat(axisToVec3(joint.xaxisA), axisToVec3(joint.zaxisA))
                local bb = rotation * sm.item.getShapeSize(uuid)

                local halfVec = sm.vec3.one() / 2
                pos = pos - rotation * halfVec + halfVec

                local worldPos = offsetRotation * (pos + bb / 2) * scale

                table.insert(hologramEffects,
                    createObject(
                        uuid,
                        worldPos,
                        offsetRotation * rotation,
                        sm.vec3.one() * scale,
                        joint.color
                    )
                )

                if not smallestCorner then
                    smallestCorner = worldPos
                    largestCorner = worldPos
                else
                    smallestCorner = smallestCorner:min(worldPos)
                    largestCorner = largestCorner:max(worldPos)
                end
            end

            local bb = largestCorner - smallestCorner
            local center = bb / 2 + smallestCorner
            local modify = center - sm.vec3.new(0, bb.y / 2, 0)

            for _, id in pairs(hologramEffects) do
                local object = self.sv.rawObjects[id] and self:sv_createObjectData(id)

                if object then
                    object.setPosition(object.getPosition() - modify + offsetPosition)
                end
            end
    
            return hologramEffects
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

function HologramClass:sv_onPowerLoss()
    for index, object in pairs(self.sv.rawObjects) do
        if object then
            self:sv_deleteObject(index)
        end
    end
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
    for i, object in pairs(self.sv.pendingObjects) do
        self.network:sendToClients("cl_setOrCreateObject", object)
        self.sv.pendingObjects[i] = nil
    end

    for i, index in pairs(self.sv.pendingDeletingObjects) do
        self.network:sendToClients("cl_deleteObject", index)
        self.sv.pendingDeletingObjects[i] = nil
    end

    local parents = self.interactable:getParents()
    local resetIndex = #parents == 0
    for _, parent in pairs(parents) do
        if parent.active then
            resetIndex = false
            break
        end
    end

    if resetIndex then
        self.sv.index = 0
    end

    sm.scrapcomputers.powerManager.updatePowerInstance(self.shape.id, 0.2 * sm.scrapcomputers.table.getTableSize(self.sv.rawObjects))
end

function HologramClass:sv_updateObj(data, index)
    table.insert(self.sv.pendingObjects, {data, index})
end

function HologramClass:sv_deleteObject(index)
    table.insert(self.sv.pendingDeletingObjects, index)
end

-- CLIENT --

function HologramClass:client_onCreate()
    self.cl = {
        effects = {}
    }
end

function HologramClass:client_onFixedUpdate()
    local parents = self.interactable:getParents()
    local killEffects = #parents == 0

    for _, parent in pairs(parents) do
        if parent.active then
            killEffects = false
            break
        end
    end

    if killEffects then
        self:cl_killEmAll()
    end
end


function HologramClass:client_onDestroy()
    self:cl_killEmAll()
end

function HologramClass:cl_killEmAll()
    for _, effect in pairs(self.cl.effects) do
        if sm.exists(effect) then
            effect:destroy()
        end
    end
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
sm.scrapcomputers.componentManager.toComponent(HologramClass, "Holograms", true, true, true)