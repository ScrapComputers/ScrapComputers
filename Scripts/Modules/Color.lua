---Additional features that sm.color dosen't have
sm.scrapcomputers.color = {}

---Generates a random color.
---
---@return Color
sm.scrapcomputers.color.random = function (from, to)
    assert(type(from) == "number", "bad argument #1. Expected number. Got "..type(from).." instead!")
    assert(type(to) == "number", "bad argument #2 Expected number. Got "..type(to).." instead!")
    
    return sm.color.new(math.random(from, to), math.random(from, to), math.random(from, to))
end

---Generates a random color. (0 to 1 as a float)
---
---@return Color
sm.scrapcomputers.color.random0to1 = function ()
    return sm.color.new(math.random(),math.random(),math.random())
end

---A function like sm.color.new but its 1 argument.
---
---Its just simply sm.color.new(rgbNum, rgbNum, rgbNum) and also why its called "newSingluar".
---@param rgbNum number
---@return Color
sm.scrapcomputers.color.newSingluar = function (rgbNum)
    assert(type(rgbNum) == "number", "Expected number. Got "..type(rgbNum).." instead!")

    return sm.color.new(rgbNum, rgbNum, rgbNum)
end