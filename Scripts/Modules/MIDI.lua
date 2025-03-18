sm.scrapcomputers.midi = {}

---Creates a MIDI player
---@param data table MIDI data generated from the conveter.
---@param speaker Speaker The speaker to play it to
function sm.scrapcomputers.midi.createPlayer(data, speaker)
    local player = {
        currentTick = 0,
        playing = false,
        looped = false,
        songData = data,
        speakerId = speaker.getId()
    }

    ---Starts the player
    function player:start()
        sm.scrapcomputers.errorHandler.assert(not self.playing, nil, "Already playing!")

        self.currentTick = 0
        self.playing = true
    end

    ---Stops the player
    function player:stop()
        sm.scrapcomputers.errorHandler.assert(self.playing, nil, "Already not playing!")

        self.currentTick = 0
        self.playing = false
    end

    ---Returns true if it is playing.
    ---@return boolean isPlaying If it is playing.
    function player:isPlaying()
        return self.playing
    end

    ---Toggles song looping.
    ---@param loop boolean If it should loop or not.
    function player:toggleLoop(loop)
        sm.scrapcomputers.errorHandler.assertArgument(loop, nil, {"boolean"})

        self.looped = loop
    end

    ---Returns true if it is looped
    ---@return boolean isLooped If it is looped or not.
    function player:isLooped()
        return self.looped
    end

    ---Plays the actual audio. Needs to be called every tick.
    function player:update()
        if not self.playing then return end
        
        local internalSpeaker = sm.scrapcomputers.dataList["Speakers"][self.speakerId]

        local tickNotes = self.songData.notes[self.currentTick + 1]
        if tickNotes then
            for _, note in pairs(tickNotes) do
                local scrapInstrument = self.songData.instrumentMap[tostring(note[2])] or 3
                if scrapInstrument >= 0 then
                    internalSpeaker.SC_PRIVATE_fastPlaySound(
                        "AUDIO" .. scrapInstrument,
                        { pitch = tonumber(note[1])},
                        tonumber(note[3]) or 40
                    )
                end
            end
        end

        self.currentTick = self.currentTick + 1

        if self.currentTick >= #self.songData.notes then
            if self.looped then
                self.currentTick = 0
            else
                self:stop()
            end
        end
    end

    return player
end