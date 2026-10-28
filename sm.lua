---@meta
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
---| "Uuid"



---@class Vec3
---@operator add(Vec3): Vec3
---@operator add(number): Vec3
---@operator div(Vec3): Vec3
---@operator div(number): Vec3
---@operator eq(Vec3): boolean
---@operator lt(Vec3): boolean
---@operator mul(Vec3): Vec3
---@operator mul(number): Vec3
---@operator sub(Vec3): Vec3
---@operator sub(number): Vec3
---@operator unm(): Vec3 
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

---Returns a vector of only positive values by taking the absolute value of each component in the input vector.  
---@return Vec3 # The absolute value vector.
function Vec3:abs() end

---Ceil each component of the vector  
---@return Vec3 # The ceiled vector.
function Vec3:ceil() end

---Returns the <a target="_blank" href="https://en.wikipedia.org/wiki/Cross_product">cross product</a> of two vectors.  
---@param v2 Vec3 # The second vector.
---@return Vec3 # The cross product.
function Vec3:cross(v2) end

---Returns the <a target="_blank" href="https://en.wikipedia.org/wiki/Dot_product">dot product</a> of a vector.  
---@param v2 Vec3 # The second vector.
---@return number # The dot product.
function Vec3:dot(v2) end

---Floor each component of the vector  
---@return Vec3 # The floored vector.
function Vec3:floor() end

---Returns the length of the vector.  
---If you want the squared length, using [Vec3.length2, length2] is faster than squaring the result of this function.  
---@return number # The length of the vector.
function Vec3:length() end

---Returns the squared length of the vector.  
---@return number # The squared length of the vector.
function Vec3:length2() end

---Returns the maximum value between two vectors components.  
---@param v2 Vec3 # The second vector.
---@return Vec3 # Component wise maximum value vector.
function Vec3:max(v2) end

---Returns the minimum value between two vectors components.  
---@param v2 Vec3 # The second vector.
---@return Vec3 # Component wise minimum value vector.
function Vec3:min(v2) end

---Normalizes a vector, ie. converts to a unit vector of length 1.  
---@return Vec3 # The normalized vector.
function Vec3:normalize() end

---Rotate a vector around an axis.  
---@param angle number # The angle.
---@param normal Vec3 # The axis to be rotated around.
---@return Vec3 # The rotated vector.
function Vec3:rotate(angle, normal) end

---Rotate a vector around the X axis.  
---@param angle number # The angle.
---@return Vec3 # The rotated vector.
function Vec3:rotateX(angle) end

---Rotate a vector around the Y axis.  
---@param angle number # The angle.
---@return Vec3 # The rotated vector.
function Vec3:rotateY(angle) end

---Rotate a vector around the Z axis.  
---@param angle number # The angle.
---@return Vec3 # The rotated vector.
function Vec3:rotateZ(angle) end

---Normalizes a vector with safety, ie. converts to a unit vector of length 1.  
---@param fallback Vec3 # The fallback vector
---@return Vec3 # The normalized vector.
function Vec3:safeNormalize(fallback) end


---@class Quat
---A userdata object representing a <strong>quaternion</strong>.  
---@operator eq(Quat): boolean
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

---Returns the quaternions at vector.  
---@return Vec3 # The at vector.	
function Quat:getAt() end

---Returns the quaternions right vector.  
---@return Vec3 # The right vector.
function Quat:getRight() end

---Returns the quaternions up vector.  
---@return Vec3 # The up vector.
function Quat:getUp() end

---Inverts the quaternion.  
---@return Quat # The inverted quaternion.
function Quat:inverse() end

---Normalizes a quaternion, ie. converts to a unit quaternion of length 1.  
---@return Quat # The normalized quaternion.
function Quat:normalize() end

---Rounds the quaternion rotation into 90 degree steps  
---@return Quat # The rounded quaternion.
function Quat:round90() end

---Normalizes a quaternion with safety, ie. converts to a unit quaternion of length 1.  
---@param fallback Quat # The fallback quaternion
---@return Quat # The normalized quaternion.
function Quat:safeNormalize(fallback) end

---@class Uuid
---A userdata object representing a <strong>uuid</strong>.  
---@operator eq(Uuid): boolean 
local Uuid = {}

---Checks if the uuid is nil {00000000-0000-0000-0000-000000000000}  
---@return boolean # True if the uuid is nil.
function Uuid:isNil() end


---@class Color
---@operator add(Color): Color
---@operator div(Color): Color
---@operator div(number): Color
---@operator eq(Color): boolean
---@operator mul(Color): Color
---@operator mul(number): Color
---@operator sub(Color): Color
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

---Get the json gui color representation of the color.  
---@return string # Json gui color string.
function Color:getGuiColorStr() end

---Get the hex representation of the color.  
---@return string # Hex string.
function Color:getHexStr() end

---Get the uint rgba representation of the color.  
---@return integer # color value.
function Color:getUintRgba() end



---@alias RaycastResultTypes
---| "limiter"
---| "terrainSurface"
---| "terrainAsset"
---| "body"
---| "joint"
---| "lift"
---| "character"
---| "joint"
---| "harvestable"
---| "ragdoll"
---| "areaTrigger"
---| "vision"
---| "voxelTerrain"
---| "tunnelCatcher"

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
---@type RaycastResultTypes
RaycastResult.type = {}

---**Get**:
---Returns whether the raycast successfully hit a target.  
---@type boolean
RaycastResult.valid = {}

---Returns the [AreaTrigger] hit during the raycast. This is only possible if [RaycastResult.type] is equal to "areaTrigger", otherwise this will return nil.  
---@return AreaTrigger # The areaTrigger target
function RaycastResult:getAreaTrigger() end

---Returns the [Body] hit during the raycast. This is only possible if [RaycastResult.type] is equal to "body", otherwise this will return nil.  
---@return Body # The body target.
function RaycastResult:getBody() end

---Returns the [Character] hit during the raycast. This is only possible if [RaycastResult.type] is equal to "character", otherwise this will return nil.  
---@return Character # The character target.
function RaycastResult:getCharacter() end

---Returns the [Harvestable] hit during the raycast. This is only possible if [RaycastResult.type] is equal to "harvestable", otherwise this will return nil.  
---@return Harvestable # The harvestable target.
function RaycastResult:getHarvestable() end

---Returns the [Joint] hit during the raycast. This is only possible if [RaycastResult.type] is equal to "joint", otherwise this will return nil.  
---@return Joint # The joint target
function RaycastResult:getJoint() end

---Returns the [Lift] hit during the raycast. This is only possible if [RaycastResult.type] is equal to "lift", otherwise this will return nil.  
---@return Lift, boolean isTop; The lift; True if the lift is top
function RaycastResult:getLiftData() end

---Returns the [Shape] hit during the raycast. This is only possible if [RaycastResult.type] is equal to "body", otherwise this will return nil.  
---@return Shape # The shape target.
function RaycastResult:getShape() end

---Returns the material hit during the raycast. This is only possible if [RaycastResult.type] is equal to "terrainAsset", otherwise this will return empty.  
---@return string # The material name.
function RaycastResult:getTerrainAssetMaterialName() end 


---@class LoadCellHandle
---A userdata object representing a <strong>load cell handle</strong>.  
---@operator eq(LoadCellHandle): boolean
local LoadCellHandle = {}

---*Server only*  
---@return boolean # True if succesful
function LoadCellHandle:release() end


---@class Shape
---@operator eq(Shape): boolean
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
---Return true if a shape is a basicmaterial
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
---Returns the local grid position of a shape.  
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

---*Client only*  
---Applies a shake impulse to the shape  
---@param shake number # The shake impulse value.
function Shape:applyShakeImpulse(shake) end

---*Server only*  
---Create a new joint  
---@param uuid Uuid The uuid of the joint.
---@param position Vec3 The joint's grid position.
---@param direction Vec3 The joint's normal direction.
---@return Joint joint The created joint.
function Shape:createJoint(uuid, position, direction) end

---*Server only*  
---Destroy a block.  
---@param position Vec3 # The local position of the removal box corner.
---@param size? Vec3 # The size of the removal box. Defaults to 1x1x1 (Optional)
---@param attackLevel? integer # Determines which quality level of block the attack can destroy. Setting it to 0 (default) will destroy any block.
---@param destructionType? integer # The type of destruction (Optional). (See[sm.shape.destructionType). (Defaults to sm.shape.destructionType.none)
---@param destructionPosition? Vec3 # The position of the destruction would hit the block (Optional)
---@param destructionNormal? Vec3 # The normal direction of where the destruction would hit the block (Optional)
function Shape:destroyBlock(position, size, attackLevel, destructionType, destructionPosition, destructionNormal) end

---*Server only*  
---@deprecated use [Shape.destroyShape]
---Destroy a part  
---@param attackLevel? integer # Determines which quality level of parts the attack can destroy. Setting it to 0 (default) will destroy any part.
---@param destructionType? integer # The type of destruction (Optional). (See[sm.shape.destructionType). (Defaults to sm.shape.destructionType.none)
---@param destructionPosition? Vec3 # The position of the destruction would hit the part (Optional)
---@param destructionNormal? Vec3 # The normal direction of where the destruction would hit the part (Optional)
function Shape:destroyPart(attackLevel, destructionType, destructionPosition, destructionNormal) end

---*Server only*  
---Destroy a shape  
---@param attackLevel? integer # Determines which quality level of shape the attack can destroy. Setting it to 0 (default) will destroy any shape.
---@param destructionType? integer # The type of destruction (Optional). (See[sm.shape.destructionType). (Defaults to sm.shape.destructionType.none)
---@param destructionPosition? Vec3 # The position of the destruction would hit the shape (Optional)
---@param destructionNormal? Vec3 # The normal direction of where the destruction would hit the shape (Optional)
function Shape:destroyShape(attackLevel, destructionType, destructionPosition, destructionNormal) end

---Returns the direction of a shape's front side.  
---The direction is affected by the shape's rotation in the world.  
---@return Vec3 # The shape's at-axis.
function Shape:getAt() end

---Returns the [Body] a shape is part of.  
---@return Body # The body which the shape is part of.
function Shape:getBody() end

---Returns the bounding box of a shape &ndash; the dimensions that a shape occupies when building.  
---@return Vec3 # The size of the shape's bounding box.
function Shape:getBoundingBox() end

---Returns the buoyancy multiplier of a shape.  
---@return number # The buoyancy multiplier.
function Shape:getBuoyancy() end

---Check if a shape is burning.  
---@return boolean # Return true if the shape is burning.
function Shape:getBurning() end

---Transform a world position to the closest block's local position in a shape.  
---@param position Vec3 # The world position.
---@return Vec3 # The closest position.
function Shape:getClosestBlockLocalPosition(position) end

---Returns the color of a shape.  
---@return Color # The shape's color.
function Shape:getColor() end

---Check if a shape is compromised.  
---@return boolean # Return true if the shape is compromised.
function Shape:getCompromised() end

---Returns the id of a shape.  
---@return integer # The shape's id.
function Shape:getId() end

---Returns the [Interactable] of a shape, if one exists. Otherwise the function will return nil.  
---@return Interactable # The interactable belonging to the shape.
function Shape:getInteractable() end

---Returns the interpolated direction of a shape's front side.  
---The direction is affected by the shape's rotation in the world.  
---@return Vec3 # The shape's interpolated at-axis.
function Shape:getInterpolatedAt() end

---Returns the interpolated direction of a shape's right side.  
---The direction is affected by the shape's rotation in the world.  
---@return Vec3 # The shape's interpolated right-axis.
function Shape:getInterpolatedRight() end

---Returns the interpolated direction of a shape's top side.  
---The direction is affected by the shape's rotation in the world.  
---@return Vec3 # The shape's interpolated up-axis.
function Shape:getInterpolatedUp() end

---Returns the interpolated world position of a shape.  
---@return Vec3 # The shape's interpolated world position.
function Shape:getInterpolatedWorldPosition() end

---Return whether the shape belongs to a harvest shape  
---@return boolean # True if the shape is harvestable.
function Shape:getIsHarvest() end

---Return whether the shape belongs to a stackable shape  
---@return boolean # True if the shape is stackable.
function Shape:getIsStackable() end

---Returns a table of all [Joint, joints] that are attached to the shape.  
---Will return all attached joints when onlyChildJoints is set to false.  
---@param onlyChildJoints? boolean # Filters what joints to return. Defaults to true (Optional)
---@return Joints[] # The table of joints attached to the shape. {[Joint], ..}
function Shape:getJoints(onlyChildJoints) end

---Get the local aabb of the shape.  
---@return Vec3,Vec3 # Returns the aabb min and max.
function Shape:getLocalAabb() end

---Returns the local grid position of a shape.  
---@return Vec3 # The shape's local position.
function Shape:getLocalPosition() end

---Returns the local rotation of a shape.  
---@return Quat # The shape's local rotation.
function Shape:getLocalRotation() end

---Returns the mass of a shape.  
---@return number # The shape's mass.
function Shape:getMass() end

---Returns the material of a shape.  
---@return string # The shape's material.
function Shape:getMaterial() end

---Returns the material id of a shape.  
---@return integer # The shape's material id.
function Shape:getMaterialId() end

---@return Joint[] # A table of joints contained in the multishape (returns nil if shape wasn't a multishape)
function Shape:getMultiShapeJoints() end

---@return Shape[] # A table of shapes contained in the multishape (returns nil if shape wasn't a multishape)
function Shape:getMultiShapeShapes() end

---*Server only*  
---Returns a table of shapes which are neighbours to the shape  
---@return Shape[] # table of shapes. {[Shape], ..}
function Shape:getNeighbours() end

---Returns a table offsets for the pipe connections of the shape. Can specify direction using sm.pipeGraph.direction.  
---@param direction? integer # The direction to fetch in. Defaults to [sm.pipeGraph.direction, sm.pipeGraph.direction.any] (Optional)
---@return Vec3[] # table of local offset positions. {[Vec3], ..}
function Shape:getPipeOffsets(direction) end

---*Server only*  
---Returns a table of shapes which are neighbours connected with pipes to the shape  
---@return Shape[] # table of shapes. {[Shape], ..}
function Shape:getPipedNeighbours() end

---Returns the direction of a shape's right side.  
---The direction is affected by the shape's rotation in the world.  
---@return Vec3 # The shape's right-axis.
function Shape:getRight() end

---Returns the shapes output container index listed in the shapeset for pipe graph affecting shapes.  
function Shape:getShapeOutputContainerIndex() end

---Returns the uuid unique to a shape/block type.  
---@return Uuid # The shape's uuid.
function Shape:getShapeUuid() end

---Returns the sticky directions of the shape for positive xyz and negative xyz.  
---A value of 1 means that the direction is sticky and a value of 0 means that the direction is not sticky.  
---@return Vec3[] # The negative xyz sticky and the positive xyz sticky.
function Shape:getSticky() end

---Returns the direction of a shape's top side.  
---The direction is affected by the shape's rotation in the world.  
---@return Vec3 # The shape's up-axis.
function Shape:getUp() end

---Returns the linear velocity of a shape.  
---@return Vec3 # The shape's linear velocity.
function Shape:getVelocity() end

---Returns the world position of a shape.  
---@return Vec3 # The shape's world position.
function Shape:getWorldPosition() end

---Returns the world rotation of a shape.  
---@return Quat # The shape's world rotation.
function Shape:getWorldRotation() end

---Returns the local x-axis vector of a shape.  
---@return Vec3 # The shape's x-axis.
function Shape:getXAxis() end

---Returns the local y-axis vector of a shape.  
---@return Vec3 # The shape's y-axis.
function Shape:getYAxis() end

---Returns the local z-axis vector of a shape.  
---@return Vec3 # The shape's z-axis.
function Shape:getZAxis() end

---Returns whether the shape is a pipe or not.  
---@return boolean # Whether the shape was a pipe or not.
function Shape:isPipe() end

---*Server only*  
---Restores the color of a shape to its base color. This is similar to coloring with the <em>Paint Tool</em>  
function Shape:removeColor() end

---*Server only*  
---Creates a new [Shape] from [Uuid] to replace the given [Shape].  
---@param uuid Uuid # The uuid of the new shape.
function Shape:replaceShape(uuid) end

---*Server only*  
---Set the state that determines if a shape is burning.  
---True to set burning and false to set not burning.  
---@param state boolean # The state.
function Shape:setBurning(state) end

---Sets if the shape should generate sound on collisions.  
---@param enabled boolean # Whether the sound should be enabled or not.
function Shape:setCollisionSoundEnabled(enabled) end

---*Server only*  
---Sets the color of a shape. This is similar to coloring with the <em>Paint Tool</em>.  
---@param color Color # The color.
function Shape:setColor(color) end

---*Server only*  
---Set the state that determines if a shape is compromised.  
---True to set compromised and false to set not compromised.  
---@param state boolean # The state.
function Shape:setCompromised(state) end

---Sets the physics material of the shape.  
---@param material integer # The new physics material for the shape.
function Shape:setPhysicsMaterial(material) end

---@deprecated use [sm.exists]
---Return true if a shape exists.  
---@return boolean # Whether the shape exists.
function Shape:shapeExists() end

---Transform a world direction to the local shape transform.  
---@param vector Vec3 # The untransformed direction.
---@return Vec3 # The transformed direction.
function Shape:transformDirection(vector) end

---Transform a local direction to world space.  
---@param vector Vec3 # The local direction.
---@return Vec3 # The world direction.
function Shape:transformLocalDirection(vector) end

---Transform a local point to world space.  
---```
---local worldPos = self.shape:transformLocalPoint( localPos )
---```
---@param vector Vec3 # The local point.
---@return Vec3 # The world point.
function Shape:transformLocalPoint(vector) end

---Transform a world point to the local shape transform.  
---```
---local localPos = self.shape:transformPoint( worldPos )
---```
---@param vector Vec3 # The world point.
---@return Vec3 # The local point.
function Shape:transformPoint(vector) end

---Transform a world rotation to the local shape transform.  
---```
---local worldUp = sm.vec3.new( 0, 0, 1 )
---local worldRot = sm.vec3.getRotation( worldUp, worldDir )
---local localRot = self.shape:transformRotation( worldRot )
---```
---@param quat Quat # The untransformed quaternion.
---@return Quat # The transformed quaternion.
function Shape:transformRotation(quat) end


---@class Body
---A userdata object representing a <strong>body</strong> in the game.  
---@operator eq(Body): boolean
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
---@param uuid Uuid # The uuid of the shape.
---@param size Vec3 # The shape's size.
---@param position Vec3 # The shape's local position.
---@param forceAccept? boolean # Set true to force the body to accept the shape. (Defaults to true)
---@return Shape # The created block
function Body:createBlock(uuid, size, position, forceAccept) end

---*Server only*  
---Create a part on body  
---@param uuid Uuid # The uuid of the shape.
---@param position Vec3 # The shape's local position.
---@param z_axis Vec3 # The shape's local z direction.
---@param x_axis Vec3 # The shape's local x direction.
---@param forceAccept? boolean # Set true to force the body to accept the shape. (Defaults to true)
---@return Shape # The created part
function Body:createPart(uuid, position, z_axis, x_axis, forceAccept) end

---*Server only*  
---Creates a wedge attached to a body. The wedge is oriented with one   
---cathetus along the Y-axis and the other along the Z-axis, forming a right angle. The wedge's   
---rotation is controlled by z-axis and x-axis parameters, similar to standard part rotation.  
---@param uuid Uuid # The uuid of the shape.
---@param size Vec3 # The shape's size.
---@param position Vec3 # The shape's local position.
---@param z_axis Vec3 # The shape's local z direction.
---@param x_axis Vec3 # The shape's local x direction.
---@param forceAccept? boolean # Set true to force the body to accept the shape. (Defaults to true)
function Body:createWedge(uuid, size, position, z_axis, x_axis, forceAccept) end

---*Server only*  
---Destroys the entire creation connected to this body  
function Body:destroyCreation() end

---*Server only*  
---Returns a table with all characters seated in this body  
---@return Character[] # The table of all seated characters. {[Character], ...}
function Body:getAllSeatedCharacter() end

---Returns the angular velocity of a body.  
---@return Vec3 # The body's angular velocity.
function Body:getAngularVelocity() end

---Returns the center of mass world position of a body.  
---@return Vec3 # The body's center of mass world position.
function Body:getCenterOfMassPosition() end

---Returns a table of all bodies in a creation.  
---A creation includes all bodies connected by [Joint, joints], etc.  
---@return Body[] # An array table of all bodies in a creation. {[Body], ...}
function Body:getCreationBodies() end

---*Server only*  
---Returns the id of the creation  
---@return integer # The creation's local id
function Body:getCreationId() end

---Returns a table of all [Joint, joints] that are part of a creation.  
---A creation includes all bodies connected by [Joint, joints], etc.  
---@return Joint[] # The table of joints in a creation. {[Joint], ...}
function Body:getCreationJoints() end

---Returns a table of all [Shape, shapes] that are part of a creation.  
---A creation includes all bodies connected by [Joint, joints], etc.  
---@return Shape[] # The table of shapes in a creation. {[Shape], ...}
function Body:getCreationShapes() end

---Returns the id of a body.  
---@return integer # The body's id.
function Body:getId() end

---Returns a table of all [Interactable, interactables] that are part of a body.  
---This will <strong>not</strong> return interactables in neighbouring bodies connected by [Joint, joints], etc.  
---@return Interactable[] # The table of interactables in a body. {[Interactable], ...}
function Body:getInteractables() end

---Returns a table of all [Joint, joints] that are part of a body.  
---This will <strong>not</strong> return joints in neighbouring bodies.  
---@return Joint[] # The table of joints in a body. {[Joint], ...}
function Body:getJoints() end

---Get the local aabb of the body.  
---@return Vec3,Vec3 # Returns the aabb min and max.
function Body:getLocalAabb() end

---Returns the mass of a body.  
---@return number# The body's mass.
function Body:getMass() end

---Returns a shape that is part of a body by index.  
---@param index integer # The index of the shape.
---@return Shape # The shape at the specified index, or nil if the index is out of range.
function Body:getShape(index) end

---Returns the number of shapes in a body.  
---@return integer # The number of shapes in the body.
function Body:getShapeCount() end

---Returns a table of all [Shape, shapes] that are part of a body.  
---This will <strong>not</strong> return shapes in neighbouring bodies connected by [Joint, joints], etc.  
---@return Shape[] # The table of shapes in a body. {[Shape], ...}
function Body:getShapes() end

---Returns a table of all [Shape, shapes] that are part of a body and have a specified uuid.  
---This will <strong>not</strong> return shapes in neighbouring bodies connected by [Joint, joints], etc.  
---@param uuid Uuid # The uuid to look for.
---@return Shape[] # The table of shapes in a body. {[Shape], ...}
function Body:getShapesByUuid(uuid) end

---Returns the linear velocity of a body.  
---@return Vec3 # The body's linear velocity.
function Body:getVelocity() end

---Returns the world a body exists in.  
---@return World # The world the body exists in.
function Body:getWorld() end

---Get the world aabb of the body.  
---@return Vec3,Vec3 # Returns the aabb min and max.
function Body:getWorldAabb() end

---Returns the world position of a body.  
---@return Vec3 # The body's world position.
function Body:getWorldPosition() end

---Returns true if the given tick is lower than the tick the body was last changed.  
---@param tick integer The tick.
---@return boolean # Returns true if the body has been changed.
function Body:hasChanged(tick) end

---Check if a body is buildable  
---@return boolean  # Return true if the body is buildable.
function Body:isBuildable() end

---Check if a body is connectable  
---@return boolean # Return true if the body is connectable.
function Body:isConnectable() end

---Check if a body is convertible to dynamic form  
---@return boolean # Return true if the body can be converted to dynamic.
function Body:isConvertibleToDynamic() end

---Check if a body is destructable.  
---@return boolean # Return true if the body is destructable.
function Body:isDestructable() end

---Check if a body is dynamic  
---@return boolean # Return true if the body is dynamic.
function Body:isDynamic() end

---Check if a body is erasable.  
---@return boolean # Return true if the body is erasable.
function Body:isErasable() end

---Check if the body is a ghost body.  
---@return boolean # Returns true if the body is a ghost body.
function Body:isGhost() end

---Check if a body is liftable  
---@return boolean
function Body:isLiftable() end

---Check if a body is on a lift  
---@return boolean
function Body:isOnLift() end

---Check if a body is on a virtual lift  
---@return boolean
function Body:isOnVirtualLift() end

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
---@param value boolean # Whether the body is convertible to dynamic form.
function Body:setConvertibleToDynamic(value) end

---*Server only*  
---Controls whether a body is destructable  
---@param value boolean # Whether the body is destructable.
function Body:setDestructable(value) end

---*Server only*  
---Controls whether a body is erasable  
---@param value boolean # Whether the body is erasable.
function Body:setErasable(value) end

---*Server only*  
---Controls whether a body is liftable  
---@param value boolean # Whether the body is liftable.
function Body:setLiftable(value) end

---*Server only*  
---Controls whether a body is non paintable  
---@param value boolean # Whether the body is paintable.
function Body:setPaintable(value) end

---*Server only*  
---Controls whether a body is interactable  
---@param value boolean # Whether the body is interactable.
function Body:setUsable(value) end

---Transforms a point from local space to world space.  
---@param point Vec3 # The point in local space.
---@return Vec3 # The point in world space.
function Body:transformLocalPoint(point) end

---Transforms a point from world space to local space.  
---@param point Vec3 # The point in world space.
---@return Vec3 # The point in local space.
function Body:transformWorldPoint(point) end

---Transforms a point from world space to local space.  
---@param point Vec3 # The point in world space.
---@return Vec3 # The point in local space.
function Body:transformPoint(point) end


---@class Interactable
---Represents an interactable object in the game  
---@operator eq(Interactable): boolean
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
---*Client only*  
---Returns (client) public data from a interactable.  
---**Set**:
---*Client only*  
---Sets (client) public data on a interactable.  
---@type table
Interactable.clientPublicData = {}

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
---@type InteractableType
Interactable.type = {}

---*Server only*  
---Creates and stores a container in the given index inside the controller  
---@param index integer The index of the container [0-15].
---@param size integer The number of slots in the container.
---@param stackSize? integer The stack size. Defaults to maximum possible stack size(65535).
---@return Container # The created container.
function Interactable:addContainer(index, size, stackSize) end

---*Server only*  
---Binds a callback to be called if the interactable is destroyed through a source of damage.  
---@param callback string # The name of the lua function to bind.
function Interactable:bindDamageDestruction(callback) end

---*Server only*  
---Clear the override color of a light controller.  
function Interactable:clearLightOverrideColor() end

---*Server only*  
---Connects two interactables. Similar to using the Connect Tool.  
---@param child Interactable The receiver of a connection.
---@return boolean # Returns true if the connection attempt was successful.
function Interactable:connect(child) end

---*Server only*  
---Connects interactable with joint.  
---@param child Joint The receiver of a connection.
function Interactable:connectToJoint(child) end

---*Server only*  
---Disconnects two interactables. Similar to using the Connect Tool.  
---@param child Interactable The receiver of a connection.
---@return boolean # The receiver of a connection.
function Interactable:disconnect(child) end

---*Client only*  
---Returns animation duration in seconds.  
---@param name string The name of the animation.
---@return number
function Interactable:getAnimDuration(name) end

---Returns a table of [Joint, bearings] that an interactable is connected to.  
---@return Joint[] # A table of the connected [Joint, bearings] {[Joint], ..}.
function Interactable:getBearings() end

---Returns the [Body] an interactable's [Shape] is part of.  
---@return Body # The body an interactable's shape is part of.
function Interactable:getBody() end

---*Server only*  
---Get carry data for a script interactable  
---@return any # The data
function Interactable:getCarryData() end

---Returns a table of child [Interactable, interactables] that an interactable is connected to. The children listen to the interactable's output.  
---@param flags? integer Connection type flags filter. (defaults to all types except for sm.interactable.connectionType.bearing (for backwards compability))
---@return (Interactable|Joint)[]  # A table of the connected child [Interactable, interactables] {[Interactable], ..}.
function Interactable:getChildren(flags) end

---*Client only*  
---Returns (client) public data from a interactable.  
---@return table # The public data.
function Interactable:getClientPublicData() end

---Returns the connection-point highlight color of an interactable. The point is shown when using the <em>Connect Tool</em>.  
---@return Color  # The connection-point highlight color.
function Interactable:getColorHighlight() end

---Returns the connection-point color of an interactable. The point is shown when using the <em>Connect Tool</em>.  
---@return Color # The connection-point color.
function Interactable:getColorNormal() end

---Returns the input connection type.  
---@return integer # connection type The input connection type.
function Interactable:getConnectionInputType() end

---Returns the output connection type.  
---@return integer # connection type The output connection type.
function Interactable:getConnectionOutputType() end

---Returns the container stored in the given index inside the controller  
---@param index? integer The index of the container (default: 0).
---@return Container # The container.
function Interactable:getContainer(index) end

---*Client only*  
---Gets the glow multiplier.  
---@return number # The glow multiplier (0.0 - 1.0).
function Interactable:getGlowMultiplier() end

---Returns the id of an interactable.  
---@return integer
function Interactable:getId() end

---Returns custom joint script data.  
---@param joint Joint # The joint.
---@return any # The data.
function Interactable:getJointCustomData(joint) end

---Returns a table of all [Joint, joints] that an interactable is connected to. Joints include <strong>bearings</strong> and <strong>pistons</strong>.  
---@return Joint[] # A table of the connected [Joint, joints] {[Joint], ..}.
function Interactable:getJoints() end

---Return the position of the bone  
---@param name string The bone name.
---@return Vec3 # The position.
function Interactable:getLocalBonePosition(name) end

---Returns the maximum number of allowed child connections of an interactable &ndash; the number of outgoing connections.  
---@return integer # The max child connection count.
function Interactable:getMaxChildCount() end

---Returns the maximum number of allowed parent connections of an interactable &ndash; the number of incoming connections.  
---@return integer # The max parent connection count.
function Interactable:getMaxParentCount() end

---Returns a table of parent [Interactable, interactables] that are connected to an interactable. The parents act as the interactable's input.  
---@param flags? integer Connection type flags filter. (default to all types)
---@return Interactable[] # A table of the connected parent [Interactable, interactables] {[Interactable], ..}.
function Interactable:getParents(flags) end

---Returns a table of [Joint, pistons] that an interactable is connected to.  
---@return Joint[] # A table of the connected [Joint, pistons] {[Joint], ..}.
function Interactable:getPistons() end

---*Client only*  
---Returns the pose weight of the pose in the given index.  
---@param index integer The index.
---@return number # The pose weight.
function Interactable:getPoseWeight(index) end

---Returns the power output signal of an interactable. Signal is a number between -1 to 1, where 1 is forward and -1 backward.  
---@return number # The power output signal.
function Interactable:getPower() end

---*Server only*  
---Returns (server) public data from a interactable.  
---@return table # The public data.
function Interactable:getPublicData() end

---Returns the [Character] that is seated in the [Interactable].  
---@return Character # The character.
function Interactable:getSeatCharacter() end

---Retrieves the list of [Interactable] connected to the seat.  
---@return Interactable[]
function Interactable:getSeatInteractables() end

---Returns the [Shape] of an interactable.  
---@return Shape # The shape which hosts the interactable.
function Interactable:getShape() end

---Returns the parent [Interactable] that is connected to an interactable. The parent act as the interactable's input.  
---**Warning:**
---*This method is <strong>not</strong> allowed for an interactable that allows more than one parent connection.*
---@return Interactable # The connected parent interactable.
function Interactable:getSingleParent() end

---Returns the steering direction of a seat. (A = -1, D = 1)
---@return number # The steering angle
function Interactable:getSteeringAngle() end

---Returns the left angle limit of a [Joint] connected to a steering [Interactable].  
---@param joint Joint The joint.
---@return number # The left angle limit.
function Interactable:getSteeringJointLeftAngleLimit(joint) end

---Returns the left angle speed of a [Joint] connected to a steering [Interactable].  
---@param joint Joint The joint.
---@return number # The left angle speed.
function Interactable:getSteeringJointLeftAngleSpeed(joint) end

---Returns the right angle limit of a [Joint] connected to a steering [Interactable].  
---@param joint Joint The joint.
---@return number # The right angle limit.
function Interactable:getSteeringJointRightAngleLimit(joint) end

---Returns the right angle speed of a [Joint] connected to a steering [Interactable].  
---@param joint Joint The joint.
---@return number # The right angle speed.
function Interactable:getSteeringJointRightAngleSpeed(joint) end

---Returns the settings of a [Joint] connected to a steering [Interactable].  
---@param joint Joint # The joint.
---@return number,number,number,number,boolean # The left angle speed; right angle speed; left angle limit; right angle limit; true if the joint is unlocked.
function Interactable:getSteeringJointSettings(joint) end

---Returns the unlocked state of a [Joint] connected to a steering [Interactable].  
---@param joint Joint # The joint.
---@return boolean # True if the joint is unlocked
function Interactable:getSteeringJointUnlocked(joint) end

---Returns the throttle direction of a seat. (W = 1, S = -1)
---@return number # The power.
function Interactable:getSteeringPower() end

---Returns the sprint value of an steering interactable.  
---@return boolean # The sprint value
function Interactable:getSteeringSprint() end

---Returns the interactable type of an interactable.  
---@return string # The interactable's type. ([sm.interactable.types])
function Interactable:getType() end

---*Client only*  
---Returns the index of the current UV animation frame  
---@return integer # The uv frame.
function Interactable:getUvFrameIndex() end

---Return the position of the bone  
---@param name string # The bone name.
---@return Vec3 # The position.
function Interactable:getWorldBonePosition(name) end

---*Client only*  
---Checks if an animation exists.  
---@param name string # The name of the animation.
---@return boolean # True if exists, false otherwise.
function Interactable:hasAnim(name) end

---Returns true if the interactable had updates since the given tick.  
---@param tick integer # The tick.
---@return boolean # Returns true if the interactable has been updated.
function Interactable:hasChanged(tick) end

---Returns true if the [Interactable] has the output type.  
---@param flags integer # The output type.
---@return boolean # Has the output type.
function Interactable:hasOutputType(flags) end

---Returns true if [Interactable] has a seat component.  
---@return boolean # The result.
function Interactable:hasSeat() end

---Returns true if [Interactable] has a steering component.  
---@return boolean # The result.
function Interactable:hasSteering() end

---Returns the logic output signal of an interactable. Signal is a boolean, <strong>on</strong> or <strong>off</strong>.  
---@return boolean # The logic output signal.
function Interactable:isActive() end

---*Client only*  
---Returns if the animation isLooping or not.  
---@param name string # The name of the animation.
---@return bool # Is the animation looping.
function Interactable:isAnimLooping(name) end

---Triggers a press interaction on a [Interactable] connected to the seat.  
---@param index integer # The index of the interactable to press.
---@return boolean # True if successful.
function Interactable:pressSeatInteractable(index) end

---Triggers a release interaction on a [Interactable] connected to the seat.  
---@param index integer # The index of the interactable to release.
---@return boolean # True if successful.
function Interactable:releaseSeatInteractable(index) end

---*Server only*  
---Removes the container stored in the given index inside the controller  
---@param index integer # The index of the container.
function Interactable:removeContainer(index) end

---*Server only*  
---Sets the logic output signal of an interactable. Signal is a boolean, <strong>on</strong> or <strong>off</strong>.  
---@param signal boolean # The logic output signal.
function Interactable:setActive(signal) end

---*Client only*  
---Sets whether the animation with the given name should be applied to the mesh. True enables the animation and false disables it.  
---@param name string # The name of the animation.
---@param enabled boolean # The boolean enable state.
function Interactable:setAnimEnabled(name, enabled) end

---*Client only*  
---Sets the progress on the animation with the given name.  
---@param name string # The name of the animation.
---@param progress number # The animation's progress between 0 and 1.
function Interactable:setAnimProgress(name, progress) end

---*Server only*  
---Set carry data for a script interactable  
---@param data any # The carry data.
function Interactable:setCarryData(data) end

---*Client only*  
---Sets (client) public data on a interactable.  
---@param data table # The public data.
function Interactable:setClientPublicData(data) end

---*Client only*  
---Sets a value to multiply the glow from asg texture with.  
---@param value number # The glow multiplier (0.0 - 1.0).
function Interactable:setGlowMultiplier(value) end

---*Client only*  
---Set the direction of the gyro  
---@param direction Vec3 # The gyro direction.
function Interactable:setGyroDirection(direction) end

---Sets a max motor force on the turret seat  
function Interactable:setGyroForce() end

---Sets a target speed multiplier on the turret seat  
function Interactable:setGyroMaxSpeed() end

---*Server only*  
---Sets custom joint script data.  
---@param joint Joint # The joint.
---@param data any # The data.
function Interactable:setJointCustomData(joint, data) end

---*Server only*  
---Set the override color of a light controller, ignoring the color of the shape.  
---@param color Color # The color to override with.
function Interactable:setLightOverrideColor(color) end

---Sets param data for a script interactable  
---@param data any # The param data.
function Interactable:setParams(data) end

---*Client only*  
---Set the pose weight of the pose in the given index.  
---@param index integer # The index.
---@param value number # The pose weight.
function Interactable:setPoseWeight(index, value) end

---*Server only*  
---Sets the power output signal of an interactable. Signal is a number between -1 to 1, where 1 is forward and -1 backward.  
---@param signal number # The power output signal.
function Interactable:setPower(signal) end

---*Server only*  
---Sets (server) public data on a interactable.  
---@param data table # The public data.
function Interactable:setPublicData(data) end

---Requests to seat a [Character] in the [Interactable].  
---@param character Character # The character.
function Interactable:setSeatCharacter(character) end

---Set the steering flag for a steering interactable.  
---@param steeringFlags integer # The steering flags.
function Interactable:setSteeringFlag(steeringFlags) end

---*Client only*  
---Sets the left angle limit settings of a [Joint] connected to a steering [Interactable].  
---@param joint Joint # The joint.
---@param value number # The left angle limit.
function Interactable:setSteeringJointLeftAngleLimit(joint, value) end

---*Client only*  
---Sets the left angle speed settings of a [Joint] connected to a steering [Interactable].  
---@param joint Joint # The joint.
---@param value number # The left angle speed.
function Interactable:setSteeringJointLeftAngleSpeed(joint, value) end

---*Client only*  
---Sets the right angle limit settings of a [Joint] connected to a steering [Interactable].  
---@param joint Joint # The joint.
---@param value number # The right angle limit.
function Interactable:setSteeringJointRightAngleLimit(joint, value) end

---*Client only*  
---Sets the right angle speed settings of a [Joint] connected to a steering [Interactable].  
---@param joint Joint # The joint.
---@param value number # The right angle speed.
function Interactable:setSteeringJointRightAngleSpeed(joint, value) end

---*Client only*  
---Sets the settings of a [Joint] connected to a steering [Interactable].  
---@param joint Joint # The joint.
---@param leftAngleSpeed number # The left angle speed.
---@param rightAngleSpeed number # The right angle speed.
---@param leftAngleLimit number # The left angle limit.
---@param rightAngleLimit number # The right angle limit.
---@param unlocked boolean # Whether the joint is unlocked.
function Interactable:setSteeringJointSettings(joint, leftAngleSpeed, rightAngleSpeed, leftAngleLimit, rightAngleLimit, unlocked) end

---*Client only*  
---Sets unlocked settings of a [Joint] connected to a steering [Interactable].  
---@param joint Joint # The joint.
---@param value boolean # true if joint is unlocked
function Interactable:setSteeringJointUnlocked(joint, value) end

---*Client only*  
---Set the visibility of a submesh  
---@param name string # Name of the submesh.
---@param visible boolean # True if the submesh should be visible.
function Interactable:setSubMeshVisible(name, visible) end

---*Client only*  
---Sets the UV animation frame with the given index.  
---@param index integer # The index.
function Interactable:setUvFrameIndex(index) end

---Unset the steering flag for a steering interactable.  
---@param steeringFlags integer # The steering flags.
function Interactable:unsetSteeringFlag(steeringFlags) end


---@class Joint
---A userdata object representing a <strong>joint</strong> in the game.  
---@operator eq(Joint): boolean
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
---**Set**:
---*Server only*  
---Sets the color of a joint.  
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
---@param uuid Uuid # The uuid of the shape.
---@param size Vec3 # The shape's size.
---@param position Vec3 # The shape's local position.
---@param forceCreate? boolean # Set true to force create the shape. (Defaults to true)
function Joint:createBlock(uuid, size, position, forceCreate) end

---*Server only*  
---Create a part on joint.  
---@param uuid Uuid # The uuid of the shape.
---@param position Vec3 # The shape's local position.
---@param zAxis Vec3 # The shape's local z direction.
---@param xAxis Vec3 # The shape's local x direction.
---@param forceCreate? boolean # Set true to force create the shape. (Defaults to true)
function Joint:createPart(uuid, position, zAxis, xAxis, forceCreate) end

---Returns the angle of a bearing.  
---@return number # The bearing's angle. The angle ranges between `-math.pi` and `+math.pi`.
function Joint:getAngle() end

---Returns the angular velocity of a bearing.  
---The angular velocity can be set using [Joint.setMotorVelocity, setMotorVelocity] or [Joint.setTargetAngle, setTargetAngle].  
---@return number # The bearing's angular velocity.
function Joint:getAngularVelocity() end

---Returns the angular velocity of a generic joint.  
---@return Vec3 # The joint's angular velocities.
function Joint:getAngularVelocityVector() end

---Returns the applied impulse of a bearing.  
---The applied impulse can be set using [Joint.setMotorVelocity, setMotorVelocity] or [Joint.setTargetAngle, setTargetAngle].  
---@return number # The bearing's applied impulse.
function Joint:getAppliedImpulse() end

---Returns whether a joint has a bearing enabled.  
---@return boolean # Whether the joint has a bearing enabled. Springs return whether their bearing is enabled, bearings always return true, pistons always return false.
function Joint:getBearingEnabled() end

---Returns the bounding box of a joint &ndash; the dimensions that a joint occupies when building.  
---@return Vec3 # The size of the joint's bounding box.
function Joint:getBoundingBox() end

---Returns the color of a joint.  
---@return Color # The joint's color.
function Joint:getColor() end

---Returns the id of a joint.  
---@return integer # The joint's id.
function Joint:getId() end

---Returns the current length of a piston. The length is measured in blocks.  
---@return number # The piston's current length in blocks.
function Joint:getLength() end

---Returns the local position of a joint.  
---@return Vec3 # The joint's local position.
function Joint:getLocalPosition() end

---Returns the local rotation of a joint.  
---@return Quat # The joint's local rotation.
function Joint:getLocalRotation() end

---@return Joint[] # A table of joints contained in the multishape (returns nil if joint wasn't a multishape)
function Joint:getMultiShapeJoints() end

---@return Shape[] # A table of shapes contained in the multishape (returns nil if joint wasn't a multishape)
function Joint:getMultiShapeShapes() end

---Returns the [Shape] a joint is attached to. This shape does always exist.  
---@return Shape # The joint's first shape.
function Joint:getShapeA() end

---Returns the [Shape] that is attached to a joint on another [Body]. This method returns nil if there is no shape attached to the joint.  
---@return Shape # The joint's second shape.
function Joint:getShapeB() end

---Returns the uuid string unique to a joint type.  
---@return Uuid # The joint's uuid.
function Joint:getShapeUuid() end

---Returns the sticky directions of the joint for positive xyz and negative xyz.  
---A value of 1 means that the direction is sticky and a value of 0 means that the direction is not sticky.  
---@return Vec3,Vec3 # The negative xyz sticky and the positive xyz sticky.
function Joint:getSticky() end

---Returns the joint type of a joint.  
---@return string # One of the joint's type found in (sm.joint.types).
function Joint:getType() end

---Returns the world position of a joint.  
---@return Vec3 # The joint's world position.
function Joint:getWorldPosition() end

---Returns the world rotation of a joint.  
---@return Quat # The joint's world rotation.
function Joint:getWorldRotation() end

---Returns the local x-axis vector of a joint.  
---@return Vec3 # The joint's x-axis.
function Joint:getXAxis() end

---Returns the local y-axis vector of a joint.  
---@return Vec3 # The joint's y-axis.
function Joint:getYAxis() end

---Returns the local z-axis vector of a joint.  
---@return Vec3 # The joint's z-axis.
function Joint:getZAxis() end

---Returns whether a bearing has been reversed using the <em>Connect Tool</em>. A reversed bearing rotates counterclockwise.  
---@return boolean # Whether the bearing is reversed (rotating counterclockwise).
function Joint:isReversed() end

---*Server only*  
---Sets the color of a joint.  
---@param color Color # The new color.
function Joint:setColor(color) end

---Sets the motor velocity for a bearing. The bearing will try to maintain the target velocity with the given amount of impulse/strength.  
---In Scrap Mechanic, the Gas Engine increases both velocity and impulse with every gear. The Electric Engine increases velocity, but maintains the same impulse for every gear, making it sturdier.  
---This method cancels the effects of [Joint.setTargetAngle, setTargetAngle].  
---@param targetVelocity number # The target velocity.
---@param maxImpulse number # The max impulse.
function Joint:setMotorVelocity(targetVelocity, maxImpulse) end

---Sets the target angle for a bearing. The bearing will try to reach the target angle with the target velocity and the given amount of impulse/strength.  
---The target angle is set to range between `-math.pi` and `+math.pi`. The bearing will always try to rotate in the direction closest to the target angle.  
---This method cancels the effects of [Joint.setMotorVelocity, setMotorVelocity].  
---@param targetAngle number # The target angle.
---@param targetVelocity number # The target velocity.
---@param maxImpulse number # The max impulse.
function Joint:setTargetAngle(targetAngle, targetVelocity, maxImpulse) end

---*Server only*  
---Sets the target length for a piston. The piston will try to reach the target length with the target velocity and the given amount of impulse/strength.  
---The target length is measured in blocks.  
---This method cancels the effects of [Joint.setMotorVelocity, setMotorVelocity].  
---@param targetLength number # The target length.
---@param targetVelocity number # The target velocity.
---@param maxImpulse? number # The max impulse. (Defaults to impulse used in game)
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
---@param player Player # The client player (or the host).
---@param callbackMethod string # The client function name.
---@param args? any # Optional arguments to be sent to the client.
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
---@param callbackMethod string # The client function name.
---@param args? any # Optional arguments to be sent to the client.
function Network:sendToClients(callbackMethod, args) end

---*Client only*  
---Sends a network event from the client to the server. This will run the callback method on the server with optional arguments.  
---```
----- Example of calling server function over network, called function receives the optional argument and the sending player
---function MySwitch.client_onInteract( self ) 
---	self.network:sendToServer( 'server_setSwitch', { active = true } )
---end
---
---function MySwitch.server_setSwitch( self, args, player ) 
---	-- Set state of switch
---	self.interactable.active = args.active
---end
---```
---@param callbackMethod string # The server function name.
---@param args? any # Optional arguments to be sent to the server.
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
---function MyEngine.client_onClientDataUpdate( self, data, channel )
---	if channel == 1 then
---		self.interactable:setPoseWeight( 0, data.gear / self.maxGears )
---	end
---end
---```
---@param data any # Persistent data to be synchronized with existing and new clients.
---@param channel? 1|2 # Client data channel, 1 to 4 (Optional) (Defaults to 1)
function Network:setClientData(data, channel) end


---@class Item
---@field uuid Uuid The UUID of the item.
---@field instance number The instance ID, if the item is a tool.
---@field quantity number The item amount.


---@class Container
---Represents a container  
---@operator eq(Container): boolean
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

---*Server only*  
---Binds a container's onTransaction event to a custom callback. The event is triggered when a transaction is completed.  
---@param callback string # The name of the Lua function to bind.
---@param object? table # The object that will receive the callback. (optional)
function Container:bindOnTransaction(callback, object) end

---Checks if [sm.container.collect] is allowed using the same parameters.  
---@param itemUuid Uuid # The uuid of the item.
---@param quantity integer # The number of items.
---@return boolean # Indicates if the action is possible.
function Container:canCollect(itemUuid, quantity) end

---Checks if the container can collect a set of items.  
---@param uuids Uuid[] # The uuids of items to check.
---@param quantities number[] # The number of items of each uuid. Needs to match the number of uuids.
---@return boolean # Indicates if the action is possible.
function Container:canCollectAll(uuids, quantities) end

---Checks if [sm.container.spend] is allowed.  
---@param itemUuid Uuid # The uuid of the item.
---@param quantity integer # The number of items.
---@return boolean # Indicates if the action is possible.
function Container:canSpend(itemUuid, quantity) end

---*Server only*  
---Clears out the contents of the container.  
function Container:clear() end

---*Server only*  
---Adds a quantity of a given item to a container.  
---@param itemUuid Uuid # The uuid of the item.
---@param quantity integer # The number of items.
---@param mustCollectAll? boolean # Must collect all items for the transaction to be valid. Defaults to true. (Optional)
---@return integer # The number of items successfully added.
function Container:collect(itemUuid, quantity, mustCollectAll) end

---*Server only*  
---Returns whether the container can collect items.  
---@return boolean # Returns true if the container can collect.
function Container:getAllowCollect() end

---*Server only*  
---Returns whether the container can spend items.  
---@return boolean # Returns true if the container can spend.
function Container:getAllowSpend() end

---Returns a table containing item uuid, quantity (and instance id for tools) at given slot.  
---@param slot integer # The slot.
---@return Item # Table containg item {uuid = [Uuid], instance = integer, quantity = integer}.
function Container:getItem(slot) end

---Returns the max stack size in the container.  
---@return integer # The max stack size.
function Container:getMaxStackSize() end

---Returns the network revision number of the container.  
---@return number # The revision
function Container:getRevision() end

---Returns the number of slots in a container.  
---@return integer # The size.
function Container:getSize() end

---*Server only*  
---Returns true if the given tick is lower than the tick the container was last changed.  
---@param tick integer # The tick.
---@return boolean # Returns true if the container has been changed.
function Container:hasChanged(tick) end

---Returns true if the container is empty.  
---@return boolean # Returns true if the container is empty.
function Container:isEmpty() end

---Returns true if all container slots in the container is at max capacity.  
---@return boolean # Returns true if the container is empty.
function Container:isFull() end

---*Server only*  
---Resize a container.  
---@param size integer # The new size of the container.
---@param stackSize? integer # The stack size. Defaults to maximum possible stack size(65535).
function Container:resize(size, stackSize) end

---*Server only*  
---Sets whether the container can collect items.  
---@param allow boolean # True if the container can collect.
function Container:setAllowCollect(allow) end

---*Server only*  
---Sets whether the container can spend items.  
---@param allow boolean # True if the container can spend.
function Container:setAllowSpend(allow) end

---*Server only*  
---Set item filter.  
---@param filter Uuid[] # A table of the item uuid's {[Uuid], ...} allowed to be stored in the container.
function Container:setFilters(filter) end

---*Server only*  
---Sets the number of items stacked in a given container slot.  
---@param slot integer # The slot.
---@param itemUuid Uuid # The uuid of the item.
---@param quantity integer # The number of items.
---@param instance? integer # The instance id, if the item is a tool. (Optional)
---@return boolean # Indicates if the action is possible.
function Container:setItem(slot, itemUuid, quantity, instance) end


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
---Returns the smooth direction of where a character is viewing or aiming.  
---@type Vec3
Character.smoothDirection = {}

---**Get**:
---Returns the velocity of a character.  
---@type Vec3
Character.velocity = {}

---**Get**:
---Returns the world a character exists in.  
---@type World
Character.world = {}

---**Get**:
---Returns the world position of a character.  
---**Set**:
---*Server only*  
---Sets the world position of a character.  
---@type Vec3
Character.worldPosition = {}

---*Client only*  
---Adds a renderable (file containing model data) to be used for the character in third person view.  
---@param renderable string # The renderable path.
function Character:addRenderable(renderable) end

---Applies impulse to the characters tumbling shape.  
---@param impulse Vec3 # The impulse.
---@param offset? Vec3 # The offset from the center point. (Defaults to no offset)
function Character:applyTumblingImpulse(impulse, offset) end

---Binds a character's animation to a callback function.  
---@param animationName string # The name of the animation.
---@param triggerTime number # The required time that will have elapsed in the animation when the callback is triggered.
---@param callback string # The name of the Lua function to bind.
function Character:bindAnimationCallback(animationName, triggerTime, callback) end

---@class ActiveAnimationInfo
---@field name string
---@field weight number 

---Returns the set of active animations.  
---@return ActiveAnimationInfo[] # The set of active animations { { name = string, weight = number }, ...}
function Character:getActiveAnimations() end

---@class AnimationInfo
---@field looping boolean
---@field name string
---@field duration number

---*Client only*  
---@param name string # The name.
---@return AnimationInfo # The animation info { name = string, duration = number, looping = boolean }.
function Character:getAnimationInfo(name) end

---Returns whether the character will float or sink in liquid.  
---@return boolean # True if the character will float, false if the character will sink.
function Character:getCanSwim() end

---Returns the uuid of the character.  
---@return Uuid # The character type.
function Character:getCharacterType() end

---*Client only*  
---Returns client public data from a character.  
---@return table # The client public data.
function Character:getClientPublicData() end

---Returns the base color of a character.  
---@return Color # The character color.
function Character:getColor() end

---Returns the radius around the character where it can be heard.  
---@return number # The noise radius of the character.
function Character:getCurrentMovementNoiseRadius() end

---Returns the current movement speed of the character depending on state and multiplier.  
---@return number # The current movement speed.
function Character:getCurrentMovementSpeed() end

---Returns the direction of where a character is viewing or aiming.  
---@return Vec3 # The character's view direction.
function Character:getDirection() end

---*Client only*  
---Gets the glow multiplier.  
---@return number # The glow multiplier (0.0 - 1.0).
function Character:getGlowMultiplier() end

---Returns the height of a character  
---@return number # The character's height.
function Character:getHeight() end

---Returns the id of a character.  
---@return integer # The character's id.
function Character:getId() end

---*Server only*  
---Returns whether a non-player character is immovable,  
---@return boolean # The immovable state of the character.
function Character:getImmovable() end

---Gets the current fraction multiplier applied on the character's jump speed.  
---@return number # The jump speed fraction.
function Character:getJumpSpeedFraction() end

---Get the [Harvestable] that the [Character] is locked to.  
---@return Harvestable # The harvestable.
function Character:getLockingHarvestable() end

---Get the [Interactable] that the [Character] is locked to.  
---@return Interactable # The interactable.
function Character:getLockingInteractable() end

---Returns the mass of a character.  
---@return number # The character's mass.
function Character:getMass() end

---Returns the move speed of a character  
---@return number # The character's move speed.
function Character:getMoveSpeed() end

---Gets the current fraction multiplier applied on the character's movement speed.  
---@return number # The movement speed fraction.
function Character:getMovementSpeedFraction() end

---Returns the player controlling the character.  
---@return Player # The player controlling the character.
function Character:getPlayer() end

---*Server only*  
---Returns (server) public data from a character.  
---@return table # The public data.
function Character:getPublicData() end

---Returns the radius of a character  
---@return number # The character's radius.
function Character:getRadius() end

---Returns the smooth direction of where a character is viewing or aiming.  
---@return Vec3 # The character's smooth view direction.
function Character:getSmoothViewDirection() end

---Returns the sprint speed of a character  
---@return number # The character's sprint speed.
function Character:getSprintSpeed() end

---Returns the normal of the character's contact with a surface. Defaults to a zero vector when no contact is found.  
---@return Vec3 # The surface normal.
function Character:getSurfaceNormal() end

---Returns the world position for a bone in the third person view animation skeleton.  
---@param jointName string # The joint name.
---@return Vec3 # The joint position.
function Character:getTpBonePos(jointName) end

---Returns the world rotation for a bone in the third person view animation skeleton.  
---@param jointName string # The joint name.
---@return Quat # The joint rotation.
function Character:getTpBoneRot(jointName) end

---Returns the angular velocity of the characters tumbling shape.  
---@return Vec3 # The tumbling shape's angular velocity.
function Character:getTumblingAngularVelocity() end

---Returns the extent of the characters tumbling shape.  
---@return Vec3 # The tumbling shape's extent.
function Character:getTumblingExtent() end

---Returns the linear velocity of the characters tumbling shape.  
---@return Vec3 # The tumbling shape's linear velocity.
function Character:getTumblingLinearVelocity() end

---Returns the world position of the characters tumbling shape.  
---@return Vec3 # The tumbling shape's world position.
function Character:getTumblingWorldPosition() end

---Returns the world rotation of the characters tumbling shape.  
---@return Quat # The tumbling shape's world rotation.
function Character:getTumblingWorldRotation() end

---Returns the unit controlling the character.  
---@return Unit # The unit controlling the character.
function Character:getUnit() end

---Returns the velocity of a character.  
---@return Vec3 # The character's velocity.
function Character:getVelocity() end

---Returns the world a character exists in.  
---@return World # The world the character exists in.
function Character:getWorld() end

---Returns the world position of a character.  
---@return Vec3 # The character's world position.
function Character:getWorldPosition() end

---*Client only*  
---Returns whether or not the character has an active animation override on its third person animations.  
---A third person animation override could be the crowbar animation when picking something up or the hammer when placing something.  
---@return bool # Has active animation override.
function Character:hasActiveOverrideAnimation() end

---*Client only*  
---Checks if a character has graphics.  
---@return boolean # Whether the character has graphics.
function Character:hasGraphics() end

---Returns whether a character is currently aiming with a weapon.  
---@return boolean # Whether the character is aiming.
function Character:isAiming() end

---Get the character climbing state.  
---@return boolean # The climbing state.
function Character:isClimbing() end

---Returns whether a character is currently crouching.  
---@return boolean # Whether the character is crouching.
function Character:isCrouching() end

---Returns true if the current character color is its default color.  
---@return boolean # True if the color is the base color.
function Character:isDefaultColor() end

---Get the character diving state.  
---@return boolean # The diving state.
function Character:isDiving() end

---Get the character downed state.  
---@return boolean # The downed state.
function Character:isDowned() end

---Get the character flying state.  
---@return boolean # The flying state.
function Character:isFlying() end

---Get the character hovering state.  
---@return boolean # The hovering state.
function Character:isHovering() end

---Get whether the character is climbing a ladder.  
---@return boolean # The ladder climbing state.
function Character:isLadderClimbing() end

---Returns whether a character is currently moving.  
---@return boolean # Whether the character is moving.
function Character:isMoving() end

---Returns whether the character is currently standing on the ground.  
---@return boolean # Whether the character is on the ground.
function Character:isOnGround() end

---Returns whether a character is owned by a player.  
---@return boolean # Whether the character is owned by a player.
function Character:isPlayer() end

---Returns whether the character is currently seated.  
---@return boolean # Whether the character is seated.
function Character:isSeated() end

---Returns whether a character is currently sprinting.  
---@return boolean # Whether the character is sprinting.
function Character:isSprinting() end

---Get the character swimming state.  
---@return boolean # The swimming state.
function Character:isSwimming() end

---Get the character tumbling state.  
---@return boolean # The tumbling state.
function Character:isTumbling() end

---*Client only*  
---Returns whether a character is visible.  
---@return boolean # Whether the character is visible.
function Character:isVisible() end

---*Client only*  
---Overrides a non player character's third person renderable list with a new list of renderables. Will trigger a rebuild of the character's graphics.  
---@param renderables string[] # An array of renderable file paths to override with.
function Character:overrideRenderableList(renderables) end

---Removes all of a character's animation callbacks.  
function Character:removeAnimationCallbacks() end

---*Client only*  
---Removes a renderable (file containing model data) that was used for the character in third person view.  
---@param renderable string # The renderable path.
function Character:removeRenderable(renderable) end

---*Client only*  
---Enables or disables event animations.  
---When set to false no animations can play while tumble is active, and when set to true the animations will play while tumbling.  
---@param allow boolean # The state.
function Character:setAllowTumbleAnimations(allow) end

---*Client only*  
---Sets client public data on a character.  
---@param data table # The client public data.
function Character:setClientPublicData(data) end

---*Server only*  
---Sets whether the character is climbing.  
---@param state boolean # The climbing state.
function Character:setClimbing(state) end

---*Server only*  
---Sets the character color.  
---@param color Color # The character color.
function Character:setColor(color) end

---*Server only*  
---Sets whether the character is diving.  
---@param state boolean # The diving state.
function Character:setDiving(state) end

---*Server only*  
---Sets whether the character is downed.  
---@param state boolean # The downed state.
function Character:setDowned(state) end

---*Server only*  
---Sets whether the character is flying.  
---Will not activate flight for player characters.  
---@param state boolean # The flying state.
function Character:setFlying(state) end

---*Client only*  
---Sets a value to multiply the glow from asg texture with.  
---@param value number # The glow multiplier (0.0 - 1.0).
function Character:setGlowMultiplier(value) end

---*Server only*  
---Sets whether the character is hovering.  
---Will not activate hover for player characters.  
---@param state boolean # The hovering state.
function Character:setHovering(state) end

---*Server only*  
---Sets the immovable state on a non-player character. This prevents the character from updating its physics.  
---@param enable boolean # Set immovable state.
function Character:setImmovable(enable) end

---Sets a fraction multiplier to the character's jump speed.  
---@param fraction number # The jump speed fraction.
function Character:setJumpSpeedFraction(fraction) end

---Set the [Harvestable] that the [Character] is locked to. Set [Harvestable] to nil to unlock.  
---@param harvestable Harvestable # The harvestable.
---@return boolean # True if the character was successfully locked or unlocked.
function Character:setLockingHarvestable(harvestable) end

---Set the [Interactable] that the [Character] is locked to. Set [Interactable] to nil to unlock.  
---@param interactable Interactable # The interactable.
---@return boolean # True if the character was successfully locked or unlocked.
function Character:setLockingInteractable(interactable) end

---Sets the movement effect set filepath.  
---@param filepath string # The effect set filepath.
function Character:setMovementEffects(filepath) end

---Sets a fraction multiplier to the character's movement speed.  
---@param fraction number # The movement speed fraction.
function Character:setMovementSpeedFraction(fraction) end

---*Client only*  
---Sets the weights for movement animations on a character's upper and lower body.  
---For a value of 0 no movement animations will play, and for a value of 1 the movement animations will fully play unless otherwise overridden.  
---@param lower number # The lower weight.
---@param upper number # The upper weight.
function Character:setMovementWeights(lower, upper) end

---*Client only*  
---Sets the name tag display value for the character  
---@param name string # The new name tag text value.
---@param color? Color # The color of the name. (defaults to white)
---@param requiresLoS? boolean # Whether broken line of sight will hide the name tag. (Defaults to false)
---@param renderDistance? number # Max distance the name tag will render in. (Defaults to 10000)
---@param fadeDistance? number # Distance where fade out will start. (Defaults to 9500)
function Character:setNameTag(name, color, requiresLoS, renderDistance, fadeDistance) end

---*Server only*  
---Sets (server) public data on a character.  
---@param data table # The public data.
function Character:setPublicData(data) end

---*Server only*  
---Sets whether the character is swimming.  
---**Note:**
---*By default the swimming state is controlled by the client as part of the player movement. This value is treated like an override that is synchronized from the server. Buoyancy calculations in the character controller require that the character touches a liquid volume.*
---@param state boolean # The swimming state.
function Character:setSwimming(state) end

---*Server only*  
---Sets whether the character is tumbling.  
---@param state boolean # The tumbling state.
function Character:setTumbling(state) end

---*Client only*  
---Sets the upward direction of the character's graphics.  
---@param up Vec3 # The direction.
function Character:setUpDirection(up) end

---*Client only*  
---Sets the visibility.  
---@param visible boolean # Whether the character should be visible.
function Character:setVisible(visible) end

---*Server only*  
---Sets the world position of a character.  
---@param position Vec3 # The character's new world position.
function Character:setWorldPosition(position) end

---*Client only*  
---Updates a character animation.  
---@param name string # The animation name.
---@param time number # The time.
---@param weight? number # The weight. Defaults to -1.0. (Optional)
---@param additive? boolean # Whether the animation will be added to the default animation. Defaults to false. (Optional)
function Character:updateAnimation(name, time, weight, additive) end


---@class Player
---A userdata object representing a <strong>player</strong> in the game.  
---@operator eq(Player): boolean
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
---@return Container # The player's carry.
function Player:getCarry() end

---*Server only*  
---Returns the color of the shape the player is carrying.  
---@return Color # The color of the shape the player is carrying.
function Player:getCarryColor() end

---*Server only*  
---get the carry data on a player.  
function Player:getCarryData() end

---Returns the character the player is controlling.  
---@return Character # The player's character.
function Player:getCharacter() end

---*Client only*  
---Returns client public data from a player.  
---@return table # The client public data.
function Player:getClientPublicData() end

---Returns the uuid of the tool the player is currently holding.  
---@return Tool # The player's held tool uuid.
function Player:getCurrentToolUuid() end

---*Server only*  
---Get uuid of customization from index  
---@param customization integer # index
---@return uuid # uuid
function Player:getCustomizationUuid(customization) end

---Returns the hotbar container of the player.  
---@return Container # The player's hotbar.
function Player:getHotbar() end

---Returns the id of a player.  
---@return integer # The player's id.
function Player:getId() end

---Returns the inventory container of the player.  
---@return Container # The player's inventory.
function Player:getInventory() end

---Returns the name of a player.  
---@return string # The player's name.
function Player:getName() end

---*Server only*  
---Returns (server) public data from a player.  
---@return table # The public data.
function Player:getPublicData() end

---Returns true if the player is currently in the game.  
---@return boolean # True if active.
function Player:isActive() end

---Check if the player is female  
---@return boolean # True if female
function Player:isFemale() end

---Check if the player is male  
---@return boolean # True if male
function Player:isMale() end

---*Server only*  
---Place down a lift game object  
---@param creation Body[] # The bodies to place on the lift. {[Body], ..}
---@param position Vec3 # The lift position.
---@param level integer # The lift level.
---@param rotation integer # The rotation of the creation on the lift.
function Player:placeLift(creation, position, level, rotation) end

---*Server only*  
---Remove the player's lift, if the lift exists.  
function Player:removeLift() end

---*Server only*  
---Sends an event to a given player  
---@param event string # The event to send
function Player:sendCharacterEvent(event) end

---*Server only*  
---Set the carry data on a player.
---@param data table  
function Player:setCarryData(data) end

---*Server only*  
---Sets the character the player is controlling.  
---@param character Character # The character.
function Player:setCharacter(character) end

---*Client only*  
---Sets client public data on a player.  
---@param data table # The client public data.
function Player:setClientPublicData(data) end

---*Server only*  
---Sets (server) public data on a player.  
---@param data table # The public data.
function Player:setPublicData(data) end


---@class AreaTrigger
---A userdata object representing an <strong>area trigger</strong> in the game.  
---@operator eq(AreaTrigger): boolean
local AreaTrigger = {}

---**Get**:
---Returns the id of an area trigger.  
---@type integer
AreaTrigger.id = {}

---**Get**:
---Returns the world id of the area trigger. Keep in mind that area triggers can move between worlds, so world id might change!  
---@type World
AreaTrigger.world = {}

---*Client only*  
---Bind a callback that checks if the area trigger can be erased.  
---@param callback string # The name of the Lua function to bind.
---@param object? table # The object that will receive the callback. (optional)
function AreaTrigger:bindCanErase(callback, object) end

---*Client only*  
---Bind the lua function to be used when checking for player interaction with the area trigger  
---@param callback string # The name of the Lua function to bind.
---@param object? table # The object that will receive the callback. (optional)
function AreaTrigger:bindCanInteract(callback, object) end

---Bind the lua function to be called when the area trigger is destroyed  
---@param callback string # The name of the Lua function to bind.
---@param object? table # The object that will receive the callback. (optional)
function AreaTrigger:bindOnDestroy(callback, object) end

---Binds an area trigger's onEnter event to a custom callback. The onEnter event is triggered when an object enters the trigger area.  
---The callback receives:  
--- - <strong>self</strong> (<em>table</em>) &ndash; The class instance.
--- - <strong>trigger</strong> (<em>[AreaTrigger]</em>) &ndash; The area trigger instance.
--- - <strong>results</strong> (<em>table</em>) &ndash; A table of [Character, characters] and/or [Body, bodies] and/or [Harvestable, harvestables] and/or [Lift, lifts] and/or [AreaTrigger, areaTriggers].
---```
---function MyClass.onEnter( self, trigger, results ) ...
---```
---@param callback string # The name of the Lua function to bind.
---@param object? table # The object that will receive the callback. (optional)
function AreaTrigger:bindOnEnter(callback, object) end

---*Client only*  
---Bind the lua function to be used when an interactable area trigger is erased.  
---@param callback string # The name of the Lua function to bind.
---@param object? table # The object that will receive the callback. (optional)
function AreaTrigger:bindOnErase(callback, object) end

---Binds an area trigger's onExit event to a custom callback. The onExit event is triggered when an object leaves the trigger area.  
---The callback receives:  
--- - <strong>self</strong> (<em>table</em>) &ndash; The class instance.
--- - <strong>trigger</strong> (<em>[AreaTrigger]</em>) &ndash; The area trigger instance.
--- - <strong>results</strong> (<em>table</em>) &ndash; A table of [Character, characters] and/or [Body, bodies] and/or [Harvestable, harvestables] and/or [Lift, lifts] and/or [AreaTrigger, areaTriggers].
---```
---function MyClass.onExit( self, trigger, results ) ...
---```
---@param callback string # The name of the Lua function to bind.
---@param object? table # The object that will receive the callback. (optional)
function AreaTrigger:bindOnExit(callback, object) end

---Bind the lua function to be used when an area trigger is destroyed.  
---@param callback string # The name of the Lua function to bind.
---@param object? table # The object that will receive the callback. ( optional )
function AreaTrigger:bindOnHostDestroy(callback, object) end

---Bind the lua function to be used when an interactable area trigger's host object is unloaded.  
---Note: Only the game host can know if a host object is unloaded, to a connected client it will look like the host object was destroyed.  
---@param callback string # The name of the Lua function to bind.
---@param object? table # The object that will receive the callback. ( optional )
function AreaTrigger:bindOnHostUnload(callback, object) end

---*Client only*  
---Bind the lua function to be used when a player interacts with an area trigger  
---@param callback string # The name of the Lua function to bind.
---@param object? table # The object that will receive the callback. (optional)
function AreaTrigger:bindOnInteract(callback, object) end

---*Server only*  
---Bind the lua function to be used when the area trigger is hit by a melee attack.  
---Requires that areaTriggerProxyType has been set to [sm.areaTrigger.areaTriggerProxyType, sm.areaTrigger.areaTriggerProxyType.melee]  
---@param callback string # The name of the Lua function to bind.
---@param object? table # The object that will receive the callback. (optional)
function AreaTrigger:bindOnMelee(callback, object) end

---Binds an area trigger's onProjectile event to a custom callback. The onProjectile event is triggered if a projectile collides with the trigger area  
---@param callback string # The name of the Lua function to bind.
---@param object? table # The object that will receive the callback. (optional)
function AreaTrigger:bindOnProjectile(callback, object) end

---Binds an area trigger's onStay event to a custom callback. The onStay event is triggered every tick as long as an object is staying inside of the trigger area.  
---The callback receives:  
--- - <strong>self</strong> (<em>table</em>) &ndash; The class instance.
--- - <strong>trigger</strong> (<em>[AreaTrigger]</em>) &ndash; The area trigger instance.
--- - <strong>results</strong> (<em>table</em>) &ndash; A table of [Character, characters] and/or [Body, bodies] and/or [Harvestable, harvestables] and/or [Lift, lifts] and/or [AreaTrigger, areaTriggers].
---```
---function MyClass.onStay( self, trigger, results ) ...
---```
---@param callback string # The name of the Lua function to bind.
---@param object? table # The object that will receive the callback. (optional)
function AreaTrigger:bindOnStay(callback, object) end

---Destroys an area trigger.  
function AreaTrigger:destroy() end

---Gets the trigger collisions for characters inside the area trigger  
---@return Character[] # A table of character trigger collisions.
function AreaTrigger:getCharacters() end

---Gets the contents of the area trigger.  
---Returns a table of [Character, characters] and/or [Body, bodies] and/or [Harvestable, harvestables] and/or [Lift, lifts] and/or [AreaTrigger, areaTriggers].  
---@return (Character|Body|Harvestable|Lift|Areatrigger)[] # The table with the content.
function AreaTrigger:getContents() end

---Gets the trigger collisions for harvestables inside the area trigger  
---@return Harvestable[] # A table of harvestable trigger collisions.
function AreaTrigger:getHarvestables() end

---Returns the attached host [sm.interactable, interactable].  
---@return Interactable # The area trigger's host interactable.
function AreaTrigger:getHostInteractable() end

---Returns the id of an area trigger.  
---@return integer # The area trigger's id.
function AreaTrigger:getId() end

---@class AreaTriggerShape
---@field shape Shape
---@field triggerWorldPosition Vec3
---@field triggerLocalPosition Vec3
---@field shapeWorldPosition Vec3
---@field shapeLocalPosition Vec3

---Gets the trigger collisions for shapes inside the area trigger  
---Will only return one [Shape] for each [Body] that is colliding with the [AreaTrigger].  
---@return AreaTriggerShape[] # A table of shape trigger collisions.
function AreaTrigger:getShapes() end

---Returns the size of an area trigger.  
---@return Vec3 # The area trigger's size.
function AreaTrigger:getSize() end

---Returns the user data set on the area trigger.  
---@return table # The user data set on this trigger
function AreaTrigger:getUserData() end

---Returns the world id of the area trigger. Keep in mind that area triggers can move between worlds, so world id might change!  
---@return World # The _current_ world id of the area trigger.
function AreaTrigger:getWorld() end

---Returns the world max corner position of an area trigger.  
---@return Vec3 # The area trigger's max corner position.
function AreaTrigger:getWorldMax() end

---Returns the world min corner position of an area trigger.  
---@return Vec3 # The area trigger's min corner position.
function AreaTrigger:getWorldMin() end

---Returns the world position of an area trigger.  
---@return Vec3 # The area trigger's world position.
function AreaTrigger:getWorldPosition() end

---Returns the world rotation of an area trigger.  
---@return Quat # The area trigger's world rotation.
function AreaTrigger:getWorldRotation() end

---Returns true if the [AreaTrigger] is in contact with destructable terrain.  
---@return boolean # Destructable terrain contact.
function AreaTrigger:hasVoxelTerrainContact() end

---When set to true the area trigger can calculate which characters are inside of the trigger and get the collision information.  
---with a call to [AreaTrigger]: getCharacters  
---@param detectCharacters boolean # Character detection on or off.
function AreaTrigger:setCharacterDetection(detectCharacters) end

---Sets whether the areatrigger should be destroyed immediately upon being erased or simply invoke the bound OnErase callback. True by default.  
---@param destroyOnErase boolean # Destroy on erase.
function AreaTrigger:setDestroyOnErase(destroyOnErase) end

---Sets the time it takes to erase this trigger if it is erasable.  
---@param eraseTime number # The time it takes to erase this area trigger.
function AreaTrigger:setEraseTime(eraseTime) end

---When set to true the area trigger can calculate which harvestables are inside of the trigger and get the collision information.  
---with a call to [AreaTrigger]: getHarvestables  
---@param detectHarvestables boolean # Harvestable detection on or off.
function AreaTrigger:setHarvestableDetection(detectHarvestables) end

---When set to true the area trigger will include individual shapes in its content list.  
---@param includeShapesInContent boolean # Include shapes in content on or off.
function AreaTrigger:setIncludeShapesInContent(includeShapesInContent) end

---Shape detection is off by default. When set to true the area trigger can calculate which shapes are inside of the trigger  
---with a call to [AreaTrigger]: getShapes  
---@param detectShapes boolean # Shape detection on or off.
function AreaTrigger:setShapeDetection(detectShapes) end

---Sets the new size of an area trigger.  
---@param size Vec3 # The area trigger's new size.
function AreaTrigger:setSize(size) end

---Sets whether VoxelTerrain can destroy this area trigger by voxel addition.  
---@param destructible boolean # The state to set
function AreaTrigger:setVoxelDestructible(destructible) end

---Sets the liquid type of the area trigger. (See [sm.areaTrigger.liquidType])  
---Only has an effect on area triggers with the 'water' proxy type; setting it on any other proxy type has no effect.  
---Currently only 'lava' has special behavior: it occasionally destroys submerged shapes. Lava behavior requires  
---shapes to be included in the content list via [AreaTrigger]: setIncludeShapesInContent.  
---@param waterType integer # The liquid type. (See [sm.areaTrigger.liquidType])
function AreaTrigger:setWaterType(waterType) end

---Sets the new world position of an area trigger.  
---@param position Vec3 # The area trigger's new world position.
function AreaTrigger:setWorldPosition(position) end

---Sets the new world rotation of an area trigger.  
---@param rotation Quat # The area trigger's new world rotation.
function AreaTrigger:setWorldRotation(rotation) end

---@class World
---A userdata object representing a <strong>world</strong> in the game.  
---@operator eq(World): boolean
local World = {}

---**Get**:
---*Client only*  
---Returns client public data from a world.  
---**Set**:
---*Client only*  
---Sets client public data on a World.  
---@type table
World.clientPublicData = {}

---**Get**:
---Returns the id of a world.  
---@type integer
World.id = {}

---**Get**:
---Returns true if the world is an indoor world.  
---@type boolean
World.indoor = {}

---**Get**:
---*Server only*  
---Returns public data from a world.  
---**Set**:
---*Server only*  
---Sets public data on a World.  
---@type table
World.publicData = {}

---*Server only*  
---Clears the override light color on all light controllers in the world.  
function World:clearLightColorOverride() end

---*Server only*  
---Destroys the given world.  
function World:destroy() end

---Returns the minimum and maximum cell coordinates for the given world.  
---@return integer, integer, integer, integer # The minimum and maximum cell coordinates (minX, maxX, minY, maxY).
function World:getCellBounds() end

---Finds the dominant voxel material inside a capsule volume.  
---@param position Vec3 # The center position of the capsule.
---@param radius number # The radius of the capsule.
---@param height number # The height of the cylindrical part of the capsule (Z-axis aligned, excluding hemispherical caps).
---@return integer # The dominant material index value. (returns nil if no voxel was found)
---@return integer # The highest single-voxel density of the dominant material.
---@return Vec3 # The weighted average world position of the dominant material (biased toward dense, nearby voxels)
function World:getDominantMaterialInCapsule(position, radius, height) end

---Finds the dominant voxel material inside a sphere volume.  
---@param position Vec3 # The center position of the sphere.
---@param radius number # The radius of the sphere.
---@return integer # The dominant material index value. (returns nil if no voxel was found)
---@return integer # The highest single-voxel density of the dominant material.
---@return Vec3 # The weighted average world position of the dominant material (biased toward dense, nearby voxels).
function World:getDominantMaterialInSphere(position, radius) end

---Returns the id of a world.  
---@return integer # The world's id.
function World:getId() end

---@param worldPosition Vec3 # The position of the voxel chunk in the world.
---@return integer # The material index value. (returns nil if no voxel was at point)
---@return integer # The density value. (returns nil if no voxel was at point)
function World:getVoxelMaterialFromWorldPosition(worldPosition) end

---Get weighted voxel density in world point.  
---@param point Vec3 # The world space point to check density in.
---@return number # Weighted density. (returns 0 if world doesn't have voxels)
---@return Vec3 # Weighted direction of voxel influence.
function World:getWeightedVoxelDensityInWorldPoint(point) end

---Returns the zone id from a position.  
---@param position Vec3 # The position.
---@return table? # The Zone id. (nil if position is invalid)
function World:getZoneId(position) end

---Checks if the given cell coordinates are within the bounds of the world.  
---@param x integer # The X coordinate of the cell.
---@param y integer # The Y coordinate of the cell.
---@return boolean # True if the cell is within the bounds of the world, false otherwise.
function World:isCellInBounds(x, y) end

---*Client only*  
---@param cellX integer # The cell X value.
---@param cellY integer # The cell Y value.
---@return boolean # If the cell is loaded or not.
function World:isCellLoadedClient(cellX, cellY) end

---*Server only*  
---@param cellX integer # The cell X value.
---@param cellY integer # The cell Y value.
---@return boolean # If the cell is loaded or not.
function World:isCellLoadedServer(cellX, cellY) end

---Returns true if the world is an indoor world.  
---@return boolean # True if indoor.
function World:isIndoor() end

---Tests if a world position is free from voxel terrain coverage.  
---@param referencePosition Vec3 # The reference position (e.g. character position).
---@param testPosition Vec3 # The position to test for voxel coverage (e.g. shape center).
---@return bool # True if the position is clear of voxel terrain, false if covered.
function World:isVoxelTerrainPointClear(referencePosition, testPosition) end

---*Server only*  
---Load a cell for player. The cell will stay loaded until the player steps into the cell.  
---@param x integer # Cell X position.
---@param y integer # Cell Y Position.
---@param player? Player # A player to load for, can be nil.
---@param callback? string # Lua function to call when cell is loaded. Callback parameters are ( world, x, y, player, params )
---@param params? any # Parameter object passed to the callback.
---@param ref? table # Script ref to callback object.
function World:loadCell(x, y, player, callback, params, ref) end

---Load a cell. The cell will stay loaded until the cell is released with [LoadCellHandle].release()  
---or when the [LoadCellHandle] is garbage collected  
---@param x integer # Cell X position.
---@param y integer # Cell Y Position.
---@param callback? string # Lua function to call when cell is loaded. Callback parameters are ( world, x, y, params )
---@param params? any # Parameter object passed to the callback.
---@param ref? table # Script ref to callback object.
---@return LoadCellHandle # Handle to releasing cell.
function World:loadCellWithHandle(x, y, callback, params, ref) end

---*Server only*  
---Load a cell and nav mesh. The cell will stay loaded until the cell is released with [LoadCellHandle].release()  
---or when the [LoadCellHandle] is garbage collected  
---@param x integer # Cell X position.
---@param y integer # Cell Y Position.
---@param callback? string # Lua function to call when cell nav mesh is created. Callback parameters are ( world, x, y, params )
---@param params? any # Parameter object passed to the callback.
---@param ref? table # Script ref to callback object.
---@return LoadCellHandle # Handle to releasing cell.
function World:loadNavMeshWithHandle(x, y, callback, params, ref) end

---Reload a cell. Callback result values: 0 means cell isnt active and wont be reloaded, 1 means success  
---@param x integer # Cell X position.
---@param y integer # Cell Y Position.
---@param callback? string # Lua function to call when cell is reloaded. Callback parameters are ( world, x, y, result ) (Optional)
---@param ref? table # Script ref to callback object. (Optional)
---@param params? any # Parameter passed to the callback. (Optional)
function World:reloadCell(x, y, callback, ref, params) end

---*Server only*  
---Sets the override light color on all light controllers in the world.  
---@param color Color # The override color.
function World:setLightColorOverride(color) end

---@class VoxelMaterialMiningConfig
---@field sizeX number
---@field sizeY number
---@field sizeZ number
---@field seed number
---@field spawnId number
---@field tunnelType? string
---@field maxDist? number

---@alias MiningConfig [ VoxelMaterialMiningConfig, VoxelMaterialMiningConfig, VoxelMaterialMiningConfig, VoxelMaterialMiningConfig, VoxelMaterialMiningConfig, VoxelMaterialMiningConfig, VoxelMaterialMiningConfig, VoxelMaterialMiningConfig ]

---*Server only*  
---Configures the mining loot population. Matched candidates are sent to the  
---world script via the server_onMining callback whenever voxels are removed.  
---@param config MiningConfig # Spawn rules keyed by voxel material index (1-8). Each value is an array of rule tables: { sizeX, sizeY, sizeZ, seed, spawnId = integers, tunnelType = string (optional), maxDist = number (optional) }.
function World:setMiningConfig(config) end

---Set data to pass on to the terrain generation script. If no data is set the terrain generation script receives the same data as the world script.  
---@param data any # Any data, available to the terrain generation script as parameter 6 in the create callback.
function World:setTerrainScriptData(data) end

---*Server only*  
---Modify voxel terrain with a sphere shape  
---@param position Vec3 # The world position of the sphere.
---@param radius number # The radius of the sphere.
---@param material integer # The material to add [0-7].
---@param player? Player # The player who constructed. (Optional)
function World:sphereVoxelDensityAddition(position, radius, material, player) end

---*Server only*  
---Modify destructable terrain with a sphere shape  
---@param position Vec3 # The world position of the sphere.
---@param radius number # The radius of the sphere.
---@param filter? integer # The materials the shape can modify. (See [sm.world.voxelFilter]). (Defaults to sm.world.voxelFilter.all)
---@param strength? number # The strength of the modification. (Defaults to radius)
---@param callback? string # Lua function to call when cell is loaded. Callback parameters are a table of destruction data { remDensities = {integer, ..}, avgPositions = {[Vec3], ..} } and (optional) pass-through params passed to this function.
---@param params? any # Parameter passed to the callback. (Optional)
function World:sphereVoxelDensitySubtraction(position, radius, filter, strength, callback, params) end

---*Server only*  
---Modify destructable terrain  
---@param position Vec3 # The voxel world position.
---@param surfaceNormal Vec3 # The surface normal.
---@param maxDistance number # The maximum distance from position that can be modified.
---@param targetDensity integer # The target density to add.
---@param material integer # The material to add [0-7].
---@param filter? integer # The materials the shape can modify. (See [sm.world.voxelFilter]). (Defaults to sm.world.voxelFilter.all)
---@param player? Player # The player who constructed. (Optional)
function World:voxelDensityAddition(position, surfaceNormal, maxDistance, targetDensity, material, filter, player) end

---*Server only*  
---Modify destructible terrain around a point or line with a radius.  
---@param position Vec3 # The world position a of the modification.
---@param direction Vec3 # The world direction of the modification. Non normalized direction that defines the center line of modification.
---@param radius number # The maximum distance from positions in the line defined by position and direction that can be modified.
---@param targetDensity integer # The target density to remove.
---@param filter? integer # The materials the shape can modify. (See [sm.world.voxelFilter]). (Defaults to sm.world.voxelFilter.all)
---@param enableDestructionEffect? boolean # Whether to enable destruction effect. (Defaults to true)
---@param callback? string # Lua function to call when cell is loaded. Callback parameters are a table of destruction data { remDensities = {integer, ..}, avgPositions = {[Vec3], ..} } and (optional) pass-through params passed to this function.
---@param params? any # Parameter passed to the callback. (Optional)
function World:voxelDensitySubtraction(position, direction, radius, targetDensity, filter, enableDestructionEffect, callback, params) end

---*Server only*  
---Modify destructible terrain around a point or line with a radius.  
---@param position Vec3 # The world position a of the modification.
---@param direction Vec3 # The world direction of the modification. Non normalized direction that defines the center line of modification.
---@param radius number # The maximum distance from positions in the line defined by position and direction that can be modified.
---@param targetDensities [number, number, number, number, number, number, number, number] # A table of target densities to remove per material type {[1] = integer, .., [8] = integer}.
---@param filter? integer # The materials the shape can modify. (See [sm.world.voxelFilter]). (Defaults to sm.world.voxelFilter.all)
---@param enableDestructionEffect? boolean # Whether to enable destruction effect. (Defaults to true)
---@param callback? string # Lua function to call when cell is loaded. Callback parameters are a table of destruction data { remDensities = {integer, ..}, avgPositions = {[Vec3], ..} } and (optional) pass-through params passed to this function.
---@param params? any # Parameter passed to the callback. (Optional)
function World:voxelDensitySubtraction(position, direction, radius, targetDensities, filter, enableDestructionEffect, callback, params) end


---@class Portal
---@operator eq(Portal): boolean
local Portal = {}

---**Get**:
---Returns the id of a portal.  
---@type integer
Portal.id = {}

---*Server only*  
---Gets the contents of opening A  
---@return (Character|Body)[] # A table of contents of type [Character] and [Body].
function Portal:getContentsA() end

---*Server only*  
---Gets the contents of opening B  
---@return (Character|Body)[] # A table of contents of type [Character] and [Body].
function Portal:getContentsB() end

---Returns the id of a portal.  
---@return integer # The portal's id.
function Portal:getId() end

---*Server only*  
---Returns the position of portal opening A.  
---@return Vec3 # The portal opening A position.
function Portal:getPositionA() end

---*Server only*  
---Returns the position of portal opening B.  
---@return Vec3 # The portal opening B position.
function Portal:getPositionB() end

---*Server only*  
---Returns the rotation of portal opening A.  
---@return Quat # The portal opening A rotation.
function Portal:getRotationA() end

---*Server only*  
---Returns the rotation of portal opening B.  
---@return Quat # The portal opening B rotation.
function Portal:getRotationB() end

---*Server only*  
---Returns the world of a portal opening A.  
---@return World # The portal opening A world.
function Portal:getWorldA() end

---*Server only*  
---Returns the world of a portal opening B.  
---@return World # The portal opening B world.
function Portal:getWorldB() end

---*Server only*  
---Checks if the portal has opening A.  
---@return boolean # True if opening A exists, false if not.
function Portal:hasOpeningA() end

---*Server only*  
---Checks if the portal has opening B.  
---@return boolean # True if opening B exists, false if not.
function Portal:hasOpeningB() end

---*Server only*  
---Sets the offset of the world marker of portal A  
---@param offset Vec3 # The offset of the world marker in world space.
function Portal:setAMarkerOffset(offset) end

---*Server only*  
---Set if transfer from A to B is allowed, used for marker placements  
---@param allowed boolean # Whether the portal is allowed to show A to B connection
function Portal:setAToBMarkerAllowed(allowed) end

---*Server only*  
---Sets the offset of the world marker of portal B  
---@param offset Vec3 # The offset of the world marker in world space.
function Portal:setBMarkerOffset(offset) end

---*Server only*  
---Set if transfer from B to A is allowed, used for marker placements  
---@param allowed boolean # Whether the portal is allowed to show A to B connection
function Portal:setBToAMarkerAllowed(allowed) end

---*Server only*  
---Sets the position of portal opening A.  
---The world will be the same as the object that calls this function.  
---@param position Vec3 # The portal opening A position.
---@param rotation Quat # The portal opening A rotation.
---@param world? World # The world to look in (Optional, defaults to world from script context)
function Portal:setOpeningA(position, rotation, world) end

---*Server only*  
---Sets the position B of portal opening B.  
---The world will be the same as the object that calls this function.  
---@param position Vec3 # The portal opening B position.
---@param rotation Quat # The portal opening B rotation.
---@param world? World # The world to look in (Optional, defaults to world from script context)
function Portal:setOpeningB(position, rotation, world) end

---*Server only*  
---Transfers objects inside A opening to B opening  
---@param filter? integer # A [sm.physics.filter] mask selecting which contents to transfer. Only [sm.physics.filter, dynamicBody], [sm.physics.filter, staticBody] and [sm.physics.filter, character] are meaningful. Defaults to transferring bodies and characters. (Optional)
---@return boolean # True if successful, false on failure.
function Portal:transferAToB(filter) end

---*Server only*  
---Transfers objects inside B opening to A opening  
---@param filter? integer # A [sm.physics.filter] mask selecting which contents to transfer. Only [sm.physics.filter, dynamicBody], [sm.physics.filter, staticBody] and [sm.physics.filter, character] are meaningful. Defaults to transferring bodies and characters. (Optional)
---@return boolean # true if successful, false on failure.
function Portal:transferBToA(filter) end


---@class Harvestable
---Represents a harvestable object in the game.  
---@operator eq(Harvestable): boolean
local Harvestable = {}

---**Get**:
---Returns the angular velocity of the harvestable.  
---@type Vec3
Harvestable.angularVelocity = {}

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
---Gets the initial hash of a kinematic. The initial hash identifies the kinematic by its initial world position, uuid and world id.  
---This can be used to match kinematics spawned from the same entity in a tile even though each loaded kinematic is technically a different object.  
---@type number
Harvestable.initialHash = {}

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
---Returns the velocity of the harvestable.  
---@type Vec3
Harvestable.velocity = {}

---**Get**:
---Returns the world coordinates of a harvestable.  
---@type Vec3
Harvestable.worldPosition = {}

---**Get**:
---Returns the quaternion rotation of a harvestable.  
---@type Quat
Harvestable.worldRotation = {}

---*Client only*  
---Applies a shake impulse to the harvestable.  
---@param shake number # The shake impulse value.
function Harvestable:applyShakeImpulse(shake) end

---*Server only*  
---Destroys a harvestable.  
function Harvestable:destroy() end

---Returns the axis aligned world space bounds of the harvestable.  
---@return Vec3,Vec3 # The min and max bounds.
function Harvestable:getAabb() end

---Returns the angular velocity of the harvestable.  
---@return Vec3 # The angular velocity.
function Harvestable:getAngularVelocity() end

---*Client only*  
---Returns client public data from a harvestable.  
---@return table # The client public data.
function Harvestable:getClientPublicData() end

---Returns the color of the harvestable.  
---@return Color # The color.
function Harvestable:getColor() end

---Get the script data from a harvestable.  
---@return table # data			The script data.
function Harvestable:getData() end

---Returns the id of a harvestable.  
---@return integer # The harvestable id.
function Harvestable:getId() end

---Gets the initial hash of a kinematic. The initial hash identifies the kinematic by its initial world position, uuid and world id.  
---This can be used to match kinematics spawned from the same entity in a tile even though each loaded kinematic is technically a different object.  
---@return number # The initial hash. Returns 0 if the harvestable is not kinematic.
function Harvestable:getInitialHash() end

---Returns the axis aligned local space bounds of the harvestable.  
---@return Vec3,Vec3 # The min and max bounds.
function Harvestable:getLocalAabb() end

---Returns the mass of a harvestable. The mass scales with the harvestable's scale.  
---@return number # The mass.
function Harvestable:getMass() end

---Returns the material name of a harvestable.  
---@return string # The name of the material.
function Harvestable:getMaterial() end

---Returns the material id of a harvestable.  
---@return integer # The id of the material.
function Harvestable:getMaterialId() end

---Returns the name of a harvestable.  
---@return string # The harvestable name.
function Harvestable:getName() end

---*Client only*  
---Returns the pose weight of the pose in the given index.  
---@param index integer # The index.
---@return number # The pose weight.
function Harvestable:getPoseWeight(index) end

---Returns the world coordinates of a harvestable.  
---@return Vec3 # The position.
function Harvestable:getPosition() end

---*Server only*  
---Returns (server) public data from a harvestable.  
---@return table # The public data.
function Harvestable:getPublicData() end

---Returns the quaternion rotation of a harvestable.  
---@return Quat # The rotation.
function Harvestable:getRotation() end

---Returns the scale of the harvestable.  
---@return Vec3 # The scale.
function Harvestable:getScale() end

---Returns the [Character] that is seated in the kinematic.  
---@return Character # The character.
function Harvestable:getSeatCharacter() end

---Returns the type of a harvestable.  
---@return string # The harvestable's type.
function Harvestable:getType() end

---Returns the [Uuid] of the harvestable.  
---@return Uuid # The uuid.
function Harvestable:getUuid() end

---*Client only*  
---Returns the index of the current UV animation frame  
---@return integer # The uv frame.
function Harvestable:getUvFrameIndex() end

---Returns the velocity of the harvestable.  
---@return Vec3 # The velocity.
function Harvestable:getVelocity() end

---Returns the world a harvestable exists in.  
---@return World # The world the harvestable exists in.
function Harvestable:getWorld() end

---Returns true if kinematic has a seat component.  
---@return boolean # The result.
function Harvestable:hasSeat() end

---Check if a kinematic comes from a cell or is created from a script.  
---@return boolean # True if it is a kinematic from a cell, false if it is not. Nil if it is not a kinematic.
function Harvestable:isCellKinematic() end

---Check if a harvestable is kinematic  
---@return boolean # Return true if the harvestable is kinematic.
function Harvestable:isKinematic() end

---*Client only*  
---Set the visibility of all submeshes  
---@param visible boolean # True if the submeshes should be visible.
function Harvestable:setAllSubMeshVisible(visible) end

---*Client only*  
---Sets client public data on a harvestable.  
---@param data table # The client public data.
function Harvestable:setClientPublicData(data) end

---*Client only*  
---Sets the color of the harvestable.  
---@param color Color # The color.
function Harvestable:setColor(color) end

---*Server only*  
---Sets param data for a harvestable.  
---@param data any # The param data.
function Harvestable:setParams(data) end

---*Client only*  
---Set the pose weight of the pose in the given index.  
---@param index integer # The index.
---@param value number # The pose weight.
function Harvestable:setPoseWeight(index, value) end

---Set the world coordinates of a harvestable. Can only be used on kinematic harvestables.  
---Can be used on both the client and the server, but using it on the server only affects the host.
---@param position Vec3 # The position.
function Harvestable:setPosition(position) end

---*Server only*  
---Sets (server) public data on a harvestable.  
---@param data table # The public data.
function Harvestable:setPublicData(data) end

---Set the quaternion rotation of a harvestable. Can only be used on kinematic harvestables.  
---Can be used on both the client and the server, but using it on the server only affects the host.
---@param rotation Quat # The rotation.
function Harvestable:setRotation(rotation) end

---Requests to seat a [Character] in the kinematic.  
---@param character Character # The character.
function Harvestable:setSeatCharacter(character) end

---*Client only*  
---Set the visibility of a submesh  
---@param name string # Name of the submesh.
---@param visible boolean # True if the submesh should be visible.
function Harvestable:setSubMeshVisible(name, visible) end

---*Client only*  
---Sets the UV animation frame with the given index.  
---@param index integer # The index.
function Harvestable:setUvFrameIndex(index) end

---Transforms a direction in the world into a local direction of the harvestable  
---@param direction Vec3 # The world direction.
---@return Vec3 # The local direction.
function Harvestable:transformDirection(direction) end

---Transform a local point to world space.  
---```
---local worldPos = self.harvestable:transformLocalPoint( localPos )
---```
---@param vector Vec3 # The local point.
---@return Vec3 # The world point.
function Harvestable:transformLocalPoint(vector) end

---Transform a world point to the local harvestable transform.  
---```
---local localPos = self.harvestable:transformPoint( worldPos )
---```
---@param vector Vec3 # The world point.
---@return Vec3 # The local point.
function Harvestable:transformPoint(vector) end


---@class Lift
---A userdata object representing a <strong>lift</strong> in the game.  
---@operator eq(Lift): boolean
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
---@return integer # The lift's id.
function Lift:getId() end

---Returns the level of a lift.  
---@return integer # The lift's level.
function Lift:getLevel() end

---Returns the world position of a lift.  
---@return Vec3 # The lift's world position.
function Lift:getWorldPosition() end

---Returns whether there's a body on the lift.  
---@return boolean # Returns true if the lift has a body.
function Lift:hasBodies() end


---@class ScriptableObject
---A userdata object representing a <strong>scriptable object</strong>.  
---@operator eq(ScriptableObject): boolean
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
---Returns the world of a scriptable object.  
---@type World
ScriptableObject.world = {}

---*Server only*  
---Destroys a scriptable Object.  
function ScriptableObject:destroy() end

---*Client only*  
---Returns client public data from a scriptableObject.  
---@return table # The client public data.
function ScriptableObject:getClientPublicData() end

---Returns json data from a scriptableObject.  
---@return table # The json data.
function ScriptableObject:getData() end

---Returns the id of a scriptable object.  
---@return number # id					The scriptableObject id.
function ScriptableObject:getId() end

---*Server only*  
---Returns (server) public data from a scriptableObject.  
---@return table # The public data.
function ScriptableObject:getPublicData() end

---Returns the world of a scriptable object.  
---@return World # world				The world.
function ScriptableObject:getWorld() end

---*Client only*  
---Sets client public data on a scriptableObject.  
---@param data table # The client public data.
function ScriptableObject:setClientPublicData(data) end

---*Server only*  
---Sets (server) public data on a scriptableObject.  
---@param data table # The public data.
function ScriptableObject:setPublicData(data) end


---@class ClientScriptableObject
---A userdata object representing a <strong>scriptable object</strong>.  
---@operator eq(ClientScriptableObject): boolean
local ClientScriptableObject = {}

---**Get**:
---*Client only*  
---Returns public data from a client scriptable object.  
---**Set**:
---*Client only*  
---Sets public data on a client scriptable object.  
---@type table
ClientScriptableObject.clientPublicData = {}

---**Get**:
---*Client only*  
---Returns the id of a client scriptable object.  
---@type number
ClientScriptableObject.id = {}

---**Get**:
---*Client only*  
---Returns the worldId of a client scriptable object.  
---@type World
ClientScriptableObject.world = {}

---*Client only*  
---Destroys a client scriptable Object.  
function ClientScriptableObject:destroy() end

---*Client only*  
---Returns public data from a client scriptable object.  
---@return table # The client public data.
function ClientScriptableObject:getClientPublicData() end

---*Client only*  
---Returns json data from a client scriptableObject.  
---@return table # The json data.
function ClientScriptableObject:getData() end

---*Client only*  
---Returns the id of a client scriptable object.  
---@return number # id						The clientScriptableObject id.
function ClientScriptableObject:getId() end

---*Client only*  
---Returns the worldId of a client scriptable object.  
---@return World # world				The world.
function ClientScriptableObject:getWorld() end

---*Client only*  
---Sets public data on a client scriptable object.  
---@param data table # The client public data.
function ClientScriptableObject:setClientPublicData(data) end


---@class BuilderGuide
---A userdata object representing a <strong>builder guide</strong>.  
---@operator eq(BuilderGuide): boolean
local BuilderGuide = {}

---**Get**:
---Returns the id of a guide.  
---@type integer
BuilderGuide.id = {}

---Destroys a guide.  
function BuilderGuide:destroy() end

---Returns the stage index of a guide.  
---@return integer # The stage index.
function BuilderGuide:getCurrentStageIndex() end

---@class BuilderGuideErrors
---@field blocks number
---@field joints number
---@field parts number
---@field connections number
---@field connectionsReversed number

---Returns error information of the builder guide.  
---@return BuilderGuideErrors # Table of errors { blocks = number, joints = number, parts = number, connections = number, connectionsReversed = number },
function BuilderGuide:getErrorInfo() end

---Returns the id of a guide.  
---@return integer # The guide's id.
function BuilderGuide:getId() end

---@class BuilderGuideStageInfo
---@field blocksLeft number
---@field jointsLeft number
---@field partsLeft number
---@field connectionsLeft number

---Returns information about the current stage.  
---@return BuilderGuideStageInfo # Table of stage info { blocksLeft = number, jointsLeft = number, partsLeft = number, connectionsLeft = number }, 
function BuilderGuide:getStageInfo() end

---Returns the completion status of a guide.  
---@return boolean # True if the guide is completed.
function BuilderGuide:isComplete() end

---Update the state of a guide. Should be called whenever the root [Shape] of the builder guide has changed.  
function BuilderGuide:update() end


---@class CullSphereGroup
---A userdata object representing a <strong>cull sphere group</strong>.  
---@operator eq(CullSphereGroup): boolean
local CullSphereGroup = {}

---**Get**:
---Returns the id of a sphere group.  
---@type integer
CullSphereGroup.id = {}

---Adds a sphere to the sphere group, duplicate ids are ignored.  
---@param id integer # Sphere id.
---@param position Vec3 # Sphere position.
---@param radius number # Sphere radius.
function CullSphereGroup:addSphere(id, position, radius) end

---Queries the change in overlapping spheres since the last call to getDelta.  
---@param position Vec3 # Position to query sphere.
---@param innerRadius number # Radius for inner sphere.
---@param outerRadius number # Radius for outer sphere.
---@return number[], number[] # Arrays of removed, added ids {integer, ...}.
function CullSphereGroup:getDelta(position, innerRadius, outerRadius) end

---Query for overlapping spheres.  
---@param position Vec3 # Position to query sphere.
---@param radius number # Radius for query sphere.
function CullSphereGroup:getOverlaps(position, radius) end

---Query all currently active spheres and leave them.  
---@return number[] # An array of previously active ids {integer, ...}.
function CullSphereGroup:leave() end

---Removes a sphere from the sphere group.  
---@param id integer # Sphere id.
function CullSphereGroup:removeSphere(id) end


---@class JsonGui
---@operator eq(JsonGui): boolean
local JsonGui = {}

---**Get**:
---Returns the id of a gui.  
---@type integer
JsonGui.id = {}

---Clears the close callback so it will not be called when the gui is closed  
function JsonGui:clearOnCloseCallback() end

---Close a JsonGui  
function JsonGui:close() end

---Returns a JsonWidget. Nil if no widget was found with the name  
---@param widgetName string # The name of the widget.
---@return JsonWidget # widget			The found widget in the JsonGui.
function JsonGui:getWidget(widgetName) end

---Get the absolute position of a named widget in 720 coords  
---@param widgetName string # The name of the widget.
---@return number, number # Left, Top
function JsonGui:getWidgetAbsolutePosition(widgetName) end

---Check if a JsonGui is active  
---@return boolean # Is the gui active?
function JsonGui:isActive() end

---Gets the visibility of the gui.  
---@return boolean # hidden			True if the gui is hidden.
function JsonGui:isHidden() end

---Renders the DOM  
---@param DOM table # A table representing the gui elements to show
---@param forceProperties? boolean # Force update widget properties (optional). (Defaults to false)
function JsonGui:render(DOM, forceProperties) end

---Sets desired visibility of the gui.  
---@param hidden boolean # True if the gui should be hidden.
function JsonGui:setHidden(hidden) end


---@class JsonWidget
---@operator eq(JsonWidget): boolean
local JsonWidget = {}

---**Get**:
---*Client only*  
---Get the name of the jsonWidget.  
---@type string
JsonWidget.name = {}

---*Client only*  
---Gets an effect from a widget.  
---@param name string # The name of the effect on the json widget to get.
---@return Effect # The effect.
function JsonWidget:getEffect(name) end

---*Client only*  
---Gets a string associated with the given key from a json widget.  
---@param key string # The key connected to the value.
---@return string		value			The value associated with the key.
function JsonWidget:getUserString(key) end

---*Client only*  
---Returns if a named effect is done or not.  
---@param name string # The name of the effect.
---@return boolean # True if the effect is done, false otherwise.
function JsonWidget:isEffectDone(name) end

---*Client only*  
---Returns if a named effect is playing or not.  
---@param name string # The name of the effect.
---@return boolean # True if the effect is playing, false otherwise.
function JsonWidget:isEffectPlaying(name) end

---*Client only*  
---Sets the position of the widget. This will not change the json data position.  
---@param x integer # The x position.
---@param y integer # The y position.
function JsonWidget:setPosition(x, y) end

---*Client only*  
---Sets the item preview uuid for a json widget. Passing nil clears the preview.  
---@param uuid uuid # The item uuid.
function JsonWidget:setPreview(uuid) end

---*Client only*  
---Sets the blueprint preview path for a json widget. Passing nil clears the preview.  
---@param string string # The blueprint path.
function JsonWidget:setPreview(string) end

---*Client only*  
function JsonWidget:setPreview() end

---*Client only*  
---Sets a custom string on a json widget that can be fetched using the key.  
---@param key string # The key connected to the value.
---@param value string # The value being written onto the widget.
function JsonWidget:setUserString(key, value) end

---*Client only*  
---Sets the visibility of a widget.  
---@param stopImmediate boolean # The widgets new visibility state.
function JsonWidget:setVisible(stopImmediate) end

---*Client only*  
---Starts the effect applied to the widget.  
---@param name string # The name of the effect on the json widget to start.
function JsonWidget:startEffect(name) end

---*Client only*  
---Stops the effect applied to the widget.  
---@param name string # The name of the effect to stop.
---@param stopImmediate? boolean # If the effect should stop immediately. (Optional) (Defaults to false)
function JsonWidget:stopEffect(name, stopImmediate) end


---@class Effect
---A userdata object representing an <strong>effect</strong>.  
---@operator eq(Effect): boolean
local Effect = {}

---**Get**:
---Returns the id of an effect.  
---@type integer
Effect.id = {}

---*Client only*  
---@deprecated use [Effect.bindEventClientCallback] instead.
---Bind a lua callback to be triggered by the effect.  
---@param methodName string # The name of the callback method being bound. Example: MyClass.methodName( self, event, params )
---@param params? any # Parameter object passed to the callback. (Optional)
---@param reference? table # Table to receive the callback. (Optional)
function Effect:bindEventCallback(methodName, params, reference) end

---*Client only*  
---Bind a lua client callback script reference to be used by the effect.  
---@param params? any # Parameter object passed to the callback. (Optional)
---@param reference? table # Table to receive the callback. (Optional)
function Effect:bindEventClientCallback(params, reference) end

---*Client only*  
---Bind a lua server callback script reference to be used by the effect. Host only.  
---@param params? any # Parameter object passed to the callback. (Optional)
---@param reference? table # Table to receive the callback. (Optional)
function Effect:bindEventServerCallback(params, reference) end

---*Client only*  
---Clear the effect lua client callback script reference.  
function Effect:clearClientEventCallback() end

---*Client only*  
---@deprecated use [Effect.clearClientEventCallback] together with [Effect.bindEventClientCallback] instead.
---Clear all lua effect callbacks.  
function Effect:clearEventCallbacks() end

---*Client only*  
---Clear the effect lua server callback script reference.  
function Effect:clearServerEventCallback() end

---Stops and destroys the effect.  
function Effect:destroy() end

---*Client only*  
---Detaches the effect from its host object.  
function Effect:detach() end

---@class EffectCameraData
---@field hasBlendIn boolean
---@field hasBlendOut boolean
---@field active boolean
---@field cameraPosition Vec3]
---@field cameraRotation Quat
---@field cameraFov number

---*Client only*  
---Get a table of camera effect data.  
---Returns nil if the effect is not a camera effect.  
---@return EffectCameraData # The settings. { hasBlendIn = boolean, hasBlendOut = boolean, active = boolean, cameraPosition = [Vec3], cameraRotation = [Quat], cameraFov = number }
function Effect:getCameraData() end

---Returns the id of an effect.  
---@return integer # The effect's id.
function Effect:getId() end

---*Client only*  
---Gets the current world position  
---@return Vec3	position The world position.
function Effect:getWorldPosition() end

---*Client only*  
---Check if the effect has an active camera effect.  
---@return boolean # Is active.
function Effect:hasActiveCamera() end

---*Client only*  
---Returns whether the effect has a host.  
---@return boolean # Whether the effect is hosted.
function Effect:hasHost() end

---*Client only*  
---Returns whether the effect is break sustained.  
---@return boolean # Whether effect is break sustained.
function Effect:isBreakSustaining() end

---*Client only*  
---Returns whether the effect is done, meaning that all effect instances have finished.  
---@return boolean # Whether effect is done.
function Effect:isDone() end

---*Client only*  
---Returns whether the effect is currently playing.  
---@return boolean # Whether effect is playing.
function Effect:isPlaying() end

---*Client only*  
---Sets an effect to start playing and repeating automatically.  
---@param autoplay boolean # Autoplay enabled.
---@param autoPlayOnce? boolean # If set the effect will not loop when autoplaying. (Defaults to false) (Optional)
---@param resetPlayOnce? boolean # Will reset the autoPlayOnce condition, allowing the effect to play again if it already has since earlier. (Defaults to false) (Optional)
function Effect:setAutoPlay(autoplay, autoPlayOnce, resetPlayOnce) end

---*Client only*  
---Detaches the effect from its host object when the host disappears.  
---@param detach boolean # If the effect should automatically detach from the host or not.
function Effect:setDetachOnHostDestroy(detach) end

---*Client only*  
---Sets a [Interactable] as host for an effect.  
---@param Interactable Interactable # The Interactable the effect is attached to.
---@param boneName? string # The bone name to attach effect to. (Defaults to not attached to a bone) (Optional)
function Effect:setHost(Interactable, boneName) end

---*Client only*  
---Sets a [Shape] as host for an effect.  
---@param shape Shape # The shape the effect is attached to.
---@param boneName? string # The bone name to attach effect to. (Defaults to not attached to a bone) (Optional)
function Effect:setHost(shape, boneName) end

---*Client only*  
---Sets a [Character] as host for an effect.  
---@param Character Character # The Character the effect is attached to.
---@param boneName? string # The bone name to attach effect to. (Defaults to not attached to a bone) (Optional)
function Effect:setHost(Character, boneName) end

---*Client only*  
---Sets a [Harvestable] as host for an effect.  
---@param pHarvestable Harvestable # The pHarvestable the effect is attached to.
---@param boneName? string # The bone name to attach effect to. (Defaults to not attached to a bone) (Optional)
function Effect:setHost(pHarvestable, boneName) end

---*Client only*  
---Sets a rotation axis which hosted effects will ignore.  
---@param axis integer # The rotation axis.
function Effect:setHostAxisIgnore(axis) end

---*Client only*  
---Offsets the position of the effect relatively to the host.  
---**Note:**
---*Does not work if the effect was created without a host.*
---@param offsetPosition Vec3 # The relative offset position.
function Effect:setOffsetPosition(offsetPosition) end

---*Client only*  
---Offsets the orientation of the effect relatively to the host.  
---**Note:**
---*Does not work if the effect was created without a host.*
---@param offsetRotation Quat # The relative offset rotation.
function Effect:setOffsetRotation(offsetRotation) end

---*Client only*  
---Sets a named parameter value on the effect.  
---@param name string # The name.
---@param value any # The effect parameter value.
function Effect:setParameter(name, value) end

---*Client only*  
---Sets the position of an effect.  
---**Note:**
---*Does not work if the effect has a host.*
---@param position Vec3 # The position.
function Effect:setPosition(position) end

---*Client only*  
---Sets the orientation of an effect using a quaternion.  
---**Note:**
---*Does not work if the effect has a host.*
---@param rotation Quat # The rotation.
function Effect:setRotation(rotation) end

---*Client only*  
---Sets the scale of an effect.  
---**Note:**
---*Only applies to effect renderables.*
---@param scale Vec3 # The scale.
function Effect:setScale(scale) end


---The effect will:  
---* Start when your distance is less than the startDistance.  
---* End when your distance is over the stopDistance.  
---@param startDistance number Distance at which to start the effect. Must be < than stopDistance and over 0.
---@param stopDistance number Distance at which to stop the effect. Must be > than startDistance and over 0. 
function Effect:setStartStopDistance(startDistance, stopDistance) end

---*Client only*  
---Sets an effect to be active during specific period of the day / night cycle.  
---@param enabled boolean # Time of day enabled.
---@param startTime number # Start normalized time of day.
---@param endTime number # End normalized time of day.
---@param inversed boolean # If true, period between start-end becomes inactive time.
function Effect:setTimeOfDay(enabled, startTime, endTime, inversed) end

---*Client only*  
---Sets the velocity of an effect. The effect will move along at the set velocity until it receives a new position.  
---**Note:**
---*Does not work if the effect has a host.*
---@param velocity Vec3 # The velocity.
function Effect:setVelocity(velocity) end

---*Client only*  
---Sets the world for an effect.  
---@param world World # The world. Defaults to world from script context. (optional)
function Effect:setWorld(world) end

---*Client only*  
---Sets the effect's world to UWorldId_Any, used to play global sounds through the dialog manager.  
function Effect:setWorldAny() end

---*Client only*  
---Starts playing an effect.  
---@param startTime? number # The start time of the effect. Only applies to audio and cinematic effects. (Defaults to 0)
function Effect:start(startTime) end

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
---@return any # The data stored.
function Storage:load() end

---*Server only*  
---Saves any Lua data into the storage object.  
---The data will remain stored after closing the world, and is retrieved using [Storage.load, load].  
---@param data any # The data to be stored.
function Storage:save(data) end


---@class Unit
---A userdata object representing a <strong>unit</strong> in the game.  
---@operator eq(Unit): boolean
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
---Creates and stores a container in the given index inside the unit.  
---@param index integer # The index of the container [0-15].
---@param size integer # The number of slots in the container.
---@param stackSize? integer # The stack size. Defaults to maximum possible stack size(65535).
---@return Container # The created container.
function Unit:addContainer(index, size, stackSize) end

---*Server only*  
---Creates a Ai State from a name (See [AiState])  
---@param stateName string # Name of predefined ai state.
---@return AiState state The ai state.
function Unit:createState(stateName) end

---*Server only*  
---Destroy a unit  
function Unit:destroy() end

---*Server only*  
---Returns the character associated with a unit.  
---@return Character # The associated character.
function Unit:getCharacter() end

---Returns the container stored in the given index inside the unit.  
---@param index? integer # The index of the container (default: 0).
---@return Container # The container.
function Unit:getContainer(index) end

---*Server only*  
---Gets the current facing direction of a unit.  
---@return Vec3 # The units facing direction.
function Unit:getCurrentFacingDirection() end

---*Server only*  
---Gets the current movement direction of a unit.  
---@return Vec3 # The units movement direction.
function Unit:getCurrentMovementDirection() end

---*Server only*  
---Returns the id of a unit.  
---@return integer # The unit's id.
function Unit:getId() end

---*Server only*  
---Returns (server) public data from a unit.  
---@return table # The public data.
function Unit:getPublicData() end

---*Server only*  
---Removes the container stored in the given index inside the unit.  
---@param index integer # The index of the container.
function Unit:removeContainer(index) end

---*Server only*  
---Sends a event to the associated character of the unit.  
---@param event string # The event name.
function Unit:sendCharacterEvent(event) end

---*Server only*  
---Sets the facing direction for a unit  
---@param direction Vec3 # The desired facing direction.
function Unit:setFacingDirection(direction) end

---*Server only*  
---Notifies a unit that it heard a sound  
---@param noiseScale number # The noise amount.
function Unit:setHearingData(noiseScale) end

---*Server only*  
---Sets the movement direction for a unit  
---@param direction Vec3 # The desired movement direction.
function Unit:setMovementDirection(direction) end

---*Server only*  
---Sets the movment type for a unit  
---moveType can be "stand", "walk", "sprint" or "crouch"  
---@param moveTypeName string # The movement type to set
function Unit:setMovementType(moveTypeName) end

---*Server only*  
---Sets (server) public data on a unit.  
---@param data table # The public data.
function Unit:setPublicData(data) end

---*Server only*  
---Set a unit to crouch  
---@param wantCrouch boolean # True if the unit should crouch
function Unit:setWantsCrouch(wantCrouch) end

---*Server only*  
---Set a unit to jump  
---@param wantJump boolean # True if the unit should jump
function Unit:setWantsJump(wantJump) end

---*Server only*  
---Sets the whisker data for obstacle avoidance  
---@param whiskerCount integer # The whiskerCount.
---@param maxAngle number # The maxAngle.
---@param startLength number # The startLength.
---@param endLength number # The endLength.
function Unit:setWhiskerData(whiskerCount, maxAngle, startLength, endLength) end


---@class AiState
---A userdata object representing an <strong>AI state</strong> belonging to a [Unit].  
---@operator eq(AiState): boolean
local AiState = {}

---**Get**:
---*Server only*
---Gets the debug name of the state.  
---**Set**:
---*Server only*  
---Sets the debug name of the state.  
---@type string
AiState.debugName = {}

---**Get**:
---*Server only*
---Gets the timeout of the state.  
---**Set**:
---*Server only*  
---Sets the timeout of the state.  
---@type number
AiState.timeout = {}

---**Get**:
---*Server only*
---Gets the tolerance of the state.  
---**Set**:
---*Server only*  
---Sets the tolerance of the state.  
---@type number
AiState.tolerance = {}

---**Get**:
---*Server only*
---Gets whether the state has avoidance.  
---**Set**:
---*Server only*  
---Sets whether the state has avoidance.  
---@type boolean
AiState.avoidance = {}

---**Get**:
---*Server only*
---Gets the movement type of the state.  
---**Set**:
---*Server only*  
---Sets the movement type of the state.  
---@type string
AiState.movementType = {}

---**Get**:
---*Server only*
---Gets the melee type of the state.  
---**Set**:
---*Server only*  
---Sets the melee type of the state.  
---@type Uuid
AiState.meleeType = {}

---**Get**:
---*Server only*
---Gets the event name of the state.  
---**Set**:
---*Server only*  
---Sets the event name of the state.  
---@type string
AiState.event = {}

---**Get**:
---*Server only*
---Gets the damage of the state.  
---**Set**:
---*Server only*  
---Sets the damage of the state.  
---@type number
AiState.damage = {}

---**Get**:
---*Server only*
---Gets the attack range of the state.  
---**Set**:
---*Server only*  
---Sets the attack range of the state.  
---@type number
AiState.attackRange = {}

---**Get**:
---*Server only*
---Gets the animation cooldown of the state.  
---**Set**:
---*Server only*  
---Sets the animation cooldown of the state.  
---@type number
AiState.animationCooldown = {}

---**Get**:
---*Server only*
---Gets the attack cooldown of the state.  
---**Set**:
---*Server only*  
---Sets the attack cooldown of the state.  
---@type number
AiState.attackCooldown = {}

---**Get**:
---*Server only*
---Gets the global cooldown of the state.  
---**Set**:
---*Server only*  
---Sets the global cooldown of the state.  
---@type number
AiState.globalCooldown = {}

---**Get**:
---*Server only*
---Gets the attack delay of the state.  
---**Set**:
---*Server only*  
---Sets the attack delay of the state.  
---@type number
AiState.attackDelay = {}

---**Get**:
---*Server only*
---Gets the power of the state.  
---**Set**:
---*Server only*  
---Sets the power of the state.  
---@type number
AiState.power = {}

---**Get**:
---*Server only*
---Gets the movement angle threshold of the state.  
---**Set**:
---*Server only*  
---Sets the movement angle threshold of the state.  
---@type number
AiState.movementAngleThreshold = {}

---**Get**:
---*Server only*
---Gets the maximum flee time of the state.  
---**Set**:
---*Server only*  
---Sets the maximum flee time of the state.  
---@type number
AiState.maxFleeTime = {}

---**Get**:
---*Server only*
---Gets the maximum deviation of the state.  
---**Set**:
---*Server only*  
---Sets the maximum deviation of the state.  
---@type number
AiState.maxDeviation = {}

---**Get**:
---*Server only*
---Gets the time of the state.  
---**Set**:
---*Server only*  
---Sets the time of the state.  
---@type number
AiState.time = {}

---**Get**:
---*Server only*
---Gets whether the state is interruptible.  
---**Set**:
---*Server only*  
---Sets whether the state is interruptible.  
---@type boolean
AiState.interruptible = {}

---**Get**:
---*Server only*
---Gets the name of the state.  
---**Set**:
---*Server only*  
---Sets the name of the state.  
---@type string
AiState.name = {}

---**Get**:
---*Server only*
---Gets the spread angle of the state.  
---**Set**:
---*Server only*  
---Sets the spread angle of the state.  
---@type number
AiState.spreadAngle = {}

---**Get**:
---*Server only*
---Gets the cooldown of the state.  
---**Set**:
---*Server only*  
---Sets the cooldown of the state.  
---@type number
AiState.cooldown = {}

---**Get**:
---*Server only*
---Gets the aim time of the state.  
---**Set**:
---*Server only*  
---Sets the aim time of the state.  
---@type number
AiState.aimTime = {}

---**Get**:
---*Server only*
---Gets the projectile of the state.  
---**Set**:
---*Server only*  
---Sets the projectile of the state.  
---@type Uuid
AiState.projectile = {}

---**Get**:
---*Server only*
---Gets the offset of the state.  
---**Set**:
---*Server only*  
---Sets the offset of the state.  
---@type Vec3
AiState.offset = {}

---**Get**:
---*Server only*
---Gets the velocity of the state.  
---**Set**:
---*Server only*  
---Sets the velocity of the state.  
---@type number
AiState.velocity = {}

---**Get**:
---*Server only*
---Gets whether the states prefers high angle shots.  
---**Set**:
---*Server only*  
---Setsthe whether the state prefers high angle shots.  
---@type boolean
AiState.preferHighAngle = {}

---**Get**:
---*Server only*
---Gets the delay of the state.  
---**Set**:
---*Server only*  
---Sets the delay of the state.  
---@type number
AiState.delay = {}

---**Get**:
---*Server only*
---Gets the tether position of the state.  
---**Set**:
---*Server only*  
---Sets the tether position of the state.  
---@type Vec3
AiState.tetherPosition = {}

---**Get**:
---*Server only*
---Gets the roam center offset of the state.  
---**Set**:
---*Server only*  
---Sets the roam center offset of the state.  
---@type number
AiState.roamCenterOffset = {}

---**Get**:
---*Server only*
---Gets the minimum random event cooldown  of the state.  
---**Set**:
---*Server only*  
---Sets the minimum random event cooldown  of the state.  
---@type number
AiState.randomEventCooldownMin = {}

---**Get**:
---*Server only*
---Gets the maximum random event cooldown  of the state.  
---**Set**:
---*Server only*  
---Sets the maximum random event cooldown  of the state.  
---@type number
AiState.randomEventCooldownMax = {}

---@class AiStateEvent
---@field name string
---@field time number
---@field interruptible boolean
---@field chance number

---**Get**:
---*Server only*
---Gets the random events of the state.  
---**Set**:
---*Server only*  
---Sets the random events of the state.  
---@type AiStateEvent[]
AiState.randomEvents = {}


---*Server only*  
---Returns the state's facing direction.  
---@return Vec3 # The direction.
function AiState:getFacingDirection() end

---*Server only*  
---Returns the state's movement direction.  
---@return Vec3 # The direction.
function AiState:getMovementDirection() end

---*Server only*  
---Returns a string describing the state's movement type.  
---Movement type can be "stand", "walk", "sprint" or "crouch".  
---@return string # The movement type.
function AiState:getMovementType() end

---*Server only*  
---Check if the state wants to crouch.  
---@return boolean # Returns true when the state wants to crouch.
function AiState:getWantsCrouch() end

---*Server only*  
---Check if the state wants to jump.  
---@return boolean # Returns true when the state wants to jump.
function AiState:getWantsJump() end

---*Server only*  
---Checks if the AI state is done.  
---Returns true when the state is done, and a string describing the state's current situation.  
---Can be used to determine if another state is allowed to be started.  
---@return boolean, string # Returns true when done, and a string description.
function AiState:isDone() end

---*Server only*  
---Updates the state by adding delta time progression.  
---Should be called once every game tick while the state is active.  
---@param deltaTime number # The delta time.
function AiState:onFixedUpdate(deltaTime) end

---*Server only*  
---Updates the state by adding delta time progression.  
---Should be called once every unit update, by the unit that owns the state, while the state is active.  
---@param deltaTime number # The delta time.
function AiState:onUnitUpdate(deltaTime) end

---*Server only*  
---Starts the state.  
function AiState:start() end

---*Server only*  
---Stops the state.  
function AiState:stop() end


---@class PathNode
---@field toNode PathNode
---A userdata object representing a PathNode in the game.  
---@operator eq(PathNode): boolean
local PathNode = {}

---*Server only*  
---Create a PathNode connection  
---@param to PathNode # PathNode to create connection to
function PathNode:connect(to) end

---*Server only*  
---Destroys a path node.  
function PathNode:destroy() end

---*Server only*  
---Get the world position of a path node  
---@return Vec3 # World position
function PathNode:getPosition() end


---@class Tool
---A userdata object representing a <strong>tool</strong> in the game.  
local Tool = {}

---**Get**:
---Returns the id of a tool.  
---@type integer
Tool.id = {}

---**Get**:
---Returns the tool type uuid.  
---@type Uuid
Tool.uuid = {}

---*Client only*  
---Returns general information for a third person view animation.  
---@param name string The name.
---@return AnimationInfo # The animation information
function Tool:getAnimationInfo(name) end

---*Client only*  
---Get the current weights for the tool's local camera settings.  
---@return number, number # The third-person weight and the first-person weight
function Tool:getCameraWeights() end

---*Client only*  
---Returns the direction of where the player is viewing or aiming.  
---@return Vec3 # The player's view direction.
function Tool:getDirection() end

---*Client only*  
---Returns general information for a first person view animation.  
---@param name string # The name.
---@return AnimationInfo # A table containing "name", "duration" and "looping".
function Tool:getFpAnimationInfo(name) end

---*Client only*  
---Returns the local or world direction for a bone in the first person view animation skeleton.  
---@param jointName string # The joint name.
---@param convertToWorldSpace? boolean # Whether to convert the position to world space. (Defaults to true)
---@return Vec3 # The joint direction.
function Tool:getFpBoneDir(jointName, convertToWorldSpace) end

---*Client only*  
---Returns the local or world position for a bone in the first person view animation skeleton.  
---@param jointName string # The joint name.
---@param convertToWorldSpace? boolean # Whether to convert the position to world space. (Defaults to true)
---@return Vec3 # The joint position.
function Tool:getFpBonePos(jointName, convertToWorldSpace) end

---*Client only*  
---Returns the local or world rotation for a bone in the first person view animation skeleton.  
---@param jointName string # The joint name.
---@param convertToWorldSpace? boolean # Whether to convert the position to world space. (Defaults to true)
---@return Quat # The joint rotation.
function Tool:getFpBoneRot(jointName, convertToWorldSpace) end

---Returns the id of a tool.  
---@return integer # The tool's id.
function Tool:getId() end

---*Client only*  
---Returns the fraction of the player's movement speed in proportion to its maximum. This is affected by sprinting, crouching, blocking, aiming, etc.  
---sprinting	1.0  
---walking	0.5  
---crouching	0.375  
---aiming	0.3125  
---@return number # The player's movement speed fraction.
function Tool:getMovementSpeedFraction() end

---*Client only*  
---Returns the movement velocity of the player.  
---@return Vec3 # The player's velocity.
function Tool:getMovementVelocity() end

---Returns the player that owns the tool.  
---@return Player # The tool's owner.
function Tool:getOwner() end

---*Client only*  
---Returns the world position of the player.  
---@return Vec3 # The player's world position.
function Tool:getPosition() end

---*Client only*  
---Returns the relative movement direction of the player. This is the direction the player wants to move based on movement input.  
---@return Vec3 # The player's relative movement direction.
function Tool:getRelativeMoveDirection() end

---*Client only*  
---Returns the smooth direction of where the player is viewing or aiming.  
---@return Vec3 # The player's smooth view direction.
function Tool:getSmoothDirection() end

---*Client only*  
---Returns the world direction for a bone in the third person view animation skeleton.  
---@param jointName string # The joint name.
---@return Vec3 # The joint direction.
function Tool:getTpBoneDir(jointName) end

---*Client only*  
---Returns the world position for a bone in the third person view animation skeleton.  
---@param jointName string # The joint name.
---@return Vec3 # The joint position.
function Tool:getTpBonePos(jointName) end

---*Client only*  
---Returns the world rotations for a bone in the third person view animation skeleton.  
---@param jointName string # The joint name.
---@return Quat # The joint rotation.
function Tool:getTpBoneRot(jointName) end

---Returns the tool type uuid.  
---@return Uuid # The tool's uuid.
function Tool:getUuid() end

---*Client only*  
---Returns whether the player is currently crouching.  
---@return boolean # Whether the player is crouching.
function Tool:isCrouching() end

---*Client only*  
---Returns whether the tool is equipped or not.  
---@return boolean # whether the tool is equipped or not.
function Tool:isEquipped() end

---*Client only*  
---Returns whether the player is in first person view where the viewpoint is rendered from the player's perspective. Otherwise, the player is in third person view where the camera is behind the player.  
---@return boolean # Whether the player is in first person view.
function Tool:isInFirstPersonView() end

---*Client only*  
---Returns whether the player holding the tool is the as [sm.localPlayer].  
---@return boolean # Whether the player is the local player.
function Tool:isLocal() end

---*Client only*  
---Returns whether the player is currently standing on the ground.  
---@return boolean # Whether the player is on the ground.
function Tool:isOnGround() end

---*Client only*  
---Returns whether the player is currently sprinting.  
---@return boolean # Whether the player is sprinting.
function Tool:isSprinting() end

---*Client only*  
---Sets whether the player is unable to sprint. Sprinting is normally blocked when the player is attacking, blocking, aiming, etc.  
---@param block boolean # Whether the player's sprinting is blocked.
function Tool:setBlockSprint(block) end

---*Client only*  
---Sets the opacity of the crosshair. An alpha value of 0 makes the crosshair transparent.  
---@param alpha number # The alpha value for the crosshair.
function Tool:setCrossHairAlpha(alpha) end

---*Client only*  
---Sets the color of the crosshair.   
---@param color Color # The color.
function Tool:setCrossHairColor(color) end

---*Client only*  
---Sets the type of the crosshair.   
---@param type number # The type value for the crosshair.
function Tool:setCrossHairType(type) end

---*Client only*  
---Sets the tool's dispersion fraction. This represents the accuracy of the tool, and affects the size of the player's crosshair.  
---A dispersion value of 0 is perfect accuracy, whereas 1 is the worst.  
---@param dispersion number # The dispersion fraction.
---@param dispersionSecondary? number # The secondary dispersion fraction for circles. (Optional)
function Tool:setDispersionFraction(dispersion, dispersionSecondary) end

---*Client only*  
---Sets the color to be used for the tool in first person view.  
---@param color Color # The color.
function Tool:setFpColor(color) end

---*Client only*  
---Sets the renderables (files containing model data) to be used for the character in first person view.  
---@param renderables string[] # The table of renderables names {string, ..}
function Tool:setFpRenderables(renderables) end

---@deprecated Deprecated function. Kept for compability with old scripts.
---Does nothing.  
---@param suppressed boolean Whether interaction texts are suppressed.
function Tool:setInteractionTextSuppressed(suppressed) end

---*Client only*  
---Sets the current third person view movement animation to be used by the tool.  
---@param name string # The name.
---@param animation string # The animation.
function Tool:setMovementAnimation(name, animation) end

---*Client only*  
---Sets whether the player is slowed down. This is similar to crouching and normally occurs when the player is aiming.  
---@param slowDown boolean # Whether the player movement is slowed down.
function Tool:setMovementSlowDown(slowDown) end

---*Client only*  
---Sets the color to be used for the tool in third person view.  
---@param color Color # The color.
function Tool:setTpColor(color) end

---*Client only*  
---Sets the renderables (files containing model data) to be used for the character in third person view.  
---@param renderables string[] # The table of renderables names. {string, ..}
function Tool:setTpRenderables(renderables) end

---*Client only*  
---Updates a third person view animation.  
---@param name string # The animation name.
---@param time number # The time.
---@param weight? number # The weight. (Defaults to -1.0)
function Tool:updateAnimation(name, time, weight) end

---*Client only*  
---Updates the third person view camera for the tool.  
---@param distance number # The distance.
---@param fov number # The fov.
---@param offset Vec3 # The offset.
---@param weight number # The weight.
function Tool:updateCamera(distance, fov, offset, weight) end

---*Client only*  
---Updates a first person view animation.  
---@param name string # The name.
---@param time number # The time.
---@param weight? number # The weight. (Defaults to -1.0)
---@param looping? boolean # The looping. (Defaults to false)
function Tool:updateFpAnimation(name, time, weight, looping) end

---*Client only*  
---Updates the first person view camera for the tool.  
---@param fov number # The fov.
---@param offset Vec3 # The offset.
---@param weight number # The weight.
---@param bobbing number # The bobbing.
function Tool:updateFpCamera(fov, offset, weight, bobbing) end

---*Client only*  
---Sets the rotation and weight for a bone in the animation skeleton.  
---@param name string # The name.
---@param rotation Vec3 # The rotation.
---@param weight? number # The weight. (Defaults to -1.0)
function Tool:updateJoint(name, rotation, weight) end

---*Client only*  
---Updates the currently set third person view movement animation for the tool.  
---@param time number # The time.
---@param weight? number # The weight. (Defaults to -1.0)
function Tool:updateMovementAnimation(time, weight) end

---@alias MovementAnimation string
---| "idle"
---| "idleRelaxed"
---| "sprint"
---| "runFwd"
---| "runBwd"
---| "jump"
---| "jumpUp"
---| "jumpDown"
---| "land"
---| "landFwd"
---| "landBwd"
---| "crouchIdle"
---| "crouchFwd"
---| "crouchBwd"
---| "swimIdle"
---| "swimFwd"
---| "swimBwd"


---*Client only*  
---Sets the current third person view movement animation to be used by the tool.  
---@param name MovementAnimation The name.
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
---@param renderables string[] The table of renderables names. {string, ..}
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
---@operator eq(Widget): boolean
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
---A userdata object representing a <strong>blueprint visualziation</strong>.  
---@operator eq(BlueprintVisualization): boolean
local BlueprintVisualization = {}

---*Client only*  
---Destroy a [BlueprintVisualization].  
function BlueprintVisualization:destroy() end

---*Client only*  
---Set the world position of a [BlueprintVisualization].  
---@param position Vec3 # World position
function BlueprintVisualization:setPosition(position) end

---*Client only*  
---Set the rotation of a [BlueprintVisualization].  
---@param rotation Quat # Rotation
function BlueprintVisualization:setRotation(rotation) end

---*Client only*  
---Set the scale of a [BlueprintVisualization].  
---@param scale Vec3 # Scale
function BlueprintVisualization:setScale(scale) end

---*Client only*  
---Controls the rendering of the [BlueprintVisualization].  
---@param visualizationColor string # Visualization color name to render the blueprint in.
function BlueprintVisualization:setVisualizationColor(visualizationColor) end

---*Client only*  
---Update the state of a builder guide [BlueprintVisualization]. Should be called whenever the root [Shape] of the builder guide has changed.  
---But should not be called every frame or tick for performance.  
function BlueprintVisualization:updateBuilderGuide() end


---@class GuiInterface
---A userdata object representing a <strong>GUI interface</strong>.  
---A <strong>gui interface</strong> is an adapter between a script and a GUI.  
---Can only be used on the <a href="index.html#client">client</a>.  
---@operator eq(GuiInterface): boolean
local GuiInterface = {}

---*Client only*  
---Adds an item to a grid  
---@param gridName string # The name of the grid
---@param item table # The item
function GuiInterface:addGridItem(gridName, item) end

---*Client only*  
---Adds items to a grid from json  
---@param gridName string # The name of the grid
---@param jsonPath string # Json file path
---@param additionalData? table # Additional data to the json (Optional)
function GuiInterface:addGridItemsFromFile(gridName, jsonPath, additionalData) end

---*Client only*  
---Appends an item to a list  
---@param listName string # The name of the list
---@param itemName string # The name of the item
---@param data table # Table of data to store
function GuiInterface:addListItem(listName, itemName, data) end

---*Client only*  
---Adds an item to the item pickup display  
---@param uuid Uuid # The item uuid
---@param amount number # Quantity of items picked up
function GuiInterface:addToPickupDisplay(uuid, amount) end

---*Client only*  
---Clears a grid  
---@param gridName string # The name of the grid to clear
function GuiInterface:clearGrid(gridName) end

---*Client only*  
---Clears a list  
---@param listName string # The name of the list
function GuiInterface:clearList(listName) end

---*Client only*  
---Clears the close callback so it will not be called when the gui is closed  
function GuiInterface:clearOnCloseCallback() end

---*Client only*  
---Close a gui interface  
function GuiInterface:close() end

---*Client only*  
---Add an icon to the compass.  
---@param iconName string # Name of the new compass icon.
---@param image? string # The name or path of the image. (Optional)
---@param showDistance? boolean # If the icon should display distance. (Optional)
---@param width? integer # The width of the icon, defaults to 22. (Optional)
---@param height? integer # The height of the icon, defaults to 22. (Optional)
function GuiInterface:compassAddIcon(iconName, image, showDistance, width, height) end

---*Client only*  
---Plays an effect on an icon on the compass.  
---@param iconName string # Name of the compass icon.
---@param effectName string # The name of the effect
---@param color Color? # The color of the effect
function GuiInterface:compassPingMarker(iconName, effectName, color) end

---*Client only*  
---Remove an icon from the compass.  
---@param iconName string # Name of a compass icon.
function GuiInterface:compassRemoveIcon(iconName) end

---*Client only*  
---Sets a [Character] as host for a world gui  
---@param host Character # The host of the icon
---@param joint? string # The joint/bone name (Optional)
function GuiInterface:compassSetIconHost(host, joint) end

---*Client only*  
---Sets a [Shape] as host for a compass icon  
---@param iconName string # Name of a compass icon.
---@param host Shape # The host of the icon
---@param joint? string # The host joint/bone name (Optional)
function GuiInterface:compassSetIconHost(iconName, host, joint) end

---*Client only*  
---Sets whether the icon should be stacked on top of other icons.  
---@param iconName string # Name of a compass icon.
---@param stacking boolean # The stacking setting.
function GuiInterface:compassSetIconStacking(iconName, stacking) end

---*Client only*  
---Sets the world position for a world gui  
---@param iconName string # Name of a compass icon.
---@param worldPosition Vec3 # The position to set.
---@param world? World # The world, defaults to same as the script
function GuiInterface:compassSetIconWorldPosition(iconName, worldPosition, world) end

---*Client only*  
---Creates a dropdown at the specified widget  
---@param widgetName string # The name of the widget
---@param functionName string # The name of the function
---@param options table # The options in the dropdown menu
function GuiInterface:createDropDown(widgetName, functionName, options) end

---@class GridData
---@field type string
---@field layout string
---@field itemWidth integer
---@field itemHeight integer
---@field itemCount integer

---*Client only*  
---Creats a grid from a table/json  
---@param gridName string # The name of the grid
---@param index GridData # Grid data table { type=string, layout=string, itemWidth=integer, itemHeight=integer, itemCount=integer }
function GuiInterface:createGridFromJson(gridName, index) end

---*Client only*  
---Creates a slider at the specified widget  
---@param widgetName string # The name of the widget
---@param range number # The range of the slider
---@param value number # The start value on the slider
---@param functionName string # Slider change callback function name
---@param numbered? boolean # Enable numbered steps (Defaults to false)
---@param inverted? boolean # Invert slider direction (Defaults to false)
function GuiInterface:createHorizontalSlider(widgetName, range, value, functionName, numbered, inverted) end

---*Client only*  
---Creates a slider at the specified widget  
---@param widgetName string # The name of the widget
---@param range number # The range of the slider
---@param value number # The start value on the slider
---@param functionName string # Slider change callback function name
function GuiInterface:createVerticalSlider(widgetName, range, value, functionName) end

---*Client only*  
---Destroy a gui interface  
function GuiInterface:destroy() end

---*Client only*  
---Gets the current world position of a world gui  
---@return Vec3								The in world position of the gui
function GuiInterface:getWorldPosition() end

---*Client only*  
---Checks if a gui interface is active  
---@return boolean # True if gui is active
function GuiInterface:isActive() end

---*Client only*  
---Open a gui interface  
function GuiInterface:open() end

---*Client only*  
---Plays an effect at a widget  
---@param widgetName string # The name of the widget
---@param effectName string # The name of the effect
---@param restart? boolean # If the effect should restart if its already playing (Defaults to true)
---@param useHistory? boolean # If the effect should use call history (Defaults to false)
function GuiInterface:playEffect(widgetName, effectName, restart, useHistory) end

---*Client only*  
---Plays an effect at widget inside a grid  
---@param gridName string # The name of the grid
---@param index integer # The index in the grid
---@param effectName string # The name of the effect
---@param restart? boolean # If the effect should restart if its already palying (Defaults to true)
function GuiInterface:playGridEffect(gridName, index, effectName, restart) end

---*Client only*  
---Removes an item from the item pickup display  
---@param uuid Uuid # The item uuid
---@param amount number # Quantity of items to remove
function GuiInterface:removeFromPickupDisplay(uuid, amount) end

---*Client only*  
---Sets a button callback to be called when the button is pressed  
---@param buttonName string # The button name
---@param callback string # Function to be called when button is pressed
function GuiInterface:setButtonCallback(buttonName, callback) end

---*Client only*  
---Sets the enabled state of a widget  
---@param widgetName string # The name of the widget
---@param enabled boolean # True if the widget should be enabled
function GuiInterface:setButtonEnabled(widgetName, enabled) end

---*Client only*  
---Sets the button state  
---@param buttonName string # The name of the button
---@param state boolean # The state of the button
function GuiInterface:setButtonState(buttonName, state) end

---*Client only*  
---Sets the color of a widget  
---@param widgetName string # The name of the widget
---@param Color Color # The color
function GuiInterface:setColor(widgetName, Color) end

---*Client only*  
---Sets a container to a grid  
---@param gridName string # The name of the grid
---@param container Container # The container
function GuiInterface:setContainer(gridName, container) end

---*Client only*  
---Sets multiple containers to a grid  
---@param gridName string # The name of the grid
---@param containers Container[] # Table of containers. {[Container], ..}
function GuiInterface:setContainers(gridName, containers) end

---*Client only*  
---Sets data to a widget  
---@param widgetName string # The name of the widget
---@param data? table # The data
function GuiInterface:setData(widgetName, data) end

---*Client only*  
---Sets the Lua callback for when the DressbotGui unlocks something. The callback will receive the uuid of the unlocked customization item.  
---@param functionName string # The name function.
function GuiInterface:setDressbotUnlockCallback(functionName) end

---*Client only*  
---Sets the fade range for a world gui  
---@param range number # The fade range
function GuiInterface:setFadeRange(range) end

---*Client only*  
---Sets a widget to receive key focus  
---@param widgetName string # The name of the widget that needs focus
function GuiInterface:setFocus(widgetName) end

---*Client only*  
---Sets a callback to be called when a button inside a grid is pressed  
---@param buttonName string # The button name
---@param callback string # Function to be called when button is pressed
function GuiInterface:setGridButtonCallback(buttonName, callback) end

---*Client only*  
---Sets an item in a grid  
---@param gridName string # The name of the grid
---@param index integer # The item index
---@param item? table # The item
function GuiInterface:setGridItem(gridName, index, item) end

---*Client only*  
---Sets a callback to be called when a grid item is changed  
---@param gridName string # The grid name
---@param callback string # Function to be called when button is pressed
function GuiInterface:setGridItemChangedCallback(gridName, callback) end

---*Client only*  
---Sets a callback to be called when a grid item is changed  
---@param gridName string # The grid name
---@param callback string # Function to be called when button is pressed
function GuiInterface:setGridItemClickedCallback(gridName, callback) end

---*Client only*  
---Sets a callback to be called when a grid widget gets mouse focus  
---@param buttonName string # The button name
---@param callback string # Function to be called when button is pressed
function GuiInterface:setGridMouseFocusCallback(buttonName, callback) end

---*Client only*  
---Sets the size of a grid  
---@param gridName string # The name of the grid
---@param index integer # The size
function GuiInterface:setGridSize(gridName, index) end

---*Client only*  
---Sets a [Character] as host for a world gui  
---@param character Character # The character to host the gui
---@param joint? string # The joint (Optional)
function GuiInterface:setHost(character, joint) end

---*Client only*  
---Sets a [Shape] as host for a world gui  
---@param shape Shape # The shape to host the gui
---@param joint? string # The joint (Optional)
function GuiInterface:setHost(shape, joint) end

---*Client only*  
---Sets the icon image to a shape from an uuid  
---@param itembox string # The name of the itembox
---@param uuid Uuid # The item uuid
function GuiInterface:setIconImage(itembox, uuid) end

---*Client only*  
---Sets the image of an imagebox  
---@param imagebox string # The name of the imagebox widget
---@param image string # The name or path of the image
function GuiInterface:setImage(imagebox, image) end

---*Client only*  
---Sets the resource, group and item name on an imagebox widget  
---@param imagebox string # The name of the imagebox
---@param itemResource string # The item resource 
---@param itemGroup string # The item group
---@param itemName string # The item name
function GuiInterface:setItemIcon(imagebox, itemResource, itemGroup, itemName) end

---*Client only*  
---Sets a callback to be called when a list selection is changed  
---@param listName string # The list name
---@param callback string # Function to be called when list is selected
function GuiInterface:setListSelectionCallback(listName, callback) end

---*Client only*  
---Sets the maximum render distance for a world gui  
---@param distance number # The max render distance
function GuiInterface:setMaxRenderDistance(distance) end

---*Client only*  
---Sets a mesh preview to display an item from uuid  
---@param widgetName string # The name of the widget
---@param uuid Uuid # The item uuid to display
function GuiInterface:setMeshPreview(widgetName, uuid) end

---*Client only*  
---Sets a callback to be called when the gui is closed  
---@param callback string # Function to be called when gui is closed
function GuiInterface:setOnCloseCallback(callback) end

---*Client only*  
---Sets a callback to be called when the gui is opened  
---@param callback string # Function to be called when gui is opened
function GuiInterface:setOnOpenCallback(callback) end

---*Client only*  
---Overwrites default gui effects with specified open and close effects  
---@param openEffectName string # The name of the open effect
---@param closEffectName string # The name of the close effect
function GuiInterface:setOpenCloseEffect(openEffectName, closEffectName) end

---*Client only*  
---Sets if a world gui requires line of sight to be shown  
---@param required boolean # True if gui requires line of sight to render
function GuiInterface:setRequireLineOfSight(required) end

---*Client only*  
---Sets the selected item in a dropdown widget
---@param widget string The dropdown widget
---@param item string The item to be selected in the dropdown
function GuiInterface:setSelectedDropDownItem(widget, item) end

---*Client only*  
---Selects an item in a list  
---@param listName string # The name of the list
---@param itemName string # The name of the item
function GuiInterface:setSelectedListItem(listName, itemName) end

---*Client only*  
---Sets a callback to be called when the slider is moved  
---@param sliderName string # The button name
---@param callback string # Function to be called when slider is moved
function GuiInterface:setSliderCallback(sliderName, callback) end

---*Client only*  
---Sets the position and range of a slider  
---@param sliderName string # The name of the slider
---@param range number # The slider range
---@param position number # The slider position
function GuiInterface:setSliderData(sliderName, range, position) end

---*Client only*  
---Sets the position of a slider  
---@param sliderName string # The name of the slider
---@param position integer # The slider position
function GuiInterface:setSliderPosition(sliderName, position) end

---*Client only*  
---Sets the slider range of a slider.  
---@param sliderName string # The name of the slider
---@param range integer # The slider range
function GuiInterface:setSliderRange(sliderName, range) end

---*Client only*  
---Sets the range limit of a slider  
---@param sliderName string # The name of the slider
---@param limit integer # The slider range limit
function GuiInterface:setSliderRangeLimit(sliderName, limit) end

---*Client only*  
---Sets the text caption of a textbox widget  
---@param textbox string # The name of the textbox widget
---@param text string # The text
function GuiInterface:setText(textbox, text) end

---*Client only*  
---Sets a callback to be called when the text change is accepted  
---@param editBoxName string # The edit box name
---@param callback string # Function to be called when text is committed
function GuiInterface:setTextAcceptedCallback(editBoxName, callback) end

---*Client only*  
---Sets a callback to be called when the text is changed  
---@param editBoxName string # The edit box name
---@param callback string # Function to be called when text is edited
function GuiInterface:setTextChangedCallback(editBoxName, callback) end

---*Client only*  
---Sets a widget to be visible or not  
---@param widgetName string # The name of the widget
---@param visible boolean # True if visible
function GuiInterface:setVisible(widgetName, visible) end

---*Client only*  
---Sets the state of a widget  
---@param widgetName string # The name of the widget
---@param state integer # The widget state [sm.gui.widgetStates]
function GuiInterface:setWidgetState(widgetName, state) end

---*Client only*  
---Sets the world position for a world gui  
---@param worldPosition Vec3 # The position to set.
---@param world? World # The world, defaults to same as the script
function GuiInterface:setWorldPosition(worldPosition, world) end

---*Client only*  
---Stops an effect playing at a widget  
---@param widgetName string # The name of the widget
---@param effectName string # The name of the effect
---@param immediate? boolean # When true, the effect stops immediately (Defaults to false)
---@param useHistory? boolean # If the effect should use call history (Defaults to false)
function GuiInterface:stopEffect(widgetName, effectName, immediate, useHistory) end

---*Client only*  
---Stopts an effect playing inside a grid  
---@param gridName string # The name of the grid
---@param index integer # The index in the grid
---@param effectName string # The name of the effect
function GuiInterface:stopGridEffect(gridName, index, effectName) end

---@class QuestTask
---@field name string
---@field text string
---@field count number
---@field target number
---@field complete boolean

---*Client only*  
---Adds a quest to the quest tracker  
---@param name string # The name of quest
---@param title string # The quest title to be displayed in the tracker
---@param mainQuest boolean # If the quest is a main quest (Displayed on top in the tracker)
---@param questTasks QuestTask[] # The table of quest tasks to display in the log Task{ name = string, text = string, count = number, target = number, complete = boolean }
---@param icon? string # The icon to display in the tracker (Optional)
function GuiInterface:trackQuest(name, title, mainQuest, questTasks, icon) end

---*Client only*  
---Removes a quest from the quest tracker  
---@param questName string # The name of quest
function GuiInterface:untrackQuest(questName) end


---@class Garage
---A userdata object representing an <strong>Garage</strong> in the game.  
---@operator eq(Garage): boolean
local Garage = {}

---**Get**:
---returns the id of the garage  
---@type int
Garage.id = {}

---Checks if the tracked creation fits into the garage returns nil if no creation is tracked.  
---@return bool fits true if the creation fits otherwise false.
function Garage:creationFits() end

---Returns the bounds of the body of the actively tracked blueprint in the garage. Returns nil if there is no actively tracked blueprint.  
---@return [Vec3, Vec3] # The table of { min, max }
function Garage:getBlueprintBounds() end

---Returns the bounds of the garage staging area.  
---@return [Vec3, Vec3] # The table of { min, max }
function Garage:getGarageBounds() end

---Imports a actively tracked blueprint using the garage returns nil if the blueprint is not initialized yet.  
---@return Vec3 # position	The world position of the tracked blueprint.
function Garage:getPlacement() end

---Returns the position of the garage.  
---@return vec3 # position
function Garage:getPosition() end

---Gets the tracked creation Name and JsonTable from the garage.  
---@return string Name
---@return table jsonData
function Garage:getTrackedBlueprint() end

---Returns the tracking revision counter, incremented each time the tracked blueprint changes.  
---@return int # revision
function Garage:getTrackingRevision() end

---Checks if the garage has an actively tracked blueprint.  
---@return bool				true if there is an actively tracked blueprint, false otherwise.
function Garage:hasActiveTracking() end

---Imports a actively tracked blueprint using the garage  
function Garage:importBlueprint() end

---*Client only*  
---Tracks a blueprint from a garage and synchronizes it to all other clients.  
---@param pathString string # The blueprint path.
function Garage:trackBlueprint(pathString) end

---Untrack a blueprint from a garage and synchronizes it to all other clients.  
function Garage:untrackBlueprint() end


---Creates a new class object.  
---@param base? table # An optional base class to inherit from. (Defaults to inheriting from no class)
---@return table # Class table.
function class(base) end

---Opens the named file and executes its contents as a Lua chunk. In case of errors, dofile propagates the error to its caller.  
---@param filename string # The name of the file to be loaded.
function dofile(filename) end

---Returns the type of an object as an enum integer. This includes standard Lua types and userdata types specific to this API.  
---@param object any # The object instance.
---@return integer # The object type.
function enumType(object) end

---Prints data to the <a href="index.html#console">console</a>. This is useful for debugging.  
---**Note:**
---*If the game is running with the `-dev` flag, any output will be added to the game logs.*
---@param ... any # The arguments to be printed.
function print(...) end

---Returns the type of an object as a string. This includes standard Lua types and userdata types specific to this API.  
---@param object any The object instance.
---@return string # The object type.
function type(object) end


---The <strong>sm</strong> namespace contain all API features related to Scrap Mechanic.  
sm = {}

---Returns whether the game is currently running on the <a href="index.html#server">hosting</a> player's computer.  
---@type boolean
sm.isHost = {}

---Lua types  
---nil
---boolean
---lightUserdata
---number
---string
---table
---function
---userdata
---thread
---quest
---areaTrigger
---portal
---pathNode
---lift
---scriptableObject
---builderGuide
---cullSphereGroup
---voxelTerrain
---jsonGui
---jsonWidget
---clientScriptableObject
---uuid
---vec3
---quat
---color
---raycastResult
---loadCellHandle
---effect
---shape
---body
---interactable
---container
---harvestable
---network
---world
---unit
---storage
---player
---character
---joint
---aiState
sm.types = {
    ["nil"] = 0,
    boolean = 1,
    lightUserdata = 2,
    number = 3,
    string = 4,
    table = 5,
    ["function"] = 6,
    userdata = 7,
    thread = 8,
    quest = 10034,
    areaTrigger = 10035,
    portal = 10036,
    pathNode = 10037,
    lift = 10038,
    scriptableObject = 10039,
    builderGuide = 10040,
    cullSphereGroup = 10041,
    voxelTerrain = 10042,
    jsonGui = 10043,
    jsonWidget = 10044,
    clientScriptableObject = 10045,
    uuid = 10001,
    vec3 = 10003,
    quat = 10004,
    color = 10005,
    raycastResult = 10006,
    loadCellHandle = 10007,
    effect = 10008,
    shape = 10021,
    body = 10022,
    interactable = 10023,
    container = 10024,
    harvestable = 10025,
    network = 10026,
    world = 10027,
    unit = 10028,
    storage = 10029,
    player = 10030,
    character = 10031,
    joint = 10032,
    aiState = 10033,
}

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
---@param path string # The json file path.
---@return boolean # Return true if the file exists.
function sm.json.fileExists(path) end

---Opens a json file and parses to Lua table.  
---@param path string # The json file path.
---@param ignoreCache boolean? # Whether to ignore the cache.
---@return table # The table.
function sm.json.open(path, ignoreCache) end

---Parses a json string to lua table.  
---@param json string # The json string.
---@return table # The table.
function sm.json.parseJsonString(json) end

---Write a lua table to json.  
---@param root table # The lua table.
---@param path string # The json file path.
function sm.json.save(root, path) end

---Writes a json string from a lua table.  
---@param root table # The lua table.
---@param stylized? boolean # Generates stylized json if true, compact if false. (Defaults to false)
---@return string # The json string.
function sm.json.writeJsonString(root, stylized) end


---Contains methods related to random number and noise generation.  
---Most noise related functions are used for terrain generation.  
sm.noise = {}

---A number noise 2d function.  
---@param x number # The X value.
---@param y number # The Y value.
---@param seed integer # The seed.
---@return number # The noise value.
function sm.noise.floatNoise2d(x, y, seed) end

---Returns a directional vector with a random spread given by a [sm.noise.randomNormalDistribution, normal distribution].  
---@param direction Vec3 # The direction.
---@param spreadAngle number # The spread angle in degrees.
---@return Vec3 # The spread direction.
function sm.noise.gunSpread(direction, spreadAngle) end

---An integer noise 2d function. Generates positive numbers only.  
---@param x number # The X value.
---@param y number # The Y value.
---@param seed integer # The seed.
---@return integer # The noise value.
function sm.noise.intNoise2d(x, y, seed) end

---An octave noise 2d function.  
---@param x number # The X value.
---@param y number # The Y value.
---@param octaves integer # The octaves.
---@param seed integer # The seed.
---@return number # The noise value.
function sm.noise.octaveNoise2d(x, y, octaves, seed) end

---A perlin noise 2d function.  
---@param x number # The X value.
---@param y number # The Y value.
---@param seed integer # The seed.
---@return number # The noise value.
function sm.noise.perlinNoise2d(x, y, seed) end

---Returns a random number according to the <a target="_blank" href="https://en.wikipedia.org/wiki/Normal_distribution">normal random number distribution</a>.  
---Values near the <strong>mean</strong> are the most likely.  
---Standard <strong>deviation</strong> affects the dispersion of generated values from the mean.  
---@param mean number # The mean.
---@param deviation number # The deviation.
---@return number # The random number.
function sm.noise.randomNormalDistribution(mean, deviation) end

---Returns a random number N such that `a <= N <= b`.  
---@param a number # The lower bound.
---@param b number # The upper bound.
---@return number # The random value.
function sm.noise.randomRange(a, b) end

---A simplex noise 1d function.  
---@param x number # The X value.
---@param xm? number # X value multiplier. (Default 1)
---@return number # The noise value.
function sm.noise.simplexNoise1d(x, xm) end

---A simplex noise 2d function.  
---@param x number # The X value.
---@param y number # The Y value.
---@param xm? number # X value multiplier. (Default 1)
---@param ym? number # Y value multiplier. (Default xm)
---@return number # The noise value.
function sm.noise.simplexNoise2d(x, y, xm, ym) end

---A simplex noise 3d function.  
---@param x number # The X value.
---@param y number # The Y value.
---@param z number # The Z value.
---@param xm? number # X value multiplier. (Default 1)
---@param ym? number # Y value multiplier. (Default xm)
---@param zm? number # Z value multiplier. (Default xm)
---@return number # The noise value.
function sm.noise.simplexNoise3d(x, y, z, xm, ym, zm) end


---Offers various math-related functions.  
sm.util = {}

---Easing function ids can be passed to the easing function instead of the easing function's name.  
---The easings are:  
--- - <strong>linear</strong>
--- - <strong>easeInQuad</strong>
--- - <strong>easeOutQuad</strong>
--- - <strong>easeInOutQuad</strong>
--- - <strong>easeInCubic</strong>
--- - <strong>easeOutCubic</strong>
--- - <strong>easeInOutCubic</strong>
--- - <strong>easeInQuart</strong>
--- - <strong>easeOutQuart</strong>
--- - <strong>easeInOutQuart</strong>
--- - <strong>easeInQuint</strong>
--- - <strong>easeOutQuint</strong>
--- - <strong>easeInOutQuint</strong>
--- - <strong>easeInSine</strong>
--- - <strong>easeOutSine</strong>
--- - <strong>easeInOutSine</strong>
--- - <strong>easeInCirc</strong>
--- - <strong>easeOutCirc</strong>
--- - <strong>easeInOutCirc</strong>
--- - <strong>easeInExpo</strong>
--- - <strong>easeOutExpo</strong>
--- - <strong>easeInOutExpo</strong>
--- - <strong>easeInElastic</strong>
--- - <strong>easeOutElastic</strong>
--- - <strong>easeInOutElastic</strong>
--- - <strong>easeInBack</strong>
--- - <strong>easeOutBack</strong>
--- - <strong>easeInOutBack</strong>
--- - <strong>easeInBounce</strong>
--- - <strong>easeOutBounce</strong>
--- - <strong>easeInOutBounce</strong>
sm.util.easingFunctionIds = {
    linear           = 1,
    easeInQuad       = 2,
    easeOutQuad      = 3,
    easeInOutQuad    = 4,
    easeInCubic      = 5,
    easeOutCubic     = 6,
    easeInOutCubic   = 7,
    easeInQuart      = 8,
    easeOutQuart     = 9,
    easeInOutQuart   = 10,
    easeInQuint      = 11,
    easeOutQuint     = 12,
    easeInOutQuint   = 13,
    easeInSine       = 14,
    easeOutSine      = 15,
    easeInOutSine    = 16,
    easeInCirc       = 17,
    easeOutCirc      = 18,
    easeInOutCirc    = 19,
    easeInExpo       = 20,
    easeOutExpo      = 21,
    easeInOutExpo    = 22,
    easeInElastic    = 23,
    easeOutElastic   = 24,
    easeInOutElastic = 25,
    easeInBack       = 26,
    easeOutBack      = 27,
    easeInOutBack    = 28,
    easeInBounce     = 29,
    easeOutBounce    = 30,
    easeInOutBounce  = 31,
}

---Constructs a quaternion from a X and Z axis  
---@param xAxis Vec3 # The X axis.
---@param yAxis Vec3 # The Z axis.
---@return Quat # rotation		The quaternion.
function sm.util.axesToQuat(xAxis, yAxis) end

---Quadratic Bezier interpolation. One dimensional bezier curve.  
---@param c0 number # The start value.
---@param c1 number # The control point.
---@param c2 number # The end value.
---@param t number # The interpolation step.
---@return number # The interpolated value between two values.
function sm.util.bezier2(c0, c1, c2, t) end

---Cubic Bezier interpolation. One dimensional bezier curve.  
---@param c0 number # The start value.
---@param c1 number # The first control point.
---@param c2 number # The second control point.
---@param c3 number # The end value.
---@param t number # The interpolation step.
---@return number # The interpolated value between two values.
function sm.util.bezier3(c0, c1, c2, c3, t) end

---Restricts a value to a given range.  
---@param value number # The value.
---@param min number # The lower limit.
---@param max number # The upper limit.
---@return number # The clamped value.
function sm.util.clamp(value, min, max) end

---Clamps a UTF-8 string to a maximum number of characters without splitting multi-byte sequences.  
---@param string string # The input string.
---@param maxLength integer # The maximum number of UTF-8 characters.
---@return string # The clamped string.
function sm.util.clampUtf8String(string, maxLength) end

---Applies an easing function to a given input.  
---@param easingFunctionId integer # The easing function to use. (See [sm.util.easingFunctionIds])
---@param p number # The easing function input.
---@return number # The output.
function sm.util.easing(easingFunctionId, p) end

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
---Easing function names:  
---<em>linear</em>  
---<em>easeInQuad</em>  
---<em>easeOutQuad</em>  
---<em>easeInOutQuad</em>  
---<em>easeInCubic</em>  
---<em>easeOutCubic</em>  
---<em>easeInOutCubic</em>  
---<em>easeInQuart</em>  
---<em>easeOutQuart</em>  
---<em>easeInOutQuart</em>  
---<em>easeInQuint</em>  
---<em>easeOutQuint</em>  
---<em>easeInOutQuint</em>  
---<em>easeInSine</em>  
---<em>easeOutSine</em>  
---<em>easeInOutSine</em>  
---<em>easeInCirc</em>  
---<em>easeOutCirc</em>  
---<em>easeInOutCirc</em>  
---<em>easeInExpo</em>  
---<em>easeOutExpo</em>  
---<em>easeInOutExpo</em>  
---<em>easeInElastic</em>  
---<em>easeOutElastic</em>  
---<em>easeInOutElastic</em>  
---<em>easeInBack</em>  
---<em>easeOutBack</em>  
---<em>easeInOutBack</em>  
---<em>easeInBounce</em>  
---<em>easeOutBounce</em>  
---<em>easeInOutBounce</em>  
---@param easing EasingFunction # The easing function name.
---@param p number # The easing function input.
---@return number # The output.
function sm.util.easing(easing, p) end

---Numerically approximates the geometric median from a table of points.  
---If no initial guess is made, the mean position of all the points will be used as a guess.  
---@param points Vec3[] # The table of points. { [Vec3], ... }.
---@param initialGuess? Vec3 # A guessed position to start searching from. (Optional)
---@param iterations? integer # The number of iterations. (Defaults to 1)
---@return Vec3 # The estimated geometric median.
function sm.util.geometricMedian(points, initialGuess, iterations) end

---Create a hash from arguments.  
---@param ... any # The arguments to be hashed.
---@return integer # The hash.
function sm.util.hash(...) end

---Linear interpolation between two values. This is known as a lerp.  
---@param a number # The first value.
---@param b number # The second value.
---@param t number # The interpolation step.
---@return number # The interpolated value between two values.
function sm.util.lerp(a, b, t) end

---Returns the positive remainder after division of x by n.  
---@param x integer # The number.
---@param n integer # The modulo value.
---@return number # The value.
function sm.util.positiveModulo(x, n) end

---An improved version of the [sm.util.smoothstep, smoothstep] function which has zero 1st and 2nd order derivatives at `x = edge0` and `x = edge1`.  
---@param edge0 number # The value of the lower edge of the Hermite function.
---@param edge1 number # The value of the upper edge of the Hermite function.
---@param x number # The source value for interpolation.
---@return number # The value.
function sm.util.smootherstep(edge0, edge1, x) end

---Performs smooth Hermite interpolation between 0 and 1 when `edge0 < x < edge1`. This is useful in cases where a threshold function with a smooth transition is desired.  
---@param edge0 number # The value of the lower edge of the Hermite function.
---@param edge1 number # The value of the upper edge of the Hermite function.
---@param x number # The source value for interpolation.
---@return number # The value.
function sm.util.smoothstep(edge0, edge1, x) end

---Returns the number of UTF-8 characters in a string.  
---@param string string # The input string.
---@return integer # The number of UTF-8 characters.
function sm.util.utf8StringLength(string) end

---Used for logging information from scripts to the game log.  
sm.log = {}

---Logs an error message  
---@param ... any # The arguments to be displayed as an error message.
function sm.log.error(...) end

---Logs an information message  
---@param ... any # The arguments to be displayed as a log message.
function sm.log.info(...) end

---Logs a warning message  
---@param ... any # The arguments to be displayed as a warning message.
function sm.log.warning(...) end


---A <strong>vector</strong> is used to represent position and direction in 3D space, using X, Y and Z coordinates.  
---To create one, use [sm.vec3.new].  
sm.vec3 = {}

---Quadratic Bezier interpolation. Three dimensional bezier curve.  
---@param c0 Vec3 # The start point.
---@param c1 Vec3 # The control point.
---@param c2 Vec3 # The end point.
---@param t number # The interpolation step.
---@return Vec3 # The interpolated value between two values.
function sm.vec3.bezier2(c0, c1, c2, t) end

---Cubic Bezier interpolation. Three dimensional bezier curve.  
---@param c0 Vec3 # The start point.
---@param c1 Vec3 # The first control point.
---@param c2 Vec3 # The second control point.
---@param c3 Vec3 # The end point.
---@param t number # The interpolation step.
---@return Vec3 # The interpolated value between two values.
function sm.vec3.bezier3(c0, c1, c2, c3, t) end

---Finds the closest axis-aligned vector from the given vector  
---@param vector Vec3 # The vector.
---@return Vec3 # The axis-aligned vector.
function sm.vec3.closestAxis(vector) end

---Compare vectors with threshold FLT_EPSILON.  
---@param v1 Vec3 # The first vector.
---@param v2 Vec3 # The second vector.
---@return boolean		The result of the comparison.
function sm.vec3.fuzzyEquals(v1, v2) end

---Get the distance between 2 vectors  
---@param vector Vec3 # Vector A
---@param vector Vec3 # Vector B
---@return number # distance	The distance between the vectors
function sm.vec3.getDistance(vector, vector) end

---Get the distance between 2 vectors  
---@param vector Vec3 # Vector A
---@param vector Vec3 # Vector B
---@return number # distance	The squared distance between the vectors
function sm.vec3.getDistanceSquared(vector, vector) end

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
---@param v1 Vec3 # The first vector.
---@param v2 Vec3 # The second vector.
---@return Quat # The transformation.
function sm.vec3.getRotation(v1, v2) end

---Performs a <a target="_blank" href="https://en.wikipedia.org/wiki/Linear_interpolation">linear interpolation</a> between two vectors.  
---@param v1 Vec3 # The first vector.
---@param v2 Vec3 # The second vector.
---@param t number # Interpolation amount between the two inputs.
---@return Vec3 # Interpolated vector.
function sm.vec3.lerp(v1, v2, t) end

---Creates a new vector from an existing one.  
---@param vector Vec3 # The original vector.
---@return Vec3 # The created vector.
function sm.vec3.new(vector) end

---Creates a new vector.  
---@param x number # The X value.
---@param y number # The Y value.
---@param z number # The Z value.
---@return Vec3 # The created vector.
function sm.vec3.new(x, y, z) end

---Creates a new vector with 1 in x, y, x.  
---@return Vec3 # The one vector.
function sm.vec3.one() end

---Creates a new vector with 0 in x, y, x.  
---@return Vec3 # The zero vector.
function sm.vec3.zero() end



---A <strong>quaternion</strong> is used to represent rotation as a <a target="_blank" href="https://en.wikipedia.org/wiki/Quaternion">generalization of complex numbers</a>.  
---To create one, use [sm.quat.new].  
---**Warning:**
---*It is uncommon to modify individual X, Y, Z, W components directly. To create a new quaternion, consider using [sm.vec3.getRotation].*
sm.quat = {}

---Creates a new quaternion from angle and axis.  
---@param angle number The rotation angle in radians.
---@param axis Vec3 The axis vector to rotate around.
---@return Quat # The quaternion for rotating angle radians around axis.
function sm.quat.angleAxis(angle, axis) end

---Create a new quaternion from an euler angle vector.  
---@param euler Vec3 The euler angle vector.
---@return Quat # The quaternion.
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
---@return Quat # The quaternion.
function sm.quat.lookRotation(at, up) end

---Creates a new quaternion.  
---@param x number The X value.
---@param y number The Y value.
---@param z number The Z value.
---@param w number The W value.
---@return Quat # The created quaternion.
function sm.quat.new(x, y, z, w) end

---Creates a new quaternion
---@param quat Quat
---@return Quat
function sm.quat.new(quat) end

---Rounds the quaternion rotation into 90 degree steps  
---@param quaternion Quat The quaternion.
---@return Quat # The created quaternion.
function sm.quat.round90(quaternion) end

---Returns the rotation constant for rotating -90 degrees around the X-axis.  
---@return Quat # The rotation quaternion.
function sm.quat.rotNegX90() end

---Returns the rotation constant for rotating -90 degrees around the Y-axis.  
---@return Quat # The rotation quaternion.
function sm.quat.rotNegY90() end

---Returns the rotation constant for rotating -90 degrees around the Z-axis.  
---@return Quat # The rotation quaternion.
function sm.quat.rotNegZ90() end

---Returns the rotation constant for rotating 180 degrees around the X-axis.  
---@return Quat # The rotation quaternion.
function sm.quat.rotX180() end

---Returns the rotation constant for rotating 90 degrees around the X-axis.  
---@return Quat # The rotation quaternion.
function sm.quat.rotX90() end

---Returns the rotation constant for rotating 180 degrees around the Y-axis.  
---@return Quat # The rotation quaternion.
function sm.quat.rotY180() end

---Returns the rotation constant for rotating 90 degrees around the Y-axis.  
---@return Quat # The rotation quaternion.
function sm.quat.rotY90() end

---Returns the rotation constant for rotating 180 degrees around the Z-axis.  
---@return Quat # The rotation quaternion.
function sm.quat.rotZ180() end

---Returns the rotation constant for rotating 90 degrees around the Z-axis.  
---@return Quat # The rotation quaternion.
function sm.quat.rotZ90() end

---Performs a spherical linear interpolation between two quaternion.  
---@param quaternion1 Quat The first quaternion.
---@param quaternion2 Quat The second quaternion.
---@param t number Interpolation amount between the two inputs.
---@return Quat # The interpolated quaternion.
function sm.quat.slerp(quaternion1, quaternion2, t) end


---A universally unique identifier (<strong>UUID</strong>) is a 128-bit number that can guarantee uniqueness across space and time.  
---To generate one, use [sm.uuid.new].  
sm.uuid = {}

---Generates a named (version 5) uuid.  
---@param namespace Uuid # A uuid namespace for the name. The namespace makes sure any equal name from different namespaces do not collide.
---@param name string # A name, to generate a uuid from. Provided the same namespace and name, the uuid will be the same.
---@return Uuid # The created uuid.
function sm.uuid.generateNamed(namespace, name) end

---Generates a random (version 4) uuid.  
---@return Uuid # The generated uuid.
function sm.uuid.generateRandom() end

---Creates a nil uuid {00000000-0000-0000-0000-000000000000}  
---@return Uuid # The nil uuid.
function sm.uuid.getNil() end

---Creates a uuid from a string or generates a random uuid (version 4).  
---@param uuid? Uuid # The uuid to create a uuid instance from. If none is provided, generate a random uuid.
---@return Uuid # The created uuid.
function sm.uuid.new(uuid) end

---Creates a uuid from a string or generates a random uuid (version 4).  
---@param uuid? string # The uuid string to create a uuid instance from. If none is provided, generate a random uuid.
---@return Uuid # The created uuid.
function sm.uuid.new(uuid) end


---A <strong>color</strong> is represented using a red, green, blue and alpha component. Colors are prominently used for blocks and parts that are colored by the <em>Paint Tool</em>.  
---To create one, use [sm.color.new]. It is possible to use hex `0xRRGGBBAA` or strings `"RRGGBBAA"`.  
---**Note:**
---*R, G, B, A values range between 0.0&ndash;1.0.*
sm.color = {}

---Linearly interpolates between two colors  
---@param color1 Color # The first color.
---@param color2 Color # The second color.
---@param t number # Interpolation amount between the two inputs.
---@return Color # Interpolated color.
function sm.color.lerp(color1, color2, t) end

---Creates a new color object from another color object.  
---@param color Color # The color to copy.
---@return Color # The created color.
function sm.color.new(color) end

---Creates a new color object from R, G, B, A.  
---@param r number # The red value.
---@param g number # The green value.
---@param b number # The blue value.
---@param a? number # The alpha value. Defaults to 1.0. (Optional)
---@return Color # The created color.
function sm.color.new(r, g, b, a) end

---Creates a new color object from a hex string `"RRGGBBAA"`.  
---@param hexStr string # The hex string.
---@return Color # The created color.
function sm.color.new(hexStr) end

---Creates a new color object from a hex value `0xRRGGBBAA`.  
---@param hexInt integer # The hex value.
---@return Color # The created color.
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
    waterArea = 16,
    terrainSurface = 128,
    terrainAsset = 256,
    harvestable = 512,
    joints = 4096,
    voxelTerrain = 32768,
    allTerrain = 33152,
    static = 558978,
    default = 563079,
    portalArea = 2097152,
}

---Physics types are used to define an object's characteristics is in the physics world. Upon a raycast or collision detection, these types are used to find out what object was intersected.  
---"invalid"	No object.  
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
---"debris" Visual objects that have no impact on any other object.
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
    "tunnelCatcher",
    "debris",
}

---Applies an impulse to a [Shape], changing its velocity immediately. The impulse is applied to the shape's centerpoint with an optional offset.  
---@param target Shape # The object on which the impulse is exerted on.
---@param impulse Vec3 # The direction and strength of the impulse.
---@param worldSpace? boolean # Whether the impulse is applied in world space coordinates. (Defaults to local rotation)
---@param offset? Vec3 # The offset from the center point. (Defaults to no offset)
function sm.physics.applyImpulse(target, impulse, worldSpace, offset) end

---Applies an impulse to a [Body], changing its velocity immediately. The impulse is applied to the body's center of mass with an optional offset.  
---@param target Body # The object on which the impulse is exerted on.
---@param impulse Vec3 # The direction and strength of the impulse.
---@param worldSpace? boolean # Whether the impulse is applied in world space coordinates. (Defaults to local rotation)
---@param offset? Vec3 # The offset from the center point. (Defaults to no offset)
function sm.physics.applyImpulse(target, impulse, worldSpace, offset) end

---Applies an impulse to a [Character], changing its velocity immediately. The impulse is applied to the character's centerpoint.  
---@param target Character # The character on which the impulse is exerted on.
---@param impulse Vec3 # The direction and strength of the impulse.
function sm.physics.applyImpulse(target, impulse) end

---Applies a torque impulse to a [Body], changing its angular velocity immediately. The torque is applied along the body's center of mass, making it rotate.  
---@param target Body # The object on which the torque is exerted on.
---@param torque Vec3 # The direction and strength of the torque.
---@param worldSpace? boolean # Whether the torque is applied in world space coordinates. (Defaults to local rotation)
function sm.physics.applyTorque(target, torque, worldSpace) end

---Returns the number of collision objects that are found inside a given capsule.  
---The capsule is formed by connecting two spheres.  
---@param from Vec3 # The world position of the first sphere.
---@param to Vec3 # The world position of the second sphere.
---@param radius number # The radius of the spheres.
---@param mask? integer # The collision mask. Defaults to [sm.physics.filter, sm.physics.filter.default] (Optional)
---@return integer # The number of objects.
function sm.physics.capsuleContactCount(from, to, radius, mask) end

---Returns true if any collision object is found inside a given capsule.  
---Faster than capsuleContactCount when only checking for existence.  
---The capsule is formed by connecting two spheres.  
---@param from Vec3 # The world position of the first sphere.
---@param to Vec3 # The world position of the second sphere.
---@param radius number # The radius of the spheres.
---@param mask? integer # The collision mask. Defaults to [sm.physics.filter, sm.physics.filter.default] (Optional)
---@return boolean # True if any contact was found.
function sm.physics.capsuleHasContact(from, to, radius, mask) end

---Performs a capsule <a target="_blank" href="https://en.wikipedia.org/wiki/Ray_casting">ray cast</a> (Z-axis aligned) between two positions.  
---The returned [RaycastResult] contains information about any object intersected by the ray.  
---If the ray cast is called from within a shape (e.g. a Sensor), a [Body] may be provided which the ray will not intersect.  
---@param startPosition Vec3 # The start position.
---@param endPosition Vec3 # The end position.
---@param radius number # The radius of the capsule.
---@param height number # The height of the cylindrical part of the capsule.
---@param ignore? Body|Shape|Harvestable|Character|AreaTrigger # An object to be ignored. (Optional)
---@param mask? integer # The collision mask. Defaults to [sm.physics.filter, sm.physics.filter.default] (Optional)
---@param world? World # The world to perform the cast in. (Optional)
---@param ignoreUuids? Uuid[] # A table of uuids {[Uuid], ...} of [Shape], [Harvestable] or [Character] type to be ignored. (Optional)
---@return boolean,	RaycastResult # True if raycast was successful; The raycast result data.
function sm.physics.capsulecast(startPosition, endPosition, radius, height, ignore, mask, world, ignoreUuids) end

---Performs a distance <a target="_blank" href="https://en.wikipedia.org/wiki/Ray_casting">ray cast</a> from a position with a given direction.  
---**Note:**
---*[sm.physics.distanceRaycast] is generally cheaper to use than [sm.physics.raycast] as it performs collision checks in a simplified world. If the raycast is only used for checking collision, it is advised to use this method instead.*
---@param start Vec3 # The start position.
---@param direction Vec3 # The ray's direction and length.
---@return boolean, number # 2 values: whether raycast was successful; the fraction (0&ndash;1) of the distance reached until collision divided by the ray's length.
function sm.physics.distanceRaycast(start, direction) end

---*Server only*  
---Creates an explosion at given position. The explosion creates a shockwave that is capable of destroying blocks and pushing characters and creations away.  
---Shapes that are within the explosion's destruction radius may receive the event [ShapeClass.server_onExplosion, server_onExplosionHit].  
---**Note:**
---*The <strong>destruction level</strong> is the damage effect on blocks and parts, determining how likely it is that they are destroyed. This is related to the `qualityLevel` found in parts json-files.*
---*Any quality level equal to or less than the destruction level may be destroyed. The effect fades one level every half travelled of the remaining destruction radius.*
---*A quality level of 0 means a block or part is indestructible.*
---@param position Vec3 # The center point of the explosion.
---@param level integer # The destruction level affecting nearby objects.
---@param destructionRadius number # The destruction radius. Objects inside this sphere may be destroyed.
---@param impulseRadius number # The impulse radius. Objects inside this sphere are affected by an [sm.physics.applyImpulse, impulse].
---@param magnitude number # The impulse strength of the explosion. The strength diminishes with distance.
---@param effectName? string # The name of the effect to be played upon explosion. (Optional)
---@param ignoreShape? Shape # The shape to be ignored. (Optional)
---@param parameters? table # The table containing the parameters for the effect. (Optional)
---@param world? World # The world to cause the explosion in. (Optional)
---@param damage? integer # The damage of the explosion. Defaults to 2 * destruction level (Optional)
---@param source? Harvestable|Player|Shape|Unit # The source of the explosion. Defaults to none (Optional)
---@param type? Uuid # The explosionType. Defaults to nil uuid (Optional)
function sm.physics.explode(position, level, destructionRadius, impulseRadius, magnitude, effectName, ignoreShape, parameters, world, damage, source, type) end

---@class SphereContacts
---@field bodies Body[]
---@field characters Character[]
---@field harvestables Harvestable[]
---@field lifts Lift[]

---Returns a table of the game objects that are found inside the given box  
---@param pos Vec3 # The world position of the box center.
---@param rotation Quat # The rotation of the box.
---@param halfExtents Vec3 # The half extents of the box.
---@param world? World # The world to search in. (optional)
---@param mask? integer # The collision mask. Defaults to [sm.physics.filter, sm.physics.filter.static] and [sm.physics.filter, sm.physics.filter.dynamicBody] and [sm.physics.filter, sm.physics.filter.character] (Optional)
---@return SphereContacts # The table with tables of objects found inside the box. { bodies={[Body], ..}, characters={[Character], ..}, harvestables={[Harvestable], ..}, lifts={[Lift], ..} }
function sm.physics.getBoxContacts(pos, rotation, halfExtents, world, mask) end

---*Server only*  
---Returns the gravitational acceleration affecting [Shape, shapes] and [Body, bodies].  
---@return number # The gravitational value.
function sm.physics.getGravity() end

---Returns the material at the given position in the terrain.  
---@param worldPosition Vec3 # The world position to check the material at.
---@return string # The material name.
function sm.physics.getGroundMaterial(worldPosition) end

---Returns the material id from name  
---@param materialName string # Material name.
---@return integer # The id of the material.
function sm.physics.getMaterialId(materialName) end

---@alias ShapeContacts {shape: Shape, contactWorldPosition: Vec3}[]

---Returns a table of all shapes colliding with a given box.  
---@param position Vec3 # The center position of the box.
---@param rotation Quat # The rotation of the box.
---@param halfExtents Vec3 # The halved size of the box.
---@param world? World # The world to search in. (optional)
---@return ShapeContacts # The table of found shapes. {{shape=[Shape], contactWorldPosition=[Vec3] }, ..}
function sm.physics.getShapeContactsInBox(position, rotation, halfExtents, world) end

---Returns a table of all shapes colliding with a given sphere.  
---@param center Vec3 # The center position of the sphere.
---@param radius number # The radius of the sphere.
---@param world World? # The world to search in. (optional)
---@return ShapeContacts # The table of found shapes. {{shape=[Shape], contactWorldPosition=[Vec3] }, ..}
function sm.physics.getShapeContactsInSphere(center, radius, world) end

---Returns a table of the game objects that are found inside the given sphere  
---@param pos Vec3 # The world position of the sphere.
---@param radius number # The radius of the sphere.
---@param world? World # The world to search in. Defaults to current world (Optional)
---@param mask? integer # The collision mask. Defaults to [sm.physics.filter, sm.physics.filter.static] and [sm.physics.filter, sm.physics.filter.dynamicBody] and [sm.physics.filter, sm.physics.filter.character] (Optional)
---@return SphereContacts # The table with tables of objects found inside the sphere. { bodies={[Body], ..}, characters={[Character], ..}, harvestables={[Harvestable], ..}, lifts={[Lift], ..} }
function sm.physics.getSphereContacts(pos, radius, world, mask) end

---Returns whether a point is in a liquid or not.  
---@param position Vec3 # The world position to check.
---@param world? World # The world to check in.
---@return boolean # Whether the point is inside liquid or not
function sm.physics.isPointInLiquid(position, world) end

---Returns whether a sphere is hitting a liquid or not.  
---@param position Vec3 # The world position to check.
---@param radius number # The radius of the sphere.
---@param world? World # The world to check in.
---@return boolean # Whether the sphere is hitting a liquid or not
function sm.physics.isSphereHittingLiquid(position, radius, world) end

---@class MulticastData
---@field type string
---@field startPoint Vec3
---@field endPoint Vec3
---@field radius number
---@field mask? number
---@field ignoreUuids? Uuid[]

---Performs multiple sphere and/or raycasts given a table of parameters.  
---Type can be "sphere" or "ray". Radius is ignored for rays.  
---ignoreUuids option is a table of uuids {[Uuid], ...} of [Shape], [Harvestable] or [Character] type to be ignored.  
---@param casts MulticastData[] # Table of casts. { type=string, startPoint=[Vec3], endPoint=[Vec3], radius=number, mask=[sm.physics.filter], ignoreUuids=table }
---@param world? World # The world to perform the cast in. (Optional)
---@return RaycastResult[] # Array of pairs of boolean and [RaycastResult]. {{boolean,  [RaycastResult]}, ..}
function sm.physics.multicast(casts, world) end

---Performs a <a target="_blank" href="https://en.wikipedia.org/wiki/Ray_casting">ray cast</a> between two positions.  
---The returned [RaycastResult] contains information about any object intersected by the ray.  
---If the ray cast is called from within a shape (e.g. a Sensor), a [Body] may be provided which the ray will not intersect.  
---@param startPosition Vec3 # The start position.
---@param endPosition Vec3 # The end position.
---@param ignoredObject? Body|Character|Shape|Harvestable|AreaTrigger # The body to be ignored. (Optional)
---@param mask? integer # The collision mask. Defaults to [sm.physics.filter, sm.physics.filter.default] (Optional)
---@param world? World # The world to perform the raycast in. (Optional)
---@param ignoreUuids? Uuid[] # A table of uuids {[Uuid], ...} of [Shape], [Harvestable] or [Character] type to be ignored. (Optional)
---@return boolean,	RaycastResult # True if raycast was successful; The raycast result data.
function sm.physics.raycast(startPosition, endPosition, ignoredObject, mask, world, ignoreUuids) end

---Performs a <a target="_blank" href="https://en.wikipedia.org/wiki/Ray_casting">ray cast</a> between two positions to find a specific target.  
---a [Body] must be provided as a target.  
---The returned [RaycastResult] contains information about any object intersected by the ray.  
---@param startPosition Vec3 # The start position.
---@param endPosition Vec3 # The end position.
---@param ignoredObject Body|Character|Shape|Harvestable # The body to be exclusively checked.
---@param world? World # The world to perform the raycast in. (Optional)
---@param ignoreUuids? Uuid[] # A table of uuids {[Uuid], ...} of [Shape], [Harvestable] or [Character] type to be ignored. (Optional)
---@return boolean,	RaycastResult # True if raycast was successful; The raycast result data.
function sm.physics.raycastTarget(startPosition, endPosition, ignoredObject, world, ignoreUuids) end

---*Server only*  
---Sets the gravitational acceleration affecting [Shape, shapes] and [Body, bodies].  
---@param gravity number # The gravitational value.
function sm.physics.setGravity(gravity) end

---Returns the number of collision objects that are found inside the given sphere  
---@param worldPosition Vec3 # The world position of the sphere.
---@param radius number # The radius of the sphere.
---@param includeTerrain? boolean # True if terrain should be included in the test (Defaults to false)
---@param countWater? boolean # True if water should be included (Defaults to false)
---@param mask? integer # The collision mask. Defaults to [sm.physics.filter, sm.physics.filter.default]. Using this will override "includeTerrain" and "countWater". (Optional)
---@return integer # The number of objects.
function sm.physics.sphereContactCount(worldPosition, radius, includeTerrain, countWater, mask) end

---Returns true if any collision object is found inside the given sphere.  
---Faster than sphereContactCount when only checking for existence.  
---@param worldPosition Vec3 # The world position of the sphere.
---@param radius number # The radius of the sphere.
---@param includeTerrain? boolean # True if terrain should be included in the test (Defaults to false)
---@param countWater? boolean # True if water should be included (Defaults to false)
---@param mask? integer # The collision mask. Defaults to [sm.physics.filter, sm.physics.filter.default]. Using this will override "includeTerrain" and "countWater". (Optional)
---@return boolean # True if any contact was found.
function sm.physics.sphereHasContact(worldPosition, radius, includeTerrain, countWater, mask) end

---Performs a spherical <a target="_blank" href="https://en.wikipedia.org/wiki/Ray_casting">ray cast</a> between two positions.  
---The returned [RaycastResult] contains information about any object intersected by the ray.  
---If the ray cast is called from within a shape (e.g. a Sensor), a [Body] may be provided which the ray will not intersect.  
---@param startPosition Vec3 # The start position.
---@param endPosition Vec3 # The end position.
---@param radius number # The radius of the sphere.
---@param ignoredObject? Body|Shape|Harvestable|Character|AreaTrigger # An object to be ignored. (Optional)
---@param mask? integer # The collision mask. Defaults to [sm.physics.filter, sm.physics.filter.default] (Optional)
---@param world? World # The world to perform the cast in. (Optional)
---@param ignoreUuids? Uuid[] # A table of uuids {[Uuid], ...} of [Shape], [Harvestable] or [Character] type to be ignored. (Optional)
---@return boolean,	RaycastResult # True if raycast was successful; The raycast result data.
function sm.physics.spherecast(startPosition, endPosition, radius, ignoredObject, mask, world, ignoreUuids) end



---A <strong>shape</strong> is any block, part or basic material that can be built by a player. Shapes are always connected to a [sm.body, body], which is a collection of shapes.  
---For more information about creating your own scripted shapes, see [ShapeClass, ShapeClass].  
sm.shape = {}

---Shape destruction types. Using these will handle the destruction as if it was caused by the specified type.          
sm.shape.destructionType = {
    none = 0,
    projectile = 1,
    melee = 2,
    explosion = 3,
}

---Shape physics materials                                                                         
sm.shape.material = {
    grass = 2,
    gravel = 5,
    hvs_disconite = 36,
    hvs_matrixium = 35,
    ice = 24,
    matrixium = 37,
    mechanical = 19,
    metal = 9,
    metalslippery = 34,
    none = 0,
    plastic = 8,
    popcorn = 33,
    ragdollanimal = 21,
    ragdollhuman = 18,
    rewardlocker = 27,
    rock = 6,
    rubber = 29,
    sand = 4,
    scrapmetal = 26,
    slime = 30,
    slimeslippery = 32,
    sticky = 23,
    tape = 15,
    voxel_bedrock = 100,
    voxel_clay = 111,
    voxel_crimsonite = 108,
    voxel_dirt = 112,
    voxel_goopite = 107,
    voxel_ice = 113,
    voxel_junk = 110,
    voxel_orerich = 106,
    voxel_rock1_a = 101,
    voxel_rock1_b = 102,
    voxel_rock1_c = 103,
    voxel_rock2 = 104,
    default = 1,
    voxel_thornite = 109,
    water = 16,
    watersubmerged = 17,
    wood = 7,
    voxel_rock3 = 105,
    bots = 31,
    bubblewrap = 25,
    cardboard = 13,
    chili = 28,
    dirt = 3,
    disconite = 38,
    electronics = 22,
    fabric = 12,
    fence = 11,
    foilage = 14,
    fruit = 20,
    glass = 10,
}

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
---@param world? World # The world to create the part in. Uses the script's world by default. (Optional)
---@return Shape part The created part
function sm.shape.createPart(uuid, position, rotation, dynamic, forceSpawn, world) end

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

---Return whether the shape uuid belongs to a harvest shape  
---@param uuid Uuid # The shape uuid.
---@return boolean # True if the shape is harvestable.
function sm.shape.getIsHarvest(uuid) end

---Return whether the shape uuid belongs to a stackable shape  
---@param uuid Uuid # The shape uuid.
---@return boolean # True if the shape is stackable.
function sm.shape.getIsStackable(uuid) end

---Returns the block/part description for the given uuid.  
---@param uuid Uuid # The uuid.
---@return string # The shape description.
function sm.shape.getShapeDescription(uuid) end

---@deprecated Deprecated function. Kept for compability with old scripts.
---Does nothing.  
function sm.shape.getShapeIcon() end

---Returns the block/part name for the given uuid.  
---@param uuid Uuid # The uuid.
---@return string # The shape title.
function sm.shape.getShapeTitle(uuid) end

---Returns the color of the uuid's shape type  
---@param uuid Uuid # The uuid of the shape.
---@return Color # The color of the shape type.
function sm.shape.getShapeTypeColor(uuid) end

---Returns the block/part name for the given uuid in uppercase as given in the inventory description translations. Defaults to the shape title if an upper case version does not exist.  
---@param uuid Uuid # The uuid.
---@return string # The shape title in upper case.
function sm.shape.getShapeUpperCaseTitle(uuid) end

---Returns a table of all shapes colliding with a given sphere.  
---@param center Vec3 # The center position of the sphere.
---@param radius number # The radius of the sphere.
---@return Shape[] # The table of found shapes. {[Shape], ..}
function sm.shape.shapesInSphere(center, radius) end

---Return whether the shape uuid exists  
---@param uuid Uuid # The shape uuid.
---@return boolean # exists.
function sm.shape.uuidExists(uuid) end

---A <strong>body</strong> is a collection of [Shape, shapes] that are built together. Bodies can be connected to other bodies using [Joint, joints] such as the bearing.  
sm.body = {}

---*Server only*  
---Create a new body  
---@param position Vec3 # The body's world position.
---@param rotation? Quat # The body's world rotation. (Defaults to [sm.quat.identity])
---@param isDynamic? boolean # Set true if the body is dynamic or false if the body is static. (Defaults to true)
---@return Body # The created body
function sm.body.createBody(position, rotation, isDynamic) end

---Returns a table with all the bodies in the world.  
---@param world? World # The world, will default to the script's world. (optional)
---@return Body[] # The table of all bodies. {[Body], ...}
function sm.body.getAllBodies(world) end

---Returns a table of tables, which is an array of tables containing bodies grouped by creation.  
---A creation includes all bodies connected by [Joint, joints], etc.  
---@param bodies table # The bodies to find all creation bodies from. {[Body], ...}
---@return Body[][] # The table array containing tables of all the bodies, grouped by creation. { {[Body], ...}, ... }
function sm.body.getCreationsFromBodies(bodies) end

---Get the lift a body is on.  
---@param body Body # The body.
---@return Lift # The lift the body is on, or nil if the body is not on a lift.
function sm.body.getLift(body) end


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
    ammo = 2048,
    chemical = 4096,
    all = 4294967295,
}

---Flags to be used with the steering component.  
sm.interactable.steering = {
    left = 1,
    right = 2,
    forward = 4,
    backward = 8
}

---@alias InteractableType string
---| "electricEngine"
---| "gasEngine"
---| "steering"
---| "seat"
---| "controller"
---| "button"
---| "lever"
---| "sensor"
---| "thruster"
---| "radio"
---| "horn"
---| "tone"
---| "logic"
---| "timer"
---| "particlePreview"
---| "audioPreview"
---| "spring"
---| "pointLight"
---| "spotLight"
---| "chest"
---| "itemStack"
---| "scripted"
---| "piston"
---| "simpleInteractive"
---| "camera"
---| "waypoint"
---| "survivalThruster"
---| "survivalPiston"
---| "survivalSpring"
---| "survivalSequence"
---| "survivalSensor"

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
    "audioPreview",
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
sm.joint.types = {
    "bearing",
    "spring",
    "piston"
}


---Information about projectiles are located in `/Data/Projectiles/ProjectileSets/projectiles.json`.  
sm.projectile = {}

---*Server only*  
---@deprecated Name is deprecated, use uuid instead
---Perform a customized projectile attack  
---@param userdata table # The custom user data
---@param name string # The projectile's name.
---@param damage integer # The damage the projectile will inflict.
---@param position Vec3 # The start position in world space.
---@param velocity Vec3 # The direction and velocity.
---@param source Player|Unit # The Unit that is the source of the projectile.
---@param fakePosThird? Vec3 # The visual start position in third-person. (Defaults to position)
---@param fakePosFirst? Vec3 # The visual start position in first-person. (Defaults to position)
---@param delay? integer # The number of ticks before firing. (Defaults to 0)
function sm.projectile.customProjectileAttack(userdata, name, damage, position, velocity, source, fakePosThird, fakePosFirst, delay) end

---*Server only*  
---Perform a customized projectile attack  
---@param userdata table # The custom user data
---@param uuid Uuid # The projectile's uuid.
---@param damage integer # The damage the projectile will inflict.
---@param position Vec3 # The start position in world space.
---@param velocity Vec3 # The direction and velocity.
---@param source Player|Unit|World # The world that is the source of the projectile.
---@param fakePosThird? Vec3 # The visual start position in third-person. (Defaults to position)
---@param fakePosFirst? Vec3 # The visual start position in first-person. (Defaults to position)
---@param delay? integer # The number of ticks before firing. (Defaults to 0)
---@param acceleration? number # The acceleration of the projectile. (Defaults to 0)
---@param lifetime? integer # The max lifetime of the projectile in ticks. (Defaults to 400)
function sm.projectile.customProjectileAttack(userdata, uuid, damage, position, velocity, source, fakePosThird, fakePosFirst, delay, acceleration, lifetime) end

---@deprecated Name is deprecated, use uuid instead
---Returns the mass of a projectile.  
---@param name string # The projectile's name.
---@return number # The mass.
function sm.projectile.getProjectileMass(name) end

---Returns the mass of a projectile.  
---@param uuid Uuid # The projectile's uuid.
---@return number # The mass.
function sm.projectile.getProjectileMass(uuid) end

---Returns the radius of a projectile.  
---@param uuid Uuid # The projectile's uuid.
---@return number # The radius.
function sm.projectile.getProjectileRadius(uuid) end

---*Server only*  
---@deprecated Name is deprecated, use uuid instead
---Perform a customized projectile attack  
---@param userdata table # The custom user data
---@param name string # The projectile's name.
---@param damage integer # The damage the projectile will inflict.
---@param position Vec3 # The start position in world space.
---@param velocity Vec3 # The direction and velocity.
---@param source Harvestable # The harvestable that is the source of the projectile.
---@param delay? integer # The number of ticks before firing. (Defaults to 0)
function sm.projectile.harvestableCustomProjectileAttack(userdata, name, damage, position, velocity, source, delay) end

---*Server only*  
---Perform a customized projectile attack  
---@param userdata table # The custom user data
---@param uuid Uuid # The projectile's uuid.
---@param damage integer # The damage the projectile will inflict.
---@param position Vec3 # The start position in world space.
---@param velocity Vec3 # The direction and velocity.
---@param source Harvestable # The harvestable that is the source of the projectile.
---@param delay? integer # The number of ticks before firing. (Defaults to 0)
---@param acceleration? number # The acceleration of the projectile. (Defaults to 0)
---@param lifetime? integer # The max lifetime of the projectile in ticks. (Defaults to 400)
function sm.projectile.harvestableCustomProjectileAttack(userdata, uuid, damage, position, velocity, source, delay, acceleration, lifetime) end

---@deprecated Name is deprecated, use uuid instead
---Perform a projectile attack  
---@param name string # The projectile's name.
---@param damage integer # The damage the projectile will inflict.
---@param position Vec3 # The start position in world space.
---@param velocity Vec3 # The direction and velocity.
---@param source Harvestable # The [Harvestable] that is the source of the projectile.
---@param delay? integer # The number of ticks before firing. (Defaults to 0)
function sm.projectile.harvestableProjectileAttack(name, damage, position, velocity, source, delay) end

---Perform a projectile attack  
---@param uuid Uuid # The projectile's uuid.
---@param damage integer # The damage the projectile will inflict.
---@param position Vec3 # The start position in world space.
---@param velocity Vec3 # The direction and velocity.
---@param source Harvestable # The [Harvestable] that is the source of the projectile.
---@param delay? integer # The number of ticks before firing. (Defaults to 0)
---@param acceleration? number # The acceleration of the projectile. (Defaults to 0)
---@param lifetime? integer # The max lifetime of the projectile in ticks. (Defaults to 400)
function sm.projectile.harvestableProjectileAttack(uuid, damage, position, velocity, source, delay, acceleration, lifetime) end

---*Client only*  
---@deprecated Name is deprecated, use uuid instead
---Creates and fires a projectile from a player.  
---The projectile is normally fired from the player's position, but due to the weapon being held off-center it may require a fake position for where the projectile appears to be fired from.  
---@param name string # The projectile's name.
---@param position Vec3 # The start position.
---@param velocity Vec3 # The direction and velocity.
---@param fakePosThird? Vec3 # The visual start position in third-person. (Defaults to position)
---@param fakePosFirst? Vec3 # The visual start position in first-person. (Defaults to position)
---@param delay? integer # The number of ticks before firing. (Defaults to 0)
function sm.projectile.playerFire(name, position, velocity, fakePosThird, fakePosFirst, delay) end

---*Client only*  
---Creates and fires a projectile from a player.  
---The projectile is normally fired from the player's position, but due to the weapon being held off-center it may require a fake position for where the projectile appears to be fired from.  
---@param uuid Uuid # The projectile's uuid.
---@param position Vec3 # The start position.
---@param velocity Vec3 # The direction and velocity.
---@param fakePosThird? Vec3 # The visual start position in third-person. (Defaults to position)
---@param fakePosFirst? Vec3 # The visual start position in first-person. (Defaults to position)
---@param delay? integer # The number of ticks before firing. (Defaults to 0)
function sm.projectile.playerFire(uuid, position, velocity, fakePosThird, fakePosFirst, delay) end

---@deprecated Name is deprecated, use uuid instead
---Perform a projectile attack  
---@param name string # The projectile's name.
---@param damage integer # The damage the projectile will inflict.
---@param position Vec3 # The start position.
---@param velocity Vec3 # The direction and velocity.
---@param source Player|Unit # The player that is the source of the projectile.
---@param fakePosThird? Vec3 # The visual start position in third-person. (Defaults to position)
---@param fakePosFirst? Vec3 # The visual start position in first-person. (Defaults to position)
---@param delay? integer # The number of ticks before firing. (Defaults to 0)
function sm.projectile.projectileAttack(name, damage, position, velocity, source, fakePosThird, fakePosFirst, delay) end

---Perform a projectile attack  
---@param uuid Uuid # The projectile's uuid.
---@param damage integer # The damage the projectile will inflict.
---@param position Vec3 # The start position.
---@param velocity Vec3 # The direction and velocity.
---@param source Player|Unit # The player that is the source of the projectile.
---@param fakePosThird? Vec3 # The visual start position in third-person. (Defaults to position)
---@param fakePosFirst? Vec3 # The visual start position in first-person. (Defaults to position)
---@param delay? integer # The number of ticks before firing. (Defaults to 0)
---@param acceleration? number # The acceleration of the projectile. (Defaults to 0)
---@param lifetime? integer # The max lifetime of the projectile in ticks. (Defaults to 400)
function sm.projectile.projectileAttack(uuid, damage, position, velocity, source, fakePosThird, fakePosFirst, delay, acceleration, lifetime) end

---*Client only*  
---Removes projectiles created by a given source. The source world must exist.  
---@param source World # The world that is the source of the projectile.
---@param delay? integer # The number of ticks before destroying the projectile. (Defaults to 0)
function sm.projectile.removeProjectilesWithSource(source, delay) end

---*Client only*  
---Removes projectiles created by a given source. The source player must exist.  
---@param source Player # The player that is the source of the projectile.
---@param delay? integer # The number of ticks before destroying the projectile. (Defaults to 0)
function sm.projectile.removeProjectilesWithSource(source, delay) end

---*Client only*  
---Removes projectiles created by a given character source. Can remove projectiles from a source that doesn't exist, in this case a world to remove from is required.  
---@param source Character # The Character that is the source of the projectile.
---@param delay? integer # The number of ticks before destroying the projectile. (Defaults to 0)
---@param world? World # The world the projectiles should be removed from. (Defaults to same world as source.)
function sm.projectile.removeProjectilesWithSource(source, delay, world) end

---*Server only*  
---@deprecated Name is deprecated, use uuid instead
---Perform a customized projectile attack  
---@param userdata table # The custom user data
---@param name string # The projectile's name.
---@param damage integer # The damage the projectile will inflict.
---@param position Vec3 # The start position in the shape's local space.
---@param velocity Vec3 # The direction and velocity.
---@param source Shape # The shape that is the source of the projectile.
---@param delay? integer # The number of ticks before firing. (Defaults to 0)
function sm.projectile.shapeCustomProjectileAttack(userdata, name, damage, position, velocity, source, delay) end

---*Server only*  
---Perform a customized projectile attack  
---@param userdata table # The custom user data
---@param uuid Uuid # The projectile's uuid.
---@param damage integer # The damage the projectile will inflict.
---@param position Vec3 # The start position in the shape's local space.
---@param velocity Vec3 # The direction and velocity.
---@param source Shape # The shape that is the source of the projectile.
---@param delay? integer # The number of ticks before firing. (Defaults to 0)
---@param acceleration? number # The acceleration of the projectile. (Defaults to 0)
---@param lifetime? integer # The max lifetime of the projectile in ticks. (Defaults to 400)
function sm.projectile.shapeCustomProjectileAttack(userdata, uuid, damage, position, velocity, source, delay, acceleration, lifetime) end

---*Server only*  
---@deprecated Name is deprecated, use uuid instead
---Creates and fires a projectile from a [Shape].  
---@param shape Shape # The shape.
---@param name string # The projectile's name.
---@param position Vec3 # The start position.
---@param velocity Vec3 # The direction and velocity.
---@param delay? integer # The number of ticks before firing. (Defaults to 0)
function sm.projectile.shapeFire(shape, name, position, velocity, delay) end

---*Server only*  
---Creates and fires a projectile from a [Shape].  
---@param shape Shape # The shape.
---@param uuid Uuid # The projectile's uuid.
---@param position Vec3 # The start position.
---@param velocity Vec3 # The direction and velocity.
---@param delay? integer # The number of ticks before firing. (Defaults to 0)
---@param projectileAmount? integer # The amount of shots that will be fired. Uses projectile amount from json if not set (Optional, range of 0-255)
function sm.projectile.shapeFire(shape, uuid, position, velocity, delay, projectileAmount) end

---@deprecated Name is deprecated, use uuid instead
---Perform a projectile attack  
---@param name string # The projectile's name.
---@param damage integer # The damage the projectile will inflict.
---@param position Vec3 # The start position in the shape's local space.
---@param velocity Vec3 # The direction and velocity.
---@param source Shape # The shape that is the source of the projectile.
---@param delay? integer # The number of ticks before firing. (Defaults to 0)
function sm.projectile.shapeProjectileAttack(name, damage, position, velocity, source, delay) end

---Perform a projectile attack  
---@param uuid Uuid # The projectile's uuid.
---@param damage integer # The damage the projectile will inflict.
---@param position Vec3 # The start position in the shape's local space.
---@param velocity Vec3 # The direction and velocity.
---@param source Shape # The shape that is the source of the projectile.
---@param delay? integer # The number of ticks before firing. (Defaults to 0)
---@param acceleration? number # The acceleration of the projectile. (Defaults to 0)
---@param lifetime? integer # The max lifetime of the projectile in ticks. (Defaults to 400)
function sm.projectile.shapeProjectileAttack(uuid, damage, position, velocity, source, delay, acceleration, lifetime) end

---Calculate the ballistic arc of a projectile. There are two potential solutions to the problem.   
---One with a low fire angle and one with a high fire angle. Solutions can be nil if no solution is found.  
---@param firePos Vec3 # The position the projectile is fired from.
---@param targetPos Vec3 # The position the projectile should hit.
---@param velocity number # The fire velocity of the projectile.
---@param gravity number # The gravity ( positive down ).
---@return Vec3, Vec3 # The low angle solution; The high angle solution.
function sm.projectile.solveBallisticArc(firePos, targetPos, velocity, gravity) end

---Information about melee attacks are located in `/Data/Melee/attacks.json`.  
sm.melee = {}

---Performs melee attack check and returns a table of raycast results.  
---@param uuid Uuid # The uuid of the melee attack.
---@param origin Vec3 # The source position of the attack.
---@param directionRange Vec3 # The direction and reach of the attack.
---@param source Unit # The unit that is the source of the attack.
---@return RaycastResult[] # RaycastResult		A table containing [RaycastResult] data.
function sm.melee.getMeleeAttackHits(uuid, origin, directionRange, source) end

---@deprecated Name is deprecated, use uuid instead
---Perform a melee attack  
---@param name string # The name of the melee attack.
---@param damage integer # The damage the attack will inflict.
---@param origin Vec3 # The source position of the attack.
---@param directionRange Vec3 # The direction and reach of the attack.
---@param source Player|Unit # The player that is the source of the attack.
---@param delay? integer # The number of ticks before performing the attack. (Defaults to 0)
---@param power? number # The strength of the knockback power. (Defaults to 5000)
---@param ignoreCharacters? Character[] # A table of characters to ignore in the attack. (optional)
function sm.melee.meleeAttack(name, damage, origin, directionRange, source, delay, power, ignoreCharacters) end

---Perform a melee attack  
---@param uuid Uuid # The uuid of the melee attack.
---@param damage integer # The damage the attack will inflict.
---@param origin Vec3 # The source position of the attack.
---@param directionRange Vec3 # The direction and reach of the attack.
---@param source Player|Unit # The player that is the source of the attack.
---@param delay? integer # The number of ticks before performing the attack. (Defaults to 0)
---@param power? number # The strength of the knockback power. (Defaults to 5000)
---@param ignoreCharacters? Characteer[] # A table of characters to ignore in the attack. (optional)
function sm.melee.meleeAttack(uuid, damage, origin, directionRange, source, delay, power, ignoreCharacters) end

---A <strong>Creation</strong> represent a collection of [sm.body, bodies] linked together by [sm.joint, joints].  
sm.creation = {}

---*Server only*  
---Builds a multi shape  
---@param shape Uuid # The uuid of shape to build.
---@param worldPosition Vec3 # World position of shape.
---@param worldRotation Quat # World rotation of shape.
---@param localPosition? Vec3 # Local position of shape.
---@param localRotation? Quat # Local rotation of shape.
function sm.creation.buildMultiShape(shape, worldPosition, worldRotation, localPosition, localRotation) end

---*Server only*  
---Exports creation to blueprint formatted json string.  
---@param body Body # Any body in the creation.
---@param exportTransforms? boolean # Export the current world transform of bodies. Defaults to false.
---@param forceDynamic? boolean # Force export to dynamic bodies. Defaults to false.
---@return string # The blueprint json string.
function sm.creation.exportToString(body, exportTransforms, forceDynamic) end

---*Server only*  
---Exports creation to blueprint lua table.  
---@param body Body # Any body in the creation.
---@param exportTransforms? boolean # Export the current world transform of bodies. Defaults to false.
---@param forceDynamic? boolean # Force export to dynamic bodies. Defaults to false.
---@return table # The blueprint lua table.
function sm.creation.exportToTable(body, exportTransforms, forceDynamic) end

---Returns a table with uuid's and quantity. A body can be sent in to remove from blueprint cost.  
---@param filePath string # The file path for the blueprint.
---@param bodyId? integer # The id of a body.(Optional)
---@return {uuid: Uuid, quantity: number}[] # The table of {uuid: Uuid, quantity: number}
function sm.creation.getBlueprintCost(filePath, bodyId) end

---Returns a table with uuid's and quantity. A body can be sent in to remove from blueprint cost.  
---@param table table # The lua table for the blueprint.
---@param bodyId? integer # The id of a body.(Optional)
---@return {uuid: Uuid, quantity: number}[] # The table of {uuid: Uuid, quantity: number}
function sm.creation.getBlueprintCost(table, bodyId) end

---*Server only*  
---Imports blueprint json file to world.  
---**Warning:**
---*If the blueprint was not exported with transforms the importer will treat it as if importTransforms was disabled.*
---@param world? World # The world to import to.
---@param pathString string # The blueprint path.
---@param worldPosition? Vec3 # World position of import. If importTransforms is enabled position is applied to the imported transform. (Defaults to vec3.zero().)
---@param worldRotation? Quat # World rotation of import. If importTransforms is enabled rotation is applied to the imported transform. (Defaults to quat.identity().)
---@param importTransforms? boolean # Import world transforms from bodies. (Defaults to false.)
---@param indestructible? boolean # (DEPRECATED) Ignored, use setDestructable(false) on each body in creation. (Defaults to false)
---@return Body[] # The table {[Body], ...} of bodies created from the blueprint.
function sm.creation.importFromFile(world, pathString, worldPosition, worldRotation, importTransforms, indestructible) end

---*Server only*  
---Imports blueprint json string to world.  
---**Warning:**
---*If the blueprint was not exported with transforms the importer will treat it as if importTransforms was disabled.*
---@param world World # The world to import to.
---@param jsonString string # The blueprint json string.
---@param worldPosition? Vec3 # World position of import. If importTransforms is enabled position is applied to the imported transform. (Defaults to vec3.zero().)
---@param worldRotation? Quat # World rotation of import. If importTransforms is enabled rotation is applied to the imported transform. (Defaults to quat.identity().)
---@param importTransforms? boolean # Import world transforms from bodies. (Defaults to false.)
---@param forceInactive? boolean # Import interactables in an inactive state. (Defaults to false.)
---@return Body[] # The table {[Body], ...} of bodies created from the blueprint.
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
---@param x integer # The X-coordinate.
---@param y integer # The Y-coordinate.
---@param size? integer # Size of harvestable (defaults to any size).
---@return Harvestable[] # A table {[sm.harvestable, harvestable], ...} of harvestables.
function sm.cell.getHarvestables(x, y, size) end

---*Server only*  
---Returns a table of [sm.harvestable, harvestables] of a given size for a cell coordinate and Uuid.  
---Sizes are:  
---0: Tiny - plants and crops.  
---1: Small - small trees and rocks.  
---2: Medium - medium trees, visible at a long distance.  
---3: Large - large trees, visible at a very long distance.  
---@param x integer # The X-coordinate.
---@param y integer # The Y-coordinate.
---@param uuid Uuid # The uuid of the harvestable(s)
---@param size? integer # Size of harvestable (defaults to any size).
---@return Harvestable[] # A table {[sm.harvestable, harvestable], ...} of harvestables.
function sm.cell.getHarvestablesByUuid(x, y, uuid, size) end

---*Server only*  
---Returns a table of [sm.interactable, interactables] which matches any of the given [sm.uuid, uuids] for a cell coordinate.  
---**Note:**
---*Can only be used in a server_onCellLoaded callback.*
---@param x integer # The X-coordinate.
---@param y integer # The Y-coordinate.
---@param uuids table # A table {[Uuid], ...} of uuids to match interactables against.
---@return Interactables[] # A table {[sm.interactable, interactable]} of found interactables with matching uuid.
function sm.cell.getInteractablesByAnyUuid(x, y, uuids) end

---*Server only*  
---Returns a table of [sm.interactable, interactables] which contain the given tag for a cell coordinate.  
---**Note:**
---*Can only be used in a server_onCellLoaded callback.*
---@param x integer # The X-coordinate.
---@param y integer # The Y-coordinate.
---@param tag string # A tag to match with.
---@return Interactable[] # A table {[sm.interactable, interactable], ...} of found interactables with matching tag.
function sm.cell.getInteractablesByTag(x, y, tag) end

---*Server only*  
---Returns a table of [sm.interactable, interactables] which contain all of the given tags for a cell coordinate.  
---~ can be used to exclude a specific tag. Example: { "FRUIT", "~BANANA" } finds interactables tagged with FRUIT but excludes interactables that are also tagged with BANANA.  
---**Note:**
---*Can only be used in a server_onCellLoaded callback*
---@param x integer # The X-coordinate
---@param y integer # The Y-coordinate
---@param tags string[] # A table {string, ...} of tags to match with.
---@return Interactable[] # A table {[sm.interactable, interactable], ...} of found interactables with matching tags
function sm.cell.getInteractablesByTags(x, y, tags) end

---*Server only*  
---Returns a table of [sm.interactable, interactables] of a given [sm.uuid, uuid] for a cell coordinate.  
---**Note:**
---*Can only be used in a server_onCellLoaded callback.*
---@param x integer # The X-coordinate.
---@param y integer # The Y-coordinate.
---@param uuid Uuid # The uuid of the interactable(s)
---@return Interactable[] # A table {[sm.interactable, interactable], ...} of found interactables with matching uuid.
function sm.cell.getInteractablesByUuid(x, y, uuid) end

---@class NodeParams : table
---@field name string
---@field connections table

---@class Node
---@field position Vec3
---@field rotation Quat 
---@field scale Vec3
---@field tags string[]
---@field params NodeParams
---@field world? World

---Returns a table of nodes which contains the given tag for a cell coordinate.  
---@param x integer # X-coordinate.
---@param y integer # Y-coordinate.
---@param tag string # Tag to match with.
---@param world? world # The world we are searching in. (Optional, defaults to current world)
---@return Node[] # Table containing { position = [Vec3], rotation = [Quat], scale = [Vec3], tags = {string, ...}, params = table } for each node.
function sm.cell.getNodesByTag(x, y, tag, world) end

---Returns a table of nodes which contain all of the given tags for a cell coordinate.  
---@param x integer # X-coordinate.
---@param y integer # Y-coordinate.
---@param tags string[] # A table {string, ...} of tags to match with.
---@param world? world # The world we are searching in (Optional, defaults to current world)
---@return Node[] # Table containing { position = [Vec3], rotation = [Quat], scale = [Vec3], tags = {string, ...}, params = table } for each node.
function sm.cell.getNodesByTags(x, y, tags, world) end

---Returns a table of tags for a cell coordinate.  
---@param x integer # X-coordinate
---@param y integer # Y-coordinate
---@param world? world # The world we are searching in. (Optional, defaults to current world)
---@return string[] # Table {string, ...} of tags.
function sm.cell.getTags(x, y, world) end



sm.container = {}

---*Server only*  
---Aborts a transaction.  
function sm.container.abortTransaction() end

---*Server only*  
---Starts a new <em>transaction</em> shared across all containers. A transaction is a collection of all changes of container items will be collected and processed  
---A transaction must be ended with [sm.container.endTransaction].  
---@return boolean # Whether starting a transaction was successful.
function sm.container.beginTransaction() end

---*Server only*  
---Performs a collect operation to a specific slot.  
---@param container Container # The container.
---@param slot integer # The container slot.
---@param itemUuid Uuid # The uuid of the item to be added.
---@param quantity integer # The number of items to be added.
---@param mustCollectAll? boolean # If true, only add items if there is enough room. If false, add as many items as possible. Defaults to true. (Optional)
---@return integer # The number of items successfully added.
function sm.container.collectToSlot(container, slot, itemUuid, quantity, mustCollectAll) end

---*Server only*  
---Ends a transaction.  
---@return boolean # Whether ending a transaction was successful.
function sm.container.endTransaction() end

---Returns a table containing item uuid, quantity (and instance id for tools) at first available slot  
---@param container Container # The container.
---@return Item # Table containg item {uuid  = [Uuid], instance = integer, quantity = integer}.
function sm.container.getFirstItem(container) end

---Returns a table containing all item uuids in a container.  
---@param container Container # The container.
---@return Uuid[] # The table of item uuids {[Uuid], ..}.
function sm.container.itemUuid(container) end

---*Server only*  
---Moves the content from one container to another.  
---@param container Container # The source container.
---@param container Container # The destination container.
---@param moveAll? boolean # If true, requires that all items can be moved. Defaults to true. (Optional)
function sm.container.moveAll(container, container, moveAll) end

---*Server only*  
---Moves the content of input container to the player carry container and assigns the carry color.  
---@param container Container # The container to assign.
---@param player Player # The player to receive the carry content and color.
---@param color Color # The color to assign.
function sm.container.moveAllToCarryContainer(container, player, color) end

---Returns a table containing all item quantities in a container.  
---@param container Container # The container.
---@return number[] # The table of item quantities {integer, ..}.
function sm.container.quantity(container) end

---*Server only*  
---Removes a quantity of a given item from a container.  
---@param container Container # The container.
---@param itemUuid Uuid # The uuid of the item.
---@param quantity integer # The number of items.
---@param mustSpendAll? boolean # If true, only remove items if there are enough. If false, remove as many items as possible. Defaults to true. (Optional)
---@param avoidSlot? integer # If the spending should try and avoid a specific inventory slot if the resource is available in inventory. (Optional)
---@return integer # The number of items successfully removed.
function sm.container.spend(container, itemUuid, quantity, mustSpendAll, avoidSlot) end

---*Server only*  
---Performs a [sm.container.spend] operation from a specific slot.   
---@param container Container # The container.
---@param slot integer # The container slot.
---@param itemUuid Uuid # The uuid of the item to be removed.
---@param quantity integer # The number of items to be removed.
---@param mustSpendAll? boolean # If true, only remove items if there are enough. If false, remove as many items as possible. Defaults to true. (Optional)
---@return integer # The number of items successfully removed.
function sm.container.spendFromSlot(container, slot, itemUuid, quantity, mustSpendAll) end

---*Server only*  
---Swaps two item slots.  
---@param container Container # The first container.
---@param container Container # The second container.
---@param slotFrom integer # The first slot
---@param slotTo integer # The second slot
---@return boolean # Indicates if the action is possible.
function sm.container.swap(container, container, slotFrom, slotTo) end

---Returns the total number of a given item uuid in a container.  
---@param container Container # The container.
---@param itemUuid Uuid # The uuid of the item.
---@return integer # The quantity of the given item uuid.
function sm.container.totalQuantity(container, itemUuid) end

---Returns a table containing all item uuids in a container.  
---@param container Container # The container.
---@return Uuid[] # The table of item uuids {[Uuid], ..}.
function sm.container.uniqueItemUuids(container) end


---AI utility functions.  
sm.ai = {}

---Check if the unit can reach the target position by moving straight.  
---@param unit Unit # The unit.
---@param position Vec3 # The target position.
---@param range number # The maximum allowed distance to target position.
---@return boolean # Returns true if the position is available directly.
function sm.ai.directPathAvailable(unit, position, range) end

---Returns true if the character can fire at the target character within a given fire lane.  
---Also returns the aim position that allows the character to succeed.  
---Any obstacle shape that blocks the target, but can be destroyed by the projectile, will be targeted instead.  
---@param character Character # The firing character.
---@param target Harvestable|Character # The target character.
---@param range number # The maximum firing distance.
---@param width number # The width of the fire lane.
---@param attack? integer # The attack level of the projectile. (Defaults to 5)
---@return boolean,Vec3 # The result.
function sm.ai.getAimPosition(character, target, range, width, attack) end

---Check if there's an attackable object between the unit and a position.  
---@param unit Unit # The unit.
---@param position Vec3 # The target position.
---@param range number # The distance.
---@param attack integer # The possible attack level from the breacher.
---@return boolean, Vec3|nil, Shape|Harvestable|Lift|nil # Returns true if a breachable object is found, an attackable position, and an attackable shape.
function sm.ai.getBreachablePosition(unit, position, range, attack) end

---Find the closest harvestable of 'tree' type in a world.  
---@param position Vec3 # The world position to search around.
---@param world? World # The world to search in. (Defaults to the world of the script that is calling the function)
---@return Harvestable # The closest tree harvestable.
function sm.ai.getClosestTree(position, world) end

---Returns the character of a given uuid type that is closest to the unit.  
---@param unit Unit # The unit.
---@param uuid Uuid # The character uuid.
---@return Character # The character.
function sm.ai.getClosestVisibleCharacterType(unit, uuid) end

---Returns the farming harvestable that is closest to the unit.  
---@param unit Unit # The unit.
---@return Harvestable # The harvestable.
function sm.ai.getClosestVisibleCrop(unit) end

---Returns the character closest to the unit.  
---@param unit Unit # The unit.
---@return Character # The character.
function sm.ai.getClosestVisiblePlayerCharacter(unit) end

---Returns the character, with an opposing color, closest to the unit.  
---@param unit Unit # The unit.
---@param color Color # The color.
---@return Character # The character.
function sm.ai.getClosestVisibleTeamOpponent(unit, color) end

---eturns a random position on a given body.  
---@param body Body # The body.
---@return Vec3 # The position.
function sm.ai.getRandomCreationPosition(body) end

---Check if the unit can reach the target position by moving along a path.  
---@param unit Unit # The unit.
---@param position Vec3 # The target position.
---@return boolean # Returns true if the position is reachable.
function sm.ai.isReachable(unit, position) end


---A <strong>character</strong> is the physical body of a living entity in the world. Both <strong>players</strong> and <strong>units</strong> may control a character.  
sm.character = {}

---*Server only*  
---Creates a new character in a world.  
---@param player Player # The player controlling the character.
---@param world World # The world the character is created in.
---@param position Vec3 # The world position of the character.
---@param yaw? number # The initial yaw of the character (Optional).
---@param pitch? number # The initial pitch of the character (Optional).
---@param visible? boolean # Whether the character is visible on spawn. Defaults to true. (Optional)
---@return Character # The created character.
function sm.character.createCharacter(player, world, position, yaw, pitch, visible) end

---A <strong>player</strong> is a user playing the game. Every player controls a [Character] in the world.  
sm.player = {}

---Returns a table of all [Player, players] that are currently in the game.  
---@param getInactive? boolean # Include getting inactive players. Defaults to false. (Optional)
---@return Player[] # Table of all players in the game. {[Player], ..}
function sm.player.getAllPlayers(getInactive) end

---Returns the player of the game host.  
---@return Player # The host player.
function sm.player.getHostPlayer() end

---*Server only*  
---Place down a lift game object  
---@param player Player # The player that owns the lift.
---@param creation Body[] # The bodies to place on the lift. {[Body], ..}
---@param position Vec3 # The lift position.
---@param level integer # The lift level.
---@param rotation integer # The rotation of the creation on the lift.
function sm.player.placeLift(player, creation, position, level, rotation) end

---*Server only*  
---Remove the player's lift, if the lift exists.  
---@param player Player # The player that owns the lift.
function sm.player.removeLift(player) end


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

---Defines special area trigger features:  
--- - <strong>default</strong> &ndash; Nothing special.
--- - <strong>water</strong> &ndash; Buoyancy applied to colliding objects.
--- - <strong>interactable</strong> &ndash; Can be interacted with if implementing bindCanInteract, bindOnInteract, bindCanErase and bindOnDestroy.
--- - <strong>ladder</strong> &ndash; Attach colliding players to the trigger.
--- - <strong>melee</strong> &ndash; Can react to melee attack callbacks if implementing bindOnMelee.
sm.areaTrigger.areaTriggerProxyType = {
    default      = 0,  
    water        = 1,  
    interactable = 2,  
    ladder       = 3,  
    melee        = 4,  
}

---Filters are used to specify what object types an area trigger is able to detect. If an area trigger is created with a filter, it will <strong>only</strong> react to objects of that type. Filters can be combined by adding them.  
---The filters are:  
--- - <strong>dynamicBody</strong> &ndash; Detects [Body, bodies] that are free to move around in the world.
--- - <strong>staticBody</strong> &ndash; Detects [Body, bodies] that are built on the ground or on the lift.
--- - <strong>character</strong> &ndash; Detects [Character, characters] such as players.
--- - <strong>areaTrigger</strong> &ndash; Detects [AreaTrigger, areatriggers] such as water areas.
--- - <strong>harvestable</strong> &ndash; Detects [Harvestable, harvestables] such as planted objects.
--- - <strong>lift</strong> &ndash; Detects [Lift, lifts].
--- - <strong>voxelTerrain</strong> &ndash; Detects destructible terrain.
--- - <strong>all</strong> &ndash; Detects all of the object types above. (Default)
sm.areaTrigger.filter = {
    dynamicBody = 1,
    staticBody = 2,
    character = 4,
    areaTrigger = 8,
    harvestable = 512,
    lift = 1024,
    voxelTerrain = 32768,
    all = 50703
}

---Defines the liquid type of an area trigger.  
---Only has an effect on area triggers with the <strong>water</strong> proxy type; setting it on any other proxy type has no effect.  
---Currently only <strong>lava</strong> has special behavior.  
--- - <strong>water</strong> &ndash; Water. The default. No special behavior beyond the water proxy buoyancy.
--- - <strong>chemical</strong> &ndash; Chemical. No special behavior beyond the water proxy buoyancy.
--- - <strong>oil</strong> &ndash; Oil. No special behavior beyond the water proxy buoyancy.
--- - <strong>lava</strong> &ndash; Lava. Occasionally destroys submerged shapes. Requires [AreaTrigger]: setIncludeShapesInContent.
sm.areaTrigger.liquidType = {
    water = 0,
    chemical = 1,
    oil = 2,
    lava = 3,
}

---Creates an area trigger box with a given size that stays attached to an [sm.character, character]  
---If a filter is specified, the trigger area will only be able to detects objects of that certain type. See [sm.areaTrigger.filter] for more information about filters.  
---@param character Character|Harvestable|Shape|Interactable # The host character.
---@param dimension Vec3 # The size of the box
---@param position? Vec3 # The position offset (Defaults to [sm.vec3.zero])
---@param rotation? Quat # The rotation offset (Defaults to [sm.quat.identity])
---@param filter? integer # The object types the area trigger may detect. (See [sm.areaTrigger.filter]). (Defaults to sm.areaTrigger.filter.all)
---@param userdata? table # An optional table of user data
---@param areaTriggerProxyType? integer # The proxy type of the area trigger. (See [sm.areaTrigger.areaTriggerProxyType]) (Defaults to sm.areaTrigger.areaTriggerProxyType.default)
---@param boneName? string # The bone name of the character to attach the area trigger to. (optional)
---@return AreaTrigger # The created area trigger.
function sm.areaTrigger.createAttachedBox(character, dimension, position, rotation, filter, userdata, areaTriggerProxyType, boneName) end

---Creates an area trigger cylinder with a given size that stays attached to a [sm.character, character]  
---If a filter is specified, the trigger area will only be able to detects objects of that certain type. See [sm.areaTrigger.filter] for more information about filters.  
---@param character Character|Harvestable|Shape|Interactable # The host character.
---@param radius number # The radius of the cylinder.
---@param halfLength number # The lengthwise extent of the cylinder (i.e. half the length of the cylinder).
---@param position? Vec3 # The position offset (Defaults to [sm.vec3.zero])
---@param rotation? Quat # The rotation offset (Defaults to [sm.quat.identity])
---@param filter? integer # The object types the area trigger may detect. (See [sm.areaTrigger.filter]). (Defaults to sm.areaTrigger.filter.all)
---@param userdata? table # An optional table of user data
---@param areaTriggerProxyType? integer # The proxy type of the area trigger. (See [sm.areaTrigger.areaTriggerProxyType]) (Defaults to sm.areaTrigger.areaTriggerProxyType.default)
---@param boneName? string # The bone name of the character to attach the area trigger to. (optional)
---@return AreaTrigger # The created area trigger.
function sm.areaTrigger.createAttachedCylinder(character, radius, halfLength, position, rotation, filter, userdata, areaTriggerProxyType, boneName) end

---Creates an area trigger hull with a given size that stays attached to a [sm.character, character]  
---If a filter is specified, the trigger area will only be able to detects objects of that certain type. See [sm.areaTrigger.filter] for more information about filters.  
---@param character Character|Harvestable|Shape|Interactable # The host character.
---@param hull string # The path to the hull file.
---@param position? Vec3 # The position offset (Defaults to [sm.vec3.zero])
---@param rotation? Quat # The rotation offset (Defaults to [sm.quat.identity])
---@param filter? integer # The object types the area trigger may detect. (See [sm.areaTrigger.filter]). (Defaults to sm.areaTrigger.filter.all)
---@param userdata? table # An optional table of user data
---@param areaTriggerProxyType? integer # The proxy type of the area trigger. (See [sm.areaTrigger.areaTriggerProxyType]) (Defaults to sm.areaTrigger.areaTriggerProxyType.default)
---@param boneName? string # The bone name of the character to attach the area trigger to. (optional)
---@return AreaTrigger # The created area trigger.
function sm.areaTrigger.createAttachedHull(character, hull, position, rotation, filter, userdata, areaTriggerProxyType, boneName) end

---Creates an area trigger sphere with a given size that stays attached to a [sm.character, character]  
---If a filter is specified, the trigger area will only be able to detects objects of that certain type. See [sm.areaTrigger.filter] for more information about filters.  
---@param character Character|Harvestable|Shape|Interactable # The host character.
---@param radius number # The radius of the sphere.
---@param position? Vec3 # The position offset (Defaults to [sm.vec3.zero])
---@param rotation? Quat # The rotation offset (Defaults to [sm.quat.identity])
---@param filter? integer # The object types the area trigger may detect. (See [sm.areaTrigger.filter]). (Defaults to sm.areaTrigger.filter.all)
---@param userdata? table # An optional table of user data
---@param areaTriggerProxyType? integer # The proxy type of the area trigger. (See [sm.areaTrigger.areaTriggerProxyType]) (Defaults to sm.areaTrigger.areaTriggerProxyType.default)
---@param boneName? string # The bone name of the character to attach the area trigger to. (optional)
---@return AreaTrigger # The created area trigger.
function sm.areaTrigger.createAttachedSphere(character, radius, position, rotation, filter, userdata, areaTriggerProxyType, boneName) end

---Creates a new box area trigger at a given position with a given size.  
---If a filter is specified, the trigger area will only be able to detects objects of that certain type. See [sm.areaTrigger.filter] for more information about filters.  
---@param dimension Vec3 # The dimensions of the box.
---@param position Vec3 # The world position.
---@param rotation? Quat # The world rotation. (Defaults to [sm.quat.identity])
---@param filter? integer # The object types the area trigger may detect. (See [sm.areaTrigger.filter]). (Defaults to sm.areaTrigger.filter.all)
---@param userdata? table # An optional table of user data
---@param world? World # The world to create the area trigger in. (optional)
---@param areaTriggerProxyType? integer # The proxy type of the area trigger. (See [sm.areaTrigger.areaTriggerProxyType]) (Defaults to sm.areaTrigger.areaTriggerProxyType.default)
---@return AreaTrigger # The created area trigger.
function sm.areaTrigger.createBox(dimension, position, rotation, filter, userdata, world, areaTriggerProxyType) end

---@deprecated use [sm.areaTrigger.createBox] with [sm.areaTrigger.areaTriggerProxyType] instead.
---Creates a new box area trigger that represent water ie. certain objects cant be placed in it.  
---If a filter is specified, the trigger area will only be able to detects objects of that certain type. See [sm.areaTrigger.filter] for more information about filters.  
---@param dimension Vec3 # The dimensions of the box.
---@param position Vec3 # The world position.
---@param rotation? Quat # The world rotation. (Defaults to [sm.quat.identity])
---@param filter? integer # The object types the area trigger may detect. (See [sm.areaTrigger.filter]). (Defaults to sm.areaTrigger.filter.all)
---@param userdata? table # An optional table of user data
---@return AreaTrigger # The created area trigger.
function sm.areaTrigger.createBoxWater(dimension, position, rotation, filter, userdata) end

---Creates a new cylinder area trigger at a given position with a given size.  
---If a filter is specified, the trigger area will only be able to detects objects of that certain type. See [sm.areaTrigger.filter] for more information about filters.  
---@param radius number # The radius of the cylinder.
---@param halfLength number # The lengthwise extent of the cylinder (i.e. half the length of the cylinder).
---@param position Vec3 # The world position.
---@param rotation? Quat # The world rotation. (Defaults to [sm.quat.identity])
---@param filter? integer # The object types the area trigger may detect. (See [sm.areaTrigger.filter]). (Defaults to sm.areaTrigger.filter.all)
---@param userdata? table # An optional table of user data
---@param world? World # The world to create the area trigger in. (optional)
---@param areaTriggerProxyType? integer # The proxy type of the area trigger. (See [sm.areaTrigger.areaTriggerProxyType]) (Defaults to sm.areaTrigger.areaTriggerProxyType.default)
---@return AreaTrigger # The created area trigger.
function sm.areaTrigger.createCylinder(radius, halfLength, position, rotation, filter, userdata, world, areaTriggerProxyType) end

---Creates a new hull area trigger at a given position with a given size.  
---If a filter is specified, the trigger area will only be able to detects objects of that certain type. See [sm.areaTrigger.filter] for more information about filters.  
---@param hull string # The path to the hull file.
---@param position Vec3 # The world position.
---@param rotation? Quat # The world rotation. (Defaults to [sm.quat.identity])
---@param filter? integer # The object types the area trigger may detect. (See [sm.areaTrigger.filter]). (Defaults to sm.areaTrigger.filter.all)
---@param userdata? table # An optional table of user data
---@param world? World # The world to create the area trigger in. (optional)
---@param areaTriggerProxyType? integer # The proxy type of the area trigger. (See [sm.areaTrigger.areaTriggerProxyType]) (Defaults to sm.areaTrigger.areaTriggerProxyType.default)
---@return AreaTrigger # The created area trigger.
function sm.areaTrigger.createHull(hull, position, rotation, filter, userdata, world, areaTriggerProxyType) end

---Creates a new sphere area trigger at a given position with a given size.  
---If a filter is specified, the trigger area will only be able to detects objects of that certain type. See [sm.areaTrigger.filter] for more information about filters.  
---@param radius number # The radius of the sphere.
---@param position Vec3 # The world position.
---@param rotation? Quat # The world rotation. (Defaults to [sm.quat.identity])
---@param filter? integer # The object types the area trigger may detect. (See [sm.areaTrigger.filter]). (Defaults to sm.areaTrigger.filter.all)
---@param userdata? table # An optional table of user data
---@param world? World # The world to create the area trigger in. (optional)
---@param areaTriggerProxyType? integer # The proxy type of the area trigger. (See [sm.areaTrigger.areaTriggerProxyType]) (Defaults to sm.areaTrigger.areaTriggerProxyType.default)
---@return AreaTrigger # The created area trigger.
function sm.areaTrigger.createSphere(radius, position, rotation, filter, userdata, world, areaTriggerProxyType) end

---The <strong>world</strong> api handles the creation and destruction of worlds.  
---A world contains the terrain and simulates the physics environment in which other game objects can exist.  
sm.world = {}

---Predefined special world ids  
---anyWorld  
---noWorld  
sm.world.ids = {}

---Filters are used to specify what materials a terrain modification sphere can destroy.  
---The filters are:  
--- - <strong>material0</strong> &ndash; Allows destruction of material 0 in the voxel material set.
--- - <strong>material1</strong> &ndash; Allows destruction of material 1 in the voxel material set.
--- - <strong>material2</strong> &ndash; Allows destruction of material 2 in the voxel material set.
--- - <strong>material3</strong> &ndash; Allows destruction of material 3 in the voxel material set.
--- - <strong>material4</strong> &ndash; Allows destruction of material 4 in the voxel material set.
--- - <strong>material5</strong> &ndash; Allows destruction of material 5 in the voxel material set.
--- - <strong>material6</strong> &ndash; Allows destruction of material 6 in the voxel material set.
--- - <strong>material7</strong> &ndash; Allows destruction of material 7 in the voxel material set.
--- - <strong>all</strong> &ndash; Allows destruction of all materials in the voxel material set.
sm.world.voxelFilter = {
    none      = 0,  
    material0 = 1,  
    material1 = 2,  
    material2 = 4,  
    material3 = 8,  
    material4 = 16,  
    material5 = 32,  
    material6 = 64,  
    material7 = 128,  
    all       = 255,  
}

---*Server only*  
---Creates a new world object.  
---@param filename string # The world script filename.
---@param classname string # The world script class name.
---@param terrainParams? any # The world's terrain parameters. (Optional)
---@param seed? integer # The world's seed. Defaults to 0 (Optional)
---@return World # The created world object.
function sm.world.createWorld(filename, classname, terrainParams, seed) end

---Get the world that the scripted object is in.  
---@return World # The world
function sm.world.getCurrentWorld() end

---@class DirtySphere
---@field center Vec3
---@field radius number

---Returns an array of tables representing spheres where something has changed in the world.  
---The optional position and radius parameters will construct a sphere, and use it as a filter to only show results that intersect that sphere.  
---@param position? Vec3 # The world position of the sphere. (Optional)
---@param radius? number # The radius of the sphere. (Optional)
---@return DirtySphere[] # The table of tables. { {center=[Vec3], radius=number}, ..}
function sm.world.getDirtySpheres(position, radius) end

---*Server only*  
---Gets a previously saved creative world  
---@return World # The world (id 0) if it exists in the database or nil
function sm.world.getLegacyCreativeWorld() end

---*Server only*  
---Loads a previously created world.  
---@param world World # The world that should be loaded.
---@return boolean # Return true if the world was loaded.
function sm.world.loadWorld(world) end


---Events for communicating between scripts by running callbacks.  
sm.event = {}

---Event types  
---validate	Will make sure script instance exists, and that the callback is declared on the receiving end, before queuing the event. This is the default type.  
---blind	Will blindly queue the event without making any validation checks. Can be useful for sending events to script we know will come alive the next tick.  
---instant	Same as blind event, but sent immediately.  
sm.event.types = {
    validate = 0,
    blind = 1,
    instant = 2,
}

---Sends an event to a specified [Character].  
---@param character Character # The character.
---@param callback string # The function name in a character script.
---@param args? any # Optional arguments to be sent to the callback.
---@param eventType? integer # The type of event. Defaults to [sm.event.types, sm.event.types.validate].
---@param pauseSave? boolean # Optional, defaults to true. If true, pauses saving for 1 tick for delayed event types (server only).
---@return boolean # result					Returns true if the event was successfully processed.
function sm.event.sendToCharacter(character, callback, args, eventType, pauseSave) end

---Sends an event to the game script.  
---@param callback string # The function name in the game script.
---@param args? any # Optional arguments to be sent to the callback.
---@param eventType? integer # The type of event. Defaults to [sm.event.types, sm.event.types.validate].
---@param pauseSave? boolean # Optional, defaults to true. If true, pauses saving for 1 tick for delayed event types (server only).
---@return boolean # result			Returns true if the event was successfully processed.
function sm.event.sendToGame(callback, args, eventType, pauseSave) end

---Sends an event to a specified [Harvestable].  
---@param harvestable Harvestable # The harvestable.
---@param callback string # The function name in a harvestable script.
---@param args? any # Optional arguments to be sent to the callback.
---@param eventType? integer # The type of event. Defaults to [sm.event.types, sm.event.types.validate].
---@param pauseSave? boolean # Optional, defaults to true. If true, pauses saving for 1 tick for delayed event types (server only).
---@return boolean # result				Returns true if the event was successfully processed.
function sm.event.sendToHarvestable(harvestable, callback, args, eventType, pauseSave) end

---Sends an event to a specified [Interactable].  
---@param interactable Interactable # The interactable.
---@param callback string # The function name in an interactable script.
---@param args? any # Optional arguments to be sent to the callback.
---@param eventType? integer # The type of event. Defaults to [sm.event.types, sm.event.types.validate].
---@param pauseSave? boolean # Optional, defaults to true. If true, pauses saving for 1 tick for delayed event types (server only).
---@return boolean # result				Returns true if the event was successfully processed.
function sm.event.sendToInteractable(interactable, callback, args, eventType, pauseSave) end

---Sends an event to a specified [Player].  
---@param player Player # The player.
---@param callback string # The function name in a player script.
---@param args? any # Optional arguments to be sent to the callback.
---@param eventType? integer # The type of event. Defaults to [sm.event.types, sm.event.types.validate].
---@param pauseSave? boolean # Optional, defaults to true. If true, pauses saving for 1 tick for delayed event types (server only).
---@return boolean # result				Returns true if the event was successfully processed.
function sm.event.sendToPlayer(player, callback, args, eventType, pauseSave) end

---Sends an event to a specified [ScriptableObject].  
---@param scriptableObject ScriptableObject # The scriptableObject.
---@param callback string # The function name in a scriptableObject script.
---@param args? any # Optional arguments to be sent to the callback.
---@param eventType? integer # The type of event. Defaults to [sm.event.types, sm.event.types.validate].
---@param pauseSave? boolean # Optional, defaults to true. If true, pauses saving for 1 tick for delayed event types (server only).
---@return boolean # result				Returns true if the event was successfully processed.
function sm.event.sendToScriptableObject(scriptableObject, callback, args, eventType, pauseSave) end

---Sends an event to a specified [Tool].  
---@param tool Tool # The tool.
---@param callback string # The function name in a tool script.
---@param args? any # Optional arguments to be sent to the callback.
---@param eventType? integer # The type of event. Defaults to [sm.event.types, sm.event.types.validate].
---@param pauseSave? boolean # Optional, defaults to true. If true, pauses saving for 1 tick for delayed event types (server only).
---@return boolean # result				Returns true if the event was successfully queued.
function sm.event.sendToTool(tool, callback, args, eventType, pauseSave) end

---Sends an event to a specified [Unit].  
---@param unit Unit # The unit.
---@param callback string # The function name in a unit script.
---@param args? any # Optional arguments to be sent to the callback.
---@param eventType? integer # The type of event. Defaults to [sm.event.types, sm.event.types.validate].
---@param pauseSave? boolean # Optional, defaults to true. If true, pauses saving for 1 tick for delayed event types (server only).
---@return boolean # result			Returns true if the event was successfully processed.
function sm.event.sendToUnit(unit, callback, args, eventType, pauseSave) end

---Sends an event to a specified [World].  
---@param world World # The world.
---@param callback string # The function name in a world script.
---@param args? any # Optional arguments to be sent to the callback.
---@param eventType? integer # The type of event. Defaults to [sm.event.types, sm.event.types.validate].
---@param pauseSave? boolean # Optional, defaults to true. If true, pauses saving for 1 tick for delayed event types (server only).
---@return boolean # result			Returns true if the event was successfully processed.
function sm.event.sendToWorld(world, callback, args, eventType, pauseSave) end


sm.message = {}

---*Server only*  
---Sends a message to all script instances registered for the given key. Can only be called from server!  
---@param messageKey string # The message key.
---@param data? any # Optional data to send with the message.
function sm.message.send(messageKey, data) end

---*Server only*  
---Subscribes the calling script instance to receive messages for a given key. Can only be called from server!  
---@param messageKey string # The message key to subscribe to.
---@param callbackName string # The name of the callback function to invoke.
function sm.message.subscribe(messageKey, callbackName) end

---Allows checking for static infortmation about items.  
sm.item = {}

---Item tracking filter types 
sm.item.trackingType = {
    mainQuest = 0,
    sideQuest = 1,
    researchable = 2,
}

---*Client only*  
---Adds a shape uuid to be a tracked item.  
---@param uuid Uuid # The uuid of the shape.
---@param type integer # The [sm.item.trackingType].
function sm.item.addTrackedItem(uuid, type) end

---Returns the buoyancy rating of an item.  
---@param uuid Uuid # The item uuid.
---@return integer # The buoyancy.
function sm.item.getBuoyancyRating(uuid) end

---@class CharacterShape
---@field placementSphereRadius number
---@field characterUuid string UUID string of the character

---Return the data for the character [Shape].  
---@param uuid Uuid # The shape uuid.
---@return CharacterShape # The character shape data.
function sm.item.getCharacterShape(uuid) end

---Returns the density rating of an item.  
---@param uuid Uuid # The item uuid.
---@return integer # The density.
function sm.item.getDensityRating(uuid) end

---Returns the durability rating of an item.  
---@param uuid Uuid # The item uuid.
---@return integer # The durability.
function sm.item.getDurabilityRating(uuid) end

---@class Edible
---@field hpGain? number
---@field foodGain? number
---@field waterGain? number 

---Return the data for the edible [Shape].  
---@param uuid Uuid # The shape uuid.
---@return Edible # The edible data.
function sm.item.getEdible(uuid) end

---@class GyroData
---@field yawSensitivityModifier number
---@field pitchSensitivityModifier number

---@class FeatureData : table
---@field filename string
---@field classname string
---@field gyro? GyroData
---@field data table
---@field tag string 

---Returns the shapes feature data.  
---@param uuid Uuid # The item uuid.
---@return FeatureData # The feature data table
function sm.item.getFeatureData(uuid) end

---Returns the friction rating of an item.  
---@param uuid Uuid # The item uuid.
---@return integer # The friction.
function sm.item.getFrictionRating(uuid) end

---Returns a table of all [Interactable, interactable] [Uuid, uuids] of a interactable type  
---@param interactableType string # The interactable type name
---@return Uuid[] # table of interactable [Uuid, uuids] {[Uuid], ..}
function sm.item.getInteractablesUuidsOfType(interactableType) end

---Returns the material of a shape uuid.  
---@param uuid Uuid # The uuid of the shape.
---@return string # The shape's material.
function sm.item.getMaterial(uuid) end

---Returns the material id of a shape uuid.  
---@param uuid Uuid # The uuid of the shape.
---@return integer # The shape's material id.
function sm.item.getMaterialId(uuid) end

---@class Plantable
---@field harvestable string UUID string of the planted harvestable 
---@field allowInGrowbed boolean Whethe the crop can be planted in the growbed
---@field growbed Uuid The UUID string of the growbed shape version of the plantable

---Return the data for the plantable [Shape].  
---@param uuid Uuid # The shape uuid.
---@return Plantable # The plantable data.
function sm.item.getPlantable(uuid) end

---Returns a table of all plantable [Uuid, uuids].  
---@return Uuid[] # table of all plantable [Uuid, uuids] {[Uuid], ..}.
function sm.item.getPlantableUuids() end

---Return the quality level for the [Shape].  
---@param uuid Uuid # The shape uuid.
---@return integer # The quality level.
function sm.item.getQualityLevel(uuid) end

---Returns the default color of a shape  
---@param uuid Uuid # The item uuid.
---@return Color # Color of the shape.
function sm.item.getShapeDefaultColor(uuid) end

---Return the [Shape] offset  
---@param uuid Uuid # The shape uuid.
---@return Vec3 # The offset vector.
function sm.item.getShapeOffset(uuid) end

---Gets the shape local rotation given a shape rotation index and a surface normal in local space (unit axis vector).  
---@param uuid Uuid # The shape uuid.
---@param rotationIndex? integer # The rotation index to get the rotation for. (Defaults to 0)
---@param localNormal? Vec3 # The local space normal the is considered to be placed on. (Defaults to positive Z axis)
---@return Quat # The local shape rotation.
function sm.item.getShapeRotation(uuid, rotationIndex, localNormal) end

---Returns the block dimensions of an shape. Returns nil if the uuid is not an item.  
---@param uuid Uuid # The item uuid.
---@return Vec3 # Size of the shape.
function sm.item.getShapeSize(uuid) end

---Return the stack size for the item. Returns the default stack size of 1 if the item is not found or is a Tool.  
---@param uuid Uuid # The item uuid.
---@return integer # The stack size.
function sm.item.getStackSize(uuid) end

---Check if the item is a block.  
---@param uuid Uuid # The item uuid.
---@return boolean # True if the item is a block.
function sm.item.isBlock(uuid) end

---Returns whether the item is flammable.  
---@param uuid Uuid # The item uuid.
---@return boolean # True if flammable.
function sm.item.isFlammable(uuid) end

---Return whether the [Shape] uuid belongs to a harvestable shape.  
---@param uuid Uuid # The shape uuid.
---@return boolean # True if shape is a harvestable shape.
function sm.item.isHarvestablePart(uuid) end

---Check if the item is a [Joint].  
---@param uuid Uuid # The item uuid.
---@return boolean # True if the item is a joint.
function sm.item.isJoint(uuid) end

---Check if the item is a part.  
---@param uuid Uuid # The item uuid.
---@return boolean # True if the item is a part.
function sm.item.isPart(uuid) end

---Check if the item uuid belongs to a [Tool].  
---@param uuid Uuid # The uuid.
---@return boolean # True if the item uuid belongs to a tool.
function sm.item.isTool(uuid) end

---Return whether the [Shape] uuid belongs to a multi shape.  
---@param uuid Uuid # The uuid.
---@return boolean # True if shape is a multi shape.
function sm.item.isMultiShape(uuid) end

---*Client only*  
---Removes a shape uuid from the tracked items.  
---@param uuid Uuid # The uuid of the shape.
---@param type integer # The [sm.item.trackingType].
function sm.item.removeTrackedItem(uuid, type) end


---The <strong>Challenge</strong> api contains functions related to the Challenge game mode.  
sm.challenge = {}

---*Server only*  
---Retrieve challenge completion time.  
---@param level Uuid # The level's uuid.
---@return number # The completion time.
function sm.challenge.getCompletionTime(level) end

---*Server only*  
---Retrieve challenge level save data.  
---@param level Uuid # The level's uuid.
---@return table # The save data.
function sm.challenge.getSaveData(level) end

---*Server only*  
---Check if a challenge has started  
---@return boolean # Return true if the challenge has started.
function sm.challenge.hasStarted() end

---*Client only*  
---Returns true if the current content is the master mechanic trial pack.  
---@return boolean # The content pack status.
function sm.challenge.isMasterMechanicTrial() end

---*Server only*  
---Completes a challenge level and saves progression.  
---@param level Uuid # The level's uuid.
---@param time number # The completion time.
---@param save table # A table containing save data.
function sm.challenge.levelCompleted(level, time, save) end

---*Server only*  
---Resolves a path containing $CONTENT_DATA to path that can be accessed in the main scripting environment.  
---@param path string # The path containing $CONTENT_DATA.
---@return string # The resolved path.
function sm.challenge.resolveContentPath(path) end

---*Server only*  
---Starts challenge.  
---@param world World
function sm.challenge.start(world) end

---*Server only*  
---Stops challenge.  
function sm.challenge.stop() end

---*Server only*  
---Takes a picture of the challenge level with a custom resolution.  
---@param width integer # Preview width.
---@param height integer # Preview height.
---@param rotation integer # Rotation step.
function sm.challenge.takePicture(width, height, rotation) end

---*Server only*  
---Takes pictures of the challenge level to use as icon and preview.
function sm.challenge.takePicturesForMenu() end

---Used to save and load blueprints displayed in the menu.  
sm.menuCreation = {}

---*Server only*  
---Loads the users menu creation blueprint and returns it as a table.  
---@return table # Users menu creation blueprint table.
function sm.menuCreation.load() end

---*Server only*  
---Saves the users menu creation blueprint.
---@param blueprints string[]  
function sm.menuCreation.save(blueprints) end


---A <strong>portal</strong> moves objects inside a box to another box in another place.  
sm.portal = {}

---*Server only*  
---Adds a hook that a new world can find to hook up the other side of a portal.  
---@param world World # The target world.
---@param name string # The portal name.
---@param portal Portal # The portal.
function sm.portal.addWorldPortalHook(world, name, portal) end

---*Server only*  
---Creates a new portal.  
---@param dimensions Vec3 # The dimensions of the portal box.
---@return Portal # The created portal.
function sm.portal.createPortal(dimensions) end

---*Server only*  
---Destroys a portal.  
---@param portal Portal # The portal to be destroyed.
function sm.portal.destroy(portal) end

---Finds the portal position that has the best path to the given world.  
---@param playerWorld integer # The player's current world id.
---@param targetWorld integer # The world id we wanna get a path towards.
---@param fromPosition Vec3 # The position we wanna get a path from.
---@return Vec3, Portal # The position of the portal, and the portal with the shortest path to the given world.
function sm.portal.findBestPortalToWorld(playerWorld, targetWorld, fromPosition) end

---*Server only*  
---Finds and pops world hook for this world if present.  
---@param name string # The portal name.
---@param world? World # The world to look in (Optional, defaults to world from script context)
---@return Portal # The portal. Nil if nothing was found.
function sm.portal.popWorldPortalHook(name, world) end

---*Server only*  
---Transfers objects inside one B opening to the B opening of another portal.  
---Can be used to make elevators with several floors.  
---Portal sizes and opening A must match (world, position and rotation).  
---@param fromPortal Portal # The portal to transfer from.
---@param toPortal Portal # The portal to transfer to.
---@param filter? integer # A [sm.physics.filter] mask selecting which contents to transfer. Only [sm.physics.filter, dynamicBody], [sm.physics.filter, staticBody] and [sm.physics.filter, character] are meaningful. Defaults to transferring bodies and characters. (Optional)
---@return boolean # True if successful, false on failure.
function sm.portal.transferBToB(fromPortal, toPortal, filter) end


---Harvestable creation  
sm.harvestable = {}

---@deprecated Use createHarvestable instead
---Create a new harvestable  
---@param uuid Uuid # The uuid of the harvestable.
---@param position Vec3 # The harvestable's world position.
---@param rotation? Quat # The harvestable's world rotation, optional uses identity rotation if nil.
---@param slopeNormal? Vec3 # The harvestable's slope normal. For "skew" and "rotate" slope settings, optional uses z axis if nil.
---@return Harvestable # The created harvestable.
function sm.harvestable.create(uuid, position, rotation, slopeNormal) end

---*Server only*  
---Create a new harvestable  
---@param uuid Uuid # The uuid of the harvestable.
---@param position Vec3 # The harvestable's world position.
---@param rotation? Quat # The harvestable's world rotation, optional uses identity rotation if nil.
---@param slopeNormal? Vec3 # The harvestable's slope normal. For "skew" and "rotate" slope settings, optional uses z axis if nil.
---@param world? World # The world to create the harvestable in. Defaults to the world of the script.
---@return Harvestable # The created harvestable.
function sm.harvestable.createHarvestable(uuid, position, rotation, slopeNormal, world) end

---Returns a table with all the harvestables in the world.  
---@param world? World # The world, will default to the script's world. (optional)
---@return Harvestable[] # The table of all harvestables. {[Harvestable], ..}
function sm.harvestable.getAllHarvestables(world) end

---Gets a kinematic matching the provided initial hash if it exists.  
---@param initialHash number # The initial hash to search for.
---@return Harvestable kinematic The kinematic if it exists.
function sm.harvestable.getKinematicByInitialHash(initialHash) end


sm.lift = {}

---*Server only*  
---Creates a non-player lift. A non-player lift is a lift that doesn't belong to any player.   
---return	[Lift]:						The created lift.  
---@param world World # World to place the lift in.
---@param pos Vec3 # Position to place the lift at.
---@param body? Body # Body to place on the lift (optional).
---@param level? integer # Level to place the lift at. (Defaults to 0.)
---@param rotation? integer # Rotation index to place the lift at. (Defaults to 0.)
function sm.lift.createNonPlayerLift(world, pos, body, level, rotation) end

---*Server only*  
---Creates a virtual lift. A virtual lift is a lift that doesn't exist in the game world. But allows for a static body to be placed on it.  
---return	[Lift]:					The created lift.  
---@param world World # World to place the lift in.
---@param body Body # Body to place on the lift.
function sm.lift.createVirtualLift(world, body) end


---The <strong>Construction</strong> api is used for interacting with the shape construction system.   
sm.construction = {}

---Constants used by the construction system.  
--- - <strong>subdivideRatio</strong> &ndash; The physical size of one block.
--- - <strong>subdivideRatio_2</strong> &ndash; The physical size of one block divided by two.
--- - <strong>subdivisions</strong> &ndash; One dividided by subdivideRatio.
--- - <strong>shapeSpacing</strong> &ndash; Bias value.
---subdivideRatio	0.25  
---subdivideRatio_2	0.125  
---subdivisions	4  
---shapeSpacing	0.004	  
sm.construction.constants = {
    shapeSpacing = 0.004,
    subdivideRatio = 0.25,
    subdivideRatio_2 = 0.125,
    subdivisions = 4
}

---*Server only*  
---Builds a block on an object.  
---@param uuid Uuid # The uuid of the block to build.
---@param localPosition Vec3 # The position to build the block on.
---@param object? Lift|Shape|Joint
function sm.construction.buildBlock(uuid, localPosition, object) end


---Validates if an object can be built on another object.  
---@param uuid Uuid # The uuid of the shape to validate.
---@param localPosition Vec3 # The position local to the body.
---@param localNormal Vec3 # The normal of the surface to validate placement.
---@param object? Lift|Shape|Joint # The object to build on.
---@return boolean # True if position is valid.
function sm.construction.validateLocalPosition(uuid, localPosition, localNormal, object) end

---ScriptableObject creation  
sm.scriptableObject = {}

---*Server only*  
---Create a new Scriptable Object.  
---@param uuid Uuid # ScriptableObject uuid.
---@param params? any # self.params on scriptable object.
---@param world? World # The world this script belongs to, for world dependent api calls. Defaults to [sm.world.ids, sm.world.ids.noWorld]
---@return ScriptableObject # The scriptable object.
function sm.scriptableObject.createScriptableObject(uuid, params, world) end


---ScriptableObject creation  
sm.clientScriptableObject = {}

---*Client only*  
---Create a new client Scriptable Object.  
---@param uuid Uuid # ScriptableObject uuid.
---@param params? any # self.params on scriptable object.
---@param world? World # The world this script belongs to, for world dependent api calls. Defaults to [sm.world.ids, sm.world.ids.noWorld]
---@return ScriptableObject # The scriptable object.
function sm.clientScriptableObject.createScriptableObject(uuid, params, world) end


---Builder Guide  
sm.builderGuide = {}

---Create a [BuilderGuide], comparing the creation from the root [Shape] to the blueprint given by the path.  
---@param path string # A file path to the builder guide blueprint.
---@param shape Shape # Root [Shape] for comparing the creation from.
---@param ignoreBlockUuid? boolean # Should block uuid be ignored for stage completion. (Defaults to false)
---@param recordErrors? boolean # Should errors be recorded. Needed for getErrorInfo (Defaults to false)
---@param allowExtraBlocks? boolean # Should extra blocks be ignored for stage completion. (Defaults to true)
---@return BuilderGuide # The created guide.
function sm.builderGuide.createBuilderGuide(path, shape, ignoreBlockUuid, recordErrors, allowExtraBlocks) end


---A <strong>cull sphere group</strong> is a collection of spheres that can be efficiently queried for.   
sm.cullSphereGroup = {}

---Creates a sphere group.  
---@return CullSphereGroup # sphereGroup		The sphere group.
function sm.cullSphereGroup.newCullSphereGroup() end


sm.jsonGui = {}

---Creates a new gui.  
---@param settings? GuiSettings # Table with bool settings for: isHud, isInteractive, needsCursor, hidesHotbar, isOverlapped, backgroundAlpha, handleKeySetup, name, layer
---@return JsonGui # gui		The gui
function sm.jsonGui.createGui(settings) end

---*Client only*  
---Returns the size of the window in 720 coords.  
---@return integer,integer # The view size as width and height.
function sm.jsonGui.getViewSize() end


---The <strong>effect</strong> api handles the creation and playing of audio and visual effects.  
---Effects can consist of multiple components each being of separate types and with unique offsets, rotations and delays.  
---For more information on how to setup effects please take a look in the Effects/Database/EffectSets folder in the game data.  
sm.effect = {}

---Rotation axis removal types for hosted effects. Not combinable
sm.effect.axis = {
    none = 0,
    xaxis = 1,
    yaxis = 2,
    zaxis = 3,
    all = 4,
}

---All of the vanilla effect names that can be used with sm.effect functions. If the effect doesnt play, then the effect isnt present in the current gamemode. (Can be fixed by adding it to your effect set)
---@alias EffectName
---| "DestructableTape - TapeRoll"
---| "DestructableTape - TapeRollBig"
---| "DestructableTape - cocoon01"
---| "DestructableTape - cocoon02"
---| "Explosion - Debris"
---| "PropaneTank - SingleActivate"
---| "Resourcecollector - PutIn"
---| "MountedPotatoRifle - Shoot"
---| "Resourcecollector - TakeOut"
---| "Beacon - Idle"
---| "PropaneTank - ActivateSmall"
---| "PropaneTank - ExplosionBig"
---| "BubbleBath"
---| "PropaneTank - ExplosionSmall"
---| "NoteTerminal - Interact"
---| "PropaneTank - ActivateBig"
---| "PistonExhaust"
---| "PowerSocket - Activate"
---| "DestructableTape - Tape"
---| "NoteTerminal - Active"
---| "DestructableTape - TapeCorner"
---| "Mountedwatercanon - Shoot"
---| "DestructableTape - TapeCornerBig"
---| "DestructableTape - DoorwayDestruction"
---| "SledgehammerHit - Default"
---| "Collision - Impact"
---| "Collision - SlidingA"
---| "Collision - SlidingB"
---| "Projectile - Destroy"
---| "Collision - RollingA"
---| "Collision - RollingB"
---| "Projectile - Hit"
---| "Character - Hit"
---| "Weapon - Impact"
---| "Sledgehammer - NoProgress"
---| "Sledgehammer - Hit"
---| "Sledgehammer - Destroy"
---| "Projectile - HitWater"
---| "Eat - Drink"
---| "Eat - DrinkFinish"
---| "Multiknife - Use"
---| "Eat - DrinkSound"
---| "Eat - EatFinish"
---| "Eat - Munch"
---| "Eat - MunchFP"
---| "PaintTool - Close"
---| "Itemtool - FPFertilizerUse"
---| "PaintTool - Open"
---| "Itemtool - FertilizerUse"
---| "Mechanic - ReciveBaguette"
---| "Multiknife - Complete"
---| "Multiknife - Hit"
---| "PaintTool - Paint"
---| "PaintTool - NoAmmo"
---| "Mechanic - EatBaguette"
---| "BearingDrill - Use"
---| "Eat - MunchSound"
---| "Critter - Fly"
---| "Critter - NightMoth"
---| "Critter - Rottingsmoke"
---| "AtmosphericDust"
---| "ChallengeAmbience"
---| "Forest - LeafsBlowing"
---| "Forest - MassiveFog"
---| "Forest - SmallFog"
---| "Hideout - Smoke"
---| "Lakes - Floatingdebri"
---| "Lakes - bubbles"
---| "OutdoorAmbience"
---| "Water - Waterleak02"
---| "Water - Waterleak01"
---| "ChemicalLakes - SurfaceBubblesSmall"
---| "ChemicalLakes - SurfaceBubblesBig"
---| "Critter - Butterfly01"
---| "Forest - Fireflies"
---| "Critter - Butterfly02"
---| "Forest - Grassblowing"
---| "flies01"
---| "flies02"
---| "butterfly"
---| "Tree - CrownCollapse"
---| "Tree - CrownCollapse Pine"
---| "Tree - CrownCollapse Spurce"
---| "Tree - BreakTrunk Pine"
---| "Tree - BreakTrunk PineHalf"
---| "Tree - BreakTrunk PineQuarter"
---| "Tree - BreakTrunk Spruce"
---| "Tree - BreakTrunk SpruceHalf"
---| "Tree - BreakTrunk Birch"
---| "Stone - BreakChunk small"
---| "Stone - BreakChunk"
---| "Stone - CrackRock"
---| "FreshLight"
---| "HeadLight"
---| "PackingtableLight"
---| "PosterLight"
---| "ShackLight"
---| "AreaLight"
---| "ConstructionLight"
---| "EncryptorLight"
---| "EnvironmentAmbientLight_Large"
---| "EnvironmentSpotLight_Static_Large"
---| "EnvironmentAmbientLight_Medium"
---| "EnvironmentAmbientLight_Small"
---| "EnvironmentPointLight_Static_Medium"
---| "EnvironmentSpotLight_Dynamic_Medium"
---| "EnvironmentSpotLight_Dynamic_Small"
---| "FactoryLight"
---| "EnvironmentSpotLight_Static_Medium"
---| "EnvironmentSpotLight_Static_Small"
---| "FloodLight"
---| "FluorescentLight"
---| "Fire -medium01"
---| "Fire -medium01_putout"
---| "Fire- Smoke Medium01"
---| "FireColorTest"
---| "Smoke - GroundSmokeMassive"
---| "Fire - large01"
---| "Smoke - ash"
---| "Smoke - blowing01"
---| "Smoke - blowing02"
---| "Smoke - blowing03"
---| "Smoke - embers"
---| "Fire - gradual"
---| "Smoke - pillar01"
---| "Smoke - pillar02"
---| "Fire - large01_putout"
---| "Steam - quench"
---| "Fire - lowburn"
---| "Smoke - pillar03"
---| "Fire - Shipwreck"
---| "Fire - small01"
---| "Fire - vertical"
---| "Water - HitWaterMassive"
---| "Water - HitWaterBig"
---| "Water - HitWaterSmall"
---| "Water - HitWaterTiny"
---| "Water - splash02"
---| "Water - BucketGetWater"
---| "Water - WaterProjectileTrail"
---| "Water - splash01"
---| "GasEngine - Level 3"
---| "GasEngine - Level 4"
---| "GasEngine - Level 1"
---| "GasEngine - Level 5"
---| "GasEngine - Scrap"
---| "GasEngine - Level 2"
---| "Thruster - Level 1"
---| "Thruster - Level 4"
---| "Thruster - Level 3"
---| "Thruster - Level 5"
---| "Thruster - Ground effect"
---| "Thruster - Level 2"
---| "ElectricEngine - Level 1"
---| "ElectricEngine - Level 2"
---| "ElectricEngine - Level 3"
---| "ElectricEngine - Level 5"
---| "ElectricEngine - Level 4"
---| "Suspension - Level 3"
---| "Suspension - Level 4"
---| "Suspension - Level 5"
---| "Suspension"
---| "Suspension - Level 1"
---| "Suspension - Level 2"
---| "Sensor on - Level 3"
---| "Sensor on - Level 4"
---| "Sensor on - Level 5"
---| "Sensor off"
---| "Sensor on"
---| "Sensor off - Level 1"
---| "Sensor off - Level 2"
---| "Sensor off - Level 3"
---| "Sensor off - Level 4"
---| "Sensor off - Level 5"
---| "Sensor on - Level 1"
---| "Sensor on - Level 2"
---| "Mechanic - Swimforeward"
---| "Mechanic - HurtDrown"
---| "Mechanic crouch"
---| "Mechanic - Hurthunger"
---| "Mechanic - Hurtshock"
---| "Mechanic - KoLoop"
---| "Mechanic - HurtFire"
---| "Mechanic land"
---| "Mechanic - Hurtpoision"
---| "Mechanic walk"
---| "Mechanic - JetpackBurstThruster"
---| "Mechanic - JetpackThruster"
---| "Mechanic underwater"
---| "Mechanic jump"
---| "Mechanic getUp"
---| "Mechanic - MeleeHit"
---| "Mechanic - StatusHungry"
---| "Mechanic crouch walk"
---| "Mechanic - StatusThirsty"
---| "Mechanic - StatusUnderwater"
---| "Mechanic - Ko"
---| "Mechanic - Swimbackward"
---| "Mechanic - Hurt"
---| "Controller - Level 5"
---| "Controller - Default"
---| "Controller - Level 1"
---| "Controller - Level 2"
---| "Controller - Level 3"
---| "Controller - Level 4"
---| "TomatoProjectile - Hit"
---| "GlowstickProjectile - Bounce"
---| "WaterProjectile - Hit"
---| "GlowstickProjectile - Hit"
---| "OrangeProjectile - Hit"
---| "BananaProjectile - Hit"
---| "PesticideProjectile - Attached"
---| "BlueberryProjectile - Hit"
---| "Pesticide - Cloud"
---| "BroccoliProjectile - Hit"
---| "CarrotProjectile - Hit"
---| "TapeProjectile - Hit"
---| "PineappleProjectile - Hit"
---| "TapeProjectile - Attached"
---| "ChemicalProjectile - Hit"
---| "RedbeetProjectile - Hit"
---| "FertilizerProjectile - Attached"
---| "PotatoProjectile - Hit"
---| "FertilizerProjectile - Hit"
---| "ChemicalProjectile - Attached"
---| "GlowstickProjectile - Attached"
---| "PesticideProjectile - Hit"
---| "Piston - Level 1"
---| "Piston - Level 2"
---| "Piston - Level 3"
---| "Piston - Level 4"
---| "Piston - Level 5"
---| "Piston - Default"
---| "Shipwreck - sparks03"
---| "ShipFire - large01"
---| "ShipFire - lowburn"
---| "ShipFire - medium01"
---| "Shipwreck - AmbianceSound"
---| "Shipwreck - sparks02"
---| "Shipwreck - sparks01"
---| "Fence - PlankCornerDestruction"
---| "Fence - PlankLongDestruction"
---| "Fence - FarmPlank04Destruction"
---| "Fence - FarmPlank01Destruction"
---| "Fence - FarmPlank03Destruction"
---| "Fence - FarmPlank02Destruction"
---| "Sign - HideoutSign07 Destruction"
---| "Fence - HideoutFence02 Destruction"
---| "Sign - HideoutSign04 Destruction"
---| "Fence - HideoutFence04 Destruction"
---| "Sign - HideoutSign03 Destruction"
---| "Fence - HideoutFence05 Destruction"
---| "Fence - PlankShortDestruction"
---| "Fence - HideoutFence06 Destruction"
---| "Fence - HideoutFence01 Destruction"
---| "EpicLootProjectile - Hit"
---| "LootCrate - Destroy"
---| "Loot - AudioLogfiles"
---| "Loot - GlowItem"
---| "Loot - Pickup"
---| "LootProjectile - Hit"
---| "Loot - Logentry"
---| "Loot - Logentryactivate"
---| "Loot - LogfilesPickup"
---| "Loot - OutfitCommonGlowItem"
---| "Loot - OutfitCommonPickup"
---| "LootProjectile - Attached"
---| "Loot - OutfitEpicGlowItem"
---| "LootCrate - EpicDestroy"
---| "Loot - OutfitEpicPickup"
---| "LootCrate - DestroyGlow"
---| "Loot - OutfitRareGlowItem"
---| "Loot - Logbook"
---| "Loot - OutfitRarePickup"
---| "EpicLootProjectile - Attached"
---| "EpicLoot - GlowItem"
---| "Loot - PictureLogfiles"
---| "Plants - Picked"
---| "Plants - Destroyed"
---| "Plants - Planted"
---| "Plants - Done"
---| "Plants - SoilbagUse"
---| "Plants - Fertilizer"
---| "Packingstation - Load"
---| "Packingstation - Orange"
---| "Packingstation - Activate"
---| "Packingstation - Pineapplecrate"
---| "Packingstation - ActivateSound"
---| "Packingstation - Redbeetcrate"
---| "Packingstation - Bananacrate"
---| "Packingstation - Tomatocrate"
---| "Packingstation - Blueberrycrate"
---| "Packingstation - Shoot"
---| "Packingstation - Brocolicrate"
---| "Packingstation - Roller"
---| "Packingstation - Carrotcrate"
---| "Craftbot - Unpack"
---| "Refinery - WorkMetal"
---| "Craftbot - Work"
---| "Craftbot - Work01"
---| "Refinery - WorkWood"
---| "Craftbot - Work02"
---| "Workbench - Idle"
---| "Craftbot - Work02Torch"
---| "Dispenserbot - Work01"
---| "DispenserbotSpawner - Spawn"
---| "Dressbot - Finish"
---| "Dressbot - HeadWork01"
---| "Dressbot - Idle"
---| "Dressbot - Opendoors"
---| "Workbench - Work01"
---| "Dressbot - Start"
---| "Workbench - Finish"
---| "Dressbot - Work01"
---| "Refinery - WorkStone"
---| "Refinery - WoodBlockLog"
---| "Cookbot - Idle"
---| "Refinery - WoodBlock"
---| "Refinary - Area"
---| "Refinery - Unpack"
---| "Refinery - Finish"
---| "Cookbot - Finish"
---| "Cookbot - Start"
---| "Refinery - MetalBlock"
---| "Cookbot - IdleSpecial01"
---| "Cookbot - Unpack"
---| "Refinery - ScrapWoodBlockLog"
---| "Cookbot - Work"
---| "Refinery - ScrapWoodBlock"
---| "Cookbot - Work01"
---| "Refinery - ScrapStoneBlockLog"
---| "Cookbot - Work02"
---| "Refinery - ScrapStoneBlock"
---| "Cookbot - Work03"
---| "Refinery - ScrapMetalBlockLog"
---| "Cookbot - Work03Salt"
---| "Refinery - ScrapMetalBlock"
---| "Craftbot - Finish"
---| "Refinery - MetalBlockLog"
---| "Refinery - Start"
---| "Craftbot - Idle"
---| "Refinery - SuckStart"
---| "Craftbot - IdleSpecial01"
---| "Cookbot - IdleSpecial02"
---| "Craftbot - IdleSpecial02"
---| "Dressbot - Work02"
---| "Craftbot - Start"
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
---| "Treeparts - birch01_p05"
---| "Treeparts - birch02_p04"
---| "Treeparts - birch02_p05"
---| "Treeparts - birch02_p06"
---| "Treeparts - birch03_p02"
---| "Treeparts - birch03_p03"
---| "Treeparts - birch03_p04"
---| "Treeparts - birch03_p05"
---| "Treeparts - birch03_p06"
---| "Treeparts - leafy01_p02"
---| "Treeparts - leafy01_p04"
---| "Treeparts - leafy02_p02"
---| "Treeparts - leafy02_p03"
---| "Treeparts - leafy02_p04"
---| "Treeparts - leafy02_p05"
---| "Treeparts - leafy02_p06"
---| "Treeparts - leafy02_p07"
---| "Treeparts - leafy03_p02"
---| "Treeparts - leafy03_p03"
---| "Treeparts - leafy03_p05"
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
---| "Treeparts_burntforest - spruce04"
---| "Treeparts_burntforest - spruce05"
---| "Treeparts_burntforest - spruce03"
---| "Treeparts_burntforest - spiketree01"
---| "Treeparts_burntforest - birch01"
---| "Treeparts_burntforest - spiketree02"
---| "Treeparts_burntforest - spruce01"
---| "Treeparts_burntforest - spruce02"
---| "Glowgorp - Idlesound"
---| "Glowgorp - Jump"
---| "Glowgorp - Pickup"
---| "Glowgorp - Hit"
---| "Glowgorp - Destruct"
---| "Glowgorp - Cardboardmunch"
---| "Glowgorp - Walk"
---| "Saw - SawBlade"
---| "Drill - Debris"
---| "Saw - Debris"
---| "Drill - StoneDrill"
---| "Vacuumpipe - Suction"
---| "Vacuumpipe - Blowout"
---| "Leafpile - Destruction"
---| "Haypile - Destruction"
---| "Part - Upgrade"
---| "Part - Electricity"
---| "Part - Removed"
---| "SpudgunSpinner - SpinnerMuzzel"
---| "SpudgunSpinner - FPSpinnerMuzzel"
---| "SpudgunSpinner - Windup"
---| "SpudgunBasic - DefaultImpact01"
---| "SpudgunBasic - BasicMuzzel"
---| "SpudgunFrier - FrierMuzzel"
---| "SpudgunFrier - FPFrierMuzzel"
---| "SpudgunBasic - FPBasicMuzzel"
---| "Hideout - PumpSuction"
---| "Encryptor - Deactivation"
---| "Barrier - ShieldImpact"
---| "Barrier - Activation"
---| "Encryptor - Activation"
---| "Barrier - SledgeHammerHit"
---| "Barrier - Deactivation"
---| "Watercannon - Impact"
---| "Watercannon - Muzzeflash"
---| "Gui - PlayButtonShine"
---| "Gui - DressbotCollect"
---| "Gui - DressbotDone"
---| "Gui - DressbotUnboxCommon"
---| "Gui - Test"
---| "Gui - UnboxItem"
---| "Gui - DressbotUnboxEpic"
---| "Gui - Upgrade"
---| "Gui - UpgradeIcon"
---| "Gui - CraftingDone"
---| "Gui - CraftingDoneCollectButton"
---| "Gui - DressbotUnboxGarmentButton"
---| "Gui - Setwaypoint Loop"
---| "Gui - DressbotUnboxGarmentButtonActivate"
---| "Gui - Setwaypoint Flash"
---| "Gui - DressbotUnboxRare"
---| "Gui - CustomizationRewardItem"
---| "Gui - LogbookIcon Flash"
---| "Gui - DressbotBackground"
---| "Gui - LogbookNotification"
---| "Gui - DressbotBox"
---| "Gui - LogbookPhotograph Flash"
---| "Gui - CuztomizeMainMenuShine"
---| "Unbox - glowworm01"
---| "Unbox - Tapebot01"
---| "Unbox - woc01"
---| "Unbox - Totebot01"
---| "Unbox - Haybot01"
---| "Unbox - Farmbot01"
---| "Paintcharacter - Large"
---| "Paintcharacter - Small"
---| "Paintcharacter - Erase"
---| "Paintcharacter - Medium"
---| "Arrow"
---| "Robotparts - FarmbotHead"
---| "Robotparts - HaybotHead"
---| "Robotparts - FarmbotCannonarm"
---| "Robotparts - HaybotBody"
---| "Robotparts - FarmbotDrill"
---| "Robotparts - HaybotPelvis"
---| "Robotparts - FarmbotScyth"
---| "Robotparts - HaybotFork"
---| "Robotparts - TapebotLeftarm"
---| "Robotparts - RedtapebotHead"
---| "Robotparts - TapebotTorso"
---| "Robotparts - TotebotBody"
---| "Robotparts - TapebotHead"
---| "Robotparts - TotebotLeg"
---| "Builderguide - Active"
---| "Builderguide - Deactivate"
---| "Builderguide - Background"
---| "Builderguide - Stagecomplete"
---| "Builderguide - Buildcomplete"
---| "Horn - Honk"
---| "TapeBot - AlertedServo"
---| "TapeBot - ChasingFotStep"
---| "TapeBot - ChasingGunRattle"
---| "TapeBot - ChasingScissor"
---| "TapeBot - ChasingServo"
---| "TapeBot - FotStep"
---| "TapeBot - Hit"
---| "TapeBot - Scissor"
---| "TapeBot - Servo"
---| "RedTapeBot - ExplosivesHit"
---| "TapeBot - Alerted"
---| "TapeBot - AlertedFotStep"
---| "TapeBot - Shoot"
---| "TapeBot - AlertedGunRattle"
---| "TapeBot - Destroyed"
---| "TapeBot - AlertedScissor"
---| "TapeBot - HeadShot"
---| "Woc - Run"
---| "Woc - Walk"
---| "Woc - Eating"
---| "Woc - Destruct"
---| "Woc - Moo"
---| "Woc - Panic"
---| "SurvivalMusic"
---| "WarehouseAmbiance"
---| "UnderwaterAmbiance"
---| "ElevatorAmbiance"
---| "Elevator - MoveOutside"
---| "ElevatorMusic"
---| "Elevator - Opendoor"
---| "ElevatorWall"
---| "Elevator - Closedoor"
---| "Elevator Button"
---| "Elevator - Keycarduse"
---| "Corn - Destruct"
---| "Harvestable - Marker"
---| "beehive - beeswarm"
---| "beehive - destruct"
---| "Harvestable - Burnttree"
---| "Oilgeyser - OilgeyserPickedLoop"
---| "Tree - BirchHit"
---| "SlimyClam - Bubbles"
---| "Cotton - Picked"
---| "SlimyClam - BubblesAmbience"
---| "SlimyClam - Destruct"
---| "Pigmentflower - Picked"
---| "Stone - Stress"
---| "Oilgeyser - Picked"
---| "Cotton - Fluff"
---| "Tree - BurnedHit"
---| "Tree - Ambient Birds"
---| "Tree - LeafRattle"
---| "Tree - Falling"
---| "Tree - DefaultHit"
---| "Oilgeyser - OilgeyserLoop"
---| "Tree - Creak"
---| "Oilgeyser - OilgeyserAmbience"
---| "Tree - LogAppear"
---| "ToteBot - Attack"
---| "ToteBot - Sparks"
---| "ToteBot - FotStep"
---| "ToteBot - SparkAttack"
---| "ToteBot - DestroyedParts"
---| "ToteBot - ChasePlayer"
---| "ToteBot - Alerted"
---| "ToteBot - Hit"
---| "Haybot - ForkStep"
---| "Haybot - Alerted"
---| "Haybot - FotStep"
---| "Haybot - Attack01"
---| "Haybot - Hit"
---| "Haybot - IdleSpecial01"
---| "Haybot - Attack02"
---| "Haybot - IdleSpecial02"
---| "Haybot - Destroyed"
---| "Haybot - Attack03"
---| "Haybot - Metal"
---| "Haybot - Servo"
---| "Haybot - CaseplayerVoice"
---| "Haybot - SprintAttack"
---| "Farmbot - RoamingIdle"
---| "Farmbot - RunBody"
---| "Farmbot - DestructionStartup01"
---| "Farmbot - DestructionStartup02"
---| "Farmbot - Attack04"
---| "Farmbot - Attack02"
---| "Farmbot - Attack05"
---| "Farmbot - DestructionStartup04"
---| "Farmbot - Shoot"
---| "Farmbot - FotStepHeavy"
---| "Farmbot - Voice"
---| "Farmbot - FotStepLight"
---| "Farmbot - SprintBody"
---| "Farmbot - FotStepMedium"
---| "Farmbot - Hit"
---| "Farmbot - Attack03"
---| "Farmbot - Destroyed"
---| "Farmbot - MoveHead"
---| "Farmbot - DestructionStartup03"
---| "Farmbot - MoveLegs"
---| "Farmbot - Angry"
---| "Farmbot - RattleSyth"
---| "Farmbot - Attack01"
---| "ShapeRenderable"
---| "CustomizationRenderable"
---| "Glowstick - Throw"
---| "Glowstick - Hold"
---| "Bucket - Fill"
---| "Bucket - Throw"
---| "FarmerBall - Struggle"
---| "Farmerhideout - Accept"
---| "FarmerBall - Help"
---| "Farmerhideout - Open"
---| "FarmerBall - Rolling"
---| "Farmerhideout - Close"
---| "Guiquest - Questupdate"
---| "Questmarker - Pointmarker"
---| "Questmarker - Pointmarker_small"
---| "Guiquest - Newquest"
---| "Questmarker - Zonearea"
---| "Questmarker - Pointmarker_large"
---| "Guiquest - Pausestarterquest"
---| "Cinematic - Survivalstart02"
---| "Cinematic - Survivalstart01"
---| "Supervisor - Generic"
---| "CelebrationBot - Confetti"
---| "Celebrationbot - Activate"
---| "ChallengeCrowd - Jump"
---| "Characterspawner - Activate"
---| "Chest - Arrow"
---| "Goal - Activate"
---| "Goal - Oncreate"
---| "Boop - Floor"
---| "MapInspector - On"
---| "ObserverBot - Move"
---| "ObserverBot - Write"
---| "Balltrigger - Activate"
---| "PlayerStart - Glow"
---| "BuildMode - Floor"
---| "SmallGoal - Activate"
---| "Ballspawner - Activate"
---| "Buildarea - Oncreate"
---| "Soundcube - Activate"
---| "Supervisor - Cheer"
---| "Ball"
---| "Supervisor - Fail"
---| "CelebrationBot - Audio"
---| "Builderbot - Thruster"
---| "Cinematic - Challengemodecomplete"
---| "Cinematic - Challengemodecomplete_audio"
---| "Challengecamera - Puzzlelevel_04"
---| "Challengecamera - Puzzlelevel_05"
---| "Challengecamera - Puzzlelevel_06"
---| "Challengecamera - Puzzlelevel_07"
---| "Challengecamera - Puzzlelevel_08"
---| "Challengecamera - Puzzlelevel_09"
---| "Challengecamera - Puzzlelevel_10"
---| "Challengecamera - TutorialLevel_10"
---| "Challengecamera - Stuntlevel_01"
---| "Challengecamera - Stuntlevel_02"
---| "Challengecamera - TutorialLevel_09"
---| "Challengecamera - Stuntlevel_03"
---| "Challengecamera - Stuntlevel_04"
---| "Challengecamera - Stuntlevel_05"
---| "Challengecamera - TutorialLevel_08"
---| "Challengecamera - TutorialLevel_07"
---| "Challengecamera - Stuntlevel_06"
---| "Challengecamera - Stuntlevel_07"
---| "Challengecamera - Stuntlevel_08"
---| "Challengecamera - Stuntlevel_09"
---| "Challengecamera - Stuntlevel_10"
---| "Challengecamera - TutorialLevel_01"
---| "Challengecamera - TutorialLevel_04"
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
---| "Challengecamera - Potatolevel_01"
---| "Challengecamera - Potatolevel_10"
---| "Challengecamera - Puzzlelevel_01"
---| "Challengecamera - Puzzlelevel_02"
---| "Challengecamera - Puzzlelevel_03"
---| "Gui - Challengemode Stuntmanbackgroundshine"
---| "Gui - Challengemode Approvedbannershine"
---| "Gui - Stuntmancollectpressed"

---*Client only*  
---Creates an effect.  
---If you provide a host object to the effect then it will fetch position, velocity and orientation data from the interactable instead of relying on this information being fed to it.  
---This results in far more accurate positioning of effects that are supposed to stay attached to an object.  
---@param name string|EffectName The name.
---@param object? Interactable|Shape|Character|Harvestable The object the effect is attached to.
---@param boneName? string The bone name. (Defaults to not attached to a bone) (Optional)
---@param axis? integer # The axis of which the effect will ignore the hosts rotation around. (Defaults to [sm.effect.axis, sm.effect.axis.none]) (Optional)
---@return Effect
function sm.effect.createEffect(name, object, boneName, axis) end

---*Client only*  
---Creates an 2d effect.  
---@param name string|EffectName The name of the effect.
---@return Effect
function sm.effect.createEffect2D(name) end

---*Client only*  
---Creates an effect that is only visible in the first person scene.  
---@param name string # The name of the effect.
---@return Effect # The created effect.
function sm.effect.createEffectFirstPerson(name) end

---*Client only*  
---Creates an Sky effect.  
---@param name string # The name of the effect.
---@return Effect # The created effect.
function sm.effect.createEffectSky(name) end

---*Client only*  
---Estimates the radius of influence for an effect and instance parameters  
---@param name string|EffectName The name of the effect.
---@param parameters table Table of params
---@return number
function sm.effect.estimateSize(name, parameters) end

---Plays an effect. If this function is called on the server it will play the effect on all clients.  
---**Note:**
---*If you start a looping effect using this function you will not be able to stop it.<br>Please use [sm.effect.createEffect, createEffect] for looping effects.*
---@param name string|EffectName # The name.
---@param position? Vec3 # The position. (Defaults to [0,0,0])
---@param velocity? Vec3 # The velocity. (Defaults to no velocity)
---@param rotation? Quat # The rotation. (Defaults to no rotation)
---@param scale? Vec3 # The scale. (Defaults to no scale, only applied to renderables)
---@param parameters? table # The table containing the parameters for the effect. (Defaults to no parameters)
---@param startTime? number # The initial time progression of the effect. Can be used to fast forward some effect parts. Can be used to delay effect part activation if negative.
---@param world? World # The world to play the effect in. (Defaults to [World] from script context)
function sm.effect.playEffect(name, position, velocity, rotation, scale, parameters, startTime, world) end

---*Client only*  
---Plays an effect. It will fetch position, velocity and orientation data from the host object.  
---**Note:**
---*If you start a looping effect using this function you will not be able to stop it.<br>Please use [sm.effect.createEffect, createEffect] for looping effects*
---@param name string # The effect name.
---@param object? Interactable|Shape|Character|Harvestable # The object the effect is attached to.
---@param boneName? string # The bone name. (Optional)
---@param parameters? table # The table containing the parameters for the effect. (Optional)
---@param axis? integer # The axis of which the effect will ignore the hosts rotation around. (Defaults to [sm.effect.axis, sm.effect.axis.none]) (Optional)
---@param startTime? number # The initial time progression of the effect. Can be used to fast forward some effect parts. Can be used to delay effect part activation if negative.
---@param offsetPosition? Vec3 # The host object relative offset position. (Defaults to sm.vec3.zero())
---@param offsetRotation? Quat # The host object relative offset rotation. (Defaults to sm.quat.identity())
---@param scale? Vec3 # The scale, only applied to renderables. (Defaults to sm.vec3.one())
function sm.effect.playHostedEffect(name, object, boneName, parameters, axis, startTime, offsetPosition, offsetRotation, scale) end

---<strong>Debris</strong> are visual objects that have no impact on any other object.  
sm.debris = {}

---*Client only*  
---Add a black hole that attracts nearby debris towards its position.  
---@param position Vec3 # The position of the black hole.
---@param radius? number # The radius of effect. (Defaults to 10)
---@param force? number # The attraction force. (Defaults to 100)
---@param position2? Vec3 # An optional secondary position, making the black hole a capsule shape instead of a sphere.
---@param wanderForce? number # A force applied along direction from position to position2. (Defaults to 0)
---@param dissolveRadius? number # The radius within which debris will start to dissolve. (Defaults to 0)
---@param timeToLive? number # The time the black hole will be simulated before disappearing. (Defaults to one tick)
---@param channel? number # The channel this black hole affects. Debris only reacts to black holes matching its channel. 0 means no debris is affected. (Defaults to 1)
function sm.debris.createBlackHole(position, radius, force, position2, wanderForce, dissolveRadius, timeToLive, channel) end

---*Client only*  
---Create visual debris of a [Shape, shape] from its [Uuid, uuid], that collides with world objects but does not have an impact on them.  
---@param uuid Uuid # The uuid of the shape.
---@param position Vec3 # The position.
---@param rotation Quat # The rotation.
---@param velocity? Vec3 # The linear velocity. (Defaults to zero)
---@param angularVelocity? Vec3 # The angular velocity in radians per second around the axes (x,y,z). (Defaults to zero)
---@param color? Color # The color. (Defaults to the shape's default color)
---@param timeToLive? number # Time to live. (Defaults to 10)
---@param gravity? number # Gravity vector. (Defaults to { 0,0,-10 })
---@param friction? number # Amount of friction. (Defaults to 1)
---@param linearDamping? number # Amount of linear damping. (Defaults to 0.3)
---@param angularDamping? number # Amount of angular damping. (Defaults to 0.3)
---@param time? number # The time the debris will be simulated before disappearing. (Defaults to 10 seconds)
function sm.debris.createDebris(uuid, position, rotation, velocity, angularVelocity, color, timeToLive, gravity, friction, linearDamping, angularDamping, time) end


---Pipe utility functions.  
sm.pipeGraph = {}

---Pipe direction types      
sm.pipeGraph.direction = {
    any = 0,
    incoming = 1,
    outgoing = 2,
}

---*Client only*  
---Returns a table of shapes on the path between the requesting shape and target container shape.  
---@param requester Shape # The requesting shape.
---@param target Shape # The target container shape.
---@param direction? integer # The direction to fetch in. Defaults to [sm.pipeGraph.direction, sm.pipeGraph.direction.any] (Optional)
---@return Shape[] # shapes			The shapes on the path between requesting shape to target. Requester not included in table.
function sm.pipeGraph.getContainerPath(requester, target, direction) end

---Returns a chest which allows for collection of specified items of the specified quantities.  
---@param requester Shape # The shape connected to the pipe graph who requests the information.
---@param items Uuid[] # The uuids of items to check.
---@param quantities number[] # The number of items of each uuid. Needs to match the number of uuids.	
---@return Shape # container		The shape of the container which was the first one that allows the collection.
function sm.pipeGraph.getContainerShapeToCollectTo(requester, items, quantities) end

---Returns a chest which allows for spending of specific item with a given quantity.  
---@param requester Shape # The shape connected to the pipe graph who requests the information.
---@param item Uuid # The uuid of the target item.
---@param quantities number # The target spending amount.
---@return Shape # container		The shape of the container which was the first one that allows spending.
function sm.pipeGraph.getContainerShapeToSpendFrom(requester, item, quantities) end

---Returns a table of all connected input containers sorted by closest first. If the asking shape doesn't have input and output directions it returns all connected containers.  
---@param requester Shape # The shape connected to the pipe graph who's connected chests you want.
---@return Shape[] containers # A table of connected container shapes sorted by closest first.
function sm.pipeGraph.getInputContainers(requester) end

---*Server only*  
---Returns the remaining of special condition, nil if no data is available.  
---return integer:	remainingTicks	The remaining ticks of the special condition.  
---@param requester Shape # The requesting shape.
function sm.pipeGraph.getInteractableConditionTicks(requester) end

---Returns the containers of all chests connected to the given shape through the pipe connections. Will only return containers from shapes of the same type as the original.  
---@param originInteractable Interactable # The interactable where the search will start from.
---@return Container[] # containers				The container of the originInteractable as well as those of the same type connected through pipes.
function sm.pipeGraph.getMatchingPipedContainers(originInteractable) end

---Returns a table of all connected output containers sorted by closest first. If the asking shape doesn't have input and output directions it returns all connected containers.  
---@param requester Shape # The shape connected to the pipe graph who's connected chests you want.
---@return Shape[] # containers		A table of connected container shapes sorted by closest first.
function sm.pipeGraph.getOutputContainers(requester) end

---*Client only*  
---Releases any glow and UV overrides made by the shape.  
---@param requester Shape # The requesting shape.
function sm.pipeGraph.releaseLightingOverride(requester) end

---*Server only*  
---Removes all stored automated tasks capable of producing the specified item from a producing shape.  
---@param requester Shape # The requesting shape.
---@param item Uuid # The production to stop.
function sm.pipeGraph.removeAutomatedTask(requester, item) end

---*Server only*  
---Removes any stored automated tasks for the requesting shape.  
---@param requester Shape # The requesting shape.
function sm.pipeGraph.removeAutomatedTasks(requester) end

---*Client only*  
---Requests a glow and UV override for pipes between requesting shape and target container.  
---@param requester Shape # The requesting shape.
---@param target Shape # The target container shape.
---@param uvIndex integer # The uv frame index for the affected pipes. Ranges 0 to 3.
---@param glow number # The glow multiplier of the pipes.
function sm.pipeGraph.requestLightingOverride(requester, target, uvIndex, glow) end

---@class Recipe
---@field craftTime number
---@field quantity number
---@field itemId string
---@field externalContainers? Container[] (containers targeted outside pipe graph for consumption, example: refinery)
---@field selfOutputContainer? Container (if the shape has it's own collection container)
---@field ingredientList? table
---@field randomCraftList? table random weighted crafts (see prospector)
---@field specialCrafting? table used to target specific container slots with custom information (see ore crusher).

---*Server only*  
---Sets an automated task to be performed by the pipe graph when the body is unloaded.  
---@param requester Shape # The shape which requests the automated process.
---@param recipe Recipe # A table with information on the recipe. Uses the crafter recipe format. Can have "craftTime", "quantity", "itemId", "externalContainers"(containers targeted outside pipe graph for consumption, example: refinery), "selfOutputContainer"(if the shape has it's own collection container), "ingredientList", "randomCraftList" random weighted crafts (see prospector), "specialCrafting" used to target specific container slots with custom information (see ore crusher).
---@param parallel? boolean # Whether the craft tasks should be carried out in parallel or not, off by default. A parallel task will be carried out independently of other automated tasks on this shape. (Optional)
function sm.pipeGraph.setAutomatedTask(requester, recipe, parallel) end

---@class PipeGraphCondition
---@field uuid Uuid
---@field tickFrequency number
---@field remainingTicks? number
---@field consumptionCount number
---@field onlyExternal boolean

---*Server only*  
---Sets special conditions for allowing an interactable to craft.  
---@param requester Shape # The requesting shape.
---@param condition PipeGraphCondition # Values for special conditions to allow crafting. Uses "uuid", "tickFrequency", "remainingTicks"(optional), "consumptionCount", "onlyExternal". See Prospector.lua for example.
function sm.pipeGraph.setInteractableCondition(requester, condition) end

---*Server only*  
---Sets the maximum amount of parallel crafts, 65535 if not set.  
---@param requester Shape # The requesting shape.
---@param amount integer # The number of parallel crafts allowed to be done at once.
function sm.pipeGraph.setParallelLimit(requester, amount) end

---The <strong>Debug Draw</strong> api can be used for drawing geometric primitives for debug purposes.  
sm.debugDraw = {}

---Adds a named aabb debug draw.  
---@param name string # The debug transform name.
---@param min Vec3 # The box minimum extent.
---@param max Vec3 # The box maximum extent.
---@param color? Color # The color. Defaults to white.
function sm.debugDraw.addAabb(name, min, max, color) end

---Adds a named arrow debug draw.  
---@param name string # The debug arrow name.
---@param from Vec3 # The from position.
---@param to? Vec3 # The to position. Defaults to the from position plus one along the z axis. (World up vector)
---@param color? Color # The color. Defaults to white.
function sm.debugDraw.addArrow(name, from, to, color) end

---Adds a named box debug draw.  
---@param name string # The debug transform name.
---@param min Vec3 # The box minimum extent.
---@param max Vec3 # The box maximum extent.
---@param position Vec3 # The box position.
---@param rotation? Quat # The box rotation. Defaults to identity.
---@param color? Color # The color. Defaults to white.
function sm.debugDraw.addBox(name, min, max, position, rotation, color) end

---Adds a named sphere debug draw.  
---@param name string # The debug sphere name.
---@param center Vec3 # The sphere center.
---@param radius? number # The sphere radius. Defaults to 0.125.
---@param color? Color # The color. Defaults to white.
function sm.debugDraw.addSphere(name, center, radius, color) end

---Adds text in world debug draw.  
---@param name string # The text name.
---@param text string # The text content.
---@param position Vec3 # The world position of the text.
---@param fade? boolean # If the text should fade. Defaults to false.
---@param scale? number # The scale of the text. Defaults to 30.
---@param color? Color # The color. Defaults to white.
function sm.debugDraw.addText(name, text, position, fade, scale, color) end

---Adds a named transform debug draw.  
---@param name string # The debug transform name.
---@param origin Vec3 # The transform origin.
---@param rotation Quat # The transform rotation.
---@param scale? number # The transform scale. Defaults to 1.0.
function sm.debugDraw.addTransform(name, origin, rotation, scale) end

---Removes all debug draws beginning with a given name.  
---@param name? string # The name to match (Defaults to "", matching all debug draws).
function sm.debugDraw.clear(name) end

---Draws an arrow.  
---@param from Vec3 # The starting position of the arrow.
---@param to? Vec3 # The ending position of the arrow. Defaults to the starting position plus one unit along the z-axis (world up vector).
---@param color? Color # The color of the arrow. Defaults to white.
function sm.debugDraw.drawArrowTopDown(from, to, color) end

---Draws a box.  
---@param min Vec3 # The minimum extent of the box.
---@param max Vec3 # The maximum extent of the box.
---@param position Vec3 # The position of the box.
---@param rotation? Quat # The rotation of the box. Defaults to identity.
---@param color? Color # The color of the box. Defaults to white.
---@param duration? number # The duration of the flash animation in seconds. Defaults to 0.5 seconds.
function sm.debugDraw.drawBoxTopDown(min, max, position, rotation, color, duration) end

---Draws a circle.  
---@param center Vec3 # The center position of the circle.
---@param radius? number # The radius of the circle. Defaults to 0.125.
---@param color? Color # The color of the circle. Defaults to white.
function sm.debugDraw.drawCircleTopDown(center, radius, color) end

---Draws a rectangle.  
---@param min Vec3 # The minimum extent of the rectangle.
---@param max Vec3 # The maximum extent of the rectangle.
---@param color? Color # The color of the rectangle. Defaults to white.
function sm.debugDraw.drawRectTopDown(min, max, color) end

---Draws a sphere.  
---@param center Vec3 # The center position of the sphere.
---@param radius? number # The radius of the sphere. Defaults to 0.125.
---@param color? Color # The color of the sphere. Defaults to white.
function sm.debugDraw.drawSphereTopDown(center, radius, color) end

---Flashes an axis-aligned bounding box for a specified duration.  
---@param min Vec3 # The minimum world extent of the box.
---@param max Vec3 # The maximum world extent of the box.
---@param color? Color # The color of the box. Defaults to white.
---@param duration? number # The duration of the flash animation in seconds. Defaults to 0.5 seconds.
function sm.debugDraw.flashAabb(min, max, color, duration) end

---Flashes an arrow for a specified duration.  
---@param from Vec3 # The starting position of the arrow.
---@param to? Vec3 # The ending position of the arrow. Defaults to the starting position plus one unit along the z-axis (world up vector).
---@param color? Color # The color of the arrow. Defaults to white.
---@param duration? number # The duration of the flash animation in seconds. Defaults to 0.5 seconds.
function sm.debugDraw.flashArrow(from, to, color, duration) end

---Flashes an arrow for a specified duration.  
---@param from Vec3 # The starting position of the arrow.
---@param to? Vec3 # The ending position of the arrow. Defaults to the starting position plus one unit along the z-axis (world up vector).
---@param color? Color # The color of the arrow. Defaults to white.
---@param duration? number # The duration of the flash animation in seconds. Defaults to 0.5 seconds.
function sm.debugDraw.flashArrowTopDown(from, to, color, duration) end

---Flashes a box for a specified duration.  
---@param min Vec3 # The minimum extent of the box.
---@param max Vec3 # The maximum extent of the box.
---@param position Vec3 # The position of the box.
---@param rotation? Quat # The rotation of the box. Defaults to identity.
---@param color? Color # The color of the box. Defaults to white.
---@param duration? number # The duration of the flash animation in seconds. Defaults to 0.5 seconds.
function sm.debugDraw.flashBox(min, max, position, rotation, color, duration) end

---Flashes a box for a specified duration.  
---@param min Vec3 # The minimum extent of the box.
---@param max Vec3 # The maximum extent of the box.
---@param position Vec3 # The position of the box.
---@param rotation? Quat # The rotation of the box. Defaults to identity.
---@param color? Color # The color of the box. Defaults to white.
---@param duration? number # The duration of the flash animation in seconds. Defaults to 0.5 seconds.
function sm.debugDraw.flashBoxTopDown(min, max, position, rotation, color, duration) end

---Flashes a circle for a specified duration.  
---@param center Vec3 # The center position of the circle.
---@param radius? number # The radius of the circle. Defaults to 0.125.
---@param color? Color # The color of the circle. Defaults to white.
---@param duration? number # The duration of the flash animation in seconds. Defaults to 0.5 seconds.
function sm.debugDraw.flashCircleTopDown(center, radius, color, duration) end

---Flashes a rectangle for a specified duration.  
---@param min Vec3 # The minimum extent of the rectangle.
---@param max Vec3 # The maximum extent of the rectangle.
---@param color? Color # The color of the rectangle. Defaults to white.
---@param duration? number # The duration of the flash animation in seconds. Defaults to 0.5 seconds.
function sm.debugDraw.flashRectTopDown(min, max, color, duration) end

---Flashes a sphere for a specified duration.  
---@param center Vec3 # The center position of the sphere.
---@param radius? number # The radius of the sphere. Defaults to 0.125.
---@param color? Color # The color of the sphere. Defaults to white.
---@param duration? number # The duration of the flash animation in seconds. Defaults to 0.5 seconds.
function sm.debugDraw.flashSphere(center, radius, color, duration) end

---Flashes a sphere for a specified duration.  
---@param center Vec3 # The center position of the sphere.
---@param radius? number # The radius of the sphere. Defaults to 0.125.
---@param color? Color # The color of the sphere. Defaults to white.
---@param duration? number # The duration of the flash animation in seconds. Defaults to 0.5 seconds.
function sm.debugDraw.flashSphereTopDown(center, radius, color, duration) end

---Draws text in world debug draw.  
---@param text string # The text content.
---@param position Vec3 # The world position of the text.
---@param fade? boolean # If the text should fade. Defaults to false.
---@param scale? number # The scale of the text. Defaults to 30.
---@param color? Color # The color. Defaults to white.
---@param time? number # Time to show text. Defaults to 0.5.
function sm.debugDraw.flashText(text, position, fade, scale, color, time) end

---Removes a named arrow debug draw.  
---@param name string # The debug arrow name.
function sm.debugDraw.removeArrow(name) end

---Removes a named box debug draw.  
---@param name string # The debug box name.
function sm.debugDraw.removeBox(name) end

---Removes a named sphere debug draw.  
---@param name string # The debug sphere name.
function sm.debugDraw.removeSphere(name) end

---Remove text in world debug draw.  
---@param name string # The text name.
function sm.debugDraw.removeText(name) end

---Removes a named transform debug draw.  
---@param name string # The debug transform name.
function sm.debugDraw.removeTransform(name) end


sm.debugGui = {}

---<strong>Storage</strong> is used for saving and loading any Lua data into the world's database. This allows for data to be retrieved after closing and reloading the world.  
---Storage can only be used on the <a href="index.html#server">server</a>.  
---**Warning:**
---*Storage allows for data to be saved immediately into the world's database. This is a <strong>very slow</strong> process and should be done as sparsely as possible.*
---*If you have data that is shared globally and updated often, consider using global variables instead. Ideally, storage should only be used to save data upon closing the world, or when saving a creation on the Lift.*
sm.storage = {}

---Loads Lua data stored with a given key. The <em>key</em> can be any lua object.  
---If no data is stored with the given key, this returns nil.  
---@param key any # The key.
---@return any # The data stored.
function sm.storage.load(key) end

---Load terrain data for this world if available.  
---@param worldId integer # The id of the world to load terrain data for.
---@return any # The data. Any lua object.
function sm.storage.loadTerrainData(worldId) end

---Saves any Lua object with a given key. The <em>key</em> can be any lua object.  
---The data will remain stored after closing the world, and is retrieved using [sm.storage.load, load], provided the same key.  
---**Note:**
---*The data is stored globally <strong>within the current mod</strong>. As of such, keys will not collide with external mods and scripts.*
---@param key any # The key that will be used to get the data.
---@param data any # The data to be stored.
function sm.storage.save(key, data) end

---Saves any Lua object with a given key. The <em>key</em> can be any lua object.  
---The data will remain stored after closing the world and synchronized to other clients, and is retrieved using [sm.storage.load, load], provided the same key.  
---**Note:**
---*The data is stored globally <strong>within the current mod</strong>. As of such, keys will not collide with external mods and scripts.*
---@param key any # The key that will be used to get the data.
---@param data any # The data to be stored.
function sm.storage.saveAndSync(key, data) end


---Unit creation and management  
sm.unit = {}

-- unit_mechanic         = sm.uuid.new( "00000000-0000-0000-0000-000000000000" )
-- unit_challengebuilder = sm.uuid.new( "b6cafd3e-970b-4974-bb9f-ba7184b02797" )
-- unit_tapebot          = sm.uuid.new( "04761b4a-a83e-4736-b565-120bc776edb2" )
-- unit_tapebot_taped_1  = sm.uuid.new( "9dbbd2fb-7726-4e8f-8eb4-0dab228a561d" )
-- unit_tapebot_taped_2  = sm.uuid.new( "fcb2e8ce-ca94-45e4-a54b-b5acc156170b" )
-- unit_tapebot_taped_3  = sm.uuid.new( "68d3b2f3-ed4b-4967-9d22-8ee6f555df63" )
-- unit_tapebot_red      = sm.uuid.new( "c3d31c47-0c9b-4b07-9bd4-8f022dc4333e" )
-- unit_totebot_green    = sm.uuid.new( "8984bdbf-521e-4eed-b3c4-2b5e287eb879" )
-- unit_haybot           = sm.uuid.new( "c8bfb8f3-7efc-49ac-875a-eb85ac0614db" )
-- unit_farmbot          = sm.uuid.new( "9f4fde94-312f-4417-b13b-84029c5d6b52" )
-- unit_woc              = sm.uuid.new( "264a563a-e304-430f-a462-9963c77624e9" )
-- unit_worm             = sm.uuid.new( "48c03f69-3ec8-454c-8d1a-fa09083363b1" )

--Removed from CharacterUUID because the game doesn't define it.
--| `unit_challengebuilder`

---All of the vanilla character UUIDs that can be used with sm.unit.createUnit.
---Use if you have imported survival_items.lua in your mod environment.
---@alias CharacterUUID
---| `unit_mechanic`
---| `unit_tapebot`
---| `unit_tapebot_taped_1`
---| `unit_tapebot_taped_2`
---| `unit_tapebot_taped_3`
---| `unit_tapebot_red`
---| `unit_totebot_green`
---| `unit_haybot`
---| `unit_farmbot`
---| `unit_woc`
---| `unit_worm`

---All of the vanilla character UUIDs that can be used with sm.unit.createUnit.
---Use if you haven't imported survival_items.lua in your mod environment.
---@alias CharacterUUID
---| `sm.uuid.new('00000000-0000-0000-0000-000000000000')` # MechanicCharacter
---| `sm.uuid.new('b6cafd3e-970b-4974-bb9f-ba7184b02797')` # BuilderbotCharacter
---| `sm.uuid.new('04761b4a-a83e-4736-b565-120bc776edb2')` # TapeBotCharacter
---| `sm.uuid.new('9dbbd2fb-7726-4e8f-8eb4-0dab228a561d')` # TapeBotCharacter
---| `sm.uuid.new('fcb2e8ce-ca94-45e4-a54b-b5acc156170b')` # TapeBotCharacter
---| `sm.uuid.new('68d3b2f3-ed4b-4967-9d22-8ee6f555df63')` # TapeBotCharacter
---| `sm.uuid.new('c3d31c47-0c9b-4b07-9bd4-8f022dc4333e')` # TapeBotCharacter
---| `sm.uuid.new('8984bdbf-521e-4eed-b3c4-2b5e287eb879')` # TotebotCharacter
---| `sm.uuid.new('c8bfb8f3-7efc-49ac-875a-eb85ac0614db')` # HaybotCharacter
---| `sm.uuid.new('9f4fde94-312f-4417-b13b-84029c5d6b52')` # FarmbotCharacter
---| `sm.uuid.new('264a563a-e304-430f-a462-9963c77624e9')` # WocCharacter
---| `sm.uuid.new('48c03f69-3ec8-454c-8d1a-fa09083363b1')` # GlobCharacter

---*Server only*  
---Creates a new unit of type from an [Uuid]  
---@param uuid Uuid|CharacterUUID # The character type uuid.
---@param feetPos Vec3 # The feet position in world where unit should spawn.
---@param yaw? number # The initial yaw. Defaults to 0 (Optional)
---@param data? any # The param data. (Optional)
---@param pitch? number # The initial pitch. Defaults to 0 (Optional)
---@param visible? boolean # Whether the unit is visible on spawn. Defaults to true. (Optional)
---@return Unit # The created unit.
function sm.unit.createUnit(uuid, feetPos, yaw, data, pitch, visible) end

---*Server only*  
---Destroys a unit.  
---If the unit does not exist at the moment, it is removed from the save file. This will stop it from loading back into the game.  
---@param unit Unit # The unit.
function sm.unit.forceDestroy(unit) end

---*Server only*  
---Returns a table with all the units in the world.  
---@param world? World # The world to get units from. Defaults to the world of the script (Optional)
---@return Unit[] # The table of all units. {[Unit], ..}
function sm.unit.getAllUnits(world) end

---*Server only*  
---Returns a table with units within a given range.  
---@param world World # The world to check in.
---@param position Vec3 # The position to check from.
---@param range number # The range to check.
---@param heightModifier? number # A value to modify the height of the range check. Defaults to 1. Higher values makes enemy elevation difference deemed as greater distance.
---@return Unit[] units The units
function sm.unit.getUnitsInRange(world, position, range, heightModifier) end


---Achievement events will not be processed with edited core files or mods enabled.  
sm.achievement = {}

---@param uuidString string
---@param value number
---@param playerIds integer[]?
function sm.achievement.addf(uuidString, value, playerIds) end

---@param uuidString string
---@param value integer
---@param playerIds integer[]?
function sm.achievement.addi(uuidString, value, playerIds) end

---@param uuidString string
---@param value number
---@param playerIds integer[]?
function sm.achievement.setf(uuidString, value, playerIds) end

---@param uuidString string
---@param value integer
---@param playerIds integer[]?
function sm.achievement.seti(uuidString, value, playerIds) end

---@param name string
---@param data table
---@param playerIds integer[]?
function sm.achievement.pushToContext(name, data, playerIds) end


---Pathfinder  
sm.pathfinder = {}

---Condition link types  
---height  
---target  
---none  S
sm.pathfinder.conditionProperty = {
    height = 0,
    target = 1,
    none = 2
}

---@class PathfinderAbilities 
---@field canWalk? boolean
---@field canSwim? boolean

---@class PathfinderCosts
---@field ground? number
---@field water? number
---@field chemicals? number
---@field oil? number
---@field lava? number

---*Server only*  
---Constrain a point to nav mesh. Returns original point if no nav mesh is found.  
---@param world World # The world to look in.
---@param point Vec3 # The point.
---@param abilities? PathfinderAbilities # Table of actor abilities { canWalk=boolean, canSwim=boolean }. Defaults to all abilities.
---@return Vec3 # The modified point.
function sm.pathfinder.constrainPointToNavMesh(world, point, abilities) end

---@class NodePathElement
---@field toNode PathNode

---*Server only*  
---Find a path  
---@param character Character # The character to find path for
---@param destination Vec3 # The path destination
---@param groundPos? boolean # If the destination is ground level (ignored if nav mesh is used) (Defaults to true)
---@param abilities? PathfinderAbilities # Table of actor abilities { canWalk=boolean, canSwim=boolean }. Defaults to character abilities.
---@param costs? PathfinderCosts # Table of traverse area costs [1-10] { ground=number, water=number, chemicals=number, oil=number, lava=number }. Defaults to default costs.
---@return NodePathElement[] # The path as table of PathNodes
function sm.pathfinder.getPath(character, destination, groundPos, abilities, costs) end

---*Server only*  
---Fetches a random point from the navmesh polys in a set radius. The point can be outside the radius but no polys outside the radius will be selected.  
---@param world World # The world to look in.
---@param point Vec3 # The point.
---@param radius number # The radius to search in.
---@param abilities? PathfinderAbilities # Table of actor abilities { canWalk=boolean, canSwim=boolean }. Defaults to all abilities.
---@return Vec3 # The new random point. (returns original point in case of failure)
function sm.pathfinder.getRandomPoint(world, point, radius, abilities) end

---*Server only*  
---Find all nearby path nodes  
---@param worldPosition Vec3 # The position to look in
---@param minDist number # Minimum distance around pos
---@param maxDist number # Maximum distance around pos
---@return PathNode[] # Table of PathNodes sorted closest to farthest
function sm.pathfinder.getSortedNodes(worldPosition, minDist, maxDist) end

---*Server only*  
---Find all nearby path nodes  
---@param worldPosition Vec3 # The position to look in
---@param minDist number # Minimum distance around pos
---@param maxDist number # Maximum distance around pos
---@return PathNode[] # Table of PathNodes sorted closest to farthest
function sm.pathfinder.getSortedNodes(worldPosition, minDist, maxDist) end

---*Server only*  
---Find a path  
---@param world World # The world to look in
---@param start Vec3 # The path start
---@param destination Vec3 # The path destination
---@param abilities? PathfinderAbilities # Table of actor abilities { canWalk=boolean, canSwim=boolean }. Defaults to all abilities.
---@param costs? PathfinderCosts # Table of traverse area costs [1-10] { ground=number, water=number, chemicals=number, oil=number, lava=number }. Defaults to default costs.
---@return PathNode[] # The path as table of PathNodes
function sm.pathfinder.getWorldPath(world, start, destination, abilities, costs) end

---*Server only*  
---Looks at the surface of the navmesh from the start position toward the destination position to see if it is traversable.  
---If the distance isn't fully traversable, the out_fDistance is the traversable distance.  
---@param world World # The world to look in.
---@param start Vec3 # The path start
---@param destination Vec3 # The path destination
---@param abilities? PathfinderAbilities # Table of actor abilities { canWalk=boolean, canSwim=boolean }. Defaults to all abilities.
---@return boolean,number # True if fully traversable, and a traversable distance when not fully traversable. (distance becomes FLT_MAX when fully traversable)
function sm.pathfinder.traversableRaycast(world, start, destination, abilities) end


---Path node creation  
sm.pathNode = {}

---*Server only*  
---Create a PathNode  
---@param worldPosition Vec3 # The node's world position
---@param radius number # The node's radius
---@param temporary? boolean # Temporary nodes are not saved and relies on lua garbage collection for removal (defaults to false).
---@return PathNode # The path node
function sm.pathNode.createPathNode(worldPosition, radius, temporary) end

---Used to check the state of the game.  
sm.game = {}

---*Server only*  
---Ban a player from the server.  
---@param player Player # The player to be banned.
function sm.game.banPlayer(player) end

---{ type, name (, optional, autocomplete ) }
---@alias ChatCommandParam { [1]: "string"|"int"|"number"|"bool", [2]: string, [3]: boolean?, [4]: any[]? }

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
---@param command string # The command.
---@param params ChatCommandParam[] # An array of parameters the callback function expects in the form of { { type, name (, optional, autocomplete ) }, ... }. The first is the <strong>type</strong> name of the parameter as a string. Valid types are "bool", "int", "number" and "string". The second is the <strong>name</strong> in the help text. Defaults to automatic naming ("p1", "p2", "p3", ...). The third is a bool value where true means that this parameter is <strong>optional</strong> (Optional, defaults to false). The fourth is a list of values that can be auto-completed to by pressing tab (Optional).
---@param callback string # The name of the Lua function to bind.
---@param help string # Help text.
function sm.game.bindChatCommand(command, params, callback, help) end

---Only for testing!  
function sm.game.exitToMenu() end

---Exits to the main menu and requests the end-game credits sequence to play once there.  
function sm.game.exitToMenuWithEndCredits() end

---Return the current game tick.  
---@return integer # The tick.
function sm.game.getCurrentTick() end

---Return the index of the current difficulty setting.  
---@return integer # index	The difficulty index.
function sm.game.getDifficulty() end

---Returns true if aggro is enabled and false if aggro is disabled.  
---@return boolean # The enable state.
function sm.game.getEnableAggro() end

---Returns true if ammo consumption is enabled and false if ammo consumption is disabled.  
---@return boolean # The enable state.
function sm.game.getEnableAmmoConsumption() end

---Returns true if fuel consumption is enabled and false if fuel consumption is disabled.  
---@return boolean # The enable state.
function sm.game.getEnableFuelConsumption() end

---Returns true if restrictions are enabled and false if restrictions are disabled.  
---@return boolean # The enable state.
function sm.game.getEnableRestrictions() end

---Returns true if upgrading is enabled and false if upgrading is disabled.  
---@return boolean # The enable state.
function sm.game.getEnableUpgrade() end

---Return limited inventory state. If true the items are limited, if false the items are unlimited.  
---@return boolean # Is limited.
function sm.game.getLimitedInventory() end

---Returns true if recipes is enabled and false if recipes are is disabled.  
---@return boolean # The enable state.
function sm.game.getRecipesEnabled() end

---Return estimated game tick on the server.  
---@return integer # The tick.
function sm.game.getServerTick() end

---Get the boolean value of a named setting.  
---@param name string # The name of the setting
---@return boolean # value	The value of the setting.
function sm.game.getSettingBoolean(name) end

---Get the string value of a named setting.  
---@param name string # The name of the setting
---@return string # value	The value of the setting.
function sm.game.getSettingString(name) end

---Get the number value of a named setting.  
---@param name string # The name of the setting
---@return number # value	The value of the setting.
function sm.game.getSettingValue(name) end

---Return the fraction value of how far the current day has progressed.  
---@return number # The fraction of the day cycle.
function sm.game.getTimeOfDay() end

---*Server only*  
---Kick a player from the server.  
---@param player Player # The player to be kicked.
function sm.game.kickPlayer(player) end

---*Client only*  
---Loads the users watched tutorials and returns it as a table.  
---@return table # Users watched tutorials table.
function sm.game.loadWatchedTutorials() end

---*Server only*  
---Pauses saving for the specified number of ticks. Server only.  
---If already paused, extends to the longer of current remaining and the requested ticks.  
---@param waitName string # The name identifying this pause request.
---@param ticks integer # The number of ticks to pause saving for.
function sm.game.pauseSaving(waitName, ticks) end

---*Server only*  
---Resumes saving by removing a named pause request. Server only.  
---@param waitName string # The name identifying the pause request to remove.
function sm.game.resumeSaving(waitName) end

---*Client only*  
---Saves the user's watched tutorials.  
---@param watchedTutorials table # The table of watched tutorials.
function sm.game.saveWatchedTutorials(watchedTutorials) end

---*Server only*  
---Enables and disables aggro. If true, player's will be detected as targets.  
---@param enableAggro boolean # The enable state.
function sm.game.setEnableAggro(enableAggro) end

---*Server only*  
---Enables and disables ammo consumption. If true, ammo will be required to shoot spudguns.  
---@param enableAmmoConsumption boolean # The enable state.
function sm.game.setEnableAmmoConsumption(enableAmmoConsumption) end

---*Server only*  
---Enables and disables fuel consumption. If true, fuel will be consumed from engines.  
---@param enableFuelConsumption boolean # The enable state.
function sm.game.setEnableFuelConsumption(enableFuelConsumption) end

---*Server only*  
---Enables and disables recipes. If true, player's will need to unlock recipes before they become available for crafting.  
---@param enableRecipes boolean # The enable state.
function sm.game.setEnableRecipes(enableRecipes) end

---*Server only*  
---Enables and disables the use of restrictions. If true restrictions will be applied, if false the restrictions will default to unrestricted.  
---@param enableRestrictions boolean # Restrictions enable state.
function sm.game.setEnableRestrictions(enableRestrictions) end

---*Server only*  
---Enables and disables upgrade. If true, the [Interactable] can be upgraded with component kits.  
---@param enableUpgrade boolean # The enable state.
function sm.game.setEnableUpgrade(enableUpgrade) end

---*Server only*  
---Sets limited inventory. If true the items are limited, if false the items are unlimited.  
---@param isLimited boolean # Is limited.
function sm.game.setLimitedInventory(isLimited) end

---*Client only*  
---Sets the fraction value of how far the current day has progressed.  
---@param time number # The fraction of the day cycle.
function sm.game.setTimeOfDay(time) end


---Library for <strong>compromised</strong> shape management.  
---See CablebotManager.lua  
sm.compromised = {}

---*Server only*  
---Compromises a [Shape, shape] within the sphere.  
---@param position Vec3 # The center position of the sphere.  
---@param radius number # The radius of the sphere.  
---@return boolean # True if a shape has been compromised.  
function sm.compromised.compromiseShapeInSphere(position, radius) end

---*Server only*  
---Returns a table of all compromised [Shape, shapes].  
---@param world World? # The world to check for compromised shapes in. (Optional, defaults to world from script context)  
---@return Shape[] # The table of compromised shapes. {[Shape], ..}  
function sm.compromised.getCompromisedShapes(world) end

---*Server only*  
---Returns whether there are any compromised [Shape, shapes].  
---@param world World # The world to check for compromised shapes in.
---@return boolean # True if there are compromised shapes.  
function sm.compromised.hasCompromisedShapes(world) end


---Library for <strong>fire</strong> management.  
sm.fire = {}

---*Server only*  
---Returns whether there is any fire in the sphere.  
---@param position Vec3 # The position of the sphere.  
---@param radius number # The radius of the sphere.  
---@param world World # The world to check for fire in.  
---@return boolean # True if there is fire in the sphere.  
function sm.fire.isAreaBurning(position, radius, world) end

---*Server only*  
---Sets the limit of fire instances.  
---@param limit integer # The limit of fire instances.  
function sm.fire.setFireLimit(limit) end

---*Server only*  
---Ignites everything in the sphere.  
---@param position Vec3 # The position of the sphere.  
---@param radius number # The radius of the sphere.  
---@param bool boolean? # Undocumented. Optional.  
---@param world World? # The world to ignite fire in. (Optional, defaults to world from script context)  
function sm.fire.igniteSphere(position, radius, bool, world) end

---*Server only*  
---Returns a table of all burning [Shape, shapes].  
---@return Shape[] # The table of burning shapes. {[Shape], ..}  
function sm.fire.getBurningShapes() end


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
---@param creation Body[] A table of all the bodies belonging to the creation placed on the lift.
---@param position Vec3 The lift position.
---@param rotation integer The rotation of the creation on the lift.
---@return boolean, integer # True if the lift collides with the world; The lift level.
function sm.tool.checkLiftCollision(creation, position, rotation) end

---Checks whether a specific lift level is valid (no collision) for a creation at the given position and rotation.  
---@param creation Body[] # A table of all the bodies belonging to the creation placed on the lift.
---@param position Vec3 # The lift position.
---@param rotation integer # The rotation of the creation on the lift.
---@param level integer # The specific lift level to test.
---@param timeStamp integer # The timestamp of when the body set was initialized
---@return boolean								True if the level is valid (no collision).
function sm.tool.checkLiftCollisionAtLevel(creation, position, rotation, level, timeStamp) end

---Find index of column of shades that best matches given color.
---@param uintRgba integer # The UintRgba version of the color (Color:getUnitRgba()).  
---@return integer # Palette column index.
function sm.tool.findPaintToolPaletteColumnIndex( uintRgba ) end

---*Client only*  
---Force equip a tool for the local player. Pass nil to unforce an already forced tool.  
---@param tool Tool|nil The tool.
function sm.tool.forceTool(tool) end

---Returns the maximum number of lift levels.  
---@return integer								The maximum lift level count.
function sm.tool.getLiftMaxLevel() end

---*Client only*  
---Pre-loads renderable data to be used by the tool. This eliminates excessive loading during run time.  
---@param renderables string[] The table of renderables names. {string, ..}
function sm.tool.preloadRenderables(renderables) end

---Return whether the tool uuid exists  
---@param uuid Uuid # The tool uuid.
---@return boolean # exists.
function sm.tool.uuidExists(uuid) end


---The <strong>audio</strong> manager is used to play sound effects in the game.  
---**Note:**
---*This manager does only produce sound for the local <a href="index.html#client">client</a>. This is useful for small sound effects such as for GUI.*
---*For more information about sound and particle effects that affect all players, see [sm.effect].*
sm.audio = {}

---A table with all the names of available sounds in the game.  
---@deprecated Audio is deprecated, use Effect instead
sm.audio.soundList = {}

---*Client only*  
---Gets a named global parameter value from FMOD.  
---@param name string # The name.
---@return number # The parameter value.
function sm.audio.getGlobalParameter(name) end

---All of the audio names that can be used with sm.audio.play.
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
---@param sound string|AudioName The sound to play.
---@param position? Vec3 The world position of the sound. (Optional)
function sm.audio.play(sound, position) end

---*Client only*  
---Sets a named global parameter value in FMOD.  
---@param name string # The name.
---@param value number # The parameter value.
function sm.audio.setGlobalParameter(name, value) end


---The <strong>particle</strong> api allows you to create particle effects at a position.  
---If you require more control or complexity, please see the [sm.effect, effect] api.  
sm.particle = {}


---The <strong>particle</strong> api allows you to create particle effects at a position.  
---If you require more control or complexity, please see the [sm.effect, effect] api.  
sm.particle = {}

---*Client only*  
---Create a particle effect at a given position and rotation.  
---**Note:**
---*If you start a looping particle effect through this method then the only way to get rid of it is by reloading the save.*
---@param particle string # The particle name.
---@param position Vec3 # The position.
---@param rotation? Quat # The rotation. (Defaults to no rotation)
---@param color? Color # The blend color. (Defaults to white)
function sm.particle.createParticle(particle, position, rotation, color) end


---<strong>Local player</strong> represents the current character being controlled on the client's computer. This library can only be used on the <a href="index.html#client">client</a>.  
---For more information about other players in the world, see [sm.player].  
sm.localPlayer = {}

---*Client only*  
---Adds a renderable (file containing model data) to be used for the local player in first person view.  
---@param renderable string # The renderable path.
function sm.localPlayer.addRenderable(renderable) end

---*Client only*  
---Returns the item currently held by the local player.  
---@return Uuid # The player's held item uuid.
function sm.localPlayer.getActiveItem() end

---*Client only*  
---Return the player aim sensitivity  
---@return number # The aim sensitivity
function sm.localPlayer.getAimSensitivity() end

---*Client only*  
---Returns the carrying container of the local player.  
---@return Container # The player's carry.
function sm.localPlayer.getCarry() end

---*Client only*  
---Returns the color of the shape the local player is carrying.  
---@return Color # The color of the shape the local player is carrying.
function sm.localPlayer.getCarryColor() end

---*Client only*  
---Gets the world position and rotation of the local player's shape placement if it is not colliding. Otherwise nil is returned.  
---@return Vec3, Quat # World position and rotation.
function sm.localPlayer.getConstructionPlacement() end

---*Client only*  
---Returns the direction the local player is aiming.  
---@return Vec3 # The direction of the player's aim.
function sm.localPlayer.getDirection() end

---*Client only*  
---Returns general information for a first person view animation.  
---@param name string # The name.
---@return AnimationInfo # A table containing name, duration and looping.
function sm.localPlayer.getFpAnimationInfo(name) end

---*Client only*  
---Returns the world position for a bone in the first person view animation skeleton.  
---@param jointName string The joint name.
---@return Vec3
function sm.localPlayer.getFpBonePos(jointName) end

---*Client only*  
---Gets the title of the garment with the given uuid in the current language.  
---@param uuid Uuid # The garment.
---@return string # The title of the garment
function sm.localPlayer.getGarmentName(uuid) end

---*Client only*  
---Gets the UPPER CASE title of the garment with the given uuid in the current language.  
---@param uuid Uuid # The garment.
---@return string # The title of the garment
function sm.localPlayer.getGarmentUpperCaseTitle(uuid) end

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
---Returns the latest interaction raycast result of the local player. This is the raycast that is constantly performed to detect interactable objects up to a range of 7.5.  
---@return bool, RaycastResult # True if raycast was successful; Raycast result data.
function sm.localPlayer.getLatestRaycast() end

---*Client only*  
---Returns delta positions of mouse  
---@return number,number # Delta X; Delta Y
function sm.localPlayer.getMouseDelta() end

---*Client only*  
---Returns the [Lift] of the local player.  
---@return Lift # The player's lift.
function sm.localPlayer.getOwnedLift() end

---*Client only*  
---Returns the player object of the local player.  
---@return Player # The player object.
function sm.localPlayer.getPlayer() end

---*Client only*  
---@deprecated Use [Character.worldPosition] or [Character.getWorldPosition]
---Returns the world position of the local player.  
---@return Vec3 # The player's world position.
function sm.localPlayer.getPosition() end

---*Client only*  
---Performs a <a target="_blank" href="https://en.wikipedia.org/wiki/Ray_casting">raycast</a> relative to the local player's perspective.  
---@param range number # The maximum range.
---@param origin? Vec3 # The start position. (Defaults to [sm.localPlayer.getRaycastStart])
---@param direction? Vec3 # The direction. (Defaults to [sm.localPlayer.getDirection])
---@return bool, RaycastResult # True if raycast was successful; Raycast result data.
function sm.localPlayer.getRaycast(range, origin, direction) end

---*Client only*  
---Returns the start position of the local player's raycast. The position depends on the [sm.camera, camera]'s position, and whether it's in first- of third-person.  
---@return Vec3 # The start position of the raycast.
function sm.localPlayer.getRaycastStart() end

---*Client only*  
---Returns the right-vector perpendicular to the local player's aim.  
---@return Vec3 # The right-vector of the player's aim.
function sm.localPlayer.getRight() end

---*Client only*  
---Returns the local player's selected slot.  
---@return integer # The player's selected slot.
function sm.localPlayer.getSelectedHotbarSlot() end

---*Client only*  
---Returns the up-vector perpendicular to the local player's aim.  
---@return Vec3 # The up-vector of the player's aim.
function sm.localPlayer.getUp() end

---*Client only*  
---Checks if local player wants to sprint (pressing the sprint key).  
---@return boolean # Whether the player is holding the sprint key.
function sm.localPlayer.getWantsSprint() end

---*Client only*  
---Gets the world the local player's character is in, if any, otherwise nil.  
---@return World # The world the local player is in, if any.
function sm.localPlayer.getWorld() end

---*Client only*  
---Unlocks a cosmetic with the given uuid for the player. Requires survival mode, non modified core files and no active mods to function.  
---@param uid Uuid # The uuid of the unlocked cosmetic.
function sm.localPlayer.grantQuestItem(uid) end

---*Client only*  
---Check if the garment has been granted to the local player.  
---@param uuid Uuid # The garment.
---@return boolean # Returns true if the garment is unlocked.
function sm.localPlayer.isGarmentUnlocked(uuid) end

---*Client only*  
---Returns whether the player is in first person view where the viewpoint is rendered from the player's perspective. Otherwise, the player is in third person view where the camera is behind the player.  
---@return boolean # Whether the player is in first person view.
function sm.localPlayer.isInFirstPersonView() end

---*Client only*  
---Removes a renderable (file containing model data) that was used for the local player in first person view.  
---@param renderable string # The renderable path.
function sm.localPlayer.removeRenderable(renderable) end

---*Client only*  
---Returns if the currently equipped tool consumes the secondary interaction, such as aiming with the spudgun.  
---@return boolean # True if the tool consumes the secondary interaction.
function sm.localPlayer.secondaryInteractBusy() end

---*Client only*  
---Stops the local player from sprinting.  
---@param blockSprinting boolean # Sets whether sprinting is blocked.
function sm.localPlayer.setBlockSprinting(blockSprinting) end

---*Client only*  
---Sets the direction of where the player is viewing or aiming. Intended to be used when the controls have been locked. (See [sm.localPlayer.setLockedControls])  
---@param direction Vec3 # The world direction.
function sm.localPlayer.setDirection(direction) end

---*Client only*  
---Sets whether the player's in-game controls are locked.  
---@param locked boolean The lock state.
function sm.localPlayer.setLockedControls(locked) end

---*Client only*  
---Updates a first person view animation.  
---@param name string # The name.
---@param time number # The time.
---@param weight? number # The weight. (Defaults to -1.0)
---@param looping? boolean # The looping. (Defaults to false)
function sm.localPlayer.updateFpAnimation(name, time, weight, looping) end


---The <strong>camera</strong> library contains methods related to the [sm.localPlayer, localPlayer]'s camera view.  
---In first-person view the camera is located inside the player's head, whereas in third-person view it floats behind them.  
---This library can only be used on the <a href="index.html#client">client</a>.  
sm.camera = {}

---Camera states are used to specify how the camera will view the world. The default state is meant for normal gameplay and the scripted states are meant to be used in cutscenes or interactables.  
---The states are:  
--- - <strong>default</strong> &ndash; The camera is controlled by the player.
--- - <strong>cutsceneFP</strong> &ndash; Scripted first-person camera; position, rotation, and FOV are set by script.
--- - <strong>cutsceneTP</strong> &ndash; Scripted third-person camera; position, rotation, and FOV are set by script.
--- - <strong>forcedTP</strong> &ndash; Forces a third-person view regardless of the player's zoom step. Used during tumbling.
--- - <strong>gyroSeatFP</strong> &ndash; First-person camera whose direction is driven by the gyro seat's rotation.
--- - <strong>gyroSeatTP</strong> &ndash; Third-person camera for the gyro seat.
--- - <strong>scriptedTP</strong> &ndash; Third-person camera with position, rotation, and FOV fully overridden by script. Used for interactable cutscenes.
--- - <strong>seatLockedCamera</strong> &ndash; The camera direction and position are locked to the seat's local space. The view is first-person unless a pullback is set, which produces a third-person view.
sm.camera.state = {   
    default = 1,
    cutsceneFP = 2,
    cutsceneTP = 3,
    forcedTP = 4,
    gyroSeatFP = 5,
    gyroSeatTP = 6,
    scriptedTP = 7,
    seatLockedCamera = 8
}

---*Client only*  
---Performs a distance convex sweep with the shape of a sphere, from a position with a given direction.  
---@param radius number # The radius of the cast sphere
---@param start Vec3 # The start position.
---@param direction Vec3 # The cast direction and range.
---@return number # The fraction of the distance reached until collision.
function sm.camera.cameraSphereCast(radius, start, direction) end

---*Client only*  
---Returns the camera's zoom step.  
---@return number # step		How far away the camera is from the player while standing
---@return number # seatedStep	How far away the camera is from the player while seated
function sm.camera.getCameraPullback() end

---*Client only*  
---Gets the camera's control state.  
---@return integer # state	How the camera is moved. (See [sm.camera.state])
function sm.camera.getCameraState() end

---*Client only*  
---Returns the camera's default field of view angle.  
---@return number # The field of view.
function sm.camera.getDefaultFov() end

---*Client only*  
---Returns the world position where the camera should be by default.  
---@return Vec3 # The camera's world position.
function sm.camera.getDefaultPosition() end

---*Client only*  
---Returns the world rotation where the camera should be by default.  
---@return Quat # The camera's default world rotation.
function sm.camera.getDefaultRotation() end

---*Client only*  
---Returns the direction the camera is aiming.  
---@return Vec3 # The direction of the camera's aim.
function sm.camera.getDirection() end

---*Client only*  
---Returns the camera's field of view angle.  
---@return number # The field of view.
function sm.camera.getFov() end

---*Client only*  
---Returns the world position of the camera.  
---@return Vec3 # The camera's world position.
function sm.camera.getPosition() end

---*Client only*  
---Returns the right-vector perpendicular to the camera's aim.  
---@return Vec3 # The right-vector of the camera's aim.
function sm.camera.getRight() end

---*Client only*  
---Returns the world rotation of the camera.  
---@return Quat # The camera's world rotation.
function sm.camera.getRotation() end

---*Client only*  
---Returns the up-vector perpendicular to the camera's aim.  
---@return Vec3 # The up-vector of the camera's aim.
function sm.camera.getUp() end

---*Client only*  
---Sets the camera's zoom step.  
---@param step integer # How far away the camera is from the player while standing
---@param seatedStep integer # How far away the camera is from the player while seated
function sm.camera.setCameraPullback(step, seatedStep) end

---*Client only*  
---Sets the camera's control state.  
---@param state integer # How the camera is moved. (See [sm.camera.state])
function sm.camera.setCameraState(state) end

---*Client only*  
---Sets the direction the camera is aiming.  
---@param direction Vec3 # The direction of the camera's aim.
function sm.camera.setDirection(direction) end

---*Client only*  
---Sets the camera's field of view angle.  
---@param FOV number # The field of view.
function sm.camera.setFov(FOV) end

---*Client only*  
---Sets the world position of the camera.  
---@param position Vec3 # The camera's world position.
function sm.camera.setPosition(position) end

---*Client only*  
---Sets the rotation of the camera.  
---@param rotation Quat # The rotation of the camera.
function sm.camera.setRotation(rotation) end

---*Client only*  
---Sets the camera pullback distance for the seatLockedCamera camera state.  
---When greater than zero the camera is pulled back from the seat origin along the camera direction.  
---@param pullback number # The pullback distance.
function sm.camera.setSeatLockedCameraPullback(pullback) end

---*Client only*  
---Sets the camera up offset for the seatLockedCamera camera state.  
---@param upOffset number # The up offset in local space.
function sm.camera.setSeatLockedCameraUpOffset(upOffset) end

---*Client only*  
---Sets the local direction for the camera when using the seatLockedCamera camera state.  
---The direction is in the seat's local space and will be transformed by the interpolated seat rotation.  
---@param localDirection Vec3 # The local direction to face.
function sm.camera.setSeatLockedLocalDirection(localDirection) end

---*Client only*  
---Sets the local up vector for the camera when using the seatLockedCamera camera state.  
---The up vector is in the seat's local space.  
---@param localUp Vec3 # The local up direction.
function sm.camera.setSeatLockedLocalUp(localUp) end

---*Client only*  
---Sets the camera's level of camera shake.  
---@param strength number # The camera shake strength.
function sm.camera.setShake(strength) end

---*Client only*  
---Sets the world-space direction for the local player character to face when the player unseats. Cleared automatically when used or when entering a seat.  
---Passing nil clears any previously set unseat direction.  
---@param worldDirection? Vec3 # The world-space direction to face on unseat. (optional)
function sm.camera.setUnseatDirection(worldDirection) end


---The <strong>gui</strong> library contains various utility functions for handling user interfaces.  
---This library can only be used on the <a href="index.html#client">client</a>.  
sm.gui = {}

---Widget states
sm.gui.widgetStates = {
    disabled = 0,
    normal = 1,
    highlighted = 2,
    pushed = 3,
    disabled_checked = 4,
    normal_checked = 5,
    highlighted_checked = 6,
    pushed_checked = 7,
}

---*Client only*  
---Sets a target callback for generic notification popups  
---@param callback string # Function to be called when a alert message is called
function sm.gui.bindDisplayMessageCallback(callback) end

---*Client only*  
---Sets the blocking state for the in game menu.  
---@param block boolean # The new blocking state for the in game menu.
function sm.gui.blockInGameMenu(block) end

---Prints text in the chat gui.  
---**Note:**
---*Will not be sent to other players.*
---@param message string # The message.
function sm.gui.chatMessage(message) end

---*Client only*  
---Calculates the 720 widget size required to display a text  
---@param text string # The text to compute.
---@param font string # The font to use.
---@param align string # The text alignment.
---@param maxWidth? number # The maximum desired widget width before wrapping (optional) (Defaults to -1)
---@param replaceTags? boolean # Should tags be replaced before calculating? (optional) (Defaults to true)
---@return number, number # The calculated width and height.
function sm.gui.computeTextSize(text, font, align, maxWidth, replaceTags) end

---*Client only*  
---Create a ammunition container GUI.  
---@param destroyOnClose? boolean # If true the gui is destroyed when closed, otherwise the gui can be reused. (Defaults to false)
---@return GuiInterface # The gui interface to the created gui.
function sm.gui.createAmmunitionContainerGui(destroyOnClose) end

---*Client only*  
---@deprecated use createWorldIconGui
---Create a bag icon GUI.  
---@param destroyOnClose? boolean # If true the gui is destroyed when closed, otherwise the gui can be reused. (Defaults to false)
---@return GuiInterface # The gui interface to the created gui.
function sm.gui.createBagIconGui(destroyOnClose) end

---*Client only*  
---Create a battery container GUI.  
---@param destroyOnClose? boolean # If true the gui is destroyed when closed, otherwise the gui can be reused. (Defaults to false)
---@return GuiInterface # The gui interface to the created gui.
function sm.gui.createBatteryContainerGui(destroyOnClose) end

---*Client only*  
---@deprecated use createWorldIconGui
---Create a beacon icon GUI.  
---@param destroyOnClose? boolean # If true the gui is destroyed when closed, otherwise the gui can be reused. (Defaults to false)
---@return GuiInterface # The gui interface to the created gui.
function sm.gui.createBeaconIconGui(destroyOnClose) end

---*Client only*  
---Create a challenge HUD GUI.  
---@param destroyOnClose? boolean # If true the gui is destroyed when closed, otherwise the gui can be reused. (Defaults to false)
---@return GuiInterface # The gui interface to the created gui.
function sm.gui.createChallengeHUDGui(destroyOnClose) end

---*Client only*  
---Create a challenge message HUD GUI.  
---@param destroyOnClose? boolean # If true the gui is destroyed when closed, otherwise the gui can be reused. (Defaults to false)
---@return GuiInterface # The gui interface to the created gui.
function sm.gui.createChallengeMessageGui(destroyOnClose) end

---*Client only*  
---Create a character customization GUI.  
---**Note:**
---*Character customization gui has two magic callbacks*
---*Mouse drag cl_onDragZoneUsed ( number, number )*
---*Mouse scroll cl_onDragZoneUsed ( number )*
---@param destroyOnClose? boolean # If true the gui is destroyed when closed, otherwise the gui can be reused. (Defaults to false)
---@return GuiInterface # The gui interface to the created gui.
function sm.gui.createCharacterCustomizationGui(destroyOnClose) end

---*Client only*  
---Create a chemical container GUI.  
---@param destroyOnClose? boolean # If true the gui is destroyed when closed, otherwise the gui can be reused. (Defaults to false)
---@return GuiInterface # The gui interface to the created gui.
function sm.gui.createChemicalContainerGui(destroyOnClose) end

---*Client only*  
---Create a compass hud GUI.  
---@param destroyOnClose? boolean # If true the gui is destroyed when closed, otherwise the gui can be reused. (Defaults to false)
---@return GuiInterface # The gui interface to the created gui.
function sm.gui.createCompassHudGui(destroyOnClose) end

---*Client only*  
---Create a container GUI, for showing two containers.  
---@param destroyOnClose? boolean # If true the gui is destroyed when closed, otherwise the gui can be reused. (Defaults to false)
---@return GuiInterface # The gui interface to the created gui.
function sm.gui.createContainerGui(destroyOnClose) end

---*Client only*  
---Create a craft bot GUI.  
---@param destroyOnClose? boolean # If true the gui is destroyed when closed, otherwise the gui can be reused. (Defaults to false)
---@return GuiInterface # The gui interface to the created gui.
function sm.gui.createCraftBotGui(destroyOnClose) end

---*Client only*  
---Create a dress bot GUI.  
---@param destroyOnClose? boolean # If true the gui is destroyed when closed, otherwise the gui can be reused. (Defaults to false)
---@return GuiInterface # The gui interface to the created gui.
function sm.gui.createDressBotGui(destroyOnClose) end

---*Client only*  
---Create a engine GUI.  
---@param destroyOnClose? boolean # If true the gui is destroyed when closed, otherwise the gui can be reused. (Defaults to false)
---@return GuiInterface # The gui interface to the created gui.
function sm.gui.createEngineGui(destroyOnClose) end

---*Client only*  
---Create a fertilizer container GUI.  
---@param destroyOnClose? boolean # If true the gui is destroyed when closed, otherwise the gui can be reused. (Defaults to false)
---@return GuiInterface # The gui interface to the created gui.
function sm.gui.createFertilizerContainerGui(destroyOnClose) end

---*Client only*  
---Create a gas container GUI.  
---@param destroyOnClose? boolean # If true the gui is destroyed when closed, otherwise the gui can be reused. (Defaults to false)
---@return GuiInterface # The gui interface to the created gui.
function sm.gui.createGasContainerGui(destroyOnClose) end

---*Client only*  
---Create a glowstick container GUI.  
---@param destroyOnClose? boolean # If true the gui is destroyed when closed, otherwise the gui can be reused. (Defaults to false)
---@return GuiInterface # The gui interface to the created gui.
function sm.gui.createGlowstickContainerGui(destroyOnClose) end

---@class GuiSettings
---@field isHud? boolean Whether the gui is part of the HUD or not
---@field isInteractive? boolean Whether the gui is interactive or not
---@field needsCursor? boolean Whether the gui makes use of the mouse cursor or not
---@field hidesHotbar? boolean Whether the gui hides the hotbar or not
---@field isOverlapped? boolean Unknown
---@field backgroundAlpha? number The alpha of the background(0 - transparent | 1 - opaque, black background)
---@field handleKeySetup? string Unknown
---@field name? string Unknown
---@field layer? string Unknown

---*Client only*  
---Create a GUI from a layout file.  
---@param layout string # Path to the layout file
---@param destroyOnClose? boolean # If true the gui is destroyed when closed, otherwise the gui can be reused. (Defaults to false)
---@param settings? GuiSettings # Table with bool settings for: isHud, isInteractive, needsCursor
---@return GuiInterface # The gui interface to the created gui.
function sm.gui.createGuiFromLayout(layout, destroyOnClose, settings) end

---*Client only*  
---Create a hideout gui GUI.  
---@param destroyOnClose? boolean # If true the gui is destroyed when closed, otherwise the gui can be reused. (Defaults to false)
---@return GuiInterface # The gui interface to the created gui.
function sm.gui.createHideoutGui(destroyOnClose) end

---*Client only*  
---Create a log book GUI.  
---@param destroyOnClose? boolean # If true the gui is destroyed when closed, otherwise the gui can be reused. (Defaults to false)
---@return GuiInterface # The gui interface to the created gui.
function sm.gui.createLogbookGui(destroyOnClose) end

---*Client only*  
---Create a mechanic station dispenser GUI.  
---@param destroyOnClose? boolean # If true the gui is destroyed when closed, otherwise the gui can be reused. (Defaults to false)
---@return GuiInterface # The gui interface to the created gui.
function sm.gui.createMechanicStationGui(destroyOnClose) end

---*Client only*  
---Create a mining hub dispenser GUI.  
---@param destroyOnClose? boolean # If true the gui is destroyed when closed, otherwise the gui can be reused. (Defaults to false)
---@return GuiInterface # The gui interface to the created gui.
function sm.gui.createMininghubDispenserGui(destroyOnClose) end

---*Client only*  
---Create a name tag GUI.  
---@param destroyOnClose? boolean # If true the gui is destroyed when closed, otherwise the gui can be reused. (Defaults to false)
---@return GuiInterface # The gui interface to the created gui.
function sm.gui.createNameTagGui(destroyOnClose) end

---*Client only*  
---Create a ore crusher container GUI.  
---@param destroyOnClose boolean # If true the gui is destroyed when closed, otherwise the gui can be reused.
---@return GuiInterface # The gui interface to the created gui.
function sm.gui.createOreCrusherContainerGui(destroyOnClose) end

---*Client only*  
---Create a portable craftbot GUI.  
---@param destroyOnClose? boolean # If true the gui is destroyed when closed, otherwise the gui can be reused. (Defaults to false)
---@return GuiInterface # The gui interface to the created gui.
function sm.gui.createPortableCrafterGui(destroyOnClose) end

---*Client only*  
---Create a prospector container GUI.  
---@param destroyOnClose? boolean # If true the gui is destroyed when closed, otherwise the gui can be reused. (Defaults to false)
---@return GuiInterface # The gui interface to the created gui.
function sm.gui.createProspectorContainerGui(destroyOnClose) end

---*Client only*  
---Create a quest tracker GUI.  
---@param destroyOnClose? boolean # If true the gui is destroyed when closed, otherwise the gui can be reused. (Defaults to false)
---@return GuiInterface # The gui interface to the created gui.
function sm.gui.createQuestTrackerGui(destroyOnClose) end

---*Client only*  
---Create a refinery container GUI.  
---@param destroyOnClose boolean # If true the gui is destroyed when closed, otherwise the gui can be reused.
---@return GuiInterface # The gui interface to the created gui.
function sm.gui.createRefineryContainerGui(destroyOnClose) end

---*Client only*  
---Create a saw bot GUI.  
---@param destroyOnClose? boolean # If true the gui is destroyed when closed, otherwise the gui can be reused. (Defaults to false)
---@return GuiInterface # The gui interface to the created gui.
function sm.gui.createSawbotGui(destroyOnClose) end

---*Client only*  
---Create a seat GUI.  
---@param destroyOnClose? boolean # If true the gui is destroyed when closed, otherwise the gui can be reused. (Defaults to false)
---@return GuiInterface # The gui interface to the created gui.
function sm.gui.createSeatGui(destroyOnClose) end

---*Client only*  
---Create a seat upgrade GUI.  
---@param destroyOnClose? boolean # If true the gui is destroyed when closed, otherwise the gui can be reused. (Defaults to false)
---@return GuiInterface # The gui interface to the created gui.
function sm.gui.createSeatUpgradeGui(destroyOnClose) end

---*Client only*  
---Create a seed container GUI.  
---@param destroyOnClose? boolean # If true the gui is destroyed when closed, otherwise the gui can be reused. (Defaults to false)
---@return GuiInterface # The gui interface to the created gui.
function sm.gui.createSeedContainerGui(destroyOnClose) end

---*Client only*  
---Create a steering bearing upgrade GUI.  
---@param destroyOnClose? boolean # If true the gui is destroyed when closed, otherwise the gui can be reused. (Defaults to false)
---@return GuiInterface # The gui interface to the created gui.
function sm.gui.createSteeringBearingGui(destroyOnClose) end

---*Client only*  
---Create a survival hud GUI.  
---@param destroyOnClose? boolean # If true the gui is destroyed when closed, otherwise the gui can be reused. (Defaults to false)
---@return GuiInterface # The gui interface to the created gui.
function sm.gui.createSurvivalHudGui(destroyOnClose) end

---*Client only*  
---Create a water container GUI.  
---@param destroyOnClose? boolean # If true the gui is destroyed when closed, otherwise the gui can be reused. (Defaults to false)
---@return GuiInterface # The gui interface to the created gui.
function sm.gui.createWaterContainerGui(destroyOnClose) end

---*Client only*  
---@deprecated use createWorldIconGui
---Create a waypoint icon GUI.  
---@param destroyOnClose? boolean # If true the gui is destroyed when closed, otherwise the gui can be reused. (Defaults to false)
---@return GuiInterface # The gui interface to the created gui.
function sm.gui.createWaypointIconGui(destroyOnClose) end

---@deprecated Use [sm.gui.createGuiFromLayout]
---Removed! Does nothing.  
function sm.gui.createWidget() end

---*Client only*  
---Create a workbench GUI.  
---@param destroyOnClose? boolean # If true the gui is destroyed when closed, otherwise the gui can be reused. (Defaults to false)
---@return GuiInterface # The gui interface to the created gui.
function sm.gui.createWorkbenchGui(destroyOnClose) end

---*Client only*  
---Create a world icon GUI from a layout file.  
---@param width integer # The width.
---@param height integer # The height.
---@param layout? string # Path to the layout file (Defaults to "$GAME_DATA/Gui/Layouts/Hud/Hud_WorldIcon.layout")
---@param destroyOnClose? boolean # If true the gui is destroyed when closed, otherwise the gui can be reused. (Defaults to false)
---@return GuiInterface # The gui interface to the created gui.
function sm.gui.createWorldIconGui(width, height, layout, destroyOnClose) end

---*Client only*  
---Displays an alert message at the top of the screen for a set duration.  
---@param text string # The message to be displayed
---@param duration? number # The time in seconds during which the message is shown. Defaults to 4 seconds
---@param queued? boolean # If true the message is queued, otherwise it is displayed instantly. Defaults to false
function sm.gui.displayAlertText(text, duration, queued) end

---*Client only*  
---Fades the screen back from a fade to black.  
---@param duration number # Animation duration
---@param force? boolean # If true, start the fade out from full black even if there was no fade to black active. (Defaults to false)
function sm.gui.endFadeToBlack(duration, force) end

---*Client only*  
---Exits the current game and returns to the main menu  
---**Note:**
---*Can only be used in the Challenge Mode*
function sm.gui.exitToMenu() end

---*Client only*  
---Returns the current users language setting.  
---@return string # The language setting ex. "English".
function sm.gui.getCurrentLanguage() end

---@class ItemIcon
---@field itemResource string
---@field group string
---@field name string
---@field trackingType string
---@field shapeType string

---Gets the item resource, group and name for an item icon from a uuid  
---@param uuid Uuid # The uuid.
---@return ItemIcon icon The item resource, group, name, trackingType and shapeType.
function sm.gui.getItemIconFromUuid(uuid) end

---*Client only*  
---Returns the set binding for an action as a string  
---@param action string # The action
---@param hyper? boolean # If the string should contain hyper text (Defaults to false)
---@return string # The key binding
function sm.gui.getKeyBinding(action, hyper) end

---*Client only*  
---Returns the size of the screen.  
---@return integer,integer # The screen size as width and height.
function sm.gui.getScreenSize() end

---*Client only*  
---Returns whether the player has an active gui or not  
---@return boolean # guiActive	Whether the player has an active gui or not.
function sm.gui.hasActiveGui() end

---*Client only*  
---Set gui visibility.  
---@param visible boolean # The gui visibility
function sm.gui.hideGui(visible) end

---*Client only*  
---Set hotbar visibility.  
---@param visible boolean # The hotbar visibility
function sm.gui.hideHotbar(visible) end

---*Client only*  
---Open the garage creation import GUI  
function sm.gui.openGarageImportGui() end

---@deprecated Use [sm.gui.setInteractionText]
---Removed! Does nothing.  
---Set the icon displayed at the center.  
---@param iconName string The icon.
function sm.gui.setCenterIcon(iconName) end

---Set a text for the character that will be displayed above its head. Only has effect in dev build.  
---@param character Character # The character.
---@param text string # The debug text.
---@param clear? boolean # If true the previous text will be overwritten. (Defaults to true)
function sm.gui.setCharacterDebugText(character, text, clear) end

---*Client only*  
---Sets a button callback to be called when the button is pressed.  
---@param callback string # Function to be called when button is pressed
function sm.gui.setGarageButtonCallback(callback) end

---*Client only*  
---Sets a callback to be called when an error with the import is met.  
---@param callback string # Function to be called when error is met
function sm.gui.setGarageErrorCallback(callback) end

---Set the storage container for the garage creation import gui to use  
---@param container Container # The container import gui should use for materials.
function sm.gui.setGarageImportGuiStorage(container) end

---*Client only*  
---Set the binding text displayed at the center.  
---@param text1 string # The leftmost segment.
---@param binding1? string # The left white segment.
---@param text2? string # The mid or end segment.
---@param binding2? string # The right white segment.
---@param text3? string # The rightmost segment.
function sm.gui.setInteractionText(text1, binding1, text2, binding2, text3) end

---*Client only*  
---Set the progress fraction filling the circle icon displayed at the center.  
---@param progress number # The fraction that determines how much of the circle is filled.
function sm.gui.setProgressFraction(progress) end

---*Client only*  
---Fades the screen to black and back after timeout.  
---@param duration number # Animation duration
---@param timeout number # Seconds until the fade fades back
function sm.gui.startFadeToBlack(duration, timeout) end

---*Client only*  
---Fades the screen to black, waits for the world to finish loading, then fades back.  
---First waits until timeout, then holds black until the world is ready or a max timeout is reached.  
---@param duration number # Animation duration
---@param timeout number # Seconds until the fade starts waiting for the world
function sm.gui.startFadeToBlackWaitForWorld(duration, timeout) end

---*Client only*  
---Converts ticks to a HH:MM:SS string representation.  
---@param ticks integer # Game ticks
---@return string # time		Human time formatted string
function sm.gui.ticksToTimeString(ticks) end

---*Client only*  
---Translates all localization tags in a text using the current language.  
---@param text string # The text containing localization tags
---@return string # The text with translated tags
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
---@param path string # A file path to the blueprint to be visualized
---@return BlueprintVisualization # The blueprint visualization
function sm.visualization.createBlueprint(path) end

---*Client only*  
---Create a [BlueprintVisualization] from a blueprint table.  
---@param blueprintTable table # Table with blueprint information to be visualized
---@return BlueprintVisualization # The blueprint visualization
function sm.visualization.createBlueprint(blueprintTable) end

---*Client only*  
---Create a builder guide [BlueprintVisualization], comparing the creation from the root [Shape] to the blueprint give by path.  
---The builder guide blueprint contains stage indices based on shape color, stage color order is the same as the color order in the PaintTool color picker.  
---@param path string # A file path to the builder guide blueprint
---@param shape Shape # Root [Shape] for comparing the creation from
---@param ignoreBlockUuid? boolean # Should block uuid be evaluated for stage completion (Defaults to false)
---@param completeEffectName? string # The name of the effect that should be played at the placed block once the builder guide stage is completed (Defaults to "")
---@param completeEffectAtBaseName? string # The name of the effect that should be played at the base once the builder guide stage is completed (Defaults to "")
---@return BlueprintVisualization # The builder guide blueprint visualization
function sm.visualization.createBuilderGuide(path, shape, ignoreBlockUuid, completeEffectName, completeEffectAtBaseName) end

---*Client only*  
---Adds a builderguide connection guide line between two points.  
---@param startingPoint Vec3 # The starting point for the line.
---@param endPoint Vec3 # The end point for the line.
---@param color? Color # The color for the line. Defaults to yellow. (Optional)
function sm.visualization.drawLine(startingPoint, endPoint, color) end

---@class ShapePlacementVisualization
---@field isLegal boolean
---@field shapeUuid Uuid
---@field worldRotation Quat
---@field worldPosition Vec3

---*Client only*  
---Returns a table containing the current state of the shape placement visualization.  
---@return ShapePlacementVisualization # Table containing { worldPosition = [Vec3], worldRotation = [Quat], shapeUuid = [Uuid], isLegal = boolean }.
function sm.visualization.getShapePlacementVisualization() end

---*Client only*  
---Visualizes a block on an object  
---@param position Vec3 # The local space position
---@param illegal? boolean # Whether the visualization should render as illegal (Defaults to false)
---@param object? Lift|Shape|Joint
function sm.visualization.setBlockVisualization(position, illegal, object) end

---*Client only*  
---Sets an array of bodies to visualize.  
---@param bodies Body[] # Array of bodies to visualize {[Body], ..}.
function sm.visualization.setCreationBodies(bodies) end

---*Client only*  
---Controls the transform of the creation visualization. If true the visualization will render using setFreePlacementPosition/setFreePlacementRotation functions.  
---If false the visualization will render on top of the creation.  
---@param valid boolean # Should the creation visualization be free placement
function sm.visualization.setCreationFreePlacement(valid) end

---*Client only*  
---Set the world position of the creation visualization. Only works if setFreePlacement is true.  
---@param position Vec3 # World position of the creation visualization
function sm.visualization.setCreationFreePlacementPosition(position) end

---*Client only*  
---Set the rotation index of the creation visualization. Only works if setFreePlacement is true.  
---@param index integer # Index to rotate the creation visualization with
function sm.visualization.setCreationFreePlacementRotation(index) end

---*Client only*  
---Controls the rendering of the creation visualization.   
---@param valid boolean # Should the visualization should render be valid
---@param lift? boolean # Should the visualization should render be lift or place (Defaults to false)
function sm.visualization.setCreationValid(valid, lift) end

---*Client only*  
---Controls the visibility of the creation visualization  
---@param visible boolean # Should the creation visualization be visible
function sm.visualization.setCreationVisible(visible) end

---*Client only*  
---Set the lift level of the lift visualization.  
---@param level integer # The level of the lift
function sm.visualization.setLiftLevel(level) end

---*Client only*  
---Set the world position of the lift visualization.  
---@param position Vec3 # World position of the lift visualization
function sm.visualization.setLiftPosition(position) end

---*Client only*  
---Controls the rendering of the lift visualization.   
---@param valid boolean # Whether the visualization should render as valid
function sm.visualization.setLiftValid(valid) end

---*Client only*  
---Controls the visibility of the lift visualization  
---@param visible boolean # Whether the lift visualization is visible
function sm.visualization.setLiftVisible(visible) end


---Render settings  
sm.render = {}

---Gets a table of the default camera light render settings.  
---@return table # The default camera light render settings.
function sm.render.getDefaultCameraLight() end

---Gets a table of the default fog render settings.  
---@return table # The default fog render settings.
function sm.render.getDefaultFog() end

---Gets a table of the default GI render settings.  
---@return table # The default GI render settings.
function sm.render.getDefaultGI() end

---Gets a table of the default horizon light render settings.  
---@return table # The default horizon light render settings.
function sm.render.getDefaultHorizonLight() end

---Gets a table of the default reflection color render settings.  
---@return table # The default reflection color render settings.
function sm.render.getDefaultReflectionColor() end

---Gets a table of the default Volumetric fog render settings.  
---@return table # The default Volumetric fog render settings.
function sm.render.getDefaultVolumetricFog() end

---Gets the default voxel LOD boost render setting.  
---@return number # The default voxel LOD boost render setting.
function sm.render.getDefaultVoxelLODBoost() end

---*Client only*  
---Gets the draw distance.  
---@return number # The draw distance.
function sm.render.getDrawDistance() end

---*Client only*  
---Gets the lighting cycle fraction.  
---@return number # The fraction of the day cycle lighting.
function sm.render.getOutdoorLighting() end

---Return the screen coordinates that align with the given world position.  
---@param pos Vec3 # World position to align
---@param width integer # Screen width
---@param height integer # Screen height
---@return number, number # The x and y screen coordinates.
function sm.render.getScreenCoordinatesFromWorldPosition(pos, width, height) end

---*Client only*  
---Checks if client is outdoor  
---@return boolean # True if local client is outdoor.
function sm.render.isOutdoor() end

---*Client only*  
---Resets all the reflection color settings.  
function sm.render.resetAllReflectionColor() end

---Resets the camera light override settings.  
function sm.render.resetCameraLight() end

---*Client only*  
---Resets the fog override settings.  
function sm.render.resetFog() end

---*Client only*  
---Resets the global illumination override settings.  
function sm.render.resetGI() end

---*Client only*  
---Resets the Horizon light settings.  
function sm.render.resetHorizonLight() end

---*Client only*  
---Resets the LUT override settings.  
function sm.render.resetLUT() end

---*Client only*  
---Resets the Volumetric fog override settings.  
function sm.render.resetVolumetricFog() end

---*Client only*  
---Resets the voxel terrain LOD boost override setting.  
function sm.render.resetVoxelLODBoost() end

---*Client only*  
---Sets the camera light override settings.  
---Optionally sets far camera light settings (used for camera pullback lerp).  
---@param intensity number # The light intensity.
---@param range number # Light range.
---@param color Color # Light color.
---@param farIntensity? number # Far light intensity. (Optional)
---@param farRange? number # Far light range. (Optional)
---@param farColor? Color # Far light color. (Optional)
function sm.render.setCameraLight(intensity, range, color, farIntensity, farRange, farColor) end

---*Client only*  
---Sets if a cinematic is playing  
---@param cinematic boolean # If true, sets to cinematic
function sm.render.setCinematic(cinematic) end

---*Client only*  
---Sets the cloud settings.  
---@param coverage number # The fraction of the cloud coverage.
---@param height number # The cloud height.
---@param radius number # The atmosphere radius.
---@param tallnessScale number # The tallness scale(0.1 - 4.0).
---@param directionalLightMod number # Directional light mod (0.0 - 1.0).
---@param scroll Vec3 # Cloud scroll.
---@param scrollRotation Vec3 # Cloud scroll rotation.
function sm.render.setCloudSettings(coverage, height, radius, tallnessScale, directionalLightMod, scroll, scrollRotation) end

---*Client only*  
---Sets the fog override settings.  
---@param startDistance number # Fog start distance.
---@param endDistance number # Fog end distance.
---@param falloffFactor number # Fog falloff.
---@param startColor Color # Fog start color.
---@param endColor Color # Fog end color.
---@param verticalOpacity number # Vertical fog opacity. (Optional)
---@param verticalFadeDistance number # Vertical fog fade distance.  (Optional)
---@param verticalFalloff number # Vertical fog falloff.  (Optional)
---@param verticalStart number # Vertical fog start distance.  (Optional)
---@param verticalEnd number # Vertical fog end distance.  (Optional)
---@param verticalStartColor Color # Vertical fog start color.  (Optional)
---@param verticalEndColor Color # Vertical fog end color.  (Optional)
---@param fadeDistance number # Fog fade distance. (Optional)
function sm.render.setFog(startDistance, endDistance, falloffFactor, startColor, endColor, verticalOpacity, verticalFadeDistance, verticalFalloff, verticalStart, verticalEnd, verticalStartColor, verticalEndColor, fadeDistance) end

---*Client only*  
---Sets the global illumination override settings.  
---@param weight number # GI weight.
function sm.render.setGI(weight) end

---*Client only*  
---Sets the Horizon light settings.  
---@param topColor Color # Color of the top of the horizon light.
---@param horizonColor Color # Color of the horizon of the horizon light.
---@param bottomColor Color # Color of the bottom of the horizon light.
---@param direction Vec3 # Direction of the horizon light.
---@param startDistance number # Start distance for the horizon light. (Optional)
---@param endDistance number # End distance for the horizon light. (Optional)
---@param falloff number # Falloff factor for the horizon light. (Optional)
function sm.render.setHorizonLight(topColor, horizonColor, bottomColor, direction, startDistance, endDistance, falloff) end

---*Client only*  
---Sets the LUT override settings.  
---@param LUT-A string # Name of LUT A.
---@param LUT-B? string # Name of LUT B.
---@param blend? number # blend between 0.0 and 1.0 for LUT A and B. (Defaults to 0.0)
function sm.render.setLUT(LUT_A, LUT_B, blend) end

---*Client only*  
---Sets the lighting cycle fraction.  
---@param value number # The fraction of the day cycle lighting.
function sm.render.setOutdoorLighting(value) end

---*Client only*  
---Sets the reflection color correction settings for one reflection level.  
---@param settingsLevel string # Off/Low/Medium/High.
---@param min number # Color min.
---@param max number # Color max.
---@param mul number # Color mul.
function sm.render.setReflectionLevelColor(settingsLevel, min, max, mul) end

---*Client only*  
---Sets the Volumetric fog override settings.  
---@param min number # Fog min.
---@param max number # Fog max.
---@param loopSpeed number # Fog loop speed.
---@param scrollSpeed Vec3 # Fog scroll speed.
---@param scale Vec3 # Fog scale.
---@param intensity number # Fog intensity.
function sm.render.setVolumetricFog(min, max, loopSpeed, scrollSpeed, scale, intensity) end

---*Client only*  
---Sets the voxel terrain LOD boost override setting.  
---The value is capped by the current draw distance quality.  
---@param boost number # Voxel terrain LOD boost.
function sm.render.setVoxelLODBoost(boost) end


---Empty
sm.profiler = {}


---The <strong>Garage</strong> library contains various utility functions for handling the garage.  
sm.garage = {}

---Creates a new garage.  
---The garage is a spawn area for creations defined by a bounding box. The garage can track blueprints and import them into the world.  
---The garage is identified by an user specified id.  
---@param garageId integer # The id of the garage to create
---@param world World # The world the garage is in
---@param halfextents Vec3 # Half extents of the spawnbox inside the garage
---@param position Vec3 # Position of the spawn box inside the garage
---@return Garage		Garage					The Garage object
function sm.garage.createGarage(garageId, world, halfextents, position) end

---Gets a already existing garage returns nil if it does not exist.  
---@param garageId integer # The id of the garage to get
---@return Garage		Garage					The Garage object
function sm.garage.getGarage(garageId) end


---The data manager helps storing script data, both locally and between server and client in multiplayer games.  
sm.terrainData = {}

---Check if terrain data exists for this world.  
---@return boolean # True if data exists. False otherwise.
function sm.terrainData.exists() end

---@deprecated Use [sm.terrainData.load]
---Legacy function for reading creative terrain. <strong>Do not use.</strong>  
---@return string # The serialized bitser data.
function sm.terrainData.legacy_getData() end

---@deprecated Use [sm.terrainData.load]
---Legacy function for reading creative custom terrain. <strong>Do not use.</strong>  
---@param id integer # The id.
---@return any # The data. Any lua object.
function sm.terrainData.legacy_loadTerrainData(id) end

---@deprecated Use [sm.terrainData.save]
---Legacy function for storing creative custom terrain. <strong>Do not use.</strong>  
---@param id integer # The id.
---@param data any # The data. Any lua object.
function sm.terrainData.legacy_saveTerrainData(id, data) end

---@deprecated Use [sm.terrainData.save]
---Legacy function for storing creative terrain. <strong>Do not use.</strong>  
---@param data string # The serialized bitser data.
function sm.terrainData.legacy_setData(data) end

---Load terrain data for this world if available.  
---@return any # The data. Any lua object.
function sm.terrainData.load() end

---Save and share terrain data over network from server to client.  
---The data is accessible from the same world.  
---@param data any # The data. Any lua object.
function sm.terrainData.save(data) end


---Reads .tile file data  
sm.terrainTile = {}

---Prefab content load flags.                
---@type { [string]: number }
sm.terrainTile.loadFlags = {
    creations = 1,
    nodes = 2,
    assets = 4,
    decals = 8,
    harvestables = 16,
    kinematics = 32,
    voxelMeshes = 64,
    all = 128,
}

---@class TerrainCreation
---@field name string
---@field pathOrJson string
---@field pos Vec3
---@field rot Quat
---@field rootPrefabCenterPosition Vec3
---@field bodyTransforms? boolean
---@field mergeCreation? boolean
---@field restricted? boolean
---@field erasable? boolean
---@field buildable? boolean
---@field paintable? boolean
---@field connectable? boolean
---@field liftable? boolean
---@field usable? boolean
---@field destructable? boolean
---@field convertableToDynamic? boolean
---@field zoneIndex? number
---@field sortingIndex? number
---@field tags string[]
---@field changeColor? Color[]
---@field debugName? string

---@class TerrainPrefab
---@field name string
---@field pos Vec3
---@field rot Quat
---@field scale Vec3
---@field tags string[]
---@field flags number

---@class TerrainNode
---@field pos Vec3
---@field rot Quat
---@field scale Vec3
---@field rootPrefabCenterPosition Vec3
---@field params table
---@field tags string[]

---@class TerrainAsset
---@field uuid Uuid
---@field pos Vec3
---@field rot Quat
---@field scale Vec3
---@field rootPrefabCenterPosition Vec3
---@field colors { [string] : Color }
---@field tags string[]
---@field slopeNormal? Vec3

---@class TerrainDecal
---@field pos Vec3
---@field rot Quat
---@field scale Vec3
---@field rootPrefabCenterPosition Vec3
---@field decalId Uuid
---@field color Color
---@field layer number
---@field tags string[]

---@class TerrainHarvestable
---@field uuid Uuid
---@field pos Vec3
---@field rot Quat
---@field scale Vec3
---@field rootPrefabCenterPosition Vec3
---@field color Color
---@field colors {[string]: Color}
---@field params? table
---@field tags string[]
---@field slopeNormal? Vec3
---@field removeIfLevitating boolean

---@class TerrainKinematic
---@field uuid Uuid
---@field pos Vec3
---@field rot Quat
---@field scale Vec3
---@field rootPrefabCenterPosition Vec3
---@field color Color
---@field params table
---@field tags string[]
---@field removeIfLevitating boolean

---Returns a table of all assets in a terrain cell.  
---@param tileId Uuid The tile id.
---@param tileOffsetX integer The tile offset X.
---@param tileOffsetY integer The tile offset Y.
---@param sizeLevel integer The size level of asset.
---@return TerrainAsset[] assets
function sm.terrainTile.getAssetsForCell(tileId, tileOffsetX, tileOffsetY, sizeLevel) end

---Returns the clutter index at position (X,Y) in a tile.  
---@param tileUid Uuid # The tile uuid.
---@param cellOffsetX integer # The cell X offset.
---@param cellOffsetY integer # The cell Y offset.
---@param x integer # The local X value.
---@param y integer # The local Y value.
---@return number clutterId
function sm.terrainTile.getClutterIdxAt(tileId, cellOffsetX, cellOffsetY, x, y) end

---Returns the terrain color at position (x,y) in a tile cell.  
---@param tileUid Uuid # The tile uuid.
---@param cellOffsetX integer # The cell X offset.
---@param cellOffsetY integer # The cell Y offset.
---@param lod integer # The level of detail. [0-5]
---@param x integer # The local X value.
---@param y integer # The local Y value.
---@return number,number,number # The color R, G, B values.
function sm.terrainTile.getColorAt(tileUid, cellOffsetX, cellOffsetY, lod, x, y) end

---Returns the content of prefab.  
---@param prefabPath string The path to the prefab file.
---@param loadFlags? integer A mask of content to load
---@return TerrainCreation[] creations, TerrainPrefab[] prefabs, TerrainNode[] nodes, TerrainAsset[] assets, TerrainDecal[] decals, TerrainHarvestable[] harvestables, TerrainKinematic[] kinematics, prefabMinMax {min: Vec3, max: Vec3}
function sm.terrainTile.getContentFromPrefab(prefabPath, loadFlags) end

---Returns a table of all creations in a terrain cell.  
---@param tileUid Uuid # The tile uuid.
---@param cellOffsetX integer # The cell X offset.
---@param cellOffsetY integer # The cell Y offset.
---@return TerrainCreation[] creations # The creations .
function sm.terrainTile.getCreationsForCell(tileUid, cellOffsetX, cellOffsetY) end

---Returns the id of the tiles creator.  
---@param path string The tile's path.
---@return string
function sm.terrainTile.getCreatorId(path) end
---Returns all decals for a cell in a tile.  
---@param tileUid Uuid # The tile uuid.
---@param cellOffsetX integer # The cell X offset.
---@param cellOffsetY integer # The cell Y offset.
---@return TerrainDecal[] decals # The decals.
function sm.terrainTile.getDecalsForCell(tileUid, cellOffsetX, cellOffsetY) end

---Returns a table of all harvestables in a terrain cell.  
---@param tileUid Uuid # The tile uuid.
---@param cellOffsetX integer # The cell X offset.
---@param cellOffsetY integer # The cell Y offset.
---@param sizeLevel integer # The size level of harvestables. [0-3]
---@return TerrainHarvestable[] harvestables
function sm.terrainTile.getHarvestablesForCell(tileId, cellOffsetX, cellOffsetY, sizeLevel) end

---Returns the terrain height at position (x,y) in a tile cell.  
---@param tileUid Uuid # The tile uuid.
---@param cellOffsetX integer # The cell X offset.
---@param cellOffsetY integer # The cell Y offset.
---@param lod integer # The level of detail. [0-5]
---@param x integer # The local X value.
---@param y integer # The local Y value.
---@return number # The height.
function sm.terrainTile.getHeightAt(tileUid, cellOffsetX, cellOffsetY, lod, x, y) end

---Returns a table of all kinematics in a terrain cell.  
---@param tileUid Uuid # The tile uuid.
---@param cellOffsetX integer # The cell X offset.
---@param cellOffsetY integer # The cell Y offset.
---@param sizeLevel integer # The size level of kinematics. [0-3]
---@return TerrainKinematic[] kinematics
function sm.terrainTile.getKinematicsForCell(tileUid, cellOffsetX, cellOffsetY, sizeLevel) end

---Returns the terrain material at position (x,y) in a tile cell.  
---@param tileUid Uuid # The tile uuid.
---@param cellOffsetX integer # The cell X offset.
---@param cellOffsetY integer # The cell Y offset.
---@param lod integer # The level of detail. [0-5]
---@param x integer # The local X value.
---@param y integer # The local Y value.
---@return number material_1_weight, number material_2_weight, number material_3_weight, number material_4_weight, number material_5_weight, number material_6_weight, number material_7_weight, number material_8_weight
function sm.terrainTile.getMaterialAt(tileUid, cellOffsetX, cellOffsetY, lod, x, y) end

---Returns all nodes for a cell in a tile.  
---@param tileUid Uuid # The tile uuid.
---@param cellOffsetX integer # The cell X offset.
---@param cellOffsetY integer # The cell Y offset.
---@return TerrainNode[] nodes
function sm.terrainTile.getNodesForCell(tileUid, cellOffsetX, cellOffsetY) end

---Returns all prefabs in a cell.  
---@param tileUid Uuid # The tile uuid.
---@param cellOffsetX integer # The cell X offset.
---@param cellOffsetY integer # The cell Y offset.
---@return TerrainPrefab[] prefabs
function sm.terrainTile.getPrefabsForCell(tileUid, cellOffsetX, cellOffsetY) end

---Returns the size of a tile as the number of cells along one of the axises.  
---@param path string # The tile's path.
---@return integer # The size.
function sm.terrainTile.getSize(path) end

---Returns the uuid for a tile file.  
---@param path string # The tile's path.
---@return Uuid # The tile's uuid.
function sm.terrainTile.getTileUuid(path) end


---Allows reading and writing in game storage from terrain generation scripts.  
sm.terrainGeneration = {}

---Loads temporary data stored by terrain generation.  
---@param key any # Key used to lookup the saved data.
---@return any # The saved data.
function sm.terrainGeneration.getTempData(key) end

---Loads data stored by terrain generation.  
---@param key any # Key used to lookup the saved data.
---@return any # The saved data.
function sm.terrainGeneration.loadGameStorage(key) end

---Saves data produced from terrain generation and synchronizes to clients. Saved data can be retrived in later game sessions and by the game lua environment.    
---   
---@param key any # Key used to lookup the saved data.
---@param data any # Data to save. 
function sm.terrainGeneration.saveAndSyncGameStorage(key, data) end

---Saves data produced from terrain generation. Saved data can be retrived in later game sessions and by the game lua environment.    
---   
---@param key any # Key used to lookup the saved data.
---@param data any # Data to save. 
function sm.terrainGeneration.saveGameStorage(key, data) end

---Sets data produced from terrain generation and synchronizes to clients. This data is only valid during the game session.  
---@param key any # Key used to lookup the saved data.
---@param data any # Data to save.
function sm.terrainGeneration.setAndSyncGameStorageNoSave(key, data) end

---Sets data produced from terrain generation. This data is only valid during the game session. Does not synchronize to clients  
---   
---@param key any # Key used to lookup the saved data.
---@param data any # Data to save. 
function sm.terrainGeneration.setGameStorageNoSave(key, data) end

---Sets temporary data produced from terrain generation.  
---   
---@param key any # Key used to lookup the saved data.
---@param data any # Data to save. 
function sm.terrainGeneration.setTempData(key, data) end


---Voxel grid  
sm.voxelTerrainCell = {}

---Filters are used to specify what materials an action should modify.
sm.voxelTerrainCell.voxelFilter = {
    none      = 0,
    material0 = 1,
    material1 = 2,
    material2 = 4,
    material3 = 8,
    material4 = 16,
    material5 = 32,
    material6 = 64,
    material7 = 128,
    all       = 255,
}

---Copies a custom amount of voxel data from a tile to the voxel grid.  
---@param tileUid Uuid # The tile uuid.
---@param cellOffsetX integer # The tile cell X offset.
---@param cellOffsetY integer # The tile cell Y offset.
---@param rotationStep integer # The tile rotation (0-3).
---@param srcPos? Vec3 # The source chunk coord in the tile cell to copy.
---@param dstPos? Vec3 # The destination coord in the cell voxel grid.
---@param srcSize? Vec3 # The source size in chunks to copy.
function sm.voxelTerrainCell.copyTileCellVoxels(tileUid, cellOffsetX, cellOffsetY, rotationStep, srcPos, dstPos, srcSize) end

---Copies a custom amount of voxel data from a tile to the voxel grid.  
---@param tileUid Uuid # The tile uuid.
---@param cellOffsetX integer # The tile cell X offset.
---@param cellOffsetY integer # The tile cell Y offset.
---@param rotationStep integer # The tile rotation (0-3).
---@param srcPos Vec3 # The source chunk coord in the tile to copy.
---@param dstPos Vec3 # The destination coord in the cell voxel grid.
---@param srcSize Vec3 # The source size in chunks to copy.
function sm.voxelTerrainCell.copyTileCellVoxelsOnlyAir(tileUid, cellOffsetX, cellOffsetY, rotationStep, srcPos, dstPos, srcSize) end

---Copies a custom amount of voxel data from a tile to the voxel grid.  
---@param tileUid Uuid # The tile uuid.
---@param cellOffsetX integer # The tile cell X offset.
---@param cellOffsetY integer # The tile cell Y offset.
---@param rotationStep integer # The tile rotation (0-3).
---@param srcPos Vec3 # The source chunk coord in the tile to copy.
---@param dstPos Vec3 # The destination coord in the cell voxel grid.
---@param srcSize Vec3 # The source size in chunks to copy.
---@param voxelFilter integer # The voxel material filter to be copied. (See [sm.voxelTerrainCell.voxelFilter])
function sm.voxelTerrainCell.copyTileCellVoxelsOnlyAirAndMasked(tileUid, cellOffsetX, cellOffsetY, rotationStep, srcPos, dstPos, srcSize, voxelFilter) end

---Copies a custom amount of voxel data from a tile to the voxel grid.  
---@param tileUid Uuid # The tile uuid.
---@param cellOffsetX integer # The tile cell X offset.
---@param cellOffsetY integer # The tile cell Y offset.
---@param rotationStep integer # The tile rotation (0-3).
---@param srcPos Vec3 # The source chunk coord in the tile to copy.
---@param dstPos Vec3 # The destination coord in the cell voxel grid.
---@param srcSize Vec3 # The source size in chunks to copy.
function sm.voxelTerrainCell.copyTileCellVoxelsOnlyFilled(tileUid, cellOffsetX, cellOffsetY, rotationStep, srcPos, dstPos, srcSize) end

---Sets empty voxel (below threshold) material and density in convex hull shape in the cell's voxel grid.  
---@param vertices Vec3[] # Table of vertices {[Vec3], ...} that make up the convex hull.
---@param margin number # Hull margin added outside the hull.
---@param densityThreshold number # Existing normalized density must be below threshold for fill to happen.
---@param material integer # New material to set in convex hull.
---@param density number # New normalized density to set in convex hull.
---@param noiseFrequency? number # Noise frequency of applied simplex noise. (Defaults to 1)
---@param noiseIntensity? number # Noise intensity of applied simplex noise. (Defaults to 0)
function sm.voxelTerrainCell.fillEmptyConvexHull(vertices, margin, densityThreshold, material, density, noiseFrequency, noiseIntensity) end

---Sets density in convex hull shape to the cell's voxel grid.  
---@param vertices Vec3[] # Table of vertices {[Vec3], ...} that make up the convex hull.
---@param margin number # Hull margin added outside the hull.
---@param density number # New normalized density.
---@param voxelFilter? integer # The voxel material filter to overwrite. (Defaults to [sm.voxelTerrainCell.voxelFilter, sm.voxelTerrainCell.voxelFilter.all])
---@param noiseFrequency? number # Noise frequency of applied simplex noise. (Defaults to 1)
---@param noiseIntensity? number # Noise intensity of applied simplex noise. (Defaults to 0)
function sm.voxelTerrainCell.setDensityConvexHull(vertices, margin, density, voxelFilter, noiseFrequency, noiseIntensity) end

---Sets material in convex hull shape in the cell's voxel grid.  
---@param vertices Vec3[] # Table of vertices {[Vec3], ...} that make up the convex hull.
---@param margin number # Hull margin added outside the hull.
---@param material integer # New material in convex hull.
---@param density number # New normalized density.
---@param voxelFilter? integer # The voxel material filter to overwrite. (Defaults to [sm.voxelTerrainCell.voxelFilter, sm.voxelTerrainCell.voxelFilter.all])
---@param noiseFrequency? number # Noise frequency of applied simplex noise. (Defaults to 1)
---@param noiseIntensity? number # Noise intensity of applied simplex noise. (Defaults to 0)
function sm.voxelTerrainCell.setMaterialAndDensityConvexHull(vertices, margin, material, density, voxelFilter, noiseFrequency, noiseIntensity) end

---Sets material in convex hull shape in the cell's voxel grid.  
---@param vertices Vec3[] # Table of vertices {[Vec3], ...} that make up the convex hull.
---@param margin number # Hull margin added outside the hull.
---@param material integer # New material in convex hull.
---@param voxelFilter? integer # The voxel material filter to overwrite. (Defaults to [sm.voxelTerrainCell.voxelFilter, sm.voxelTerrainCell.voxelFilter.all])
---@param noiseFrequency? number # Noise frequency of applied simplex noise. (Defaults to 1)
---@param noiseIntensity? number # Noise intensity of applied simplex noise. (Defaults to 0)
function sm.voxelTerrainCell.setMaterialConvexHull(vertices, margin, material, voxelFilter, noiseFrequency, noiseIntensity) end

---Writes the voxel data from a tile to the cell's voxel grid.  
---@param tileUid Uuid # The tile uuid.
---@param cellOffsetX integer # The tile cell X offset.
---@param cellOffsetY integer # The tile cell Y offset.
---@param rotationStep integer # The tile rotation (0-3).
function sm.voxelTerrainCell.writeTileCellVoxels(tileUid, cellOffsetX, cellOffsetY, rotationStep) end


sm.terrainHarvestable = {}

---Calculates the initial hash of a kinematic. The initial hash identifies the kinematic by its initial world position, uuid and world id.  
---This hash will be unsalted. Usually kinematics created from script rather than from cell loading have their hashes salted with random numbers.  
---@param uuid Uuid # The kinematic uuid.
---@param world World # The world the kinematic is in.
---@param position Vec3 # The initial position of the kinematic in world space.
---@param rotation Quat # The initial rotation of the kinematic.
---@return number # The calculated unsalted initial hash.
function sm.terrainHarvestable.calculateInitialHash(uuid, world, position, rotation) end

---Use to generate cell data for producing tunnels through voxels.  
sm.tunnelGenerator = {}

---@class TunnelPathingSettings
---@field costNoiseFrequency number
---@field costNoiseIntensity number
---@field costZPenalty number

---@class TunnelRequest
---@field posA Vec3
---@field posB Vec3
---@field dirA? Vec3
---@field dirB? Vec3
---@field pathingSettings string

---@class TunnelBlocker
---@field mi Vec3
---@field mx Vec3
---@field type string

---@class Tunnel
---@field positions Vec3[]
---@field tunnelType string

---Returns an array table of pathing results. Each element consisting of a table {{positions={[Vec3],...}} of position arrays.  
---@param seed integer # Simplex noise seed.
---@param min Vec3 # Grid min x (inclusive).
---@param max Vec3 # Grid max x (non inclusive).
---@param pathingSettings { [string]: TunnelPathingSettings } # An table of available pathing settings to be used by tunnel requests. {costNoiseFrequency=number,costNoiseIntensity=number,costZPenalty=number}
---@param tunnelRequests TunnelRequest[] # An array table of tunnel requests. {{posA=[Vec3], posB=[Vec3](, dirA=[Vec3])(, dirB=[Vec3]), pathingSettings=string},...}
---@param blockers TunnelBlocker[] # An array table of tunnel blockers.  {{mi=[Vec3], mx=[Vec3], type=string},...}
---@param gridSize number # Size of each grid cell in world units. (Used for debug draw only.)
---@return Tunnel[] # An array table with one tunnel result per request. {{positions={[Vec3],...}}, ...}
function sm.tunnelGenerator.generate(seed, min, max, pathingSettings, tunnelRequests, blockers, gridSize) end


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
---@param timeStep number # The time period of a tick. (Is always 0.025, a 1/40th of a second.)
function CharacterClass:server_onFixedUpdate(timeStep) end

---Called every game tick &ndash; 40 ticks a second. If the frame rate is lower than 40 fps, this event may be called twice.  
---During a fixed update, physics and logic between interactables are updated.  
---@param timeStep number # The time period of a tick. (Is always 0.025, a 1/40th of a second.)
function CharacterClass:client_onFixedUpdate(timeStep) end

---Called every frame.  
---During a frame update, graphics, animations and effects are updated.  
---**Warning:**
---*Because of how frequent this event is called, the game's frame rate is greatly affected by the amount of code executed here.*
---*For any non-graphics related code, consider using [CharacterClass.client_onFixedUpdate, client_onFixedUpdate] instead.*
---*If the event is not in use, consider removing it from the script. (Event callbacks that are not implemented will not be called.)*
---@param deltaTime number # Delta time since the last frame.
function CharacterClass:client_onUpdate(deltaTime) end

---Called when the client receives new client data updates from the server set with [Network.setClientData].  
---Data set in this way is persistent and the latest data will automatically be sent to new clients.  
---The data will arrive after [CharacterClass.client_onCreate, client_onCreate] during the same tick.  
---Channel 1 will be received before channel 2 if both are updated.  
---@param data any # Any lua object set with [Network.setClientData]
---@param channel? 1|2 # Client data channel, 1 or 2. (default: 1)
function CharacterClass:client_onClientDataUpdate(data, channel) end

---Called when the [Character] is hit by a projectile.  
---**Note:**
---*If the shooter is destroyed before the hit lands, the shooter value will be nil.*
---@param position Vec3 # The position in world space where the projectile hit the [Character].
---@param airTime number # The time, in seconds, that the projectile spent flying before the hit.
---@param velocity Vec3 # The velocity of the projectile at impact.
---@param projectileName string # The name of the projectile. (Legacy, use uuid instead)
---@param shooter Player|Shape|Harvestable|nil # The shooter, can be a [Player], [Shape], [Harvestable] or nil if unknown. Projectiles shot by a [Unit] will be nil on the client.
---@param damage number # The damage value of the projectile.
---@param customData any # A Lua object that can be defined at shoot time using [sm.projectile.customProjectileAttack] or an other custom version. 
---@param normal Vec3 # The normal at the point of impact.
---@param uuid Uuid # The uuid of the projectile.
---@param mass number # The mass of the projectile.
function CharacterClass:client_onProjectile(position, airTime, velocity, projectileName, shooter, damage, customData, normal, uuid, mass) end

---Called when the [Character] is hit by a melee hit.  
---@param position Vec3 # The position in world space where the [Character] was hit.
---@param attacker Player|nil # The attacker. Can be a [Player] or nil if unknown. Attacks made by a [Unit] will be nil on the client.
---@param damage integer # The damage value of the melee hit.
---@param power number # The physical impact impact of the hit.
---@param direction Vec3 # The direction that the melee attack was made.
---@param normal Vec3 # The normal at the point of impact.
function CharacterClass:client_onMelee(position, attacker, damage, power, direction, normal) end

---Called when the [Character] collides with another object.  
---@param other Player|Shape|Harvestable|nil # The other object. Nil if terrain.
---@param position Vec3 # The position in world space where the collision occurred.
---@param selfPointVelocity Vec3 # The velocity that that the [Character] had at the point of collision.
---@param otherPointVelocity Vec3 # The velocity that that the other object had at the point of collision.
---@param normal Vec3 # The collision normal between the [Character] and the other other object.
function CharacterClass:client_onCollision(other, position, selfPointVelocity, otherPointVelocity, normal) end

---Called when graphics are loaded for the [Character].  
---After this; graphics related functions can be called, like accessing animations.  
function CharacterClass:client_onGraphicsLoaded() end

---Called when graphics are unloaded for the [Character].  
---After this; graphics related functions no longer has an effect or will fail.  
function CharacterClass:client_onGraphicsUnloaded() end

---Called when a [Player] is interacting with the [Character] by pressing the 'Use' key (default 'E').  
---@param character Character # The [Character] of the [Player] that is interacting with this [Character].
---@param state boolean # The interaction state. Always true. The [CharacterClass] only receives the key down event.
function CharacterClass:client_onInteract(character, state) end

---Called to check whether the [Character] can be interacted with at this moment.  
---**Note:**
---*This callback is also responsible for updating interaction text shown to the player using [sm.gui.setInteractionText].*
---@param character Character # The [Character] of the [Player] that is looking at this [Character].
---@return boolean # A boolean indicating whether the characer can be interacted with or not. (Defaults to true if [CharacterClass.client_onInteract, client_onInteract] is implemented, otherwise false)
function CharacterClass:client_canInteract(character) end

---Called when the [Character] receives an event from [Player.sendCharacterEvent] or [Unit.sendCharacterEvent].  
---This is usually for triggering animations on the character.  
---For more extensive events, see [sm.event.sendToCharacter].  
---@param event string # The event name.
function CharacterClass:client_onEvent(event) end


---@class ClientScriptableObjectClass
---A client script class that doesn't represent any particular game object.  
---Can receive events sent with [sm.event.sendToScriptableObject].  
---@field scriptableObject ScriptableObject The [ScriptableObject] belonging to this class instance.
---@field data any Data from the "data" json element.
---@field params any Parameter sent to [sm.scriptableObject.createScriptableObject].
local ClientScriptableObjectClass = class()

---Called when the scripted object is created. This occurs when a new object is built, spawned, or loaded from the save file.  
function ClientScriptableObjectClass:server_onCreate() end

---Called when the scripted object is created. This occurs when a new object is built, spawned, or loaded from the save file.  
function ClientScriptableObjectClass:client_onCreate() end

---Called when the scripted object is destroyed.  
function ClientScriptableObjectClass:server_onDestroy() end

---Called when the scripted object is destroyed.  
function ClientScriptableObjectClass:client_onDestroy() end

---Called if the Lua script attached to the object is modified while the game is running.  
---**Note:**
---*This event requires Scrap Mechanic to be running with the '-dev' flag. This will allow scripts to automatically refresh upon changes.*
function ClientScriptableObjectClass:server_onRefresh() end

---Called if the Lua script attached to the object is modified while the game is running.  
---**Note:**
---*This event requires Scrap Mechanic to be running with the '-dev' flag. This will allow scripts to automatically refresh upon changes.*
function ClientScriptableObjectClass:client_onRefresh() end

---Called every game tick &ndash; 40 ticks a second. If the frame rate is lower than 40 fps, this event may be called twice.  
---During a fixed update, physics and logic between interactables are updated.  
---@param timeStep number # The time period of a tick. (Is always 0.025, a 1/40th of a second.)
function ClientScriptableObjectClass:server_onFixedUpdate(timeStep) end

---Called every game tick &ndash; 40 ticks a second. If the frame rate is lower than 40 fps, this event may be called twice.  
---During a fixed update, physics and logic between interactables are updated.  
---@param timeStep number # The time period of a tick. (Is always 0.025, a 1/40th of a second.)
function ClientScriptableObjectClass:client_onFixedUpdate(timeStep) end

---Called every frame.  
---During a frame update, graphics, animations and effects are updated.  
---**Warning:**
---*Because of how frequent this event is called, the game's frame rate is greatly affected by the amount of code executed here.*
---*For any non-graphics related code, consider using [ClientScriptableObjectClass.client_onFixedUpdate, client_onFixedUpdate] instead.*
---*If the event is not in use, consider removing it from the script. (Event callbacks that are not implemented will not be called.)*
---@param deltaTime number # Delta time since the last frame.
function ClientScriptableObjectClass:client_onUpdate(deltaTime) end

---Called when the client receives new client data updates from the server set with [Network.setClientData].  
---Data set in this way is persistent and the latest data will automatically be sent to new clients.  
---The data will arrive after [ClientScriptableObjectClass.client_onCreate, client_onCreate] during the same tick.  
---Channel 1 will be received before channel 2 if both are updated.  
---@param data any # Any lua object set with [Network.setClientData]
---@param channel? 1|2 # Client data channel, 1 or 2. (default: 1)
function ClientScriptableObjectClass:client_onClientDataUpdate(data, channel) end


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

---Enables or disables recipes being locked and needing to be learned to build items. (Defaults to true)  
GameClass.enableRecipes = {}

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
---@param timeStep number # The time period of a tick. (Is always 0.025, a 1/40th of a second.)
function GameClass:server_onFixedUpdate(timeStep) end

---Called every game tick &ndash; 40 ticks a second. If the frame rate is lower than 40 fps, this event may be called twice.  
---During a fixed update, physics and logic between interactables are updated.  
---@param timeStep number # The time period of a tick. (Is always 0.025, a 1/40th of a second.)
function GameClass:client_onFixedUpdate(timeStep) end

---Called every frame.  
---During a frame update, graphics, animations and effects are updated.  
---**Warning:**
---*Because of how frequent this event is called, the game's frame rate is greatly affected by the amount of code executed here.*
---*For any non-graphics related code, consider using [GameClass.client_onFixedUpdate, client_onFixedUpdate] instead.*
---*If the event is not in use, consider removing it from the script. (Event callbacks that are not implemented will not be called.)*
---@param deltaTime number # Delta time since the last frame.
function GameClass:client_onUpdate(deltaTime) end

---Called when the client receives new client data updates from the server set with [Network.setClientData].  
---Data set in this way is persistent and the latest data will automatically be sent to new clients.  
---The data will arrive after [GameClass.client_onCreate, client_onCreate] during the same tick.  
---Channel 1 will be received before channel 2 if both are updated.  
---@param data any # Any lua object set with [Network.setClientData]
---@param channel? 1|2 # Client data channel, 1 or 2. (default: 1)
function GameClass:client_onClientDataUpdate(data, channel) end

---Called when a [Player] joins the game.  
---@param player Player # The joining player.
---@param newPlayer boolean # True if the player has not been in this game before.
function GameClass:server_onPlayerJoined(player, newPlayer) end

---Called when a [Player] leaves the game.  
---@param player Player # The leaving player.
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

---Called when a game session ends.  
function GameClass:server_onUnload() end

---Called when the loading screen is lifted when entering a game.  
function GameClass:client_onLoadingScreenLifted() end

---Called when the user changes language in the in-game menus.  
---Possible language values:  
---"Brazilian", "Chinese", "English", "French", "German", "Italian", "Japanese", "Korean", "Polish", "Russian", "Spanish"  
---@param language string # The new language.
function GameClass:client_onLanguageChange(language) end

---Called when the user presses unstuck in the in-game main menu.  
function GameClass:client_onUnstuck() end


---@class HarvestableClass
---A script class that is instanced for every [Harvestable] in the game.  
---A tree or a plant that can be harvested is a typical case of a harvestable.  
---Can receive events sent with [sm.event.sendToHarvestable].  
---@field harvestable Harvestable The [Harvestable] game object belonging to this class instance.
---@field network Network A [Network] object that can be used to send messages between client and server.
---@field storage Storage (Server side only.) A [Storage] object that can be used to store data for the next time loading this object after being unloaded.
---@field data any Data from the "data" json element.
---@field params any Parameter sent to [sm.harvestable.create] or set in the terrain generation script.
---@field tags any The tags set on the harvestable from the editor.
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
---@param timeStep number # The time period of a tick. (Is always 0.025, a 1/40th of a second.)
function HarvestableClass:server_onFixedUpdate(timeStep) end

---Called every game tick &ndash; 40 ticks a second. If the frame rate is lower than 40 fps, this event may be called twice.  
---During a fixed update, physics and logic between interactables are updated.  
---@param timeStep number # The time period of a tick. (Is always 0.025, a 1/40th of a second.)
function HarvestableClass:client_onFixedUpdate(timeStep) end

---Called every frame.  
---During a frame update, graphics, animations and effects are updated.  
---**Warning:**
---*Because of how frequent this event is called, the game's frame rate is greatly affected by the amount of code executed here.*
---*For any non-graphics related code, consider using [HarvestableClass.client_onFixedUpdate, client_onFixedUpdate] instead.*
---*If the event is not in use, consider removing it from the script. (Event callbacks that are not implemented will not be called.)*
---@param deltaTime number # Delta time since the last frame.
function HarvestableClass:client_onUpdate(deltaTime) end

---Called when the client receives new client data updates from the server set with [Network.setClientData].  
---Data set in this way is persistent and the latest data will automatically be sent to new clients.  
---The data will arrive after [HarvestableClass.client_onCreate, client_onCreate] during the same tick.  
---Channel 1 will be received before channel 2 if both are updated.  
---@param data any # Any lua object set with [Network.setClientData]
---@param channel? 1|2 # Client data channel, 1 or 2. (default: 1)
function HarvestableClass:client_onClientDataUpdate(data, channel) end

---Called when the [Harvestable] is unloaded from the game because no [Player]'s [Character] is close enough to it. Also called when exiting the game.  
function HarvestableClass:server_onUnload() end

---Called occasionally on the [HarvestableClass] to indicate that some time has passed.  
---For performance reasons; it recommended to use this instead of [HarvestableClass.server_onFixedUpdate] for updates that do not need to happen frequently.  
---Use [sm.game.getCurrentTick] to calculate the time.  
function HarvestableClass:server_onReceiveUpdate() end 

---Called when the [Harvestable] collides with another object.  
---@param other Shape/Character # The other object.
---@param position Vec3 # The position in world space where the collision occurred.
---@param selfPointVelocity Vec3 # The velocity that the [Harvestable] had at the point of collision.
---@param otherPointVelocity Vec3 # The velocity that the other object had at the point of collision.
---@param normal Vec3 # The collision normal between the [Harvestable] and the other other object.
function HarvestableClass:client_onCollision(other, position, selfPointVelocity, otherPointVelocity, normal) end

---Called when the [Harvestable] collides with another object.  
---@param other Shape/Character # The other object.
---@param position Vec3 # The position in world space where the collision occurred.
---@param selfPointVelocity Vec3 # The velocity that the [Harvestable] had at the point of collision.
---@param otherPointVelocity Vec3 # The velocity that the other object had at the point of collision.
---@param normal Vec3 # The collision normal between the [Harvestable] and the other other object.
function HarvestableClass:server_onCollision(other, position, selfPointVelocity, otherPointVelocity, normal) end

---Called when the [Harvestable] is hit by a projectile.  
---**Note:**
---*If the shooter is destroyed before the projectile hits, the shooter value will be nil.*
---@param position Vec3 # The position in world space where the projectile hit the [Harvestable].
---@param airTime number # The time, in seconds, that the projectile spent flying before the hit.
---@param velocity Vec3 # The velocity of the projectile at impact.
---@param projectileName string # The name of the projectile. (Legacy, use uuid instead)
---@param shooter Player|Shape|Harvestable|nil # The shooter, can be a [Player], [Shape], [Harvestable] or nil if unknown. Projectiles shot by a [Unit] will be nil on the client.
---@param damage integer # The damage value of the projectile.
---@param customData any # A Lua object that can be defined at shoot time using [sm.projectile.customProjectileAttack] or an other custom version. 
---@param normal Vec3 # The normal at the point of impact.
---@param uuid Uuid # The uuid of the projectile.
---@param mass number # The mass of the projectile.
function HarvestableClass:client_onProjectile(position, airTime, velocity, projectileName, shooter, damage, customData, normal, uuid, mass) end

---Called when the [Harvestable] is hit by a projectile.  
---**Note:**
---*If the shooter is destroyed before the projectile hits, the shooter value will be nil.*
---@param position Vec3 # The position in world space where the projectile hit the [Harvestable].
---@param airTime number # The time, in seconds, that the projectile spent flying before the hit.
---@param velocity Vec3 # The velocity of the projectile at impact.
---@param projectileName string # The name of the projectile. (Legacy, use uuid instead)
---@param shooter Player|Unit|Shape|Harvestable|nil # The shooter. Can be a [Player], [Unit], [Shape], [Harvestable] or nil if unknown.
---@param damage integer # The damage value of the projectile.
---@param customData any # A Lua object that can be defined at shoot time using [sm.projectile.customProjectileAttack] or an other custom version. 
---@param normal Vec3 # The normal at the point of impact.
---@param uuid Uuid # The uuid of the projectile.
---@param mass number # The mass of the projectile.
function HarvestableClass:server_onProjectile(position, airTime, velocity, projectileName, shooter, damage, customData, normal, uuid, mass) end

---Called when the [Harvestable] is hit by an explosion.  
---@param center Vec3 # The center of the explosion.
---@param destructionLevel integer # The level of destruction done by this explosion. Corresponds to the "durability" rating of a [Shape].
---@param damage integer # The damage value of the explosion.
function HarvestableClass:server_onExplosion(center, destructionLevel, damage) end

---Called when the [Harvestable] is hit by a melee attack.  
---**Note:**
---*If the attacker is destroyed before the hit lands, the attacker value will be nil.*
---@param position Vec3 # The position in world space where the [Harvestable] was hit.
---@param attacker Player|nil # The attacker. Can be a [Player] or nil if unknown. Attacks made by a [Unit] will be nil on the client.
---@param damage integer # The damage value of the melee hit.
---@param power number # The physical impact of the hit.
---@param direction Vec3 # The direction that the melee attack was made.
---@param normal Vec3 # The normal at the point of impact.
function HarvestableClass:client_onMelee(position, attacker, damage, power, direction, normal) end

---Called when the [Harvestable] is hit by a melee attack.  
---**Note:**
---*If the attacker is destroyed before the hit lands, the attacker value will be nil.*
---@param position Vec3 # The position in world space where the [Harvestable] was hit.
---@param attacker Player|Unit|nil # The attacker. Can be a [Player], [Unit] or nil if unknown.
---@param damage integer # The damage value of the melee hit.
---@param power number # The physical impact of the hit.
---@param direction Vec3 # The direction that the melee attack was made.
---@param normal Vec3 # The normal at the point of impact.
function HarvestableClass:server_onMelee(position, attacker, damage, power, direction, normal) end

---Called when a [Player] wants to remove the [Harvestable].  
---**Note:**
---*The [HarvestableClass] is responsible for doing the remove using [Harvestable.destroy].*
---@param player Player # The [Player] that wants to remove the [Harvestable].
function HarvestableClass:server_onRemoved(player) end

---Called to check whether the [Harvestable] can be erased at this moment.  
---@return boolean # A boolean indicating whether the [Harvestable] can be removed or not. (Defaults to "removable" json value which defaults to false)
function HarvestableClass:client_canErase() end

---Called to check whether the [Harvestable] can be erased at this moment.  
---@return boolean # A boolean indicating whether the [Harvestable] can be removed or not. (Defaults to "removable" json value which defaults to false)
function HarvestableClass:server_canErase() end

---Called when a [Player] is interacting with the [Harvestable] by pressing the 'Use' key (default 'E').  
---@param character Character # The [Character] of the [Player] that is interacting with the [Harvestable].
---@param state boolean # The interaction state. Always true. The [HarvestableClass] only receives the key down event.
function HarvestableClass:client_onInteract(character, state) end

---Called to check whether the [Harvestable] can be interacted with at this moment.  
---**Note:**
---*This callback is also responsible for updating interaction text shown to the player using [sm.gui.setInteractionText].*
---@param character Character # The [Character] of the [Player] that is looking at the [Harvestable].
---@return boolean # A boolean indicating whether the harvestable can be interacted with or not. (Defaults to true if [HarvestableClass.client_onInteract, client_onInteract] is implemented, otherwise false)
function HarvestableClass:client_canInteract(character) end

---Called when the harvestable receives input from a player with the [Character] locked to the [Harvestable].  
---When a [Character] is seated in a [Harvestable] with a "seat" component, the [Character] is also considered locked to the [Harvestable].  
---@param action integer # The action as an integer value. More details in [sm.interactable.actions].
---@param state boolean # True on begin action, false on end action.
function HarvestableClass:client_onAction(action, state) end

---Called when the [Harvestable] is ignited by a nearby fire.  
function HarvestableClass:server_onIgnite() end

---Called when the [Harvestable] is floating.  
function HarvestableClass:server_onFloating() end


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
---@param timeStep number # The time period of a tick. (Is always 0.025, a 1/40th of a second.)
function PlayerClass:server_onFixedUpdate(timeStep) end

---Called every game tick &ndash; 40 ticks a second. If the frame rate is lower than 40 fps, this event may be called twice.  
---During a fixed update, physics and logic between interactables are updated.  
---@param timeStep number # The time period of a tick. (Is always 0.025, a 1/40th of a second.)
function PlayerClass:client_onFixedUpdate(timeStep) end

---Called every frame.  
---During a frame update, graphics, animations and effects are updated.  
---**Warning:**
---*Because of how frequent this event is called, the game's frame rate is greatly affected by the amount of code executed here.*
---*For any non-graphics related code, consider using [PlayerClass.client_onFixedUpdate, client_onFixedUpdate] instead.*
---*If the event is not in use, consider removing it from the script. (Event callbacks that are not implemented will not be called.)*
---@param deltaTime number # Delta time since the last frame.
function PlayerClass:client_onUpdate(deltaTime) end

---Called when the client receives new client data updates from the server set with [Network.setClientData].  
---Data set in this way is persistent and the latest data will automatically be sent to new clients.  
---The data will arrive after [PlayerClass.client_onCreate, client_onCreate] during the same tick.  
---Channel 1 will be received before channel 2 if both are updated.  
---@param data any # Any lua object set with [Network.setClientData]
---@param channel? 1|2 # Client data channel, 1 or 2. (default: 1)
function PlayerClass:client_onClientDataUpdate(data, channel) end

---Called when the player presses or releases the 'Use' key (default 'E').  
---@param character Character # The [Player]'s [Character]'. Same as self.player.character.
---@param state boolean # The interaction state. (true if pressed, false if released)
function PlayerClass:client_onInteract(character, state) end

---Called when the player presses the 'Cancel' key (default 'Esc').  
function PlayerClass:client_onCancel() end

---Called when the player presses the 'Cancel' key (default 'Esc') if a dialogue is active and no other gui has focus.  
function PlayerClass:client_onSkipDialog() end

---Called when the player presses the 'Reload' key (default 'R').  
function PlayerClass:client_onReload() end

---Called when the [Player]'s [Character] is hit by a projectile.  
---**Note:**
---*If the shooter is destroyed before the projectile hits, the shooter value will be nil.*
---@param position Vec3 # The position in world space where the projectile hit the [Player]'s [Character].
---@param airTime number # The time, in seconds, that the projectile spent flying before the hit.
---@param velocity Vec3 # The velocity of the projectile at impact.
---@param projectileName string # The name of the projectile. (Legacy, use uuid instead)
---@param shooter Player|Unit|Shape|Harvestable|nil # The shooter. Can be a [Player], [Unit], [Shape], [Harvestable] or nil if unknown.
---@param damage integer # The damage value of the projectile.
---@param customData any # A Lua object that can be defined at shoot time using [sm.projectile.customProjectileAttack] or an other custom version. 
---@param normal Vec3 # The normal at the point of impact.
---@param uuid Uuid # The uuid of the projectile.
---@param mass number # The mass of the projectile.
function PlayerClass:server_onProjectile(position, airTime, velocity, projectileName, shooter, damage, customData, normal, uuid, mass) end

---Called when the [Player]'s [Character] is hit by an explosion.  
---@param center Vec3 # The center of the explosion.
---@param destructionLevel integer # The level of destruction done by this explosion. Corresponds to the 'durability' rating of a [Shape].
---@param damage integer # The damage value of the explosion.
function PlayerClass:server_onExplosion(center, destructionLevel, damage) end

---Called when the [Player]'s [Character] is hit by a melee hit.  
---**Note:**
---*If the attacker is destroyed before the projectile hits, the attacker value will be nil.*
---@param position Vec3 # The position in world space where the [Player]'s [Character] was hit.
---@param attacker Player|Unit|nil # The attacker. Can be a [Player], [Unit] or nil if unknown.
---@param damage integer # The damage value of the melee hit.
---@param power number # The physical impact impact of the hit.
---@param direction Vec3 # The direction that the melee attack was made.
---@param normal Vec3 # The normal at the point of impact.
function PlayerClass:server_onMelee(position, attacker, damage, power, direction, normal) end

---Called when the [Player]'s [Character] collides with another object.  
---@param other Shape|Character|Harvestable|Lift|nil # The other object. Nil if terrain.
---@param position Vec3 # The position in world space where the collision occurred.
---@param selfPointVelocity Vec3 # The velocity that that the [Player]'s [Character] had at the point of collision.
---@param otherPointVelocity Vec3 # The velocity that that the other object had at the point of collision.
---@param normal Vec3 # The collision normal between the [Player]'s [Character] and the other other object.
function PlayerClass:server_onCollision(other, position, selfPointVelocity, otherPointVelocity, normal) end

---Called when the [Player]'s [Character] is crushed.  
function PlayerClass:server_onCollisionCrush() end

---@class RemovedShape
---@field uuid Uuid
---@field amount number
---@field type "part"|"block"|"joint"

---Called when the [Player] removed a [Shape] from the [World].  
---Will receive a table of tables listing the items removed by this action.  
---Element format:   
---[Uuid]	uuid	The item uuid.  
---integer	amount	The amount of items with this uuid.  
---string	type	Type of shape removed. Can be "part", "block" or "joint".  
---@param items RemovedShape[] # A table listing the removed items. {{uuid=[Uuid], amount=integer, type=string}, ..}
function PlayerClass:server_onShapeRemoved(items) end

---@class InventoryChange
---@field uuid Uuid
---@field difference number
---@field tool? Tool

---Called when the [Player] has changes in the inventory [Container].  
---Will receive a table listing the changes.  
---Element format:   
---[Uuid]	uuid	The item uuid  
---integer	difference	The change in amount. Positive numbers mean item gain, negative item loss.  
---[Tool]	tool	(Optional) If the item is a [Tool], this is the tool. Otherwise nil.  
---@param inventory Container # The player's inventory [Container].
---@param changes InventoryChange[] # A table listing the changes. {{uuid=[Uuid], difference=integer, tool=[Tool]}, ..}
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
---@param timeStep number # The time period of a tick. (Is always 0.025, a 1/40th of a second.)
function ScriptableObjectClass:server_onFixedUpdate(timeStep) end

---Called every game tick &ndash; 40 ticks a second. If the frame rate is lower than 40 fps, this event may be called twice.  
---During a fixed update, physics and logic between interactables are updated.  
---@param timeStep number # The time period of a tick. (Is always 0.025, a 1/40th of a second.)
function ScriptableObjectClass:client_onFixedUpdate(timeStep) end

---Called every frame.  
---During a frame update, graphics, animations and effects are updated.  
---**Warning:**
---*Because of how frequent this event is called, the game's frame rate is greatly affected by the amount of code executed here.*
---*For any non-graphics related code, consider using [ScriptableObjectClass.client_onFixedUpdate, client_onFixedUpdate] instead.*
---*If the event is not in use, consider removing it from the script. (Event callbacks that are not implemented will not be called.)*
---@param deltaTime number # Delta time since the last frame.
function ScriptableObjectClass:client_onUpdate(deltaTime) end

---Called when the client receives new client data updates from the server set with [Network.setClientData].  
---Data set in this way is persistent and the latest data will automatically be sent to new clients.  
---The data will arrive after [ScriptableObjectClass.client_onCreate, client_onCreate] during the same tick.  
---Channel 1 will be received before channel 2 if both are updated.  
---@param data any # Any lua object set with [Network.setClientData]
---@param channel? 1|2 # Client data channel, 1 or 2. (default: 1)
function ScriptableObjectClass:client_onClientDataUpdate(data, channel) end

---Called when the [ScriptableObject] is unloaded when exiting the game.  
function ScriptableObjectClass:server_onUnload() end


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
---@field tags any The tags set on the interactable from the editor.
local ShapeClass = class()

---Sets the connection-point highlight color. The connection-point is shown when using the <em>Connect Tool</em> and selecting the interactable. (Defaults to white)  
---@type Color
ShapeClass.colorHighlight = {}

---Sets the connection-point normal color. The connection-point is shown when using the <em>Connect Tool</em>. (Defaults to gray)  
---@type Color
ShapeClass.colorNormal = {}

---Sets the connection-point texture name that maps to texture specified in connectIcons.json. The connection-point is shown when using the <em>Connect Tool</em> and selecting the interactable. (Defaults to empty)  
---@type string
ShapeClass.connectIcon = {}

---Sets the connection-point visualization scale. The connection-point is shown when using the <em>Connect Tool</em> and selecting the interactable. (Defaults to 0.75)  
---@type integer
ShapeClass.connectIconScale = {}

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

---Sets whether the interactable should remain active when put on a lift. (Defaults to false)  
---@type boolean
ShapeClass.keepActiveOnLift = {}

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
---@param timeStep number # The time period of a tick. (Is always 0.025, a 1/40th of a second.)
function ShapeClass:server_onFixedUpdate(timeStep) end

---Called every game tick &ndash; 40 ticks a second. If the frame rate is lower than 40 fps, this event may be called twice.  
---During a fixed update, physics and logic between interactables are updated.  
---@param timeStep number # The time period of a tick. (Is always 0.025, a 1/40th of a second.)
function ShapeClass:client_onFixedUpdate(timeStep) end

---Called every frame.  
---During a frame update, graphics, animations and effects are updated.  
---**Warning:**
---*Because of how frequent this event is called, the game's frame rate is greatly affected by the amount of code executed here.*
---*For any non-graphics related code, consider using [ShapeClass.client_onFixedUpdate, client_onFixedUpdate] instead.*
---*If the event is not in use, consider removing it from the script. (Event callbacks that are not implemented will not be called.)*
---@param deltaTime number # Delta time since the last frame.
function ShapeClass:client_onUpdate(deltaTime) end

---Called when the client receives new client data updates from the server set with [Network.setClientData].  
---Data set in this way is persistent and the latest data will automatically be sent to new clients.  
---The data will arrive after [ShapeClass.client_onCreate, client_onCreate] during the same tick.  
---Channel 1 will be received before channel 2 if both are updated.  
---@param data any # Any lua object set with [Network.setClientData]
---@param channel? 1|2 # Client data channel, 1 or 2. (default: 1)
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
---function MySwitch.client_onInteract( self, character, state ) 
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
---@param character Character # The [Character] of the [Player] that is interacting with the [Interactable].
---@param state boolean # The interaction state. (true if pressed, false if released)
function ShapeClass:client_onInteract(character, state) end

---Called when a [Player] is tinkering with the [Interactable] by pressing the 'Tinker' key (default 'U').  
---**Note:**
---*Tinkering usually means opening the upgrade menu for seats.*
---@param character Character # The [Character] of the [Player] that is tinkering with the [Interactable].
---@param state boolean # The interaction state. (true if pressed, false if released)
function ShapeClass:client_onTinker(character, state) end

---Called when a [Player] is interacting with the [Interactable] through a connected [Joint].  
---@param character Character # The [Character] of the [Player] that is interacting with the [Interactable].
---@param state boolean # The interaction state. Always true. [ShapeClass.client_onInteractThroughJoint, client_onInteractThroughJoint] only receives the key down event.
---@param joint Joint # The [Joint] that the [Player] interacted through.
function ShapeClass:client_onInteractThroughJoint(character, state, joint) end

---Called when the interactable receives input from a [Player] with the [Character] locked to the [Interactable].  
---When a [Character] is seated in an [Interactable] [Shape] with a "seat" component, the [Character] is also considered locked to the [Interactable].  
---@param action integer # The action as an integer value. More details in [sm.interactable.actions].
---@param state boolean # True on begin action, false on end action.
function ShapeClass:client_onAction(action, state) end

---Called when the [Shape] is hit by a projectile.  
---**Note:**
---*If the shooter is destroyed before the projectile hits, the shooter value will be nil.*
---@param position Vec3 # The position in world space where the projectile hit the [Shape].
---@param airTime number # The time, in seconds, that the projectile spent flying before the hit.
---@param velocity Vec3 # The velocity of the projectile at impact.
---@param projectileName string # The name of the projectile. (Legacy, use uuid instead)
---@param shooter Player|Shape|Harvestable|nil # The shooter, can be a [Player], [Shape], [Harvestable] or nil if unknown. Projectiles shot by a [Unit] will be nil on the client.
---@param damage number # The damage value of the projectile.
---@param customData any # A Lua object that can be defined at shoot time using [sm.projectile.customProjectileAttack] or an other custom version. 
---@param normal Vec3 # The normal at the point of impact.
---@param uuid Uuid # The uuid of the projectile.
---@param mass number # The mass of the projectile.
function ShapeClass:client_onProjectile(position, airTime, velocity, projectileName, shooter, damage, customData, normal, uuid, mass) end

---Called when the [Shape] is hit by a projectile.  
---**Note:**
---*If the shooter is destroyed before the projectile hits, the shooter value will be nil.*
---@param position Vec3 # The position in world space where the projectile hit the [Shape].
---@param airTime number # The time, in seconds, that the projectile spent flying before the hit.
---@param velocity Vec3 # The velocity of the projectile at impact.
---@param projectileName string # The name of the projectile. (Legacy, use uuid instead)
---@param shooter Player|Unit|Shape|Harvestable|nil # The shooter. Can be a [Player], [Unit], [Shape], [Harvestable] or nil if unknown.
---@param damage integer # The damage value of the projectile.
---@param customData any # A Lua object that can be defined at shoot time using [sm.projectile.customProjectileAttack] or an other custom version. 
---@param normal Vec3 # The normal at the point of impact.
---@param uuid Uuid # The uuid of the projectile.
---@param mass number # The mass of the projectile.
function ShapeClass:server_onProjectile(position, airTime, velocity, projectileName, shooter, damage, customData, normal, uuid, mass) end

---@deprecated Use [ShapeClass.server_onMelee, server_onMelee] instead.
function ShapeClass:server_onSledgehammer() end

---Called when the [Shape] is hit by a melee attack.  
---**Note:**
---*If the attacker is destroyed before the hit lands, the attacker value will be nil.*
---@param position Vec3 # The position in world space where the [Shape] was hit.
---@param attacker Player|nil # The attacker. Can be a [Player] or nil if unknown. Attacks made by a [Unit] will be nil on the client.
---@param damage integer # The damage value of the melee hit.
---@param power number # The physical impact impact of the hit.
---@param direction Vec3 # The direction that the melee attack was made.
---@param normal Vec3 # The normal at the point of impact.
function ShapeClass:client_onMelee(position, attacker, damage, power, direction, normal) end

---Called when the [Shape] is hit by a melee attack.  
---**Note:**
---*If the attacker is destroyed before the hit lands, the attacker value will be nil.*
---@param position Vec3 # The position in world space where the [Shape] was hit.
---@param attacker Player|Unit|nil # The attacker. Can be a [Player], [Unit] or nil if unknown.
---@param damage integer # The damage value of the melee hit.
---@param power number # The physical impact impact of the hit.
---@param direction Vec3 # The direction that the melee attack was made.
---@param normal Vec3 # The normal at the point of impact.
function ShapeClass:server_onMelee(position, attacker, damage, power, direction, normal) end

---Called when the [Shape] is hit by an explosion.  
---For more information about explosions, see [sm.physics.explode].  
---@param center Vec3 # The center of the explosion.
---@param destructionLevel integer # The level of destruction done by this explosion. Corresponds to the 'durability' rating of a [Shape].
---@param damage integer # The damage value of the explosion.
function ShapeClass:server_onExplosion(center, destructionLevel, damage) end

---Called when the [Shape] collides with another object.  
---@param other Shape|Character|Harvestable|Lift|nil # The other object. Nil if terrain.
---@param position Vec3 # The position in world space where the collision occurred.
---@param selfPointVelocity Vec3 # The velocity that that the [Shape] had at the point of collision.
---@param otherPointVelocity Vec3 # The velocity that that the other object had at the point of collision.
---@param normal Vec3 # The collision normal between the [Shape] and the other other object.
function ShapeClass:client_onCollision(other, position, selfPointVelocity, otherPointVelocity, normal) end

---Called when the [Shape] collides with another object.  
---@param other Shape|Character|Harvestable|Lift|nil # The other object. Nil if terrain.
---@param position Vec3 # The position in world space where the collision occurred.
---@param selfPointVelocity Vec3 # The velocity that that the [Shape] had at the point of collision.
---@param otherPointVelocity Vec3 # The velocity that that the other object had at the point of collision.
---@param normal Vec3 # The collision normal between the [Shape] and the other other object.
function ShapeClass:server_onCollision(other, position, selfPointVelocity, otherPointVelocity, normal) end

---Called to check whether the [Shape] can be erased at this moment.  
---**Note:**
---*Can be used to override restrictions. (See [Shape.erasable])*
---@return boolean # A boolean indicating whether the [Shape] can be erased or not. (Defaults to true)
function ShapeClass:client_canErase() end

---Called to check whether the [Shape] can be erased at this moment.  
---**Note:**
---*Can be used to override restrictions. (See [Shape.erasable])*
---@return boolean # A boolean indicating whether the [Shape] can be erased or not. (Defaults to true)
function ShapeClass:server_canErase() end

---Called to check whether the [Interactable] can be interacted with at this moment.  
---**Note:**
---*This callback can also be used to change the interaction text shown to the player using [sm.gui.setInteractionText]. (Defaults to "E Use")*
---**Note:**
---*Can be used to override restrictions. (See [Shape.usable])*
---@param character Character # The [Character] of the [Player] that is looking at the [Shape].
---@return boolean # A boolean indicating whether the interactable can be interacted with or not. (Defaults to true if [ShapeClass.client_onInteract, client_onInteract] is implemented, otherwise false)
function ShapeClass:client_canInteract(character) end

---Called to check whether the [Interactable] can be interacted with through a child [Joint] at this moment.  
---**Note:**
---*This callback can also be used to change the interaction text shown to the player using [sm.gui.setInteractionText]. (Defaults to "E Use")*
---@param character Character # The [Character] of the [Player] that is looking at the [Joint].
---@param joint Joint # The [Joint].
---@return boolean # A boolean indicating whether the interactable can be interacted with or not. (Defaults to true if [ShapeClass.client_onInteractThroughJoint, client_onInteractThroughJoint] is implemented, otherwise false)
function ShapeClass:client_canInteractThroughJoint(character, joint) end

---Called to check whether the [Interactable] can be tinkered with at this moment.  
---**Note:**
---*Tinkering usually means opening the upgrade menu for seats.*
---@param character Character # The [Character] of the [Player] that is looking at the [Shape].
---@return boolean # A boolean indicating whether the interactable can be tinkered with or not. (Defaults to true if [ShapeClass.client_onTinker, client_onTinker] is implemented, otherwise false)
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
---@param flags integer # Connection type flags.
---@return integer # The number of available connections.
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
---@param flags integer # Connection type flags.
---@return integer # The number of available connections.
function ShapeClass:client_getAvailableChildConnectionCount(flags) end

---Called to check if the shape must be carried instead of put in the inventory.  
---**Note:**
---*Shapes with the "carryItem" attribute are always carried.*
---@return boolean # A boolean indicating whether the interacable must be carried or not. (Defaults to false)
function ShapeClass:client_canCarry() end

---Called when a shape changes world  
function ShapeClass:server_onWorldChanged() end

---Called when a child [Joint] is removed from the [Interactable]'s connection list.  
---This can happen when a player explicitly disconnects the [Joint] or when the [Joint] is destroyed.  
---@param joint Joint # The [Joint] that was removed.
function ShapeClass:client_onChildJointRemoved(joint) end


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
---@param timeStep number # The time period of a tick. (Is always 0.025, a 1/40th of a second.)
function UnitClass:server_onFixedUpdate(timeStep) end

---Called every game tick &ndash; 40 ticks a second. If the frame rate is lower than 40 fps, this event may be called twice.  
---During a fixed update, physics and logic between interactables are updated.  
---@param timeStep number # The time period of a tick. (Is always 0.025, a 1/40th of a second.)
function UnitClass:client_onFixedUpdate(timeStep) end

---Called every frame.  
---During a frame update, graphics, animations and effects are updated.  
---**Warning:**
---*Because of how frequent this event is called, the game's frame rate is greatly affected by the amount of code executed here.*
---*For any non-graphics related code, consider using [UnitClass.client_onFixedUpdate, client_onFixedUpdate] instead.*
---*If the event is not in use, consider removing it from the script. (Event callbacks that are not implemented will not be called.)*
---@param deltaTime number # Delta time since the last frame.
function UnitClass:client_onUpdate(deltaTime) end

---Called when the client receives new client data updates from the server set with [Network.setClientData].  
---Data set in this way is persistent and the latest data will automatically be sent to new clients.  
---The data will arrive after [UnitClass.client_onCreate, client_onCreate] during the same tick.  
---Channel 1 will be received before channel 2 if both are updated.  
---@param data any # Any lua object set with [Network.setClientData]
---@param channel? 1|2 # Client data channel, 1 or 2. (default: 1)
function UnitClass:client_onClientDataUpdate(data, channel) end

---Called when the [Unit]'s [Character] is hit by a projectile.  
---**Note:**
---*If the shooter is destroyed before the projectile hits, the shooter value will be nil.*
---@param position Vec3 # The position in world space where the projectile hit the [Unit]'s [Character].
---@param airTime number # The time, in seconds, that the projectile spent flying before the hit.
---@param velocity Vec3 # The velocity of the projectile at impact.
---@param projectileName string # The name of the projectile. (Legacy, use uuid instead)
---@param shooter Player|Unit|Shape|Harvestable|nil # The shooter. Can be a [Player], [Unit], [Shape], [Harvestable] or nil if unknown.
---@param damage integer # The damage value of the projectile.
---@param customData any # A Lua object that can be defined at shoot time using [sm.projectile.customProjectileAttack] or an other custom version. 
---@param normal Vec3 # The normal at the point of impact.
---@param uuid Uuid # The uuid of the projectile.
---@param mass number # The mass of the projectile.
function UnitClass:server_onProjectile(position, airTime, velocity, projectileName, shooter, damage, customData, normal, uuid, mass) end

---Called when the [Unit]'s [Character] is hit by an explosion.  
---@param center Vec3 # The center of the explosion.
---@param destructionLevel integer # The level of destruction done by this explosion. Corresponds to the 'durability' rating of a [Shape].
---@param damage integer # The damage value of the explosion.
function UnitClass:server_onExplosion(center, destructionLevel, damage) end

---Called when the [Unit]'s [Character] is hit by a melee hit.  
---**Note:**
---*If the attacker is destroyed before the hit lands, the attacker value will be nil.*
---@param position Vec3 # The position in world space where the [Unit]'s [Character] was hit.
---@param attacker Player|Unit|nil # The attacker. Can be a [Player], [Unit] or nil if unknown.
---@param damage integer # The damage value of the melee hit.
---@param power number # The physical impact impact of the hit.
---@param direction Vec3 # The direction that the melee attack was made.
---@param normal Vec3 # The normal at the point of impact.
function UnitClass:server_onMelee(position, attacker, damage, power, direction, normal) end

---Called when the [Unit]'s [Character] collides with another object.  
---@param other Shape|Character|Harvestable|Lift|nil # The other object. Nil if terrain.
---@param position Vec3 # The position in world space where the collision occurred.
---@param selfPointVelocity Vec3 # The velocity that that the [Unit]'s [Character] had at the point of collision.
---@param otherPointVelocity Vec3 # The velocity that that the other object had at the point of collision.
---@param normal Vec3 # The collision normal between the [Unit]'s [Character] and the other other object.
function UnitClass:server_onCollision(other, position, selfPointVelocity, otherPointVelocity, normal) end

---Called when the [Unit]'s [Character] is crushed.  
function UnitClass:server_onCollisionCrush() end

---Called occasionally for units based on how many units are active.  
---It is recommended to do heavier AI decisions here instead of in [UnitClass.server_onFixedUpdate, server_onFixedUpdate].  
---@param deltaTime number # The time, in seconds, since [UnitClass.server_onUnitUpdate, server_onUnitUpdate] was last called for this [Unit].
function UnitClass:server_onUnitUpdate(deltaTime) end

---Called when the [Unit]'s [Character] color is set. Either by painting or set using [Character.setColor] or [Character.color].  
---@param color Color # The new [Color] of the [Unit]'s [Character].
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

---Default value when sampling voxel density. (Defaults to 0)  
---@type integer
WorldClass.defaultVoxelDensity = {}

---Default value when sampling voxel material. (Defaults to 0)  
---@type integer
WorldClass.defaultVoxelMaterial = {}

---Enables or disables terrain assets for this world. (Defaults to true)  
---@type boolean
WorldClass.enableAssets = {}

---Enables or disables the ability to build on terrain assets. (Defaults to true)  
---@type boolean
WorldClass.enableBuildOnAssets = {}

---Enables or disables the ability to build on bodies. (Defaults to true)  
---@type boolean
WorldClass.enableBuildOnBodies = {}

---Enables or disables the ability to build on lift. (Defaults to true)  
---@type boolean
WorldClass.enableBuildOnLift = {}

---Enables or disables the ability to build on terrain surface. (Defaults to true)  
---@type boolean
WorldClass.enableBuildOnSurface = {}

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

---Enables or disables navigation mesh generation for better AI path finding. (Defaults to true)  
---@type boolean
WorldClass.enableNavMesh = {}

---Enables or disables nodes for this world. (Defaults to true)  
---@type boolean
WorldClass.enableNodes = {}

---Enables or disables terrain surface for this world. (Defaults to true)  
---@type boolean
WorldClass.enableSurface = {}

---Enables or disables voxel terrain for this world. (Defaults to true)  
---@type boolean
WorldClass.enableVoxelTerrain = {}

---Sets the ground material set used by the terrain. (Defaults to "$GAME_DATA/Terrain/Materials/gnd_standard_materialset.json")  
---Full $-path to the material set.  
---@type string
WorldClass.groundMaterialSet = {}

---Enables or disables h lods.  
---@type integer
WorldClass.hLod = {}

---Enables or disables automatically placing water effects at the edge of the world.  
---@type integer
WorldClass.horizonWater = {}

---Enables or disables indoor mode. (Defaults to false)  
---Indoor worlds have only one terrain cell in (0, 0)  
---@type boolean
WorldClass.isIndoor = {}

---Enables or disables static mode. (Defaults to false)  
---Static worlds are created at load time and doesn't stream in and out.  
---@type boolean
WorldClass.isStatic = {}

---Sets the render mode for this world. (Default "outdoor")  
---Possible values: "outdoor", "challenge", "warehouse", "mini_dungeon", "underground"  
---@type string
WorldClass.renderMode = {}

---Sets the script used to generate terrain.  
---Full $-path to the terrain generation script.  
---@type string
WorldClass.terrainScript = {}

---Sets the voxel material set used by the voxel terrain. (Defaults to "$SURVIVAL_DATA/Terrain/Materials/voxel_materialset_drill1.voxelmaterialset")  
---Full $-path to the material set.  
---@type string
WorldClass.voxelMaterialSet = {}

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
---@param timeStep number # The time period of a tick. (Is always 0.025, a 1/40th of a second.)
function WorldClass:server_onFixedUpdate(timeStep) end

---Called every game tick &ndash; 40 ticks a second. If the frame rate is lower than 40 fps, this event may be called twice.  
---During a fixed update, physics and logic between interactables are updated.  
---@param timeStep number # The time period of a tick. (Is always 0.025, a 1/40th of a second.)
function WorldClass:client_onFixedUpdate(timeStep) end

---Called every frame.  
---During a frame update, graphics, animations and effects are updated.  
---**Warning:**
---*Because of how frequent this event is called, the game's frame rate is greatly affected by the amount of code executed here.*
---*For any non-graphics related code, consider using [WorldClass.client_onFixedUpdate, client_onFixedUpdate] instead.*
---*If the event is not in use, consider removing it from the script. (Event callbacks that are not implemented will not be called.)*
---@param deltaTime number # Delta time since the last frame.
function WorldClass:client_onUpdate(deltaTime) end

---Called when the client receives new client data updates from the server set with [Network.setClientData].  
---Data set in this way is persistent and the latest data will automatically be sent to new clients.  
---The data will arrive after [WorldClass.client_onCreate, client_onCreate] during the same tick.  
---Channel 1 will be received before channel 2 if both are updated.  
---@param data any # Any lua object set with [Network.setClientData]
---@param channel? 1|2 # Client data channel, 1 or 2. (default: 1)
function WorldClass:client_onClientDataUpdate(data, channel) end

---Called when the [World] is unloaded from the game on shutdown.  
function WorldClass:server_onUnload() end

---Called when a world's terrain is created for the first time on the server.  
---This callback is triggered during the initial generation of the world terrain.  
---```
--- * function World:server_onTerrainCreated()
--- *     -- Terrain creation logic here
--- * end
---```
function WorldClass:server_onTerrainCreated() end

---Called when a world's terrain is loaded (not created) on the server.  
---This is triggered when existing terrain data is loaded into the world.  
---```
--- * function World:server_onTerrainLoaded()
--- *     -- Terrain loading logic here
--- * end
---```
function WorldClass:server_onTerrainLoaded() end

---Called on the client when a world's terrain is created for the first time.  
---This callback is used for client-side terrain generation tasks.  
---```
--- * function World:client_onTerrainCreated()
--- *     -- Client-side terrain creation logic
--- * end
---```
function WorldClass:client_onTerrainCreated() end

---Called on the client when a world's terrain is loaded (not created).  
---This function is useful for initializing client-side elements based on the loaded terrain.  
---```
--- * function World:client_onTerrainLoaded()
--- *     -- Client-side terrain loading logic
--- * end
---```
function WorldClass:client_onTerrainLoaded() end

---Called when a world cell is loaded and feature complete for the first time.  
---**Note:**
---*[Interactable, Interactables] created by terrain scripts should be processed here using [sm.cell.getInteractablesByTag] and [sm.cell.getInteractablesByUuid].*
---*They are only accessable for 1 tick after being created.*
---@param x integer # Cell x position.
---@param y integer # Cell y position.
function WorldClass:server_onCellCreated(x, y) end

---Called when a world cell is loaded and feature complete, but has been before.  
---@param x integer # Cell x position.
---@param y integer # Cell y position.
function WorldClass:server_onCellLoaded(x, y) end

---Called when a world cell is no longer feature complete.  
---@param x integer # Cell x position.
---@param y integer # Cell y position.
function WorldClass:server_onCellUnloaded(x, y) end

---Called when a world cell is considered feature complete for a client (has nodes).  
---@param x integer # Cell x position.
---@param y integer # Cell y position.
function WorldClass:client_onCellLoaded(x, y) end

---Called when a world cell is no longer considered feature complete for a client (no longer has nodes).  
---@param x integer # Cell x position.
---@param y integer # Cell y position.
function WorldClass:client_onCellUnloaded(x, y) end

---Called when an [Interactable] [Shape] is built in the world.  
---@param interactable Interactable # The [Interactable] of the built [Shape].
function WorldClass:server_onInteractableCreated(interactable) end

---Called when an [Interactable] [Shape] is removed from the world.  
---@param interactable Interactable # The [Interactable] of the removed [Shape].
function WorldClass:server_onInteractableDestroyed(interactable) end

---Called when a projectile hits something in this world.  
---**Note:**
---*If the shooter is destroyed before the projectile hits, the shooter value will be nil.*
---@param position Vec3 # The position in world space where the projectile hit.
---@param airTime number # The time, in seconds, that the projectile spent flying before the hit.
---@param velocity Vec3 # The velocity of the projectile at impact.
---@param projectileName string # The name of the projectile. (Legacy, use uuid instead)
---@param shooter Player|Unit|Shape|Harvestable|nil # The shooter. Can be a [Player], [Unit], [Shape], [Harvestable] or nil if unknown.
---@param damage integer # The damage value of the projectile.
---@param customData any # A Lua object that can be defined at shoot time using [sm.projectile.customProjectileAttack] or an other custom version. 
---@param normal Vec3 # The normal at the point of impact.
---@param target Character|Shape|Harvestable|Lift|nil # The hit target. Can be a [Character], [Shape], [Harvestable], [Lift] or nil if terrain or unknown.
---@param uuid Uuid # The uuid of the projectile.
function WorldClass:server_onProjectile(position, airTime, velocity, projectileName, shooter, damage, customData, normal, target, uuid) end

---Called when an explosion occurs in this world.  
---@param center Vec3 # The center of the explosion.
---@param destructionLevel integer # The level of destruction done by this explosion. Corresponds to the 'durability' rating of a [Shape].
---@param damage integer # The damage value of the explosion.
function WorldClass:server_onExplosion(center, destructionLevel, damage) end

---Called when a melee attack hits something in this world.  
---**Note:**
---*If the attacker is destroyed before the hit lands, the attacker value will be nil.*
---@param position Vec3 # The position in world space where the attack hit.
---@param attacker Player|Unit|nil # The attacker. Can be a [Player], [Unit] or nil if unknown.
---@param target Character|Shape|Harvestable|Lift|nil # The hit target. Can be a [Character], [Shape], [Harvestable], [Lift] or nil if terrain or unknown.
---@param damage integer # The damage value of the melee hit.
---@param power number # The physical impact impact of the hit.
---@param direction Vec3 # The direction that the melee attack was made.
---@param normal Vec3 # The normal at the point of impact.
function WorldClass:server_onMelee(position, attacker, target, damage, power, direction, normal) end

---Called when a projectile is fired in this world.  
---@param position Vec3 # The position in world space where projectile was fired from.
---@param velocity Vec3 # The fire velocity of the projectile.
---@param projectileName string # The name of the projectile. (Legacy, use uuid instead)
---@param shooter Player|Unit|Shape|Harvestable|nil # The shooter. Can be a [Player], [Unit], [Shape], [Harvestable] or nil if unknown.
---@param uuid Uuid # The uuid of the projectile.
function WorldClass:server_onProjectileFire(position, velocity, projectileName, shooter, uuid) end

---Called when a collision occurs in this world.  
---@param objectA Shape|Character|Harvestable|Lift|nil # The first colliding object. Nil if terrain.
---@param objectB Shape|Character|Harvestable|Lift|nil # The other colliding object. Nil if terrain.
---@param position Vec3 # The position in world space where the collision occurred.
---@param pointVelocityA Vec3 # The velocity that that the first object had at the point of collision.
---@param pointVelocityB Vec3 # The velocity that that the other object had at the point of collision.
---@param normal Vec3 # The collision normal from objectA to objectB.
function WorldClass:server_onCollision(objectA, objectB, position, pointVelocityA, pointVelocityB, normal) end

---Called when a collision occurs in this world.  
---@param objectA Shape|Character|Harvestable|Lift|nil # One of the colliding objects. Nil if terrain.
---@param objectB Shape|Character|Harvestable|Lift|nil # The other colliding object. Nil if terrain.
---@param position Vec3 # The position in world space where the collision occurred.
---@param pointVelocityA Vec3 # The velocity that that the first object had at the point of collision.
---@param pointVelocityB Vec3 # The velocity that that the other object had at the point of collision.
---@param normal Vec3 # The collision normal from objectA to objectB.
function WorldClass:client_onCollision(objectA, objectB, position, pointVelocityA, pointVelocityB, normal) end

---Called when a projectile hits something in this world.  
---**Note:**
---*If the shooter is destroyed before the projectile hits, the shooter value will be nil.*
---@param position Vec3 # The position in world space where the projectile hit.
---@param airTime number # The time, in seconds, that the projectile spent flying before the hit.
---@param velocity Vec3 # The velocity of the projectile at impact.
---@param projectileName string # The name of the projectile. (Legacy, use uuid instead)
---@param shooter Player|Character|Shape|Harvestable|nil # The shooter. Can be a [Player], [Character], [Shape], [Harvestable] or nil if unknown.
---@param damage integer # The damage value of the projectile.
---@param normal Vec3 # The normal at the point of impact.
---@param target Character|Shape|Harvestable|Lift|nil # The hit target. Can be a [Character], [Shape], [Harvestable], [Lift] or nil if terrain or unknown.
---@param uuid Uuid # The uuid of the projectile.
function WorldClass:client_onProjectile(position, airTime, velocity, projectileName, shooter, damage, normal, target, uuid) end

---Called when a cluster of voxels are destroyed by a player or creation  
---@param densityLoss table # A table containing information about density loss for all materials.
---@param positions Vec3[] # A table containing all positions where voxels were lost for each material.
function WorldClass:server_onVoxelDestruction(densityLoss, positions) end

---Called when a cluster of voxels are added by a player  
---@param densityGain table # A table containing information about density gain for all materials.
---@param positions Vec3[] # A table containing all positions where voxels were added for each material.
function WorldClass:server_onVoxelConstruction(densityGain, positions) end

---@class MineSpawn
---@field position Vec3
---@field spawnId number

---Called when the mining manager has filtered a batch of voxel loot candidates.  
---@param spawns MineSpawn[] # An array of { position = [Vec3], spawnId = integer } describing where and what to spawn.
function WorldClass:server_onMining(spawns) end


---@class ToolClass
---A script class that is instanced for every active [Tool] in the game.  
---A tool something that a [Player] can equip by selecting it in the hotbar. For instance the Sledgehammer.  
---@field data any Data from the "data" json element.
---@field tool Tool The [Tool] game object belonging to this class instance.
---@field network Network A [Network] object that can be used to send messages between client and server.
---@field storage Storage (Server side only.) A [Storage] object that can be used to store data for the next time loading this object after being unloaded.
local ToolClass = class()

---Toggles whether the tool can be equipped while the owner is sitting in a seat.
---@type boolean
ToolClass.equipWhileSeated = {}

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
---@param timeStep number # The time period of a tick. (Is always 0.025, a 1/40th of a second.)
function ToolClass:server_onFixedUpdate(timeStep) end

---Called every game tick &ndash; 40 ticks a second. If the frame rate is lower than 40 fps, this event may be called twice.  
---During a fixed update, physics and logic between interactables are updated.  
---@param timeStep number # The time period of a tick. (Is always 0.025, a 1/40th of a second.)
function ToolClass:client_onFixedUpdate(timeStep) end

---Called every frame.  
---During a frame update, graphics, animations and effects are updated.  
---**Warning:**
---*Because of how frequent this event is called, the game's frame rate is greatly affected by the amount of code executed here.*
---*For any non-graphics related code, consider using [ToolClass.client_onFixedUpdate, client_onFixedUpdate] instead.*
---*If the event is not in use, consider removing it from the script. (Event callbacks that are not implemented will not be called.)*
---@param deltaTime number # Delta time since the last frame.
function ToolClass:client_onUpdate(deltaTime) end

---Called when the client receives new client data updates from the server set with [Network.setClientData].  
---Data set in this way is persistent and the latest data will automatically be sent to new clients.  
---The data will arrive after [ToolClass.client_onCreate, client_onCreate] during the same tick.  
---Channel 1 will be received before channel 2 if both are updated.  
---@param data any # Any lua object set with [Network.setClientData]
---@param channel? 1|2 # Client data channel, 1 or 2. (default: 1)
function ToolClass:client_onClientDataUpdate(data, channel) end

---Called when a [Player] equips the [Tool].  
---@param animate boolean # A boolean indicating whether the event should be animated or not.
function ToolClass:client_onEquip(animate) end

---Called when a [Player] unequips the [Tool].  
---@param animate boolean # A boolean indicating whether the event should be animated or not.
function ToolClass:client_onUnequip(animate) end

---Called every frame for the currently equipped [Tool].  
---**Note:**
---*Swinging the sledgehammer is a typical example where you want to block other primary input.*
---*Force building is an example where the primary input action is not blocked.*
---*Not blocking secondary input allows shape removal while the tool is equipped.*
---@param primaryState integer # The interact state of the primary (left) mouse button. (See [sm.tool.interactState])
---@param secondaryState integer # The interact state of the secondary (right) mouse button. (See [sm.tool.interactState])
---@return boolean, boolean # The first boolean indicates if other primary input actions should be blocked. The second if secondary input actions should be blocked. (Defaults to false, false)
function ToolClass:client_onEquippedUpdate(primaryState, secondaryState) end

---Called when the [Player] presses a toggle key with the [Tool] equipped (default 'Q' and 'Shift' + 'Q).  
---@return boolean # A boolean that indicates if other toggle actions should be blocked (rotating shapes). (Defaults to false)
function ToolClass:client_onToggle() end

---Called when the [Player] presses the 'Reload' key with the [Tool] equipped (default 'R').  
---@return boolean # A boolean that indicates if other reload actions should be blocked ([PlayerClass.client_onReload]). (Defaults to false)
function ToolClass:client_onReload() end

---This event is called to check whether the [Tool] can be equipped.  
---@return boolean # A boolean that indicates if the [Tool] can be equipped. (Defaults to true)
function ToolClass:client_canEquip() end


---The <a target="_blank" href="https://bitop.luajit.org/index.html">BitOp library</a> that adds <a target="_blank" href="https://en.wikipedia.org/wiki/Bitwise_operation">bitwise operations</a> on numbers.
bit = {}

---Normalizes a number to the numeric range for bit operations and returns it.
---This function is usually not needed since all bit operations already normalize all of their input arguments.     
---```
---print(0xffffffff)                --> 4294967295 (*)
---print(bit.tobit(0xffffffff))     --> -1
---print(bit.tobit(0xffffffff))     --> 0xffffffff
---print(bit.tobit(0xffffffff + 1)) --> 0
---print(bit.tobit(2^40 + 1234))    --> 1234
---```
---@param x number
---@return number y
function bit.tobit(x) end

---Converts its first argument to a hex string.
---The number of hex digits is given by the absolute value of the optional second argument.
---Positive numbers between 1 and 8 generate lowercase hex digits.
---Negative numbers generate uppercase hex digits.
---Only the least-significant 4*|n| bits are used. The default is to generate 8 lowercase hex digits.
---```
---print(bit.tohex(1))              --> 00000001
---print(bit.tohex(-1))             --> ffffffff
---print(bit.tohex(0xffffffff))     --> ffffffff
---print(bit.tohex(-1, -8))         --> FFFFFFFF
---print(bit.tohex(0x21, 4))        --> 0021
---print(bit.tohex(0x87654321, 4))  --> 4321
---```
---@param x number
---@param n? number
---@return numbr y
function bit.tohex(x, n) end

---Returns the bitwise not of its argument.
---```
---print(bit.bnot(0))            --> -1
---print(bit.bnot(0))            --> 0xffffffff
---print(bit.bnot(-1))           --> 0
---print(bit.bnot(0xffffffff))   --> 0
---print(bit.bnot(0x12345678))   --> 0xedcba987
---```
---@param x number
---@return number y
function bit.bnot(x) end

---Returns the bitwise and of all of its arguments. Note that more than two arguments are allowed. 
---```
---print(bit.band(0x12345678, 0xff))        --> 0x00000078
---```
---@param ... number
---@return number y
function bit.band(...) end

---Returns the bitwise or of all of its arguments. Note that more than two arguments are allowed. 
---```
---print(bit.bor(1, 2, 4, 8))                --> 15
---```
---@param ... number
---@return number y
function bit.bor(...) end

---Returns the bitwise xor of all of its arguments. Note that more than two arguments are allowed. 
---```
---print(bit.bxor(0xa5a5f0f0, 0xaa55ff00))  --> 0x0ff00ff0
---```
---@param ... unknown
---@return number y
function bit.bxor(...) end

---Returns the bitwise logical left-shift of its first argument by the number of bits given by the second argument. 
---Logical shifts treat the first argument as an unsigned number and shift in 0-bits. Arithmetic right-shift treats the most-significant bit as a sign bit and replicates it.
---Only the lower 5 bits of the shift count are used (reduces to the range [0..31]). 
---```
---print(bit.lshift(1, 0))              --> 1
---print(bit.lshift(1, 8))              --> 256
---print(bit.lshift(1, 40))             --> 256
---print(bit.lshift(0x87654321, 12))    --> 0x54321000
---```
---@param x number
---@param n number
---@return number y
function bit.lshift(x, n) end

---Returns the bitwise logical right-shift of its first argument by the number of bits given by the second argument. 
---Logical shifts treat the first argument as an unsigned number and shift in 0-bits. Arithmetic right-shift treats the most-significant bit as a sign bit and replicates it.
---Only the lower 5 bits of the shift count are used (reduces to the range [0..31]). 
---```
---print(bit.rshift(256, 8))            --> 1
---print(bit.rshift(-256, 8))           --> 16777215
---print(bit.rshift(0x87654321, 12))    --> 0x00087654
---```
---@param x number
---@param n number
---@return number y
function bit.rshift(x, n) end

---Returns the bitwise arithmetic right-shift of its first argument by the number of bits given by the second argument. 
---Logical shifts treat the first argument as an unsigned number and shift in 0-bits. Arithmetic right-shift treats the most-significant bit as a sign bit and replicates it.
---Only the lower 5 bits of the shift count are used (reduces to the range [0..31]). 
---```
---print(bit.arshift(256, 8))           --> 1
---print(bit.arshift(-256, 8))          --> -1
---print(bit.arshift(0x87654321, 12))   --> 0xfff87654
---```
---@param x number
---@param n number
---@return number y
function bit.arshift(x, n) end

---Returns the bitwise left rotation of its first argument by the number of bits given by the second argument.
---Bits shifted out on one side are shifted back in on the other side. 
---Only the lower 5 bits of the rotate count are used (reduces to the range [0..31]). 
---```
---print(bit.rol(0x12345678, 12))   --> 0x45678123
---```
---@param x number
---@param n number
---@return number y
function bit.rol(x, n) end

---Returns the bitwise right rotation of its first argument by the number of bits given by the second argument.
---Bits shifted out on one side are shifted back in on the other side. 
---Only the lower 5 bits of the rotate count are used (reduces to the range [0..31]). 
---```
---print(bit.ror(0x12345678, 12))   --> 0x67812345
---```
---@param x number
---@param n number
---@return number y
function bit.ror(x, n) end

---Swaps the bytes of its argument and returns it. This can be used to convert little-endian 32 bit numbers to big-endian 32 bit numbers or vice versa.
---```
---print(bit.bswap(0x12345678)) --> 0x78563412
---print(bit.bswap(0x78563412)) --> 0x12345678
---```
---@param x number
---@return number y
function bit.bswap(x) end



---Called on every thread before everything else.
---@param world World The World object that the terrain script is attached to.
---@param generatorIndex number The thread id of this instance.
function Init(world, generatorIndex) end

---Called on every thread after Init.  
---Return **true** if loading any saved terrain data was successful, return **false** if it wasn't.
---If **false** is returned, the **Create** function will be called.  
---@return boolean success Whether loading terrain data was successful.
function Load() end

---Called after Load.  
---Only gets called if the **Load** function returns false.  
---@param xMin number The minimum x size of the world.
---@param xMax number The maximum x size of the world.
---@param yMin number The minimum y size of the world.
---@param yMax number The maximum y size of the world.
---@param seed number The seed to be used for random number generation.
---@param data any Some data that the world might provide, for example, the path to a world file.
function Create( xMin, xMax, yMin, yMax, seed, data ) end

---Called before any of the **Get\<parameter\>At** and **Get\<objects\>ForCell** functions are called.  
---Generally used to set up data that will be used for those functions later.  
---
---The bits of the `loadFlags` mask, from least significant to most significant bit, correspond to:  
---1. Creations
---2. Surface
---3. Assets
---4. Nodes (broken, always 0)
---5. Harvestables
---6. Kinematics
---@param cellX number The x coordinate of the cell.
---@param cellY number The y coordinate of the cell.
---@param loadFlags integer A mask of what should be loaded by the current thread. Usually used for sm.terrainTile.getContentFromPrefab.
function PrepareCell( cellX, cellY, loadFlags ) end

---Should return the path of the tile with the given uuid.  
---The game automatically calls this to get the path of tiles.  
---@param uuid Uuid The UUID of the tile.
---@return string path The path to the tile.
function GetTilePath( uuid ) end

---Determines what the terrain surface height is at a given **x** and **y** coordinate.
---@param x number The x coordinate.
---@param y number The y coordinate.
---@param lod number The Level of Detail value. The higher it is, the less fidelity the terrain height is going to have.
---@return number height The height of the terrain.
function GetHeightAt( x, y, lod ) end

---Determines the ground color.
---@param x number The x coordinate.
---@param y number The y coordinate.
---@param lod number The Level of Detail value. The higher it is, the less fidelity the terrain colour is going to have.
---@return number r The red value of the colour.
---@return number g The green value of the colour.
---@return number b The blue value of the colour.
function GetColorAt( x, y, lod ) end

---Determines what material the ground has.
---Each returned number determines the weight of that specific ground material.
---The ground material set can be set on the world class.
---@param x number The x coordinate.
---@param y number The y coordinate.
---@param lod number The Level of Detail value. The higher it is, the less fidelity the terrain material is going to have.
---@return number material_1_weight The weight of the first material.
---@return number material_2_weight The weight of the second material.
---@return number material_3_weight The weight of the third material.
---@return number material_4_weight The weight of the fourth material.
---@return number material_5_weight The weight of the fifth material.
---@return number material_6_weight The weight of the sixth material.
---@return number material_7_weight The weight of the seventh material.
---@return number material_8_weight The weight of the eighth material.
function GetMaterialAt( x, y, lod ) end

---Determines what clutter to place in the tile. 
---The clutter set can be set on the world class.
---@param x number The x coordinate.
---@param y number The y coordinate.
---@return number clutterId The id of the clutter.
function GetClutterIdxAt( x, y ) end

---Determines what assets to place in the cell.
---@param cellX number The x coordinate of the cell.
---@param cellY number The y coordinate of the cell.
---@param lod number The Level of Detail value. The higher it is, the less fidelity the terrain assets are going to have.
---@return TerrainAsset[] terrainAssets The terrain assets for the cell.
function GetAssetsForCell( cellX, cellY, lod ) end

---Determines what nodes to place in the cell.
---@param cellX number The x coordinate of the cell.
---@param cellY number The y coordinate of the cell.
---@return TerrainNode[] nodes The nodes for the cell.
function GetNodesForCell( cellX, cellY ) end

---Determines what creations to place in the cell.
---@param cellX number The x coordinate of the cell.
---@param cellY number The y coordinate of the cell.
---@return TerrainCreation[] creations The creations for the cell.
function GetCreationsForCell( cellX, cellY ) end

---Determines what harvestables to place in the cell.
---@param cellX number The x coordinate of the cell.
---@param cellY number The y coordinate of the cell.
---@param lod number The Level of Detail value. The higher it is, the less fidelity the harvestables are going to have.
---@return TerrainHarvestable[] harvestables The harvestables for the cell.
function GetHarvestablesForCell( cellX, cellY, lod ) end

---Determines what kinematics to place in the cell.
---@param cellX number The x coordinate of the cell.
---@param cellY number The y coordinate of the cell.
---@param lod number The Level of Detail value. The higher it is, the less fidelity the kinematics are going to have.
---@return TerrainKinematic[] kinematics The kinematics for the cell.
function GetKinematicsForCell( cellX, cellY, lod ) end

---Determines what assets to place in the cell.
---@param cellX number The x coordinate of the cell.
---@param cellY number The y coordinate of the cell.
---@param lod number The Level of Detail value. The higher it is, the less fidelity the decals are going to have.
---@return TerrainDecal[] decals The decals for the cell.
function GetDecalsForCell( cellX, cellY, lod ) end

---Determines what tags the cell will have.
---@param cellX number The x coordinate of the cell.
---@param cellY number The y coordinate of the cell.
---@return string[] tags The tags.
function GetTagsForCell(cellX, cellY) end

---Determines what hit effect should be played at this position.
---@param x number The x coordinate.
---@param y number The y coordinate.
---@return string material The name of the material.
function GetEffectMaterialAt( x, y ) end

---???
---@return { [1]: integer, [2]: integer }[] cells {{cellX, cellY}, .. }
function GetOceanCells() end

---???
---@return { [1]: number, [2]: number, [3]: number, [4]: string }[] cells {{x, y, z, effectName}, ..}
function GetHLodCells() end

---@class TerrainCullingPortal
---@field id integer
---@field maxX number
---@field maxY number
---@field maxZ number
---@field minX number
---@field minY number
---@field minZ number
---@field zoneA number
---@field zoneB number

---@class TerrainCullingZone
---@field id integer
---@field maxX number
---@field maxY number
---@field maxZ number
---@field minX number
---@field minY number
---@field minZ number

---???
---@return TerrainCullingPortal[] portals
---@return TerrainCullingZone[] zones
function GetCullingZoneTree() end