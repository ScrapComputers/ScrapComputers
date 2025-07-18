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
    assert(currentProcess, "Process ID: "..processID.." does not have a created process.")

    currentProcess.processValue = processValue or 0
    currentProcess.setValue = setValue or 0
    currentProcess.p = p or 0
    currentProcess.i = i or 0
    currentProcess.d = d or 0
    currentProcess.deltatimeI = deltatimeI and sm.util.clamp(deltatimeI, 1, 4096) or 1
    currentProcess.deltatimeD = deltatimeD and sm.util.clamp(deltatimeD, 1, 4096) or 1

    sm.scrapcomputers.PIDHandler.processes[processID] = currentProcess
end

function sm.scrapcomputers.PIDHandler.getProcess(processID)
    sm.scrapcomputers.errorHandler.assertArgument(processID, 1, {"number"})

    local currentProcess = sm.scrapcomputers.PIDHandler.processes[processID]
    assert(currentProcess, "Process ID: "..processID.." does not have a created process.")
    
    return currentProcess
end

