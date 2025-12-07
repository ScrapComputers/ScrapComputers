MemoryTracker = {}
MemoryTracker.__index = MemoryTracker

function MemoryTracker:new()
    local obj = {
        totalDiff = 0,
        frameCount = 0,
        maxDiff = 0,
        avgDiff = 0,
        growthStreak = 0,

        totalPositive = 0,
        totalNegative = 0,
        countPositive = 0,
        countNegative = 0,

        memoryUsageSamples = {},
        diffsWindow = {},
        lastWasGC = false,

        maxWindowSize = 30,
        highTrendStreak = 0
    }

    sm.scrapcomputers.util.setmetatable(obj, self)
    return obj
end

function MemoryTracker:trackMemory(L)
    local delta = L.memory.new - L.memory.old
    
    self.frameCount = self.frameCount + 1
    self.totalDiff = self.totalDiff + delta

    if delta > self.maxDiff then
        self.maxDiff = delta
    end

    if delta > 0 then
        self.growthStreak = self.growthStreak + 1
        self.totalPositive = self.totalPositive + delta
        self.countPositive = self.countPositive + 1
        self.lastWasGC = false
    elseif delta < 0 then
        self.growthStreak = 0
        self.totalNegative = self.totalNegative + delta
        self.countNegative = self.countNegative + 1
        self.lastWasGC = true
    else
        self.growthStreak = 0
    end

    table.insert(self.memoryUsageSamples, {
        old = L.memory.old,
        new = L.memory.new,
        delta = delta,
        timestamp = timestamp or os.time() * 1000,
    })

    while #self.memoryUsageSamples > 250 do
       table.remove(self.memoryUsageSamples, 1)
    end

    table.insert(self.diffsWindow, delta)
    if #self.diffsWindow > self.maxWindowSize then
        table.remove(self.diffsWindow, 1)
    end
end

function MemoryTracker:getData()
    local averageDiff = self.frameCount > 0 and (self.totalDiff / self.frameCount) or 0
    local averagePositive = self.countPositive > 0 and (self.totalPositive / self.countPositive) or 0
    local averageNegative = self.countNegative > 0 and (self.totalNegative / self.countNegative) or 0

    local trend = 0
    local n = #self.diffsWindow
    if n > 1 then
        local sumX, sumY, sumXY, sumXX = 0, 0, 0, 0
        for i, val in ipairs(self.diffsWindow) do
            sumX = sumX + i
            sumY = sumY + val
            sumXY = sumXY + i * val
            sumXX = sumXX + i * i
        end
        local denominator = (n * sumXX - sumX * sumX)
        if denominator ~= 0 then
            trend = (n * sumXY - sumX * sumY) / denominator
        end
    end

    local STREAK_THRESHOLD = 1
    
    if trend >= 1 then
        self.highTrendStreak = self.highTrendStreak + 1
    else
        self.highTrendStreak = 0
    end

    self.memoryIsLikelyHigh = self.highTrendStreak >= STREAK_THRESHOLD

    return {
        frameCount = self.frameCount,
        totalDiff = self.totalDiff,
        maxDiff = self.maxDiff,
        avgDiff = averageDiff,
        growthStreak = self.growthStreak,

        totalPositive = self.totalPositive,
        countPositive = self.countPositive,
        averagePositive = averagePositive,

        totalNegative = self.totalNegative,
        countNegative = self.countNegative,
        averageNegative = averageNegative,

        lastWasGC = self.lastWasGC,

        memoryUsageSamplesCount = #self.memoryUsageSamples,

        diffsWindow = self.diffsWindow,
        trend = trend,

        memoryIsLikelyHigh = self.memoryIsLikelyHigh,
    }
end

function MemoryTracker.getEmptyData()
    return {
        frameCount = 0,
        totalDiff = 0,
        maxDiff = 0,
        avgDiff = 0,
        growthStreak = 0,

        totalPositive = 0,
        countPositive = 0,
        averagePositive = 0,

        totalNegative = 0,
        countNegative = 0,
        averageNegative = 0,

        lastWasGC = false,

        memoryUsageSamplesCount = 0,

        diffsWindow = {},
        trend = 0,
    }
end

function MemoryTracker:reset()
    self.totalDiff = 0
    self.frameCount = 0
    self.maxDiff = 0
    self.avgDiff = 0
    self.growthStreak = 0

    self.totalPositive = 0
    self.totalNegative = 0
    self.countPositive = 0
    self.countNegative = 0

    self.memoryUsageSamples = {}
    self.diffsWindow = {}
    self.lastWasGC = false
end
