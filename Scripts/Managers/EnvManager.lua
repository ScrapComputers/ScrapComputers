--- Manages the enviroment variables for the Computer!
sm.scrapcomputers.enviromentManager = {}

-- Lets you hook the EnviromentManager so you can add your own ENV to it!
---@type function[]
sm.scrapcomputers.enviromentManager.enviromentHooks = {}

---Creates a enviroment variables table and returns it
---@param self ShapeClass This should be the "self" keyword. A.K.A your class
---@return table enviromentVariables The created enviroment variables.
function sm.scrapcomputers.enviromentManager.createEnv(self)
    sm.scrapcomputers.errorHandler.assertArgument(self, nil, {"table"}, {"ShapeClass"})
    
    local enviromentVariables = {
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
        alert = function(message, duration)
            duration = duration or 5

            sm.scrapcomputers.errorHandler.assertArgument(message, 1, {"string"})
            sm.scrapcomputers.errorHandler.assertArgument(duration, 2, {"number", "nil"})
            
            self.network:sendToClients("cl_alert", {message, duration})
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
            randomseed = math.randomseed
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

        ---Loads a string and lets you execute it
        ---@param code string The code to execute
        ---@param env table The enviroment variables it can use
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

            fontmanager = {
                getDefaultFont = sm.scrapcomputers.fontManager.getDefaultFont,
                getDefaultFontName = sm.scrapcomputers.fontManager.getDefaultFontName,
                getFont = sm.scrapcomputers.fontManager.getFont,
                getFontNames = sm.scrapcomputers.fontManager.getFontNames,
            },

            color = sm.scrapcomputers.color,
            util = sm.scrapcomputers.util,
            vec3 = sm.scrapcomputers.vec3,
            audio = sm.scrapcomputers.audio,
            base64 = sm.scrapcomputers.base64,
            md5 = sm.scrapcomputers.md5,
            sha256 = sm.scrapcomputers.sha256,
            table = sm.scrapcomputers.table,
            bitStream = sm.scrapcomputers.BitStream,
            vpbs = sm.scrapcomputers.VPBS,
            string = sm.scrapcomputers.string,
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
                parseJsonString = function(root) 
                    return sm.scrapcomputers.json.toTable(root, true) 
                end,

                writeJsonString = function(root) 
                    return sm.scrapcomputers.json.toString(root, true, false) 
                end
            }
        },
    }

    enviromentVariables._ENV = enviromentVariables
    enviromentVariables._G = enviromentVariables

    if not sm.scrapcomputers.config.getConfig then
        sm.scrapcomputers.config.initConfig()
    end

    if sm.scrapcomputers.config.getConfig("scrapcomputers.computer.safe_or_unsafe_env").selectedOption == 2 then
        enviromentVariables._G = _G

        enviromentVariables.self = {
            colorHighlight = self.colorHighlight,
            colorNormal = self.colorNormal,
            connectionInput = self.connectionInput,
            connectionOutput = self.connectionOutput,
            data = self.data,
            interactable = self.interactable,
            maxChildCount = self.maxChildCount,
            maxParentCount = self.maxParentCount,
            network = self.network,
            params = self.params,
            poseWeightCount = self.poseWeightCount,
            shape = self.shape,
            storage = self.storage,
        }

        enviromentVariables.sm = sm

        enviromentVariables.string = string
        enviromentVariables.table = table
        enviromentVariables.math = math
        enviromentVariables.bit = bit
        enviromentVariables.os = os

        enviromentVariables.sc.json = sm.scrapcomputers.json
        enviromentVariables.sc.fontmanager = sm.scrapcomputers.fontManager
    end

    for _, enviromentHook in pairs(sm.scrapcomputers.enviromentManager.enviromentHooks) do
        local contents = enviromentHook(self)

        enviromentVariables = sm.scrapcomputers.table.merge(enviromentVariables, contents)
    end

    return enviromentVariables
end