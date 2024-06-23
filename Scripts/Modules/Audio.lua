---@diagnostic disable: duplicate-doc-field
-- This is a manager for the Audio json file for ScrapComputers
sm.scrapcomputers.audio = {}

---Returns all audio's that u can use.
---@return string[]
function sm.scrapcomputers.audio.getAudioNames()
    -- Check if the file exists
    if not sm.json.fileExists(sm.scrapcomputers.jsonFiles.AudioList) then
        error("Corrupted Mod! Audio json file not found!")
    end

    -- Open it
    local data = sm.json.open(sm.scrapcomputers.jsonFiles.AudioList)
    local output = {}

    -- Loop through it and add the name to the output
    for name, _ in pairs(data) do
        table.insert(output, name)
    end

    -- return it
    return output
end

---Returns true if the name exists.
---
---<h2>NOTE: The name must be full path! else it will NOT work!</h2>
---@param name string The name of the audio (FULL ONLY!)
---@return boolean audioExists If true, the name that was passed did exist as audio. else false (Doesn't exist)
function sm.scrapcomputers.audio.exists(name)
    -- Vaildation
    assert(type(name) == "string", "Expected string, Got "..type(name).." instead!")

    -- Check if the file exists
    if not sm.json.fileExists(sm.scrapcomputers.jsonFiles.AudioList) then
        error("Corrupted Mod! Audio json file not found!")
    end

    -- Open it
    local data = sm.json.open(sm.scrapcomputers.jsonFiles.AudioList)

    -- Loop through it
    for audioName, _ in pairs(data) do
        -- Check if the index matches with the name. if so then return true
        if audioName == name then
            return true
        end
    end

    -- Since it couldn't find any. it dosen't exist so return flase
    return false
end

---@class sm.scrapcomputers.audio.AudioParameter
---@field default number The default value of the Parameter
---@field maximum number The maximum value of the Parameter
---@field minimum number The minimum value of the Parameter

---This will return the parameters you can set by the audio name
---@param name string The name of the audio to get it's paramters
---@return sm.scrapcomputers.audio.AudioParameter[]?
function sm.scrapcomputers.audio.getParams(name)
    -- Vaildation
    assert(type(name) == "string", "Expected string, Got "..type(name).." instead!")
    assert(sm.scrapcomputers.audio.exists(name), "Audio doesn't exist!") -- Important!

    -- Open it
    local data = sm.json.open(sm.scrapcomputers.jsonFiles.AudioList)

    -- Loop through it
    for audioName, audioContents in pairs(data) do
        -- Check if the index matches with the name. if so then return the paramterList if it even exist
        if audioName == name then
            return audioContents["Parameters"]
        end
    end

    -- Since it didn't exist (This is not even possible. if u somehow get nil and u put a print statment
    -- right here and it prints. PLEASE FOR THE LOVE OF GOD REPORT IT TO US AS IT WILL NOT MAKE SENSE OF
    -- WHY IT WILL DO THAT)
    return nil
end

---@class sm.scrapcomputers.audio.ParamsIncorrectTable
---@field hasNoParamsUsableIssue boolean If true, then this audio doesn't have any paramaters.
---@field issues string[][] Contains all issues that have issue with the parameters

---This will return the parameters you can set by the audio name
---@param name string The name of the audio to get it's paramters
---@param params sm.scrapcomputers.audio.AudioParameter[] The paramaters of the audio that it will contain
---@return sm.scrapcomputers.audio.ParamsIncorrectTable? validAudioParamaters If nil, then all of your paramters are valid. Else its a table that will contain the issues
function sm.scrapcomputers.audio.areParamsCorrect(name, params)
    -- Vaildation
    assert(type(name)   == "string", "bad argument #1, Expected string, Got "..type(name  ).." instead!")
    assert(type(params) == "table" , "bad argument #2, Expected string, Got "..type(params).." instead!")
    assert(sm.scrapcomputers.audio.exists(name), "Audio doesn't exist!") -- Important!

    local existingAudioParams = sm.scrapcomputers.audio.getParams(name) -- Get the parameters

    ---@type sm.scrapcomputers.audio.ParamsIncorrectTable
    local issuesTable = {hasNoParamsUsableIssue = false, issues = {}}
    
    if not existingAudioParams then
        if sm.scrapcomputers.table.getTotalItemsDict(params) > 0 then
            issuesTable.hasNoParamsUsableIssue = true
            return issuesTable
        end
    end

    -- Loop through parameters
    for index, value in pairs(params) do
        -- Create issues table
        local issues = {}

        -- Check if index is valid. else add it to issues
        if type(index) ~= "string" then
            table.insert(issues, "INDEX_NOT_NUMBER")
        else
            -- Check if the parameter even exist's. else add to issues
            if not existingAudioParams[index] then
                table.insert(issues, "PARAMETER_DOESNT_EXIST")
            else
                -- Check if the value is valid. else add it to issues
                if type(value) ~= "number" then
                    table.insert(issues, "VALUE_NOT_NUMBER")
                else
                    -- Get the existing
                    local existingAudioParam = existingAudioParams[index]
                
                    -- Check if the boundaries are correct. else add to issues
                    if value > existingAudioParam.maximum then
                        table.insert(issues, "VALUE_TOO_HIGH")
                    end
                    if value < existingAudioParam.minimum then
                        table.insert(issues, "VALUE_TOO_LOW")
                    end
                end
            end
        end

        -- Check if it has any issues. if so then add it to the issuesTable
        if sm.scrapcomputers.table.getTotalItemsDict(issues) > 0 then
            issuesTable.issues[sm.scrapcomputers.toString(index)] = issues
        end
    end

    -- Return nil if theres no issues. else return the issuesTable
    if sm.scrapcomputers.table.getTotalItemsDict(issuesTable.issues) == 0 then
        return nil
    end
    return issuesTable
end