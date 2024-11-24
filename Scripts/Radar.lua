---@class RadarClass : ShapeClass
RadarClass = class()
RadarClass.maxParentCount = 1
RadarClass.maxChildCount = 0
RadarClass.connectionInput = sm.interactable.connectionType.compositeIO
RadarClass.connectionOutput = sm.interactable.connectionType.none
RadarClass.colorNormal = sm.color.new(0xa8604cff)
RadarClass.colorHighlight = sm.color.new(0xe06d2bff)

-- CLIENT / SERVER --

-- Returns true of a body is in a creation
---@param body Body The body to find
---@param creation Body[] The body's creations
---@return boolean bodyInCreation If true, the body is in the creation. else not!
local function isBodyInCreation(body, creation)
    for _, cBody in pairs(creation) do
        if cBody.id == body.id then
            return true
        end
    end

    return false
end

-- SERVER --

function RadarClass:sv_createData()
    return {
        -- Gets its targets and returns them.
        ---@return RadarTarget[] targets The list of detected targets
        getTargets = function() return self:sv_calculateTargets() end,

        -- Sets the vertical scan angle
        ---@param angle number The angle
        setVerticalScanAngle = function(angle)
            sm.scrapcomputers.errorHandler.assertArgument(angle, nil, {"number"})
            sm.scrapcomputers.errorHandler.assert(angle >= 10 and angle <= 90, nil, "Angle must be within 10 and 90 degrees")

            self.sv.vAngle = angle
        end,

        -- Sets the horizontal scan angle
        ---@param angle number The angle
        setHorizontalScanAngle = function(angle)
            -- Type check
            sm.scrapcomputers.errorHandler.assertArgument(angle, nil, {"number"})
            sm.scrapcomputers.errorHandler.assert(angle >= 10 and angle <= 90, nil, "Angle must be within 10 and 90 degrees")

            self.sv.hAngle = angle
        end,
}
end

function RadarClass:server_onCreate()
    self.sv = {
        vAngle = 30,
        hAngle = 30,
        targets = {},
    }
end

function RadarClass:sv_calculateTargets()
    local bodies = sm.body.getAllBodies()
    local losCreations = {} ---@type Body[][]

    local radarPos = self.shape.worldPosition
    local radarAt = sm.quat.getAt(self.shape.worldRotation)
    local radarUp = sm.quat.getUp(self.shape.worldRotation)

    local vAngleRad = math.rad(self.sv.vAngle / 2)
    local hAngleRad = math.rad(self.sv.hAngle / 2)

    for _, body in pairs(bodies) do
        local bool = isBodyInCreation(body, self.shape.body:getCreationBodies())

        if not bool then
            for _, creation in pairs(losCreations) do
                bool = isBodyInCreation(body, creation)

                if bool then break end
            end
        end

        if not bool then
            local bodyPos = body:getShapes()[1].worldPosition
            local dir = bodyPos - radarPos

            if dir:length() ~= 0 then
                local distance = dir:length()
                dir = dir:normalize()

                local verticalAngle = math.asin(dir:dot(radarUp))

                if math.abs(verticalAngle) > vAngleRad then
                    goto continue
                end

                local horizontalDir = dir - radarUp * dir:dot(radarUp)
                local horizontalAngle = math.acos(radarAt:dot(horizontalDir:normalize()))

                if horizontalAngle > hAngleRad then
                    goto continue
                end

                local hit, res = sm.physics.raycast(radarPos, radarPos + dir * distance, self.shape.body)

                if hit then
                    if res.type == "body" then
                        local resBody = res:getBody()
                        local bool1 = isBodyInCreation(resBody, body:getCreationBodies())

                        local creationId = resBody:getCreationId()

                        if bool1 and not losCreations[creationId] then
                            losCreations[creationId] = resBody:getCreationBodies()
                        end
                    end
                end
            end
        end

        ::continue::
    end

    local validTargets = {}

    if losCreations ~= {} then
        for _, creation in pairs(losCreations) do
            local minBound ---@type Vec3?
            local maxBound ---@type Vec3?

            for _, body in pairs(creation) do
                if sm.exists(body) then
                    local min, max = body:getLocalAabb()

                    if not minBound then
                        minBound = min
                        maxBound = max
                    else
                        minBound = minBound:min(min)
                        maxBound = maxBound:max(max)
                    end
                end
            end

            if maxBound and minBound then
                local averagePos = sm.vec3.zero()

                for _, body in pairs(creation) do
                    averagePos = averagePos + body:getCenterOfMassPosition()
                end

                averagePos = averagePos / #creation

                local distance = (self.shape.worldPosition - averagePos):length() ---@type number

                local bb = maxBound - minBound
                local surfaceArea = ((bb.x * bb.z + bb.x * bb.y + bb.z * bb.y) / 2 / math.sqrt(distance)) * 8

                local surfaceAreaBound = self.sv.hAngle * self.sv.vAngle / 80

                if surfaceArea > surfaceAreaBound or distance < 200 then
                    table.insert(validTargets, {creation, surfaceArea})
                end
            end
        end
    end

    local finalTargets = {}

    if #validTargets > 0 then
        for _, data in pairs(validTargets) do
            local creation, surfaceArea = unpack(data) ---@type Body[], number
            local averagePos = sm.vec3.zero()

            for _, body in pairs(creation) do
                averagePos = averagePos + body:getCenterOfMassPosition()
            end

            averagePos = averagePos / #creation

            table.insert(finalTargets, {position = averagePos, surfaceArea = surfaceArea})
        end
    end

    return finalTargets
end

sm.scrapcomputers.componentManager.toComponent(RadarClass, "Radars", true)