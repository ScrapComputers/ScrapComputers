-- This file was using such a old version of the bitstream library that i have to do some stupid fucking hacks
-- so it would work

function swap_endian32(num)
    local b1 = bit.band(bit.rshift(num, 24), 0xFF)
    local b2 = bit.band(bit.rshift(num, 16), 0xFF)
    local b3 = bit.band(bit.rshift(num, 8),  0xFF)
    local b4 = bit.band(num, 0xFF)

    return bit.bor(
        bit.lshift(b4, 24),
        bit.lshift(b3, 16),
        bit.lshift(b2, 8),
        b1
    )
end

function swap_endian16(num)
    local b1 = bit.band(bit.rshift(num, 8), 0xFF)
    local b2 = bit.band(num, 0xFF)

    return bit.bor(
        bit.lshift(b2, 8),
        b1
    )
end

sm.scrapcomputers.nbs = {}

function sm.scrapcomputers.nbs.loadOpenNBS(str)
    sm.scrapcomputers.errorHandler.assertArgument(str, nil, {"string"})

    -- NOTE: We don't give a shit about OpenNBS's new data

    local data = sm.scrapcomputers.bitstream.new(str)

    if data:readBytes(2) ~= "\x00\x00" then
        error("Invalid (Open)NBS format!")
    end

    local header = {
        nbsVersion              = data:readByte(),
        vanilaInstrumentCount   = data:readByte(),
        songLength              = data:readUIntLE(16),
        layerCount              = data:readUIntLE(16),
        songName                = data:readBytes(data:readUIntLE(32)),
        songAuthor              = data:readBytes(data:readUIntLE(32)),
        songOriginalAuthor      = data:readBytes(data:readUIntLE(32)),
        songDescription         = data:readBytes(data:readUIntLE(32)),
        songTempo               = data:readUIntLE(16),
        autoSaving              = data:readByte() ~= 0,
        autoSavingDuration      = data:readByte(),
        timeSignature           = data:readByte(),
        minutesSpent            = data:readUIntLE(32),
        totalLeftClicks         = data:readUIntLE(32),
        totalRightClicks        = data:readUIntLE(32),
        totalNoteBlocksAdded    = data:readUIntLE(32),
        totalNoteBlocksRemoved  = data:readUIntLE(32),
        midiOrSchematicFilename = data:readBytes(data:readUIntLE(32)),
        loopToggle              = data:readByte(),
        maxLoopCount            = data:readByte(),
        loopStartTick           = data:readUIntLE(16)
    }
    
    local noteBlocks = {}
    local tick = -1

    while true do
        local tickJump = data:readUIntLE(16)
        if tickJump == 0 then break end
        
        tick = tick + tickJump
        
        while true do
            local layerJump = data:readUIntLE(16)
            if layerJump == 0 then break end
            
            local note = {
                tick             = tick,
                layer            = layerJump - 1,
                instrument       = data:readByte(),
                key              = data:readByte(),
                velocity         = data:readByte(),
                noteBlockPanning = data:readByte(),
                noteBlockPitch   = data:readUIntLE(16)
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
    if data:readBytes(2) == "\x00\x00" then
        return sm.scrapcomputers.nbs.loadOpenNBS(str)
    end
    
    data = sm.scrapcomputers.bitstream.new(str)

    ---@class NBS.Header
    local header = {
        songLength              = data:readUIntLE(16),
        layerCount              = data:readUIntLE(16),
        songName                = data:readBytes(data:readUIntLE(32)),
        songAuthor              = data:readBytes(data:readUIntLE(32)),
        songOriginalAuthor      = data:readBytes(data:readUIntLE(32)),
        songDescription         = data:readBytes(data:readUIntLE(32)),
        songTempo               = data:readUIntLE(16),
        autoSaving              = data:readByte() ~= 0,
        autoSavingDuration      = data:readByte(),
        timeSignature           = data:readByte(),
        minutesSpent            = data:readUIntLE(32),
        totalLeftClicks         = data:readUIntLE(32),
        totalRightClicks        = data:readUIntLE(32),
        totalNoteBlocksAdded    = data:readUIntLE(32),
        totalNoteBlocksRemoved  = data:readUIntLE(32),
        midiOrSchematicFilename = data:readBytes(data:readUIntLE(32))
    }
    
    ---@alias NBS.Blocks NBS.Note[]
    
    ---@type NBS.Blocks
    local noteBlocks = {}
    local tick = -1

    while true do
        local tickJump = data:readUIntLE(16)
        if tickJump == 0 then break end
        
        tick = tick + tickJump
        
        while true do
            local layerJump = data:readUIntLE(16)
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
        actualTempo = (nbsData.header.songTempo / 2000),
        looped = false
    }

    -- Error-handling makes it slow as hell, So we have to play it unsafe.
    local playSound = sm.scrapcomputers.dataList["Speakers"][speaker.getId()].SC_PRIVATE_fastPlaySound

    for _, block in pairs(nbsData.noteBlocks) do
        local smTick = block.tick * 2 -- Scale tick positions for 40 TPS

        if not player.noteBlockOrder[smTick] then
            player.noteBlockOrder[smTick] = {}
        end

        table.insert(player.noteBlockOrder[smTick], block)
    end

    -- Update the new size based on adjusted tick positions
    -- Find highest key instead of #table because it's sparse
    local maxTick = 0
    for tick in pairs(player.noteBlockOrder) do
        if tick > maxTick then
            maxTick = tick
        end
    end
    player.noteBlockOrderSize = maxTick

    function player:update()
        if not self.playing then
            return
        end

        local layer = player.noteBlockOrder[math.floor(self.tick)]
        self.tick = self.tick + self.actualTempo -- scale tempo to 40 TPS
        print(self.tick)
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
