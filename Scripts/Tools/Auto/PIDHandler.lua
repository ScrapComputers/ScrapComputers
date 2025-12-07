dofile("$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/Scripts/Config.lua")

---@class PIDHandlerClass : ToolClass
PIDHandlerClass = class()

sm.scrapcomputers.PIDHandler = {}
sm.scrapcomputers.PIDHandler.processes = {}

function sm.scrapcomputers.PIDHandler.createProcess(processID)
    sm.scrapcomputers.errorHandler.assertArgument(processID, 1, {"number"})

    sm.scrapcomputers.PIDHandler.processes[processID] = {
        PIDOut = 0,
        processValue = 0,
        setValue = 0,
        p = 0,
        i = 0,
        d = 0,
        deltatimeI = 1,
        deltatimeD = 1,

        dBuffer = {},
        dBufferIndex = 0,
        averageBuffer = {},
        bufferIndex = 1
    }
end

function sm.scrapcomputers.PIDHandler.removeProcess(processID)
    sm.scrapcomputers.errorHandler.assertArgument(processID, 1, {"number"})

    sm.scrapcomputers.PIDHandler.processes[processID] = nil
end

function sm.scrapcomputers.PIDHandler.setProcess(processID, processValue, setValue, p, i, d, deltatimeI, deltatimeD)
    sm.scrapcomputers.errorHandler.assertArgument(processID, 1, {"number"})
    sm.scrapcomputers.errorHandler.assertArgument(processValue, 2, {"number", "nil"})
    sm.scrapcomputers.errorHandler.assertArgument(setValue, 3, {"number", "nil"})
    sm.scrapcomputers.errorHandler.assertArgument(p, 4, {"number", "nil"})
    sm.scrapcomputers.errorHandler.assertArgument(i, 5, {"number", "nil"})
    sm.scrapcomputers.errorHandler.assertArgument(d, 6, {"number", "nil"})
    sm.scrapcomputers.errorHandler.assertArgument(deltatimeI, 7, {"number", "nil"})
    sm.scrapcomputers.errorHandler.assertArgument(deltatimeD, 8, {"number", "nil"})

    local currentProcess = sm.scrapcomputers.PIDHandler.processes[processID]

    if currentProcess then
        currentProcess.processValue = processValue or 0
        currentProcess.setValue = setValue or 0
        currentProcess.p = p or 0
        currentProcess.i = i or 0
        currentProcess.d = d or 0
        currentProcess.deltatimeI = deltatimeI and sm.util.clamp(deltatimeI, 1, 4096) or 1
        currentProcess.deltatimeD = deltatimeD and sm.util.clamp(deltatimeD, 1, 4096) or 1

        sm.scrapcomputers.PIDHandler.processes[processID] = currentProcess
    end
end

function sm.scrapcomputers.PIDHandler.getProcess(processID)
    sm.scrapcomputers.errorHandler.assertArgument(processID, 1, {"number"})

    local currentProcess = sm.scrapcomputers.PIDHandler.processes[processID]
    assert(currentProcess, "Process ID: "..processID.." does not have a created process.")
    
    return currentProcess
end

local function movingAverage(num, averageBuffer, bufferIndex, count)
    averageBuffer[bufferIndex] = num;
    bufferIndex = (bufferIndex + 1)%count
  
    local runningAverage = 0

    for k, v in pairs(averageBuffer) do
        if k >= count then
            v = 0
        else
            runningAverage = runningAverage + v
        end
    end

    return runningAverage / count, averageBuffer, bufferIndex
end

function PIDHandlerClass:server_onCreate()
end

function PIDHandlerClass:server_onFixedUpdate()
    if sm.scrapcomputers.PIDHandler and sm.scrapcomputers.table.getTableSize(sm.scrapcomputers.PIDHandler.processes) > 0 then
        if sm.scrapcomputers.computerManager:getTotalComputers() == 0 then
            sm.scrapcomputers.PIDHandler.processes = {}
        end

        for _, process in pairs(sm.scrapcomputers.PIDHandler.processes) do
            local _error = process.setValue - process.processValue
            process.dBuffer[process.dBufferIndex] = _error
            local lasterror = (process.dBuffer[(process.dBufferIndex - process.deltatimeD)%20] == nil) and _error or process.dBuffer[(process.dBufferIndex - process.deltatimeD)%20]
            
            local maOut
            maOut, process.averageBuffer, process.bufferIndex = movingAverage(_error, process.averageBuffer, process.bufferIndex, process.deltatimeI)
            
            local output = _error * process.p + maOut * process.i + (_error - lasterror) * process.d
            output = sm.util.clamp(output, -4096, 4096)

            process.dBufferIndex = (process.dBufferIndex + 1)%20
            process.PIDOut = output
        end
    end
end

function PIDHandlerClass:server_onRefresh() self:server_onCreate() end