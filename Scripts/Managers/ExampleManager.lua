---Manages examples and lets you create examples for the Computer.
sm.scrapcomputers.exampleManager = sm.scrapcomputers.exampleManager or {}
sm.scrapcomputers.exampleManager.examples = {}

sm.scrapcomputers.exampleManager.addonExamples = sm.scrapcomputers.exampleManager.addonExamples or {}

---Reloads all the examples.
function sm.scrapcomputers.exampleManager.reloadExamples()
    local bultInExamples = sm.json.open("$CONTENT_632be32f-6ebd-414e-a061-d45906ae4dc6/JSON/examples.json")
    local mergedList = sm.scrapcomputers.table.mergeLists(bultInExamples, sm.scrapcomputers.exampleManager.addonExamples)

    sm.scrapcomputers.exampleManager.examples = mergedList
end

---Gets the loaded examples.
---@return {name:string,script:string}[] examples All loaded examples.
function sm.scrapcomputers.exampleManager.getExamples()
    sm.scrapcomputers.exampleManager.reloadExamples()
    
    return sm.scrapcomputers.exampleManager.examples
end

---Gets the total amount of examples currently loaded.
---@return integer totalExamples The total amount of loaded examples
function sm.scrapcomputers.exampleManager.getTotalExamples()
    return #sm.scrapcomputers.exampleManager.getExamples()
end

---Adds a example
---@param name string The name of the example
---@param script string The script of the example
function sm.scrapcomputers.exampleManager.addExample(name, script)
    sm.scrapcomputers.errorHandler.assertArgument(name, 1, {"string"})
    sm.scrapcomputers.errorHandler.assertArgument(script, 2, {"string"})

    local exampleData = {
        name = name,
        script = script
    }

    table.insert(sm.scrapcomputers.exampleManager.addonExamples, exampleData)
    sm.scrapcomputers.exampleManager.reloadExamples()
end

---Gets a example from name
---@param name string The example name
---@return Example? example The discovered example, nil if not found
function sm.scrapcomputers.exampleManager.loadExample(name)
    sm.scrapcomputers.errorHandler.assertArgument(name, nil, {"string"})

    local lowerName = name:lower()
    local examples = sm.scrapcomputers.exampleManager.getExamples()
    for _, example in pairs(examples) do
        if example.name:lower() == lowerName then
            return example
        end
    end
end

sm.scrapcomputers.exampleManager.reloadExamples()