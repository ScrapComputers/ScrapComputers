--- Manages the environment variables for the Computer!
sm.scrapcomputers.environmentManager = {}

-- Lets you hook the environmentManager so you can add your own ENV to it!
---@type function[]
sm.scrapcomputers.environmentManager.environmentHooks = {}

---Creates a environment variables table and returns it
---@param self ShapeClass This should be the "self" keyword. A.K.A your class
---@return table environmentVariables The created environment variables.
function sm.scrapcomputers.environmentManager.createEnv(self)
    sm.scrapcomputers.errorHandler.assertArgument(self, nil, {"table"}, {"ShapeClass"})
    
    if not sm.scrapcomputers.config.getConfig then
        sm.scrapcomputers.config.initConfig()
    end

    local isUnsafeENV = sm.scrapcomputers.config.getConfig("scrapcomputers.computer.safe_or_unsafe_env").selectedOption == 2

    local environmentVariables = {
        print = function (...)
            local text = ""
            
            for _, value in ipairs({...}) do
                text = text .. " " .. sm.scrapcomputers.toString(value)
            end

            local message = text:gsub("⁄n", "\n"):gsub("⁄t", "\t"):sub(2)

            self.network:sendToClients("cl_chatMessage", "[#3A96DDS#3b78ffC#eeeeee]: " .. message)
        end,

        ---@param message string
        ---@param duration number?
        ---@param player Player?
        alert = function(message, duration, player)
            duration = duration or 5

            sm.scrapcomputers.errorHandler.assertArgument(message, 1, {"string"})
            sm.scrapcomputers.errorHandler.assertArgument(duration, 2, {"number", "nil"})
            sm.scrapcomputers.errorHandler.assertArgument(player, 3, {"Player", "nil"})
            
            if not isUnsafeENV and player then
                error("Cannot use Player argument in safe-env!")
            end

            if player then
                self.network:sendToClient(player, "cl_alert", {message, duration})
            else
                self.network:sendToClients("cl_alert", {message, duration})
            end
        end,
        
        debug = function (...)
            print("[SC]: ", unpack({...}))
        end,

        ---@param seconds number
        sleep = function (seconds)
            sm.scrapcomputers.errorHandler.assertArgument(seconds, nil, {"number"})
            sm.scrapcomputers.errorHandler.assert(seconds <= 5, nil, "Too long to wait! (Max is 5 secconds!)")

            local endClock = tonumber(os.clock() + seconds)

            while os.clock() < endClock do end
        end,

        tostring = sm.scrapcomputers.toString,

        tonumber = tonumber,
        type = type,
        string = {
            byte = string.byte,
            char = string.char,
            find = string.find,
            format = string.format,
            gmatch = string.gmatch,
            gsub = string.gsub,
            len = string.len,
            lower = string.lower,
            match = string.match,
            rep = string.rep,
            reverse = string.reverse,
            sub = string.sub,
            upper = string.upper
        },
        table = {
            insert = table.insert,
            maxn = table.maxn,
            remove = table.remove,
            sort = table.sort,
            concat = table.concat
        },
        math = {
            abs = math.abs,
            acos = math.acos,
            asin = math.asin,
            atan = math.atan,
            atan2 = math.atan2,
            ceil = math.ceil,
            cos = math.cos,
            cosh = math.cosh,
            deg = math.deg,
            exp = math.exp,
            floor = math.floor,
            fmod = math.fmod,
            frexp = math.frexp,
            huge = math.huge,
            ldexp = math.ldexp,
            log = math.log,
            log10 = math.log10,
            max = math.max,
            min = math.min,
            modf = math.modf,
            pi = math.pi,
            pow = math.pow,
            rad = math.rad,
            random = math.random,
            sin = math.sin,
            sinh = math.sinh,
            sqrt = math.sqrt,
            tan = math.tan,
            tanh = math.tanh,
            pid = function(processValue, setValue, p, i, d, deltatime_i, deltatime_d)
                sm.scrapcomputers.backend.pid.processValue = processValue
                sm.scrapcomputers.backend.pid.setValue = setValue
                sm.scrapcomputers.backend.pid.p = p
                sm.scrapcomputers.backend.pid.i = i
                sm.scrapcomputers.backend.pid.d = d
                sm.scrapcomputers.backend.pid.deltatime_i = deltatime_i
                sm.scrapcomputers.backend.pid.deltatime_d = deltatime_d

                return sm.scrapcomputers.backend.pid.output
            end
        },
        bit = {
            tobit = bit.tobit,
            tohex = bit.tohex,
            bnot = bit.bnot,
            band = bit.band,
            bor = bit.bor,
            bxor = bit.bxor,
            lshift = bit.lshift,
            rshift = bit.rshift,
            arshift = bit.arshift,
            rol = bit.rol,
            ror = bit.ror,
            bswap = bit.bswap
        },
        os = {
            clock = os.clock,
            difftime = os.difftime,
            time = os.time
        },
        assert = assert,
        error = error,
        ipairs = ipairs,
        pairs = pairs,
        next = next,
        pcall = pcall,
        xpcall = xpcall,
        select = select,
        unpack = unpack,
        class = class,

        setmetatable = sm.scrapcomputers.util.setmetatable,
        getmetatable = sm.scrapcomputers.util.getmetatable,

        ---Loads a string and lets you execute it
        ---@param code string The code to execute
        ---@param env table The environment variables it can use
        ---@param bytecodeMode boolean? If it should execute bytecode or not. You must have unsafe env enabled to use bytecode!
        ---@return function?
        ---@return string?
        loadstring = function (code, env, bytecodeMode)
            sm.scrapcomputers.errorHandler.assertArgument(code, 1, {"string"})
            sm.scrapcomputers.errorHandler.assertArgument(env, 2, {"table"})
            sm.scrapcomputers.errorHandler.assertArgument(bytecodeMode, 3, {"boolean", "nil"})
            
            if bytecodeMode then
                local isUnsafeENV = sm.scrapcomputers.config.getConfig("scrapcomputers.computer.safe_or_unsafe_env").selectedOption == 2
                sm.scrapcomputers.errorHandler.assert(isUnsafeENV, nil, "Cannot execute bytecode in safe env!")

                return sm.scrapcomputers.luavm.bytecodeLoadstring(code, env)
            end

            return sm.scrapcomputers.luavm.loadstring(code, env)
        end,

        sc = {
            getDisplays = function () return sm.scrapcomputers.componentManager.getComponents("Displays", self.interactable, true) end,
            getDrives = function () return sm.scrapcomputers.componentManager.getComponents("Harddrives", self.interactable, true) end,
            getHolograms = function () return sm.scrapcomputers.componentManager.getComponents("Holograms", self.interactable, true) end,
            getTerminals = function () return sm.scrapcomputers.componentManager.getComponents("Terminals", self.interactable, true) end,
            getRadars = function () return sm.scrapcomputers.componentManager.getComponents("Radars", self.interactable, true) end,
            getNetworkPorts = function () return sm.scrapcomputers.componentManager.getComponents("NetworkPorts", self.interactable, true) end,
            getCameras = function () return sm.scrapcomputers.componentManager.getComponents("Cameras", self.interactable, true) end,
            getSpeakers = function () return sm.scrapcomputers.componentManager.getComponents("Speakers", self.interactable, true) end,
            getKeyboards = function () return sm.scrapcomputers.componentManager.getComponents("Keyboards", self.interactable, true) end,
            getMotors = function () return sm.scrapcomputers.componentManager.getComponents("Motors", self.interactable, true) end,
            getLasers = function () return sm.scrapcomputers.componentManager.getComponents("Lasers", self.interactable, true) end,
            getGPSs = function () return sm.scrapcomputers.componentManager.getComponents("GPSs", self.interactable, true) end,
            getSeatControllers = function () return sm.scrapcomputers.componentManager.getComponents("SeatControllers", self.interactable, false) end,
            getLights = function () return sm.scrapcomputers.componentManager.getComponents("Lights", self.interactable, true) end,
            getGravityControllers = function () return sm.scrapcomputers.componentManager.getComponents("GravityControllers", self.interactable, true) end,

            getReg = function (registerName)
                sm.scrapcomputers.errorHandler.assertArgument(registerName, nil, {"string"})

                local readers = sm.scrapcomputers.componentManager.getComponents("InputRegisters", self.interactable, false)

                for _, reader in pairs(readers) do
                    if reader.name == registerName then
                        return reader.power
                    end
                end

                error("Reader Register not found!")
            end,
            setReg = function (registerName, power)
                sm.scrapcomputers.errorHandler.assertArgument(registerName, 1, {"string"})
                sm.scrapcomputers.errorHandler.assertArgument(power, 2, {"number"})

                local writers = sm.scrapcomputers.componentManager.getComponents("OutputRegisters", self.interactable, true, nil, true)

                for _, writer in pairs(writers) do
                    if writer.name == registerName then
                        sm.event.sendToInteractable(writer.SC_PRIVATE_interactable, "sv_onRecievePowerUpdate", power)
                        return
                    end
                end

                error("Writer Register not found!")
            end,

            json = {
                isSafe = sm.scrapcomputers.json.isSafe,
                toString = function(root, prettify, indent) 
                    return sm.scrapcomputers.json.toString(root, true, prettify, indent) 
                end,

                toTable = function(root) 
                    return sm.scrapcomputers.json.toTable (root, true) 
                end,
            },
            font = {
                getDefaultFont = sm.scrapcomputers.fontManager.getDefaultFont,
                getDefaultFontName = sm.scrapcomputers.fontManager.getDefaultFontName,
                getFont = sm.scrapcomputers.fontManager.getFont,
                getFontNames = sm.scrapcomputers.fontManager.getFontNames,
            },

            ascfont = {
                applyDisplayFunctions = sm.scrapcomputers.ascfManager.applyDisplayFunctions,
                calcTextSize = sm.scrapcomputers.ascfManager.calcTextSize,
                drawText = sm.scrapcomputers.ascfManager.drawTextSafe,
                getFontInfo = function (fontName)
                    local font, errMsg = sm.scrapcomputers.ascfManager.getFontInfo(fontName)
                    if font then
                        return sm.scrapcomputers.table.clone(font), nil
                    end

                    return nil, errMsg
                end,
                getFontNames = sm.scrapcomputers.ascfManager.getFontNames
            },
            example = {
                getExamples = function ()
                    return sm.scrapcomputers.table.clone(sm.scrapcomputers.exampleManager.getExamples())
                end,
                
                getTotalExamples = sm.scrapcomputers.exampleManager.getTotalExamples,
            },
            language = {
                getLanguages = function ()
                    return sm.scrapcomputers.table.clone(sm.scrapcomputers.languageManager.getLanguages())
                end,
                
                getSelectedLanguage = sm.scrapcomputers.languageManager.getSelectedLanguage,
                getTotalLanguages = sm.scrapcomputers.languageManager.getTotalLanguages,
                translatable = sm.scrapcomputers.languageManager.translatable
            },
            syntax = sm.scrapcomputers.syntaxManager,

            -- DO NOT REMVOE CLONING! They prevent you from fucking up the mod from referenced tables!

            color          = sm.scrapcomputers.table.clone(sm.scrapcomputers.color),
            util           = sm.scrapcomputers.table.clone(sm.scrapcomputers.util),
            vec3           = sm.scrapcomputers.table.clone(sm.scrapcomputers.vector3),
            audio          = sm.scrapcomputers.table.clone(sm.scrapcomputers.audio),
            base64         = sm.scrapcomputers.table.clone(sm.scrapcomputers.base64),
            lz4            = sm.scrapcomputers.table.clone(sm.scrapcomputers.lz4),
            md5            = sm.scrapcomputers.table.clone(sm.scrapcomputers.md5),
            sha256         = sm.scrapcomputers.table.clone(sm.scrapcomputers.sha256),
            table          = sm.scrapcomputers.table.clone(sm.scrapcomputers.table),
            bitstream      = sm.scrapcomputers.table.clone(sm.scrapcomputers.bitstream),
            string         = sm.scrapcomputers.table.clone(sm.scrapcomputers.string),
            virtualdisplay = sm.scrapcomputers.table.clone(sm.scrapcomputers.virtualdisplay),
            multidisplay   = sm.scrapcomputers.table.clone(sm.scrapcomputers.multidisplay),
            midi           = sm.scrapcomputers.table.clone(sm.scrapcomputers.midi),
            nbs = {
                loadNBS = sm.scrapcomputers.nbs.loadNBS
            },
            
            config = {
                getConfigNames = function ()
                    local list = {}
                    for _, config in pairs(sm.scrapcomputers.config.configurations) do
                        table.insert(config.id)
                    end

                    return list
                end,

                getTotalConfigurations = sm.scrapcomputers.config.getTotalConfigurations,
                configExists = sm.scrapcomputers.config.configExists,
                nameToId = sm.scrapcomputers.config.nameToId,
                
                getConfig = function (id)
                    return sm.scrapcomputers.table.clone(sm.scrapcomputers.config.getConfig(id))
                end,

                getConfigByIndex = function (index)
                    return sm.scrapcomputers.table.clone(sm.scrapcomputers.config.getConfigByIndex(index))
                end
            },

            isUnsafeEnvEnabled = function ()
                return isUnsafeENV
            end
        },

        sm = {
            vec3 = sm.vec3,
            util = {
                axesToQuat = sm.util.axesToQuat,
                bezier2 = sm.util.bezier2,
                bezier3 = sm.util.bezier3,
                clamp = sm.util.clamp,
                easing = sm.util.easing,
                lerp = sm.util.lerp,
                positiveModulo = sm.scrapcomputers.util.positiveModulo,
                smootherstep = sm.util.smootherstep,
                smoothstep = sm.util.smoothstep,
            },
            quat = sm.quat,
            noise = sm.noise,
            color = sm.color,
            uuid = sm.uuid,
            json = {
                open = sm.json.open,
                
                parseJsonString = function(root) 
                    return sm.scrapcomputers.json.toTable(root, true) 
                end,

                writeJsonString = function(root) 
                    return sm.scrapcomputers.json.toString(root, true, false)
                end
            },

            projectile = {
                solveBallisticArc = sm.projectile.solveBallisticArc
            }
        },
    }

    environmentVariables._ENV = environmentVariables
    environmentVariables._G = environmentVariables

    if isUnsafeENV then
        environmentVariables._G = _G

        environmentVariables.self = self

        environmentVariables.sm = sm

        environmentVariables.string = string
        environmentVariables.table = table
        environmentVariables.math = math
        environmentVariables.math.pid = function(processValue, setValue, p, i, d, deltatime_i, deltatime_d)
            sm.scrapcomputers.backend.pid.processValue = processValue
            sm.scrapcomputers.backend.pid.setValue = setValue
            sm.scrapcomputers.backend.pid.p = p
            sm.scrapcomputers.backend.pid.i = i
            sm.scrapcomputers.backend.pid.d = d
            sm.scrapcomputers.backend.pid.deltatime_i = deltatime_i
            sm.scrapcomputers.backend.pid.deltatime_d = deltatime_d

            return sm.scrapcomputers.backend.pid.output
        end

        environmentVariables.bit = bit
        environmentVariables.os = os

        environmentVariables.sc.json = sm.scrapcomputers.json
        environmentVariables.sc.font = sm.scrapcomputers.fontManager
        environmentVariables.sc.ascfont = sm.scrapcomputers.ascfManager
        environmentVariables.sc.example = sm.scrapcomputers.exampleManager
        environmentVariables.sc.language = sm.scrapcomputers.languageManager
        environmentVariables.sc.config = sm.scrapcomputers.config
    end

    for _, environmentHook in pairs(sm.scrapcomputers.environmentManager.environmentHooks) do
        local contents = environmentHook(self)

        environmentVariables = sm.scrapcomputers.table.merge(environmentVariables, contents)
    end
    
    return environmentVariables
end