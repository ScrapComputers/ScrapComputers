-- Modified to just contain what the ScrapComputers ENV provides.

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

---@class UnsafeENV.RaycastResult
---A userdata object representing a <strong>raycast result</strong>.  
---A <strong>raycast result</strong> is a collection of data received from a raycast. The result contains information about where the raycast travelled and what objects it eventually hit.  
---Raycast results are the result of functions such as [sm.physics.raycast], [sm.physics.distanceRaycast] and [sm.localPlayer.getRaycast].  
local UnsafeENVRaycastResult = {}

---**Get**:
---Returns the direction vector of the raycast  
---@type Vec3
UnsafeENVRaycastResult.directionWorld = {}

---**Get**:
---Returns the fraction (0&ndash;1) of the distance reached until collision divided by the ray's length.  
---@type number
UnsafeENVRaycastResult.fraction = {}

---**Get**:
---Returns the normal vector of the surface that was hit, relative to the target's rotation.  
---@type Vec3
UnsafeENVRaycastResult.normalLocal = {}

---**Get**:
---Returns the normal vector of the hit surface  
---@type Vec3
UnsafeENVRaycastResult.normalWorld = {}

---**Get**:
---Returns the starting world position of the raycast.  
---@type Vec3
UnsafeENVRaycastResult.originWorld = {}

---**Get**:
---Returns the world position of the point that was hit, relative to the target's position.  
---@type Vec3
UnsafeENVRaycastResult.pointLocal = {}

---**Get**:
---Returns the world position of the point that was hit.  
---@type Vec3
UnsafeENVRaycastResult.pointWorld = {}

---**Get**:
---Returns the physics type of the target that was hit. (See [sm.physics.types])  
---@type RaycastResultTypes
UnsafeENVRaycastResult.type = {}

---**Get**:
---Returns whether the raycast successfully hit a target.  
---@type boolean
UnsafeENVRaycastResult.valid = {}

---Returns the [AreaTrigger] hit during the raycast. This is only possible if [RaycastResult.type] is equal to "areaTrigger", otherwise this will return nil.  
---@return userdata # The areaTrigger target
function RaycastResult:getAreaTrigger() end

---Returns the [Body] hit during the raycast. This is only possible if [RaycastResult.type] is equal to "body", otherwise this will return nil.  
---@return userdata # The body target.
function RaycastResult:getBody() end

---Returns the [Character] hit during the raycast. This is only possible if [RaycastResult.type] is equal to "character", otherwise this will return nil.  
---@return userdata # The character target.
function RaycastResult:getCharacter() end

---Returns the [Harvestable] hit during the raycast. This is only possible if [RaycastResult.type] is equal to "harvestable", otherwise this will return nil.  
---@return userdata # The harvestable target.
function RaycastResult:getHarvestable() end

---Returns the [Joint] hit during the raycast. This is only possible if [RaycastResult.type] is equal to "joint", otherwise this will return nil.  
---@return userdata # The joint target
function RaycastResult:getJoint() end

---Returns the [Lift] hit during the raycast. This is only possible if [RaycastResult.type] is equal to "lift", otherwise this will return nil.  
---@return userdata, boolean isTop; The lift; True if the lift is top
function RaycastResult:getLiftData() end

---Returns the [Shape] hit during the raycast. This is only possible if [RaycastResult.type] is equal to "body", otherwise this will return nil.  
---@return userdata # The shape target.
function RaycastResult:getShape() end

---Returns the material hit during the raycast. This is only possible if [RaycastResult.type] is equal to "terrainAsset", otherwise this will return empty.  
---@return string # The material name.
function RaycastResult:getTerrainAssetMaterialName() end 

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

---**Get**:
---Returns the material hit during the raycast. This is only possible if [RaycastResult.type] is equal to "terrainAsset" or "terrainSurface", otherwise this will return empty.
---@type string
RaycastResult.material = {}

---**Get**:
---Returns the color of the userdata object. Nil if the userdata object doesn't provide a color.
---@type Color?
RaycastResult.color = {}

---Creates a new class object.  
---@param base? table # An optional base class to inherit from. (Defaults to inheriting from no class)
---@return table # Class table.
function class(base) end

