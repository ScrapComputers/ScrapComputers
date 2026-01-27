-- We let you control WASD power before, But the connected seat and this component kept on
-- having fackin MMO battles, fight to the fucking ashes style. So we were forced to remove
-- it.

---@class SeatControllerClass : ShapeClass
SeatControllerClass = class()
SeatControllerClass.maxParentCount = 1
SeatControllerClass.maxChildCount = -1
SeatControllerClass.connectionInput = sm.interactable.connectionType.power
SeatControllerClass.connectionOutput = sm.interactable.connectionType.compositeIO
SeatControllerClass.colorNormal = sm.color.new(0x696969ff)
SeatControllerClass.colorHighlight = sm.color.new(0x969696ff)

local localPlayer = sm.localPlayer
local camera = sm.camera

-- SERVER --

function SeatControllerClass:sv_createData()
    return {
        ---Gets seat data and returns it
        ---@return SeatData? data The seat data
        getSeatData = function() return self.sv.seat and self.sv.data or nil end,

        ---Gets all connected joints and gets its data and returns it
        ---@return JointData[]? data The connected joints data
        getJointData = function() return self.sv.seat and self:sv_getJointData() or nil end,

        ---Gets the seated characters camera data and returns it
        ---@return CameraData data The camera data
        getCameraData = function() return self.sv.seat and self.sv.camera or nil end,

        ---Presses a button
        ---@param index integer The button to press
        ---@return boolean? success If it succeeded
        pressButton = function (index)
            sm.scrapcomputers.errorHandler.assertArgument(index, nil, {"integer"})
            sm.scrapcomputers.errorHandler.assert(index >= 0, nil, "Index out of range.")

            return self.sv.seat and self.sv.seat:pressSeatInteractable(index) or nil
        end,

        ---Releases a button
        ---@param index integer The button to release
        ---@return boolean? success If it succeeded
        releaseButton = function (index)
            sm.scrapcomputers.errorHandler.assertArgument(index, nil, {"integer"})
            sm.scrapcomputers.errorHandler.assert(index >= 0, nil, "Index out of range.")

            return self.sv.seat and self.sv.seat:releaseSeatInteractable(index) or nil
        end,
}
end

function SeatControllerClass:server_onCreate()
    self.sv = {
        data = {},
        camera = {},
        seat = nil, ---@type Interactable
    }

    sm.scrapcomputers.powerManager.updatePowerInstance(self.shape.id, 1)
end

function SeatControllerClass:server_onFixedUpdate()
    local singleParent = self.interactable:getSingleParent()

    if singleParent and singleParent:hasSeat() then
        self.sv.seat = singleParent

        local seatedCharacter = singleParent:getSeatCharacter()
        local name = seatedCharacter and seatedCharacter:getPlayer().name or nil

        self.sv.data = {
            wsPower = singleParent:getSteeringPower(),
            adPower = singleParent:getSteeringAngle(),
            characterName = name,
        }
    else
        self.sv.seat = nil
    end
end

function SeatControllerClass:sv_getJointData()
    local jointData = {}

    for _, joint in pairs(self.sv.seat:getBearings()) do
        local leftSpeed, rightSpeed, leftLimit, rightLimit, locked = self.sv.seat:getSteeringJointSettings(joint)

        table.insert(jointData, {
            leftSpeed = leftSpeed,
            rightSpeed = rightSpeed,
            leftLimit = leftLimit,
            rightLimit = rightLimit,
            bearingLock = not locked,
        })
    end

    return jointData
end

function SeatControllerClass:sv_setCameraInfo(data)
    self.sv.camera = {
        position = data[1],
        rotation = data[2],
        direction = data[3],
        fov = data[4]
    }
end

function SeatControllerClass:client_onFixedUpdate()
    local player = localPlayer.getPlayer()
    local character = player.character

    if character then
        local singleParent = self.interactable:getSingleParent()

        if singleParent and singleParent:hasSeat() then
            local seatedCharacter = singleParent:getSeatCharacter()

            if seatedCharacter and seatedCharacter == character then
                self.network:sendToServer("sv_setCameraInfo", {camera.getDefaultPosition() + seatedCharacter.velocity * 0.025, camera.getDefaultRotation(), localPlayer.getDirection(), camera.getDefaultFov()})
            end
        end
    end
end

sm.scrapcomputers.componentManager.toComponent(SeatControllerClass, "SeatControllers", true, nil, true)