---@class __DO_NOT_USE__VECTOR_2_CLASS__
sm.scrapcomputers.vector2 = {}

---Creates a new vector2
---@param x number The X value of the vector
---@param y number The Y value of the vector
---@return ScVec2 A new vector2 instance
function sm.scrapcomputers.vector2.new(x, y)
    -- Metatbles don't work for some reason
    ---@class ScVec2 : __DO_NOT_USE__VECTOR_2_CLASS__
    local self = sm.scrapcomputers.table.clone(sm.scrapcomputers.vector2)
    self.x = x
    self.y = y
    self.new = nil
    
    return self
end

---Sets the X and Y value of the vector.
---@param x number The new X value
---@param y number The new Y value
---@return self vector The current vector instance with updated values
function sm.scrapcomputers.vector2:set(x, y)
    self.x = x
    self.y = y

    return self
end

---Adds another vector to the current vector.
---@param other ScVec2 Another vector to add
---@return ScVec2 vector The resulting vector after addition
function sm.scrapcomputers.vector2:add(other)
    return sm.scrapcomputers.vector2.new(self.x + other.x, self.y + other.y)
end

---Subtracts another vector from the current vector.
---@param other ScVec2 Another vector to subtract
---@return ScVec2 vector The resulting vector after subtraction
function sm.scrapcomputers.vector2:sub(other)
    return sm.scrapcomputers.vector2.new(self.x - other.x, self.y - other.y)
end

---Multiplies the current vector by another vector element-wise.
---@param other ScVec2 Another vector to multiply
---@return ScVec2 vector The resulting vector after multiplication
function sm.scrapcomputers.vector2:mul(other)
    return sm.scrapcomputers.vector2.new(self.x * other.x, self.y * other.y)
end

---Divides the current vector by another vector element-wise.
---@param other ScVec2 Another vector to divide
---@return ScVec2 vector The resulting vector after division
function sm.scrapcomputers.vector2:div(other)
    return sm.scrapcomputers.vector2.new(self.x / other.x, self.y / other.y)
end

---Normalizes the vector, scaling it to unit length.
---@return ScVec2 vector The normalized vector
function sm.scrapcomputers.vector2:normalize()
    local length = self:length()
    return sm.scrapcomputers.vector2.new(self.x / length, self.y / length)
end

---Safely normalizes the vector, ensuring no division by zero.
---@return ScVec2 vector The normalized vector or (0, 0) if the vector is a zero vector
function sm.scrapcomputers.vector2:safeNormalize()
    local length = self:length()
    if length == 0 then
        return sm.scrapcomputers.vector2.new(0, 0)
    else
        return self:normalize()
    end
end

---Calculates the length (magnitude) of the vector.
---@return number length The length of the vector
function sm.scrapcomputers.vector2:length()
    return math.sqrt(self:length2())
end

---Calculates the squared length (magnitude) of the vector.
---@return number length The squared length of the vector
function sm.scrapcomputers.vector2:length2()
    return self.x * self.x + self.y * self.y
end

---Calculates the dot product of the current vector and another vector.
---@param other ScVec2 Another vector
---@return number dotProduct The dot product of the two vectors
function sm.scrapcomputers.vector2:dot(other)
    return self.x * other.x + self.y * other.y
end

---Calculates the cross product of the current vector and another vector.
---@param other ScVec2 Another vector
---@return number crossProduct The result of the cross product
function sm.scrapcomputers.vector2:cross(other)
    return self.x * other.y - self.y * other.x
end

---Finds the maximum of the two vector components (X and Y).
---@return number max The maximum value between x and y
function sm.scrapcomputers.vector2:max()
    return math.max(self.x, self.y)
end

---Finds the minimum of the two vector components (X and Y).
---@return number min The minimum value between x and y
function sm.scrapcomputers.vector2:min()
    return math.min(self.x, self.y)
end

---Rotates the vector around the X axis by a given angle.
---@param angle number The angle in degrees to rotate
---@return ScVec2 vector The rotated vector
function sm.scrapcomputers.vector2:rotateX(angle)
    local rad = math.rad(angle)
    local cos = math.cos(rad)
    local sin = math.sin(rad)
    return sm.scrapcomputers.vector2.new(self.x, self.y * cos - self.x * sin)
end

---Rotates the vector around the Y axis by a given angle.
---@param angle number The angle in degrees to rotate
---@return ScVec2 vector The rotated vector
function sm.scrapcomputers.vector2:rotateY(angle)
    local rad = math.rad(angle)
    local cos = math.cos(rad)
    local sin = math.sin(rad)
    return sm.scrapcomputers.vector2.new(self.x * cos + self.y * sin, self.y)
end

---Converts the vector to a string representation.
---@return string str A string representing the vector in the form "(x, y)"
function sm.scrapcomputers.vector2:tostring()
    return "(" .. self.x .. ", " .. self.y .. ")"
end

---Creates a new vector that is a clone of the current one.
---@return ScVec2 vector A new vector that is a copy of the current one
function sm.scrapcomputers.vector2:clone()
    return sm.scrapcomputers.vector2.new(self.x, self.y)
end

---Calculates the distance between the current vector and another vector.
---@param other ScVec2 Another vector to calculate distance to
---@return number The distance between the two vectors
function sm.scrapcomputers.vector2:distance(other)
    local dx = self.x - other.x
    local dy = self.y - other.y
    return math.sqrt(dx * dx + dy * dy)
end

---Converts an input into a vector2 if needed. If the input is already a vector2, it returns it; otherwise, it tries to convert from a table.
---@param input ScVec2|table The input that might be a vector2 or a table representing it
---@param nilAllowed boolean Whether `nil` is allowed as a valid input
---@return ScVec2 The converted vector2 or nil if allowed and input is nil
function sm.scrapcomputers.vector2.convertIfNeeded(input, nilAllowed)
    if nilAllowed and type(input) == "nil" then
        return nil
    end
    
    if type(input) ~= "table" then
        error("Not a valid Vec2!")
    end

    if #input == 0 and input.x and input.y then
        return input
    end

    if #input ~= 2 then
        error("Not a valid Vec2!")
    end

    if type(input[1]) ~= "number" or type(input[2]) ~= "number" then
        error("Not a valid Vec2!")
    end

    return sm.scrapcomputers.vector2.new(input[1], input[2])
end