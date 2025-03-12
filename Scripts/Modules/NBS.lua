sm.scrapcomputers.nbs = {}

function sm.scrapcomputers.nbs.loadOpenNBS(str)
    sm.scrapcomputers.errorHandler.assertArgument(str, nil, {"string"})

    -- NOTE: We don't give a shit about OpenNBS's new data

    local data = sm.scrapcomputers.bitstream.new(str)

    if data:readStringEx(2) ~= "\x00\x00" then
        error("Invalid (Open)NBS format!")
    end

    local header = {
        nbsVersion              = data:readByte(),
        vanilaInstrumentCount   = data:readByte(),
        songLength              = data:readNumberLE(2),
        layerCount              = data:readNumberLE(2),
        songName                = data:readString(true),
        songAuthor              = data:readString(true),
        songOriginalAuthor      = data:readString(true),
        songDescription         = data:readString(true),
        songTempo               = data:readNumberLE(2),
        autoSaving              = data:readByte() ~= 0,
        autoSavingDuration      = data:readByte(),
        timeSignature           = data:readByte(),
        minutesSpent            = data:readNumberLE(4),
        totalLeftClicks         = data:readNumberLE(4),
        totalRightClicks        = data:readNumberLE(4),
        totalNoteBlocksAdded    = data:readNumberLE(4),
        totalNoteBlocksRemoved  = data:readNumberLE(4),
        midiOrSchematicFilename = data:readString(true),
        loopToggle              = data:readByte(),
        maxLoopCount            = data:readByte(),
        loopStartTick           = data:readNumberLE(2)
    }
    
    local noteBlocks = {}
    local tick = -1

    while true do
        local tickJump = data:readNumberLE(2)
        if tickJump == 0 then break end
        
        tick = tick + tickJump
        
        while true do
            local layerJump = data:readNumberLE(2)
            if layerJump == 0 then break end
            
            local note = {
                tick             = tick,
                layer            = layerJump - 1,
                instrument       = data:readByte(),
                key              = data:readByte(),
                velocity         = data:readByte(),
                noteBlockPanning = data:readByte(),
                noteBlockPitch   = data:readNumberLE(2)
            }
            
            table.insert(noteBlocks, note)
        end
    end

    local output = {
        header = header,
        noteBlocks = noteBlocks,
        isOpenNBS = true
    }

    return output
end

function sm.scrapcomputers.nbs.loadNBS(str)
    sm.scrapcomputers.errorHandler.assertArgument(str, nil, {"string"})

    local data = sm.scrapcomputers.bitstream.new(str)
    
    -- Check for OpenNBS format
    if data:readStringEx(2) == "\x00\x00" then
        return sm.scrapcomputers.nbs.loadOpenNBS(str)
    end
    data:seek(1)

    ---@class NBS.Header
    local header = {
        songLength              = data:readNumberLE(2),
        layerCount              = data:readNumberLE(2),
        songName                = data:readString(true),
        songAuthor              = data:readString(true),
        songOriginalAuthor      = data:readString(true),
        songDescription         = data:readString(true),
        songTempo               = data:readNumberLE(2),
        autoSaving              = data:readByte() ~= 0,
        autoSavingDuration      = data:readByte(),
        timeSignature           = data:readByte(),
        minutesSpent            = data:readNumberLE(4),
        totalLeftClicks         = data:readNumberLE(4),
        totalRightClicks        = data:readNumberLE(4),
        totalNoteBlocksAdded    = data:readNumberLE(4),
        totalNoteBlocksRemoved  = data:readNumberLE(4),
        midiOrSchematicFilename = data:readString(true)
    }
    
    ---@alias NBS.Blocks NBS.Note[]
    
    ---@type NBS.Blocks
    local noteBlocks = {}
    local tick = -1

    while true do
        local tickJump = data:readNumberLE(2)
        if tickJump == 0 then break end
        
        tick = tick + tickJump
        
        while true do
            local layerJump = data:readNumberLE(2)
            if layerJump == 0 then break end
            
            ---@class NBS.Note
            local note = {
                tick       = tick,
                layer      = layerJump - 1,
                instrument = data:readByte(),
                key        = data:readByte()
            }
            
            table.insert(noteBlocks, note)
        end
    end

    ---@class NBS
    local output = {
        header = header,
        noteBlocks = noteBlocks,
        isOpenNBS = false
    }

    return output
end

local instrumentTable = {
    [0] = "event:/music/robotheads/piano",
    [1] = "event:/music/robotheads/dance/dancebass",
    [2] = "event:/music/robotheads/dance/dancedrum",
    [3] = "event:/music/robotheads/dance/dancelead",
    [4] = "event:/music/robotheads/dance/dancepad",
    [5] = "event:/music/robotheads/retrobass",
    [6] = "event:/music/robotheads/retrodrum",
    [7] = "event:/music/robotheads/retrofmblip",
    [8] = "event:/music/robotheads/retrovoice",
    [9] = "event:/music/robotheads/dancebass"
}

---@param nbsData NBS
---@param speaker Speaker
function sm.scrapcomputers.nbs.createPlayer(nbsData, speaker)
    local player = {
        playing = false,
        tick = 1,
        noteBlockOrder = {}, ---@type NBS.Blocks[]
        noteBlockOrderSize = 0,
        tempo = nbsData.header.songTempo,
        actualTempo = nbsData.header.songTempo / 4000,
        looped = false
    }

    -- Error-handling makes it slow as hell, So we have to play it unsafe.
    local playSound = sm.scrapcomputers.dataList["Speakers"][speaker.getId()].SC_PRIVATE_fastPlaySound

    for _, block in pairs(nbsData.noteBlocks) do
        if not player.noteBlockOrder[block.tick] then
            player.noteBlockOrder[block.tick] = {}
        end

        table.insert(player.noteBlockOrder[block.tick], block)
    end

    player.noteBlockOrderSize = #player.noteBlockOrderSize

    function player:update()
        if not self.playing then
            return
        end

        local layer = player.noteBlockOrder[math.floor(self.tick)]
        self.tick = self.tick + self.actualTempo

        if layer then
            for _, block in pairs(layer) do
                local instrument = instrumentTable[block.instrument]

                if instrument then
                    playSound(instrument, {pitch = block.key / 87}, 5)
                end
            end
        end

        if self.tick >= player.noteBlockOrderSize then
            if self.looped then
                self.tick = 1
            else
                self:stop()
            end
        end
    end

    function player:start()
        sm.scrapcomputers.errorHandler.assert(not self.playing, nil, "Please call NBSPlayer:stop before trying to play again!")

        self.tick = 1
        self.playing = true
    end

    function player:stop()
        sm.scrapcomputers.errorHandler.assert(not self.playing, nil, "Please call NBSPlayer:start before trying to stop again!")

        self.playing = false
    end

    function player:isPlaying()
        return self.playing
    end

    function player:getCurrentTick()
        return self.tick
    end

    function player:isLooped()
        return self.looped
    end

    function player:setLooped(looped)
        sm.scrapcomputers.errorHandler.assertArgument(looped, nil, {"boolean"})

        self.looped = looped
    end

    return player
end
