---Additional features that sm.vec3 dosen't have
sm.scrapcomputers.vec3 = {}

---Since the add,subtract,divide and mulitply have same asserts. To reduce amount of code. this is all in 1 function now
local function peformASDMAsserts(vec3, x, y, z)
    assert(type(vec3) == "Vec3", "bad argument #1. Expected number. Got "..type(vec3).." instead!")
    assert(type(x) == "number", "bad argument #2. Expected number. Got "..type(x).." instead!")
    assert(type(y) == "number", "bad argument #3. Expected number. Got "..type(y).." instead!")
    assert(type(z) == "number", "bad argument #4. Expected number. Got "..type(z).." instead!")
end

---A function like sm.vec3.new but its 1 argument.
---
---Its just simply sm.vec3.new(xyzNum, xyzNum, xyzNum) and also why its called "newSingluar".
---@param xyzNum any
---@return Vec3
sm.scrapcomputers.vec3.newSingluar = function (xyzNum)
    assert(type(xyzNum) == "number", "Expected number. Got "..type(xyzNum).." instead!")

    return sm.vec3.new(xyzNum, xyzNum, xyzNum)
end

---Returns a new vector3 with the added numbers
---@param vec3 Vec3
---@param x number
---@param y number
---@param z number
---@return Vec3
sm.scrapcomputers.vec3.add = function(vec3, x, y, z)
    peformASDMAsserts(vec3, x, y, z) -- Perform checks
    return sm.vec3.new(vec3.x + x, vec3.y + y, vec3.z + z) -- Return new vec3 with the new values
end

---Returns a new vector3 with the subtracted numbers
---@param vec3 Vec3
---@param x number
---@param y number
---@param z number
---@return Vec3
sm.scrapcomputers.vec3.subtract = function(vec3, x, y, z)
    peformASDMAsserts(vec3, x, y, z) -- Perform checks
    return sm.vec3.new(vec3.x - x, vec3.y - y, vec3.z - z) -- Return new vec3 with the new values
end

---Returns a new vector3 with the divided numbers
---@param vec3 Vec3
---@param x number
---@param y number
---@param z number
---@return Vec3
sm.scrapcomputers.vec3.divide = function(vec3, x, y, z)
    peformASDMAsserts(vec3, x, y, z) -- Perform checks
    return sm.vec3.new(vec3.x / x, vec3.y / y, vec3.z / z) -- Return new vec3 with the new values
end

---Returns a new vector3 with the multiplied numbers
---@param vec3 Vec3
---@param x number
---@param y number
---@param z number
---@return Vec3
sm.scrapcomputers.vec3.mulitply = function(vec3, x, y, z)
    peformASDMAsserts(vec3, x, y, z) -- Perform checks
    return sm.vec3.new(vec3.x * x, vec3.y * y, vec3.z * z) -- Return new vec3 with the new values
end

---Gets the distance between 2 vector's.
---@param vec1 Vec3 The first point
---@param vec2 Vec3 The seccond point
---@return number The distance between the 2 vector3's.
sm.scrapcomputers.vec3.distance = function (vec1, vec2)
    assert(type(vec1) == "Vec3", "bad argument #1. Expected Vec3, Got "..type(vec1).." instead!")
    assert(type(vec2) == "Vec3", "bad argument #2. Expected Vec3, Got "..type(vec2).." instead!")
    
    local dx = vec2.x - vec1.x
    local dy = vec2.y - vec1.y
    local dz = vec2.z - vec1.z
    return math.sqrt(dx * dx + dy * dy + dz * dz)
end