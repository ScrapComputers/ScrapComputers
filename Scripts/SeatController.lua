---@class SeatControllerClass : ShapeClass
SeatControllerClass = class()
SeatControllerClass.maxParentCount = 1
SeatControllerClass.maxChildCount = -1
SeatControllerClass.connectionInput = sm.interactable.connectionType.power
SeatControllerClass.connectionOutput = sm.interactable.connectionType.compositeIO
SeatControllerClass.colorNormal = sm.color.new(0x696969ff)
SeatControllerClass.colorHighlight = sm.color.new(0x969696ff)
SeatControllerClass.connectIcon = "driverSeat"
SeatControllerClass.connectIconScale = 0.75

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
        getJointData = function() return self.sv.seat and self.sv.jointData or nil end,

        ---Gets the seated characters camera data and returns it
        ---@return CameraData data The camera data
        getCameraData = function() return self.sv.seat and self.sv.camera or nil end,

        ---Gets the connected joints steering angles and returns it
        ---@return number[]? angles The connected joints steering angles
        getSteeringAngles = function() return self.sv.seat and self.sv.steeringAngles or nil end,

        ---Presses a button
        ---@param index integer The button to press
        ---@return boolean? success If it succeeded
        pressButton = function(index)
            sm.scrapcomputers.errorHandler.assertArgument(index, nil, { "integer" })
            sm.scrapcomputers.errorHandler.assert(index >= 0, nil, "Index out of range.")

            return self.sv.seat and self.sv.seat:pressSeatInteractable(index) or nil
        end,

        ---Releases a button
        ---@param index integer The button to release
        ---@return boolean? success If it succeeded
        releaseButton = function(index)
            sm.scrapcomputers.errorHandler.assertArgument(index, nil, { "integer" })
            sm.scrapcomputers.errorHandler.assert(index >= 0, nil, "Index out of range.")

            return self.sv.seat and self.sv.seat:releaseSeatInteractable(index) or nil
        end,
    }
end

function SeatControllerClass:server_onCreate()
    self.sv = {
        data = {
            wsPower = 0,
            adPower = 0,
            sprint = false,
            characterName = nil
        },
        camera = {},
        seat = nil, ---@type Interactable
        jointData = {},
        steeringAngles = {}
    }

    sm.scrapcomputers.powerManager.updatePowerInstance(self.shape.id, 1)
end

function SeatControllerClass:server_onFixedUpdate()
    local singleParent = self.interactable:getSingleParent()

    if singleParent and singleParent:hasSeat() then
        self.sv.seat = singleParent

        local seatedCharacter = singleParent:getSeatCharacter()
        local name = seatedCharacter and seatedCharacter:getPlayer().name or nil

        self.sv.data.wsPower = singleParent:getSteeringPower()
        self.sv.data.adPower = singleParent:getSteeringAngle()
        self.sv.data.sprint = singleParent:getSteeringSprint()
        self.sv.data.characterName = name

        self:sv_updateJointsInfo()
    else
        self.sv.seat = nil

        for index = #self.sv.jointData, 1, -1 do self.sv.jointData[index] = nil end
        for index = #self.sv.steeringAngles, 1, -1 do self.sv.steeringAngles[index] = nil end
    end
end

function SeatControllerClass:sv_updateJointsInfo()
    local joints = self.sv.seat:getJoints()
    if not joints then return end

    local jointData = self.sv.jointData
    local steeringAngles = self.sv.steeringAngles

    local count = 0
    for _, joint in ipairs(joints) do
        if sm.exists(joint) and joint:getBearingEnabled() then
            count = count + 1
            
            local angle = joint:getAngle()
            local jointType = joint:getType()

            steeringAngles[count] = (jointType == "spring" and -angle or angle)

            local leftSpeed, rightSpeed, leftLimit, rightLimit, locked = self.sv.seat:getSteeringJointSettings(joint)
            local isReversed = joint:isReversed()
            isReversed = (jointType == "spring") ~= isReversed

            local item = jointData[count] or {}
            item.leftSpeed = leftSpeed
            item.rightSpeed = rightSpeed
            item.leftLimit = leftLimit
            item.rightLimit = rightLimit
            item.bearingLock = not locked
            item.isReversed = isReversed
            item.bearingType = jointType

            jointData[count] = item
        end
    end

    for index = #jointData, count + 1, -1 do
        jointData[index] = nil
    end

    for index = #steeringAngles, count + 1, -1 do
        steeringAngles[index] = nil
    end
end

function SeatControllerClass:sv_setCameraInfo(data)
    self.sv.camera = {
        position = data[1],
        rotation = data[2],
        direction = data[3],
        fov = data[4]
    }
end

-- CLIENT --

function SeatControllerClass:client_onCreate()
    self.cl = {
        lastCamPos = nil,
        lastCamRot = nil
    }
end

function SeatControllerClass:client_onFixedUpdate()
    local player = localPlayer.getPlayer()
    local character = player.character
    if not character then return end

    local singleParent = self.interactable:getSingleParent()
    if not singleParent or not singleParent:hasSeat() then return end

    local seatedCharacter = singleParent:getSeatCharacter()
    if not seatedCharacter or seatedCharacter ~= character then return end

    local camPos = camera.getPosition() + seatedCharacter.velocity * 0.025
    local camRot = camera.getRotation()
    local camDir = localPlayer.getDirection()
    local camFov = camera.getFov()

    if not self.cl.lastCamPos or self.cl.lastCamPos ~= camPos or self.cl.lastCamRot ~= camRot then
        self.cl.lastCamPos = camPos
        self.cl.lastCamRot = camRot

        self.network:sendToServer("sv_setCameraInfo", { camPos, camRot, camDir, camFov })
    end
end

sm.scrapcomputers.componentManager.toComponent(SeatControllerClass, "SeatControllers", true, nil, true)