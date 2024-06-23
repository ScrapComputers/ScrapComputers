dofile("$CONTENT_DATA/Scripts/Config.lua")

---@class SeatController : ShapeClass
SeatController = class()
SeatController.maxParentCount = 1
SeatController.maxChildCount = -1
SeatController.connectionInput = sm.interactable.connectionType.power
SeatController.connectionOutput = sm.interactable.connectionType.compositeIO
SeatController.colorNormal = sm.color.new(0x696969ff)
SeatController.colorHighlight = sm.color.new(0x969696ff)

-- SERVER --

function SeatController:sv_createData()
    return {
        ---Gets seat data
        ---@return table? data The seat data
        getSeatData = function()
            if self.sv.seat then
                -- Get the ass
                return self.sv.data
            end
        end,

        ---Gets joints data
        ---@return table[]? data The joints data
        getJointData = function()
            if not self.sv.seat then return end

            -- GET THE MOTHERFUCKING ASS
            return self:sv_getJointData()
        end,

        ---Presses a button
        ---@param index integer? The button to press
        pressButton = function (index)
            assert(index > -1, "bad argument #1. Index out of range.") -- Range check

            if self.sv.seat then
                -- Do the fucking action
                self.sv.seat:pressSeatInteractable(index)
            end
        end,

        ---Releases a button
        ---@param index integer? THe button to release
        releaseButton = function (index)
            assert(index > -1, "bad argument #1. Index out of range.") -- Range check

            if self.sv.seat then
                -- Do the fucking action
                self.sv.seat:releaseSeatInteractable(index)
            end
        end,
    }
end

function SeatController:server_onCreate()
    -- Server-side Variables
    self.sv = {
        -- Contains seat data
        data = {},

        ---@type Interactable? The seat's interactable
        seat = nil
    }
end

function SeatController:server_onFixedUpdate()
    -- Get the singluar parent
    local int = self.interactable:getSingleParent()

    -- Check if there is one and is a seat
    if int and int:hasSeat() then
        -- Update self.sv.seat
        self.sv.seat = int

        -- Get the seated character
        local seatedCharacter = int:getSeatCharacter()

        -- Get the seated name or nil
        local name = seatedCharacter and seatedCharacter:getPlayer().name or nil

        -- Update self.sv.data
        self.sv.data = {
            wsPower       = int:getSteeringPower(), -- The current power when you got fucked in the ass
            adPower       = int:getSteeringAngle(), -- The current angle
            characterName = name                    -- The name of the sitting player
        }
    else
        -- WIPE IT OFF!
        self.sv.seat = nil
    end
end

function SeatController:sv_getJointData()
    -- The joint data
    local jointData = {}

    -- Loop through all bearings
    for _, joint in pairs(self.sv.seat:getBearings()) do
        -- Get it's settings
        local leftSpeed, rightSpeed, leftLimit, rightLimit, locked = self.sv.seat:getSteeringJointSettings(joint)

        -- Add it to jointData
        table.insert(jointData, {
            leftSpeed = leftSpeed,   -- The current left speed
            rightSpeed = rightSpeed, -- The current right speed
            leftLimit = leftLimit,   -- The current left limit (angle)
            rightLimit = rightLimit, -- The current right limit (angle)
            bearingLock = not locked -- True if the bearing is locked
        })
    end

    return jointData
end

-- Convert the class to a component
sm.scrapcomputers.components.ToComponent(SeatController, "SeatControllers", true)