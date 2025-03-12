---@class GravityControllerClass : ShapeClass
GravityControllerClass = class()
GravityControllerClass.maxParentCount = 1
GravityControllerClass.maxChildCount = 0
GravityControllerClass.connectionInput = sm.interactable.connectionType.compositeIO
GravityControllerClass.connectionOutput = sm.interactable.connectionType.none
GravityControllerClass.colorNormal = sm.color.new(0x696969ff)
GravityControllerClass.colorHighlight = sm.color.new(0x969696ff)

-- SERVER --

function GravityControllerClass:sv_createData()
    return {

        setMultiplier = function(multiplier)
            sm.scrapcomputers.errorHandler.assertArgument(multiplier, 1, {"number"})

            self.sv.multiplier = multiplier
        end,

        getMultiplier = function()
            return self.sv.multiplier
        end,

        setGravityEnabled = function(bool)
            sm.scrapcomputers.errorHandler.assertArgument(bool, 1, {"boolean"})

            self.sv.gravity = bool
        end
   }
end

function GravityControllerClass:server_onCreate()
    self.sv = {
        multiplier = 1
    }
end

function GravityControllerClass:server_onFixedUpdate(dt)
    if self.sv.gravity then
        for _, body in pairs(self.shape.body:getCreationBodies()) do
            local gravity = sm.vec3.new(0, 0, 1) * sm.physics.getGravity() * 1.0475 * dt * (1 - self.sv.multiplier) * body.mass
            sm.physics.applyImpulse(body, gravity, true)
        end
    end
end

sm.scrapcomputers.componentManager.toComponent(GravityControllerClass, "GravityControllers", true)