---@class GravityControllerClass : ShapeClass
GravityControllerClass = class()
GravityControllerClass.maxParentCount = -1
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
        end,

        getBodyMass = function()
            return self.shape.body.mass / 10
        end,

        getCreationMass = function()
            local mass = 0

            for _, body in pairs(self.shape.body:getCreationBodies()) do
                mass = mass + body.mass / 10
            end

            return mass
        end
   }
end

function GravityControllerClass:sv_onPowerLoss()
    self.sv.multiplier = 1
    self.sv.gravity = false
end

function GravityControllerClass:server_onCreate()
    self.sv = {
        multiplier = 1
    }
end

function GravityControllerClass:server_onFixedUpdate(dt)
    local totalMass = 0

    if self.sv.gravity then
        for _, body in pairs(self.shape.body:getCreationBodies()) do
            local gravity = sm.vec3.new(0, 0, 1) * sm.physics.getGravity() * 1.0475 * dt * (1 - self.sv.multiplier) * body.mass
            sm.physics.applyImpulse(body, gravity, true)

            totalMass = totalMass + body.mass
        end
    end

    local powerMult = math.abs(1 - self.sv.multiplier)
    local efficiencyMult = self.data.isLarge and 0.8 or 1
    sm.scrapcomputers.powerManager.updatePowerInstance(self.shape.id, (self.sv.gravity and (powerMult * totalMass / 100) or 0.1) * efficiencyMult)
end

-- CLIENT --

function GravityControllerClass:client_onCreate()
    if self.cl and sm.exists(self.cl.particle) then
        self.cl.particle:destroy()
    end

    local defualtName = "ScrapComputers - GravityControllerOrb Small"
    local effectName = self.data and (self.data.effectName or defualtName) or defualtName

    self.cl = {}
    self.cl.particle = sm.effect.createEffect(effectName, self.interactable)

    self.cl.particle:setAutoPlay(true)
    self.cl.particle:start()
end

function GravityControllerClass:client_onDestroy()
    if sm.exists(self.cl.particle) then
        self.cl.particle:destroy()
    end
end

sm.scrapcomputers.componentManager.toComponent(GravityControllerClass, "GravityControllers", true, nil, true)