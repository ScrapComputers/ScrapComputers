sm.scrapcomputers.logger = {}

local function GenerateLogFunction(logFunc, type)
    ---@param identifier string The identifier of where the log came
    ---@param ... any[]|any Parameters
    return function (identifier, ...)
        if not sm.scrapcomputers.isDeveloperEnvironment() then return end

        logFunc("[SC-" .. identifier .. " " .. type .. "] >", ...)
    end
end

sm.scrapcomputers.logger.info = GenerateLogFunction(sm.log.info   , "INFO")
sm.scrapcomputers.logger.warn = GenerateLogFunction(sm.log.warning, "WARN")
sm.scrapcomputers.logger.error = GenerateLogFunction(sm.log.error  , "ERROR")
sm.scrapcomputers.logger.fatal = GenerateLogFunction(sm.log.error  , "FATAL")