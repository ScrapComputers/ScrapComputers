sm.scrapcomputers.vector2 = {}

---@return self
function sm.scrapcomputers.vector2.new(x, y)
    -- We gotta do this bullshit because we don't have access to setmetatable.
    local self = sm.scrapcomputers.table.clone(sm.scrapcomputers.vector2)
    self.x = x
    self.y = y

    return self
end

function sm.scrapcomputers.vector2:add(other)
    return sm.scrapcomputers.vector2.new(self.x + other.x, self.y + other.y)
end

function sm.scrapcomputers.vector2:sub(other)
    return sm.scrapcomputers.vector2.new(self.x - other.x, self.y - other.y)
end

function sm.scrapcomputers.vector2:mul(scalar)
    return sm.scrapcomputers.vector2.new(self.x * scalar, self.y * scalar)
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

function sm.scrapcomputers.vector2:dot(other)
    return self.x * other.x + self.y * other.y
end

function sm.scrapcomputers.vector2:cross(other)
    return self.x * other.y - self.y * other.x
end

function sm.scrapcomputers.vector2:max()
    return math.max(self.x, self.y)
end

function sm.scrapcomputers.vector2:min()
    return math.min(self.x, self.y)
end

function sm.scrapcomputers.vector2:rotateX(angle)
    local rad = math.rad(angle)
    local cos = math.cos(rad)
    local sin = math.sin(rad)
    return sm.scrapcomputers.vector2.new(self.x, self.y * cos - self.x * sin)
end

function sm.scrapcomputers.vector2:rotateY(angle)
    local rad = math.rad(angle)
    local cos = math.cos(rad)
    local sin = math.sin(rad)
    return sm.scrapcomputers.vector2.new(self.x * cos + self.y * sin, self.y)
end

function sm.scrapcomputers.vector2:tostring()
    return "(" .. self.x .. ", " .. self.y .. ")"
end