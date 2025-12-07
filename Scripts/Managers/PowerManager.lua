sm.scrapcomputers.powerManager = {}
sm.scrapcomputers.powerManager.powerTable = {}
sm.scrapcomputers.powerManager.customTable = {}

function sm.scrapcomputers.powerManager.createPowerInstance(shapeId)
    sm.scrapcomputers.powerManager.powerTable[shapeId] = 0
end

function sm.scrapcomputers.powerManager.createCustomComponent(shape, type_, data)
    sm.scrapcomputers.powerManager.customTable[shape.id] = {type = type_, shape = shape, data = data}
end

function sm.scrapcomputers.powerManager.updateCustomComponent(shapeId, data)
    sm.scrapcomputers.powerManager.customTable[shapeId].data = data
end

function sm.scrapcomputers.powerManager.updatePowerInstance(shapeId, powerPoints)
    sm.scrapcomputers.powerManager.powerTable[shapeId] = powerPoints
end

function sm.scrapcomputers.powerManager.removePowerInstance(shapeId)
    sm.scrapcomputers.powerManager.powerTable[shapeId] = nil
    sm.scrapcomputers.powerManager.customTable[shapeId] = nil
end

function sm.scrapcomputers.powerManager.isEnabled()
    return sm.scrapcomputers.config.getConfig("scrapcomputers.global.power").selectedOption == 2
end