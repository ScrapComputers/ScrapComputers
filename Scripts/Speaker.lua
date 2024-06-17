dofile("$CONTENT_DATA/Scripts/Config.lua")

---@class Speaker : ShapeClass
Speaker = class()
Speaker.maxParentCount = 1
Speaker.maxChildCount = 0
Speaker.connectionInput = sm.interactable.connectionType.compositeIO
Speaker.connectionOutput = sm.interactable.connectionType.none
Speaker.colorNormal = sm.color.new(0x7d34ebff)
Speaker.colorHighlight = sm.color.new(0xb66ffcff)

-- SERVER --
local AUDIO_START_NAME = "ScrapComputers - AUDIO"

function Speaker:sv_createData()
    ---This checks parameters if they are correct. else they error
    ---@param name string The name of the audio
    ---@param params sc.audio.AudioParameter[] The parameters for it
    local function checkParameters(name, params)
        local validParamsCheck = sc.audio.areParamsCorrect(name, params) -- Check if the parameters are correct
        if validParamsCheck then
            -- Its not correct! Merge all issues into 1 big ass string and error it out.
            local issuesAsText = "\t"

            -- Check if its a no params usable issue. If so then say it
            if validParamsCheck.hasNoParamsUsableIssue then
                issuesAsText = "NO_PARAMETERS_ALLOWED"
            else
                -- Loop through them and format it all to be in issuesAsText
                ---@param paramaterName string
                for paramaterName, paramater in pairs(validParamsCheck.issues) do
                    issuesAsText = issuesAsText.."\n\t"..paramaterName..string.rep(" ", 15 - #paramaterName)
                    for _, issue in pairs(paramater) do
                        issuesAsText = issuesAsText.."\t"..issue..","
                    end

                    issuesAsText = issuesAsText:sub(1, #issuesAsText - 1)
                end
            end

            -- ERROR MY FUCKING ASS!
            error("Invalid Parameters! Error('s): "..issuesAsText)
        end
    end
    return {
        ---Play's a beep sound
        beep = function ()
            -- Add it
            table.insert(self.sv.buffer, {"cl_playNote", {AUDIO_START_NAME.." ", 10, {pitch = 100}}})
        end,

        ---Play's a beep sound
        ---NOTE: This won't actually play! it is added to a queue so u have to flush the queue to play it!
        ---@return number beepIndex The index where the queue is located.
        beepQueue = function ()
            -- Add it and return ít's index
            table.insert(self.sv.bufferQueue, {"cl_playNote", {AUDIO_START_NAME.." ", 10, {pitch = 100}}})
            return #self.sv.bufferQueue
        end,

        -- Play's whatever note
        ---@param pitch number
        ---@param note number The nit
        ---@param durationTicks number The duration that it will play in ticks
        playNote = function (pitch, note, durationTicks)
            durationTicks = durationTicks or 40

            assert(type(pitch        ) == "number", "bad argument #1, Expected number, got "       ..type(pitch        ).." instead!")
            assert(type(note         ) == "number", "bad argument #2, Expected number, got "       ..type(note         ).." instead!")
            assert(type(durationTicks) == "number", "bad argument #3, Expected number or nil, got "..type(durationTicks).." instead!")
            assert(durationTicks       >  0       , "bad argument #3, Expected higher number than 0")

            assert(note <= 9 and note >= 0, "bad argument #1, Out of bounds! (0 to 10!)"                                             )

            table.insert(self.sv.buffer, {"cl_playNote", {AUDIO_START_NAME..tostring(note), durationTicks, {pitch = pitch}}})
        end,

        -- NOTE: This won't actually play! it is added to a queue so u have to flush the queue to play it!
        ---@return number beepIndex The index where the queue is located.
        playNoteQueue = function (pitch, note, durationTicks)
            -- Set the default values incase they are nil
            durationTicks = durationTicks or 40

            -- Do some validation
            assert(type(note         ) == "number", "bad argument #1, Expected number, got "       ..type(note         ).." instead!")
            assert(type(durationTicks) == "number", "bad argument #2, Expected number or nil, got "..type(durationTicks).." instead!")
            assert(durationTicks       >  0       , "bad argument #2, Expected higher number than 0")

            assert(note <= 9 and note >= 0, "bad argument #1, Out of bounds! (0 to 10!)"                                             )
            -- Add it and return the index for it
            table.insert(self.sv.bufferQueue, {"cl_playNote", {AUDIO_START_NAME..tostring(note), durationTicks, {pitch = pitch}}})
            return #self.sv.bufferQueue
        end,

        -- Plays whatever event effect you specify!
        playNoteEffect = function (name, params, durationTicks)
            -- Set the default values incase they are nil
            durationTicks = durationTicks or 40
            params        = params        or {}

            -- Do some validation
            assert(type(name         ) == "string", "bad argument #1, Expected string, got "       ..type(name         ).." instead!")
            assert(type(params       ) == "table" , "bad argument #2, Expected table or nil, got "  ..type(params      ).." instead!")
            assert(type(durationTicks) == "number", "bad argument #3, Expected number or nil, got "..type(durationTicks).." instead!")
            assert(durationTicks       >  0       , "bad argument #3, Expected higher number than 0")

            -- Do validation for the name and paramters
            assert(sc.audio.exists(name), "bad argument #1, Invalid audio name!")

            checkParameters(name, params)

            -- Add it
            table.insert(self.sv.buffer, {"cl_playNote", {"ScrapComputers - "..name, durationTicks, params}})
        end,

        -- Plays whatever event effect you specify!
        -- NOTE: This won't actually play! it is added to a queue so u have to flush the queue to play it!
        ---@return number beepIndex The index where the queue is located.
        playNoteEffectQueue = function (name, params, durationTicks)
            -- Set the default values incase they are nil
            durationTicks = durationTicks or 40
            params        = params        or {}

            -- Do some validation
            assert(type(name         ) == "string", "bad argument #1, Expected string, got "       ..type(name         ).." instead!")
            assert(type(params       ) == "table" , "bad argument #2, Expected table or nil, got "  ..type(params      ).." instead!")
            assert(type(durationTicks) == "number", "bad argument #3, Expected number or nil, got "..type(durationTicks).." instead!")
            assert(durationTicks       >  0       , "bad argument #3, Expected higher number than 0")

            -- Do validation for the name and paramters
            assert(sc.audio.exists(name), "bad argument #1, Invalid audio name!")

            checkParameters(name, params)

            -- Add it and return the index for it
            table.insert(self.sv.bufferQueue, {"cl_playNote", {"ScrapComputers - "..name, durationTicks, params}})
            return #self.sv.bufferQueue
        end,

        ---Flushes the queue and plays all of them whatever it's inside at ONCE!
        flushQueue = function ()
            -- Send the entire queue to the buffer
            for _, data in ipairs(self.sv.bufferQueue) do
                table.insert(self.sv.buffer, data)
            end
 
            -- Clear it like how fucking messy your room is.
            self.sv.bufferQueue = {}
        end,

        ---Remove's a note from the queue
        ---@param noteIndex number The index where the note is located
        removeNote = function (noteIndex)
            -- Do some validation
            assert(type(noteIndex                     ) == "number", "Expected number, got "..type(note).." instead!")
            assert(type(self.sv.bufferQueue[noteIndex]) == "table" , "Note doesn't exist!"                           )
            
            -- Remove a bit from your left-over ass shit.
            self.sv.bufferQueue[noteIndex] = nil
        end,

        ---Clear the entire queue
        clearQueue = function ()
            -- Clear it like when u had to hire a maid for 1 day just so u can force him to clean your entire home.
            self.sv.bufferQueue = {}
        end,

        ---Returns the size of the queue
        ---@return number queueSize The size of the queue.
        getCurrentQueueSize = function ()
            -- Return the size of the queue
            return #self.sv.bufferQueue
        end,

        -- Stops all audio that are playing
        stopAllAudio = function ()
            self.sv.killAll = true
        end
    }
end

function Speaker:server_onCreate()
    -- Server-side variables
    self.sv = {
        -- The buffer that contains all the notes
        buffer = {},
        --- The buffer that is like the one above but more like a queue buffer.
        bufferQueue = {},
        --- The boolean that will kill all playing effects if true
        killAll = false
    }
end

function Speaker:server_onFixedUpdate()
    -- Loop through the buffer (if it has anything in it)
    if #self.sv.buffer > 0 then
        -- Loop through them and fuck the network by sending a shit ton to all clients of them in potentally 1 tick. Good Idea fucking Veradev.
        for _, ClFunc in pairs(self.sv.buffer) do
            self.network:sendToClients(ClFunc[1], ClFunc[2])
        end
    
        -- Clear like how you clean your ass.
        self.sv.buffer = {}
    end

    -- Check if it has to kill all sounds. if so then send it to all clients and set it back to false
    if self.sv.killAll then
        self.network:sendToClients("cl_killAll")
        self.sv.killAll = false
    end
end

-- CLIENT --
function Speaker:client_onCreate()
    -- Client-side variables
    self.cl = {
        ---@type Effect[] Contain's all effects
        effects = {},
        ---@type table Contains info about a effect by id.
        effectBuffer = {}
    }
end

function Speaker:cl_killAll()
    -- Loop through all of them
    for effectId, _ in pairs(self.cl.effectBuffer) do
        -- Stop it and destroy it if it exists
        if sm.exists(self.cl.effects[effectId]) then
            self.cl.effects[effectId]:stopImmediate()
            self.cl.effects[effectId]:destroy()
        end

        -- Remove it from list
        table.remove(self.cl.effects, effectId)
        table.remove(self.cl.effectBuffer, effectId)
    end
end

function Speaker:client_onFixedUpdate()
    -- Loop through all of them
    for effectId, number in pairs(self.cl.effectBuffer) do
        -- Check if theres no duration
        if number == 0 then
            -- Stop it and destroy it if it exists
            if sm.exists(self.cl.effects[effectId]) then
                self.cl.effects[effectId]:stopImmediate()
                self.cl.effects[effectId]:destroy()
            end

            -- Remove it from list
            table.remove(self.cl.effects, effectId)
            table.remove(self.cl.effectBuffer, effectId)
        else
            -- Theres duration! Decrease it by 1 tick.
            self.cl.effectBuffer[effectId] = self.cl.effectBuffer[effectId] - 1
        end
    end
end

-- Plays a note
function Speaker:cl_playNote(params)
    -- Unpack the arguments
    ---@type string,number,table
    local name, durationTicks, args = unpack(params)
    local effect = sm.effect.createEffect(name, self.interactable) -- Create it
    
    if type(args) == "table" then -- If it has any parameters. Set it to the effect
        for index, value in pairs(args) do
            effect:setParameter(index, value)
        end
    end

    effect:start() -- Play it

    -- Add it to the list.
    table.insert(self.cl.effectBuffer, effect:getId(), math.floor(durationTicks))
    table.insert(self.cl.effects, effect:getId(), effect)
end

-- Convert the class to a component
dofile("$CONTENT_DATA/Scripts/ComponentManager.lua")
sc.componentManager.ToComponent(Speaker, "Speakers", true)