---Additional features for math related operations.
sm.scrapcomputers.math = {}

---Clamps a value from min to max
---@param value number The value to clamp
---@param min number The maximun
---@param max number The minimun
---@return number clampedValue The clamped number value.
sm.scrapcomputers.math.clamp = function(value, min, max)
    -- Asserts, Asserts. More fucking assertion.
    assert(type(value) == "number", "bad argument #1, Expected number, Got "..type(value).." instead!")
    assert(type(min) == "number", "bad argument #2, Expected number, Got "..type(min).." instead!")
    assert(type(max) == "number", "bad argument #3, Expected number, Got "..type(max).." instead!")
    
    assert(min <= max, "Min value must be less than or equal to Max value")
    
    -- This is all you gotta implement for clamping!
    return math.max(min, math.min(max, value))
end
