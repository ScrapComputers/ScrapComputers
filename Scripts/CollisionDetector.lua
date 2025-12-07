---@class ComponentTemplateClass : ShapeClass
CollisionDetectorClass = class()
CollisionDetectorClass.maxParentCount = -1
CollisionDetectorClass.maxChildCount = 0
CollisionDetectorClass.connectionInput = sm.interactable.connectionType.compositeIO
CollisionDetectorClass.connectionOutput = sm.interactable.connectionType.none
CollisionDetectorClass.colorNormal = sm.color.new(0x696969ff)
CollisionDetectorClass.colorHighlight = sm.color.new(0x969696ff)

-- SERVER --

function CollisionDetectorClass:sv_createData()
    return {
        ---Returns the last collision event that occured.
        ---@return CollisionEvent[] collisionEvent The latest collision event.
        getLastCollisionEvent = function()
            return self.sv.lastCollisionEvent
        end,

        ---Returns the last melee event that occured.
        ---@return MeleeEvent[] meleeEvent The latest melee event.
        getLastMeleeEvent = function()
            return self.sv.lastMeleeEvent
        end,

        ---Returns true if the shape is actively colliding with something.
        ---@return boolean bool Wether the shape is colliding or not.
        isColliding = function()
            return self.sv.isColliding
        end,

        ---Returns true if the shape is actively being meleed.
        ---@return boolean bool Wether the shape is being meleed or not.
        isMeleeing = function ()
            return self.sv.isMeleeing
        end
   }
end

function CollisionDetectorClass:server_onCreate()
    self.sv = {}

    sm.scrapcomputers.powerManager.updatePowerInstance(self.shape.id, 0.2)
end

function CollisionDetectorClass:server_onFixedUpdate()
    self.sv.isColliding = false
    self.sv.isMeleeing = false
end

function CollisionDetectorClass:server_onCollision(other, position, selfPointVelocity, otherPointVelocity, normal )
    self.sv.lastCollision = sm.game.getCurrentTick()
    self.sv.isColliding = true

    self.sv.lastCollisionEvent = {
        other = type(other),
        position = position,
        selfPointVelocity = selfPointVelocity,
        otherPointVelocity = otherPointVelocity,
        normal = normal
    }
end

function CollisionDetectorClass:server_onMelee(position, attacker, damage, power, direction, normal)
    self.sv.lastMelee = sm.game.getCurrentTick()
    self.sv.isMeleeing = true

    self.sv.lastMeleeEvent = {
        position = position,
        attacker = type(attacker),
        damage = damage,
        power = power,
        direction = direction,
        normal = normal
    }
end

sm.scrapcomputers.componentManager.toComponent(CollisionDetectorClass, "CollisionDetectors", true, nil, true)