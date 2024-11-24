---@diagnostic disable
---The <strong>sm</strong> namespace contain all API features related to Scrap Mechanic.
---
---NOTE: This is modifed for the safe-env! Copy the sm.lua from the root of the mod to here and replace this file for unsafe-env!
sm = {}

---Parses and writes json files from and to lua values.  
sm.json = {}

---Opens a json file and parses to Lua table.  
---@param path string The json file path.
---@return table
function sm.json.open(path) end

---Parses a json string to lua table.  
---@param json string The json string.
---@return table
function sm.json.parseJsonString(json) end

---Writes a json string from a lua table.  
---@param root string The lua table.
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
---@param easing string The easing function name.
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