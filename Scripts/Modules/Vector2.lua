---@class __DO_NOT_USE__VECTOR_2_CLASS__
sm.scrapcomputers.vector2 = {}

---@param x number
---@param y number
---@return ScVec2
function sm.scrapcomputers.vector2.new(x, y)
    -- Metatbles don't work for some reason
    ---@class ScVec2 : __DO_NOT_USE__VECTOR_2_CLASS__
    local self = sm.scrapcomputers.table.clone(sm.scrapcomputers.vector2)
    self.x = x
    self.y = y
    self.new = nil
    
    return self
end

---@param x number
---@param y number
---@return self
function sm.scrapcomputers.vector2:set(x, y)
    self.x = x
    self.y = y

    return self
end

---@param other ScVec2
function sm.scrapcomputers.vector2:add(other)
    return sm.scrapcomputers.vector2.new(self.x + other.x, self.y + other.y)
end

---@param other ScVec2
function sm.scrapcomputers.vector2:sub(other)
    return sm.scrapcomputers.vector2.new(self.x - other.x, self.y - other.y)
end

---@param other ScVec2
function sm.scrapcomputers.vector2:mul(other)
    return sm.scrapcomputers.vector2.new(self.x * other.x, self.y * other.y)
end

---@param other ScVec2
function sm.scrapcomputers.vector2:div(other)
    return sm.scrapcomputers.vector2.new(self.x / other.x, self.y / other.y)
end

function sm.scrapcomputers.vector2:normalize()
    local length = self:length()
    return sm.scrapcomputers.vector2.new(self.x / length, self.y / length)
end

function sm.scrapcomputers.vector2:safeNormalize()
    local length = self:length()
    if length == 0 then
        return sm.scrapcomputers.vector2.new(0, 0)
    else
        return self:normalize()
    end
end

function sm.scrapcomputers.vector2:length()
    return math.sqrt(self:length2())
end

function sm.scrapcomputers.vector2:length2()
    return self.x * self.x + self.y * self.y
end

---@param other ScVec2
function sm.scrapcomputers.vector2:dot(other)
    return self.x * other.x + self.y * other.y
end

---@param other ScVec2
function sm.scrapcomputers.vector2:cross(other)
    return self.x * other.y - self.y * other.x
end

function sm.scrapcomputers.vector2:max()
    return math.max(self.x, self.y)
end

function sm.scrapcomputers.vector2:min()
    return math.min(self.x, self.y)
end

---@param angle number
function sm.scrapcomputers.vector2:rotateX(angle)
    local rad = math.rad(angle)
    local cos = math.cos(rad)
    local sin = math.sin(rad)
    return sm.scrapcomputers.vector2.new(self.x, self.y * cos - self.x * sin)
end

---@param angle number
function sm.scrapcomputers.vector2:rotateY(angle)
    local rad = math.rad(angle)
    local cos = math.cos(rad)
    local sin = math.sin(rad)
    return sm.scrapcomputers.vector2.new(self.x * cos + self.y * sin, self.y)
end

function sm.scrapcomputers.vector2:tostring()
    return "(" .. self.x .. ", " .. self.y .. ")"
end

function sm.scrapcomputers.vector2:clone()
    return sm.scrapcomputers.vector2.new(self.x, self.y)
end

function sm.scrapcomputers.vector2:distance(other)
    local dx = self.x - other.x
    local dy = self.y - other.y
    return math.sqrt(dx * dx + dy * dy)
end

---@param input ScVec2|table
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