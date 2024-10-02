-- Lets you manage audio. (Names, not playing them)
sm.scrapcomputers.audio = {}

---Gets all the audio names.
---@return string[] fontNames All font names
function sm.scrapcomputers.audio.getAudioNames()
    local output = {}
    local data = sm.json.open(sm.scrapcomputers.jsonFiles.AudioList)

    for name, _ in pairs(data) do
        table.insert(output, name)
    end

    -- Return it
    return output
end

---Returns true if a audio name exists
---@param name string The name of the audio
---@return boolean audioExists If the audio exists or not
function sm.scrapcomputers.audio.audioExists(name)
    sm.scrapcomputers.errorHandler.assertArgument(name, nil, {"string"})

    local data = sm.json.open(sm.scrapcomputers.jsonFiles.AudioList)

    for audioName, _ in pairs(data) do
        if audioName == name then
            return true
        end
    end

    return false
end

--- Gives you available parameters of a audio name
--- @param name string The name of the audio
--- @return AudioParameter[]? AudioParameters All audio parameters assosiated with the audio
function sm.scrapcomputers.audio.getAvailableParams(name)
    sm.scrapcomputers.errorHandler.assertArgument(name, nil, {"string"})
    sm.scrapcomputers.errorHandler.assert(sm.scrapcomputers.audio.audioExists(name), "Audio Not Found!")

    local data = sm.json.open(sm.scrapcomputers.jsonFiles.AudioList)

    for audioName, audioContents in pairs(data) do
        if audioName == name then
            return audioContents["Parameters"]
        end
    end
end

---Returns you all issues with the parameters you have specified.
---@param name string The name of the audio
---@param params table The parameters you specified
---@return AudioParamsIssues? AudioParamsIssues All issues with the params specified
function sm.scrapcomputers.audio.getIssuesWithParams(name, params)
    sm.scrapcomputers.errorHandler.assertArgument(name, 1, {"string"})
    sm.scrapcomputers.errorHandler.assertArgument(params, 2, {"table"}, {"AudioParameter[]"})
    
    sm.scrapcomputers.errorHandler.assert(sm.scrapcomputers.audio.audioExists(name), 2, "Audio Not Found!")
    
    local existingAudioParams = sm.scrapcomputers.audio.getAvailableParams(name)
    local issuesTable = {hasNoParamsUsableIssue = false, issues = {}}
    
    if not existingAudioParams then
        if sm.scrapcomputers.table.getTableSize(params) > 0 then
            issuesTable.hasNoParamsUsableIssue = true
            return issuesTable
        end
    end

    for parameterIndex, parameterValue in pairs(params) do
        local issues = {}

        if type(parameterIndex) ~= "string" then
            table.insert(issues, "INDEX_NOT_NUMBER")
        else
            local existingAudioParam = existingAudioParams[parameterIndex]

            if not existingAudioParam then
                table.insert(issues, "PARAMETER_DOESNT_EXIST")
            else
                if type(parameterValue) ~= "number" then
                    table.insert(issues, "VALUE_NOT_NUMBER")
                else
                    if parameterValue > existingAudioParam.maximum then
                        table.insert(issues, "VALUE_TOO_HIGH")
                    end

                    if parameterValue < existingAudioParam.minimum then
                        table.insert(issues, "VALUE_TOO_LOW")
                    end
                end
            end
        end

        if sm.scrapcomputers.table.getTableSize(issues) > 0 then
            issuesTable.issues[sm.scrapcomputers.toString(parameterIndex)] = issues
        end
    end

    if sm.scrapcomputers.table.getTableSize(issuesTable.issues) == 0 then
        return nil
    end

    return issuesTable
end