---Returns the type of an object as an enum integer. This includes standard Lua types and userdata types specific to this API.  
---@param object any # The object instance.
---@return integer # The object type.
function enumType(object) end

---Returns the type of an object as a string. This includes standard Lua types and userdata types specific to this API.  
---@param object any The object instance.
---@return string # The object type.
function type(object) end

---The <strong>sm</strong> namespace contain all API features related to Scrap Mechanic.  
sm = {}

---Lua types  
sm.types = {
    [0]     = "nil",                    ["nil"] = 0,
    [1]     = "boolean",                ["boolean"] = 1,
    [2]     = "lightUserdata",          ["lightUserdata"] = 2,
    [3]     = "number",                 ["number"] = 3,
    [4]     = "string",                 ["string"] = 4,
    [5]     = "table",                  ["table"] = 5,
    [6]     = "function",               ["function"] = 6,
    [7]     = "userdata",               ["userdata"] = 7,
    [8]     = "thread",                 ["thread"] = 8,
    
    [10001] = "Uuid",                   ["Uuid"] = 10001,
    [10003] = "Vec3",                   ["Vec3"] = 10003,
    [10004] = "Quat",                   ["Quat"] = 10004,
    [10005] = "Color",                  ["Color"] = 10005,
    [10006] = "RaycastResult",          ["RaycastResult"] = 10006,
    [10007] = "LoadCellHandle",         ["LoadCellHandle"] = 10007,
    [10008] = "Effect",                 ["Effect"] = 10008,
    
    [10021] = "Shape",                  ["Shape"] = 10021,
    [10022] = "Body",                   ["Body"] = 10022,
    [10023] = "Interactable",           ["Interactable"] = 10023,
    [10024] = "Container",              ["Container"] = 10024,
    [10025] = "Harvestable",            ["Harvestable"] = 10025,
    [10026] = "Network",                ["Network"] = 10026,
    [10027] = "World",                  ["World"] = 10027,
    [10028] = "Unit",                   ["Unit"] = 10028,
    [10029] = "Storage",                ["Storage"] = 10029,
    [10030] = "Player",                 ["Player"] = 10030,
    [10031] = "Character",              ["Character"] = 10031,
    [10032] = "Joint",                  ["Joint"] = 10032,
    [10033] = "AiState",                ["AiState"] = 10033,
    [10034] = "Quest",                  ["Quest"] = 10034,
    [10035] = "AreaTrigger",            ["AreaTrigger"] = 10035,
    [10036] = "Portal",                 ["Portal"] = 10036,
    [10037] = "PathNode",               ["PathNode"] = 10037,
    [10038] = "Lift",                   ["Lift"] = 10038,
    [10039] = "ScriptableObject",       ["ScriptableObject"] = 10039,
    [10040] = "BuilderGuide",           ["BuilderGuide"] = 10040,
    [10041] = "CullSphereGroup",        ["CullSphereGroup"] = 10041,
    [10042] = "VoxelTerrain",           ["VoxelTerrain"] = 10042,
    [10043] = "JsonGui",                ["JsonGui"] = 10043,
    [10044] = "JsonWidget",             ["JsonWidget"] = 10044,
    [10045] = "ClientScriptableObject", ["ClientScriptableObject"] = 10045,

    [20002] = "Tool",                   ["Tool"] = 20002,
    [20006] = "GuiInterface",           ["GuiInterface"] = 20006,
    [20007] = "BlueprintVisualization", ["BlueprintVisualization"] = 20007,
    [20008] = "Garage",                 ["Garage"] = 20008,
}

---Returns the current version of the game as a string.  
---@type string
sm.version = {}

---Parses and writes json files from and to lua values.  
sm.json = {}

---Opens a json file and parses to Lua table.  
---@param path string # The json file path.
---@param ignoreCache boolean? # Whether to ignore the cache.
---@return table # The table.
function sm.json.open(path, ignoreCache) end

---Parses a json string to lua table.  
---@param json string # The json string.
---@return table # The table.
function sm.json.parseJsonString(json) end

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

---Allows checking for static infortmation about items.  
sm.item = {}

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

---Used to check the state of the game.  
sm.game = {}

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
function sm.game.getTick() end

---Return the fraction value of how far the current day has progressed.  
---@return number # The fraction of the day cycle.
function sm.game.getTimeOfDay() end

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