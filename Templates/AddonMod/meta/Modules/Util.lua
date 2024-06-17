---Additional features that sm.util dosen't have.
sc.util = {}

---Gets the remainder of division. This function is more safer than sm.util.postiveModule as for some reason, Scrap Mechanic
---dosent handle division by 0 for sm.util.postiveModule so it crashes.
---@param a number The number to divide
---@param b number The amount to divide
---@return number remainder The remains that it is impossible to divide
sc.util.postiveModulo = function (a, b)
    if b == 0 then
        error("Cannot Divide by 0!")
    else
        return sm.util.positiveModulo(a, b)
    end
end