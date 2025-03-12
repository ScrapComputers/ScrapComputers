---@class SpeakerClass : ShapeClass
SpeakerClass = class()
SpeakerClass.maxParentCount = 1
SpeakerClass.maxChildCount = 0
SpeakerClass.connectionInput = sm.interactable.connectionType.compositeIO
SpeakerClass.connectionOutput = sm.interactable.connectionType.none
SpeakerClass.colorNormal = sm.color.new(0x7d34ebff)
SpeakerClass.colorHighlight = sm.color.new(0xb66ffcff)

-- SERVER --
function SpeakerClass:sv_createData()
    ---@param name string The name of the audio
    ---@param params AudioParameter[] The parameters for it
    local function checkParameters(name, params)
        local validParamsCheck = sm.scrapcomputers.audio.getIssuesWithParams(name, params) 

        if validParamsCheck then
            local issuesAsText = "\t"

            if validParamsCheck.hasNoParamsUsableIssue then
                issuesAsText = "NO_PARAMETERS_ALLOWED"
            else
                ---@param paramaterName string
                for paramaterName, paramater in pairs(validParamsCheck.issues) do
                    issuesAsText = issuesAsText .. "\n\t" .. paramaterName .. string.rep(" ", 15 - #paramaterName)

                    for _, issue in pairs(paramater) do
                        issuesAsText = issuesAsText .. "\t" .. issue .. ","
                    end

                    issuesAsText = issuesAsText:sub(1, #issuesAsText - 1)
                end
            end

            error("Invalid Parameters! Error('s): " .. issuesAsText)
        end
    end

    return {
        beep = function ()
            table.insert(self.sv.buffer, {"ScrapComputers - AUDIO1", 10, {pitch = 100}})
        end,

        longBeep = function ()
            table.insert(self.sv.buffer, {"ScrapComputers - AUDIO1", 25, {pitch = 100}})
        end,

        ---@param pitch number The pitch
        ---@param note number The note
        ---@param durationTicks number The duration that it will play in ticks
        playNote = function (pitch, note, durationTicks)
            sm.scrapcomputers.errorHandler.assertArgument(pitch, 1, {"number"})
            sm.scrapcomputers.errorHandler.assertArgument(note, 2, {"integer"})
            sm.scrapcomputers.errorHandler.assertArgument(durationTicks, 3, {"integer", "nil"})
            
            sm.scrapcomputers.errorHandler.assert(durationTicks > 0, nil, "bad argument #3, Expected higher number than 0")
            sm.scrapcomputers.errorHandler.assert(note <= 9 and note >= 0, nil, "bad argument #1, Out of bounds! (0 to 10!)")

            table.insert(self.sv.buffer, {"ScrapComputers - AUDIO" .. sm.scrapcomputers.toString(note), durationTicks or 40, {pitch = pitch}})
        end,

        -- Plays whatever sound effect you specify!
        ---@param name string The pitch
        ---@param params AudioEffectParameterList The note
        ---@param durationTicks number The duration that it will play in ticks
        playSound = function (name, params, durationTicks)
            sm.scrapcomputers.errorHandler.assertArgument(name, 1, {"string"})
            sm.scrapcomputers.errorHandler.assertArgument(params, 2, {"table", "nil"})
            sm.scrapcomputers.errorHandler.assertArgument(durationTicks, 3, {"integer", "nil"})
            
            sm.scrapcomputers.errorHandler.assert(sm.scrapcomputers.audio.audioExists(name), nil, "Audio does not exist!")
            
            checkParameters(name, params or {})

            table.insert(self.sv.buffer, {"ScrapComputers - " .. name, durationTicks or 40, params or {}})
        end,

        SC_PRIVATE_fastPlaySound = function (name, params, durationTicks)
            self.sv.buffer[#self.sv.buffer+1] = {"ScrapComputers - " .. name, durationTicks, params}
        end,

        getId = function ()
            return self.shape.id
        end,

        stopAllAudio = function ()
            self.sv.killAll = true
        end
    }
end

function SpeakerClass:server_onCreate()
    self.sv = {
        buffer = {},
        killAll = false,
    }
end

function SpeakerClass:server_onFixedUpdate()
    if #self.sv.buffer > 0 then
        self.network:sendToClients("cl_playNotes", self.sv.buffer)
        self.sv.buffer = {}
    end

    if self.sv.killAll then
        self.network:sendToClients("cl_kilEmlAll")
        self.sv.killAll = false
    end
end

-- CLIENT --

function SpeakerClass:client_onCreate()
    self.cl = {
        effects = {}, --- @type Effect[]
        effectBuffer = {},
    }
end

function SpeakerClass:cl_kilEmlAll() -- 🔥🔥🔥 10/10 function name 💯💯💯
    for effectId, _ in pairs(self.cl.effectBuffer) do
        if sm.exists(self.cl.effects[effectId]) then
            self.cl.effects[effectId]:destroy()
        end

        table.remove(self.cl.effects, effectId)
        table.remove(self.cl.effectBuffer, effectId)
    end
end

function SpeakerClass:client_onFixedUpdate()
    for effectId, number in pairs(self.cl.effectBuffer) do
        if number == 0 then
            if sm.exists(self.cl.effects[effectId]) then
                self.cl.effects[effectId]:destroy()
            end

            table.remove(self.cl.effects, effectId)
            table.remove(self.cl.effectBuffer, effectId)
        else
            self.cl.effectBuffer[effectId] = self.cl.effectBuffer[effectId] - 1
        end
    end
end

function SpeakerClass:cl_playNote(params)
    local name, durationTicks, args = unpack(params) ---@type string,number,table
    local effect = sm.effect.createEffect(name, self.interactable)

    if type(args) == "table" then
        for index, value in pairs(args) do
            effect:setParameter(index, value)
        end
    end

    effect:start()

    table.insert(self.cl.effectBuffer, effect:getId(), math.floor(durationTicks))
    table.insert(self.cl.effects, effect:getId(), effect)
end

function SpeakerClass:cl_playNotes(notes)
    for _, note in pairs(notes) do
        self:cl_playNote(note)
    end
end

sm.scrapcomputers.componentManager.toComponent(SpeakerClass, "Speakers", true)