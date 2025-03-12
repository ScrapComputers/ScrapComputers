---@diagnostic disable

---@alias type
---| "nil"
---| "number"
---| "string"
---| "boolean"
---| "table"
---| "function"
---| "thread"
---| "userdata"
---| "Shape"
---| "Body"
---| "Character"
---| "Joint"
---| "Harvestable"
---| "AreaTrigger"
---| "Vec3"
---| "Quat"
---| "Container"
---| "RaycastResult"
---| "Interactable"
---| "Network"
---| "Player"
---| "World"
---| "GuiInterface"
---| "Tool"
---| "Portal"
---| "BlueprintVisualization"
---| "PathNode"
---| "AiState"
---| "Unit"
---| "Storage"
---| "Effect"
---| "CullSphereGroup"
---| "BuilderGuide"
---| "Lift"
---| "ScriptableObject"



---@class Vec3
---@operator mul(number): Vec3
---@operator mul(Quat): Vec3
---@operator add(Vec3): Vec3
---@operator sub(Vec3): Vec3
---@operator mul(Vec3): Vec3
---@operator div(number): Vec3
---@operator unm: Vec3
---A userdata object representing a 3D <strong>vector</strong>.  
local Vec3 = {}

---**Get**:
---Returns the X value of a vector.  
---**Set**:
---Sets the X value of a vector.  
---@type number
Vec3.x = {}

---**Get**:
---Returns the Y value of a vector.  
---**Set**:
---Sets the Y value of a vector.  
---@type number
Vec3.y = {}

---**Get**:
---Returns the Z value of a vector.  
---**Set**:
---Sets the Z value of a vector.  
---@type number
Vec3.z = {}

---Returns the <a target="_blank" href="https://en.wikipedia.org/wiki/Cross_product">cross product</a> of two vectors.  
---@param v2 Vec3 The second vector.
---@return Vec3
function Vec3:cross(v2) end

---Returns the <a target="_blank" href="https://en.wikipedia.org/wiki/Dot_product">dot product</a> of a vector.  
---@param v2 Vec3 The second vector.
---@return number
function Vec3:dot(v2) end

---Returns the length of the vector.  
---If you want the squared length, using [Vec3.length2, length2] is faster than squaring the result of this function.  
---@return number
function Vec3:length() end

---Returns the squared length of the vector.  
---@return number
function Vec3:length2() end

---Returns the maximum value between two vectors components.  
---@param v2 Vec3 The second vector.
---@return Vec3
function Vec3:max(v2) end

---Returns the minimum value between two vectors components.  
---@param v2 Vec3 The second vector.
---@return Vec3
function Vec3:min(v2) end

---Normalizes a vector, ie. converts to a unit vector of length 1.  
---@return Vec3
function Vec3:normalize() end

---Rotate a vector around an axis.  
---@param angle number The angle.
---@param normal Vec3 The axis to be rotated around.
---@return Vec3
function Vec3:rotate(angle, normal) end

---Rotate a vector around the X axis.  
---@param angle number The angle.
---@return Vec3
function Vec3:rotateX(angle) end

---Rotate a vector around the Y axis.  
---@param angle number The angle.
---@return Vec3
function Vec3:rotateY(angle) end

---Rotate a vector around the Z axis.  
---@param angle number The angle.
---@return Vec3
function Vec3:rotateZ(angle) end

---Normalizes a vector with safety, ie. converts to a unit vector of length 1.  
---@param fallback Vec3 The fallback vector
---@return Vec3
function Vec3:safeNormalize(fallback) end


---@class Quat
---@operator mul(Quat): Quat
---@operator mul(Vec3): Vec3
---A userdata object representing a <strong>quaternion</strong>.  
local Quat = {}

---**Get**:
---Returns the W value of a quaternion.  
---**Set**:
---Sets the W value of a quaternion.  
---@type number
Quat.w = {}

---**Get**:
---Returns the X value of a quaternion.  
---**Set**:
---Sets the X value of a quaternion.  
---@type number
Quat.x = {}

---**Get**:
---Returns the Y value of a quaternion.  
---**Set**:
---Sets the Y value of a quaternion.  
---@type number
Quat.y = {}

---**Get**:
---Returns the Z value of a quaternion.  
---**Set**:
---Sets the Z value of a quaternion.  
---@type number
Quat.z = {}


---@class Uuid
---A userdata object representing a <strong>uuid</strong>.  
local Uuid = {}

---Checks if the uuid is nil {00000000-0000-0000-0000-000000000000}  
---@return bool
function Uuid:isNil() end


---@class Color
---A userdata object representing a <strong>color</strong>.  
local Color = {}

---**Get**:
---Returns the alpha value of a color.  
---**Set**:
---Sets the alpha value of a color.  
---@type number
Color.a = {}

---**Get**:
---Returns the blue value of a color.  
---**Set**:
---Sets the blue value of a color.  
---@type number
Color.b = {}

---**Get**:
---Returns the green value of a color.  
---**Set**:
---Sets the green value of a color.  
---@type number
Color.g = {}

---**Get**:
---Returns the red value of a color.  
---**Set**:
---Sets the red value of a color.  
---@type number
Color.r = {}

---Get the hex representation of the color.  
---@return string
function Color:getHexStr() end


---@class RaycastResult
---A userdata object representing a <strong>raycast result</strong>.  
---A <strong>raycast result</strong> is a collection of data received from a raycast. The result contains information about where the raycast travelled and what objects it eventually hit.  
---Raycast results are the result of functions such as [sm.physics.raycast], [sm.physics.distanceRaycast] and [sm.localPlayer.getRaycast].  
local RaycastResult = {}

---**Get**:
---Returns the direction vector of the raycast  
---@type Vec3
RaycastResult.directionWorld = {}

---**Get**:
---Returns the fraction (0&ndash;1) of the distance reached until collision divided by the ray's length.  
---@type number
RaycastResult.fraction = {}

---**Get**:
---Returns the normal vector of the surface that was hit, relative to the target's rotation.  
---@type Vec3
RaycastResult.normalLocal = {}

---**Get**:
---Returns the normal vector of the hit surface  
---@type Vec3
RaycastResult.normalWorld = {}

---**Get**:
---Returns the starting world position of the raycast.  
---@type Vec3
RaycastResult.originWorld = {}

---**Get**:
---Returns the world position of the point that was hit, relative to the target's position.  
---@type Vec3
RaycastResult.pointLocal = {}

---**Get**:
---Returns the world position of the point that was hit.  
---@type Vec3
RaycastResult.pointWorld = {}

---**Get**:
---Returns the physics type of the target that was hit. (See [sm.physics.types])  
---@type string
RaycastResult.type = {}

---**Get**:
---Returns whether the raycast successfully hit a target.  
---@type boolean
RaycastResult.valid = {}

---Returns the [AreaTrigger] hit during the raycast. This is only possible if [RaycastResult.type] is equal to "areaTrigger", otherwise this will return nil.  
---@return AreaTrigger
function RaycastResult:getAreaTrigger() end

---Returns the [Body] hit during the raycast. This is only possible if [RaycastResult.type] is equal to "body", otherwise this will return nil.  
---@return Body
function RaycastResult:getBody() end

---Returns the [Character] hit during the raycast. This is only possible if [RaycastResult.type] is equal to "character", otherwise this will return nil.  
---@return Character
function RaycastResult:getCharacter() end

---Returns the [Harvestable] hit during the raycast. This is only possible if [RaycastResult.type] is equal to "harvestable", otherwise this will return nil.  
---@return Harvestable
function RaycastResult:getHarvestable() end

---Returns the [Joint] hit during the raycast. This is only possible if [RaycastResult.type] is equal to "joint", otherwise this will return nil.  
---@return Joint
function RaycastResult:getJoint() end

---Returns the [Lift] hit during the raycast. This is only possible if [RaycastResult.type] is equal to "lift", otherwise this will return nil.  
---@return Lift, boolean Lift, isTop; The lift; True if the lift is top
function RaycastResult:getLiftData() end

---Returns the [Shape] hit during the raycast. This is only possible if [RaycastResult.type] is equal to "body", otherwise this will return nil.  
---@return Shape
function RaycastResult:getShape() end


---@class LoadCellHandle
---A userdata object representing a <strong>load cell handle</strong>.  
local LoadCellHandle = {}

---*Server only*  
---@return boolean
function LoadCellHandle:release() end


---@class Shape
---A userdata object representing a <strong>shape</strong> in the game.  
local Shape = {}

---**Get**:
---Returns the direction of a shape's front side.  
---The direction is affected by the shape's rotation in the world.  
---@type Vec3
Shape.at = {}

---**Get**:
---Returns the [Body] a shape is part of.  
---@type Body
Shape.body = {}

---**Get**:
---Check if a shape is buildable  
---@type boolean
Shape.buildable = {}

---**Get**:
---Returns the buoyancy multiplier of a shape.  
---@type number
Shape.buoyancy = {}

---**Get**:
---Returns the color of a shape.  
---**Set**:
---*Server only*  
---Sets the color of a shape. This is similar to coloring with the <em>Paint Tool</em>.  
---@type Color
Shape.color = {}

---**Get**:
---Check if a shape is connectable  
---@type boolean
Shape.connectable = {}

---**Get**:
---Check if a shape is convertible to dynamic form  
---@type boolean
Shape.convertableToDynamic = {}

---**Get**:
---Check if a shape is destructable.  
---@type boolean
Shape.destructable = {}

---**Get**:
---Check if a shape is erasable.  
---@type boolean
Shape.erasable = {}

---**Get**:
---Returns the id of a shape.  
---@type integer
Shape.id = {}

---**Get**:
---Returns the [Interactable] of a shape, if one exists. Otherwise the function will return nil.  
---@type Interactable
Shape.interactable = {}

---**Get**:
---Return true if a shape is a block  
---@type boolean
Shape.isBlock = {}

---**Get**:
---Return true if a shape is a wedge  
---@type boolean
Shape.isWedge = {}

---**Get**:
---Check if a shape is liftable  
---@type boolean
Shape.liftable = {}

---**Get**:
---Returns the local grid postition of a shape.  
---@type Vec3
Shape.localPosition = {}

---**Get**:
---Returns the local rotation of a shape.  
---@type Quat
Shape.localRotation = {}

---**Get**:
---Returns the mass of a shape.  
---@type number
Shape.mass = {}

---**Get**:
---Returns the material of a shape.  
---@type string
Shape.material = {}

---**Get**:
---Returns the material id of a shape.  
---@type integer
Shape.materialId = {}

---**Get**:
---Check if a shape is paintable  
---@type boolean
Shape.paintable = {}

---**Get**:
---Returns the direction of a shape's right side.  
---The direction is affected by the shape's rotation in the world.  
---@type Vec3
Shape.right = {}

---**Get**:
---Return the amount that is stacked in the shape  
---**Set**:
---*Server only*  
---Set the amount that is stacked in the shape  
---@type integer
Shape.stackedAmount = {}

---**Get**:
---Return the item [Uuid] that is stacked in the shape  
---**Set**:
---*Server only*  
---Set the item [Uuid] that is stacked in the shape  
---@type Uuid
Shape.stackedItem = {}

---**Get**:
---Returns the direction of a shape's top side.  
---The direction is affected by the shape's rotation in the world.  
---@type Vec3
Shape.up = {}

---**Get**:
---Check if a shape is interactable  
---@type boolean
Shape.usable = {}

---**Get**:
---Returns the uuid string unique to a shape/block type.  
---@type Uuid
Shape.shapeUuid = {}

---**Get**:
---Returns the uuid string unique to a shape/block type.  
---@type Uuid
Shape.uuid = {}

---**Get**:
---Returns the linear velocity of a shape.  
---@type Vec3
Shape.velocity = {}

---**Get**:
---Returns the world position of a shape.  
---@type Vec3
Shape.worldPosition = {}

---**Get**:
---Returns the world rotation of a shape.  
---@type Quat
Shape.worldRotation = {}

---**Get**:
---Returns the local x-axis vector of a shape.  
---@type Vec3
Shape.xAxis = {}

---**Get**:
---Returns the local y-axis vector of a shape.  
---@type Vec3
Shape.yAxis = {}

---**Get**:
---Returns the local z-axis vector of a shape.  
---@type Vec3
Shape.zAxis = {}

---*Server only*  
---Create a new joint  
---@param uuid Uuid The uuid of the joint.
---@param position Vec3 The joint's grid position.
---@param direction Vec3 The joint's normal direction.
---@return Joint					The created joint.
function Shape:createJoint(uuid, position, direction) end

---*Server only*  
---Destroy a block.  
---@param position Vec3 The local position of the removal box corner.
---@param size? Vec3 The size of the removal box. Defaults to 1x1x1 (Optional)
---@param attackLevel? integer Determines which quality level of block the attack can destroy. Setting it to 0 (default) will destroy any block.
function Shape:destroyBlock(position, size, attackLevel) end

---*Server only*  
---Destroy a part  
---@param attackLevel? integer Determines which quality level of parts the attack can destroy. Setting it to 0 (default) will destroy any part.
function Shape:destroyPart(attackLevel) end

---*Server only*  
---Destroy a shape  
---@param attackLevel? integer Determines which quality level of shape the attack can destroy. Setting it to 0 (default) will destroy any shape.
function Shape:destroyShape(attackLevel) end

---Returns the direction of a shape's front side.  
---The direction is affected by the shape's rotation in the world.  
---@return Vec3
function Shape:getAt() end

---Returns the [Body] a shape is part of.  
---@return Body
function Shape:getBody() end

---Returns the bounding box of a shape &ndash; the dimensions that a shape occupies when building.  
---@return Vec3
function Shape:getBoundingBox() end

---Returns the buoyancy multiplier of a shape.  
---@return number
function Shape:getBuoyancy() end

---Transform a world position to the closest block's local position in a shape.  
---@param position Vec3 The world position.
---@return Vec3
function Shape:getClosestBlockLocalPosition(position) end

---Returns the color of a shape.  
---@return Color
function Shape:getColor() end

---Returns the id of a shape.  
---@return integer
function Shape:getId() end

---Returns the [Interactable] of a shape, if one exists. Otherwise the function will return nil.  
---@return Interactable
function Shape:getInteractable() end

---Returns the interpolated direction of a shape's front side.  
---The direction is affected by the shape's rotation in the world.  
---@return Vec3
function Shape:getInterpolatedAt() end

---Returns the interpolated direction of a shape's right side.  
---The direction is affected by the shape's rotation in the world.  
---@return Vec3
function Shape:getInterpolatedRight() end

---Returns the interpolated direction of a shape's top side.  
---The direction is affected by the shape's rotation in the world.  
---@return Vec3
function Shape:getInterpolatedUp() end

---Returns the interpolated world position of a shape.  
---@return Vec3
function Shape:getInterpolatedWorldPosition() end

---Returns a table of all [Joint, joints] that are attached to the shape.  
---Will return all attached joints when onlyChildJoints is set to false.  
---Will only get the joints which are subshapes to the shape when onlySubshapes is set to true.  
---@param onlyChildJoints? boolean Filters what joints to return. Defaults to true (Optional)
---@param onlySubshapes? boolean Only get the joints which are subshapes to the shape. Defaults to false (Optional)
---@return Joint[]
function Shape:getJoints(onlyChildJoints, onlySubshapes) end

---Returns the local grid postition of a shape.  
---@return Vec3
function Shape:getLocalPosition() end

---Returns the local rotation of a shape.  
---@return Quat
function Shape:getLocalRotation() end

---Returns the mass of a shape.  
---@return number
function Shape:getMass() end

---Returns the material of a shape.  
---@return string
function Shape:getMaterial() end

---Returns the material id of a shape.  
---@return integer
function Shape:getMaterialId() end

---*Server only*  
---Returns a table of shapes which are neighbours to the shape  
---@return Shape[]
function Shape:getNeighbours() end

---*Server only*  
---Returns a table of shapes which are neighbours connected with pipes to the shape  
---@return Shape[]
function Shape:getPipedNeighbours() end

---Returns the direction of a shape's right side.  
---The direction is affected by the shape's rotation in the world.  
---@return Vec3
function Shape:getRight() end

---Returns the uuid string unique to a shape/block type.  
---@return Uuid
function Shape:getShapeUuid() end

---Returns the sticky directions of the shape for positive xyz and negative xyz.  
---A value of 1 means that the direction is sticky and a value of 0 means that the direction is not sticky.  
---@return Vec3, Vec3
function Shape:getSticky() end

---Returns the direction of a shape's top side.  
---The direction is affected by the shape's rotation in the world.  
---@return Vec3
function Shape:getUp() end

---Returns the linear velocity of a shape.  
---@return Vec3
function Shape:getVelocity() end

---Returns the world position of a shape.  
---@return Vec3
function Shape:getWorldPosition() end

---Returns the world rotation of a shape.  
---@return Quat
function Shape:getWorldRotation() end

---Returns the local x-axis vector of a shape.  
---@return Vec3
function Shape:getXAxis() end

---Returns the local y-axis vector of a shape.  
---@return Vec3
function Shape:getYAxis() end

---Returns the local z-axis vector of a shape.  
---@return Vec3
function Shape:getZAxis() end

---*Server only*  
---Creates a new [Shape] from [Uuid] to replace the given [Shape].  
---@param uuid Uuid The uuid of the new shape.
function Shape:replaceShape(uuid) end

---*Server only*  
---Sets the color of a shape. This is similar to coloring with the <em>Paint Tool</em>.  
---@param color Color The color.
function Shape:setColor(color) end

---@deprecated use [sm.exists]
---Return true if a shape exists.  
---@return boolean
function Shape:shapeExists() end

---Returns a table of all shapes colliding with a given sphere.  
---@param radius number The radius of the sphere.
---@return Shape[]
function Shape:shapesInSphere(radius) end

---Transform a world direction to the local shape transform.  
---@param vector Vec3 The untransformed direction.
---@return Vec3
function Shape:transformDirection(vector) end

---Transform a local point to world space.  
---```
---local worldPos = self.shape:transformLocalPoint( localPos )
---```
---@param vector Vec3 The local point.
---@return Vec3
function Shape:transformLocalPoint(vector) end

---Transform a world point to the local shape transform.  
---```
---local localPos = self.shape:transformPoint( worldPos )
---```
---@param vector Vec3 The world point.
---@return Vec3
function Shape:transformPoint(vector) end

---Transform a world rotation to the local shape transform.  
---```
---local worldUp = sm.vec3.new( 0, 0, 1 )
---local worldRot = sm.vec3.getRotation( worldUp, worldDir )
---local localRot = self.shape:transformRotation( worldRot )
---```
---@param quat Quat The untransformed quaternion.
---@return Quat
function Shape:transformRotation(quat) end


---@class Body
---A userdata object representing a <strong>body</strong> in the game.  
local Body = {}

---**Get**:
---Returns the angular velocity of a body.  
---@type Vec3
Body.angularVelocity = {}

---**Get**:
---Check if a body is buildable  
---**Set**:
---*Server only*  
---Controls whether a body is buildable  
---@type boolean
Body.buildable = {}

---**Get**:
---Returns the center of mass world position of a body.  
---@type Vec3
Body.centerOfMassPosition = {}

---**Get**:
---Check if a body is connectable  
---**Set**:
---*Server only*  
---Controls whether a body is connectable  
---@type boolean
Body.connectable = {}

---**Get**:
---Check if a body is convertible to dynamic form  
---**Set**:
---*Server only*  
---Controls whether a body is convertible to dynamic form  
---@type boolean
Body.convertableToDynamic = {}

---**Get**:
---Check if a body is destructable.  
---**Set**:
---*Server only*  
---Controls whether a body is destructable  
---@type boolean
Body.destructable = {}

---**Get**:
---Check if a body is erasable.  
---**Set**:
---*Server only*  
---Controls whether a body is erasable  
---@type boolean
Body.erasable = {}

---**Get**:
---Returns the id of a body.  
---@type integer
Body.id = {}

---**Get**:
---Check if a body is liftable  
---**Set**:
---*Server only*  
---Controls whether a body is liftable  
---@type boolean
Body.liftable = {}

---**Get**:
---Returns the mass of a body.  
---@type number
Body.mass = {}

---**Get**:
---Check if a body is paintable  
---**Set**:
---*Server only*  
---Controls whether a body is non paintable  
---@type boolean
Body.paintable = {}

---**Get**:
---Check if a body is interactable  
---**Set**:
---*Server only*  
---Controls whether a body is interactable  
---@type boolean
Body.usable = {}

---**Get**:
---Returns the linear velocity of a body.  
---@type Vec3
Body.velocity = {}

---**Get**:
---Returns the world position of a body.  
---@type Vec3
Body.worldPosition = {}

---**Get**:
---Returns the world rotation of a body.  
---@type Quat
Body.worldRotation = {}

---*Server only*  
---Create a block on body  
---@param uuid Uuid The uuid of the shape.
---@param size Vec3 The shape's size.
---@param position Vec3 The shape's local position.
---@param forceAccept? boolean Set true to force the body to accept the shape. (Defaults to true)
---@return Shape shape
function Body:createBlock(uuid, size, position, forceAccept) end

---*Server only*  
---Create a part on body  
---@param uuid Uuid The uuid of the shape.
---@param position Vec3 The shape's local position.
---@param z_axis Vec3 The shape's local z direction.
---@param x_axis Vec3 The shape's local x direction.
---@param forceAccept? boolean Set true to force the body to accept the shape. (Defaults to true)
---@return Shape shape
function Body:createPart(uuid, position, z_axis, x_axis, forceAccept) end

---*Server only*  
---Creates a wedge attached to a body. The wedge is oriented with one   
---cathetus along the Y-axis and the other along the Z-axis, forming a right angle. The wedge's   
---rotation is controlled by z-axis and x-axis parameters, similar to standard part rotation.  
---@param uuid Uuid The uuid of the shape.
---@param size Vec3 The shape's size.
---@param position Vec3 The shape's local position.
---@param z_axis Vec3 The shape's local z direction.
---@param x_axis Vec3 The shape's local x direction.
---@param forceAccept? boolean Set true to force the body to accept the shape. (Defaults to true)
---@return Shape wedge The created wedge
function Body:createWedge(uuid, size, position, z_axis, x_axis, forceAccept) end

---*Server only*  
---Returns a table with all characters seated in this body  
---@return Character[]
function Body:getAllSeatedCharacter() end

---Returns the angular velocity of a body.  
---@return Vec3
function Body:getAngularVelocity() end

---Returns the center of mass world position of a body.  
---@return Vec3
function Body:getCenterOfMassPosition() end

---Returns a table of all bodies in a creation.  
---A creation includes all bodies connected by [Joint, joints], etc.  
---@return Body[]
function Body:getCreationBodies() end

---*Server only*  
---Returns the id of the creation  
---@return integer
function Body:getCreationId() end

---Returns a table of all [Joint, joints] that are part of a creation.  
---A creation includes all bodies connected by [Joint, joints], etc.  
---@return Joint[]
function Body:getCreationJoints() end

---Returns a table of all [Shape, shapes] that are part of a creation.  
---A creation includes all bodies connected by [Joint, joints], etc.  
---@return Shape[]
function Body:getCreationShapes() end

---Returns the id of a body.  
---@return integer
function Body:getId() end

---Returns a table of all [Interactable, interactables] that are part of a body.  
---This will <strong>not</strong> return interactables in neighbouring bodies connected by [Joint, joints], etc.  
---@return Interactable[]
function Body:getInteractables() end

---Returns a table of all [Joint, joints] that are part of a body.  
---This will <strong>not</strong> return joints in neighbouring bodies.  
---@return Joint[]
function Body:getJoints() end

---Get the local aabb of the body.  
---@return Vec3,Vec3
function Body:getLocalAabb() end

---Returns the mass of a body.  
---@return number
function Body:getMass() end

---Returns a table of all [Shape, shapes] that are part of a body.  
---This will <strong>not</strong> return shapes in neighbouring bodies connected by [Joint, joints], etc.  
---@return Shape[]
function Body:getShapes() end

---Returns the linear velocity of a body.  
---@return Vec3
function Body:getVelocity() end

---Returns the world a body exists in.  
---@return World
function Body:getWorld() end

---Get the world aabb of the body.  
---@return Vec3,Vec3
function Body:getWorldAabb() end

---Returns the world position of a body.  
---@return Vec3
function Body:getWorldPosition() end

---Returns true if the given tick is lower than the tick the body was last changed.  
---@param tick integer The tick.
---@return boolean
function Body:hasChanged(tick) end

---Check if a body is buildable  
---@return boolean
function Body:isBuildable() end

---Check if a body is connectable  
---@return boolean
function Body:isConnectable() end

---Check if a body is convertible to dynamic form  
---@return boolean
function Body:isConvertibleToDynamic() end

---Check if a body is destructable.  
---@return boolean
function Body:isDestructable() end

---Check if a body is dynamic  
---@return boolean
function Body:isDynamic() end

---Check if a body is erasable.  
---@return boolean
function Body:isErasable() end

---Check if a body is liftable  
---@return boolean
function Body:isLiftable() end

---Check if a body is on a lift  
---@return boolean
function Body:isOnLift() end

---Check if a body is paintable  
---@return boolean
function Body:isPaintable() end

---Check if a body is static  
---@return boolean
function Body:isStatic() end

---Check if a body is interactable  
---@return boolean
function Body:isUsable() end

---*Server only*  
---Controls whether a body is buildable  
---@param value boolean Whether the body is buildable.
function Body:setBuildable(value) end

---*Server only*  
---Controls whether a body is connectable  
---@param value boolean Whether the body is connectable.
function Body:setConnectable(value) end

---*Server only*  
---Controls whether a body is convertible to dynamic form  
---@param value boolean Whether the body is convertible to dynamic form.
function Body:setConvertibleToDynamic(value) end

---*Server only*  
---Controls whether a body is destructable  
---@param value boolean Whether the body is destructable.
function Body:setDestructable(value) end

---*Server only*  
---Controls whether a body is erasable  
---@param value boolean Whether the body is erasable.
function Body:setErasable(value) end

---*Server only*  
---Controls whether a body is liftable  
---@param value boolean Whether the body is liftable.
function Body:setLiftable(value) end

---*Server only*  
---Controls whether a body is non paintable  
---@param value boolean Whether the body is paintable.
function Body:setPaintable(value) end

---*Server only*  
---Controls whether a body is interactable  
---@param value boolean Whether the body is interactable.
function Body:setUsable(value) end

---Transforms a point from local space to world space.  
---@param point Vec3 The point in local space.
---@return Vec3
function Body:transformPoint(point) end


---@class Interactable
---A userdata object representing an <strong>interactable shape</strong> in the game.  
local Interactable = {}

---**Get**:
---Returns the logic output signal of an interactable. Signal is a boolean, <strong>on</strong> or <strong>off</strong>.  
---**Set**:
---*Server only*  
---Sets the logic output signal of an interactable. Signal is a boolean, <strong>on</strong> or <strong>off</strong>.  
---@type boolean
Interactable.active = {}

---**Get**:
---Returns the [Body] an interactable's [Shape] is part of.  
---@type Body
Interactable.body = {}

---**Get**:
---Returns the id of an interactable.  
---@type integer
Interactable.id = {}

---**Get**:
---Returns the power output signal of an interactable. Signal is a number between -1 to 1, where 1 is forward and -1 backward.  
---**Set**:
---*Server only*  
---Sets the power output signal of an interactable. Signal is a number between -1 to 1, where 1 is forward and -1 backward.  
---@type number
Interactable.power = {}

---**Get**:
---*Server only*  
---Returns (server) public data from a interactable.  
---**Set**:
---*Server only*  
---Sets (server) public data on a interactable.  
---@type table
Interactable.publicData = {}

---**Get**:
---Returns the [Shape] of an interactable.  
---@type Shape
Interactable.shape = {}

---**Get**:
---Returns the interactable type of an interactable.  
---@type string
Interactable.type = {}

---*Server only*  
---Creates and stores a container in the given index inside the controller  
---@param index integer The index of the container [0-15].
---@param size integer The number of slots in the container.
---@param stackSize? integer The stack size. Defaults to maximum possible stack size(65535).
---@return Container
function Interactable:addContainer(index, size, stackSize) end

---*Server only*  
---Connects two interactables. Similar to using the Connect Tool.  
---@param child Interactable The receiver of a connection.
---@return boolean
function Interactable:connect(child) end

---*Server only*  
---Connects interactable with joint.  
---@param child Joint The receiver of a connection.
function Interactable:connectToJoint(child) end

---*Server only*  
---Disconnects two interactables. Similar to using the Connect Tool.  
---@param child Interactable The receiver of a connection.
---@return boolean
function Interactable:disconnect(child) end

---*Client only*  
---Returns animation duration in seconds.  
---@param name string The name of the animation.
---@return number
function Interactable:getAnimDuration(name) end

---Returns a table of [Joint, bearings] that an interactable is connected to.  
---@return Joint[]
function Interactable:getBearings() end

---Returns the [Body] an interactable's [Shape] is part of.  
---@return Body
function Interactable:getBody() end

---Returns a table of child [Interactable, interactables] that an interactable is connected to. The children listen to the interactable's output.  
---@param flags? integer Connection type flags filter. (defaults to all types except for sm.interactable.connectionType.bearing (for backwards compability))
---@return Interactable[]|Joint[]
function Interactable:getChildren(flags) end

---Returns the connection-point highlight color of an interactable. The point is shown when using the <em>Connect Tool</em>.  
---@return Color
function Interactable:getColorHighlight() end

---Returns the connection-point color of an interactable. The point is shown when using the <em>Connect Tool</em>.  
---@return Color
function Interactable:getColorNormal() end

---Returns the input connection type.  
---@return integer
function Interactable:getConnectionInputType() end

---Returns the output connection type.  
---@return integer
function Interactable:getConnectionOutputType() end

---Returns the container stored in the given index inside the controller  
---@param index? integer The index of the container (default: 0).
---@return Container
function Interactable:getContainer(index) end

---*Client only*  
---Gets the glow multiplier.  
---@return number
function Interactable:getGlowMultiplier() end

---Returns the id of an interactable.  
---@return integer
function Interactable:getId() end

---Returns a table of all [Joint, joints] that an interactable is connected to. Joints include <strong>bearings</strong> and <strong>pistons</strong>.  
---@return Joint[]
function Interactable:getJoints() end

---Return the position of the bone  
---@param name string The bone name.
---@return Vec3
function Interactable:getLocalBonePosition(name) end

---Returns the maximum number of allowed child connections of an interactable &ndash; the number of outgoing connections.  
---@return integer
function Interactable:getMaxChildCount() end

---Returns the maximum number of allowed parent connections of an interactable &ndash; the number of incoming connections.  
---@return integer
function Interactable:getMaxParentCount() end

---Returns a table of parent [Interactable, interactables] that are connected to an interactable. The parents act as the interactable's input.  
---@param flags? integer Connection type flags filter. (default to all types)
---@return Interactable[]
function Interactable:getParents(flags) end

---Returns a table of [Joint, pistons] that an interactable is connected to.  
---@return Joint[]
function Interactable:getPistons() end

---*Client only*  
---Returns the pose weight of the pose in the given index.  
---@param index integer The index.
---@return number
function Interactable:getPoseWeight(index) end

---Returns the power output signal of an interactable. Signal is a number between -1 to 1, where 1 is forward and -1 backward.  
---@return number
function Interactable:getPower() end

---*Server only*  
---Returns (server) public data from a interactable.  
---@return table
function Interactable:getPublicData() end

---Returns the [Character] that is seated in the [Interactable].  
---@return Character
function Interactable:getSeatCharacter() end

---Retrieves the list of [Interactable] connected to the seat.  
---@return Interactable[]
function Interactable:getSeatInteractables() end

---Returns the [Shape] of an interactable.  
---@return Shape
function Interactable:getShape() end

---Returns the parent [Interactable] that is connected to an interactable. The parent act as the interactable's input.  
---**Warning:**
---*This method is <strong>not</strong> allowed for an interactable that allows more than one parent connection.*
---@return Interactable
function Interactable:getSingleParent() end

---Returns the steering direction of a seat. (A = -1, D = 1)
---@return number
function Interactable:getSteeringAngle() end

---Returns the left angle limit of a [Joint] connected to a steering [Interactable].  
---@param joint Joint The joint.
---@return number
function Interactable:getSteeringJointLeftAngleLimit(joint) end

---Returns the left angle speed of a [Joint] connected to a steering [Interactable].  
---@param joint Joint The joint.
---@return number
function Interactable:getSteeringJointLeftAngleSpeed(joint) end

---Returns the right angle limit of a [Joint] connected to a steering [Interactable].  
---@param joint Joint The joint.
---@return number
function Interactable:getSteeringJointRightAngleLimit(joint) end

---Returns the right angle speed of a [Joint] connected to a steering [Interactable].  
---@param joint Joint The joint.
---@return number
function Interactable:getSteeringJointRightAngleSpeed(joint) end

---Returns the settings of a [Joint] connected to a steering [Interactable].  
---@param joint Joint The joint.
---@return number,number,number,number,boolean
function Interactable:getSteeringJointSettings(joint) end

---Returns the unlocked state of a [Joint] connected to a steering [Interactable].  
---@param joint Joint The joint.
---@return boolean
function Interactable:getSteeringJointUnlocked(joint) end

---Returns the throttle direction of a seat. (W = 1, S = -1)
---@return number
function Interactable:getSteeringPower() end

---Returns the interactable type of an interactable.  
---@return string
function Interactable:getType() end

---*Client only*  
---Returns the index of the current UV animation frame  
---@return integer
function Interactable:getUvFrameIndex() end

---Return the position of the bone  
---@param name string The bone name.
---@return Vec3
function Interactable:getWorldBonePosition(name) end

---*Client only*  
---Checks if an animation exists.  
---@param name string The name of the animation.
---@return boolean
function Interactable:hasAnim(name) end

---Returns true if the [Interactable] has the output type.  
---@param flags integer The output type.
---@return boolean
function Interactable:hasOutputType(flags) end

---Returns true if [Interactable] has a seat component.  
---@return boolean
function Interactable:hasSeat() end

---Returns true if [Interactable] has a steering component.  
---@return boolean
function Interactable:hasSteering() end

---Returns the logic output signal of an interactable. Signal is a boolean, <strong>on</strong> or <strong>off</strong>.  
---@return boolean
function Interactable:isActive() end

---Triggers a press interaction on a [Interactable] connected to the seat.  
---@param index integer The index of the interactable to press.
---@return boolean
function Interactable:pressSeatInteractable(index) end

---Triggers a release interaction on a [Interactable] connected to the seat.  
---@param index integer The index of the interactable to release.
---@return boolean
function Interactable:releaseSeatInteractable(index) end

---*Server only*  
---Removes the container stored in the given index inside the controller  
---@param index integer The index of the container.
function Interactable:removeContainer(index) end

---*Server only*  
---Sets the logic output signal of an interactable. Signal is a boolean, <strong>on</strong> or <strong>off</strong>.  
---@param signal boolean The logic output signal.
function Interactable:setActive(signal) end

---*Client only*  
---Sets whether the animation with the given name should be applied to the mesh. True enables the animation and false disables it.  
---@param name string The name of the animation.
---@param enabled boolean The boolean enable state.
function Interactable:setAnimEnabled(name, enabled) end

---*Client only*  
---Sets the progress on the animation with the given name.  
---@param name string The name of the animation.
---@param progress number The animation's progress between 0 and 1.
function Interactable:setAnimProgress(name, progress) end

---*Client only*  
---Sets a value to multiply the glow from asg texture with.  
---@param value number The glow multiplier (0.0 - 1.0).
function Interactable:setGlowMultiplier(value) end

---*Client only*  
---Set the direction of the gyro  
---@param direction Vec3 The gyro direction.
function Interactable:setGyroDirection(direction) end

---Sets param data for a script interactable  
---@param data any The param data.
function Interactable:setParams(data) end

---*Client only*  
---Set the pose weight of the pose in the given index.  
---@param index integer The index.
---@param value number The pose weight.
function Interactable:setPoseWeight(index, value) end

---*Server only*  
---Sets the power output signal of an interactable. Signal is a number between -1 to 1, where 1 is forward and -1 backward.  
---@param signal number The power output signal.
function Interactable:setPower(signal) end

---*Server only*  
---Sets (server) public data on a interactable.  
---@param data table The public data.
function Interactable:setPublicData(data) end

---Requests to seat a [Character] in the [Interactable].  
---@param character Character The character.
function Interactable:setSeatCharacter(character) end

---Set the steering flag for a steering interactable.  
---@param steering integer flags	The steering flags.
function Interactable:setSteeringFlag(steering) end

---*Client only*  
---Sets the left angle limit settings of a [Joint] connected to a steering [Interactable].  
---@param joint Joint The joint.
---@param value number The left angle limit.
function Interactable:setSteeringJointLeftAngleLimit(joint, value) end

---*Client only*  
---Sets the left angle speed settings of a [Joint] connected to a steering [Interactable].  
---@param joint Joint The joint.
---@param value number The left angle speed.
function Interactable:setSteeringJointLeftAngleSpeed(joint, value) end

---*Client only*  
---Sets the right angle limit settings of a [Joint] connected to a steering [Interactable].  
---@param joint Joint The joint.
---@param value number The right angle limit.
function Interactable:setSteeringJointRightAngleLimit(joint, value) end

---*Client only*  
---Sets the right angle speed settings of a [Joint] connected to a steering [Interactable].  
---@param joint Joint The joint.
---@param value number The right angle speed.
function Interactable:setSteeringJointRightAngleSpeed(joint, value) end

---*Client only*  
---Sets the settings of a [Joint] connected to a steering [Interactable].  
---@param joint Joint The joint.
---@param left number angle speed	The left angle speed.
---@param right number angle speed	The right angle speed.
---@param left number angle limit	The left angle limit.
---@param right number angle limit	The right angle limit.
---@param unlocked boolean Returns true if the joint is unlocked.
function Interactable:setSteeringJointSettings(joint, left, right, left, right, unlocked) end

---*Client only*  
---Sets unlocked settings of a [Joint] connected to a steering [Interactable].  
---@param joint Joint The joint.
---@param value boolean true if joint is unlocked
function Interactable:setSteeringJointUnlocked(joint, value) end

---*Client only*  
---Set the visibility of a submesh  
---@param name string Name of the submesh.
---@param visible boolean True if the submesh should be visible.
function Interactable:setSubMeshVisible(name, visible) end

---*Client only*  
---Sets the UV animation frame with the given index.  
---@param index integer The index.
function Interactable:setUvFrameIndex(index) end

---Unset the steering flag for a steering interactable.  
---@param steering integer flags	The steering flags.
function Interactable:unsetSteeringFlag(steering) end


---@class Joint
---A userdata object representing a <strong>joint</strong> in the game.  
local Joint = {}

---**Get**:
---Returns the angle of a bearing.  
---@type number
Joint.angle = {}

---**Get**:
---Returns the angular velocity of a bearing.  
---The angular velocity can be set using [Joint.setMotorVelocity, setMotorVelocity] or [Joint.setTargetAngle, setTargetAngle].  
---@type number
Joint.angularVelocity = {}

---**Get**:
---Returns the applied impulse of a bearing.  
---The applied impulse can be set using [Joint.setMotorVelocity, setMotorVelocity] or [Joint.setTargetAngle, setTargetAngle].  
---@type number
Joint.appliedImpulse = {}

---**Get**:
---Returns the color of a joint.  
---@type Color
Joint.color = {}

---**Get**:
---Returns the id of a joint.  
---@type integer
Joint.id = {}

---**Get**:
---Returns the current length of a piston. The length is measured in blocks.  
---@type number
Joint.length = {}

---**Get**:
---Returns the local position of a joint.  
---@type Vec3
Joint.localPosition = {}

---**Get**:
---Returns the local rotation of a joint.  
---@type Quat
Joint.localRotation = {}

---**Get**:
---Returns whether a bearing has been reversed using the <em>Connect Tool</em>. A reversed bearing rotates counterclockwise.  
---@type boolean
Joint.reversed = {}

---**Get**:
---Returns the [Shape] a joint is attached to. This shape does always exist.  
---@type Shape
Joint.shapeA = {}

---**Get**:
---Returns the [Shape] that is attached to a joint on another [Body]. This method returns nil if there is no shape attached to the joint.  
---@type Shape
Joint.shapeB = {}

---**Get**:
---Returns the joint type of a joint.  
---@type string
Joint.type = {}

---**Get**:
---Returns the uuid string unique to a joint type.  
---@type Uuid
Joint.uuid = {}

---**Get**:
---Returns the world position of a joint.  
---@type Vec3
Joint.worldPosition = {}

---**Get**:
---Returns the local x-axis vector of a joint.  
---@type Vec3
Joint.xAxis = {}

---**Get**:
---Returns the local y-axis vector of a joint.  
---@type Vec3
Joint.yAxis = {}

---**Get**:
---Returns the local z-axis vector of a joint.  
---@type Vec3
Joint.zAxis = {}

---*Server only*  
---Create a block on joint.  
---@param uuid Uuid The uuid of the shape.
---@param size Vec3 The shape's size.
---@param position Vec3 The shape's local position.
---@param forceCreate? boolean Set true to force create the shape.
function Joint:createBlock(uuid, size, position, forceCreate) end

---*Server only*  
---Create a part on joint.  
---@param uuid Uuid The uuid of the shape.
---@param position Vec3 The shape's local position.
---@param zAxis Vec3 The shape's local z direction.
---@param xAxis Vec3 The shape's local x direction.
---@param forceCreate? boolean Set true to force create the shape.
function Joint:createPart(uuid, position, zAxis, xAxis, forceCreate) end

---Returns the angle of a bearing.  
---@return number
function Joint:getAngle() end

---Returns the angular velocity of a bearing.  
---The angular velocity can be set using [Joint.setMotorVelocity, setMotorVelocity] or [Joint.setTargetAngle, setTargetAngle].  
---@return number
function Joint:getAngularVelocity() end

---Returns the applied impulse of a bearing.  
---The applied impulse can be set using [Joint.setMotorVelocity, setMotorVelocity] or [Joint.setTargetAngle, setTargetAngle].  
---@return number
function Joint:getAppliedImpulse() end

---Returns the bounding box of a joint &ndash; the dimensions that a joint occupies when building.  
---@return Vec3
function Joint:getBoundingBox() end

---Returns the color of a joint.  
---@return Color
function Joint:getColor() end

---Returns the id of a joint.  
---@return integer
function Joint:getId() end

---Returns the current length of a piston. The length is measured in blocks.  
---@return number
function Joint:getLength() end

---Returns the local position of a joint.  
---@return Vec3
function Joint:getLocalPosition() end

---Returns the local rotation of a joint.  
---@return Quat
function Joint:getLocalRotation() end

---Returns the [Shape] a joint is attached to. This shape does always exist.  
---@return Shape
function Joint:getShapeA() end

---Returns the [Shape] that is attached to a joint on another [Body]. This method returns nil if there is no shape attached to the joint.  
---@return Shape
function Joint:getShapeB() end

---Returns the uuid string unique to a joint type.  
---@return Uuid
function Joint:getShapeUuid() end

---Returns the sticky directions of the joint for positive xyz and negative xyz.  
---A value of 1 means that the direction is sticky and a value of 0 means that the direction is not sticky.  
---@return Vec3,Vec3
function Joint:getSticky() end

---Returns the joint type of a joint.  
---@return string
function Joint:getType() end

---Returns the world position of a joint.  
---@return Vec3
function Joint:getWorldPosition() end

---Returns the world rotation of a joint.  
---@return Quat
function Joint:getWorldRotation() end

---Returns the local x-axis vector of a joint.  
---@return Vec3
function Joint:getXAxis() end

---Returns the local y-axis vector of a joint.  
---@return Vec3
function Joint:getYAxis() end

---Returns the local z-axis vector of a joint.  
---@return Vec3
function Joint:getZAxis() end

---Returns whether a bearing has been reversed using the <em>Connect Tool</em>. A reversed bearing rotates counterclockwise.  
---@return boolean
function Joint:isReversed() end

---Sets the motor velocity for a bearing. The bearing will try to maintain the target velocity with the given amount of impulse/strength.  
---In Scrap Mechanic, the Gas Engine increases both velocity and impulse with every gear. The Electric Engine increases velocity, but maintains the same impulse for every gear, making it sturdier.  
---This method cancels the effects of [Joint.setTargetAngle, setTargetAngle].  
---@param targetVelocity number The target velocity.
---@param maxImpulse number The max impulse.
function Joint:setMotorVelocity(targetVelocity, maxImpulse) end

---Sets the target angle for a bearing. The bearing will try to reach the target angle with the target velocity and the given amount of impulse/strength.  
---The target angle is set to range between `-math.pi` and `+math.pi`. The bearing will always try to rotate in the direction closest to the target angle.  
---This method cancels the effects of [Joint.setMotorVelocity, setMotorVelocity].  
---@param targetAngle number The target angle.
---@param targetVelocity number The target velocity.
---@param maxImpulse number The max impulse.
function Joint:setTargetAngle(targetAngle, targetVelocity, maxImpulse) end

---*Server only*  
---Sets the target length for a piston. The piston will try to reach the target length with the target velocity and the given amount of impulse/strength.  
---The target length is measured in blocks.  
---This method cancels the effects of [Joint.setMotorVelocity, setMotorVelocity].  
---@param targetLength number The target length.
---@param targetVelocity number The target velocity.
---@param maxImpulse? number The max impulse. (Defaults to impulse used in game)
function Joint:setTargetLength(targetLength, targetVelocity, maxImpulse) end


---@class Network
---A userdata object representing a <strong>network</strong> object.  
---<strong>Network</strong> is used for sending data between scripts running on <a href="index.html#server">server</a> and <a href="index.html#client">client</a>. This allows the server to call a function on the client with optional arguments, and vice versa.  
---**Note:**
---*A network object is accessable via `self.network` in scripted shapes (see [ShapeClass]).*
---**Warning:**
---*Network allows any Lua data to be sent between the host and other players in real-time. This may result in <strong>high latency</strong> and lag in multiplayer.*
---*To avoid lag and minimize bandwidth usage, consider only sending data when necessary, when data has changed, and attempt to send as little amount of data as possible.*
local Network = {}

---*Server only*  
---Sends a network event from the server to a client. This will run the callback method on the client with optional arguments.  
---@param player Player The client player (or the host).
---@param callbackMethod string The client function name.
---@param args? any Optional arguments to be sent to the client.
function Network:sendToClient(player, callbackMethod, args) end

---*Server only*  
---Sends a network event from the server to all clients. This will run the callback method on every client with optional arguments.  
---```
----- Example of calling client function over network
---function MyHorn.server_onSledgehammer( self, position, player ) 
---	self.network:sendToClients( 'client_hit', position )
---end
--- 
---function MyHorn.client_hit( self, position ) 
---	-- Play sound
---	sm.audio.play( 'Horn', position )
---end
---```
---@param callbackMethod string The client function name.
---@param args? any Optional arguments to be sent to the client.
function Network:sendToClients(callbackMethod, args) end

---*Client only*  
---Sends a network event from the client to the server. This will run the callback method on the server with optional arguments.  
---```
----- Example of calling server function over network
---function MySwitch.client_onInteract( self ) 
---	self.network:sendToServer( 'server_toggle' )
---end
---
---function MySwitch.server_toggle( self ) 
---	-- Toggle on and off
---	self.interactable.active = not self.interactable.active
---end
---```
---@param callbackMethod string The server function name.
---@param args? any Optional arguments to be sent to the server.
function Network:sendToServer(callbackMethod, args) end

---*Server only*  
---Sets a lua object that will automatically be synchronized to clients.  
---Scripts which use this feature needs to implement 'client_onClientDataUpdate'.  
---'client_onClientDataUpdate' will be called on the client whenever the data has changed,  
---including setting the data for the first time.  
---Channel 1 will be received before channel 2 if both are updated.  
---```
----- Example:
---function MyEngine.server_onCreate( self )
---	self.network:setClientData( { gear = 1 } )
---end
--- 
---function MyEngine.client_onClientDataUpdate( self, data )
---	self.interactable:setPoseWeight( 0, data.gear / self.maxGears )
---end
---```
---@param data any Persistent data to be synchronized with existing and new clients.
---@param channel? integer Client data channel, 1 or 2 (Optional)
function Network:setClientData(data, channel) end


---@class Item
---@field uuid Uuid The UUID of the item.
---@field instance number The instance ID, if the item is a tool.
---@field quantity number The item amount.


---@class Container
---A userdata object representing a <strong>container</strong> in the game.  
local Container = {}

---**Get**:
---*Server only*  
---Returns whether the container can collect items.  
---**Set**:
---*Server only*  
---Sets whether the container can collect items.  
---@type boolean
Container.allowCollect = {}

---**Get**:
---*Server only*  
---Returns whether the container can spend items.  
---**Set**:
---*Server only*  
---Sets whether the container can spend items.  
---@type boolean
Container.allowSpend = {}

---**Get**:
---Returns the id of a container.  
---@type integer
Container.id = {}

---**Get**:
---Returns the number of slots in a container.  
---@type integer
Container.size = {}

---Checks if [sm.container.collect] is allowed using the same parameters.  
---@param itemUuid Uuid The uuid of the item.
---@param quantity integer The number of items.
---@return boolean
function Container:canCollect(itemUuid, quantity) end

---Checks if [sm.container.spend] is allowed.  
---@param itemUuid Uuid The uuid of the item.
---@param quantity integer The number of items.
---@return boolean
function Container:canSpend(itemUuid, quantity) end

---*Server only*  
---Returns whether the container can collect items.  
---@return boolean
function Container:getAllowCollect() end

---*Server only*  
---Returns whether the container can spend items.  
---@return boolean
function Container:getAllowSpend() end

---Returns a table containing item uuid, quantity (and instance id for tools) at given slot.  
---@param slot integer The slot.
---@return Item
function Container:getItem(slot) end

---Returns the max stack size in the container.  
---@return integer
function Container:getMaxStackSize() end

---Returns the number of slots in a container.  
---@return integer
function Container:getSize() end

---*Server only*  
---Returns true if the given tick is lower than the tick the container was last changed.  
---@param tick integer The tick.
---@return boolean
function Container:hasChanged(tick) end

---Returns true if the container is empty.  
---@return boolean
function Container:isEmpty() end

---*Server only*  
---Sets whether the container can collect items.  
---@param allow boolean True if the container can collect.
function Container:setAllowCollect(allow) end

---*Server only*  
---Sets whether the container can spend items.  
---@param allow boolean True if the container can spend.
function Container:setAllowSpend(allow) end

---*Server only*  
---Set item filter.  
---@param filter Uuid[] A table of the item uuid's {[Uuid], ...} allowed to be stored in the container.
function Container:setFilters(filter) end

---*Server only*  
---Sets the number of items stacked in a given container slot.  
---@param slot integer The slot.
---@param itemUuid Uuid The uuid of the item.
---@param quantity integer The number of items.
---@param instance? integer The instance id, if the item is a tool. (Optional)
---@return boolean
function Container:setItem(slot, itemUuid, quantity, instance) end


---@class AnimationInfo
---@field looping boolean
---@field name string
---@field duration number


---@class Character
---A userdata object representing a <strong>character</strong> in the game.  
local Character = {}

---**Get**:
---*Client only*  
---Returns client public data from a character.  
---**Set**:
---*Client only*  
---Sets client public data on a character.  
---@type table
Character.clientPublicData = {}

---**Get**:
---Returns the base color of a character.  
---**Set**:
---*Server only*  
---Sets the character color.  
---@type Color
Character.color = {}

---**Get**:
---Returns the direction of where a character is viewing or aiming.  
---@type Vec3
Character.direction = {}

---**Get**:
---Returns the smoothed direction of where a character is viewing or aiming.  
---@type Vec3
Character.smoothDirection = {}

---**Get**:
---Returns the id of a character.  
---@type integer
Character.id = {}

---**Get**:
---Returns the mass of a character.  
---@type number
Character.mass = {}

---**Get**:
---Gets the current fraction multiplier applied on the character's movement speed.  
---**Set**:
---Sets a fraction multiplier to the character's movement speed.  
---@type number
Character.movementSpeedFraction = {}

---**Get**:
---*Server only*  
---Returns (server) public data from a character.  
---**Set**:
---*Server only*  
---Sets (server) public data on a character.  
---@type table
Character.publicData = {}

---**Get**:
---Returns the velocity of a character.  
---@type Vec3
Character.velocity = {}

---**Get**:
---Returns the world position of a character.  
---@type Vec3
Character.worldPosition = {}

---*Client only*  
---Adds a renderable (file containing model data) to be used for the character in third person view.  
---@param renderable string The renderable path.
function Character:addRenderable(renderable) end

---Applies impulse to the characters tumbling shape.  
---@param impulse Vec3 The impulse.
function Character:applyTumblingImpulse(impulse) end

---Binds a character's animation to a callback function.  
---@param animationName string The name of the animation.
---@param triggerTime number The required time that will have elapsed in the animation when the callback is triggered.
---@param callback string The name of the Lua function to bind.
function Character:bindAnimationCallback(animationName, triggerTime, callback) end

---@class ActiveAnimationInfo
---@field name string
---@field weight number

---Returns the set of active animations.  
---@return ActiveAnimationInfo[]
function Character:getActiveAnimations() end

---*Client only*  
---@param name string The name.
---@return AnimationInfo
function Character:getAnimationInfo(name) end

---Returns whether the character will float or sink in liquid.  
---@return boolean
function Character:getCanSwim() end

---Returns the uuid of the character.  
---@return Uuid
function Character:getCharacterType() end

---*Client only*  
---Returns client public data from a character.  
---@return table
function Character:getClientPublicData() end

---Returns the base color of a character.  
---@return Color
function Character:getColor() end

---Returns the radius around the character where it can be heard.  
---@return number
function Character:getCurrentMovementNoiseRadius() end

---Returns the current movement speed of the character depending on state and multiplier.  
---@return number
function Character:getCurrentMovementSpeed() end

---Returns the direction of where a character is viewing or aiming.  
---@return Vec3
function Character:getDirection() end

---*Client only*  
---Gets the glow multiplier.  
---@return number
function Character:getGlowMultiplier() end

---Returns the height of a character  
---@return number
function Character:getHeight() end

---Returns the id of a character.  
---@return integer
function Character:getId() end

---Get the [Interactable] that the [Character] is locked to.  
---@return Interactable
function Character:getLockingInteractable() end

---Returns the mass of a character.  
---@return number
function Character:getMass() end

---Gets the current fraction multiplier applied on the character's movement speed.  
---@return number
function Character:getMovementSpeedFraction() end

---Returns the player controlling the character.  
---@return Player
function Character:getPlayer() end

---*Server only*  
---Returns (server) public data from a character.  
---@return table
function Character:getPublicData() end

---Returns the radius of a character  
---@return number
function Character:getRadius() end

---Returns the normal of the character's contact with a surface. Defaults to a zero vector when no contact is found.  
---@return Vec3
function Character:getSurfaceNormal() end

---Returns the world position for a bone in the third person view animation skeleton.  
---@param jointName string The joint name.
---@return Vec3
function Character:getTpBonePos(jointName) end

---Returns the world rotation for a bone in the third person view animation skeleton.  
---@param jointName string The joint name.
---@return Quat
function Character:getTpBoneRot(jointName) end

---Returns the extent of the characters tumbeling shape.  
---@return Vec3
function Character:getTumblingExtent() end

---Returns the linear velocity of the characters tumbling shape.  
---@return Vec3
function Character:getTumblingLinearVelocity() end

---Returns the world position of the characters tumbeling shape.  
---@return Vec3
function Character:getTumblingWorldPosition() end

---Returns the world rotation of the characters tumbeling shape.  
---@return Quat
function Character:getTumblingWorldRotation() end

---Returns the unit controlling the character.  
---@return Unit
function Character:getUnit() end

---Returns the velocity of a character.  
---@return Vec3
function Character:getVelocity() end

---Returns the world a character exists in.  
---@return World
function Character:getWorld() end

---Returns the world position of a character.  
---@return Vec3
function Character:getWorldPosition() end

---Returns whether a character is currently aiming with a weapon.  
---@return boolean
function Character:isAiming() end

---Get the character climbing state.  
function Character:isClimbing() end

---Returns whether a character is currently crouching.  
---@return boolean
function Character:isCrouching() end

---Returns true if the current character color is its default color.  
---@return boolean
function Character:isDefaultColor() end

---Get the character diving state.  
function Character:isDiving() end

---Get the character downed state.
function Character:isDowned() end

---Returns whether the character is currently standing on the ground.  
---@return boolean
function Character:isOnGround() end

---Returns whether a character is owned by a player.  
---@return boolean
function Character:isPlayer() end

---Returns whether a character is currently sprinting.  
---@return boolean
function Character:isSprinting() end

---Get the character swimming state.  
function Character:isSwimming() end

---Get the character tumbling state.
function Character:isTumbling() end

---Removes all of a character's animation callbacks.  
function Character:removeAnimationCallbacks() end

---*Client only*  
---Removes a renderable (file containing model data) that was used for the character in third person view.  
---@param renderable string The renderable path.
function Character:removeRenderable(renderable) end

---*Client only*  
---Enables or disables event animations.  
---When set to false no animations can play while tumble is active, and when set to true the animations will play while tumbling.  
---@param allow boolean The state.
function Character:setAllowTumbleAnimations(allow) end

---*Client only*  
---Sets client public data on a character.  
---@param data table The client public data.
function Character:setClientPublicData(data) end

---*Server only*  
---Sets whether the character is climbing.  
---@param state boolean The state.
function Character:setClimbing(state) end

---*Server only*  
---Sets the character color.  
---@param color Color The character color.
function Character:setColor(color) end

---*Server only*  
---Sets whether the character is diving.  
---@param state boolean The state.
function Character:setDiving(state) end

---*Server only*  
---Sets whether the character is downed.  
---@param state boolean The state.
function Character:setDowned(state) end

---*Client only*  
---Sets a value to multiply the glow from asg texture with.  
---@param value number The glow multiplier (0.0 - 1.0).
function Character:setGlowMultiplier(value) end

---Set the [Interactable] that the [Character] is locked to. Set [Interactable] to nil to unlock.  
---@param interactable Interactable? The interactable.
---@return boolean
function Character:setLockingInteractable(interactable) end

---Sets the movement effect set filepath.  
---@param Effect string set filepath		The effect set filepath.
function Character:setMovementEffects(Effect) end

---Sets a fraction multiplier to the character's movement speed.  
---@param fraction number The movement speed fraction.
function Character:setMovementSpeedFraction(fraction) end

---*Client only*  
---Sets the weights for movement animations on a character's upper and lower body.  
---For a value of 0 no movement animations will play, and for a value of 1 the movement animations will fully play unless otherwise overridden.  
---@param lower number The lower weight.
---@param upper number The upper weight.
function Character:setMovementWeights(lower, upper) end

---*Client only*  
---Sets the name tag display value for the character  
---@param name string The new name tag text value.
---@param color? Color The color of the name. (defaults to white)
---@param requiresLoS? boolean Whether broken line of sight will hide the name tag.
---@param renderDistance? number Max distance the name tag will render in.
---@param fadeDistance? number Distance where fade out will start.
function Character:setNameTag(name, color, requiresLoS, renderDistance, fadeDistance) end

---*Server only*  
---Sets (server) public data on a character.  
---@param data table The public data.
function Character:setPublicData(data) end

---*Server only*  
---Sets whether the character is swimming.  
---@param state boolean The state.
function Character:setSwimming(state) end

---*Server only*  
---Sets whether the character is tumbling.  
---@param state boolean The state.
function Character:setTumbling(state) end

---*Client only*  
---Sets the upward direction of the character's graphics.  
---@param up Vec3 The direction.
function Character:setUpDirection(up) end

---*Server only*  
---Sets the world position of a character.  
---@param WorldPosition Vec3 The character's new world position.
function Character:setWorldPosition(WorldPosition) end

---*Client only*  
---Updates a character animation.  
---@param name string The animation name.
---@param time number The time.
---@param weight? number The weight. Defaults to -1.0. (Optional)
---@param additive? boolean Whether the animation will be added to the default animation. Defaults to false. (Optional)
function Character:updateAnimation(name, time, weight, additive) end


---@class Player
---A userdata object representing a <strong>player</strong> in the game.  
local Player = {}

---**Get**:
---Returns the character the player is controlling.  
---@type Character
Player.character = {}

---**Get**:
---*Client only*  
---Returns client public data from a player.  
---**Set**:
---*Client only*  
---Sets client public data on a player.  
---@type table
Player.clientPublicData = {}

---**Get**:
---Returns the id of a player.  
---@type integer
Player.id = {}

---**Get**:
---Returns the name of a player.  
---@type string
Player.name = {}

---**Get**:
---*Server only*  
---Returns (server) public data from a player.  
---**Set**:
---*Server only*  
---Sets (server) public data on a player.  
---@type table
Player.publicData = {}

---Returns the carry container of the player.  
---@return Container
function Player:getCarry() end

---*Server only*  
---Returns the color of the shape the player is carrying.  
---@return Color
function Player:getCarryColor() end

---Returns the character the player is controlling.  
---@return Character
function Player:getCharacter() end

---*Client only*  
---Returns client public data from a player.  
---@return table
function Player:getClientPublicData() end

---Returns the hotbar container of the player.  
---@return Container
function Player:getHotbar() end

---Returns the id of a player.  
---@return integer
function Player:getId() end

---Returns the inventory container of the player.  
---@return Container
function Player:getInventory() end

---Returns the name of a player.  
---@return string
function Player:getName() end

---*Server only*  
---Returns (server) public data from a player.  
---@return table
function Player:getPublicData() end

---Check if the player is female  
---@return boolean
function Player:isFemale() end

---Check if the player is male  
---@return boolean
function Player:isMale() end

---*Server only*  
---Place down a lift game object  
---@param creation table The bodies to place on the lift. {[Body], ..}
---@param position Vec3 The lift position.
---@param level integer The lift level.
---@param rotation integer The rotation of the creation on the lift.
function Player:placeLift(creation, position, level, rotation) end

---*Server only*  
---Remove the player's lift, if the lift exists.  
function Player:removeLift() end

---*Server only*  
---Sends an event to a given player  
---@param event string The event to send
function Player:sendCharacterEvent(event) end

---*Server only*  
---Sets the character the player is controlling.  
---@param character? Character The character.
function Player:setCharacter(character) end

---*Client only*  
---Sets client public data on a player.  
---@param data table The client public data.
function Player:setClientPublicData(data) end

---*Server only*  
---Sets (server) public data on a player.  
---@param data table The public data.
function Player:setPublicData(data) end


---@class AreaTrigger
---A userdata object representing an <strong>area trigger</strong> in the game.  
local AreaTrigger = {}

---**Get**:
---Returns the id of an area trigger.  
---@type integer
AreaTrigger.id = {}

---Binds an area trigger's onEnter event to a custom callback. The onEnter event is triggered when an object enters the trigger area.  
---The callback receives:  
--- - <strong>self</strong> (<em>table</em>) &ndash; The class instance.
--- - <strong>trigger</strong> (<em>[AreaTrigger]</em>) &ndash; The area trigger instance.
--- - <strong>results</strong> (<em>table</em>) &ndash; A table of [Character, characters] and/or [Body, bodies] and/or [Harvestable, harvestables] and/or [Lift, lifts] and/or [AreaTrigger, areaTriggers].
---```
---function MyClass.onEnter( self, trigger, results ) ...
---```
---@param callback string The name of the Lua function to bind.
---@param object? table The object that will receive the callback. (optional)
function AreaTrigger:bindOnEnter(callback, object) end

---Binds an area trigger's onExit event to a custom callback. The onExit event is triggered when an object leaves the trigger area.  
---The callback receives:  
--- - <strong>self</strong> (<em>table</em>) &ndash; The class instance.
--- - <strong>trigger</strong> (<em>[AreaTrigger]</em>) &ndash; The area trigger instance.
--- - <strong>results</strong> (<em>table</em>) &ndash; A table of [Character, characters] and/or [Body, bodies] and/or [Harvestable, harvestables] and/or [Lift, lifts] and/or [AreaTrigger, areaTriggers].
---```
---function MyClass.onExit( self, trigger, results ) ...
---```
---@param callback string The name of the Lua function to bind.
---@param object? table The object that will receive the callback. (optional)
function AreaTrigger:bindOnExit(callback, object) end

---Binds an area trigger's onProjectile event to a custom callback. The onProjectile event is triggered if a projectile collides with the trigger area  
---@param callback string The name of the Lua function to bind.
---@param object? table The object that will receive the callback. (optional)
function AreaTrigger:bindOnProjectile(callback, object) end

---Binds an area trigger's onStay event to a custom callback. The onStay event is triggered every tick as long as an object is staying inside of the trigger area.  
---The callback receives:  
--- - <strong>self</strong> (<em>table</em>) &ndash; The class instance.
--- - <strong>trigger</strong> (<em>[AreaTrigger]</em>) &ndash; The area trigger instance.
--- - <strong>results</strong> (<em>table</em>) &ndash; A table of [Character, characters] and/or [Body, bodies] and/or [Harvestable, harvestables] and/or [Lift, lifts] and/or [AreaTrigger, areaTriggers].
---```
---function MyClass.onStay( self, trigger, results ) ...
---```
---@param callback string The name of the Lua function to bind.
---@param object? table The object that will receive the callback. (optional)
function AreaTrigger:bindOnStay(callback, object) end

---Gets the contents of the area trigger.  
---Returns a table of [Character, characters] and/or [Body, bodies] and/or [Harvestable, harvestables] and/or [Lift, lifts] and/or [AreaTrigger, areaTriggers].  
---@return table
function AreaTrigger:getContents() end

---Returns the attached host [sm.interactable, interactable].  
---@return Interactable
function AreaTrigger:getHostInteractable() end

---Returns the id of an area trigger.  
---@return integer
function AreaTrigger:getId() end

---@class AreaTriggerShape
---@field shape Shape
---@field triggerWorldPosition Vec3
---@field triggerLocalPosition Vec3
---@field shapeWorldPosition Vec3
---@field shapeLocalPosition Vec3

---Gets the shapes inside the area trigger.
---@return AreaTriggerShape[]
function AreaTrigger:getShapes() end

---Returns the size of an area trigger.  
---@return Vec3
function AreaTrigger:getSize() end

---Returns the user data set on the area trigger.  
---@return table
function AreaTrigger:getUserData() end

---Returns the world max corner position of an area trigger.  
---@return Vec3
function AreaTrigger:getWorldMax() end

---Returns the world min corner position of an area trigger.  
---@return Vec3
function AreaTrigger:getWorldMin() end

---Returns the world position of an area trigger.  
---@return Vec3
function AreaTrigger:getWorldPosition() end

---Returns the world rotation of an area trigger.  
---@return Quat
function AreaTrigger:getWorldRotation() end

---Returns true if the [AreaTrigger] is in contact with destructable terrain.  
---@return boolean
function AreaTrigger:hasVoxelTerrainContact() end

---Shape detection is off by default. When set to true the area trigger can calculate which shapes are inside of the trigger  
---with a call to [AreaTrigger]: getShapes  
---@param detectShapes boolean Shape detection on or off.
function AreaTrigger:setShapeDetection(detectShapes) end

---Sets the new size of an area trigger.  
---@param size Vec3 The area trigger's new size.
function AreaTrigger:setSize(size) end

---Sets the new world position of an area trigger.  
---@param position Vec3 The area trigger's new world position.
function AreaTrigger:setWorldPosition(position) end

---Sets the new world rotation of an area trigger.  
---@param rotation Quat The area trigger's new world rotation.
function AreaTrigger:setWorldRotation(rotation) end


---@class World
---A userdata object representing a <strong>world</strong> in the game.  
local World = {}

---**Get**:
---Returns the id of a world.  
---@type integer
World.id = {}

---*Server only*  
---Destroys the given world. Can only be called from inside the Game script environment.  
function World:destroy() end

---Returns the id of a world.  
---@return integer
function World:getId() end

---Returns true if the world is an indoor world.  
---@return boolean
function World:isIndoor() end

---*Server only*  
---Load a cell for player. The cell will stay loaded until the player steps into the cell, or the cell is released with releaseCell (and no player is close enough to load the cell).  
---@param x integer Cell X position.
---@param y integer Cell Y Position.
---@param player? Player A player to load for the cell for.
---@param callback? string Lua function to call when cell is loaded. Callback parameters are ( world, x, y, player, params, handle )
---@param params? any Parameter object passed to the callback.
---@param ref? ref Script ref to callback object.
---@return integer
function World:loadCell(x, y, player, callback, params, ref) end

---Reload a cell. Callback result values, 0 means cell isnt active and wont be reloaded. 1 means success  
---@param x integer Cell X position.
---@param y integer Cell Y Position.
---@param callback? string Lua function to call when cell is reloaded. Callback parameters are ( world, x, y, result ) (Optional)
---@param ref? ref Script ref to callback object. (Optional)
function World:reloadCell(x, y, callback, ref) end

---Set data to pass on to the terrain generation script. If no data is set the terrain generation script receives the same data as the world script.  
---@param data any Any data, available to the terrain generation script as parameter 6 in the create callback.
function World:setTerrainScriptData(data) end

---*Server only*  
---Modify destructable terrain with a sphere shape  
---@param position Vec3 The world position of the sphere.
---@param radius number The radius of the sphere.
---@param strength? number The strength of the modification. (Optional)
function World:terrainSphereModification(position, radius, strength) end


---@class Portal
---A userdata object representing an <strong>portal</strong> in the game.  
local Portal = {}

---**Get**:
---*Server only*  
---Returns the id of a portal.  
---@type integer
Portal.id = {}

---*Server only*  
---Gets the contents of opening A  
---@return table
function Portal:getContentsA() end

---*Server only*  
---Gets the contents of opening B  
---@return table
function Portal:getContentsB() end

---*Server only*  
---Returns the id of a portal.  
---@return integer
function Portal:getId() end

---*Server only*  
---Returns the position of portal opening A.  
---@return Vec3
function Portal:getPositionA() end

---*Server only*  
---Returns the position of portal opening B.  
---@return Vec3
function Portal:getPositionB() end

---*Server only*  
---Returns the rotation of portal opening A.  
---@return Quat
function Portal:getRotationA() end

---*Server only*  
---Returns the rotation of portal opening B.  
---@return Quat
function Portal:getRotationB() end

---*Server only*  
---Returns the world of a portal opening A.  
---@return World
function Portal:getWorldA() end

---*Server only*  
---Returns the world of a portal opening B.  
---@return World
function Portal:getWorldB() end

---*Server only*  
---Checks if the portal has opening A.  
---@return boolean
function Portal:hasOpeningA() end

---*Server only*  
---Checks if the portal has opening B.  
---@return boolean
function Portal:hasOpeningB() end

---*Server only*  
---Sets the position of portal opening A.  
---The world will be the same as the object that calls this function.  
---@param position Vec3 The portal opening A position.
---@param rotation Quat The portal opening A rotation.
function Portal:setOpeningA(position, rotation) end

---*Server only*  
---Sets the position B of portal opening B.  
---The world will be the same as the object that calls this function.  
---@param position Vec3 The portal opening B position.
---@param rotation Quat The portal opening B rotation.
function Portal:setOpeningB(position, rotation) end

---*Server only*  
---Transfers objects inside A opening to B opening  
---@return boolean
function Portal:transferAToB() end

---*Server only*  
---Transfers objects inside B opening to A opening  
---@return boolean
function Portal:transferBToA() end


---@class Harvestable
---Represents a harvestable object in the game.  
local Harvestable = {}

---**Get**:
---*Client only*  
---Returns client public data from a harvestable.  
---**Set**:
---*Client only*  
---Sets client public data on a harvestable.  
---@type table
Harvestable.clientPublicData = {}

---**Get**:
---Returns the id of a harvestable.  
---@type integer
Harvestable.id = {}

---**Get**:
---Returns the initial world coordinates of a kinematic.  
---@type Vec3
Harvestable.initialPosition = {}

---**Get**:
---Returns the initial quaternion rotation of a harvestable.  
---@type Quat
Harvestable.initialRotation = {}

---**Get**:
---Returns the mass of a harvestable. The mass scales with the harvestable's scale.  
---@type number
Harvestable.mass = {}

---**Get**:
---Returns the material name of a harvestable.  
---@type string
Harvestable.material = {}

---**Get**:
---Returns the material id of a harvestable.  
---@type integer
Harvestable.materialId = {}

---**Get**:
---Returns the name of a harvestable.  
---@type string
Harvestable.name = {}

---**Get**:
---*Server only*  
---Returns (server) public data from a harvestable.  
---**Set**:
---*Server only*  
---Sets (server) public data on a harvestable.  
---@type table
Harvestable.publicData = {}

---**Get**:
---Returns the type of a harvestable.  
---@type string
Harvestable.type = {}

---**Get**:
---Returns the [Uuid] of the harvestable.  
---@type Uuid
Harvestable.uuid = {}

---**Get**:
---Returns the world coordinates of a harvestable.  
---@type Vec3
Harvestable.worldPosition = {}

---**Get**:
---Returns the quaternion rotation of a harvestable.  
---@type Quat
Harvestable.worldRotation = {}

---*Server only*  
---Destroys a harvestable.  
function Harvestable:destroy() end

---Returns the bounds of the harvestable shape.  
---@return Vec3,Vec3
function Harvestable:getAabb() end

---*Client only*  
---Returns client public data from a harvestable.  
---@return table
function Harvestable:getClientPublicData() end

---Returns the color of the harvestable.  
---@return Color
function Harvestable:getColor() end

---Get the script data from a harvestable.  
---@return table
function Harvestable:getData() end

---Returns the id of a harvestable.  
---@return integer
function Harvestable:getId() end

---Returns the mass of a harvestable. The mass scales with the harvestable's scale.  
---@return number
function Harvestable:getMass() end

---Returns the material name of a harvestable.  
---@return string
function Harvestable:getMaterial() end

---Returns the material id of a harvestable.  
---@return integer
function Harvestable:getMaterialId() end

---Returns the name of a harvestable.  
---@return string
function Harvestable:getName() end

---*Client only*  
---Returns the pose weight of the pose in the given index.  
---@param index integer The index.
---@return number
function Harvestable:getPoseWeight(index) end

---Returns the world coordinates of a harvestable.  
---@return Vec3
function Harvestable:getPosition() end

---*Server only*  
---Returns (server) public data from a harvestable.  
---@return table
function Harvestable:getPublicData() end

---Returns the quaternion rotation of a harvestable.  
---@return Quat
function Harvestable:getRotation() end

---Returns the scale of the harvestable.  
---@return Vec3
function Harvestable:getScale() end

---Returns the [Character] that is seated in the kinematic.  
---@return Character
function Harvestable:getSeatCharacter() end

---Returns the type of a harvestable.  
---@return string
function Harvestable:getType() end

---Returns the [Uuid] of the harvestable.  
---@return Uuid
function Harvestable:getUuid() end

---*Client only*  
---Returns the index of the current UV animation frame  
---@return integer
function Harvestable:getUvFrameIndex() end

---Returns the world a harvestable exists in.  
---@return World
function Harvestable:getWorld() end

---Returns true if kinematic has a seat component.  
---@return boolean
function Harvestable:hasSeat() end

---Check if a harvestable is kinematic  
---@return boolean
function Harvestable:isKinematic() end

---*Client only*  
---Sets client public data on a harvestable.  
---@param data table The client public data.
function Harvestable:setClientPublicData(data) end

---*Client only*  
---Sets the color of the harvestable.  
---@param color Color The color.
function Harvestable:setColor(color) end

---*Server only*  
---Sets param data for a harvestable.  
---@param data any The param data.
function Harvestable:setParams(data) end

---*Client only*  
---Set the pose weight of the pose in the given index.  
---@param index integer The index.
---@param value number The pose weight.
function Harvestable:setPoseWeight(index, value) end

---Set the world coordinates of a harvestable. Can only be used on kinematic harvestables.  
---Can be used on both the client and the server, but using it on the server only affects the host.
---@param position Vec3 The position.
function Harvestable:setPosition(position) end

---*Server only*  
---Sets (server) public data on a harvestable.  
---@param data table The public data.
function Harvestable:setPublicData(data) end

---Set the quaternion rotation of a harvestable. Can only be used on kinematic harvestables.  
---Can be used on both the client and the server, but using it on the server only affects the host.
---@param rotation Quat The rotation.
function Harvestable:setRotation(rotation) end

---Requests to seat a [Character] in the kinematic.  
---@param character Character The character.
function Harvestable:setSeatCharacter(character) end

---*Client only*  
---Sets the UV animation frame with the given index.  
---@param index integer The index.
function Harvestable:setUvFrameIndex(index) end


---@class Lift
---A userdata object representing a <strong>lift</strong> in the game.  
local Lift = {}

---**Get**:
---Returns the id of a lift.  
---@type integer
Lift.id = {}

---**Get**:
---Returns the level of a lift.  
---@type integer
Lift.level = {}

---**Get**:
---Returns the world position of a lift.  
---@type Vec3
Lift.worldPosition = {}

---*Server only*  
---Destroys a lift.  
function Lift:destroy() end

---Returns the id of a lift.  
---@return integer
function Lift:getId() end

---Returns the level of a lift.  
---@return integer
function Lift:getLevel() end

---Returns the world position of a lift.  
---@return Vec3
function Lift:getWorldPosition() end

---Returns whether there's a body on the lift.  
---@return boolean
function Lift:hasBodies() end


---@class ScriptableObject
---A userdata object representing a <strong>scriptable object</strong>.  
local ScriptableObject = {}

---**Get**:
---*Client only*  
---Returns client public data from a scriptableObject.  
---**Set**:
---*Client only*  
---Sets client public data on a scriptableObject.  
---@type table
ScriptableObject.clientPublicData = {}

---**Get**:
---Returns the id of a scriptable object.  
---@type number
ScriptableObject.id = {}

---**Get**:
---*Server only*  
---Returns (server) public data from a scriptableObject.  
---**Set**:
---*Server only*  
---Sets (server) public data on a scriptableObject.  
---@type table
ScriptableObject.publicData = {}

---**Get**:
---Returns the worldId of a scriptable object.  
---@type World
ScriptableObject.world = {}

---*Server only*  
---Destroys a scriptable Object.  
function ScriptableObject:destroy() end

---*Client only*  
---Returns client public data from a scriptableObject.  
---@return table
function ScriptableObject:getClientPublicData() end

---Returns the id of a scriptable object.  
---@return number
function ScriptableObject:getId() end

---*Server only*  
---Returns (server) public data from a scriptableObject.  
---@return table
function ScriptableObject:getPublicData() end

---Returns the worldId of a scriptable object.  
---@return World
function ScriptableObject:getWorld() end

---*Client only*  
---Sets client public data on a scriptableObject.  
---@param data table The client public data.
function ScriptableObject:setClientPublicData(data) end

---*Server only*  
---Sets (server) public data on a scriptableObject.  
---@param data table The public data.
function ScriptableObject:setPublicData(data) end


---@class BuilderGuide
---A userdata object representing a <strong>builder guide</strong>.  
local BuilderGuide = {}

---**Get**:
---Returns the id of a guide.  
---@type integer
BuilderGuide.id = {}

---Destroys a guide.  
function BuilderGuide:destroy() end

---Returns the stage index of a guide.  
---@return integer
function BuilderGuide:getCurrentStageIndex() end

---Returns the id of a guide.  
---@return integer
function BuilderGuide:getId() end

---Returns the completion status of a guide.  
---@return boolean
function BuilderGuide:isComplete() end

---Update the state of a guide. Should be called whenever the root [Shape] of the builder guide has changed.  
function BuilderGuide:update() end


---@class CullSphereGroup
---A userdata object representing a <strong>cull sphere group</strong>.  
local CullSphereGroup = {}

---**Get**:
---Returns the id of the sphere group.
---@type int
CullSphereGroup.id = {}

---Adds a sphere to the [CullSphereGroup], duplicate ids are ignored.  
---@param id int Sphere id.
---@param position Vec3 Sphere position.
---@param radius number Sphere radius.
function CullSphereGroup:addSphere(id, position, radius) end

---Returns the removed and added spheres since the last call to getDelta.  
---@param position Vec3 Position of the query shpere.
---@param innerRadius number Radius for inner query sphere.
---@param outerRadius number Radius for outer query sphere.
---@return table removed, table added
function CullSphereGroup:getDelta(position, innerRadius, outerRadius) end

---Returns all overlapping spheres.  
---@param position Vec3 Position for query sphere.
---@param radius number Radius for query sphere.
---@return table overlaps Ids of all overlapping spheres
function CullSphereGroup:getOverlaps(position, radius) end

---Removes all currently active spheres.  
---@return table removed Ids of all previously active spheres
function CullSphereGroup:leave() end

---Removes a sphere from the [CullSphereGroup].  
---@param id int Sphere id.
function CullSphereGroup:removeSphere(id) end


---@class Effect
---A userdata object representing an <strong>effect</strong>.  
local Effect = {}

---**Get**:
---Returns the id of an effect.  
---@type integer
Effect.id = {}

---*Client only*  
---Bind an lua callback to be triggerd by the effect.  
---The callback receives:  
--- - <strong>self</strong> (<em>table</em>) &ndash; The class instance.
--- - <strong>eventName </strong> (<em>string</em>) &ndash; The name of the event.
--- - <strong>params</strong> (<em>any</em>) &ndash; Parameter object passed to the callback.
---```
---function MyClass.onEffectEvent( self, eventName, params ) ...
---```
---@param callback string The name of the callback to bind.
---@param params? any Parameter object passed to the callback. (Optional)
---@param reference? table Table to recieve the callback. (Optional)
function Effect:bindEventCallback(methodName, params, reference) end

---*Client only*  
---Clear all lua effect callbacks.  
function Effect:clearEventCallbacks() end

---Stops and destroys the effect.  
function Effect:destroy() end

---*Client only*  
---Get the desired camera FOV.  
---Will return nil if the effect is not playing.  
---@return number
function Effect:getCameraFov() end

---*Client only*  
---Get the desired camera position.  
---Will return nil if the effect is not playing.  
---@return Vec3
function Effect:getCameraPosition() end

---*Client only*  
---Get the desired camera rotation.  
---Will return nil if the effect is not playing.  
---@return Quat
function Effect:getCameraRotation() end

---Returns the id of an effect.  
---@return integer
function Effect:getId() end

---*Client only*  
---Check if the effect has an active camera effect.  
---@return boolean
function Effect:hasActiveCamera() end

---*Client only*  
---Returns whether the effect is done, meaning that all effect instances have finished.  
---@return boolean
function Effect:isDone() end

---*Client only*  
---Returns whether the effect is currently playing.  
---@return boolean
function Effect:isPlaying() end

---*Client only*  
---Sets an effect to start playing and repeating automatically.  
---@param Autoplay boolean enabled.
function Effect:setAutoPlay(Autoplay) end

---*Client only*  
---The effect will:  
---* Start when your distance is less than the startDistance.  
---* End when your distance is over the stopDistance.  
---@param startDistance number Distance at which to start the effect. Must be < than stopDistance and over 0.
---@param stopDistance number Distance at which to stop the effect. Must be > than startDistance and over 0.
function Effect:setStartStopDistance(startDistance, stopDistance) end

---*Client only*  
---Offsets the position of the effect relatively to the host interactable.  
---**Note:**
---*Does not work if the effect was created without a host interactable.*
---@param offsetPosition Vec3 The relative offset position.
function Effect:setOffsetPosition(offsetPosition) end

---*Client only*  
---Offsets the orientation of the effect relatively to the host interactable.  
---**Note:**
---*Does not work if the effect was created without a host interactable.*
---@param offsetRotation Quat The relative offset rotation.
function Effect:setOffsetRotation(offsetRotation) end

---*Client only*  
---Sets a named parameter value on the effect.  
---@param name string The name.
---@param value any The effect parameter value.
function Effect:setParameter(name, value) end

---*Client only*  
---Sets the position of an effect.  
---**Note:**
---*Does not work if the effect was created with a host interactable.*
---@param position Vec3 The position.
function Effect:setPosition(position) end

---*Client only*  
---Sets the orientation of an effect using a quaternion.  
---**Note:**
---*Does not work if the effect was created with a host interactable.*
---@param rotation Quat The rotation.
function Effect:setRotation(rotation) end

---*Client only*  
---Sets the scale of an effect.  
---**Note:**
---*Only applies to effect renderables.*
---@param scale Vec3 The scale.
function Effect:setScale(scale) end

---*Client only*  
---Sets an effect to be active during specific period of the day / night cycle.  
---@param enabled boolean Time of day enabled.
---@param startTime number Start normalized time of day.
---@param endTime number End normalized time of day.
---@param inversed boolean If true, period between start-end becomes inactive time.
function Effect:setTimeOfDay(enabled, startTime, endTime, inversed) end

---*Client only*  
---Sets the velocity of an effect. The effect will move along at the set velocity until it receives a new position.  
---**Note:**
---*Does not work if the effect was created with a host interactable.*
---@param velocity Vec3 The velocity.
function Effect:setVelocity(velocity) end

---*Client only*  
---Sets the world for an effect.  
---@param world World The world. Defaults to world from script constext. (optional)
function Effect:setWorld(world) end

---*Client only*  
---Starts playing an effect.  
function Effect:start() end

---*Client only*  
---Stops playing an effect  
function Effect:stop() end

---*Client only*  
---Stops playing an effect, letting sound finish before destroying the effect.  
function Effect:stopBreakSustain() end

---*Client only*  
---Immediately stop playing an effect, sound effects ended immediately.  
function Effect:stopImmediate() end


---@class Storage
---A userdata object representing a <strong>storage</strong> object.  
---**Note:**
---*A storage object is accessable via `self.storage` in scripted shapes (see [ShapeClass]).*
---*The storage object also allows for data to be saved in creations saved on the Lift.*
local Storage = {}

---*Server only*  
---Loads Lua data stored in the storage object.  
---If no data is stored in the object, this returns nil.  
---@return any
function Storage:load() end

---*Server only*  
---Saves any Lua data into the storage object.  
---The data will remain stored after closing the world, and is retrieved using [Storage.load, load].  
---@param data any The data to be stored.
function Storage:save(data) end


---@class Unit
---A userdata object representing a <strong>unit</strong> in the game.  
local Unit = {}

---**Get**:
---*Server only*  
---Returns the character associated with a unit.  
---@type Character
Unit.character = {}

---**Set**:
---*Server only*  
---Sets the eye height for a unit  
---@type number
Unit.eyeHeight = {}

---**Get**:
---*Server only*  
---Returns the id of a unit.  
---@type integer
Unit.id = {}

---**Get**:
---*Server only*  
---Returns (server) public data from a unit.  
---**Set**:
---*Server only*  
---Sets (server) public data on a unit.  
---@type table
Unit.publicData = {}

---**Set**:
---*Server only*  
---Sets the vision frustum for a unit  
---```
---* self.unit.visionFrustum = {
---*	 { 3.0, math.rad( 80.0 ),  math.rad( 80.0 ) },
---*	 { 20.0, math.rad( 40.0 ), math.rad( 35.0 ) },
---*	 { 40.0, math.rad( 20.0 ), math.rad( 20.0 ) }
---* }
---```
---@type table
Unit.visionFrustum = {}

---*Server only*  
---Creates a Ai State from a name (See [AiState])  
---@param stateName string Name of predefined ai state.
---@return AiState state The ai state.
function Unit:createState(stateName) end

---*Server only*  
---Destroy a unit  
function Unit:destroy() end

---*Server only*  
---Returns the character associated with a unit.  
---@return Character
function Unit:getCharacter() end

---*Server only*  
---Gets the current facing direction of a unit.  
---@return Vec3
function Unit:getCurrentFacingDirection() end

---*Server only*  
---Gets the current movement direction of a unit.  
---@return Vec3
function Unit:getCurrentMovementDirection() end

---*Server only*  
---Returns the id of a unit.  
---@return integer
function Unit:getId() end

---*Server only*  
---Returns (server) public data from a unit.  
---@return table
function Unit:getPublicData() end

---*Server only*  
---Sends a event to the associated character of the unit.  
---@param event string The event name.
function Unit:sendCharacterEvent(event) end

---*Server only*  
---Sets the facing direction for a unit  
---@param direction Vec3 The desired facing direction.
function Unit:setFacingDirection(direction) end

---*Server only*  
---Notifies a unit that it heard a sound  
---@param noiseScale number The noise amount.
function Unit:setHearingData(noiseScale) end

---*Server only*  
---Sets the movement direction for a unit  
---@param direction Vec3 The desired movement direction.
function Unit:setMovementDirection(direction) end

---*Server only*  
---Sets the movment type for a unit  
---moveType can be "stand", "walk", "sprint" or "crouch"  
---@param moveTypeName string The movement type to set
function Unit:setMovementType(moveTypeName) end

---*Server only*  
---Sets (server) public data on a unit.  
---@param data table The public data.
function Unit:setPublicData(data) end

---*Server only*  
---Set a unit to jump  
---@param wantJump boolean True if the unit should jump
function Unit:setWantsJump(wantJump) end

---*Server only*  
---Sets the whisker data for obstacle avoidance  
---@param whiskerCount integer The whiskerCount.
---@param maxAngle number The maxAngle.
---@param startLength number The startLength.
---@param endLength number The endLength.
function Unit:setWhiskerData(whiskerCount, maxAngle, startLength, endLength) end


---@class AiState
---A userdata object representing an <strong>AI state</strong> belonging to a [Unit].  
local AiState = {}

---*Server only*  
---Returns the state's facing direction.  
---@return Vec3
function AiState:getFacingDirection() end

---*Server only*  
---Returns the state's movement direction.  
---@return Vec3
function AiState:getMovementDirection() end

---*Server only*  
---Returns a string describing the state's movement type.  
---Movement type can be "stand", "walk", "sprint" or "crouch".  
---@return string
function AiState:getMovementType() end

---*Server only*  
---Check if the state wants to jump.  
---@return boolean
function AiState:getWantsJump() end

---*Server only*  
---Checks if the AI state is done.  
---Returns true when the state is done, and a string describing the state's current situation.  
---Can be used to determine if another state is allowed to be started.  
---@return boolean, string
function AiState:isDone() end

---*Server only*  
---Updates the state by adding delta time progression.  
---Should be called once every game tick while the state is active.  
---@param deltaTime number The delta time.
function AiState:onFixedUpdate(deltaTime) end

---*Server only*  
---Updates the state by adding delta time progression.  
---Should be called once every unit update, by the unit that owns the state, while the state is active.  
---@param deltaTime number The delta time.
function AiState:onUnitUpdate(deltaTime) end

---*Server only*  
---Starts the state.  
function AiState:start() end

---*Server only*  
---Stops the state.  
function AiState:stop() end


---@class PathNode
---A userdata object representing a PathNode in the game.  
local PathNode = {}

---*Server only*  
---Create a PathNode connection  
---@param to PathNode PathNode to create connection to
function PathNode:connect(to) end

---*Server only*  
---Destroys a path node.  
function PathNode:destroy() end

---*Server only*  
---Get the world position of a path node  
---@return Vec3
function PathNode:getPosition() end


---@class Tool
---A userdata object representing a <strong>tool</strong> in the game.  
local Tool = {}

---**Get**:
---Returns the id of a tool.  
---@type integer
Tool.id = {}

---*Client only*  
---Returns general information for a third person view animation.  
---@param name string The name.
---@return AnimationInfo
function Tool:getAnimationInfo(name) end

---*Client only*  
---Get the current weights for the tool's local camera settings.  
---@return number tpWeight The third person camera weight
---@return number tpWeight The first person camera weight
function Tool:getCameraWeights() end

---*Client only*  
---Returns the direction of where the player is viewing or aiming.  
---@return Vec3
function Tool:getDirection() end

---*Client only*  
---Returns the smoothed direction of where the player is viewing or aiming.
---@return Vec3
function Tool:getSmoothDirection() end

---*Client only*  
---Returns general information for a first person view animation.  
---@param name string The name.
---@return AnimationInfo
function Tool:getFpAnimationInfo(name) end

---*Client only*  
---Returns the world position for a bone in the first person view animation skeleton.  
---@param jointName string The joint name.
---@return Vec3
function Tool:getFpBonePos(jointName) end

---Returns the id of a tool.  
---@return integer
function Tool:getId() end

---*Client only*  
---Returns the fraction of the player's movement speed in proportion to its maximum. This is affected by sprinting, crouching, blocking, aiming, etc.  
---sprinting1.0  
---walking0.5  
---crouching0.375  
---aiming0.3125  
---@return number
function Tool:getMovementSpeedFraction() end

---*Client only*  
---Returns the movement velocity of the player.  
---@return Vec3
function Tool:getMovementVelocity() end

---Returns the player that owns the tool.  
---@return Player
function Tool:getOwner() end

---*Client only*  
---Returns the world position of the player.  
---@return Vec3
function Tool:getPosition() end

---*Client only*  
---Returns the relative movement direction of the player. This is the direction the player wants to move based on movement input.  
---@return Vec3
function Tool:getRelativeMoveDirection() end

---*Client only*  
---Returns the world direction for a bone in the third person view animation skeleton.  
---@param jointName string The joint name.
---@return Vec3
function Tool:getTpBoneDir(jointName) end

---*Client only*  
---Returns the world position for a bone in the third person view animation skeleton.  
---@param jointName string The joint name.
---@return Vec3
function Tool:getTpBonePos(jointName) end

---*Client only*  
---Returns whether the player is currently crouching.  
---@return boolean
function Tool:isCrouching() end

---*Client only*  
---Returns whether the the tool is equipped or not.  
---@return boolean
function Tool:isEquipped() end

---*Client only*  
---Returns whether the player is in first person view where the viewpoint is rendered from the player's perspective. Otherwise, the player is in third person view where the camera is behind the player.
---Automatically returns false if the tool isn't local to the client.
---@return boolean
function Tool:isInFirstPersonView() end

---*Client only*  
---Returns whether the player holding the tool is the as [sm.localPlayer].  
---@return boolean
function Tool:isLocal() end

---*Client only*  
---Returns whether the player is currently standing on the ground.  
---@return boolean
function Tool:isOnGround() end

---*Client only*  
---Returns whether the player is currently sprinting.  
---@return boolean
function Tool:isSprinting() end

---*Client only*  
---Sets whether the player is unable to sprint. Sprinting is normally blocked when the player is attacking, blocking, aiming, etc.  
---@param block boolean Whether the player's sprinting is blocked.
function Tool:setBlockSprint(block) end

---*Client only*  
---Sets the opacity of the crosshair. An alpha value of 0 makes the crosshair transparent.  
---@param alpha number The alpha value for the crosshair.
function Tool:setCrossHairAlpha(alpha) end

---*Client only*  
---Sets the tool's dispersion fraction. This represents the accuracy of the tool, and affects the size of the player's crosshair.  
---A dispersion value of 0 is perfect accuracy, whereas 1 is the worst.  
---@param dispersion number The dispersion fraction.
function Tool:setDispersionFraction(dispersion) end

---*Client only*  
---Sets the color to be used for the tool in first person view.  
---@param color Color The color.
function Tool:setFpColor(color) end

---*Client only*  
---Sets the renderables (files containing model data) to be used for the character in first person view.  
---@param renderables table The table of renderables names {string, ..}
function Tool:setFpRenderables(renderables) end

---*Client only*  
---Sets whether interaction texts are suppressed for the player. This means the player won't be able to see "Press E to use", and similar texts, when looking at an interactable.  
---@param suppressed boolean Whether interaction texts are suppressed.
function Tool:setInteractionTextSuppressed(suppressed) end

---*Client only*  
---Sets the current third person view movement animation to be used by the tool.  
---@param name string The name.
---@param animation string The animation.
function Tool:setMovementAnimation(name, animation) end

---*Client only*  
---Sets whether the player is slowed down. This is similar to crouching and normally occurs when the player is aiming.  
---@param slowDown boolean Whether the player movement is slowed down.
function Tool:setMovementSlowDown(slowDown) end

---*Client only*  
---Sets the color to be used for the tool in third person view.  
---@param color Color The color.
function Tool:setTpColor(color) end

---*Client only*  
---Sets the renderables (files containing model data) to be used for the character in third person view.  
---@param renderables table The table of renderables names. {string, ..}
function Tool:setTpRenderables(renderables) end

---*Client only*  
---Updates a third person view animation.  
---@param name string The animation name.
---@param time number The time.
---@param weight? number The weight.
function Tool:updateAnimation(name, time, weight) end

---*Client only*  
---Updates the third person view camera for the tool.  
---@param distance number The distance.
---@param fov number The fov.
---@param offset Vec3 The offset.
---@param weight number The weight.
function Tool:updateCamera(distance, fov, offset, weight) end

---*Client only*  
---Updates a first person view animation.  
---@param name string The name.
---@param time number The time.
---@param weight? number The weight.
---@param looping? boolean The looping.
function Tool:updateFpAnimation(name, time, weight, looping) end

---*Client only*  
---Updates the first person view camera for the tool.  
---@param fov number The fov.
---@param offset Vec3 The offset.
---@param weight number The weight.
---@param bobbing number The bobbing.
function Tool:updateFpCamera(fov, offset, weight, bobbing) end

---*Client only*  
---Sets the rotation and weight for a bone in the animation skeleton.  
---@param name string The name.
---@param rotation Vec3 The rotation.
---@param weight? number The weight.
function Tool:updateJoint(name, rotation, weight) end

---*Client only*  
---Updates the currently set third person view movement animation for the tool.  
---@param time number The time.
---@param weight? number The weight.
function Tool:updateMovementAnimation(time, weight) end


---@class Widget
---Removed! Don't use.  
local Widget = {}

---**Get**:
---@deprecated Use [GuiInterface]
---Removed!  
---@type integer
Widget.id = {}

---**Get**:
---@deprecated Use [GuiInterface]
---Removed!  
---**Set**:
---@deprecated Use [GuiInterface]
---Removed!  
---@type Vec3
Widget.position = {}

---**Get**:
---@deprecated Use [GuiInterface]
---Removed!  
---**Set**:
---@deprecated Use [GuiInterface]
---Removed!  
---@type table
Widget.size = {}

---**Get**:
---@deprecated Use [GuiInterface]
---Removed!  
---**Set**:
---@deprecated Use [GuiInterface]
---Removed!  
---@type boolean
Widget.visible = {}

---@deprecated Use [GuiInterface]
---Removed!  
function Widget:bindOnClick() end

---@deprecated Use [GuiInterface]
---Removed!  
function Widget:find() end

---@deprecated Use [GuiInterface]
---Removed!  
function Widget:getName() end

---@deprecated Use [GuiInterface]
---Removed!  
function Widget:getPosition() end

---@deprecated Use [GuiInterface]
---Removed!  
function Widget:getSize() end

---@deprecated Use [GuiInterface]
---Removed!  
function Widget:getText() end

---@deprecated Use [GuiInterface]
---Removed!  
function Widget:getTypeName() end

---@deprecated Use [GuiInterface]
---Removed!  
function Widget:getVisible() end

---@deprecated Use [GuiInterface]
---Removed!  
function Widget:setPosition() end

---@deprecated Use [GuiInterface]
---Removed!  
function Widget:setSize() end

---@deprecated Use [GuiInterface]
---Removed!  
function Widget:setText() end

---@deprecated Use [GuiInterface]
---Removed!  
function Widget:setVisible() end


---@class BlueprintVisualization
---A userdata object representing a <strong>blueprint visualization</strong>.  
local BlueprintVisualization = {}

---*Client only*  
---Destroy a [BlueprintVisualization].  
function BlueprintVisualization:destroy() end

---*Client only*  
---Set the world position of a [BlueprintVisualization].  
---@param position Vec3 World position
function BlueprintVisualization:setPosition(position) end

---*Client only*  
---Set the rotation of a [BlueprintVisualization].  
---@param rotation Quat Rotation
function BlueprintVisualization:setRotation(rotation) end

---*Client only*  
---Set the scale of a [BlueprintVisualization].  
---@param scale Vec3 Scale
function BlueprintVisualization:setScale(scale) end

---*Client only*  
---Update the state of a builder guide [BlueprintVisualization]. Should be called whenever the root [Shape] of the builder guide has changed.  
---But should not be called every frame or tick for performance.  
function BlueprintVisualization:updateBuilderGuide() end


---@class GuiInterface
---A userdata object representing a <strong>GUI interface</strong>.  
---A <strong>gui interface</strong> is an adapter between a script and a GUI.  
---Can only be used on the <a href="index.html#client">client</a>.  
local GuiInterface = {}

---*Client only*  
---Adds an item to a grid  
---@param gridName string The name of the grid
---@param item table The item
function GuiInterface:addGridItem(gridName, item) end

---*Client only*  
---Adds items to a grid from json  
---@param gridName string The name of the grid
---@param jsonPath string Json file path
---@param additionalData? table Additional data to the json (Optional)
function GuiInterface:addGridItemsFromFile(gridName, jsonPath, additionalData) end

---*Client only*
---@param uuid Uuid The uuid of the item
---@param difference integer Amount of items
function GuiInterface:addToPickupDisplay( uuid, difference ) end

---*Client only*  
---Appends an item to a list  
---@param listName string The name of the list
---@param itemName string The name of the item
---@param data table Table of data to store
function GuiInterface:addListItem(listName, itemName, data) end

---*Client only*  
---Clears a grid  
---@param gridName string The name of the grid to clear
function GuiInterface:clearGrid(gridName) end

---*Client only*  
---Clears a list  
---@param listName string The name of the list
function GuiInterface:clearList(listName) end

---*Client only*  
---Close a gui interface  
function GuiInterface:close() end

---*Client only*  
---Creates a dropdown at the specified widget  
---@param widgetName string The name of the widget
---@param functionName string The name of the function
---@param options table The options in the dropdown menu
function GuiInterface:createDropDown(widgetName, functionName, options) end

---*Client only*  
---Creats a grid from a table/json  
---@param gridName string The name of the grid
---@param index table Grid data table { type=string, layout=string, itemWidth=integer, itemHeight=integer, itemCount=integer }
function GuiInterface:createGridFromJson(gridName, index) end

---*Client only*  
---Creates a slider at the specified widget  
---@param widgetName string The name of the widget
---@param range number The range of the slider
---@param value number The start value on the slider
---@param functionName string Slider change callback function name
---@param numbered? boolean Enable numbered steps (Defaults to false)
function GuiInterface:createHorizontalSlider(widgetName, range, value, functionName, numbered) end

---*Client only*  
---Creates a slider at the specified widget  
---@param widgetName string The name of the widget
---@param range number The range of the slider
---@param value number The start value on the slider
---@param functionName string Slider change callback function name
function GuiInterface:createVerticalSlider(widgetName, range, value, functionName) end

---*Client only*  
---Destroy a gui interface  
function GuiInterface:destroy() end

---*Client only*  
---Checks if a gui interface is active  
---@return boolean
function GuiInterface:isActive() end

---*Client only*  
---Open a gui interface  
function GuiInterface:open() end

---*Client only*  
---Plays an effect at a widget  
---@param widgetName string The name of the widget
---@param effectName string The name of the effect
---@param restart? boolean If the effect should restart if its already palying
function GuiInterface:playEffect(widgetName, effectName, restart) end

---*Client only*  
---Plays an effect at widget inside a grid  
---@param gridName string The name of the grid
---@param index integer The index in the grid
---@param effectName string The name of the effect
---@param restart? boolean If the effect should restart if its already palying
function GuiInterface:playGridEffect(gridName, index, effectName, restart) end

---*Client only*  
---Sets a button callback to be called when the button is pressed  
---@param buttonName string The button name
---@param callback string Function to be called when button is pressed
function GuiInterface:setButtonCallback(buttonName, callback) end

---*Client only*  
---Sets the button state  
---@param buttonName string The name of the button
---@param state boolean The state of the button
function GuiInterface:setButtonState(buttonName, state) end

---*Client only*  
---Sets the color of a widget  
---@param widgetName string The name of the widget
---@param Color Color The color
function GuiInterface:setColor(widgetName, Color) end

---*Client only*  
---Sets a container to a grid  
---@param gridName string The name of the grid
---@param container Container The container
function GuiInterface:setContainer(gridName, container) end

---*Client only*  
---Sets multiple containers to a grid  
---@param gridName string The name of the grid
---@param containers table Table of containers. {[Container], ..}
function GuiInterface:setContainers(gridName, containers) end

---*Client only*  
---Sets data to a widget  
---@param widgetName string The name of the widget
---@param data table The data
function GuiInterface:setData(widgetName, data) end

---*Client only*  
---Sets the fade range for a world gui  
---@param range number The fade range
function GuiInterface:setFadeRange(range) end

---*Client only*  
---Sets a widget to recieve key focus  
---@param widgetName string The name of the widget that needs focus
function GuiInterface:setFocus(widgetName) end

---*Client only*  
---Sets a callback to be called when a button inside a grid is pressed  
---@param buttonName string The button name
---@param callback string Function to be called when button is pressed
function GuiInterface:setGridButtonCallback(buttonName, callback) end

---*Client only*  
---Sets an item in a grid  
---@param gridName string The name of the grid
---@param index integer The item index
---@param item? table The item
function GuiInterface:setGridItem(gridName, index, item) end

---*Client only*  
---Sets a callback to be called when a grid item is changed  
---@param gridName string The grid name
---@param callback string Function to be called when button is pressed
function GuiInterface:setGridItemChangedCallback(gridName, callback) end

---*Client only*  
---Sets a callback to be called when a grid widget gets mouse focus  
---@param buttonName string The button name
---@param callback string Function to be called when button is pressed
function GuiInterface:setGridMouseFocusCallback(buttonName, callback) end

---*Client only*  
---Sets the size of a grid  
---@param gridName string The name of the grid
---@param index integer The size
function GuiInterface:setGridSize(gridName, index) end

---*Client only*  
---Sets a [Character|Shape] as host for a world gui  
---@param object Character|Shape The object to host the gui
---@param joint? string The joint (Optional)
function GuiInterface:setHost(object, joint) end

---*Client only*  
---Sets the icon image to a shape from an uuid  
---@param itembox string The name of the itembox
---@param uuid Uuid The item uuid
function GuiInterface:setIconImage(itembox, uuid) end

---*Client only*  
---Sets the image of an imagebox  
---@param imagebox string The name of the imagebox widget
---@param image string The name or path of the image
function GuiInterface:setImage(imagebox, image) end

---*Client only*  
---Sets the resource, group and item name on an imagebox widget  
---@param imagebox string The name of the imagebox
---@param itemResource string The item resource 
---@param itemGroup string The item group
---@param itemName string The item name
function GuiInterface:setItemIcon(imagebox, itemResource, itemGroup, itemName) end

---*Client only*  
---Sets a callback to be called when a list selection is changed  
---@param listName string The list name
---@param callback string Function to be called when list is selected
function GuiInterface:setListSelectionCallback(listName, callback) end

---*Client only*  
---Sets the maximum render distance for a world gui  
---@param distance number The max render distance
function GuiInterface:setMaxRenderDistance(distance) end

---*Client only*  
---Sets a mesh preview to display an item from uuid  
---@param widgetName string The name of the widget
---@param uuid Uuid The item uuid to display
function GuiInterface:setMeshPreview(widgetName, uuid) end

---*Client only*  
---Sets a callback to be called when the gui is closed  
---@param callback string Function to be called when gui is closed
function GuiInterface:setOnCloseCallback(callback) end

---*Client only*  
---Sets if a world gui requires line of sight to be shown  
---@param required boolean True if gui requires line of sight to render
function GuiInterface:setRequireLineOfSight(required) end

---*Client only*  
---Sets the selected item in a dropdown widget
---@param widget string The dropdown widget
---@param item string The item to be selected in the dropdown
function GuiInterface:setSelectedDropDownItem(widget, item) end

---*Client only*  
---Selects an item in a list  
---@param listName string The name of the list
---@param itemName string The name of the item
function GuiInterface:setSelectedListItem(listName, itemName) end

---*Client only*  
---Sets a callback to be called when the slider is moved  
---@param sliderName string The button name
---@param callback string Function to be called when slider is moved
function GuiInterface:setSliderCallback(sliderName, callback) end

---*Client only*  
---Sets the position and range of a slider  
---@param sliderName string The name of the slider
---@param range number The slider range
---@param position number The slider position
function GuiInterface:setSliderData(sliderName, range, position) end

---*Client only*  
---Sets the position of a slider  
---@param sliderName string The name of the slider
---@param position integer The slider position
function GuiInterface:setSliderPosition(sliderName, position) end

---*Client only*  
---Sets the slider range of a slider.  
---@param sliderName string The name of the slider
---@param range integer The slider range
function GuiInterface:setSliderRange(sliderName, range) end

---*Client only*  
---Sets the range limit of a slider  
---@param sliderName string The name of the slider
---@param limit integer The slider range limit
function GuiInterface:setSliderRangeLimit(sliderName, limit) end

---*Client only*  
---Sets the text caption of a textbox widget  
---@param textbox string The name of the textbox widget
---@param text string The text
function GuiInterface:setText(textbox, text) end

---*Client only*  
---Sets a callback to be called when the text change is accepted  
---@param editBoxName string The edit box name
---@param callback string Function to be called when text is committed
function GuiInterface:setTextAcceptedCallback(editBoxName, callback) end

---*Client only*  
---Sets a callback to be called when the text is changed  
---@param editBoxName string The edit box name
---@param callback string Function to be called when text is edited
function GuiInterface:setTextChangedCallback(editBoxName, callback) end

---*Client only*  
---Sets a widget to be visible or not  
---@param widgetName string The name of the widget
---@param visible boolean True if visible
function GuiInterface:setVisible(widgetName, visible) end

---*Client only*  
---Sets the world position for a world gui  
---@param position Vec3 The world position of the interface
---@param world? World The world, defaults to same as the script
function GuiInterface:setWorldPosition(position, world) end

---*Client only*  
---Stops an effect playing at a widget  
---@param widgetName string The name of the widget
---@param effectName string The name of the effect
---@param immediate? boolean When true, the effect stops immediately (Defaults to false)
function GuiInterface:stopEffect(widgetName, effectName, immediate) end

---*Client only*  
---Stopts an effect playing inside a grid  
---@param gridName string The name of the grid
---@param index integer The index in the grid
---@param effectName string The name of the effect
function GuiInterface:stopGridEffect(gridName, index, effectName) end

---*Client only*  
---Adds a quest to the quest tracker  
---@param name string The name of quest
---@param title string The quest title to be displayed in the tracker
---@param mainQuest boolean If the quest is a main quest (Displayed on top in the tracker)
---@param questTasks table The table of quest tasks to display in the log Task{ name = string, text = string, count = number, target = number, complete = boolean }
function GuiInterface:trackQuest(name, title, mainQuest, questTasks) end

---*Client only*  
---Removes a quest from the quest tracker  
---@param questName string The name of quest
function GuiInterface:untrackQuest(questName) end


---Creates a new class object.
---@generic base : table
---@param superClass? base An optional base class to inherit from. (Defaults to inheriting from no class)
---@return base subClass
function class(superClass) end

---Opens the named file and executes its contents as a Lua chunk. In case of errors, dofile propagates the error to its caller.  
---@param filename string The name of the file to be loaded.
function dofile(filename) end

---Prints data to the <a href="index.html#console">console</a>. This is useful for debugging.  
---**Note:**
---*If the game is running with the `-dev` flag, any output will be added to the game logs.*
---@param ... any The arguments to be printed.
function print(...) end

---Returns the type of an object as a string. This includes standard Lua types and userdata types specific to this API.  
---@param object any The object instance.
---@return string
function type(object) end


---The <strong>sm</strong> namespace contain all API features related to Scrap Mechanic.  
sm = {}

---Returns whether the game is currently running on the <a href="index.html#server">hosting</a> player's computer.  
---@type boolean
sm.isHost = {}

---Returns the current version of the game as a string.  
---@type string
sm.version = {}

---Returns whether an object exists in the game. This is useful for checking whether a reference to an object is valid.  
---@param object any The object instance.
---@return boolean
function sm.exists(object) end

---Returns whether the script is currently running in <a href="index.html#server">server mode</a>. Otherwise, it is running in <a href="index.html#client">client mode</a>. Server mode only occurs when [sm.isHost] is true.  
---@return boolean
function sm.isServerMode() end


---Parses and writes json files from and to lua values.  
sm.json = {}

---Checks if a json file exists at the input path  
---@param path string The json file path.
---@return boolean
function sm.json.fileExists(path) end

---Opens a json file and parses to Lua table.  
---@param path string The json file path.
---@return table
function sm.json.open(path) end

---Parses a json string to lua table.  
---@param json string The json string.
---@return table
function sm.json.parseJsonString(json) end

---Write a lua table to json.  
---@param root table The lua table.
---@param path string The json file path.
function sm.json.save(root, path) end

---Writes a json string from a lua table.  
---@param root table The lua table.
---@return string
function sm.json.writeJsonString(root) end


---Contains methods related to random number and noise generation.  
---Most noise related functions are used for terrain generation.  
sm.noise = {}

---A number noise 2d function.  
---@param x number The X value.
---@param y number The Y value.
---@param seed integer The seed.
---@return number
function sm.noise.floatNoise2d(x, y, seed) end

---Returns a directional vector with a random spread given by a [sm.noise.randomNormalDistribution, normal distribution].  
---@param direction Vec3 The direction.
---@param spreadAngle number The spread angle in degrees.
---@return Vec3
function sm.noise.gunSpread(direction, spreadAngle) end

---An integer noise 2d function.  
---@param x number The X value.
---@param y number The Y value.
---@param seed integer The seed.
---@return integer
function sm.noise.intNoise2d(x, y, seed) end

---An octave noise 2d function.  
---@param x number The X value.
---@param y number The Y value.
---@param octaves integer The octaves.
---@param seed integer The seed.
---@return number
function sm.noise.octaveNoise2d(x, y, octaves, seed) end

---A perlin noise 2d function.  
---@param x number The X value.
---@param y number The Y value.
---@param seed integer The seed.
---@return number
function sm.noise.perlinNoise2d(x, y, seed) end

---Returns a random number according to the <a target="_blank" href="https://en.wikipedia.org/wiki/Normal_distribution">normal random number distribution</a>.  
---Values near the <strong>mean</strong> are the most likely.  
---Standard <strong>deviation</strong> affects the dispersion of generated values from the mean.  
---@param mean number The mean.
---@param deviation number The deviation.
---@return number
function sm.noise.randomNormalDistribution(mean, deviation) end

---Returns a random number N such that `a <= N <= b`.  
---@param a number The lower bound.
---@param b number The upper bound.
---@return number
function sm.noise.randomRange(a, b) end

---A simplex noise 1d function.  
---@param x number The X value.
---@return number
function sm.noise.simplexNoise1d(x) end

---A simplex noise 2d function.  
---@param x number The X value.
---@param y number The Y value.
---@return number
function sm.noise.simplexNoise2d(x, y) end


---Offers various math-related functions.  
sm.util = {}

---Constructs a quaternion from a X and Z axis  
---@param xAxis Vec3 The X axis.
---@param yAxis Vec3 The Z axis.
---@return Quat
function sm.util.axesToQuat(xAxis, yAxis) end

---Quadratic Bezier interpolation. One dimensional bezier curve.  
---@param c0 number The start value.
---@param c1 number The control point.
---@param c2 number The end value.
---@param t number The interpolation step.
---@return number
function sm.util.bezier2(c0, c1, c2, t) end

---Cubic Bezier interpolation. One dimensional bezier curve.  
---@param c0 number The start value.
---@param c1 number The first control point.
---@param c2 number The second control point.
---@param c3 number The end value.
---@param t number The interpolation step.
---@return number
function sm.util.bezier3(c0, c1, c2, c3, t) end

---Restricts a value to a given range.  
---@param value number The value.
---@param min number The lower limit.
---@param max number The upper limit.
---@return number
function sm.util.clamp(value, min, max) end

---@alias EasingFunction string
---| "linear"  
---| "easeInQuad"  
---| "easeOutQuad"  
---| "easeInOutQuad"  
---| "easeInCubic"  
---| "easeOutCubic"  
---| "easeInOutCubic"  
---| "easeInQuart"  
---| "easeOutQuart"  
---| "easeInOutQuart"  
---| "easeInQuint"  
---| "easeOutQuint"  
---| "easeInOutQuint"  
---| "easeInSine"  
---| "easeOutSine"  
---| "easeInOutSine"  
---| "easeInCirc"  
---| "easeOutCirc"  
---| "easeInOutCirc"  
---| "easeInExpo"  
---| "easeOutExpo"  
---| "easeInOutExpo"  
---| "easeInElastic"  
---| "easeOutElastic"  
---| "easeInOutElastic"  
---| "easeInBack"  
---| "easeOutBack"  
---| "easeInOutBack"  
---| "easeInBounce"  
---| "easeOutBounce"  
---| "easeInOutBounce"  

---Applies an easing function to a given input.
---@param easing EasingFunction The easing function name.
---@param p number The easing function input.
---@return number
function sm.util.easing(easing, p) end

---Linear interpolation between two values. This is known as a lerp.  
---@param a number The first value.
---@param b number The second value.
---@param t number The interpolation step.
---@return number
function sm.util.lerp(a, b, t) end

---Returns the positive remainder after division of x by n.  
---@param x integer The number.
---@param n integer The modulo value.
---@return number
function sm.util.positiveModulo(x, n) end

---An improved version of the [sm.util.smoothstep, smoothstep] function which has zero 1st and 2nd order derivatives at `x = edge0` and `x = edge1`.  
---@param edge0 number The value of the lower edge of the Hermite function.
---@param edge1 number The value of the upper edge of the Hermite function.
---@param x number The source value for interpolation.
---@return number
function sm.util.smootherstep(edge0, edge1, x) end

---Performs smooth Hermite interpolation between 0 and 1 when `edge0 < x < edge1`. This is useful in cases where a threshold function with a smooth transition is desired.  
---@param edge0 number The value of the lower edge of the Hermite function.
---@param edge1 number The value of the upper edge of the Hermite function.
---@param x number The source value for interpolation.
---@return number
function sm.util.smoothstep(edge0, edge1, x) end


---Used for logging information from scripts to the game log.  
sm.log = {}

---Logs an error message  
---@param ... any The arguments to be displayed as an error message.
function sm.log.error(...) end

---Logs an information message  
---@param ... any The arguments to be displayed as a log message.
function sm.log.info(...) end

---Logs a warning message  
---@param ... any The arguments to be displayed as a warning message.
function sm.log.warning(...) end


---A <strong>vector</strong> is used to represent position and direction in 3D space, using X, Y and Z coordinates.  
---To create one, use [sm.vec3.new].  
sm.vec3 = {}

---Quadratic Bezier interpolation. Three dimensional bezier curve.  
---@param c0 Vec3 The start point.
---@param c1 Vec3 The control point.
---@param c2 Vec3 The end point.
---@param t number The interpolation step.
---@return Vec3
function sm.vec3.bezier2(c0, c1, c2, t) end

---Cubic Bezier interpolation. Three dimensional bezier curve.  
---@param c0 number The start point.
---@param c1 number The first control point.
---@param c2 number The second control point.
---@param c3 number The end point.
---@param t number The interpolation step.
---@return number
function sm.vec3.bezier3(c0, c1, c2, c3, t) end

---Finds the closest axis-aligned vector from the given vector  
---@param vector Vec3 The vector.
---@return Vec3
function sm.vec3.closestAxis(vector) end

---Returns a [Quat, quaternion] representing the rotation from one vector to another.  
---The quaternion can then be multiplied with any vector to rotate it in the same fashion.  
---```
---v1 = sm.vec3.new(1,0,0)
---v2 = sm.vec3.new(0,1,0)
---
---trans = sm.vec3.getRotation(v1, v2)
----- `trans` now rotates a vector 90 degrees
---
---print(trans * v2)
----- {<Vec3>, x = -1, y = 0, z = 0}
---```
---@param v1 Vec3 The first vector.
---@param v2 Vec3 The second vector.
---@return Quat
function sm.vec3.getRotation(v1, v2) end

---Performs a <a target="_blank" href="https://en.wikipedia.org/wiki/Linear_interpolation">linear interpolation</a> between two vectors.  
---@param v1 Vec3 The first vector.
---@param v2 Vec3 The second vector.
---@param t number Interpolation amount between the two inputs.
---@return Vec3
function sm.vec3.lerp(v1, v2, t) end

---Creates a new vector.  
---@param x number The X value.
---@param y number The Y value.
---@param z number The Z value.
---@return Vec3
function sm.vec3.new(x, y, z) end

---Creates a new vector with 1 in x, y, x.  
---@return Vec3
function sm.vec3.one() end

---Creates a new vector with 0 in x, y, x.  
---@return Vec3
function sm.vec3.zero() end


---A <strong>quaternion</strong> is used to represent rotation as a <a target="_blank" href="https://en.wikipedia.org/wiki/Quaternion">generalization of complex numbers</a>.  
---To create one, use [sm.quat.new].  
---**Warning:**
---*It is uncommon to modify individual X, Y, Z, W components directly. To create a new quaternion, consider using [sm.vec3.getRotation].*
sm.quat = {}

---Creates a new quaternion from angle and axis.  
---@param angle number The rotation angle in radians.
---@param axis Vec3 The axis vector to rotate around.
---@return Quat
function sm.quat.angleAxis(angle, axis) end

---Create a new quaternion from an euler angle vector.  
---@param euler Vec3 The euler angle vector.
---@return Quat
function sm.quat.fromEuler(euler) end

---Returns the quaternions at vector.  
---@param quaternion Quat The quaternion.
---@return Vec3
function sm.quat.getAt(quaternion) end

---Returns the quaternions right vector.  
---@param quaternion Quat The quaternion.
---@return Vec3
function sm.quat.getRight(quaternion) end

---Returns the quaternions up vector.  
---@param quaternion Quat The quaternion.
---@return Vec3
function sm.quat.getUp(quaternion) end

---Creates a new identity quaternion.  
---@return Quat
function sm.quat.identity() end

---Inverts the quaternion.  
---@param quaternion Quat The quaternion.
---@return Quat
function sm.quat.inverse(quaternion) end

---Create a new quaternion from direction vectors. DEPRECATED  
---@param at Vec3 The forward vector.
---@param up Vec3 The up vector.
---@return Quat
function sm.quat.lookRotation(at, up) end

---Creates a new quaternion.  
---@param x number The X value.
---@param y number The Y value.
---@param z number The Z value.
---@param w number The W value.
---@return Quat
function sm.quat.new(x, y, z, w) end

---Rounds the quaternion rotation into 90 degree steps  
---@param quaternion Quat The quaternion.
---@return Quat
function sm.quat.round90(quaternion) end

---Performs a spherical linear interpolation between two quaternion.  
---@param quaternion1 Quat The first quaternion.
---@param quaternion2 Quat The second quaternion.
---@param t number Interpolation amount between the two inputs.
---@return Quat
function sm.quat.slerp(quaternion1, quaternion2, t) end


---A universally unique identifier (<strong>UUID</strong>) is a 128-bit number that can guarantee uniqueness across space and time.  
---To generate one, use [sm.uuid.new].  
sm.uuid = {}

---Generates a named (version 5) uuid.  
---@param namespace Uuid A uuid namespace for the name. The namespace makes sure any equal name from different namespaces do not collide.
---@param name string A name, to generate a uuid from. Provided the same namespace and name, the uuid will be the same.
---@return Uuid
function sm.uuid.generateNamed(namespace, name) end

---Generates a random (version 4) uuid.  
---@return Uuid
function sm.uuid.generateRandom() end

---Creates a nil uuid {00000000-0000-0000-0000-000000000000}  
---@return Uuid
function sm.uuid.getNil() end

---Creates a uuid from a string or generates a random uuid (version 4).  
---@param uuid? string The uuid string to create a uuid instance from. If none is provided, generate a random uuid.
---@return Uuid
function sm.uuid.new(uuid) end


---A <strong>color</strong> is represented using a red, green, blue and alpha component. Colors are prominently used for blocks and parts that are colored by the <em>Paint Tool</em>.  
---To create one, use [sm.color.new]. It is possible to use hex `0xRRGGBBAA` or strings `"RRGGBBAA"`.  
---**Note:**
---*R, G, B, A values range between 0.0&ndash;1.0.*
sm.color = {}

---Creates a new color object from R, G, B, A.  
---@param r number The red value.
---@param g number The green value.
---@param b number The blue value.
---@param a? number The alpha value. Defaults to 1.0. (Optional)
---@return Color
function sm.color.new(r, g, b, a) end

---Creates a new color object from a hex string `"RRGGBBAA"`.  
---@param hexStr string The hex string.
---@return Color
function sm.color.new(hexStr) end

---Creates a new color object from a hex value `0xRRGGBBAA`.  
---@param hexInt integer The hex value.
---@return Color
function sm.color.new(hexInt) end


---Contains functions regarding the physics engine.  
sm.physics = {}

---Collision filter types
sm.physics.filter = {
    all = -1,
    dynamicBody = 1,
    staticBody = 2,
    character = 4,
    areaTrigger = 8,
    terrainSurface = 128,
    terrainAsset = 256,
    harvestable = 512,
    joints = 4096,
    static = 34690,
    default = 38791,
    voxelTerrain = 32768,
}

---Physics types are used to define an object's characteristics is in the physics world. Upon a raycast or collision detection, these types are used to find out what object was intersected.  
---"limiter" The world border.
---"terrainSurface" The ground.  
---"terrainAsset" Terrain assets.  
---"body" A [Body].  
---"joint" A [Joint].  
---"lift" A [Lift].  
---"character" A [Character].  
---"joint" A [Joint].  
---"harvestable" A [Harvestable].  
---"ragdoll" A ragdolled character.  
---"areaTrigger" An [AreaTrigger].
---"vision" A collision area used by sensors.
---"voxelTerrain" A voxel terrain grid.
---"tunnelCatcher" The trigger that teleports things when they fall off the world.
sm.physics.types = {
    "limiter",
    "terrainSurface",
    "terrainAsset",
    "body",
    "joint",
    "lift",
    "character",
    "joint",
    "harvestable",
    "ragdoll",
    "areaTrigger",
    "vision",
    "voxelTerrain",
    "tunnelCatcher"
}

---Applies an impulse to a [Shape], changing its velocity immediately. The impulse is applied to the shape's centerpoint with an optional offset.  
---@param target Shape The object on which the impulse is exerted on.
---@param impulse Vec3 The direction and strength of the impulse.
---@param worldSpace? boolean Whether the impulse is applied in world space coordinates. (Defaults to local rotation)
---@param offset? Vec3 The offset from the center point. (Defaults to no offset)
function sm.physics.applyImpulse(target, impulse, worldSpace, offset) end

---Applies an impulse to a [Body], changing its velocity immediately. The impulse is applied to the body's center of mass with an optional offset.  
---@param target Body The object on which the impulse is exerted on.
---@param impulse Vec3 The direction and strength of the impulse.
---@param worldSpace? boolean Whether the impulse is applied in world space coordinates. (Defaults to local rotation)
---@param offset? Vec3 The offset from the center point. (Defaults to no offset)
function sm.physics.applyImpulse(target, impulse, worldSpace, offset) end

---Applies an impulse to a [Character], changing its velocity immediately. The impulse is applied to the character's centerpoint.  
---@param target Character The character on which the impulse is exerted on.
---@param impulse Vec3 The direction and strength of the impulse.
function sm.physics.applyImpulse(target, impulse) end

---Applies a torque impulse to a [Body], changing its angular velocity immediately. The torque is applied along the body's center of mass, making it rotate.  
---@param target Body The object on which the torque is exerted on.
---@param torque Vec3 The direction and strength of the torque.
---@param worldSpace? boolean Whether the torque is applied in world space coordinates. (Defaults to local rotation)
function sm.physics.applyTorque(target, torque, worldSpace) end

---Performs a distance <a target="_blank" href="https://en.wikipedia.org/wiki/Ray_casting">ray cast</a> from a position with a given direction.  
---**Note:**
---*[sm.physics.distanceRaycast] is generally cheaper to use than [sm.physics.raycast] as it performs collision checks in a simplified world. If the raycast is only used for checking collision, it is advised to use this method instead.*
---@param start Vec3 The start position.
---@param direction Vec3 The ray's direction and length.
---@return boolean, number
function sm.physics.distanceRaycast(start, direction) end

---*Server only*  
---Creates an explosion at given position. The explosion creates a shockwave that is capable of destroying blocks and pushing characters and creations away.  
---Shapes that are within the explosion's destruction radius may receive the event [ShapeClass.server_onExplosion, server_onExplosionHit].  
---**Note:**
---*The <strong>destruction level</strong> is the damage effect on blocks and parts, determining how likely it is that they are destroyed. This is related to the `qualityLevel` found in parts json-files.*
---*Any quality level equal to or less than the destruction level may be destroyed. The effect fades one level every half travelled of the remaining destruction radius.*
---*A quality level of 0 means a block or part is indestructible.*
---@param position Vec3 The center point of the explosion.
---@param level integer The destruction level affecting nearby objects.
---@param destructionRadius number The destruction radius. Objects inside this sphere may be destroyed.
---@param impulseRadius number The impulse radius. Objects inside this sphere are affected by an [sm.physics.applyImpulse, impulse].
---@param magnitude number The impulse strength of the explosion. The strength diminishes with distance.
---@param effectName? string The name of the effect to be played upon explosion. (Optional)
---@param ignoreShape? Shape The shape to be ignored. (Optional)
---@param parameters? table The table containing the parameters for the effect. (Optional)
function sm.physics.explode(position, level, destructionRadius, impulseRadius, magnitude, effectName, ignoreShape, parameters) end

---*Server only*  
---Returns the gravitational acceleration affecting [Shape, shapes] and [Body, bodies].  
---@return number
function sm.physics.getGravity() end

---Returns the material at the given position in the terrain.  
---@param worldPosition Vec3 The world position to check the material at.
---@return string
function sm.physics.getGroundMaterial(worldPosition) end

---@class SphereContacts
---@field bodies Body[]
---@field characters Character[]
---@field harvestables Harvestable[]
---@field lifts Lift[]

---*Server only*  
---Returns a table of the game objects that are found inside the given sphere  
---@param pos Vec3 The world position of the sphere.
---@param radius number The radius of the sphere.
---@return SphereContacts
function sm.physics.getSphereContacts(pos, radius) end

---Performs multiple sphere and/or raycasts given a table of parameters.  
---Type can be "sphere" or "ray". Radius is ignored for rays.  
---@param casts table Table of casts. { type=string, startPoint=[Vec3], endPoint=[Vec3], radius=number, mask=[sm.physics.filter] }
---@return RaycastResult[]
function sm.physics.multicast(casts) end

---Performs a <a target="_blank" href="https://en.wikipedia.org/wiki/Ray_casting">ray cast</a> between two positions.  
---The returned [RaycastResult] contains information about any object intersected by the ray.  
---If the ray cast is called from within a shape (e.g. a Sensor), a [Body] may be provided which the ray will not intersect.  
---@param startPos Vec3 The start position.
---@param endPos Vec3 The end position.
---@param ignoredObject? Body|Character|Shape|Harvestable The object to be ignored. (Optional)
---@param mask? integer The collision mask. Defaults to [sm.physics.filter, sm.physics.filter.default] (Optional)
---@return boolean,	RaycastResult
function sm.physics.raycast(startPos, endPos, ignoredObject, mask) end

---Performs a <a target="_blank" href="https://en.wikipedia.org/wiki/Ray_casting">ray cast</a> between two positions to find a specific target.  
---a [Body] must be provided as a target.  
---The returned [RaycastResult] contains information about any object intersected by the ray.  
---@param startPos Vec3 The start position.
---@param endPos Vec3 The end position.
---@param object Body|Character|Shape|Harvestable The object to be exclusively checked.
---@return boolean,	RaycastResult
function sm.physics.raycastTarget(startPos, endPos, object) end

---*Server only*  
---Sets the gravitational acceleration affecting [Shape, shapes] and [Body, bodies].  
---@param gravity number The gravitational value.
function sm.physics.setGravity(gravity) end

---Returns the number of collision objects that are found inside the given sphere  
---@param worldPosition Vec3 The world position of the sphere.
---@param radius number The radius of the sphere.
---@param includeTerrain? boolean True if terrain should be included in the test
---@param countWater? boolean True if water should be included
---@return integer
function sm.physics.sphereContactCount(worldPosition, radius, includeTerrain, countWater) end

---Performs a spherical <a target="_blank" href="https://en.wikipedia.org/wiki/Ray_casting">ray cast</a> between two positions.  
---The returned [RaycastResult] contains information about any object intersected by the ray.  
---If the ray cast is called from within a shape (e.g. a Sensor), a [Body] may be provided which the ray will not intersect.  
---@param startPos Vec3 The start position.
---@param endPos Vec3 The end position.
---@param radius number The radius of the sphere.
---@param object? Body|Character|Shape|Harvestable The object to be ignored. (Optional)
---@param mask? integer The collision mask. Defaults to [sm.physics.filter, sm.physics.filter.default] (Optional)
---@return boolean,	RaycastResult
function sm.physics.spherecast(startPos, endPos, radius, object, mask) end


---A <strong>shape</strong> is any block, part or basic material that can be built by a player. Shapes are always connected to a [sm.body, body], which is a collection of shapes.  
---For more information about creating your own scripted shapes, see [ShapeClass, ShapeClass].  
sm.shape = {}

---*Server only*  
---Create a new block  
---@param uuid Uuid The uuid of the shape.
---@param size Vec3 The size of the block.
---@param position Vec3 The shape's world position.
---@param rotation? Quat The shape's world rotation. Defaults to no rotation (Optional)
---@param dynamic? boolean Set true if the shape is dynamic or false if the shape is static. Defaults to true (Optional)
---@param forceSpawn? boolean Set true to force spawn the shape even if it will cause collision. Defaults to true (Optional)
---@return Shape block The created block
function sm.shape.createBlock(uuid, size, position, rotation, dynamic, forceSpawn) end

---*Server only*  
---Create a new part  
---@param uuid Uuid The uuid of the shape.
---@param position Vec3 The shape's world position.
---@param rotation? Quat The shape's world rotation. Defaults to no rotation (Optional)
---@param dynamic? boolean Set true if the shape is dynamic or false if the shape is static. Defaults to true (Optional)
---@param forceSpawn? boolean Set true to force spawn the shape even if it will cause collision. Defaults to true (Optional)
---@return Shape part The created part
function sm.shape.createPart(uuid, position, rotation, dynamic, forceSpawn) end

---*Server only*  
---Creates a wedge. The wedge is oriented with one   
---cathetus along the Y-axis and the other along the Z-axis, forming a right angle.   
---@param uuid Uuid The uuid of the shape.
---@param size Vec3 The size of the wedge.
---@param position Vec3 The shape's world position.
---@param rotation? Quat The shape's world rotation. Defaults to no rotation (Optional)
---@param dynamic? boolean Set true if the shape is dynamic or false if the shape is static. Defaults to true (Optional)
---@param forceSpawn? boolean Set true to force spawn the shape even if it will cause collision. Defaults to true (Optional)
---@return Shape wedge The created wedge
function sm.shape.createWedge(uuid, size, position, rotation, dynamic, forceSpawn) end

---Returns the block/part description for the given uuid.  
---@param uuid Uuid The uuid.
---@return string
function sm.shape.getShapeDescription(uuid) end

---@param uuid Uuid The shape's uuid.
---@return any
function sm.shape.getShapeIcon(uuid) end

---Returns the block/part name for the given uuid.  
---@param uuid Uuid The uuid.
---@return string
function sm.shape.getShapeTitle(uuid) end

---Returns the color of the uuid's shape type  
---@param uuid Uuid The uuid of the shape.
---@return Color
function sm.shape.getShapeTypeColor(uuid) end

---Return whether the shape uuid exists  
---@param uuid Uuid The shape uuid.
---@return boolean
function sm.shape.uuidExists(uuid) end

---Return whether the shape uuid belongs to a harvest part  
---@param uuid Uuid The shape uuid.
---@return boolean
function sm.shape.getIsHarvest(uuid) end

---Return whether the shape uuid belongs to a stackable shape  
---@param uuid Uuid The shape uuid.
---@return boolean
function sm.shape.getIsStackable(uuid) end

---Returns a table of shapes that are inside the sphere.
---@param center Vec3 The sphere center position.
---@param radius number The sphere radius.
---@return Shape[]
function sm.shape.shapesInSphere(center, radius) end

---A <strong>body</strong> is a collection of [Shape, shapes] that are built together. Bodies can be connected to other bodies using [Joint, joints] such as the bearing.  
sm.body = {}

---*Server only*  
---Create a new body  
---@param position Vec3 The body's world position.
---@param rotation? Quat The body's world rotation. (Defaults to [sm.quat.identity])
---@param isDynamic? boolean Set true if the body is dynamic or false if the body is static. (Defaults to true)
---@return Body body
function sm.body.createBody(position, rotation, isDynamic) end

---*Server only*  
---Returns a table with all the bodies in the world.  
---@return Body[]
function sm.body.getAllBodies() end

---Returns a table of tables, which is an array of tables containing bodies grouped by creation.  
---A creation includes all bodies connected by [Joint, joints], etc.  
---@param bodies table The bodies to find all creation bodies from. {[Body], ...}
---@return table
function sm.body.getCreationsFromBodies(bodies) end


---An <strong>interactable shape</strong> is any part that has additional functionality or abilities. The player can interact with an interactable shape by pressing `E` on it, or connect it to other interactables with the <em>Connect Tool</em>.  
sm.interactable = {}

---Actions are used to specify what inputs types an [Interactable] is able to detect.  
sm.interactable.actions = {
    none = 0,
    left = 1,
    right = 2,
    forward = 3,
    backward = 4,
    item0 = 5,
    item1 = 6,
    item2 = 7,
    item3 = 8,
    item4 = 9,
    item5 = 10,
    item6 = 11,
    item8 = 13,
    item7 = 12,
    item9 = 14,
    use = 15,
    jump = 16,
    exit = 17,
    attack = 18,
    create = 19,
    zoomIn = 20,
    zoomOut = 21
}

---<h3>Logic</h3>  
---The interactable sends or reads a boolean signal to signal it's current state. ([Interactable.isActive, isActive]) to signal its output.  
---In: The interactable reads a boolean ([Interactable.isActive, isActive]) from its parent as input.  
---<h3>Power</h3>  
---Out: The controller uses a float ([Interactable.getPower, getPower]) to signal strength output (steering only).  
---In: The controller reads a float ([Interactable.getPower, getPower]) from its parent as input for strength.  
---none0  
---logic1  
---power2  
---bearing4  
---seated8  
---piston16  
---gasoline256  
---electricity512  
---water1024  
---ammo2048  
sm.interactable.connectionType = {
    none = 0,
    logic = 1,
    power = 2,
    bearing = 4,
    seated = 8,
    piston = 16,
    gasoline = 256,
    electricity = 512,
    water = 1024,
    ammo = 2048
}

---Flags to be used with the steering component.  
sm.interactable.steering = {
    left = 1,
    right = 2,
    forward = 4,
    backward = 8
}

sm.interactable.types = {
    "electricEngine",
    "gasEngine",
    "steering",
    "seat",
    "controller",
    "button",
    "lever",
    "sensor",
    "thruster",
    "radio",
    "horn",
    "tone",
    "logic",
    "timer",
    "particlePreview",
    "spring",
    "pointLight",
    "spotLight",
    "chest",
    "itemStack",
    "scripted",
    "piston",
    "simpleInteractive",
    "camera",
    "waypoint",
    "survivalThruster",
    "survivalPiston",
    "survivalSpring",
    "survivalSequence",
    "survivalSensor"
}


---A <strong>joint</strong> is a part that can be built by a player that is used to connect [Body, bodies]. There are multiple scriptable joint types:  
--- - The <strong>bearing</strong> allows two bodies to revolve freely around each other. (See [Interactable.getBearings])
--- - The <strong>piston</strong> extends and contracts to change the distance between two bodies. (See [Interactable.getPistons])
sm.joint = {}

---"bearing"A bearing part.  
---"piston"A piston part.  
sm.joint.types = {"bearing", "piston"}


---Information about projectiles are located in `/Data/Projectiles/projectiles.json`.  
sm.projectile = {}

---*Server only*  
---@deprecated Name is deprecated, use uuid instead
---Perform a customized projectile attack  
---@param userdata table The custom user data
---@param name string The projectile's name.
---@param damage integer The damage the projectile will inflict.
---@param position Vec3 The start position in world space.
---@param velocity Vec3 The direction and velocity.
---@param source Player|Unit The player that is the source of the projectile.
---@param fakePosThird? Vec3 The visual start position in third-person. (Defaults to position)
---@param fakePosFirst? Vec3 The visual start position in first-person. (Defaults to position)
---@param delay? integer The number of ticks before firing. (Defaults to 0)
function sm.projectile.customProjectileAttack(userdata, name, damage, position, velocity, source, fakePosThird, fakePosFirst, delay) end

---*Server only*  
---Perform a customized projectile attack  
---@param userdata table The custom user data
---@param uuid Uuid The projectile's uuid.
---@param damage integer The damage the projectile will inflict.
---@param position Vec3 The start position in world space.
---@param velocity Vec3 The direction and velocity.
---@param source Player|Unit The player that is the source of the projectile.
---@param fakePosThird? Vec3 The visual start position in third-person. (Defaults to position)
---@param fakePosFirst? Vec3 The visual start position in first-person. (Defaults to position)
---@param delay? integer The number of ticks before firing. (Defaults to 0)
function sm.projectile.customProjectileAttack(userdata, uuid, damage, position, velocity, source, fakePosThird, fakePosFirst, delay) end

---@deprecated Name is deprecated, use uuid instead
---Returns the mass of a projectile.  
---@param name string The projectile's name.
---@return number
function sm.projectile.getProjectileMass(name) end

---Returns the mass of a projectile.  
---@param uuid Uuid The projectile's uuid.
---@return number
function sm.projectile.getProjectileMass(uuid) end

---*Server only*  
---@deprecated Name is deprecated, use uuid instead
---Perform a customized projectile attack  
---@param userdata table The custom user data
---@param name string The projectile's name.
---@param damage integer The damage the projectile will inflict.
---@param position Vec3 The start position in world space.
---@param velocity Vec3 The direction and velocity.
---@param source Harvestable The harvestable that is the source of the projectile.
---@param delay? integer The number of ticks before firing. (Defaults to 0)
function sm.projectile.harvestableCustomProjectileAttack(userdata, name, damage, position, velocity, source, delay) end

---*Server only*  
---Perform a customized projectile attack  
---@param userdata table The custom user data
---@param uuid Uuid The projectile's uuid.
---@param damage integer The damage the projectile will inflict.
---@param position Vec3 The start position in world space.
---@param velocity Vec3 The direction and velocity.
---@param source Harvestable The harvestable that is the source of the projectile.
---@param delay? integer The number of ticks before firing. (Defaults to 0)
function sm.projectile.harvestableCustomProjectileAttack(userdata, uuid, damage, position, velocity, source, delay) end

---@deprecated Name is deprecated, use uuid instead
---Perform a projectile attack  
---@param name string The projectile's name.
---@param damage integer The damage the projectile will inflict.
---@param position Vec3 The start position in world space.
---@param velocity Vec3 The direction and velocity.
---@param source Harvestable The [Harvestable] that is the source of the projectile.
---@param delay? integer The number of ticks before firing. (Defaults to 0)
function sm.projectile.harvestableProjectileAttack(name, damage, position, velocity, source, delay) end

---Perform a projectile attack  
---@param uuid Uuid The projectile's uuid.
---@param damage integer The damage the projectile will inflict.
---@param position Vec3 The start position in world space.
---@param velocity Vec3 The direction and velocity.
---@param source Harvestable The [Harvestable] that is the source of the projectile.
---@param delay? integer The number of ticks before firing. (Defaults to 0)
function sm.projectile.harvestableProjectileAttack(uuid, damage, position, velocity, source, delay) end

---*Client only*  
---@deprecated Name is deprecated, use uuid instead
---Creates and fires a projectile from a player.  
---The projectile is normally fired from the player's position, but due to the weapon being held off-center it may require a fake position for where the projectile appears to be fired from.  
---@param name string The projectile's name.
---@param position Vec3 The start position.
---@param velocity Vec3 The direction and velocity.
---@param fakePosThird? Vec3 The visual start position in third-person. (Defaults to position)
---@param fakePosFirst? Vec3 The visual start position in first-person. (Defaults to position)
---@param delay? integer The number of ticks before firing. (Defaults to 0)
function sm.projectile.playerFire(name, position, velocity, fakePosThird, fakePosFirst, delay) end

---*Client only*  
---Creates and fires a projectile from a player.  
---The projectile is normally fired from the player's position, but due to the weapon being held off-center it may require a fake position for where the projectile appears to be fired from.  
---@param uuid Uuid The projectile's uuid.
---@param position Vec3 The start position.
---@param velocity Vec3 The direction and velocity.
---@param fakePosThird? Vec3 The visual start position in third-person. (Defaults to position)
---@param fakePosFirst? Vec3 The visual start position in first-person. (Defaults to position)
---@param delay? integer The number of ticks before firing. (Defaults to 0)
function sm.projectile.playerFire(uuid, position, velocity, fakePosThird, fakePosFirst, delay) end

---@deprecated Name is deprecated, use uuid instead
---Perform a projectile attack  
---@param name string The projectile's name.
---@param damage integer The damage the projectile will inflict.
---@param position Vec3 The start position.
---@param velocity Vec3 The direction and velocity.
---@param source Player|Unit The Unit that is the source of the projectile.
---@param fakePosThird? Vec3 The visual start position in third-person. (Defaults to position)
---@param fakePosFirst? Vec3 The visual start position in first-person. (Defaults to position)
---@param delay? integer The number of ticks before firing. (Defaults to 0)
function sm.projectile.projectileAttack(name, damage, position, velocity, source, fakePosThird, fakePosFirst, delay) end

---Perform a projectile attack  
---@param uuid Uuid The projectile's uuid.
---@param damage integer The damage the projectile will inflict.
---@param position Vec3 The start position.
---@param velocity Vec3 The direction and velocity.
---@param source Player|Unit The player that is the source of the projectile.
---@param fakePosThird? Vec3 The visual start position in third-person. (Defaults to position)
---@param fakePosFirst? Vec3 The visual start position in first-person. (Defaults to position)
---@param delay? integer The number of ticks before firing. (Defaults to 0)
function sm.projectile.projectileAttack(uuid, damage, position, velocity, source, fakePosThird, fakePosFirst, delay) end

---*Server only*  
---@deprecated Name is deprecated, use uuid instead
---Perform a customized projectile attack  
---@param userdata table The custom user data
---@param name string The projectile's name.
---@param damage integer The damage the projectile will inflict.
---@param position Vec3 The start position in the shape's local space.
---@param velocity Vec3 The direction and velocity.
---@param source Shape The shape that is the source of the projectile.
---@param delay? integer The number of ticks before firing. (Defaults to 0)
function sm.projectile.shapeCustomProjectileAttack(userdata, name, damage, position, velocity, source, delay) end

---*Server only*  
---Perform a customized projectile attack  
---@param userdata table The custom user data
---@param uuid Uuid The projectile's uuid.
---@param damage integer The damage the projectile will inflict.
---@param position Vec3 The start position in the shape's local space.
---@param velocity Vec3 The direction and velocity.
---@param source Shape The shape that is the source of the projectile.
---@param delay? integer The number of ticks before firing. (Defaults to 0)
function sm.projectile.shapeCustomProjectileAttack(userdata, uuid, damage, position, velocity, source, delay) end

---*Server only*  
---@deprecated Name is deprecated, use uuid instead
---Creates and fires a projectile from a [Shape].  
---@param shape Shape The shape.
---@param name string The projectile's name.
---@param position Vec3 The start position.
---@param velocity Vec3 The direction and velocity.
---@param delay? integer The number of ticks before firing. (Defaults to 0)
function sm.projectile.shapeFire(shape, name, position, velocity, delay) end

---*Server only*  
---Creates and fires a projectile from a [Shape].  
---@param shape Shape The shape.
---@param uuid Uuid The projectile's uuid.
---@param position Vec3 The start position.
---@param velocity Vec3 The direction and velocity.
---@param delay? integer The number of ticks before firing. (Defaults to 0)
function sm.projectile.shapeFire(shape, uuid, position, velocity, delay) end

---@deprecated Name is deprecated, use uuid instead
---Perform a projectile attack  
---@param name string The projectile's name.
---@param damage integer The damage the projectile will inflict.
---@param position Vec3 The start position in the shape's local space.
---@param velocity Vec3 The direction and velocity.
---@param source Shape The shape that is the source of the projectile.
---@param delay? integer The number of ticks before firing. (Defaults to 0)
function sm.projectile.shapeProjectileAttack(name, damage, position, velocity, source, delay) end

---Perform a projectile attack  
---@param uuid Uuid The projectile's uuid.
---@param damage integer The damage the projectile will inflict.
---@param position Vec3 The start position in the shape's local space.
---@param velocity Vec3 The direction and velocity.
---@param source Shape The shape that is the source of the projectile.
---@param delay? integer The number of ticks before firing. (Defaults to 0)
function sm.projectile.shapeProjectileAttack(uuid, damage, position, velocity, source, delay) end

---Calculate the ballistic arc of a projectile. There are two potential solutions to the problem.   
---One with a low fire angle and one with a high fire angle. Solutions can be nil if no solution is found.  
---@param firePos Vec3 The position the projectile is fired from.
---@param targetPos Vec3 The position the projectile should hit.
---@param velocity number The fire velocity of the projectile.
---@param gravity number The gravity ( positive down ).
---@return Vec3, Vec3
function sm.projectile.solveBallisticArc(firePos, targetPos, velocity, gravity) end


---Information about melee attacks are located in `/Data/Melee/attacks.json`.  
sm.melee = {}

---@deprecated Name is deprecated, use uuid instead
---Perform a melee attack  
---@param name string The name of the melee attack.
---@param damage integer The damage the attack will inflict.
---@param origin Vec3 The source position of the attack.
---@param directionRange Vec3 The direction and reach of the attack.
---@param source Player The player that is the source of the attack.
---@param delay? integer The number of ticks before performing the attack. (Defaults to 0)
---@param power? number The strength of the knockback power.
function sm.melee.meleeAttack(name, damage, origin, directionRange, source, delay, power) end

---@deprecated Name is deprecated, use uuid instead
---Perform a melee attack  
---@param name string The name of the melee attack.
---@param damage integer The damage the attack will inflict.
---@param origin Vec3 The source position of the attack.
---@param directionRange Vec3 The direction and reach of the attack.
---@param source Unit The unit that is the source of the attack.
---@param delay? integer The number of ticks before performing the attack. (Defaults to 0)
---@param power? number The strength of the knockback power.
function sm.melee.meleeAttack(name, damage, origin, directionRange, source, delay, power) end

---Perform a melee attack  
---@param uuid Uuid The uuid of the melee attack.
---@param damage integer The damage the attack will inflict.
---@param origin Vec3 The source position of the attack.
---@param directionRange Vec3 The direction and reach of the attack.
---@param source Player The player that is the source of the attack.
---@param delay? integer The number of ticks before performing the attack. (Defaults to 0)
---@param power? number The strength of the knockback power.
function sm.melee.meleeAttack(uuid, damage, origin, directionRange, source, delay, power) end

---Perform a melee attack  
---@param uuid Uuid The uuid of the melee attack.
---@param damage integer The damage the attack will inflict.
---@param origin Vec3 The source position of the attack.
---@param directionRange Vec3 The direction and reach of the attack.
---@param source Unit The unit that is the source of the attack.
---@param delay? integer The number of ticks before performing the attack. (Defaults to 0)
---@param power? number The strength of the knockback power.
function sm.melee.meleeAttack(uuid, damage, origin, directionRange, source, delay, power) end


---A <strong>Creation</strong> represent a collection of [sm.body, bodies] linked together by [sm.joint, joints].  
sm.creation = {}

---*Server only*  
---Exports creation to blueprint formatted json string.  
---@param body Body Any body in the creation.
---@param exportTransforms? boolean Export the current world transform of bodies. Defaults to false.
---@param forceDynamic? boolean Force export to dynamic bodies. Defaults to false.
---@return string
function sm.creation.exportToString(body, exportTransforms, forceDynamic) end

---*Server only*  
---Exports creation to blueprint lua table.  
---@param body Body Any body in the creation.
---@param exportTransforms? boolean Export the current world transform of bodies. Defaults to false.
---@param forceDynamic? boolean Force export to dynamic bodies. Defaults to false.
---@return table
function sm.creation.exportToTable(body, exportTransforms, forceDynamic) end

---*Server only*  
---Imports blueprint json file to world.  
---**Warning:**
---*If the blueprint was not exported with transforms the importer will treat it as if importTransforms was disabled.*
---@param world World The world to import to.
---@param pathString string The blueprint path.
---@param worldPosition? Vec3 World position of import. If importTransforms is enabled position is applied to the imported transform. (Defaults to vec3.zero().)
---@param worldRotation? Quat World rotation of import. If importTransforms is enabled rotation is applied to the imported transform. (Defaults to quat.identity().)
---@param importTransforms? boolean Import world transforms from bodies. (Defaults to false.)
---@param indestructible? boolean (DEPRECATED) Ignored, use setDestructable(false) on each body in creation.
---@return Body[]
function sm.creation.importFromFile(world, pathString, worldPosition, worldRotation, importTransforms, indestructible) end

---*Server only*  
---Imports blueprint json string to world.  
---**Warning:**
---*If the blueprint was not exported with transforms the importer will treat it as if importTransforms was disabled.*
---@param world World The world to import to.
---@param jsonString string The blueprint json string.
---@param worldPosition? Vec3 World position of import. If importTransforms is enabled position is applied to the imported transform. (Defaults to vec3.zero().)
---@param worldRotation? Quat World rotation of import. If importTransforms is enabled rotation is applied to the imported transform. (Defaults to quat.identity().)
---@param importTransforms? boolean Import world transforms from bodies. (Defaults to false.)
---@param forceInactive? boolean Import interactables in an inactive state. (Defaults to false.)
---@return table
function sm.creation.importFromString(world, jsonString, worldPosition, worldRotation, importTransforms, forceInactive) end


---The <strong>cell</strong> api exposes and expands on parts of the world loading process.  
---These methods are commonly called from cell loading callbacks in World type scripts.  
sm.cell = {}

---*Server only*  
---Returns a table of [sm.harvestable, harvestables] of a given size for a cell coordinate.  
---Sizes are:  
---0: Tiny - plants and crops.  
---1: Small - small trees and rocks.  
---2: Medium - medium trees, visible at a long distance.  
---3: Large - large trees, visible at a very long distance.  
---@param x integer The X-coordinate.
---@param y integer The Y-coordinate.
---@param size? integer Size of harvestable (defaults to any size).
---@return Harvestable[]
function sm.cell.getHarvestables(x, y, size) end

---*Server only*  
---Returns a table of [sm.interactable, interactables] which matches any of the given [sm.uuid, uuids] for a cell coordinate.  
---**Note:**
---*Can only be used in a server_onCellLoaded callback.*
---@param x integer The X-coordinate.
---@param y integer The Y-coordinate.
---@param uuids table A table {[Uuid], ...} of uuids to match interactables against.
---@return Interactable[]
function sm.cell.getInteractablesByAnyUuid(x, y, uuids) end

---*Server only*  
---Returns a table of [sm.interactable, interactables] which contain the given tag for a cell coordinate.  
---**Note:**
---*Can only be used in a server_onCellLoaded callback.*
---@param x integer The X-coordinate.
---@param y integer The Y-coordinate.
---@param tags table A table {string, ...} of tags to match with.
---@return Interactable[]
function sm.cell.getInteractablesByTag(x, y, tags) end

---*Server only*  
---Returns a table of [sm.interactable, interactables] which contain all of the given tags for a cell coordinate.  
---**Note:**
---*Can only be used in a server_onCellLoaded callback*
---@param x integer The X-coordinate
---@param y integer The Y-coordinate
---@param tags table A table {string, ...} of tags to match with.
---@return Interactable[]
function sm.cell.getInteractablesByTags(x, y, tags) end

---*Server only*  
---Returns a table of [sm.interactable, interactables] of a given [sm.uuid, uuid] for a cell coordinate.  
---**Note:**
---*Can only be used in a server_onCellLoaded callback.*
---@param x integer The X-coordinate.
---@param y integer The Y-coordinate.
---@param uuid Uuid The uuid of the interactable(s)
---@return Interactable[]
function sm.cell.getInteractablesByUuid(x, y, uuid) end

---@class NodeParams
---@field name string
---@field connections table

---@class Node
---@field scale Vec3
---@field tags string[]
---@field position Vec3
---@field params NodeParams
---@field rotation Quat

---Returns a table of nodes which contains the given tag for a cell coordinate.  
---@param x integer X-coordinate.
---@param y integer Y-coordinate.
---@param tag string Tag to match with.
---@return Node[]
function sm.cell.getNodesByTag(x, y, tag) end

---Returns a table of nodes which contain all of the given tags for a cell coordinate.  
---@param x integer X-coordinate.
---@param y integer Y-coordinate.
---@param tags table A table {string, ...} of tags to match with.
---@return Node[]
function sm.cell.getNodesByTags(x, y, tags) end

---Returns a table of tags for a cell coordinate.  
---@param x integer X-coordinate
---@param y integer Y-coordinate
---@return string[]
function sm.cell.getTags(x, y) end


---A <strong>container</strong> keeps track of items and stores them in slots. Each slot holds one item type and a quantity, if the item is stackable.  
sm.container = {}

---*Server only*  
---Aborts a transaction.  
function sm.container.abortTransaction() end

---*Server only*  
---Starts a new <em>transaction</em> shared across all containers. A transaction is a collection of all changes of container items will be collected and processed  
---A transaction must be ended with [sm.container.endTransaction].  
---@return boolean
function sm.container.beginTransaction() end

---*Server only*  
---Adds a quantity of a given item to a container.  
---@param container Container The container.
---@param itemUuid Uuid The uuid of the item.
---@param quantity integer The number of items.
---@param mustCollectAll? boolean Must collect all items for the transaction to be valid. Defaults to true. (Optional)
---@return integer
function sm.container.collect(container, itemUuid, quantity, mustCollectAll) end

---*Server only*  
---Performs a [sm.container.collect] operation to a specific slot.  
---@param container Container The container.
---@param slot integer The container slot.
---@param itemUuid Uuid The uuid of the item to be added.
---@param quantity integer The number of items to be added.
---@param mustCollectAll? boolean If true, only add items if there is enough room. If false, add as many items as possible. Defaults to true. (Optional)
---@return integer
function sm.container.collectToSlot(container, slot, itemUuid, quantity, mustCollectAll) end

---*Server only*  
---Ends a transaction.  
---@return boolean
function sm.container.endTransaction() end

---Returns a table containing item uuid, quantity (and instance id for tools) at first available slot  
---@param container Container The container.
---@return Item
function sm.container.getFirstItem(container) end

---Returns a table containing all item uuids in a container.  
---@param container Container The container.
---@return Uuid[]
function sm.container.itemUuid(container) end

---*Server only*  
---Moves the content from one container to another.  
---@param container Container The source container.
---@param container Container The destination container.
---@param moveAll? boolean If true, requires that all items can be moved. 
function sm.container.moveAll(container, container, moveAll) end

---*Server only*  
---Moves the content of input container to the player carry container and assigns the carry color.  
---@param container Container The container to assign.
---@param player Player The player to receive the carry content and color.
---@param color Color The color to assign.
function sm.container.moveAllToCarryContainer(container, player, color) end

---Returns a table containing all item quantities in a container.  
---@param container Container The container.
---@return number[]
function sm.container.quantity(container) end

---*Server only*  
---Removes a quantity of a given item from a container.  
---@param container Container The container.
---@param itemUuid Uuid The uuid of the item.
---@param quantity integer The number of items.
---@param mustSpendAll? boolean If true, only remove items if there are enough. If false, remove as many items as possible. Defaults to true. (Optional)
---@return integer spentAmount The amount of spent items
function sm.container.spend(container, itemUuid, quantity, mustSpendAll) end

---*Server only*  
---Performs a [sm.container.spend] operation from a specific slot.   
---@param container Container The container.
---@param slot integer The container slot.
---@param itemUuid Uuid The uuid of the item to be removed.
---@param quantity integer The number of items to be removed.
---@param mustSpendAll? boolean If true, only remove items if there are enough. If false, remove as many items as possible. Defaults to true. (Optional)
---@return integer
function sm.container.spendFromSlot(container, slot, itemUuid, quantity, mustSpendAll) end

---*Server only*  
---Swaps two item slots.  
---@param fromContainer Container The first container.
---@param toContainer Container The second container.
---@param fromSlot integer The first slot
---@param toSlot integer The second slot
---@return boolean
function sm.container.swap(fromContainer, fromSlot, toContainer, toSlot) end

---Returns the total number of a given item uuid in a container.  
---@param container Container The container.
---@param itemUuid Uuid The uuid of the item.
---@return integer
function sm.container.totalQuantity(container, itemUuid) end


---AI utility functions.  
sm.ai = {}

---Check if the unit can reach the target position by moving straight.  
---@param unit Unit The unit.
---@param position Vec3 The target position.
---@param maxDistance? number The max distance.
---@return boolean
function sm.ai.directPathAvailable(unit, position, maxDistance) end

---Returns true if the character can fire at the target harvestable within a given fire lane.  
---Also returns the aim position that allows the character to succeed.  
---@param self Character The firing character.
---@param target Harvestable The target harvestable.
---@param range number The maximum firing distance.
---@param width number The width of the fire lane.
---@return boolean,Vec3
function sm.ai.getAimPosition(self, target, range, width) end

---Returns true if the character can fire at the target character within a given fire lane.  
---Also returns the aim position that allows the character to succeed.  
---@param self Character The firing character.
---@param target Character The target character.
---@param range number The maximum firing distance.
---@param width number The width of the fire lane.
---@return boolean,Vec3
function sm.ai.getAimPosition(self, target, range, width) end

---Check if there's an attackable object between the unit and a position.  
---@param unit Unit The unit.
---@param position Vec3 The target position.
---@param range number The distance.
---@param attack integer The possible attack level from the breacher.
---@return boolean,Vec3|nil,Shape|Harvestable|Lift|nil
function sm.ai.getBreachablePosition(unit, position, range, attack) end

---Find the closest harvestable of 'tree' type in a world.  
---@param position Vec3 The world position to search around.
---@param world? World The world to search in. (Defaults to the world of the script that is calling the function)
---@return Harvestable
function sm.ai.getClosestTree(position, world) end

---Returns the character of a given uuid type that is closest to the unit.  
---@param unit Unit The unit.
---@param uuid Uuid The character uuid.
---@return Character
function sm.ai.getClosestVisibleCharacterType(unit, uuid) end

---Returns the farming harvestable that is closest to the unit.  
---@param unit Unit The unit.
---@return Harvestable
function sm.ai.getClosestVisibleCrop(unit) end

---Returns the character closest to the unit.  
---@param unit Unit The unit.
---@return Character
function sm.ai.getClosestVisiblePlayerCharacter(unit) end

---Returns the character, with an opposing color, closest to the unit.  
---@param unit Unit The unit.
---@param color Color The color.
---@return Character
function sm.ai.getClosestVisibleTeamOpponent(unit, color) end

---eturns a random position on a given body.  
---@param body Body The body.
---@return Vec3
function sm.ai.getRandomCreationPosition(body) end

---Check if the unit can reach the target position by moving along a path.  
---@param unit Unit The unit.
---@param position Vec3 The target position.
---@return boolean
function sm.ai.isReachable(unit, position) end


---A <strong>character</strong> is the physical body of a living entity in the world. Both <strong>players</strong> and <strong>units</strong> may control a character.  
sm.character = {}

---*Server only*  
---Creates a new character in a world.  
---@param player Player The player controlling the character.
---@param world World The world the character is created in.
---@param position Vec3 The world position of the character.
---@param yaw? number The initial yaw of the character (Optional).
---@param pitch? number The initial pitch of the character (Optional).
---@return Character
function sm.character.createCharacter(player, world, position, yaw, pitch) end

---*Client only*  
---Pre-loads renderable data to be used by the character. This eliminates excessive loading during run time.  
---@param renderables table The table of renderables { name = string, ... }.
function sm.character.preloadRenderables(renderables) end


---A <strong>player</strong> is a user playing the game. Every player controls a [Character] in the world.  
sm.player = {}

---Returns a table of all [Player, players] that are currently in the game.  
---@return Player[]
function sm.player.getAllPlayers() end


---An <strong>area trigger</strong> is an invisible collider in the world that can trigger events when objects move in or out of it. This allows the script to, for instance, detect when a character enters a door, or count the number of shapes there are in a room.  
---Example usage:  
---```
---	function MyClass.server_onCreate( self )
---		local size = sm.vec3.new( 1, 1, 1 )
---		local position = self.shape:getWorldPosition()
---
---		self.myArea = sm.areaTrigger.createBox( size, position )
---		self.myArea:bindOnEnter( "onEnter" )
---	end
---
---	function MyClass.onEnter( self, trigger, results )
---		for i, object in ipairs( results ) do
---			print( object, "just entered" )
---		end
---	end
---```
---Example with a filter:  
---```
---	function MyClass.server_onCreate( self )
---		local size = sm.vec3.new( 10, 10, 5 )
---		local position = sm.vec3.new( 50, 40, 30 )
---
---		-- Only detect characters
---		local filter = sm.areaTrigger.filter.character
---
---		self.myArea = sm.areaTrigger.createBox( size, position, filter )
---		self.myArea:bindOnStay( "onStay" )
---	end
---
---	-- Callback receives a list of characters
---	function MyClass.onStay( self, trigger, results )
---		if #results > 0 then
---			print( "Intruder alert!" )
---		end
---	end
---```
sm.areaTrigger = {}

---Filters are used to specify what object types an area trigger is able to detect. If an area trigger is created with a filter, it will <strong>only</strong> react to objects of that type. Filters can be combined by adding them.  
---The filters are:  
--- - <strong>dynamicBody</strong> &ndash; Detects [Body, bodies] that are free to move around in the world.
--- - <strong>staticBody</strong> &ndash; Detects [Body, bodies] that are built on the ground or on the lift.
--- - <strong>character</strong> &ndash; Detects [Character, characters] such as players.
--- - <strong>areatrigger</strong> &ndash; Detects [AreaTrigger, areatriggers] such as water areas.
--- - <strong>harvestable</strong> &ndash; Detects [Harvestable, harvestables] such as planted objects.
--- - <strong>lift</strong> &ndash; Detects [Lift, lifts].
--- - <strong>voxelTerrain</strong> &ndash; Detects destructible terrain.
--- - <strong>all</strong> &ndash; Detects all of the object types above. (Default)
---dynamicBody  
---staticBody  
---character  
---areatrigger  
---harvestable  
---lif  
---voxelTerrain
---all
sm.areaTrigger.filter = {
    dynamicBody = 1,
    staticBody = 2,
    character = 4,
    areatrigger = 8,
    harvestable = 512,
    lift = 1024,
    voxelTerrain = 32768,
    all = 34319
}

---Creates an area trigger box with a given size that stays attached to an [sm.interactable, interactable]  
---If a filter is specified, the trigger area will only be able to detects objects of that certain type. See [sm.areaTrigger.filter] for more information about filters.  
---@param interactable Interactable The host interactable
---@param dimension Vec3 The size of the box
---@param position? Vec3 The position offset (Defaults to [sm.vec3.zero])
---@param rotation? Quat The rotation offset (Defaults to [sm.quat.identity])
---@param filter? integer The object types the area trigger may detect. (See [sm.areaTrigger.filter]). (Defaults to sm.areaTrigger.filter.all)
---@param userdata? table An optional table of user data
---@return AreaTrigger
function sm.areaTrigger.createAttachedBox(interactable, dimension, position, rotation, filter, userdata) end

---Creates an area trigger sphere with a given size that stays attached to an [sm.interactable, interactable]  
---If a filter is specified, the trigger area will only be able to detects objects of that certain type. See [sm.areaTrigger.filter] for more information about filters.  
---@param interactable Interactable The host interactable
---@param radius number The radius of the sphere.
---@param position? Vec3 The position offset (Defaults to [sm.vec3.zero])
---@param rotation? Quat The rotation offset (Defaults to [sm.quat.identity])
---@param filter? integer The object types the area trigger may detect. (See [sm.areaTrigger.filter]). (Defaults to sm.areaTrigger.filter.all)
---@param userdata? table An optional table of user data
---@return AreaTrigger
function sm.areaTrigger.createAttachedSphere(interactable, radius, position, rotation, filter, userdata) end

---Creates a new box area trigger at a given position with a given size.  
---If a filter is specified, the trigger area will only be able to detects objects of that certain type. See [sm.areaTrigger.filter] for more information about filters.  
---@param dimension Vec3 The dimensions of the box.
---@param position Vec3 The world position.
---@param rotation? Quat The world rotation. (Defaults to [sm.quat.identity])
---@param filter? integer The object types the area trigger may detect. (See [sm.areaTrigger.filter]). (Defaults to sm.areaTrigger.filter.all)
---@param userdata? table An optional table of user data
---@return AreaTrigger
function sm.areaTrigger.createBox(dimension, position, rotation, filter, userdata) end

---Creates a new box area trigger that represent water ie. certain objects cant be placed in it.  
---If a filter is specified, the trigger area will only be able to detects objects of that certain type. See [sm.areaTrigger.filter] for more information about filters.  
---@param dimension Vec3 The dimensions of the box.
---@param position Vec3 The world position.
---@param rotation? Quat The world rotation. (Defaults to [sm.quat.identity])
---@param filter? integer The object types the area trigger may detect. (See [sm.areaTrigger.filter]). (Defaults to sm.areaTrigger.filter.all)
---@param userdata? table An optional table of user data
---@return AreaTrigger
function sm.areaTrigger.createBoxWater(dimension, position, rotation, filter, userdata) end

---Creates a new sphere area trigger at a given position with a given size.  
---If a filter is specified, the trigger area will only be able to detects objects of that certain type. See [sm.areaTrigger.filter] for more information about filters.  
---@param radius number The radius of the sphere.
---@param position Vec3 The world position.
---@param rotation? Quat The world rotation. (Defaults to [sm.quat.identity])
---@param filter? integer The object types the area trigger may detect. (See [sm.areaTrigger.filter]). (Defaults to sm.areaTrigger.filter.all)
---@param userdata? table An optional table of user data
---@return AreaTrigger
function sm.areaTrigger.createSphere(radius, position, rotation, filter, userdata) end

---Destroys an area trigger.  
---@param areaTrigger AreaTrigger The area trigger to be destroyed.
function sm.areaTrigger.destroy(areaTrigger) end


---Used to check the state of the game.  
sm.game = {}

---Binds a chat command to a callback function. The callback function receives an array of parameters. The first parameter is the command itself.  
---Example:  
---```
---sm.game.bindChatCommand( "/enable_client_toilet",
---						 { { "bool", "enabled", false } },
---						 "onChatCommand",
---						 "Enables or disables client toilet." )
---```
---```
---function MyGameScript.onChatCommand( self, params )
---	if params[1] == "/enable_client_toilet" then
---		self.settings.enable_client_toilet = params[2]
---	end
---end
---```
---@param command string The command.
---@param params table An array of parameters the callback function expects in the form of { { type, name, optional }, ... }. The first is the <strong>type</strong> name of the parameter as a string. Valid types are "bool", "int", "number" and "string". The second is the <strong>name</strong> in the help text. Defaults to automatic naming ("p1", "p2", "p3", ...). The third is a bool value where true means that this parameter is <strong>optional</strong>. Defaults to false.
---@param callback string The name of the Lua function to bind.
---@param help string Help text.
function sm.game.bindChatCommand(command, params, callback, help) end

---Return the current game tick.  
---@return integer
function sm.game.getCurrentTick() end

---Return the index of the current difficulty setting.  
---@return integer
function sm.game.getDifficulty() end

---Returns true if aggro is enabled and false if aggro is disabled.  
---@return boolean
function sm.game.getEnableAggro() end

---Returns true if ammo consumption is enabled and false if ammo consumption is disabled.  
---@return boolean
function sm.game.getEnableAmmoConsumption() end

---Returns true if fuel consumption is enabled and false if fuel consumption is disabled.  
---@return boolean
function sm.game.getEnableFuelConsumption() end

---Returns true if restrictions are enabled and false if restrictions are disabled.  
---@return boolean
function sm.game.getEnableRestrictions() end

---Returns true if upgrading is enabled and false if upgrading is disabled.  
---@return boolean
function sm.game.getEnableUpgrade() end

---Return limited inventory state. If true the items are limited, if false the items are unlimited.  
---@return boolean
function sm.game.getLimitedInventory() end

---Return estimated game tick on the server.  
---@return integer
function sm.game.getServerTick() end

---Return the fraction value of how far the current day has progressed.  
---@return number
function sm.game.getTimeOfDay() end

---*Server only*  
---Enables and disables aggro. If true, player's will be detected as targets.  
---@param enableAggro boolean The enable state.
function sm.game.setEnableAggro(enableAggro) end

---*Server only*  
---Enables and disables ammo consumption. If true, ammo will be required to shoot spudguns.  
---@param enableAmmoConsumption boolean The enable state.
function sm.game.setEnableAmmoConsumption(enableAmmoConsumption) end

---*Server only*  
---Enables and disables fuel consumption. If true, fuel will be consumed from engines.  
---@param enableFuelConsumption boolean The enable state.
function sm.game.setEnableFuelConsumption(enableFuelConsumption) end

---*Server only*  
---Enables and disables the use of restrictions. If true restrictions will be applied, if false the restrictions will default to unrestricted.  
---@param enableRestrictions boolean Restrictions enable state.
function sm.game.setEnableRestrictions(enableRestrictions) end

---*Server only*  
---Enables and disables upgrade. If true, the [Interactable] can be upgraded with component kits.  
---@param enableUpgrade boolean The enable state.
function sm.game.setEnableUpgrade(enableUpgrade) end

---*Server only*  
---Sets limited inventory. If true the items are limited, if false the items are unlimited.  
---@param isLimited boolean Is limited.
function sm.game.setLimitedInventory(isLimited) end

---*Client only*  
---Sets the fraction value of how far the current day has progressed.  
---@param time number The fraction of the day cycle.
function sm.game.setTimeOfDay(time) end


---The <strong>world</strong> api handles the creation and destruction of worlds.  
---A world contains the terrain and simulates the physics environment in which other game objects can exist.  
sm.world = {}

---Predefined special world ids  
---anyWorld  
---noWorld  
sm.world.ids = {
    anyWorld = 65535,
    noWorld = 65534
}

---*Server only*  
---Creates a new world object. Can only be called from inside the Game script environment.  
---@param filename string The world script filename.
---@param classname string The world script class name.
---@param terrainParams? any The world's terrain parameters. (Optional)
---@param seed? integer The world's seed. Defaults to 0 (Optional)
---@return World
function sm.world.createWorld(filename, classname, terrainParams, seed) end

---Get the world that the scripted object is in.  
---@return World
function sm.world.getCurrentWorld() end

---Returns an array of tables representing spheres where something has changed in the world.  
---The optional position and radius parameters will construct a sphere, and use it as a filter to only show results that intersect that sphere.  
---@param position? Vec3 The world position of the sphere. (Optional)
---@param radius? number The radius of the sphere. (Optional)
---@return table
function sm.world.getDirtySpheres(position, radius) end

---*Server only*  
---Gets a previously saved creative world  
---@return World
function sm.world.getLegacyCreativeWorld() end

---*Server only*  
---Loads a previously created world. Can only be called from inside the Game script environment.  
---@param world World The world that should be loaded.
---@return boolean
function sm.world.loadWorld(world) end


---Events for communicating between scripts by running callbacks.  
sm.event = {}

---Sends an event to a specified [Character].  
---@param character Character The character.
---@param callback string The function name in a character script.
---@param args? any Optional arguments to be sent to the callback.
---@return boolean
function sm.event.sendToCharacter(character, callback, args) end

---Sends an event to the game script.  
---@param callback string The function name in the game script.
---@param args? any Optional arguments to be sent to the callback.
---@return boolean
function sm.event.sendToGame(callback, args) end

---Sends an event to a specified [Harvestable].  
---@param harvestable Harvestable The harvestable.
---@param callback string The function name in a harvestable script.
---@param args? any Optional arguments to be sent to the callback.
---@return boolean
function sm.event.sendToHarvestable(harvestable, callback, args) end

---Sends an event to a specified [Interactable].  
---@param interactable Interactable The interactable.
---@param callback string The function name in a interactable script.
---@param args? any Optional arguments to be sent to the callback.
---@return boolean
function sm.event.sendToInteractable(interactable, callback, args) end

---Sends an event to a specified [Player].  
---@param player Player The player.
---@param callback string The function name in a player script.
---@param args? any Optional arguments to be sent to the callback.
---@return boolean
function sm.event.sendToPlayer(player, callback, args) end

---Sends an event to a specified [ScriptableObject].
---@param scriptableObject ScriptableObject The scriptableObject.
---@param callback string The function name in a scriptableObject script.
---@param args? any Optional arguments to be sent to the callback.
---@return boolean
function sm.event.sendToScriptableObject(scriptableObject, callback, args) end

---Sends an event to a specified [Tool].  
---@param tool Tool The tool.
---@param callback string The function name in a tool script.
---@param args? any Optional arguments to be sent to the callback.
---@return boolean
function sm.event.sendToTool(tool, callback, args) end

---Sends an event to a specified [Unit].  
---@param unit Unit The unit.
---@param callback string The function name in a unit script.
---@param args? any Optional arguments to be sent to the callback.
---@return boolean
function sm.event.sendToUnit(unit, callback, args) end

---Sends an event to a specified [World].  
---@param world World The world.
---@param callback string The function name in a world script.
---@param args? any Optional arguments to be sent to the callback.
---@return boolean
function sm.event.sendToWorld(world, callback, args) end


---Allows checking for static infortmation about items.  
sm.item = {}

---@class CharacterShape
---@field placementSphereRadius number
---@field characterUuid string UUID string of the character

---Return the data for the character [Shape].  
---@param uuid Uuid The shape uuid.
---@return CharacterShape
function sm.item.getCharacterShape(uuid) end


---@class Edible
---@field hpGain? number
---@field foodGain? number
---@field waterGain? number

---Return the data for the edible [Shape].  
---@param uuid Uuid The shape uuid.
---@return Edible?
function sm.item.getEdible(uuid) end


---@class FeatureData
---@field filename string
---@field classname string
---@field data table
---@field tag string

---Returns the data in the scripted section of the object's json declaration.  
---@param uuid Uuid The item uuid.
---@return FeatureData
function sm.item.getFeatureData(uuid) end

---Returns a table of all [Interactable, interactable] [Uuid, uuids] of a interactable type  
---@param interactableType string The interactable type name
---@return Uuid[]
function sm.item.getInteractablesUuidsOfType(interactableType) end


---@class Plantable
---@field harvestable string UUID string of the planted harvestable

---Return the data for the plantable [Shape].  
---@param uuid Uuid The shape uuid.
---@return Plantable
function sm.item.getPlantable(uuid) end

---Returns a table of all plantable [Uuid, uuids].  
---@return Uuid[]
function sm.item.getPlantableUuids() end

---Return the quality level for the [Shape].  
---@param uuid Uuid The shape uuid.
---@return integer
function sm.item.getQualityLevel(uuid) end

---Returns the default color of a shape  
---@param uuid Uuid The item uuid.
---@return Color
function sm.item.getShapeDefaultColor(uuid) end

---Return the [Shape] offset  
---@param uuid Uuid The shape uuid.
---@return Vec3
function sm.item.getShapeOffset(uuid) end

---Returns the block dimensions of an shape  
---@param uuid Uuid The item uuid.
---@return Vec3
function sm.item.getShapeSize(uuid) end

---Check if the item is a block.  
---@param uuid Uuid The item uuid.
---@return boolean
function sm.item.isBlock(uuid) end

---Return whether the [Shape] uuid belongs to a harvestable shape.  
---@param uuid Uuid The shape uuid.
---@return boolean
function sm.item.isHarvestablePart(uuid) end

---Check if the item is a [Joint].  
---@param uuid Uuid The item uuid.
---@return boolean
function sm.item.isJoint(uuid) end

---Check if the item is a part.  
---@param uuid Uuid The item uuid.
---@return boolean
function sm.item.isPart(uuid) end

---Check if the item uuid belongs to a [Tool].  
---@param uuid Uuid The uuid.
---@return boolean
function sm.item.isTool(uuid) end

---Check if the item is a blueprint shape.  
---@param uuid Uuid The uuid.
---@return boolean
function sm.item.isBlueprintShape(uuid) end

---The <strong>Challenge</strong> api contains functions related to the Challenge game mode.  
sm.challenge = {}

---*Server only*  
---Retrieve challenge completion time.  
---@param level Uuid The level's uuid.
---@return number
function sm.challenge.getCompletionTime(level) end

---*Server only*  
---Retrieve challenge level save data.  
---@param level Uuid The level's uuid.
---@return table
function sm.challenge.getSaveData(level) end

---*Server only*  
---Check if a challenge has started  
---@return boolean
function sm.challenge.hasStarted() end

---*Client only*  
---Returns true if the current content is the master mechanic trial pack.  
---@return boolean
function sm.challenge.isMasterMechanicTrial() end

---*Server only*  
---Completes a challenge level and saves progression.  
---@param level Uuid The level's uuid.
---@param time number The completion time.
---@param save table A table containing save data.
function sm.challenge.levelCompleted(level, time, save) end

---*Server only*  
---Resolves a path containing $CONTENT_DATA to path that can be accessed in the main scripting environment.  
---@param path string The path containing $CONTENT_DATA.
---@return string
function sm.challenge.resolveContentPath(path) end

---*Server only*  
---Starts challenge.  
function sm.challenge.start() end

---*Server only*  
---Stops challenge.  
function sm.challenge.stop() end

---*Server only*  
---Takes a picture of the challenge level with a custom resolution.  
---@param width integer Preview width.
---@param height integer Preview height.
---@param rotation integer Rotation step.
function sm.challenge.takePicture(width, height, rotation) end

---*Server only*  
---Takes pictures of the challenge level to use as icon and preview.  
---@param rotation integer Rotation step.
function sm.challenge.takePicturesForMenu(rotation) end


---Used to save and load blueprints displayed in the menu.  
sm.menuCreation = {}

---*Server only*  
---Loads the users menu creation blueprint and returns it as a table.  
---@return table
function sm.menuCreation.load() end

---*Server only*  
---Saves the users menu creation blueprint.  
function sm.menuCreation.save() end


---A <strong>portal</strong> moves objects inside a box to another box in another place.  
sm.portal = {}

---*Server only*  
---Adds a hook that a new world can find to hook up the other side of a portal.  
---@param world World The target world.
---@param name string The portal name.
---@param portal Portal The portal.
function sm.portal.addWorldPortalHook(world, name, portal) end

---*Server only*  
---Creates a new portal.  
---@param dimensions Vec3 The dimensions of the portal box.
---@return Portal
function sm.portal.createPortal(dimensions) end

---*Server only*  
---Destroys a portal.  
---@param portal Portal The portal to be destroyed.
function sm.portal.destroy(portal) end

---*Server only*  
---Finds and pops world hook for this world if present.  
---@param name string The portal name.
---@return Portal
function sm.portal.popWorldPortalHook(name) end


sm.harvestable = {}

---*Server only*  
---Create a new harvestable  
---@param uuid Uuid The uuid of the harvestable.
---@param position Vec3 The harvestable's world position.
---@param rotation? Quat The harvestable's world rotation, optional uses identity rotation if nil.
---@param slopeNormal? Vec3 The harvestable's slope normal. For "skew" and "rotate" slope settings, optional uses z axis if nil.
---@return Harvestable
function sm.harvestable.create(uuid, position, rotation, slopeNormal) end

---*Server only*  
---Create a new harvestable  
---@param uuid Uuid The uuid of the harvestable.
---@param position Vec3 The harvestable's world position.
---@param rotation? Quat The harvestable's world rotation, optional uses identity rotation if nil.
---@param slopeNormal? Vec3 The harvestable's slope normal. For "skew" and "rotate" slope settings, optional uses z axis if nil.
---@return Harvestable
function sm.harvestable.createHarvestable(uuid, position, rotation, slopeNormal) end


---The <strong>Construction</strong> api is used for interacting with the shape construction system.   
sm.construction = {}

---Constants used by the construction system.  
--- - <strong>subdivideRatio</strong> &ndash; The physical size of one block.
--- - <strong>subdivideRatio_2</strong> &ndash; The physical size of one block divided by two.
--- - <strong>subdivisions</strong> &ndash; One dividided by subdivideRatio.
--- - <strong>shapeSpacing</strong> &ndash; Bias value.
---subdivideRatio0.25  
---subdivideRatio_20.125  
---subdivisions4  
---shapeSpacing0.004	  
sm.construction.constants = {
    shapeSpacing = 0.004,
    subdivideRatio = 0.25,
    subdivideRatio_2 = 0.125,
    subdivisions = 4
}

---*Server only*  
---Builds a block on a shape.  
---@param uuid Uuid The uuid of the block to build.
---@param localPosition Vec3 The position to build the block on.
---@param shape Shape The shape to build on.
function sm.construction.buildBlock(uuid, localPosition, shape) end

---*Server only*  
---Builds a block on a joint.  
---@param uuid Uuid The uuid of the block to build.
---@param localPosition Vec3 The position to build the block on.
---@param joint Joint The joint to build on.
function sm.construction.buildBlock(uuid, localPosition, joint) end

---*Server only*  
---Builds a block a lift.  
---@param uuid Uuid The uuid of the block to build.
---@param localPosition Vec3 The position to build the block on.
---@param lift Lift The lift to build on.
function sm.construction.buildBlock(uuid, localPosition, lift) end

---*Server only*  
---Builds a block on terrain.  
---@param uuid Uuid The uuid of the block to build.
---@param localPosition Vec3 The position to build the block on.
function sm.construction.buildBlock(uuid, localPosition) end

---Validates if a shape can be built on another shape.  
---@param uuid Uuid The uuid of the shape to validate.
---@param localPosition Vec3 The position local to the body.
---@param localNormal Vec3 The normal of the surface to validate placement.
---@param shape Shape The shape to build on.
---@return boolean
function sm.construction.validateLocalPosition(uuid, localPosition, localNormal, shape) end

---Validates if a shape can be built on another joint.  
---@param uuid Uuid The uuid of the shape to validate.
---@param localPosition Vec3 The position local to the body.
---@param localNormal Vec3 The normal of the surface to validate placement.
---@param joint Joint The joint to build on.
---@return boolean
function sm.construction.validateLocalPosition(uuid, localPosition, localNormal, joint) end

---Validates if a shape can be built on terrain.  
---@param uuid Uuid The uuid of the shape to validate.
---@param localPosition Vec3 The position local to the body.
---@param localNormal Vec3 The normal of the surface to validate placement.
---@return boolean
function sm.construction.validateLocalPosition(uuid, localPosition, localNormal) end


---ScriptableObject creation  
sm.scriptableObject = {}

---*Server only*  
---Create a new Scriptable Object.  
---@param uuid Uuid ScriptableObject uuid.
---@param params? any self.params on scriptable object.
---@param world? World The world this script belongs to, for world dependent api calls. Defaults to [sm.world.ids, sm.world.ids.noWorld]
---@return ScriptableObject
function sm.scriptableObject.createScriptableObject(uuid, params, world) end


---Builder Guide  
sm.builderGuide = {}

---Create a [BuilderGuide], comparing the creation from the root [Shape] to the blueprint given by the path.  
---@param path string A file path to the builder guide blueprint.
---@param shape Shape Root [Shape] for comparing the creation from.
---@param ignoreBlockUuid? boolean Should block uuid be ignored for stage completion. (Defaults to false)
---@return BuilderGuide
function sm.builderGuide.createBuilderGuide(path, shape, ignoreBlockUuid) end


---A [CullSphereGroup] is a collection of spheres, you can add or remove spheres and check for spheres within an inner and outer radius at a specified position.
sm.cullSphereGroup = {}

---Creates a new [CullSphereGroup].  
---@return CullSphereGroup
function sm.cullSphereGroup.newCullSphereGroup() end


---The <strong>effect</strong> api handles the creation and playing of audio and visual effects.  
---Effects can consist of multiple components each being of separate types and with unique offsets, rotations and delays.  
---For more information on how to setup effects please take a look in the Effects/Database/EffectSets folder in the game data.  
sm.effect = {}

---All the vanilla effect names that can be used with sm.effect functions. If the effect doesnt play, then the effect isnt present in the current gamemode. (Can be fixed by adding it to your effect set)
---@alias EffectName
---| "DestructableTape - TapeCorner"
---| "PropaneTank - ActivateBig"
---| "DestructableTape - TapeCornerBig"
---| "PropaneTank - ActivateSmall"
---| "DestructableTape - TapeRoll"
---| "DestructableTape - TapeRollBig"
---| "DestructableTape - cocoon01"
---| "DestructableTape - cocoon02"
---| "Explosion - Debris"
---| "PropaneTank - ExplosionSmall"
---| "PropaneTank - SingleActivate"
---| "Resourcecollector - PutIn"
---| "MountedPotatoRifle - Shoot"
---| "Resourcecollector - TakeOut"
---| "Beacon - Idle"
---| "Mountedwatercanon - Shoot"
---| "NoteTerminal - Active"
---| "BubbleBath"
---| "NoteTerminal - Interact"
---| "DestructableTape - DoorwayDestruction"
---| "PistonExhaust"
---| "PropaneTank - ExplosionBig"
---| "PowerSocket - Activate"
---| "DestructableTape - Tape"
---| "Collision - SlidingA"
---| "Collision - SlidingB"
---| "Projectile - Destroy"
---| "Weapon - Impact"
---| "Collision - Impact"
---| "Projectile - Hit"
---| "Sledgehammer - Destroy"
---| "Sledgehammer - Hit"
---| "Sledgehammer - NoProgress"
---| "Collision - RollingA"
---| "Collision - RollingB"
---| "Character - Hit"
---| "SledgehammerHit - Default"
---| "Projectile - HitWater"
---| "Multiknife - Hit"
---| "Multiknife - Complete"
---| "Mechanic - EatBaguette"
---| "PaintTool - NoAmmo"
---| "BearingDrill - Use"
---| "Eat - Drink"
---| "Eat - DrinkFinish"
---| "Eat - DrinkSound"
---| "Eat - EatFinish"
---| "Eat - Munch"
---| "Eat - MunchFP"
---| "Eat - MunchSound"
---| "PaintTool - Close"
---| "Itemtool - FPFertilizerUse"
---| "Mechanic - ReciveBaguette"
---| "PaintTool - Open"
---| "Itemtool - FertilizerUse"
---| "PaintTool - Paint"
---| "Multiknife - Use"
---| "Forest - SmallFog"
---| "Hideout - Smoke"
---| "Lakes - Floatingdebri"
---| "AtmosphericDust"
---| "ChallengeAmbience"
---| "Water - Waterleak01"
---| "ChemicalLakes - SurfaceBubblesBig"
---| "ChemicalLakes - SurfaceBubblesSmall"
---| "Critter - Butterfly01"
---| "Critter - Butterfly02"
---| "Critter - Fly"
---| "Critter - NightMoth"
---| "Critter - Rottingsmoke"
---| "OutdoorAmbience"
---| "Forest - Fireflies"
---| "Forest - Grassblowing"
---| "Water - Waterleak02"
---| "Forest - LeafsBlowing"
---| "Lakes - bubbles"
---| "Forest - MassiveFog"
---| "butterfly"
---| "flies01"
---| "flies02"
---| "Tree - CrownCollapse Pine"
---| "Tree - CrownCollapse Spurce"
---| "Tree - BreakTrunk Pine"
---| "Tree - BreakTrunk PineHalf"
---| "Tree - BreakTrunk PineQuarter"
---| "Tree - BreakTrunk Spruce"
---| "Tree - BreakTrunk SpruceHalf"
---| "Tree - BreakTrunk Birch"
---| "Tree - CrownCollapse"
---| "Stone - BreakChunk"
---| "Stone - CrackRock"
---| "Stone - BreakChunk small"
---| "ConstructionLight"
---| "EncryptorLight"
---| "EnvironmentAmbientLight_Large"
---| "EnvironmentAmbientLight_Medium"
---| "EnvironmentAmbientLight_Small"
---| "EnvironmentPointLight_Static_Medium"
---| "EnvironmentSpotLight_Dynamic_Medium"
---| "EnvironmentSpotLight_Dynamic_Small"
---| "EnvironmentSpotLight_Static_Large"
---| "EnvironmentSpotLight_Static_Medium"
---| "EnvironmentSpotLight_Static_Small"
---| "FactoryLight"
---| "FloodLight"
---| "FluorescentLight"
---| "FreshLight"
---| "HeadLight"
---| "PackingtableLight"
---| "AreaLight"
---| "ShackLight"
---| "PosterLight"
---| "Fire - gradual"
---| "Fire - small01"
---| "Fire - vertical"
---| "Fire - lowburn"
---| "Fire -medium01_putout"
---| "Fire- Smoke Medium01"
---| "Fire - large01_putout"
---| "FireColorTest"
---| "Smoke - GroundSmokeMassive"
---| "Smoke - ash"
---| "Smoke - blowing01"
---| "Smoke - blowing02"
---| "Smoke - blowing03"
---| "Steam - quench"
---| "Smoke - embers"
---| "Fire -medium01"
---| "Smoke - pillar01"
---| "Smoke - pillar02"
---| "Fire - large01"
---| "Fire - Shipwreck"
---| "Smoke - pillar03"
---| "Water - BucketGetWater"
---| "Water - splash01"
---| "Water - WaterProjectileTrail"
---| "Water - splash02"
---| "Water - HitWaterTiny"
---| "Water - HitWaterMassive"
---| "Water - HitWaterBig"
---| "Water - HitWaterSmall"
---| "GasEngine - Level 2"
---| "GasEngine - Level 3"
---| "GasEngine - Level 4"
---| "GasEngine - Level 1"
---| "GasEngine - Level 5"
---| "GasEngine - Scrap"
---| "Thruster - Level 5"
---| "Thruster - Level 2"
---| "Thruster - Level 1"
---| "Thruster - Level 4"
---| "Thruster - Level 3"
---| "Thruster - Ground effect"
---| "ElectricEngine - Level 3"
---| "ElectricEngine - Level 4"
---| "ElectricEngine - Level 1"
---| "ElectricEngine - Level 5"
---| "ElectricEngine - Level 2"
---| "Suspension - Level 1"
---| "Suspension - Level 2"
---| "Suspension - Level 3"
---| "Suspension - Level 4"
---| "Suspension - Level 5"
---| "Suspension"
---| "Sensor off"
---| "Sensor on"
---| "Sensor off - Level 2"
---| "Sensor off - Level 3"
---| "Sensor off - Level 4"
---| "Sensor off - Level 5"
---| "Sensor on - Level 1"
---| "Sensor on - Level 2"
---| "Sensor on - Level 3"
---| "Sensor on - Level 4"
---| "Sensor on - Level 5"
---| "Sensor off - Level 1"
---| "Mechanic - KoLoop"
---| "Mechanic - MeleeHit"
---| "Mechanic - StatusHungry"
---| "Mechanic - StatusThirsty"
---| "Mechanic - StatusUnderwater"
---| "Mechanic - Swimbackward"
---| "Mechanic - Swimforeward"
---| "Mechanic crouch"
---| "Mechanic crouch walk"
---| "Mechanic - HurtDrown"
---| "Mechanic getUp"
---| "Mechanic - Hurthunger"
---| "Mechanic - Hurtpoision"
---| "Mechanic - Hurtshock"
---| "Mechanic - Hurt"
---| "Mechanic walk"
---| "Mechanic - HurtFire"
---| "Mechanic underwater"
---| "Mechanic land"
---| "Mechanic jump"
---| "Mechanic - JetpackBurstThruster"
---| "Mechanic - Ko"
---| "Mechanic - JetpackThruster"
---| "Controller - Default"
---| "Controller - Level 1"
---| "Controller - Level 2"
---| "Controller - Level 3"
---| "Controller - Level 4"
---| "Controller - Level 5"
---| "BroccoliProjectile - Hit"
---| "CarrotProjectile - Hit"
---| "PesticideProjectile - Hit"
---| "ChemicalProjectile - Attached"
---| "PineappleProjectile - Hit"
---| "FertilizerProjectile - Attached"
---| "FertilizerProjectile - Hit"
---| "GlowstickProjectile - Attached"
---| "TapeProjectile - Hit"
---| "TomatoProjectile - Hit"
---| "GlowstickProjectile - Bounce"
---| "WaterProjectile - Hit"
---| "TapeProjectile - Attached"
---| "GlowstickProjectile - Hit"
---| "RedbeetProjectile - Hit"
---| "PotatoProjectile - Hit"
---| "BlueberryProjectile - Hit"
---| "BananaProjectile - Hit"
---| "OrangeProjectile - Hit"
---| "ChemicalProjectile - Hit"
---| "Pesticide - Cloud"
---| "PesticideProjectile - Attached"
---| "Piston - Level 1"
---| "Piston - Level 2"
---| "Piston - Level 3"
---| "Piston - Level 4"
---| "Piston - Level 5"
---| "Piston - Default"
---| "ShipFire - medium01"
---| "Shipwreck - sparks03"
---| "Shipwreck - AmbianceSound"
---| "ShipFire - large01"
---| "Shipwreck - sparks01"
---| "ShipFire - lowburn"
---| "Shipwreck - sparks02"
---| "Fence - PlankCornerDestruction"
---| "Sign - HideoutSign07 Destruction"
---| "Fence - PlankLongDestruction"
---| "Sign - HideoutSign04 Destruction"
---| "Fence - FarmPlank04Destruction"
---| "Fence - FarmPlank02Destruction"
---| "Fence - HideoutFence01 Destruction"
---| "Sign - HideoutSign03 Destruction"
---| "Fence - FarmPlank03Destruction"
---| "Fence - PlankShortDestruction"
---| "Fence - HideoutFence04 Destruction"
---| "Fence - HideoutFence02 Destruction"
---| "Fence - HideoutFence05 Destruction"
---| "Fence - FarmPlank01Destruction"
---| "Fence - HideoutFence06 Destruction"
---| "Loot - GlowItem"
---| "Loot - Logbook"
---| "Loot - Pickup"
---| "LootCrate - EpicDestroy"
---| "Loot - Logentry"
---| "Loot - Logentryactivate"
---| "LootProjectile - Hit"
---| "Loot - LogfilesPickup"
---| "Loot - OutfitCommonGlowItem"
---| "Loot - OutfitCommonPickup"
---| "Loot - OutfitEpicGlowItem"
---| "EpicLoot - GlowItem"
---| "Loot - OutfitEpicPickup"
---| "Loot - OutfitRareGlowItem"
---| "LootProjectile - Attached"
---| "Loot - OutfitRarePickup"
---| "EpicLootProjectile - Hit"
---| "LootCrate - DestroyGlow"
---| "Loot - PictureLogfiles"
---| "Loot - AudioLogfiles"
---| "LootCrate - Destroy"
---| "EpicLootProjectile - Attached"
---| "Plants - Destroyed"
---| "Plants - Picked"
---| "Plants - Done"
---| "Plants - SoilbagUse"
---| "Plants - Fertilizer"
---| "Plants - Planted"
---| "Packingstation - Load"
---| "Packingstation - Tomatocrate"
---| "Packingstation - Orange"
---| "Packingstation - Activate"
---| "Packingstation - Pineapplecrate"
---| "Packingstation - ActivateSound"
---| "Packingstation - Redbeetcrate"
---| "Packingstation - Bananacrate"
---| "Packingstation - Blueberrycrate"
---| "Packingstation - Shoot"
---| "Packingstation - Brocolicrate"
---| "Packingstation - Roller"
---| "Packingstation - Carrotcrate"
---| "Craftbot - Unpack"
---| "Craftbot - Work"
---| "Refinery - WorkMetal"
---| "Craftbot - Work01"
---| "Refinery - WorkStone"
---| "Craftbot - Work02"
---| "Workbench - Finish"
---| "Craftbot - Work02Torch"
---| "Dispenserbot - Work01"
---| "DispenserbotSpawner - Spawn"
---| "Dressbot - Finish"
---| "Dressbot - HeadWork01"
---| "Dressbot - Idle"
---| "Dressbot - Opendoors"
---| "Workbench - Work01"
---| "Dressbot - Start"
---| "Workbench - Idle"
---| "Dressbot - Work01"
---| "Refinery - WorkWood"
---| "Refinery - WoodBlockLog"
---| "Cookbot - Idle"
---| "Refinery - WoodBlock"
---| "Refinary - Area"
---| "Refinery - Unpack"
---| "Cookbot - IdleSpecial02"
---| "Cookbot - Start"
---| "Refinery - Finish"
---| "Cookbot - Finish"
---| "Cookbot - IdleSpecial01"
---| "Cookbot - Unpack"
---| "Refinery - ScrapWoodBlock"
---| "Cookbot - Work"
---| "Refinery - ScrapStoneBlockLog"
---| "Cookbot - Work01"
---| "Refinery - ScrapStoneBlock"
---| "Cookbot - Work02"
---| "Refinery - ScrapMetalBlockLog"
---| "Cookbot - Work03"
---| "Refinery - ScrapMetalBlock"
---| "Cookbot - Work03Salt"
---| "Refinery - MetalBlockLog"
---| "Craftbot - Finish"
---| "Refinery - MetalBlock"
---| "Refinery - ScrapWoodBlockLog"
---| "Craftbot - Idle"
---| "Refinery - Start"
---| "Craftbot - IdleSpecial01"
---| "Refinery - SuckStart"
---| "Craftbot - IdleSpecial02"
---| "Dressbot - Work02"
---| "Craftbot - Start"
---| "Treeparts - birch02_p04"
---| "Treeparts - leafy02_p02"
---| "Treeparts - leafy02_p03"
---| "Treeparts - leafy02_p04"
---| "Treeparts - birch02_p06"
---| "Treeparts - leafy02_p06"
---| "Treeparts - birch03_p03"
---| "Treeparts - birch03_p04"
---| "Treeparts - birch03_p05"
---| "Treeparts - birch03_p06"
---| "Treeparts - leafy01_p02"
---| "Treeparts - leafy03_p06"
---| "Treeparts - leafy03_p07"
---| "Treeparts - leafy03_p08"
---| "Treeparts - leafy03_p09"
---| "Treeparts - pine01_p010"
---| "Treeparts - pine01_p011"
---| "Treeparts - pine01_p06"
---| "Treeparts - pine01_p07"
---| "Treeparts - pine01_p08"
---| "Treeparts - pine01_p09"
---| "Treeparts - pine02_p010"
---| "Treeparts - pine02_p07"
---| "Treeparts - pine02_p08"
---| "Treeparts - pine02_p09"
---| "Treeparts - pine03_p010"
---| "Treeparts - pine03_p08"
---| "Treeparts - pine03_p09"
---| "Treeparts - spruce01_p05"
---| "Treeparts - spruce02_p05"
---| "Treeparts - spruce03_p05"
---| "Treeparts - leafy02_p05"
---| "Treeparts - birch02_p05"
---| "Treeparts - birch03_p02"
---| "Treeparts - leafy02_p07"
---| "Treeparts - leafy03_p02"
---| "Treeparts - leafy03_p03"
---| "Treeparts - leafy03_p05"
---| "Treeparts - birch01_p05"
---| "Treeparts - leafy01_p04"
---| "Treeparts_burntforest - spruce02"
---| "Treeparts_burntforest - spruce01"
---| "Treeparts_burntforest - spruce05"
---| "Treeparts_burntforest - spruce03"
---| "Treeparts_burntforest - spruce04"
---| "Treeparts_burntforest - birch01"
---| "Treeparts_burntforest - spiketree01"
---| "Treeparts_burntforest - spiketree02"
---| "Glowgorp - Walk"
---| "Glowgorp - Pickup"
---| "Glowgorp - Hit"
---| "Glowgorp - Idlesound"
---| "Glowgorp - Cardboardmunch"
---| "Glowgorp - Jump"
---| "Glowgorp - Destruct"
---| "Saw - Debris"
---| "Saw - SawBlade"
---| "Drill - Debris"
---| "Drill - StoneDrill"
---| "Vacuumpipe - Blowout"
---| "Vacuumpipe - Suction"
---| "Haypile - Destruction"
---| "Leafpile - Destruction"
---| "Part - Upgrade"
---| "Part - Removed"
---| "Part - Electricity"
---| "SpudgunSpinner - Windup"
---| "SpudgunBasic - FPBasicMuzzel"
---| "SpudgunSpinner - FPSpinnerMuzzel"
---| "SpudgunSpinner - SpinnerMuzzel"
---| "SpudgunBasic - BasicMuzzel"
---| "SpudgunFrier - FrierMuzzel"
---| "SpudgunFrier - FPFrierMuzzel"
---| "SpudgunBasic - DefaultImpact01"
---| "Hideout - PumpSuction"
---| "Encryptor - Activation"
---| "Barrier - Deactivation"
---| "Encryptor - Deactivation"
---| "Barrier - SledgeHammerHit"
---| "Barrier - ShieldImpact"
---| "Barrier - Activation"
---| "Watercannon - Impact"
---| "Watercannon - Muzzeflash"
---| "Gui - LogbookPhotograph Flash"
---| "Gui - PlayButtonShine"
---| "Gui - Setwaypoint Flash"
---| "Gui - CuztomizeMainMenuShine"
---| "Gui - Setwaypoint Loop"
---| "Gui - DressbotBackground"
---| "Gui - Test"
---| "Gui - DressbotBox"
---| "Gui - UnboxItem"
---| "Gui - Upgrade"
---| "Gui - DressbotCollect"
---| "Gui - DressbotDone"
---| "Gui - DressbotUnboxCommon"
---| "Gui - DressbotUnboxEpic"
---| "Gui - DressbotUnboxGarmentButton"
---| "Gui - CraftingDone"
---| "Gui - DressbotUnboxGarmentButtonActivate"
---| "Gui - UpgradeIcon"
---| "Gui - CraftingDoneCollectButton"
---| "Gui - DressbotUnboxRare"
---| "Gui - LogbookIcon Flash"
---| "Gui - CustomizationRewardItem"
---| "Gui - LogbookNotification"
---| "Unbox - Farmbot01"
---| "Unbox - woc01"
---| "Unbox - Totebot01"
---| "Unbox - Haybot01"
---| "Unbox - glowworm01"
---| "Unbox - Tapebot01"
---| "Paintcharacter - Erase"
---| "Paintcharacter - Medium"
---| "Paintcharacter - Large"
---| "Paintcharacter - Small"
---| "Arrow"
---| "Robotparts - FarmbotHead"
---| "Robotparts - HaybotFork"
---| "Robotparts - FarmbotCannonarm"
---| "Robotparts - FarmbotDrill"
---| "Robotparts - FarmbotScyth"
---| "Robotparts - TotebotLeg"
---| "Robotparts - RedtapebotHead"
---| "Robotparts - TapebotHead"
---| "Robotparts - TotebotBody"
---| "Robotparts - HaybotHead"
---| "Robotparts - TapebotTorso"
---| "Robotparts - HaybotBody"
---| "Robotparts - TapebotLeftarm"
---| "Robotparts - HaybotPelvis"
---| "Builderguide - Buildcomplete"
---| "Builderguide - Active"
---| "Builderguide - Deactivate"
---| "Builderguide - Background"
---| "Builderguide - Stagecomplete"
---| "Horn - Honk"
---| "TapeBot - AlertedServo"
---| "TapeBot - ChasingFotStep"
---| "TapeBot - ChasingGunRattle"
---| "TapeBot - ChasingScissor"
---| "TapeBot - ChasingServo"
---| "TapeBot - FotStep"
---| "TapeBot - Scissor"
---| "TapeBot - Servo"
---| "TapeBot - Shoot"
---| "TapeBot - HeadShot"
---| "TapeBot - Hit"
---| "TapeBot - Alerted"
---| "TapeBot - AlertedFotStep"
---| "TapeBot - AlertedGunRattle"
---| "TapeBot - AlertedScissor"
---| "TapeBot - Destroyed"
---| "RedTapeBot - ExplosivesHit"
---| "Woc - Run"
---| "Woc - Eating"
---| "Woc - Destruct"
---| "Woc - Moo"
---| "Woc - Walk"
---| "Woc - Panic"
---| "UnderwaterAmbiance"
---| "WarehouseAmbiance"
---| "SurvivalMusic"
---| "Elevator - Opendoor"
---| "ElevatorWall"
---| "Elevator - Closedoor"
---| "Elevator Button"
---| "Elevator - Keycarduse"
---| "ElevatorAmbiance"
---| "Elevator - MoveOutside"
---| "ElevatorMusic"
---| "Oilgeyser - Picked"
---| "Harvestable - Burnttree"
---| "Tree - BurnedHit"
---| "SlimyClam - Bubbles"
---| "SlimyClam - BubblesAmbience"
---| "SlimyClam - Destruct"
---| "Stone - Stress"
---| "Corn - Destruct"
---| "beehive - destruct"
---| "beehive - beeswarm"
---| "Tree - LogAppear"
---| "Tree - LeafRattle"
---| "Tree - Ambient Birds"
---| "Cotton - Fluff"
---| "Tree - Falling"
---| "Cotton - Picked"
---| "Tree - Creak"
---| "Harvestable - Marker"
---| "Pigmentflower - Picked"
---| "Oilgeyser - OilgeyserAmbience"
---| "Oilgeyser - OilgeyserPickedLoop"
---| "Tree - BirchHit"
---| "Tree - DefaultHit"
---| "Oilgeyser - OilgeyserLoop"
---| "ToteBot - Sparks"
---| "ToteBot - SparkAttack"
---| "ToteBot - DestroyedParts"
---| "ToteBot - Hit"
---| "ToteBot - Alerted"
---| "ToteBot - ChasePlayer"
---| "ToteBot - Attack"
---| "ToteBot - FotStep"
---| "Haybot - ForkStep"
---| "Haybot - Alerted"
---| "Haybot - FotStep"
---| "Haybot - Attack01"
---| "Haybot - Destroyed"
---| "Haybot - IdleSpecial01"
---| "Haybot - Attack02"
---| "Haybot - IdleSpecial02"
---| "Haybot - Hit"
---| "Haybot - Attack03"
---| "Haybot - Metal"
---| "Haybot - Servo"
---| "Haybot - CaseplayerVoice"
---| "Haybot - SprintAttack"
---| "Farmbot - DestructionStartup01"
---| "Farmbot - DestructionStartup02"
---| "Farmbot - FotStepLight"
---| "Farmbot - DestructionStartup03"
---| "Farmbot - FotStepMedium"
---| "Farmbot - DestructionStartup04"
---| "Farmbot - Angry"
---| "Farmbot - Shoot"
---| "Farmbot - Attack01"
---| "Farmbot - Attack02"
---| "Farmbot - MoveHead"
---| "Farmbot - Attack03"
---| "Farmbot - MoveLegs"
---| "Farmbot - Voice"
---| "Farmbot - Attack04"
---| "Farmbot - SprintBody"
---| "Farmbot - RoamingIdle"
---| "Farmbot - Attack05"
---| "Farmbot - RunBody"
---| "Farmbot - RattleSyth"
---| "Farmbot - Hit"
---| "Farmbot - FotStepHeavy"
---| "Farmbot - Destroyed"
---| "CustomizationRenderable"
---| "ShapeRenderable"
---| "Glowstick - Throw"
---| "Glowstick - Hold"
---| "Bucket - Throw"
---| "Bucket - Fill"
---| "FarmerBall - Struggle"
---| "Farmerhideout - Accept"
---| "Farmerhideout - Open"
---| "FarmerBall - Help"
---| "Farmerhideout - Close"
---| "FarmerBall - Rolling"
---| "Guiquest - Pausestarterquest"
---| "Guiquest - Questupdate"
---| "Questmarker - Pointmarker"
---| "Questmarker - Pointmarker_small"
---| "Guiquest - Newquest"
---| "Questmarker - Zonearea"
---| "Questmarker - Pointmarker_large"
---| "Cinematic - Survivalstart01"
---| "Cinematic - Survivalstart02"
---| "ObserverBot - Move"
---| "Supervisor - Fail"
---| "ObserverBot - Write"
---| "Supervisor - Generic"
---| "PlayerStart - Glow"
---| "BuildMode - Floor"
---| "Buildarea - Oncreate"
---| "Supervisor - Cheer"
---| "CelebrationBot - Audio"
---| "CelebrationBot - Confetti"
---| "Celebrationbot - Activate"
---| "ChallengeCrowd - Jump"
---| "Ball"
---| "Characterspawner - Activate"
---| "Ballspawner - Activate"
---| "Chest - Arrow"
---| "Balltrigger - Activate"
---| "Goal - Activate"
---| "Soundcube - Activate"
---| "Goal - Oncreate"
---| "Boop - Floor"
---| "SmallGoal - Activate"
---| "MapInspector - On"
---| "Builderbot - Thruster"
---| "Cinematic - Challengemodecomplete"
---| "Cinematic - Challengemodecomplete_audio"
---| "Challengecamera - Potatolevel_01"
---| "Challengecamera - Stuntlevel_07"
---| "Challengecamera - Stuntlevel_08"
---| "Challengecamera - Stuntlevel_09"
---| "Challengecamera - Stuntlevel_10"
---| "Challengecamera - ThrusterLevel_01"
---| "Challengecamera - ThrusterLevel_02"
---| "Challengecamera - ThrusterLevel_03"
---| "Challengecamera - ThrusterLevel_04"
---| "Challengecamera - ThrusterLevel_05"
---| "Challengecamera - ThrusterLevel_06"
---| "Challengecamera - Potatolevel_02"
---| "Challengecamera - Potatolevel_03"
---| "Challengecamera - ThrusterLevel_07"
---| "Challengecamera - ThrusterLevel_08"
---| "Challengecamera - ThrusterLevel_09"
---| "Challengecamera - ThrusterLevel_10"
---| "Challengecamera - Potatolevel_04"
---| "Challengecamera - TutorialLevel_02"
---| "Challengecamera - TutorialLevel_03"
---| "Challengecamera - Potatolevel_05"
---| "Challengecamera - TutorialLevel_05"
---| "Challengecamera - TutorialLevel_06"
---| "Challengecamera - Potatolevel_06"
---| "Challengecamera - Potatolevel_07"
---| "Challengecamera - Potatolevel_08"
---| "Challengecamera - Potatolevel_09"
---| "Challengecamera - Potatolevel_10"
---| "Challengecamera - Puzzlelevel_01"
---| "Challengecamera - Puzzlelevel_02"
---| "Challengecamera - Puzzlelevel_03"
---| "Challengecamera - Puzzlelevel_04"
---| "Challengecamera - Puzzlelevel_05"
---| "Challengecamera - Puzzlelevel_06"
---| "Challengecamera - Puzzlelevel_07"
---| "Challengecamera - Puzzlelevel_08"
---| "Challengecamera - Puzzlelevel_09"
---| "Challengecamera - Puzzlelevel_10"
---| "Challengecamera - TutorialLevel_10"
---| "Challengecamera - TutorialLevel_09"
---| "Challengecamera - TutorialLevel_08"
---| "Challengecamera - TutorialLevel_07"
---| "Challengecamera - TutorialLevel_04"
---| "Challengecamera - Stuntlevel_01"
---| "Challengecamera - Stuntlevel_02"
---| "Challengecamera - TutorialLevel_01"
---| "Challengecamera - Stuntlevel_06"
---| "Challengecamera - Stuntlevel_03"
---| "Challengecamera - Stuntlevel_04"
---| "Challengecamera - Stuntlevel_05"
---| "Gui - Challengemode Approvedbannershine"
---| "Gui - Stuntmancollectpressed"
---| "Gui - Challengemode Stuntmanbackgroundshine"

---*Client only*  
---Creates an effect.  
---If you provide a host object to the effect then it will fetch position, velocity and orientation data from the interactable instead of relying on this information being fed to it.  
---This results in far more accurate positioning of effects that are supposed to stay attached to an object.  
---@param name EffectName|string The name.
---@param object? Interactable|Character|Harvestable The object the effect is attached to.
---@param name? string The bone name. (Defaults to not attached to a bone) (Optional)
---@return Effect
function sm.effect.createEffect(name, object, name) end

---*Client only*  
---Creates an 2d effect.  
---@param name EffectName|string The name of the effect.
---@return Effect
function sm.effect.createEffect2D(name) end

---*Client only*  
---Estimates the radius of influence for an effect and instance parameters  
---@param name EffectName|string The name of the effect.
---@param parameters table Table of params
---@return number
function sm.effect.estimateSize(name, parameters) end

---Plays an effect. If this function is called on the server it will play the effect on all clients.  
---**Note:**
---*If you start a looping effect using this function you will not be able to stop it.<br>Please use [sm.effect.createEffect, createEffect] for looping effects.*
---@param name EffectName|string The name.
---@param position Vec3 The position.
---@param velocity? Vec3 The velocity. (Defaults to no velocity)
---@param rotation? Quat The rotation. (Defaults to no rotation)
---@param scale? Vec3 The scale. (Defaults to no scale, only applied to renderables)
---@param parameters? table The table containing the parameters for the effect.
function sm.effect.playEffect(name, position, velocity, rotation, scale, parameters) end

---*Client only*  
---Plays an effect. It will fetch position, velocity and orientation data from the host interactable.  
---**Note:**
---*If you start a looping effect using this function you will not be able to stop it.<br>Please use [sm.effect.createEffect, createEffect] for looping effects*
---@param name EffectName|string The effect name.
---@param object Interactable|Character|Harvestable The object the effect is attached to.
---@param boneName? string The bone name. (Optional)
---@param parameters? table The table containing the parameters for the effect. (Optional)
function sm.effect.playHostedEffect(name, object, boneName, parameters) end

---<strong>Debris</strong> are visual objects that have no impact on any other object.  
sm.debris = {}

---*Client only*  
---Create visual debris of a [Shape, shape] from its [Uuid, uuid], that collides with world objects but does not have an impact on them.  
---@param uuid Uuid The uuid of the shape.
---@param position Vec3 The position.
---@param rotation Quat The rotation.
---@param velocity? Vec3 The linear velocity. (Defaults to zero)
---@param angularVelocity? Vec3 The angular velocity in radians per second around the axes (x,y,z). (Defaults to zero)
---@param color? Color The color. (Defaults to the shape's default color)
---@param time? number The time the debris will be simulated before disappearing. (Defaults to 10 seconds)
function sm.debris.createDebris(uuid, position, rotation, velocity, angularVelocity, color, time) end


---The <strong>Debug Draw</strong> api can be used for drawing geometric primitives for debug purposes.  
sm.debugDraw = {}

---Adds a named arrow debug draw.  
---@param name string The debug arrow name.
---@param from Vec3 The from position.
---@param to? Vec3 The to position. Defaults to the from position plus one along the z axis. (World up vector)
---@param color? Color The color. Defaults to white.
function sm.debugDraw.addArrow(name, from, to, color) end

---Adds a named sphere debug draw.  
---@param name string The debug sphere name.
---@param center Vec3 The sphere center.
---@param radius? number The sphere radius. Defaults to 0.125.
---@param color? Color The color. Defaults to white.
function sm.debugDraw.addSphere(name, center, radius, color) end

---Adds a named transform debug draw.  
---@param name string The debug transform name.
---@param origin Vec3 The transform origin.
---@param rotation Quat The transform rotation.
---@param scale? number The transform scale. Defaults to 1.0.
function sm.debugDraw.addTransform(name, origin, rotation, scale) end

---Removes all debug draws beginning with a given name.   
---   
---@param name? string The name to match (Defaults to "", matching all debug draws).
function sm.debugDraw.clear(name) end

---Removes a named arrow debug draw.   
---@param name string The debug arrow name.
function sm.debugDraw.removeArrow(name) end

---Removes a named sphere debug draw.   
---@param name string The debug sphere name.
function sm.debugDraw.removeSphere(name) end

---Removes a named transform debug draw.   
---@param name string The debug transform name.
function sm.debugDraw.removeTransform(name) end


---<strong>Storage</strong> is used for saving and loading any Lua data into the world's database. This allows for data to be retrieved after closing and reloading the world.  
---Storage can only be used on the <a href="index.html#server">server</a>.  
---**Warning:**
---*Storage allows for data to be saved immediately into the world's database. This is a <strong>very slow</strong> process and should be done as sparsely as possible.*
---*If you have data that is shared globally and updated often, consider using global variables instead. Ideally, storage should only be used to save data upon closing the world, or when saving a creation on the Lift.*
sm.storage = {}

---Loads Lua data stored with a given key. The <em>key</em> can be any lua object.  
---If no data is stored with the given key, this returns nil.  
---@param key any The key.
---@return any
function sm.storage.load(key) end

---Saves any Lua object with a given key. The <em>key</em> can be any lua object.  
---The data will remain stored after closing the world, and is retrieved using [sm.storage.load, load], provided the same key.  
---**Note:**
---*The data is stored globally <strong>within the current mod</strong>. As of such, keys will not collide with external mods and scripts.*
---@param key any The key that will be used to get the data.
---@param data any The data to be stored.
function sm.storage.save(key, data) end

---Saves any Lua object with a given key. The <em>key</em> can be any lua object.  
---The data will remain stored after closing the world and synchronized to other clients, and is retrieved using [sm.storage.load, load], provided the same key.  
---**Note:**
---*The data is stored globally <strong>within the current mod</strong>. As of such, keys will not collide with external mods and scripts.*
---@param key any The key that will be used to get the data.
---@param data any The data to be stored.
function sm.storage.saveAndSync(key, data) end


---Unit creation and management  
sm.unit = {}

---*Server only*  
---Creates a new unit of type from an [Uuid]  
---@param uuid Uuid The character type uuid.
---@param feetPos Vec3 The feet position in world where unit should spawn.
---@param yaw? number The initial yaw. Defaults to 0 (Optional)
---@param data? any The param data. (Optional)
---@param pitch? number The initial pitch. Defaults to 0 (Optional)	
---@return Unit
function sm.unit.createUnit(uuid, feetPos, yaw, data, pitch) end

---*Server only*  
---Returns a table with all the units in the world.  
---@return Unit[]
function sm.unit.getAllUnits() end


---Pathfinder  
sm.pathfinder = {}

---Condition link types  
---height  
---target  
---none  
sm.pathfinder.conditionProperty = {
    height = 0,
    target = 1,
    none = 2
}

---*Server only*  
---Find a path  
---@param character Character The character to find path for
---@param destination Vec3 The path destination
---@param groundPos? boolean If the destination is ground level
---@param linkConditions? table Table of link conditions
---@return table
function sm.pathfinder.getPath(character, destination, groundPos, linkConditions) end

---*Server only*  
---Find all nearby path nodes  
---@param worldPosition Vec3 The position to look in
---@param minDist number Minimum distance around pos
---@param maxDist number Maximum distance around pos
---@return PathNode[]
function sm.pathfinder.getSortedNodes(worldPosition, minDist, maxDist) end


---Path node creation  
sm.pathNode = {}

---*Server only*  
---Create a PathNode  
---@param worldPosition Vec3 The node's world position
---@param radius number The nodes's radius
---@return PathNode
function sm.pathNode.createPathNode(worldPosition, radius) end


---A <strong>tool</strong> is a scripted tool a player holds in their hand. The tool object is focused on handling animations for first and third person view.  
---For more information about creating your own scripted tools, see [ToolClass, ToolClass].  
sm.tool = {}

---The interact state describe what kind of interaction is made. This is used to check whether a mouse button or key was just made pressed, held, etc.  
---The states are:  
--- - <strong>null</strong> &ndash; No keypress was made.
--- - <strong>start</strong> &ndash; The key was just pressed.
--- - <strong>hold</strong> &ndash; The key is held down.
--- - <strong>stop</strong> &ndash; The key was just released.
---null0  
---start1  
---hold2  
---stop3  
sm.tool.interactState = {
    null = 0,
    start = 1,
    hold = 2,
    stop = 3
}

---Used to check collisions between the lift and the world.  
---@param creation table A table of all the bodies belonging to the creation placed on the lift.
---@param position Vec3 The lift position.
---@param rotation integer The rotation of the creation on the lift.
---@return boolean, integer					True if the lift collides with the world; The lift level.
function sm.tool.checkLiftCollision(creation, position, rotation) end

---*Client only*  
---Force equip a tool for the local player. Pass nil to unforce an already forced tool.  
---@param tool Tool|nil The tool.
function sm.tool.forceTool(tool) end

---*Client only*  
---Pre-loads renderable data to be used by the tool. This eliminates excessive loading during run time.  
---@param renderables table The table of renderables names. {string, ..}
function sm.tool.preloadRenderables(renderables) end

---Return whether the tool uuid exists  
---@param The Uuid shape uuid.
---@return boolean
function sm.tool.uuidExists(The) end


---The <strong>audio</strong> manager is used to play sound effects in the game.  
---**Note:**
---*This manager does only produce sound for the local <a href="index.html#client">client</a>. This is useful for small sound effects such as for GUI.*
---*For more information about sound and particle effects that affect all players, see [sm.effect].*
sm.audio = {}

---@deprecated Audio is deprecated, use Effect instead
---A table with all the names of available sounds in the game.  
sm.audio.soundList = {}

---All the audio names that can be used with sm.audio.play.
---@alias AudioName
---| "Ambient - Birds"
---| "Ambient - Challenge"
---| "Ambient - Field"
---| "Blueprint - Build"
---| "Blueprint - Camera"
---| "Blueprint - Close"
---| "Blueprint - Delete"
---| "Blueprint - Open"
---| "Blueprint - Save"
---| "Blueprint - Select"
---| "Blueprint - Share"
---| "Brake"
---| "Button off"
---| "Button on"
---| "Challenge - Fall"
---| "Challenge - Start"
---| "Challenge - Supervisor generic"
---| "Character crouch"
---| "Character get up"
---| "Character hit"
---| "Character jump"
---| "Character land"
---| "Character movement"
---| "Character movement crouched"
---| "Character wind"
---| "Collision - Debris"
---| "Collision - Multiple"
---| "Collision - Rolling"
---| "Collision - Single"
---| "Collision - Sliding"
---| "Collision - Vehicle"
---| "ConnectTool"
---| "ConnectTool - Equip"
---| "ConnectTool - Idle"
---| "ConnectTool - Released"
---| "ConnectTool - Rotate"
---| "ConnectTool - Selected"
---| "ConnectTool - Unequip"
---| "Construction - Block attached to joint"
---| "Construction - Block placed"
---| "Construction - Resize"
---| "Dancebass"
---| "Dancedrum"
---| "Dancepad"
---| "Dancevoice"
---| "Destruction - Block destroyed"
---| "Destruction - Resize"
---| "ElectricEngine"
---| "GUI Backpack closed"
---| "GUI Backpack opened"
---| "GUI Inventory highlight"
---| "GUI Item drag"
---| "GUI Item released"
---| "GUI Quickbar highlight"
---| "GUI Shape rotate"
---| "Gas Explosion"
---| "Gas Leak"
---| "GasEngine"
---| "Handbook - Close"
---| "Handbook - Equip"
---| "Handbook - Highlight"
---| "Handbook - Open"
---| "Handbook - Turn page"
---| "Handbook - Unequip"
---| "Horn"
---| "Lever off"
---| "Lever on"
---| "Lift - Pickup object"
---| "Lift placed"
---| "Lift usage"
---| "Music"
---| "PaintTool - Close"
---| "PaintTool - ColorPick"
---| "PaintTool - Equip"
---| "PaintTool - Erase"
---| "PaintTool - Open"
---| "PaintTool - Paint"
---| "PaintTool - Reload"
---| "PaintTool - Unequip"
---| "Phaser"
---| "Piston"
---| "PotatoRifle - Equip"
---| "PotatoRifle - NoAmmo"
---| "PotatoRifle - Reload"
---| "PotatoRifle - Shoot"
---| "PotatoRifle - Unequip"
---| "Radio"
---| "RaftShark"
---| "Retrobass"
---| "Retrodrum"
---| "Retrofmblip"
---| "Retrovoice"
---| "Retrowildblip"
---| "Reverb - Challenge"
---| "Reverb - Field"
---| "Seat seated"
---| "Seat unseated"
---| "Sensor off"
---| "Sensor on"
---| "SequenceController"
---| "SequenceController change rotation"
---| "Sledgehammer - Equip"
---| "Sledgehammer - Swing"
---| "Sledgehammer - Unequip"
---| "Suspension"
---| "Thruster"
---| "Thruster dust"
---| "Toilet seated"
---| "Toilet unseated"
---| "Weapon - Hit"
---| "WeldTool - Case 1"
---| "WeldTool - Case 2"
---| "WeldTool - Equip"
---| "WeldTool - Error"
---| "WeldTool - Sparks"
---| "WeldTool - Unequip"
---| "WeldTool - Weld"

---*Client only*  
---Plays a sound.  
---If position is specified, the sound will play at the given coordinates in the world. Otherwise, the sound will play normally.  
---For a list of available sounds to play, see [sm.audio.soundList].  
---@param sound AudioName|string The sound to play.
---@param position? Vec3 The world position of the sound. (Optional)
function sm.audio.play(sound, position) end


---The <strong>particle</strong> api allows you to create particle effects at a position.  
---If you require more control or complexity, please see the [sm.effect, effect] api.  
sm.particle = {}

---*Client only*  
---Create a particle effect at a given position and rotation.  
---**Note:**
---*If you start a looping particle effect through this method then the only way to get rid of it is by reloading the save.*
---@param particle string The particle name.
---@param position Vec3 The position.
---@param rotation? Quat The rotation. (Defaults to no rotation)
---@param color? Color The blend color. (Defaults to white)
function sm.particle.createParticle(particle, position, rotation, color) end


---<strong>Local player</strong> represents the current character being controlled on the client's computer. This library can only be used on the <a href="index.html#client">client</a>.  
---For more information about other players in the world, see [sm.player].  
sm.localPlayer = {}

---*Client only*  
---Adds a renderable (file containing model data) to be used for the local player in first person view.  
---@param renderable string The renderable path.
function sm.localPlayer.addRenderable(renderable) end

---*Client only*  
---Returns the item currently held by the local player.  
---@return Uuid
function sm.localPlayer.getActiveItem() end

---*Client only*  
---Return the player aim sensitivity  
---@return number
function sm.localPlayer.getAimSensitivity() end

---*Client only*  
---Returns the carrying container of the local player.  
---@return Container
function sm.localPlayer.getCarry() end

---*Client only*  
---Returns the color of the shape the local player is carrying.  
---@return Color
function sm.localPlayer.getCarryColor() end

---*Client only*  
---Returns the direction the local player is aiming.  
---@return Vec3
function sm.localPlayer.getDirection() end

---*Client only*  
---Returns general information for a first person view animation.  
---@param name string The name.
---@return AnimationInfo
function sm.localPlayer.getFpAnimationInfo(name) end

---*Client only*  
---Returns the world position for a bone in the first person view animation skeleton.  
---@param jointName string The joint name.
---@return Vec3
function sm.localPlayer.getFpBonePos(jointName) end

---*Client only*  
---Returns the hotbar container of the player.  
---@return Container
function sm.localPlayer.getHotbar() end

---*Client only*  
---Returns the unique player id of the local player.  
---@return integer
function sm.localPlayer.getId() end

---*Client only*  
---Returns the inventory container of the local player.  
---@return Container
function sm.localPlayer.getInventory() end

---*Client only*  
---Returns delta positions of mouse  
---@return number,number
function sm.localPlayer.getMouseDelta() end

---*Client only*  
---Returns the [Lift] of the local player.  
---@return Lift
function sm.localPlayer.getOwnedLift() end

---*Client only*  
---Returns the player object of the local player.  
---@return Player
function sm.localPlayer.getPlayer() end

---*Client only*  
---@deprecated Use [Character.worldPosition] or [Character.getWorldPosition]
---Returns the world position of the local player.  
---@return Vec3
function sm.localPlayer.getPosition() end

---*Client only*  
---Performs a <a target="_blank" href="https://en.wikipedia.org/wiki/Ray_casting">raycast</a> relative to the local player's perspective.  
---@param range number The maximum range.
---@param origin? Vec3 The start position. (Defaults to [sm.localPlayer.getRaycastStart])
---@param direction? Vec3 The direction. (Defaults to [sm.localPlayer.getDirection])
---@return bool, RaycastResult
function sm.localPlayer.getRaycast(range, origin, direction) end

---*Client only*  
---Returns the start position of the local player's raycast. The position depends on the [sm.camera, camera]'s position, and whether it's in first- of third-person.  
---@return Vec3
function sm.localPlayer.getRaycastStart() end

---*Client only*  
---Returns the right-vector perpendicular to the local player's aim.  
---@return Vec3
function sm.localPlayer.getRight() end

---*Client only*  
---Returns the local player's selected slot.  
---@return integer
function sm.localPlayer.getSelectedHotbarSlot() end

---*Client only*  
---Returns the up-vector perpendicular to the local player's aim.  
---@return Vec3
function sm.localPlayer.getUp() end

---*Client only*  
---Check if the garment has been granted to the local player.  
---@param uuid Uuid The garment.
---@return boolean
function sm.localPlayer.isGarmentUnlocked(uuid) end

---*Client only*  
---Returns whether the player is in first person view where the viewpoint is rendered from the player's perspective. Otherwise, the player is in third person view where the camera is behind the player.  
---@return boolean
function sm.localPlayer.isInFirstPersonView() end

---*Client only*  
---Removes a renderable (file containing model data) that was used for the local player in first person view.  
---@param renderable string The renderable path.
function sm.localPlayer.removeRenderable(renderable) end

---*Client only*  
---Stops the local player from sprinting.  
---@param blockSprinting boolean Sets whether sprinting is blocked.
function sm.localPlayer.setBlockSprinting(blockSprinting) end

---*Client only*  
---Sets the direction of where the player is viewing or aiming. Intended to be used when the controls have been locked. (See [sm.localPlayer.setLockedControls])  
---@param direction Vec3 The world direction.
function sm.localPlayer.setDirection(direction) end

---*Client only*  
---Sets whether the player's in-game controls are locked.  
---@param locked boolean The lock state.
function sm.localPlayer.setLockedControls(locked) end

---*Client only*  
---Updates a first person view animation.  
---@param name string The name.
---@param time number The time.
---@param weight? number The weight.
---@param looping? boolean The looping.
function sm.localPlayer.updateFpAnimation(name, time, weight, looping) end


---The <strong>camera</strong> library contains methods related to the [sm.localPlayer, localPlayer]'s camera view.  
---In first-person view the camera is located inside the player's head, whereas in third-person view it floats behind them.  
---This library can only be used on the <a href="index.html#client">client</a>.  
sm.camera = {}

---Camera states are used to specify how the camera will view the world. The default state is meant for normal gameplay and the first-person and third-person states are meant to be used in cutcenes.  
---The states are:  
--- - <strong>default</strong> &ndash; The camera is controlled by the player.
--- - <strong>cutsceneFP</strong> &ndash; The camera views the world in a first-person perspective.
--- - <strong>cutsceneTP</strong> &ndash; The camera views the world in a third-person perspective.
---default1  
---cutsceneFP2  
---cutsceneTP3  
sm.camera.state = {   
    default = 1,
    cutsceneFP = 2,
    cutsceneTP = 3,
    forcedTP = 4,
    gyroSeatFP = 5,
    gyroSeatTP = 6
}

---*Client only*  
---Performs a distance convex sweep with the shape of a sphere, from a position with a given direction.  
---@param radius number The radius of the cast sphere
---@param start Vec3 The start position.
---@param direction Vec3 The cast direction and range.
---@return number
function sm.camera.cameraSphereCast(radius, start, direction) end

---*Client only*  
---Returns the camera's zoom steps.  
---@return number
---@return number
function sm.camera.getCameraPullback() end

---*Client only*  
---Gets the camera's control state.  
---@return integer
function sm.camera.getCameraState() end

---*Client only*  
---Returns the camera's default field of view angle.  
---@return number
function sm.camera.getDefaultFov() end

---*Client only*  
---Returns the world postition where the camera should be by default.  
---@return Vec3
function sm.camera.getDefaultPosition() end

---*Client only*  
---Returns the world rotation where the camera should be by default.  
---@return Quat
function sm.camera.getDefaultRotation() end

---*Client only*  
---Returns the direction the camera is aiming.  
---@return Vec3
function sm.camera.getDirection() end

---*Client only*  
---Returns the camera's field of view angle.  
---@return number
function sm.camera.getFov() end

---*Client only*  
---Returns the world postition of the camera.  
---@return Vec3
function sm.camera.getPosition() end

---*Client only*  
---Returns the right-vector perpendicular to the camera's aim.  
---@return Vec3
function sm.camera.getRight() end

---*Client only*  
---Returns the world rotation of the camera.  
---@return Quat
function sm.camera.getRotation() end

---*Client only*  
---Returns the up-vector perpendicular to the camera's aim.  
---@return Vec3
function sm.camera.getUp() end

---*Client only*  
---Sets the camera's zoom step.  
---@param step integer How far away the camera is from the player while standing
---@param seatedStep integer How far away the camera is from the player while seated.
function sm.camera.setCameraPullback(step, seatedStep) end

---*Client only*  
---Sets the camera's control state.  
---@param state integer How the camera is moved. (See [sm.camera.state])
function sm.camera.setCameraState(state) end

---*Client only*  
---Sets the direction the camera is aiming.  
---@param direction Vec3 The direction of the camera's aim.
function sm.camera.setDirection(direction) end

---*Client only*  
---Sets the camera's field of view angle.  
---@param FOV number The field of view.
function sm.camera.setFov(FOV) end

---*Client only*  
---Sets the world postition of the camera.  
---@param position Vec3 The camera's world position.
function sm.camera.setPosition(position) end

---*Client only*  
---Sets the rotation of the camera.  
---@param rotation Quat The rotation of the camera.
function sm.camera.setRotation(rotation) end

---*Client only*  
---Sets the camera's level of camera shake.  
---@param strength number The camera shake strength.
function sm.camera.setShake(strength) end


---The <strong>gui</strong> library contains various utility functions for handling user interfaces.  
---This library can only be used on the <a href="index.html#client">client</a>.  
sm.gui = {}

---Prints text in the chat gui.  
---**Note:**
---*Will not be sent to other players.*
---@param message string The message.
function sm.gui.chatMessage(message) end

---*Client only*  
---Create a ammunition container GUI.  
---@param destroyOnClose? boolean If true the gui is destroyed when closed, otherwise the gui can be reused.
---@return GuiInterface
function sm.gui.createAmmunitionContainerGui(destroyOnClose) end

---*Client only*  
---@deprecated use createWorldIconGui
---Create a bag icon GUI.  
---@param destroyOnClose? boolean If true the gui is destroyed when closed, otherwise the gui can be reused.
---@return GuiInterface
function sm.gui.createBagIconGui(destroyOnClose) end

---*Client only*  
---Create a battery container GUI.  
---@param destroyOnClose? boolean If true the gui is destroyed when closed, otherwise the gui can be reused.
---@return GuiInterface
function sm.gui.createBatteryContainerGui(destroyOnClose) end

---*Client only*  
---@deprecated use createWorldIconGui
---Create a beacon icon GUI.  
---@param destroyOnClose? boolean If true the gui is destroyed when closed, otherwise the gui can be reused.
---@return GuiInterface
function sm.gui.createBeaconIconGui(destroyOnClose) end

---*Client only*  
---Create a challenge HUD GUI.  
---@param destroyOnClose? boolean If true the gui is destroyed when closed, otherwise the gui can be reused.
---@return GuiInterface
function sm.gui.createChallengeHUDGui(destroyOnClose) end

---*Client only*  
---Create a challenge message HUD GUI.  
---@param destroyOnClose? boolean If true the gui is destroyed when closed, otherwise the gui can be reused.
---@return GuiInterface
function sm.gui.createChallengeMessageGui(destroyOnClose) end

---*Client only*  
---Create a character customization GUI.  
---@param destroyOnClose? boolean If true the gui is destroyed when closed, otherwise the gui can be reused.
---@return GuiInterface
function sm.gui.createCharacterCustomizationGui(destroyOnClose) end

---*Client only*  
---Create a chemical container GUI.  
---@param destroyOnClose? boolean If true the gui is destroyed when closed, otherwise the gui can be reused.
---@return GuiInterface
function sm.gui.createChemicalContainerGui(destroyOnClose) end

---*Client only*  
---Create a container GUI, for showing two containers.  
---@param destroyOnClose? boolean If true the gui is destroyed when closed, otherwise the gui can be reused.
---@return GuiInterface
function sm.gui.createContainerGui(destroyOnClose) end

---*Client only*  
---Create a craft bot GUI.  
---@param destroyOnClose? boolean If true the gui is destroyed when closed, otherwise the gui can be reused.
---@return GuiInterface
function sm.gui.createCraftBotGui(destroyOnClose) end

---*Client only*  
---Create a dress bot GUI.  
---@param destroyOnClose? boolean If true the gui is destroyed when closed, otherwise the gui can be reused.
---@return GuiInterface
function sm.gui.createDressBotGui(destroyOnClose) end

---*Client only*  
---Create a engine GUI.  
---@param destroyOnClose? boolean If true the gui is destroyed when closed, otherwise the gui can be reused.
---@return GuiInterface
function sm.gui.createEngineGui(destroyOnClose) end

---*Client only*  
---Create a fertilizer container GUI.  
---@param destroyOnClose? boolean If true the gui is destroyed when closed, otherwise the gui can be reused.
---@return GuiInterface
function sm.gui.createFertilizerContainerGui(destroyOnClose) end

---*Client only*  
---Create a gas container GUI.  
---@param destroyOnClose? boolean If true the gui is destroyed when closed, otherwise the gui can be reused.
---@return GuiInterface
function sm.gui.createGasContainerGui(destroyOnClose) end


---@class GuiSettings
---@field isHud? boolean Whether the gui is part of the HUD or not
---@field isInteractive? boolean Whether the gui is interactive or not
---@field needsCursor? boolean Whether the gui makes use of the mouse cursor or not
---@field hidesHotbar? boolean Whether the gui hides the hotbar or not
---@field isOverlapped? boolean Unknown
---@field backgroundAlpha? number The alpha of the background(0 - transparent | 1 - opaque, black background)


---*Client only*  
---Create a GUI from a layout file.  
---@param layout string Path to the layout file
---@param destroyOnClose? boolean If true the gui is destroyed when closed, otherwise the gui can be reused.
---@param settings? GuiSettings Table with bool settings for: isHud, isInteractive, needsCursor
---@return GuiInterface
function sm.gui.createGuiFromLayout(layout, destroyOnClose, settings) end

---*Client only*  
---Create a hideout gui GUI.  
---@param destroyOnClose? boolean If true the gui is destroyed when closed, otherwise the gui can be reused.
---@return GuiInterface
function sm.gui.createHideoutGui(destroyOnClose) end

---*Client only*  
---Create a log book GUI.  
---@param destroyOnClose? boolean If true the gui is destroyed when closed, otherwise the gui can be reused.
---@return GuiInterface
function sm.gui.createLogbookGui(destroyOnClose) end

---*Client only*  
---Create a mechanical station GUI.  
---@param destroyOnClose? boolean If true the gui is destroyed when closed, otherwise the gui can be reused.
---@return GuiInterface
function sm.gui.createMechanicStationGui(destroyOnClose) end

---*Client only*  
---Create a name tag GUI.  
---@param destroyOnClose? boolean If true the gui is destroyed when closed, otherwise the gui can be reused.
---@return GuiInterface
function sm.gui.createNameTagGui(destroyOnClose) end

---*Client only*  
---Create a quest tracker GUI.  
---@param destroyOnClose? boolean If true the gui is destroyed when closed, otherwise the gui can be reused.
---@return GuiInterface
function sm.gui.createQuestTrackerGui(destroyOnClose) end

---*Client only*  
---Create a seat GUI.  
---@param destroyOnClose? boolean If true the gui is destroyed when closed, otherwise the gui can be reused.
---@return GuiInterface
function sm.gui.createSeatGui(destroyOnClose) end

---*Client only*  
---Create a seat upgrade GUI.  
---@param destroyOnClose? boolean If true the gui is destroyed when closed, otherwise the gui can be reused.
---@return GuiInterface
function sm.gui.createSeatUpgradeGui(destroyOnClose) end

---*Client only*  
---Create a seed container GUI.  
---@param destroyOnClose? boolean If true the gui is destroyed when closed, otherwise the gui can be reused.
---@return GuiInterface
function sm.gui.createSeedContainerGui(destroyOnClose) end

---*Client only*  
---Create a steering bearing upgrade GUI.  
---@param destroyOnClose? boolean If true the gui is destroyed when closed, otherwise the gui can be reused.
---@return GuiInterface
function sm.gui.createSteeringBearingGui(destroyOnClose) end

---*Client only*  
---Create a survival hud GUI.  
---@param destroyOnClose? boolean If true the gui is destroyed when closed, otherwise the gui can be reused.
---@return GuiInterface
function sm.gui.createSurvivalHudGui(destroyOnClose) end

---*Client only*  
---Create a water container GUI.  
---@param destroyOnClose? boolean If true the gui is destroyed when closed, otherwise the gui can be reused.
---@return GuiInterface
function sm.gui.createWaterContainerGui(destroyOnClose) end

---*Client only*  
---@deprecated use createWorldIconGui
---Create a waypoint icon GUI.  
---@param destroyOnClose? boolean If true the gui is destroyed when closed, otherwise the gui can be reused.
---@return GuiInterface
function sm.gui.createWaypointIconGui(destroyOnClose) end

---@deprecated Use [sm.gui.createGuiFromLayout]
---Removed! Does nothing.  
function sm.gui.createWidget() end

---*Client only*  
---Create a workbench GUI.  
---@param destroyOnClose? boolean If true the gui is destroyed when closed, otherwise the gui can be reused.
---@return GuiInterface
function sm.gui.createWorkbenchGui(destroyOnClose) end

---*Client only*  
---Create a world icon GUI from a layout file.  
---@param width integer The width.
---@param height integer The height.
---@param layout? string Path to the layout file (Defaults to "$GAME_DATA/Gui/Layouts/Hud/Hud_WorldIcon.layout")
---@param destroyOnClose? boolean If true the gui is destroyed when closed, otherwise the gui can be reused. (Defaults to false)
---@return GuiInterface
function sm.gui.createWorldIconGui(width, height, layout, destroyOnClose) end

---*Client only*  
---Displays an alert message at the top of the screen for a set duration.  
---@param text string The message to be displayed
---@param duration? number The time in seconds during which the message is shown. Defaults to 4 seconds
function sm.gui.displayAlertText(text, duration) end

---*Client only*  
---Fades the screen back from a fade to black.  
---@param duration number Animation duration
function sm.gui.endFadeToBlack(duration) end

---*Client only*  
---Exits the current game and returns to the main menu  
---**Note:**
---*Can only be used in the Challenge Mode*
function sm.gui.exitToMenu() end

---*Client only*  
---Returns the current users language setting.  
---@return string
function sm.gui.getCurrentLanguage() end

---*Client only*  
---Returns the set binding for an action as a string  
---@param action string The action
---@param hyper? boolean If the string should contain hyper text
---@return string
function sm.gui.getKeyBinding(action, hyper) end

---*Client only*  
---Returns the size of the screen.  
---@return integer,integer
function sm.gui.getScreenSize() end

---*Client only*  
---Set gui visibility.  
---@param visible boolean The gui visibility
function sm.gui.hideGui(visible) end

---*Client only*  
---Set the icon displayed at the center.  
---@param iconName string The icon.
function sm.gui.setCenterIcon(iconName) end

---*Client only*  
---Set a text for the character that will be displayed above its head.  
---@param character Character The character.
---@param text string The debug text.
---@param clear? boolean If true the previous text will be overwritten.
function sm.gui.setCharacterDebugText(character, text, clear) end

---*Client only*  
---Set the binding text displayed at the center.  
---@param text1 string The leftmost segment.
---@param binding1? string The left white segment.
---@param text2? string The mid or end segment.
---@param binding2? string The right white segment.
---@param text3? string The rightmost segment.
function sm.gui.setInteractionText(text1, binding1, text2, binding2, text3) end

---*Client only*  
---Set the progress fraction filling the circle icon displayed at the center.  
---@param progress number The fraction that determines how much of the circle is filled. 
function sm.gui.setProgressFraction(progress) end

---*Client only*  
---Fades the screen to black and back after timeout.  
---@param duration number Animation duration
---@param timeout number Seconds until the fade fades back
function sm.gui.startFadeToBlack(duration, timeout) end

---*Client only*  
---Converts ticks to a HH:MM:SS string representation.  
---@param ticks integer Game ticks
---@return string
function sm.gui.ticksToTimeString(ticks) end

---*Client only*  
---Translates all localization tags in a text using the current language.  
---@param text string The text containing localization tags
---@return string
function sm.gui.translateLocalizationTags(text) end


---Removed! Don't use.  
sm.gui.widget = {}

---@deprecated Use [GuiInterface]
---Removed!  
function sm.gui.widget.destroy() end


---<strong>Visualization</strong> is used for visualizing game objects.  
sm.visualization = {}

---*Client only*  
---Create a [BlueprintVisualization] from a blueprint file path.  
---@param path string A file path to the blueprint to be visualized
---@return BlueprintVisualization
function sm.visualization.createBlueprint(path) end

---*Client only*  
---Create a [BlueprintVisualization] from a blueprint table.  
---@param blueprintTable table Table with blueprint information to be visualized
---@return BlueprintVisualization
function sm.visualization.createBlueprint(blueprintTable) end

---*Client only*  
---Create a builder guide [BlueprintVisualization], comparing the creation from the root [Shape] to the blueprint give by path.  
---The builder guide blueprint contains stage indices based on shape color, stage color order is the same as the color order in the PaintTool color picker.  
---@param path string A file path to the builder guide blueprint
---@param shape Shape Root [Shape] for comparing the creation from
---@param ignoreBlockUuid? boolean Should block uuid be evaluated for stage completion
---@param completeEffectName? string The name a effect that should be played once the builder guide is completed
---@return BlueprintVisualization
function sm.visualization.createBuilderGuide(path, shape, ignoreBlockUuid, completeEffectName) end


---@class ShapePlacementVisualization
---@field isLegalPlacement boolean
---@field shapeUuid Uuid
---@field worldRotation Quat
---@field worldPosition Vec3

---*Client only*  
---Returns a table containing the current state of the shape placement visualization.  
---@return ShapePlacementVisualization
function sm.visualization.getShapePlacementVisualization() end

---*Client only*  
---Visualizes a block on a shape  
---@param position Vec3 The local space position
---@param illegal? boolean Whether the visualization should render as illegal
---@param shape Shape Shape to visualize on
function sm.visualization.setBlockVisualization(position, illegal, shape) end

---*Client only*  
---Visualizes a block on a joint  
---@param position Vec3 The local space position
---@param illegal? boolean Whether the visualization should render as illegal
---@param joint Joint joint to visualize on
function sm.visualization.setBlockVisualization(position, illegal, joint) end

---*Client only*  
---Visualizes a block in world space  
---@param position Vec3 The world space position
---@param illegal? boolean Whether the visualization should render as illegal
function sm.visualization.setBlockVisualization(position, illegal) end

---*Client only*  
---Sets an array of bodies to visualize.  
---@param bodies table Array of bodies to visualize {[Body], ..}.
function sm.visualization.setCreationBodies(bodies) end

---*Client only*  
---Controls the transform of the creation visualization. If true the visualization will render using setFreePlacementPosition/setFreePlacementRotation functions.  
---If false the visualization will render on top of the creation.  
---@param valid boolean Should the creation visualization be free placement
function sm.visualization.setCreationFreePlacement(valid) end

---*Client only*  
---Set the world position of the creation visualization. Only works if setFreePlacement is true.  
---@param position Vec3 World position of the creation visualization
function sm.visualization.setCreationFreePlacementPosition(position) end

---*Client only*  
---Set the rotation index of the creation visualization. Only works if setFreePlacement is true.  
---@param index integer Index to rotate the creation visualization with
function sm.visualization.setCreationFreePlacementRotation(index) end

---*Client only*  
---Controls the rendering of the creation visualization.   
---@param valid boolean Should the visualization should render be valid
---@param lift? boolean Should the visualization should render be lift or place
function sm.visualization.setCreationValid(valid, lift) end

---*Client only*  
---Controls the visibility of the creation visualization  
---@param visible boolean Should the creation visualization be visible
function sm.visualization.setCreationVisible(visible) end

---*Client only*  
---Set the lift level of the lift visualization.  
---@param level integer The level of the lift
function sm.visualization.setLiftLevel(level) end

---*Client only*  
---Set the world position of the lift visualization.  
---@param position Vec3 World position of the lift visualization
function sm.visualization.setLiftPosition(position) end

---*Client only*  
---Controls the rendering of the lift visualization.   
---@param valid boolean Whether the visualization should render as valid
function sm.visualization.setLiftValid(valid) end

---*Client only*  
---Controls the visibility of the lift visualization  
---@param visible boolean Whether the lift visualization is visible
function sm.visualization.setLiftVisible(visible) end


---Render settings  
sm.render = {}

---*Client only*  
---Gets the draw distance.  
---@return number
function sm.render.getDrawDistance() end

---*Client only*  
---Gets the lighting cycle fraction.  
---@return number
function sm.render.getOutdoorLighting() end

---Return the screen coordinates that align with the given world position.  
---@param pos Vec3 World position to align
---@param width integer Screen width
---@param height integer Screen height
---@return number, number
function sm.render.getScreenCoordinatesFromWorldPosition(pos, width, height) end

---*Client only*  
---Checks if client is outdoor  
---@return boolean
function sm.render.isOutdoor() end

---*Client only*  
---Sets the lighting cycle fraction.  
---@param value number The fraction of the day cycle lighting.
function sm.render.setOutdoorLighting(value) end


---The data manager helps storing script data, both locally and between server and client in multiplayer games.  
sm.terrainData = {}

---Check if terrain data exists for this world.  
---@return boolean
function sm.terrainData.exists() end

---@deprecated Use [sm.terrainData.load]
---Legacy function for reading creative terrain. <strong>Do not use.</strong>  
---@return string
function sm.terrainData.legacy_getData() end

---@deprecated Use [sm.terrainData.load]
---Legacy function for reading creative custom terrain. <strong>Do not use.</strong>  
---@param id integer The id.
---@return any
function sm.terrainData.legacy_loadTerrainData(id) end

---@deprecated Use [sm.terrainData.save]
---Legacy function for storing creative custom terrain. <strong>Do not use.</strong>  
---@param id integer The id.
---@param data any The data. Any lua object.
function sm.terrainData.legacy_saveTerrainData(id, data) end

---@deprecated Use [sm.terrainData.save]
---Legacy function for storing creative terrain. <strong>Do not use.</strong>  
---@param data string The serialized bitser data.
function sm.terrainData.legacy_setData(data) end

---Load terrain data for this world if available.  
---@return any
function sm.terrainData.load() end

---Save and share terrain data over network from server to client.  
---The data is accessible from the same world.  
---@param data any The data. Any lua object.
function sm.terrainData.save(data) end


---Reads .tile file data  
sm.terrainTile = {}

---Returns a table of all assets in a terrain cell.  
---@param tileId Uuid The tile id.
---@param tileOffsetX integer The tile offset X.
---@param tileOffsetY integer The tile offset Y.
---@param sizeLevel integer The size level of asset.
---@return table
function sm.terrainTile.getAssetsForCell(tileId, tileOffsetX, tileOffsetY, sizeLevel) end

---Returns the clutter index at position (X,Y) in a tile.  
---@param tileId Uuid The tile id.
---@param tileOffsetX integer The tile offset X.
---@param tileOffsetY integer The tile offset Y.
---@param x integer The X.
---@param y integer The Y.
---@return number
function sm.terrainTile.getClutterIdxAt(tileId, tileOffsetX, tileOffsetY, x, y) end

---Returns the terrain color at position (X,Y) in a tile.  
---@param tileId Uuid The tile id.
---@param tileOffsetX integer The tile offset X.
---@param tileOffsetY integer The tile offset Y.
---@param lod integer The level of detail.
---@param x integer The X.
---@param y integer The Y.
---@return number
function sm.terrainTile.getColorAt(tileId, tileOffsetX, tileOffsetY, lod, x, y) end

---Returns the content of prefab.  
---@param prefabPath string The path to the prefab file.
---@param loadFlags integer A mask of content to load
---@return table
function sm.terrainTile.getContentFromPrefab(prefabPath, loadFlags) end

---Returns a table of all creations in a terrain cell.  
---@param tileId Uuid The tile id.
---@param tileOffsetX integer The tile offset X.
---@param tileOffsetY integer The tile offset Y.
---@return table
function sm.terrainTile.getCreationsForCell(tileId, tileOffsetX, tileOffsetY) end

---Returns the id of the tiles creator.  
---@param path string The tile's path.
---@return string
function sm.terrainTile.getCreatorId(path) end

---Returns all decals for a cell in a tile.  
---@param id Uuid The tile id
---@param x_offset integer The offset along the X axis
---@param y_offset integer The offset along the Y axis
---@return table
function sm.terrainTile.getDecalsForCell(id, x_offset, y_offset) end

---Returns a table of all harvestables in a terrain cell.  
---@param tileId Uuid The tile id.
---@param tileOffsetX integer The tile offset X.
---@param tileOffsetY integer The tile offset Y.
---@param sizeLevel integer The size level of harvestables.
---@return table
function sm.terrainTile.getHarvestablesForCell(tileId, tileOffsetX, tileOffsetY, sizeLevel) end

---Returns the terrain height at position (X,Y) in a tile.  
---@param tileId Uuid The tile id.
---@param tileOffsetX integer The tile offset X.
---@param tileOffsetY integer The tile offset Y.
---@param lod integer The level of detail.
---@param x integer The X.
---@param y integer The Y.
---@return number
function sm.terrainTile.getHeightAt(tileId, tileOffsetX, tileOffsetY, lod, x, y) end

---Returns a table of all kinematics in a terrain cell.  
---@param tileId Uuid The tile id.
---@param tileOffsetX integer The tile offset X.
---@param tileOffsetY integer The tile offset Y.
---@param sizeLevel integer The size level of kinematics.
---@return table
function sm.terrainTile.getKinematicsForCell(tileId, tileOffsetX, tileOffsetY, sizeLevel) end

---Returns the terrain material at position (X,Y) in a tile.  
---@param tileId Uuid The tile id.
---@param tileOffsetX integer The tile offset X.
---@param tileOffsetY integer The tile offset Y.
---@param lod integer The level of detail.
---@param x integer The X.
---@param y integer The Y.
---@return number
function sm.terrainTile.getMaterialAt(tileId, tileOffsetX, tileOffsetY, lod, x, y) end

---Returns all nodes for a cell in a tile.  
---@param id Uuid The tile id
---@param x_offset integer The offset along the X axis
---@param y_offset integer The offset along the Y axis
---@return table
function sm.terrainTile.getNodesForCell(id, x_offset, y_offset) end

---Returns all prefabs in a cell.  
---@param tileId Uuid The tile id.
---@param x_offset integer The offset along the X axis.
---@param y_offset integer The offset along the Y axis.
---@return table
function sm.terrainTile.getPrefabsForCell(tileId, x_offset, y_offset) end

---Returns the size of a tile as the number of cells along one of the axises.  
---@param path string The tile's path.
---@return integer
function sm.terrainTile.getSize(path) end

---Returns the uuid for a tile file.  
---@param path string The tile's path.
---@return Uuid
function sm.terrainTile.getTileUuid(path) end


---Allows reading and writing in game storage from terrain generation scripts.  
sm.terrainGeneration = {}

---Loads temporary data stored by terrain generation.  
---@param key any Key used to lookup the saved data.
---@return any
function sm.terrainGeneration.getTempData(key) end

---Loads data stored by terrain generation.  
---@param key any Key used to lookup the saved data.
---@return any
function sm.terrainGeneration.loadGameStorage(key) end

---Saves data produced from terrain generation and synchronizes to clients. Saved data can be retrived in later game sessions and by the game lua environment.    
---   
---@param key any Key used to lookup the saved data.
---@param data any Data to save. 
function sm.terrainGeneration.saveAndSyncGameStorage(key, data) end

---Saves data produced from terrain generation. Saved data can be retrived in later game sessions and by the game lua environment.    
---   
---@param key any Key used to lookup the saved data.
---@param data any Data to save. 
function sm.terrainGeneration.saveGameStorage(key, data) end

---Sets data produced from terrain generation and synchronizes to clients. This data is only valid during the game session.  
---   
---@param key any Key used to lookup the saved data.
---@param data any Data to save. 
function sm.terrainGeneration.setGameStorageNoSave(key, data) end

---Sets temporary data produced from terrain generation and synchronizes to clients.  
---   
---@param key any Key used to lookup the saved data.
---@param data any Data to save. 
function sm.terrainGeneration.setTempData(key, data) end


---@class CharacterClass
---A script class that is instanced for every [Character] in the game.  
---A [Character] is a temporary vessel controlled by a [Player] or [Unit].  
---Can receive events sent with [sm.event.sendToCharacter].  
---@field character Character The [Character] game object belonging to this class instance.
---@field network Network A [Network] object that can be used to send messages between client and server.
---@field data any Data from the "data" json element.
local CharacterClass = class()

---Called when the scripted object is created. This occurs when a new object is built, spawned, or loaded from the save file.  
function CharacterClass:server_onCreate() end

---Called when the scripted object is created. This occurs when a new object is built, spawned, or loaded from the save file.  
function CharacterClass:client_onCreate() end

---Called when the scripted object is destroyed.  
function CharacterClass:server_onDestroy() end

---Called when the scripted object is destroyed.  
function CharacterClass:client_onDestroy() end

---Called if the Lua script attached to the object is modified while the game is running.  
---**Note:**
---*This event requires Scrap Mechanic to be running with the '-dev' flag. This will allow scripts to automatically refresh upon changes.*
function CharacterClass:server_onRefresh() end

---Called if the Lua script attached to the object is modified while the game is running.  
---**Note:**
---*This event requires Scrap Mechanic to be running with the '-dev' flag. This will allow scripts to automatically refresh upon changes.*
function CharacterClass:client_onRefresh() end

---Called every game tick &ndash; 40 ticks a second. If the frame rate is lower than 40 fps, this event may be called twice.  
---During a fixed update, physics and logic between interactables are updated.  
---@param timeStep number The time period of a tick. (Is always 0.025, a 1/40th of a second.)
function CharacterClass:server_onFixedUpdate(timeStep) end

---Called every game tick &ndash; 40 ticks a second. If the frame rate is lower than 40 fps, this event may be called twice.  
---During a fixed update, physics and logic between interactables are updated.  
---@param timeStep number The time period of a tick. (Is always 0.025, a 1/40th of a second.)
function CharacterClass:client_onFixedUpdate(timeStep) end

---Called every frame.  
---During a frame update, graphics, animations and effects are updated.  
---**Warning:**
---*Because of how frequent this event is called, the game's frame rate is greatly affected by the amount of code executed here.*
---*For any non-graphics related code, consider using [CharacterClass.client_onFixedUpdate, client_onFixedUpdate] instead.*
---*If the event is not in use, consider removing it from the script. (Event callbacks that are not implemented will not be called.)*
---@param deltaTime number Delta time since the last frame.
function CharacterClass:client_onUpdate(deltaTime) end

---Called when the client receives new client data updates from the server set with [Network.setClientData].  
---Data set in this way is persistent and the latest data will automatically be sent to new clients.  
---The data will arrive after [CharacterClass.client_onCreate, client_onCreate] during the same tick.  
---Channel 1 will be received before channel 2 if both are updated.  
---@param data any Any lua object set with [Network.setClientData]
---@param channel integer Client data channel, 1 or 2. (default: 1)
function CharacterClass:client_onClientDataUpdate(data, channel) end

---Called when the [Character] is hit by a projectile.  
---**Note:**
---*If the shooter is destroyed before the hit lands, the shooter value will be nil.*
---@param position Vec3 The position in world space where the projectile hit the [Character].
---@param airTime number The time, in seconds, that the projectile spent flying before the hit.
---@param velocity Vec3 The velocity of the projectile at impact.
---@param projectileName string The name of the projectile. (Legacy, use uuid instead)
---@param shooter Player|Shape|Harvestable|nil The shooter, can be a [Player], [Shape], [Harvestable] or nil if unknown. Projectiles shot by a [Unit] will be nil on the client.
---@param damage number The damage value of the projectile.
---@param customData any A Lua object that can be defined at shoot time using [sm.projectile.customProjectileAttack] or an other custom version. 
---@param normal Vec3 The normal at the point of impact.
---@param uuid Uuid The uuid of the projectile.
function CharacterClass:client_onProjectile(position, airTime, velocity, projectileName, shooter, damage, customData, normal, uuid) end

---Called when the [Character] is hit by a melee hit.  
---@param position Vec3 The position in world space where the [Character] was hit.
---@param attacker Player|nil The attacker. Can be a [Player] or nil if unknown. Attacks made by a [Unit] will be nil on the client.
---@param damage integer The damage value of the melee hit.
---@param power number The physical impact impact of the hit.
---@param direction Vec3 The direction that the melee attack was made.
---@param normal Vec3 The normal at the point of impact.
function CharacterClass:client_onMelee(position, attacker, damage, power, direction, normal) end

---Called when the [Character] collides with another object.  
---@param other Shape|Character|Harvestable|Lift|nil The other object. Nil if terrain.
---@param position Vec3 The position in world space where the collision occurred.
---@param selfPointVelocity Vec3 The velocity that that the [Character] had at the point of collision.
---@param otherPointVelocity Vec3 The velocity that that the other object had at the point of collision.
---@param normal Vec3 The collision normal between the [Character] and the other other object.
function CharacterClass:client_onCollision(other, position, selfPointVelocity, otherPointVelocity, normal) end

---Called when graphics are loaded for the [Character].  
---After this; graphics related functions can be called, like accessing animations.  
function CharacterClass:client_onGraphicsLoaded() end

---Called when graphics are unloaded for the [Character].  
---After this; graphics related functions no longer has an effect or will fail.  
function CharacterClass:client_onGraphicsUnloaded() end

---Called when a [Player] is interacting with the [Character] by pressing the 'Use' key (default 'E').  
---@param character Character The [Character] of the [Player] that is interacting with this [Character].
---@param state boolean The interaction state. Always true. The [CharacterClass] only receives the key down event.
function CharacterClass:client_onInteract(character, state) end

---Called to check whether the [Character] can be interacted with at this moment.  
---**Note:**
---*This callback is also responsible for updating interaction text shown to the player using [sm.gui.setInteractionText].*
---@param character Character The [Character] of the [Player] that is looking at this [Character].
---@return boolean
function CharacterClass:client_canInteract(character) end

---Called when the [Character] receives an event from [Player.sendCharacterEvent] or [Unit.sendCharacterEvent].  
---This is usually for triggering animations on the character.  
---For more extensive events, see [sm.event.sendToCharacter].  
---@param event string The event name.
function CharacterClass:client_onEvent(event) end


---@class GameClass
---A script class that defines the game mode. Only one instance of this class is made.  
---This is the first script that will be run.  
---The game script is responsible for creating and managing [World, worlds].  
---Can receive events sent with [sm.event.sendToGame].  
---@field network Network A [Network] object that can be used to send messages between client and server.
---@field storage Storage (Server side only.) A [Storage] object that can be used to store data for the next time loading this object after being unloaded.
---@field data any Game start data.
local GameClass = class()

---Sets default player inventory size. (Defaults to 40)  
---@type integer
GameClass.defaultInventorySize = {}

---Enables or disables enemy aggression. (Defaults to true)  
---@type boolean
GameClass.enableAggro = {}

---Enables or disables ammo consumption. (Defaults to false)  
---@type boolean
GameClass.enableAmmoConsumption = {}

---Enables or disables fuel consumption. (Defaults to false)  
---@type boolean
GameClass.enableFuelConsumption = {}

---Enables or disables limited inventory. (Defaults to false)  
---When limited in inventory is on, items have a limited amount. When off, the player has access to all items. (Except for items with json value "hidden": true)  
---@type boolean
GameClass.enableLimitedInventory = {}

---Enables or disables build restrictions. (Defaults to false)  
---@type boolean
GameClass.enableRestrictions = {}

---Enables or disables interactable part upgrade. (Defaults to false)  
---@type boolean
GameClass.enableUpgrade = {}

---Called when the scripted object is created. This occurs when a new object is built, spawned, or loaded from the save file.  
function GameClass:server_onCreate() end

---Called when the scripted object is created. This occurs when a new object is built, spawned, or loaded from the save file.  
function GameClass:client_onCreate() end

---Called when the scripted object is destroyed.  
function GameClass:server_onDestroy() end

---Called when the scripted object is destroyed.  
function GameClass:client_onDestroy() end

---Called if the Lua script attached to the object is modified while the game is running.  
---**Note:**
---*This event requires Scrap Mechanic to be running with the '-dev' flag. This will allow scripts to automatically refresh upon changes.*
function GameClass:server_onRefresh() end

---Called if the Lua script attached to the object is modified while the game is running.  
---**Note:**
---*This event requires Scrap Mechanic to be running with the '-dev' flag. This will allow scripts to automatically refresh upon changes.*
function GameClass:client_onRefresh() end

---Called every game tick &ndash; 40 ticks a second. If the frame rate is lower than 40 fps, this event may be called twice.  
---During a fixed update, physics and logic between interactables are updated.  
---@param timeStep number The time period of a tick. (Is always 0.025, a 1/40th of a second.)
function GameClass:server_onFixedUpdate(timeStep) end

---Called every game tick &ndash; 40 ticks a second. If the frame rate is lower than 40 fps, this event may be called twice.  
---During a fixed update, physics and logic between interactables are updated.  
---@param timeStep number The time period of a tick. (Is always 0.025, a 1/40th of a second.)
function GameClass:client_onFixedUpdate(timeStep) end

---Called every frame.  
---During a frame update, graphics, animations and effects are updated.  
---**Warning:**
---*Because of how frequent this event is called, the game's frame rate is greatly affected by the amount of code executed here.*
---*For any non-graphics related code, consider using [GameClass.client_onFixedUpdate, client_onFixedUpdate] instead.*
---*If the event is not in use, consider removing it from the script. (Event callbacks that are not implemented will not be called.)*
---@param deltaTime number Delta time since the last frame.
function GameClass:client_onUpdate(deltaTime) end

---Called when the client receives new client data updates from the server set with [Network.setClientData].  
---Data set in this way is persistent and the latest data will automatically be sent to new clients.  
---The data will arrive after [GameClass.client_onCreate, client_onCreate] during the same tick.  
---Channel 1 will be received before channel 2 if both are updated.  
---@param data any Any lua object set with [Network.setClientData]
---@param channel integer Client data channel, 1 or 2. (default: 1)
function GameClass:client_onClientDataUpdate(data, channel) end

---Called when a [Player] joins the game.  
---@param player Player The joining player.
---@param newPlayer boolean True if the player has not been in this game before.
function GameClass:server_onPlayerJoined(player, newPlayer) end

---Called when a [Player] leaves the game.  
---@param player Player The leaving player.
function GameClass:server_onPlayerLeft(player) end

---Challenge Mode only!  
---Called when the user wants to reset the challenge level.  
function GameClass:server_onReset() end

---Challenge Mode only!  
---Called when the user wants to restart the challenge level.  
function GameClass:server_onRestart() end

---Challenge Builder only!  
---Called when the user wants to save the challenge level.  
function GameClass:server_onSaveLevel() end

---Challenge Builder only!  
---Called when the user wants to save and test the challenge level.  
function GameClass:server_onTestLevel() end

---Challenge Builder only!  
---Called when the user wants to stop testing the challenge level.  
function GameClass:server_onStopTest() end

---Called when the loading screen is lifted when entering a game.  
function GameClass:client_onLoadingScreenLifted() end

---Called when the user changes language in the in-game menus.  
---Possible language values:  
---"Brazilian", "Chinese", "English", "French", "German", "Italian", "Japanese", "Korean", "Polish", "Russian", "Spanish"  
---@param language string The new language.
function GameClass:client_onLanguageChange(language) end


---@class HarvestableClass
---A script class that is instanced for every [Harvestable] in the game.  
---A tree or a plant that can be harvested is a typical case of a harvestable.  
---Can receive events sent with [sm.event.sendToHarvestable].  
---@field harvestable Harvestable The [Harvestable] game object belonging to this class instance.
---@field network Network A [Network] object that can be used to send messages between client and server.
---@field storage Storage (Server side only.) A [Storage] object that can be used to store data for the next time loading this object after being unloaded.
---@field data any Data from the "data" json element.
---@field params any Parameter sent to [sm.harvestable.create] or set in the terrain generation script.
local HarvestableClass = class()

---Sets the number of animation poses the harvestable's model is able to use.  
---Value can be are integers 0-3. (Defaults to 0, no poses)  
---A value greater that 0 indicates that the renderable's "mesh" is set up blend into "pose0", "pose1", "pose2".  
---This is, for instance, used for growing plants.  
---@type integer
HarvestableClass.poseWeightCount = {}

---Called when the scripted object is created. This occurs when a new object is built, spawned, or loaded from the save file.  
function HarvestableClass:server_onCreate() end

---Called when the scripted object is created. This occurs when a new object is built, spawned, or loaded from the save file.  
function HarvestableClass:client_onCreate() end

---Called when the scripted object is destroyed.  
function HarvestableClass:server_onDestroy() end

---Called when the scripted object is destroyed.  
function HarvestableClass:client_onDestroy() end

---Called if the Lua script attached to the object is modified while the game is running.  
---**Note:**
---*This event requires Scrap Mechanic to be running with the '-dev' flag. This will allow scripts to automatically refresh upon changes.*
function HarvestableClass:server_onRefresh() end

---Called if the Lua script attached to the object is modified while the game is running.  
---**Note:**
---*This event requires Scrap Mechanic to be running with the '-dev' flag. This will allow scripts to automatically refresh upon changes.*
function HarvestableClass:client_onRefresh() end

---Called every game tick &ndash; 40 ticks a second. If the frame rate is lower than 40 fps, this event may be called twice.  
---During a fixed update, physics and logic between interactables are updated.  
---@param timeStep number The time period of a tick. (Is always 0.025, a 1/40th of a second.)
function HarvestableClass:server_onFixedUpdate(timeStep) end

---Called every game tick &ndash; 40 ticks a second. If the frame rate is lower than 40 fps, this event may be called twice.  
---During a fixed update, physics and logic between interactables are updated.  
---@param timeStep number The time period of a tick. (Is always 0.025, a 1/40th of a second.)
function HarvestableClass:client_onFixedUpdate(timeStep) end

---Called every frame.  
---During a frame update, graphics, animations and effects are updated.  
---**Warning:**
---*Because of how frequent this event is called, the game's frame rate is greatly affected by the amount of code executed here.*
---*For any non-graphics related code, consider using [HarvestableClass.client_onFixedUpdate, client_onFixedUpdate] instead.*
---*If the event is not in use, consider removing it from the script. (Event callbacks that are not implemented will not be called.)*
---@param deltaTime number Delta time since the last frame.
function HarvestableClass:client_onUpdate(deltaTime) end

---Called when the client receives new client data updates from the server set with [Network.setClientData].  
---Data set in this way is persistent and the latest data will automatically be sent to new clients.  
---The data will arrive after [HarvestableClass.client_onCreate, client_onCreate] during the same tick.  
---Channel 1 will be received before channel 2 if both are updated.  
---@param data any Any lua object set with [Network.setClientData]
---@param channel integer Client data channel, 1 or 2. (default: 1)
function HarvestableClass:client_onClientDataUpdate(data, channel) end

---Called when the [Harvestable] is unloaded from the game because no [Player]'s [Character] is close enough to it. Also called when exiting the game.  
function HarvestableClass:server_onUnload() end

---Called occasionally on the [HarvestableClass] to indicate that some time has passed.  
---For performance reasons; it recommended to use this instead of [HarvestableClass.server_onFixedUpdate] for updates that do not need to happen frequently.  
---Use [sm.game.getCurrentTick] to calculate the time.  
function HarvestableClass:server_onReceiveUpdate() end

---Called when the [Harvestable] collides with another object.  
---@param other Shape|Character The other object.
---@param position Vec3 The position in world space where the collision occurred.
---@param selfPointVelocity Vec3 The velocity that the [Harvestable] had at the point of collision.
---@param otherPointVelocity Vec3 The velocity that the other object had at the point of collision.
---@param normal Vec3 The collision normal between the [Harvestable] and the other other object.
function HarvestableClass:client_onCollision(other, position, selfPointVelocity, otherPointVelocity, normal) end

---Called when the [Harvestable] collides with another object.  
---@param other Shape|Character The other object.
---@param position Vec3 The position in world space where the collision occurred.
---@param selfPointVelocity Vec3 The velocity that the [Harvestable] had at the point of collision.
---@param otherPointVelocity Vec3 The velocity that the other object had at the point of collision.
---@param normal Vec3 The collision normal between the [Harvestable] and the other other object.
function HarvestableClass:server_onCollision(other, position, selfPointVelocity, otherPointVelocity, normal) end

---Called when the [Harvestable] is hit by a projectile.  
---**Note:**
---*If the shooter is destroyed before the projectile hits, the shooter value will be nil.*
---@param position Vec3 The position in world space where the projectile hit the [Harvestable].
---@param airTime number The time, in seconds, that the projectile spent flying before the hit.
---@param velocity Vec3 The velocity of the projectile at impact.
---@param projectileName string The name of the projectile. (Legacy, use uuid instead)
---@param shooter Player|Shape|Harvestable|nil The shooter, can be a [Player], [Shape], [Harvestable] or nil if unknown. Projectiles shot by a [Unit] will be nil on the client.
---@param damage integer The damage value of the projectile.
---@param customData any A Lua object that can be defined at shoot time using [sm.projectile.customProjectileAttack] or an other custom version. 
---@param normal Vec3 The normal at the point of impact.
---@param uuid Uuid The uuid of the projectile.
function HarvestableClass:client_onProjectile(position, airTime, velocity, projectileName, shooter, damage, customData, normal, uuid) end

---Called when the [Harvestable] is hit by a projectile.  
---**Note:**
---*If the shooter is destroyed before the projectile hits, the shooter value will be nil.*
---@param position Vec3 The position in world space where the projectile hit the [Harvestable].
---@param airTime number The time, in seconds, that the projectile spent flying before the hit.
---@param velocity Vec3 The velocity of the projectile at impact.
---@param projectileName string The name of the projectile. (Legacy, use uuid instead)
---@param shooter Player|Unit|Shape|Harvestable|nil The shooter. Can be a [Player], [Unit], [Shape], [Harvestable] or nil if unknown.
---@param damage integer The damage value of the projectile.
---@param customData any A Lua object that can be defined at shoot time using [sm.projectile.customProjectileAttack] or an other custom version. 
---@param normal Vec3 The normal at the point of impact.
---@param uuid Uuid The uuid of the projectile.
function HarvestableClass:server_onProjectile(position, airTime, velocity, projectileName, shooter, damage, customData, normal, uuid) end

---Called when the [Harvestable] is hit by an explosion.  
---@param center Vec3 The center of the explosion.
---@param destructionLevel integer The level of destruction done by this explosion. Corresponds to the "durability" rating of a [Shape].
function HarvestableClass:server_onExplosion(center, destructionLevel) end

---Called when the [Harvestable] is hit by a melee attack.  
---**Note:**
---*If the attacker is destroyed before the hit lands, the attacker value will be nil.*
---@param position Vec3 The position in world space where the [Harvestable] was hit.
---@param attacker Player|nil The attacker. Can be a [Player] or nil if unknown. Attacks made by a [Unit] will be nil on the client.
---@param damage integer The damage value of the melee hit.
---@param power number The physical impact of the hit.
---@param direction Vec3 The direction that the melee attack was made.
---@param normal Vec3 The normal at the point of impact.
function HarvestableClass:client_onMelee(position, attacker, damage, power, direction, normal) end

---Called when the [Harvestable] is hit by a melee attack.  
---**Note:**
---*If the attacker is destroyed before the hit lands, the attacker value will be nil.*
---@param position Vec3 The position in world space where the [Harvestable] was hit.
---@param attacker Player|Unit|nil The attacker. Can be a [Player], [Unit] or nil if unknown.
---@param damage integer The damage value of the melee hit.
---@param power number The physical impact of the hit.
---@param direction Vec3 The direction that the melee attack was made.
---@param normal Vec3 The normal at the point of impact.
function HarvestableClass:server_onMelee(position, attacker, damage, power, direction, normal) end

---Called when a [Player] wants to remove the [Harvestable].  
---**Note:**
---*The [HarvestableClass] is responsible for doing the remove using [Harvestable.destroy].*
---@param player Player The [Player] that wants to remove the [Harvestable].
function HarvestableClass:server_onRemoved(player) end

---Called to check whether the [Harvestable] can be erased at this moment.  
---@return boolean
function HarvestableClass:client_canErase() end

---Called to check whether the [Harvestable] can be erased at this moment.  
---@return boolean
function HarvestableClass:server_canErase() end

---Called when a [Player] is interacting with the [Harvestable] by pressing the 'Use' key (default 'E').  
---@param character Character The [Character] of the [Player] that is interacting with the [Harvestable].
---@param state boolean The interaction state. Always true. The [HarvestableClass] only receives the key down event.
function HarvestableClass:client_onInteract(character, state) end

---Called to check whether the [Harvestable] can be interacted with at this moment.  
---**Note:**
---*This callback is also responsible for updating interaction text shown to the player using [sm.gui.setInteractionText].*
---@param character Character The [Character] of the [Player] that is looking at the [Harvestable].
---@return boolean
function HarvestableClass:client_canInteract(character) end

---Called when the harvestable receives input from a player with the [Character] locked to the [Harvestable].  
---When a [Character] is seated in a [Harvestable] with a "seat" component, the [Character] is also considered locked to the [Harvestable].  
---@param action integer The action as an integer value. More details in [sm.interactable.actions].
---@param state boolean True on begin action, false on end action.
function HarvestableClass:client_onAction(action, state) end


---@class PlayerClass
---A script class that is instanced for every active [Player] in the game.  
---A player represent a user controlling a [Character].  
---The player script handles actions made by the user.  
---Can receive events sent with [sm.event.sendToPlayer].  
---@field player Player The [Player] game object belonging to this class instance.
---@field network Network A [Network] object that can be used to send messages between client and server.
---@field storage Storage (Server side only.) A [Storage] object that can be used to store data for the next time loading this object after being unloaded.
local PlayerClass = class()

---Called when the scripted object is created. This occurs when a new object is built, spawned, or loaded from the save file.  
function PlayerClass:server_onCreate() end

---Called when the scripted object is created. This occurs when a new object is built, spawned, or loaded from the save file.  
function PlayerClass:client_onCreate() end

---Called when the scripted object is destroyed.  
function PlayerClass:server_onDestroy() end

---Called when the scripted object is destroyed.  
function PlayerClass:client_onDestroy() end

---Called if the Lua script attached to the object is modified while the game is running.  
---**Note:**
---*This event requires Scrap Mechanic to be running with the '-dev' flag. This will allow scripts to automatically refresh upon changes.*
function PlayerClass:server_onRefresh() end

---Called if the Lua script attached to the object is modified while the game is running.  
---**Note:**
---*This event requires Scrap Mechanic to be running with the '-dev' flag. This will allow scripts to automatically refresh upon changes.*
function PlayerClass:client_onRefresh() end

---Called every game tick &ndash; 40 ticks a second. If the frame rate is lower than 40 fps, this event may be called twice.  
---During a fixed update, physics and logic between interactables are updated.  
---@param timeStep number The time period of a tick. (Is always 0.025, a 1/40th of a second.)
function PlayerClass:server_onFixedUpdate(timeStep) end

---Called every game tick &ndash; 40 ticks a second. If the frame rate is lower than 40 fps, this event may be called twice.  
---During a fixed update, physics and logic between interactables are updated.  
---@param timeStep number The time period of a tick. (Is always 0.025, a 1/40th of a second.)
function PlayerClass:client_onFixedUpdate(timeStep) end

---Called every frame.  
---During a frame update, graphics, animations and effects are updated.  
---**Warning:**
---*Because of how frequent this event is called, the game's frame rate is greatly affected by the amount of code executed here.*
---*For any non-graphics related code, consider using [PlayerClass.client_onFixedUpdate, client_onFixedUpdate] instead.*
---*If the event is not in use, consider removing it from the script. (Event callbacks that are not implemented will not be called.)*
---@param deltaTime number Delta time since the last frame.
function PlayerClass:client_onUpdate(deltaTime) end

---Called when the client receives new client data updates from the server set with [Network.setClientData].  
---Data set in this way is persistent and the latest data will automatically be sent to new clients.  
---The data will arrive after [PlayerClass.client_onCreate, client_onCreate] during the same tick.  
---Channel 1 will be received before channel 2 if both are updated.  
---@param data any Any lua object set with [Network.setClientData]
---@param channel integer Client data channel, 1 or 2. (default: 1)
function PlayerClass:client_onClientDataUpdate(data, channel) end

---Called when the player presses or releases the 'Use' key (default 'E').  
---@param character Character The [Player]'s [Character]'. Same as self.player.character.
---@param state boolean The interaction state. (true if pressed, false if released)
function PlayerClass:client_onInteract(character, state) end

---Called when the player presses the 'Cancel' key (default 'Esc').  
function PlayerClass:client_onCancel() end

---Called when the player presses the 'Reload' key (default 'R').  
function PlayerClass:client_onReload() end

---Called when the [Player]'s [Character] is hit by a projectile.  
---**Note:**
---*If the shooter is destroyed before the projectile hits, the shooter value will be nil.*
---@param position Vec3 The position in world space where the projectile hit the [Player]'s [Character].
---@param airTime number The time, in seconds, that the projectile spent flying before the hit.
---@param velocity Vec3 The velocity of the projectile at impact.
---@param projectileName string The name of the projectile. (Legacy, use uuid instead)
---@param shooter Player|Unit|Shape|Harvestable|nil The shooter. Can be a [Player], [Unit], [Shape], [Harvestable] or nil if unknown.
---@param damage integer The damage value of the projectile.
---@param customData any A Lua object that can be defined at shoot time using [sm.projectile.customProjectileAttack] or an other custom version. 
---@param normal Vec3 The normal at the point of impact.
---@param uuid Uuid The uuid of the projectile.
function PlayerClass:server_onProjectile(position, airTime, velocity, projectileName, shooter, damage, customData, normal, uuid) end

---Called when the [Player]'s [Character] is hit by an explosion.  
---@param center Vec3 The center of the explosion.
---@param destructionLevel integer The level of destruction done by this explosion. Corresponds to the 'durability' rating of a [Shape].
function PlayerClass:server_onExplosion(center, destructionLevel) end

---Called when the [Player]'s [Character] is hit by a melee hit.  
---**Note:**
---*If the attacker is destroyed before the projectile hits, the attacker value will be nil.*
---@param position Vec3 The position in world space where the [Player]'s [Character] was hit.
---@param attacker Player|Unit|nil The attacker. Can be a [Player], [Unit] or nil if unknown.
---@param damage integer The damage value of the melee hit.
---@param power number The physical impact impact of the hit.
---@param direction Vec3 The direction that the melee attack was made.
---@param normal Vec3 The normal at the point of impact.
function PlayerClass:server_onMelee(position, attacker, damage, power, direction, normal) end

---Called when the [Player]'s [Character] collides with another object.  
---@param other Shape|Character|Harvestable|Lift|nil The other object. Nil if terrain.
---@param position Vec3 The position in world space where the collision occurred.
---@param selfPointVelocity Vec3 The velocity that that the [Player]'s [Character] had at the point of collision.
---@param otherPointVelocity Vec3 The velocity that that the other object had at the point of collision.
---@param normal Vec3 The collision normal between the [Player]'s [Character] and the other other object.
function PlayerClass:server_onCollision(other, position, selfPointVelocity, otherPointVelocity, normal) end

---Called when the [Player]'s [Character] is crushed.  
function PlayerClass:server_onCollisionCrush() end

---Called when the [Player] removed a [Shape] from the [World].  
---Will receive a table of tables listing the items removed by this action.  
---Element format:   
---[Uuid]uuidThe item uuid.  
---integeramountThe amount of items with this uuid.  
---stringtypeType of shape removed. Can be "part", "block" or "joint".  
---@param items table A table listing the removed items. {{uuid=[Uuid], amount=integer, type=string}, ..}
function PlayerClass:server_onShapeRemoved(items) end

---Called when the [Player] has changes in the inventory [Container].  
---Will receive a table listing the changes.  
---Element format:   
---[Uuid]uuidThe item uuid  
---integerdifferenceThe change in amount. Positive numbers mean item gain, negative item loss.  
---[Tool]tool(Optional) If the item is a [Tool], this is the tool. Otherwise nil.  
---@param inventory Container The player's inventory [Container].
---@param changes table A table listing the changes. {{uuid=[Uuid], difference=integer, tool=[Tool]}, ..}
function PlayerClass:server_onInventoryChanges(inventory, changes) end


---@class ScriptableObjectClass
---A script class that doesn't represent any particular game object.  
---The scriptable object is automatically synchronized to all clients.  
---Can receive events sent with [sm.event.sendToScriptableObject].  
---@field scriptableObject ScriptableObject The [ScriptableObject] belonging to this class instance.
---@field network Network A [Network] object that can be used to send messages between client and server.
---@field storage Storage (Server side only, if [ScriptableObjectClass.isSaveObject, isSaveObject] is enabled) A [Storage] object that can be used to store data for the next time loading this object after being unloaded.
---@field data any Data from the "data" json element.
---@field params any Parameter sent to [sm.scriptableObject.createScriptableObject].
local ScriptableObjectClass = class()

---Enables or disables saving of this scriptable object. (Defaults to false)  
---If enabled, the [ScriptableObject] will be recreated when loading a game. Otherwise, the [ScriptableObject] is considered a temporary object.  
---**Note:**
---*If disabled, self.storage can not be used.*
---@type boolean
ScriptableObjectClass.isSaveObject = {}

---Called when the scripted object is created. This occurs when a new object is built, spawned, or loaded from the save file.  
function ScriptableObjectClass:server_onCreate() end

---Called when the scripted object is created. This occurs when a new object is built, spawned, or loaded from the save file.  
function ScriptableObjectClass:client_onCreate() end

---Called when the scripted object is destroyed.  
function ScriptableObjectClass:server_onDestroy() end

---Called when the scripted object is destroyed.  
function ScriptableObjectClass:client_onDestroy() end

---Called if the Lua script attached to the object is modified while the game is running.  
---**Note:**
---*This event requires Scrap Mechanic to be running with the '-dev' flag. This will allow scripts to automatically refresh upon changes.*
function ScriptableObjectClass:server_onRefresh() end

---Called if the Lua script attached to the object is modified while the game is running.  
---**Note:**
---*This event requires Scrap Mechanic to be running with the '-dev' flag. This will allow scripts to automatically refresh upon changes.*
function ScriptableObjectClass:client_onRefresh() end

---Called every game tick &ndash; 40 ticks a second. If the frame rate is lower than 40 fps, this event may be called twice.  
---During a fixed update, physics and logic between interactables are updated.  
---@param timeStep number The time period of a tick. (Is always 0.025, a 1/40th of a second.)
function ScriptableObjectClass:server_onFixedUpdate(timeStep) end

---Called every game tick &ndash; 40 ticks a second. If the frame rate is lower than 40 fps, this event may be called twice.  
---During a fixed update, physics and logic between interactables are updated.  
---@param timeStep number The time period of a tick. (Is always 0.025, a 1/40th of a second.)
function ScriptableObjectClass:client_onFixedUpdate(timeStep) end

---Called every frame.  
---During a frame update, graphics, animations and effects are updated.  
---**Warning:**
---*Because of how frequent this event is called, the game's frame rate is greatly affected by the amount of code executed here.*
---*For any non-graphics related code, consider using [ScriptableObjectClass.client_onFixedUpdate, client_onFixedUpdate] instead.*
---*If the event is not in use, consider removing it from the script. (Event callbacks that are not implemented will not be called.)*
---@param deltaTime number Delta time since the last frame.
function ScriptableObjectClass:client_onUpdate(deltaTime) end

---Called when the client receives new client data updates from the server set with [Network.setClientData].  
---Data set in this way is persistent and the latest data will automatically be sent to new clients.  
---The data will arrive after [ScriptableObjectClass.client_onCreate, client_onCreate] during the same tick.  
---Channel 1 will be received before channel 2 if both are updated.  
---@param data any Any lua object set with [Network.setClientData]
---@param channel integer Client data channel, 1 or 2. (default: 1)
function ScriptableObjectClass:client_onClientDataUpdate(data, channel) end


---@class ShapeClass
---A script class that is instanced for every "scripted" [Interactable] [Shape] in the game.  
---An interactable part is a [Shape] that is usually built by the player and can be interacted with. For instance a button or an engine.  
---Can receive events sent with [sm.event.sendToInteractable].  
---@field interactable Interactable The [Interactable] game object belonging to this class instance. (The same as shape.interactable)
---@field shape Shape The [Shape] game object that the [Interactable] is attached to. (The same as interactable.shape)
---@field network Network A [Network] object that can be used to send messages between client and server.
---@field storage Storage (Server side only.) A [Storage] object that can be used to store data for the next time loading this object after being unloaded.
---@field data any Data from the "data" json element.
---@field params any Parameter set with [Interactable.setParams] when created from a script.
local ShapeClass = class()

---Sets the connection-point highlight color. The connection-point is shown when using the <em>Connect Tool</em> and selecting the interactable. (Defaults to white)  
---@type Color
ShapeClass.colorHighlight = {}

---Sets the connection-point normal color. The connection-point is shown when using the <em>Connect Tool</em>. (Defaults to gray)  
---@type Color
ShapeClass.colorNormal = {}

---Sets the connection input type flags. (See [sm.interactable.connectionType]) (Defaults to 0, no input)  
---@type integer
ShapeClass.connectionInput = {}

---Sets the connection output type flags. (See [sm.interactable.connectionType]) (Defaults to 0, no output)  
---@type integer
ShapeClass.connectionOutput = {}

---Sets the maximum number of allowed child connections &ndash; the number of output connections. (Defaults to 0, no allowed child connections)  
---**Note:**
---*Implement [ShapeClass.client_getAvailableChildConnectionCount, client_getAvailableChildConnectionCount] to control specific types.*
---@type integer
ShapeClass.maxChildCount = {}

---Sets the maximum number of allowed parent connections &ndash; the number of input connections. (Defaults to 0, no allowed parent connections)  
---**Note:**
---*Implement [ShapeClass.client_getAvailableParentConnectionCount, client_getAvailableParentConnectionCount] to control specific types.*
---@type integer
ShapeClass.maxParentCount = {}

---Sets the number of animation poses the shape's model is able to use.  
---Value can be are integers 0-3. (Defaults to 0, no poses)  
---A value greater that 0 indicates that the renderable's "mesh" is set up blend into "pose0", "pose1", "pose2".  
---This is, for instance, used to move the lever on the engine.  
---@type integer
ShapeClass.poseWeightCount = {}

---Called when the scripted object is created. This occurs when a new object is built, spawned, or loaded from the save file.  
function ShapeClass:server_onCreate() end

---Called when the scripted object is created. This occurs when a new object is built, spawned, or loaded from the save file.  
function ShapeClass:client_onCreate() end

---Called when the scripted object is destroyed.  
function ShapeClass:server_onDestroy() end

---Called when the scripted object is destroyed.  
function ShapeClass:client_onDestroy() end

---Called if the Lua script attached to the object is modified while the game is running.  
---**Note:**
---*This event requires Scrap Mechanic to be running with the '-dev' flag. This will allow scripts to automatically refresh upon changes.*
function ShapeClass:server_onRefresh() end

---Called if the Lua script attached to the object is modified while the game is running.  
---**Note:**
---*This event requires Scrap Mechanic to be running with the '-dev' flag. This will allow scripts to automatically refresh upon changes.*
function ShapeClass:client_onRefresh() end

---Called every game tick &ndash; 40 ticks a second. If the frame rate is lower than 40 fps, this event may be called twice.  
---During a fixed update, physics and logic between interactables are updated.  
---@param timeStep number The time period of a tick. (Is always 0.025, a 1/40th of a second.)
function ShapeClass:server_onFixedUpdate(timeStep) end

---Called every game tick &ndash; 40 ticks a second. If the frame rate is lower than 40 fps, this event may be called twice.  
---During a fixed update, physics and logic between interactables are updated.  
---@param timeStep number The time period of a tick. (Is always 0.025, a 1/40th of a second.)
function ShapeClass:client_onFixedUpdate(timeStep) end

---Called every frame.  
---During a frame update, graphics, animations and effects are updated.  
---**Warning:**
---*Because of how frequent this event is called, the game's frame rate is greatly affected by the amount of code executed here.*
---*For any non-graphics related code, consider using [ShapeClass.client_onFixedUpdate, client_onFixedUpdate] instead.*
---*If the event is not in use, consider removing it from the script. (Event callbacks that are not implemented will not be called.)*
---@param deltaTime number Delta time since the last frame.
function ShapeClass:client_onUpdate(deltaTime) end

---Called when the client receives new client data updates from the server set with [Network.setClientData].  
---Data set in this way is persistent and the latest data will automatically be sent to new clients.  
---The data will arrive after [ShapeClass.client_onCreate, client_onCreate] during the same tick.  
---Channel 1 will be received before channel 2 if both are updated.  
---@param data any Any lua object set with [Network.setClientData]
---@param channel integer Client data channel, 1 or 2. (default: 1)
function ShapeClass:client_onClientDataUpdate(data, channel) end

---Called when the [Interactable] is unloaded from the game because no [Player]'s [Character] is close enough to it. Also called when exiting the game.  
---**Note:**
---*The creation, consisting of one or more [Body, bodies], consisting of one or more [Shape, shapes] joined together with [Joint, joints] are always unloaded at the same time.*
function ShapeClass:server_onUnload() end

---Called when a [Player] is interacting with the [Interactable] by pressing the 'Use' key (default 'E') or pressing '0&ndash;9' if the [Interactable] is connected to a seat. (See: [Interactable.pressSeatInteractable])  
---**Note:**
---*If this method is defined, the player will see the interaction text "E Use" when looking at the [Shape].*
---```
----- Example of interaction
---function MySwitch.client_onInteract( self, _, state ) 
---	if state == true then
---		self.network:sendToServer( 'sv_n_toggle' )
---	end
---end
---
---function MySwitch.sv_n_toggle( self ) 
---	-- Toggle on and off
---	self.interactable.active = not self.interactable.active
---end
---```
---@param character Character The [Character] of the [Player] that is interacting with the [Interactable].
---@param state boolean The interaction state. (true if pressed, false if released)
function ShapeClass:client_onInteract(character, state) end

---Called when a [Player] is tinkering with the [Interactable] by pressing the 'Tinker' key (default 'U').  
---**Note:**
---*Tinkering usually means opening the upgrade menu for seats.*
---@param character Character The [Character] of the [Player] that is tinkering with the [Interactable].
---@param state boolean The interaction state. (true if pressed, false if released)
function ShapeClass:client_onTinker(character, state) end

---Called when a [Player] is interacting with the [Interactable] through a connected [Joint].  
---@param character Character The [Character] of the [Player] that is interacting with the [Interactable].
---@param state boolean The interaction state. Always true. [ShapeClass.client_onInteractThroughJoint, client_onInteractThroughJoint] only receives the key down event.
---@param joint Joint The [Joint] that the [Player] interacted through.
function ShapeClass:client_onInteractThroughJoint(character, state, joint) end

---Called when the interactable receives input from a [Player] with the [Character] locked to the [Interactable].  
---When a [Character] is seated in an [Interactable] [Shape] with a "seat" component, the [Character] is also considered locked to the [Interactable].  
---@param action integer The action as an integer value. More details in [sm.interactable.actions].
---@param state boolean True on begin action, false on end action.
function ShapeClass:client_onAction(action, state) end

---Called when the [Shape] is hit by a projectile.  
---**Note:**
---*If the shooter is destroyed before the projectile hits, the shooter value will be nil.*
---@param position Vec3 The position in world space where the projectile hit the [Shape].
---@param airTime number The time, in seconds, that the projectile spent flying before the hit.
---@param velocity Vec3 The velocity of the projectile at impact.
---@param projectileName string The name of the projectile. (Legacy, use uuid instead)
---@param shooter Player|Shape|Harvestable|nil The shooter, can be a [Player], [Shape], [Harvestable] or nil if unknown. Projectiles shot by a [Unit] will be nil on the client.
---@param damage number The damage value of the projectile.
---@param customData any A Lua object that can be defined at shoot time using [sm.projectile.customProjectileAttack] or an other custom version. 
---@param normal Vec3 The normal at the point of impact.
---@param uuid Uuid The uuid of the projectile.
function ShapeClass:client_onProjectile(position, airTime, velocity, projectileName, shooter, damage, customData, normal, uuid) end

---Called when the [Shape] is hit by a projectile.  
---**Note:**
---*If the shooter is destroyed before the projectile hits, the shooter value will be nil.*
---@param position Vec3 The position in world space where the projectile hit the [Shape].
---@param airTime number The time, in seconds, that the projectile spent flying before the hit.
---@param velocity Vec3 The velocity of the projectile at impact.
---@param projectileName string The name of the projectile. (Legacy, use uuid instead)
---@param shooter Player|Unit|Shape|Harvestable|nil The shooter. Can be a [Player], [Unit], [Shape], [Harvestable] or nil if unknown.
---@param damage integer The damage value of the projectile.
---@param customData any A Lua object that can be defined at shoot time using [sm.projectile.customProjectileAttack] or an other custom version. 
---@param normal Vec3 The normal at the point of impact.
---@param uuid Uuid The uuid of the projectile.
function ShapeClass:server_onProjectile(position, airTime, velocity, projectileName, shooter, damage, customData, normal, uuid) end

---@deprecated Use [ShapeClass.server_onMelee, server_onMelee] instead.
function ShapeClass:server_onSledgehammer() end

---Called when the [Shape] is hit by a melee attack.  
---**Note:**
---*If the attacker is destroyed before the hit lands, the attacker value will be nil.*
---@param position Vec3 The position in world space where the [Shape] was hit.
---@param attacker Player|nil The attacker. Can be a [Player] or nil if unknown. Attacks made by a [Unit] will be nil on the client.
---@param damage integer The damage value of the melee hit.
---@param power number The physical impact impact of the hit.
---@param direction Vec3 The direction that the melee attack was made.
---@param normal Vec3 The normal at the point of impact.
function ShapeClass:client_onMelee(position, attacker, damage, power, direction, normal) end

---Called when the [Shape] is hit by a melee attack.  
---**Note:**
---*If the attacker is destroyed before the hit lands, the attacker value will be nil.*
---@param position Vec3 The position in world space where the [Shape] was hit.
---@param attacker Player|Unit|nil The attacker. Can be a [Player], [Unit] or nil if unknown.
---@param damage integer The damage value of the melee hit.
---@param power number The physical impact impact of the hit.
---@param direction Vec3 The direction that the melee attack was made.
---@param normal Vec3 The normal at the point of impact.
function ShapeClass:server_onMelee(position, attacker, damage, power, direction, normal) end

---Called when the [Shape] is hit by an explosion.  
---For more information about explosions, see [sm.physics.explode].  
---@param center Vec3 The center of the explosion.
---@param destructionLevel integer The level of destruction done by this explosion. Corresponds to the 'durability' rating of a [Shape].
function ShapeClass:server_onExplosion(center, destructionLevel) end

---Called when the [Shape] collides with another object.  
---@param other Shape|Character|Harvestable|Lift|nil The other object. Nil if terrain.
---@param position Vec3 The position in world space where the collision occurred.
---@param selfPointVelocity Vec3 The velocity that that the [Shape] had at the point of collision.
---@param otherPointVelocity Vec3 The velocity that that the other object had at the point of collision.
---@param normal Vec3 The collision normal between the [Shape] and the other other object.
function ShapeClass:client_onCollision(other, position, selfPointVelocity, otherPointVelocity, normal) end

---Called when the [Shape] collides with another object.  
---@param other Shape|Character|Harvestable|Lift|nil The other object. Nil if terrain.
---@param position Vec3 The position in world space where the collision occurred.
---@param selfPointVelocity Vec3 The velocity that that the [Shape] had at the point of collision.
---@param otherPointVelocity Vec3 The velocity that that the other object had at the point of collision.
---@param normal Vec3 The collision normal between the [Shape] and the other other object.
function ShapeClass:server_onCollision(other, position, selfPointVelocity, otherPointVelocity, normal) end

---Called to check whether the [Shape] can be erased at this moment.  
---**Note:**
---*Can be used to override restrictions. (See [Shape.erasable])*
---@return boolean
function ShapeClass:client_canErase() end

---Called to check whether the [Shape] can be erased at this moment.  
---**Note:**
---*Can be used to override restrictions. (See [Shape.erasable])*
---@return boolean
function ShapeClass:server_canErase() end

---Called to check whether the [Interactable] can be interacted with at this moment.  
---**Note:**
---*This callback can also be used to change the interaction text shown to the player using [sm.gui.setInteractionText]. (Defaults to "E Use")*
---**Note:**
---*Can be used to override restrictions. (See [Shape.usable])*
---@param character Character The [Character] of the [Player] that is looking at the [Shape].
---@return boolean
function ShapeClass:client_canInteract(character) end

---Called to check whether the [Interactable] can be interacted with through a child [Joint] at this moment.  
---**Note:**
---*This callback can also be used to change the interaction text shown to the player using [sm.gui.setInteractionText]. (Defaults to "E Use")*
---@param character Character The [Character] of the [Player] that is looking at the [Joint].
---@return boolean
function ShapeClass:client_canInteractThroughJoint(character) end

---Called to check whether the [Interactable] can be tinkered with at this moment.  
---**Note:**
---*Tinkering usually means opening the upgrade menu for seats.*
---@param character Character The [Character] of the [Player] that is looking at the [Shape].
---@return boolean
function ShapeClass:client_canTinker(character) end

---Called to check how many more parent (input) connections with the given type [sm.interactable.connectionType, flag] the [Interactable] will accept. Return 1 or more to allow a connection of this type.  
---```
----- Example of implementation where logic and power shares the same slot but electricity counts as separate
---MyIteractable.maxParentCount = 2
---MyIteractable.connectionInput = sm.interactable.connectionType.logic + sm.interactable.connectionType.power + sm.interactable.connectionType.electricity
---
---function MyIteractable.client_getAvailableParentConnectionCount( self, flags )
---	if bit.band( flags, bit.bor( sm.interactable.connectionType.logic, sm.interactable.connectionType.power ) ) ~= 0 then
---		return 1 - self:getParents( bit.bor( sm.interactable.connectionType.logic, sm.interactable.connectionType.power ) )
---	end
---	if bit.band( flags, sm.interactable.connectionType.electricity ) ~= 0 then
---		return 1 - self:getParents( sm.interactable.connectionType.electricity )
---	end
---	return 0
---end
---```
---**Note:**
---*[ShapeClass.maxParentCount, maxParentCount] must be 1 or more for this callback to be called.*
---@param flags integer Connection type flags.
---@return integer
function ShapeClass:client_getAvailableParentConnectionCount(flags) end

---Called to check how many more child (output) connections with the given type [sm.interactable.connectionType, flag] the [Interactable] will accept. Return 1 or more to allow a connection of this type.  
---```
----- Example of implementation that accepts 10 logic connections and 1 power connection
---MyInteractable.maxChildCount = 11
---MyInteractable.connectionOutput = sm.interactable.connectionType.logic + sm.interactable.connectionType.power
---
---function MyIteractable.client_getAvailableChildConnectionCount( self, flags )
---	if bit.band( flags, sm.interactable.connectionType.logic ) ~= 0 then
---		return 10 - self:getParents( sm.interactable.connectionType.logic )
---	end
---	if bit.band( flags, sm.interactable.connectionType.power ) ~= 0 then
---		return 1 - self:getParents( sm.interactable.connectionType.power )
---	end
---	return 0
---end
---```
---**Note:**
---*[ShapeClass.maxChildCount, maxChildCount] must be 1 or more for this callback to be called.*
---@param flags integer Connection type flags.
---@return integer
function ShapeClass:client_getAvailableChildConnectionCount(flags) end

---Called to check if the shape must be carried instead of put in the inventory.  
---**Note:**
---*Shapes with the "carryItem" attribute are always carried.*
---@return boolean
function ShapeClass:client_canCarry() end


---@class UnitClass
---A script class that is instanced for every [Unit] in the game.  
---A unit represents an AI controlling a [Character].  
---The unit script only runs on the server side.  
---Can receive events sent with [sm.event.sendToUnit].  
---@field unit Unit The [Unit] game object belonging to this class instance.
---@field storage Storage A [Storage] object that can be used to store data for the next time loading this object after being unloaded.
---@field data any Data from the "data" json element.
---@field params any Parameter sent to [sm.unit.createUnit].
local UnitClass = class()

---Enables or disables saving of this unit. (Defaults to true)  
---If enabled, the [Unit] will be recreated when loading a game. Otherwise, the [Unit] is considered a temporary object.  
---**Note:**
---*If disabled, self.storage can not be used.*
---@type boolean
UnitClass.isSaveObject = {}

---Called when the scripted object is created. This occurs when a new object is built, spawned, or loaded from the save file.  
function UnitClass:server_onCreate() end

---Called when the scripted object is created. This occurs when a new object is built, spawned, or loaded from the save file.  
function UnitClass:client_onCreate() end

---Called when the scripted object is destroyed.  
function UnitClass:server_onDestroy() end

---Called when the scripted object is destroyed.  
function UnitClass:client_onDestroy() end

---Called if the Lua script attached to the object is modified while the game is running.  
---**Note:**
---*This event requires Scrap Mechanic to be running with the '-dev' flag. This will allow scripts to automatically refresh upon changes.*
function UnitClass:server_onRefresh() end

---Called if the Lua script attached to the object is modified while the game is running.  
---**Note:**
---*This event requires Scrap Mechanic to be running with the '-dev' flag. This will allow scripts to automatically refresh upon changes.*
function UnitClass:client_onRefresh() end

---Called every game tick &ndash; 40 ticks a second. If the frame rate is lower than 40 fps, this event may be called twice.  
---During a fixed update, physics and logic between interactables are updated.  
---@param timeStep number The time period of a tick. (Is always 0.025, a 1/40th of a second.)
function UnitClass:server_onFixedUpdate(timeStep) end

---Called every game tick &ndash; 40 ticks a second. If the frame rate is lower than 40 fps, this event may be called twice.  
---During a fixed update, physics and logic between interactables are updated.  
---@param timeStep number The time period of a tick. (Is always 0.025, a 1/40th of a second.)
function UnitClass:client_onFixedUpdate(timeStep) end

---Called every frame.  
---During a frame update, graphics, animations and effects are updated.  
---**Warning:**
---*Because of how frequent this event is called, the game's frame rate is greatly affected by the amount of code executed here.*
---*For any non-graphics related code, consider using [UnitClass.client_onFixedUpdate, client_onFixedUpdate] instead.*
---*If the event is not in use, consider removing it from the script. (Event callbacks that are not implemented will not be called.)*
---@param deltaTime number Delta time since the last frame.
function UnitClass:client_onUpdate(deltaTime) end

---Called when the client receives new client data updates from the server set with [Network.setClientData].  
---Data set in this way is persistent and the latest data will automatically be sent to new clients.  
---The data will arrive after [UnitClass.client_onCreate, client_onCreate] during the same tick.  
---Channel 1 will be received before channel 2 if both are updated.  
---@param data any Any lua object set with [Network.setClientData]
---@param channel integer Client data channel, 1 or 2. (default: 1)
function UnitClass:client_onClientDataUpdate(data, channel) end

---Called when the [Unit]'s [Character] is hit by a projectile.  
---**Note:**
---*If the shooter is destroyed before the projectile hits, the shooter value will be nil.*
---@param position Vec3 The position in world space where the projectile hit the [Unit]'s [Character].
---@param airTime number The time, in seconds, that the projectile spent flying before the hit.
---@param velocity Vec3 The velocity of the projectile at impact.
---@param projectileName string The name of the projectile. (Legacy, use uuid instead)
---@param shooter Player|Unit|Shape|Harvestable|nil The shooter. Can be a [Player], [Unit], [Shape], [Harvestable] or nil if unknown.
---@param damage integer The damage value of the projectile.
---@param customData any A Lua object that can be defined at shoot time using [sm.projectile.customProjectileAttack] or an other custom version. 
---@param normal Vec3 The normal at the point of impact.
---@param uuid Uuid The uuid of the projectile.
function UnitClass:server_onProjectile(position, airTime, velocity, projectileName, shooter, damage, customData, normal, uuid) end

---Called when the [Unit]'s [Character] is hit by an explosion.  
---@param center Vec3 The center of the explosion.
---@param destructionLevel integer The level of destruction done by this explosion. Corresponds to the 'durability' rating of a [Shape].
function UnitClass:server_onExplosion(center, destructionLevel) end

---Called when the [Unit]'s [Character] is hit by a melee hit.  
---**Note:**
---*If the attacker is destroyed before the hit lands, the attacker value will be nil.*
---@param position Vec3 The position in world space where the [Unit]'s [Character] was hit.
---@param attacker Player|Unit|nil The attacker. Can be a [Player], [Unit] or nil if unknown.
---@param damage integer The damage value of the melee hit.
---@param power number The physical impact impact of the hit.
---@param direction Vec3 The direction that the melee attack was made.
---@param normal Vec3 The normal at the point of impact.
function UnitClass:server_onMelee(position, attacker, damage, power, direction, normal) end

---Called when the [Unit]'s [Character] collides with another object.  
---@param other Shape|Character|Harvestable|Lift|nil The other object. Nil if terrain.
---@param position Vec3 The position in world space where the collision occurred.
---@param selfPointVelocity Vec3 The velocity that that the [Unit]'s [Character] had at the point of collision.
---@param otherPointVelocity Vec3 The velocity that that the other object had at the point of collision.
---@param normal Vec3 The collision normal between the [Unit]'s [Character] and the other other object.
function UnitClass:server_onCollision(other, position, selfPointVelocity, otherPointVelocity, normal) end

---Called when the [Unit]'s [Character] is crushed.  
function UnitClass:server_onCollisionCrush() end

---Called occasionally for units based on how many units are active.  
---It is recommended to do heavier AI decisions here instead of in [UnitClass.server_onFixedUpdate, server_onFixedUpdate].  
---@param deltaTime number The time, in seconds, since [UnitClass.server_onUnitUpdate, server_onUnitUpdate] was last called for this [Unit].
function UnitClass:server_onUnitUpdate(deltaTime) end

---Called when the [Unit]'s [Character] color is set. Either by painting or set using [Character.setColor] or [Character.color].  
---@param color Color The new [Color] of the [Unit]'s [Character].
function UnitClass:server_onCharacterChangedColor(color) end


---@class WorldClass
---A script class that is instanced for every [World] in the game.  
---When entering a warehouse floor, the player is entering a new world.  
---Can receive events sent with [sm.event.sendToWorld].  
---@field world World The [World] game object belonging to this class instance.
---@field network Network A [Network] object that can be used to send messages between client and server.
---@field storage Storage (Server side only.) A [Storage] object that can be used to store data for the next time loading this object after being unloaded.
---@field data any Parameters from [sm.world.createWorld].
local WorldClass = class()

---Terrain generation maximum cell position in X axis. (Defaults to 0)  
---@type integer
WorldClass.cellMaxX = {}

---Terrain generation maximum cell position in Y axis. (Defaults to 0)  
---@type integer
WorldClass.cellMaxY = {}

---Terrain generation minimum cell position in X axis. (Defaults to 0)  
---@type integer
WorldClass.cellMinX = {}

---Terrain generation minimum cell position in Y axis. (Defaults to 0)  
---@type integer
WorldClass.cellMinY = {}

---Enables or disables terrain assets for this world. (Defaults to true)  
---@type boolean
WorldClass.enableAssets = {}

---Enables or disables terrain clutter for this world. (Defaults to true)  
---@type boolean
WorldClass.enableClutter = {}

---Enables or disables creations for this world. (Defaults to true)  
---@type boolean
WorldClass.enableCreations = {}

---Enables or disables terrain harvestables for this world. (Defaults to true)  
---@type boolean
WorldClass.enableHarvestables = {}

---Enables or disables terrain kinematics for this world. (Defaults to true)  
---@type boolean
WorldClass.enableKinematics = {}

---Enables or disables nodes for this world. (Defaults to true)  
---@type boolean
WorldClass.enableNodes = {}

---Enables or disables terrain surface for this world. (Defaults to true)  
---@type boolean
WorldClass.enableSurface = {}

---Sets the ground material set used by the terrain. (Defaults to "$GAME_DATA/Terrain/Materials/gnd_standard_materialset.json")  
---Full $-path to the material set.  
---@type string
WorldClass.groundMaterialSet = {}

---Enables or disables indoor mode. (Defaults to false)  
---Indoor worlds have only one terrain cell in (0, 0)  
---@type boolean
WorldClass.isIndoor = {}

---Sets the render mode for this world. (Default "outdoor")  
---Possible values: "outdoor", "challenge", "warehouse"  
---@type string
WorldClass.renderMode = {}

---Sets the script used to generate terrain.  
---Full $-path to the terrain generation script.  
---@type string
WorldClass.terrainScript = {}

---Adds borders to the world to prevent objects falling through the ground. (Defaults to true)  
---@type boolean
WorldClass.worldBorder = {}

---Called when the scripted object is created. This occurs when a new object is built, spawned, or loaded from the save file.  
function WorldClass:server_onCreate() end

---Called when the scripted object is created. This occurs when a new object is built, spawned, or loaded from the save file.  
function WorldClass:client_onCreate() end

---Called when the scripted object is destroyed.  
function WorldClass:server_onDestroy() end

---Called when the scripted object is destroyed.  
function WorldClass:client_onDestroy() end

---Called if the Lua script attached to the object is modified while the game is running.  
---**Note:**
---*This event requires Scrap Mechanic to be running with the '-dev' flag. This will allow scripts to automatically refresh upon changes.*
function WorldClass:server_onRefresh() end

---Called if the Lua script attached to the object is modified while the game is running.  
---**Note:**
---*This event requires Scrap Mechanic to be running with the '-dev' flag. This will allow scripts to automatically refresh upon changes.*
function WorldClass:client_onRefresh() end

---Called every game tick &ndash; 40 ticks a second. If the frame rate is lower than 40 fps, this event may be called twice.  
---During a fixed update, physics and logic between interactables are updated.  
---@param timeStep number The time period of a tick. (Is always 0.025, a 1/40th of a second.)
function WorldClass:server_onFixedUpdate(timeStep) end

---Called every game tick &ndash; 40 ticks a second. If the frame rate is lower than 40 fps, this event may be called twice.  
---During a fixed update, physics and logic between interactables are updated.  
---@param timeStep number The time period of a tick. (Is always 0.025, a 1/40th of a second.)
function WorldClass:client_onFixedUpdate(timeStep) end

---Called every frame.  
---During a frame update, graphics, animations and effects are updated.  
---**Warning:**
---*Because of how frequent this event is called, the game's frame rate is greatly affected by the amount of code executed here.*
---*For any non-graphics related code, consider using [WorldClass.client_onFixedUpdate, client_onFixedUpdate] instead.*
---*If the event is not in use, consider removing it from the script. (Event callbacks that are not implemented will not be called.)*
---@param deltaTime number Delta time since the last frame.
function WorldClass:client_onUpdate(deltaTime) end

---Called when the client receives new client data updates from the server set with [Network.setClientData].  
---Data set in this way is persistent and the latest data will automatically be sent to new clients.  
---The data will arrive after [WorldClass.client_onCreate, client_onCreate] during the same tick.  
---Channel 1 will be received before channel 2 if both are updated.  
---@param data any Any lua object set with [Network.setClientData]
---@param channel integer Client data channel, 1 or 2. (default: 1)
function WorldClass:client_onClientDataUpdate(data, channel) end

---Called when a world cell is loaded and feature complete for the first time.  
---**Note:**
---*[Interactable, Interactables] created by terrain scripts should be processed here using [sm.cell.getInteractablesByTag] and [sm.cell.getInteractablesByUuid].*
---*They are only accessable for 1 tick after being created.*
---@param x integer Cell x position.
---@param y integer Cell y position.
function WorldClass:server_onCellCreated(x, y) end

---Called when a world cell is loaded and feature complete, but has been before.  
---@param x integer Cell x position.
---@param y integer Cell y position.
function WorldClass:server_onCellLoaded(x, y) end

---Called when a world cell is no longer feature complete.  
---@param x integer Cell x position.
---@param y integer Cell y position.
function WorldClass:server_onCellUnloaded(x, y) end

---Called when a world cell is considered feature complete for a client (has nodes).  
---@param x integer Cell x position.
---@param y integer Cell y position.
function WorldClass:client_onCellLoaded(x, y) end

---Called when a world cell is no longer considered feature complete for a client (no longer has nodes).  
---@param x integer Cell x position.
---@param y integer Cell y position.
function WorldClass:client_onCellUnloaded(x, y) end

---Called when an [Interactable] [Shape] is built in the world.  
---@param interactable Interactable The [Interactable] of the built [Shape].
function WorldClass:server_onInteractableCreated(interactable) end

---Called when an [Interactable] [Shape] is removed from the world.  
---@param interactable Interactable The [Interactable] of the removed [Shape].
function WorldClass:server_onInteractableDestroyed(interactable) end

---Called when a projectile hits something in this world.  
---**Note:**
---*If the shooter is destroyed before the projectile hits, the shooter value will be nil.*
---@param position Vec3 The position in world space where the projectile hit.
---@param airTime number The time, in seconds, that the projectile spent flying before the hit.
---@param velocity Vec3 The velocity of the projectile at impact.
---@param projectileName string The name of the projectile. (Legacy, use uuid instead)
---@param shooter Player|Unit|Shape|Harvestable|nil The shooter. Can be a [Player], [Unit], [Shape], [Harvestable] or nil if unknown.
---@param damage integer The damage value of the projectile.
---@param customData any A Lua object that can be defined at shoot time using [sm.projectile.customProjectileAttack] or an other custom version. 
---@param normal Vec3 The normal at the point of impact.
---@param target Character|Shape|Harvestable|Lift|nil The hit target. Can be a [Character], [Shape], [Harvestable], [Lift] or nil if terrain or unknown.
---@param uuid Uuid The uuid of the projectile.
function WorldClass:server_onProjectile(position, airTime, velocity, projectileName, shooter, damage, customData, normal, target, uuid) end

---Called when an explosion occurs in this world.  
---@param center Vec3 The center of the explosion.
---@param destructionLevel integer The level of destruction done by this explosion. Corresponds to the 'durability' rating of a [Shape].
function WorldClass:server_onExplosion(center, destructionLevel) end

---Called when a melee attack hits something in this world.  
---**Note:**
---*If the attacker is destroyed before the hit lands, the attacker value will be nil.*
---@param position Vec3 The position in world space where the attack hit.
---@param attacker Player|Unit|nil The attacker. Can be a [Player], [Unit] or nil if unknown.
---@param target Character|Shape|Harvestable|Lift|nil The hit target. Can be a [Character], [Shape], [Harvestable], [Lift] or nil if terrain or unknown.
---@param damage integer The damage value of the melee hit.
---@param power number The physical impact impact of the hit.
---@param direction Vec3 The direction that the melee attack was made.
---@param normal Vec3 The normal at the point of impact.
function WorldClass:server_onMelee(position, attacker, target, damage, power, direction, normal) end

---Called when a projectile is fired in this world.  
---@param position Vec3 The position in world space where projectile was fired from.
---@param velocity Vec3 The fire velocity of the projectile.
---@param projectileName string The name of the projectile. (Legacy, use uuid instead)
---@param shooter Player|Unit|Shape|Harvestable|nil The shooter. Can be a [Player], [Unit], [Shape], [Harvestable] or nil if unknown.
---@param uuid Uuid The uuid of the projectile.
function WorldClass:server_onProjectileFire(position, velocity, projectileName, shooter, uuid) end

---Called when a collision occurs in this world.  
---@param objectA Shape|Character|Harvestable|Lift|nil The first colliding object. Nil if terrain.
---@param objectB Shape|Character|Harvestable|Lift|nil The other colliding object. Nil if terrain.
---@param position Vec3 The position in world space where the collision occurred.
---@param pointVelocityA Vec3 The velocity that that the first object had at the point of collision.
---@param pointVelocityB Vec3 The velocity that that the other object had at the point of collision.
---@param normal Vec3 The collision normal from objectA to objectB.
function WorldClass:server_onCollision(objectA, objectB, position, pointVelocityA, pointVelocityB, normal) end

---Called when a collision occurs in this world.  
---@param objectA Shape|Character|Harvestable|Lift|nil One of the colliding objects. Nil if terrain.
---@param objectB Shape|Character|Harvestable|Lift|nil The other colliding object. Nil if terrain.
---@param position Vec3 The position in world space where the collision occurred.
---@param pointVelocityA Vec3 The velocity that that the first object had at the point of collision.
---@param pointVelocityB Vec3 The velocity that that the other object had at the point of collision.
---@param normal Vec3 The collision normal from objectA to objectB.
function WorldClass:client_onCollision(objectA, objectB, position, pointVelocityA, pointVelocityB, normal) end


---@class ToolClass
---A script class that is instanced for every active [Tool] in the game.  
---A tool something that a [Player] can equip by selecting it in the hotbar. For instance the Sledgehammer.  
---@field data any Data from the "data" json element.
---@field tool Tool The [Tool] game object belonging to this class instance.
---@field network Network A [Network] object that can be used to send messages between client and server.
---@field storage Storage (Server side only.) A [Storage] object that can be used to store data for the next time loading this object after being unloaded.
local ToolClass = class()

---Called when the scripted object is created. This occurs when a new object is built, spawned, or loaded from the save file.  
function ToolClass:server_onCreate() end

---Called when the scripted object is created. This occurs when a new object is built, spawned, or loaded from the save file.  
function ToolClass:client_onCreate() end

---Called when the scripted object is destroyed.  
function ToolClass:server_onDestroy() end

---Called when the scripted object is destroyed.  
function ToolClass:client_onDestroy() end

---Called if the Lua script attached to the object is modified while the game is running.  
---**Note:**
---*This event requires Scrap Mechanic to be running with the '-dev' flag. This will allow scripts to automatically refresh upon changes.*
function ToolClass:server_onRefresh() end

---Called if the Lua script attached to the object is modified while the game is running.  
---**Note:**
---*This event requires Scrap Mechanic to be running with the '-dev' flag. This will allow scripts to automatically refresh upon changes.*
function ToolClass:client_onRefresh() end

---Called every game tick &ndash; 40 ticks a second. If the frame rate is lower than 40 fps, this event may be called twice.  
---During a fixed update, physics and logic between interactables are updated.  
---@param timeStep number The time period of a tick. (Is always 0.025, a 1/40th of a second.)
function ToolClass:server_onFixedUpdate(timeStep) end

---Called every game tick &ndash; 40 ticks a second. If the frame rate is lower than 40 fps, this event may be called twice.  
---During a fixed update, physics and logic between interactables are updated.  
---@param timeStep number The time period of a tick. (Is always 0.025, a 1/40th of a second.)
function ToolClass:client_onFixedUpdate(timeStep) end

---Called every frame.  
---During a frame update, graphics, animations and effects are updated.  
---**Warning:**
---*Because of how frequent this event is called, the game's frame rate is greatly affected by the amount of code executed here.*
---*For any non-graphics related code, consider using [ToolClass.client_onFixedUpdate, client_onFixedUpdate] instead.*
---*If the event is not in use, consider removing it from the script. (Event callbacks that are not implemented will not be called.)*
---@param deltaTime number Delta time since the last frame.
function ToolClass:client_onUpdate(deltaTime) end

---Called when the client receives new client data updates from the server set with [Network.setClientData].  
---Data set in this way is persistent and the latest data will automatically be sent to new clients.  
---The data will arrive after [ToolClass.client_onCreate, client_onCreate] during the same tick.  
---Channel 1 will be received before channel 2 if both are updated.  
---@param data any Any lua object set with [Network.setClientData]
---@param channel integer Client data channel, 1 or 2. (default: 1)
function ToolClass:client_onClientDataUpdate(data, channel) end

---Called when a [Player] equips the [Tool].  
---@param animate boolean A boolean indicating whether the event should be animated or not.
function ToolClass:client_onEquip(animate) end

---Called when a [Player] unequips the [Tool].  
---@param animate boolean A boolean indicating whether the event should be animated or not.
function ToolClass:client_onUnequip(animate) end

---Called every frame for the currently equipped [Tool].  
---**Note:**
---*Swinging the sledgehammer is a typical example where you want to block other primary input.*
---*Force building is an example where the primary input action is not blocked.*
---*Not blocking secondary input allows shape removal while the tool is equipped.*
---@param primaryState integer The interact state of the primary (left) mouse button. (See [sm.tool.interactState])
---@param secondaryState integer The interact state of the secondary (right) mouse button. (See [sm.tool.interactState])
---@return boolean, boolean
function ToolClass:client_onEquippedUpdate(primaryState, secondaryState) end

---Called when the [Player] presses a toggle key with the [Tool] equipped (default 'Q' and 'Shift' + 'Q).  
---@return boolean
function ToolClass:client_onToggle() end

---Called when the [Player] presses the 'Reload' key with the [Tool] equipped (default 'R').  
---@return boolean
function ToolClass:client_onReload() end

---This event is called to check whether the [Tool] can be equipped.  
---@return boolean
function ToolClass:client_canEquip() end
