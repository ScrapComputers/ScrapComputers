sm.scrapcomputers.computerManager = {}
sm.scrapcomputers.backend.computerManager = {}

local backend = sm.scrapcomputers.backend.computerManager
backend.computers = {} ---@type ComputerClass[]

---Registers a new computer
---@param classInstance ComputerClass The class instance
---@return integer id The id of the registered computer. Needed for comminucation!
function sm.scrapcomputers.computerManager:registerComputer(classInstance)
    backend.computers[classInstance.shape.id] = classInstance

    return classInstance.shape.id
end

---Updates a computer instance
function sm.scrapcomputers.computerManager:update()
    local pendingDeletion = {}

    for id, computer in pairs(backend.computers) do
        if not sm.exists(computer.shape) then
            table.insert(pendingDeletion, id)
        end
    end

    for _, id in pairs(pendingDeletion) do
        backend.computers[id] = nil
    end
end

---Returns the amount of computers that exist in the world
---@return integer amount Total computers
function sm.scrapcomputers.computerManager:getTotalComputers()
    sm.scrapcomputers.errorHandler.sandboxAssert(true)

    return sm.scrapcomputers.table.getTableSize(backend.computers)
end

---Returns all computer ids in the world.
---@return integer[] ids All computer ids in the world.
function sm.scrapcomputers.computerManager:getAllComputers()
    sm.scrapcomputers.errorHandler.sandboxAssert(true)
    local ids = {}

    for id, _ in pairs(backend.computers) do
        table.insert(ids, id)
    end

    return ids
end

---Returns true if a id is found inside of the computer manager
---@param id integer ID of a computer
---@return boolean exists Wether if it exists or not.
function sm.scrapcomputers.computerManager:computerExists(id)
    sm.scrapcomputers.errorHandler.sandboxAssert(true)
    sm.scrapcomputers.errorHandler.assertArgument(id, nil, {"integer"})

    return backend.computers[id] ~= nil
end

---Returns the filesystem of a computer. Hote that the filesystem is shared!
---@param id integer ID of a comptuer.
---@return Computer.Filesystem filesystem The computer's filesystem.
function sm.scrapcomputers.computerManager:getFilesystemOfComputer(id)
    sm.scrapcomputers.errorHandler.sandboxAssert(true)
    sm.scrapcomputers.errorHandler.assertArgument(id, nil, {"integer"})

    local computer = backend.computers[id]
    sm.scrapcomputers.errorHandler.assert(computer, nil, "Computer not found!")

    return computer.sv.storage.filesystem
end

---Forcefully syncs the filesystem to the computer to update it. Not calling this means it won't
---be synced with the computer's storage or clients til a sync event with the filesystem happens!
function sm.scrapcomputers.computerManager:forceSyncFilesystem()
    sm.scrapcomputers.errorHandler.sandboxAssert(true)
    sm.scrapcomputers.errorHandler.assertArgument(id, nil, {"integer"})

    local computer = backend.computers[id]
    sm.scrapcomputers.errorHandler.assert(computer, nil, "Computer not found!")

    sm.scrapcomputers.sharedTable:forceSyncProperty(computer.sv.storage, "filesystem")
end