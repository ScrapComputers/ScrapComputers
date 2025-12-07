---Additional features that sm.vec3 dosen't have
sm.scrapcomputers.vector3 = {}

---A function like sm.vec3.new but its 1 argument.
---
---Its just simply sm.vec3.new(xyzNum, xyzNum, xyzNum) and also why its called "newSingular".
---@param xyzNum number The vector3 value for x, y and z
---@return Vec3 vector3 The created vector3
function sm.scrapcomputers.vector3.newSingular(xyzNum)
    sm.scrapcomputers.errorHandler.assertArgument(xyzNum, nil, {"number"})

    return sm.vec3.new(xyzNum, xyzNum, xyzNum)
end

---Converts a vector3 to be in radians
---@param vec3 Vec3 The vector3 value for x, y and z
---@return Vec3 vec3 The created vector3
function sm.scrapcomputers.vector3.toRadians(vec3)
    sm.scrapcomputers.errorHandler.assertArgument(vec3, nil, {"Vec3"})

    return sm.vec3.new(math.rad(vec3.x), math.rad(vec3.y), math.rad(vec3.z))
end

---Converts a vector3 to be in degrees
---@param vec3 Vec3 The vector3 value for x, y and z
---@return Vec3 vec3 The created vector3
function sm.scrapcomputers.vector3.toDegrees(vec3)
    sm.scrapcomputers.errorHandler.assertArgument(vec3, nil, {"Vec3"})

    return sm.vec3.new(math.deg(vec3.x), math.deg(vec3.y), math.deg(vec3.z))
end

---Creates random noise in a vec3 format
---@param magnitude number The magnitude of the noise, a magnitude of 1 means the length of the output vector will be 1.
---@return Vec3 vec3 The created vector3
function sm.scrapcomputers.vector3.randomNoise(magnitude)
    sm.scrapcomputers.errorHandler.assertArgument(magnitude, nil, {"number"})

    local randVec = sm.vec3.new(math.random(), math.random(), math.random())
    return randVec:safeNormalize(sm.vec3.zero()) * magnitude
end