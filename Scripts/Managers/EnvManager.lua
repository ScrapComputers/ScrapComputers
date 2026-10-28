--- Manages the environment variables for the Computer!
sm.scrapcomputers.environmentManager = {}

-- Lets you hook the environmentManager so you can add your own ENV to it!
---@type function[]
sm.scrapcomputers.environmentManager.environmentHooks = {}

---Creates a environment variables table and returns it
---@param self ShapeClass This should be the "self" keyword. A.K.A your class
---@param luaVM Computer.LuaVM? The Lua virtual machine
---@return table environmentVariables The created environment variables.
function sm.scrapcomputers.environmentManager.createEnv(self, luaVM)
    sm.scrapcomputers.errorHandler.assertArgument(self, 1, {"table"}, {"ShapeClass"})
    sm.scrapcomputers.errorHandler.assertArgument(luaVM, 2, {"table", "nil"}, {"Computer.LuaVM"})

    if not sm.scrapcomputers.config.getConfig then
        sm.scrapcomputers.config.initConfig()
    end

    local isUnsafeENV = sm.scrapcomputers.config.getConfig("scrapcomputers.computer.safe_or_unsafe_env").selectedOption == 2

    local function createpid(processID)
        sm.scrapcomputers.PIDHandler.createProcess(processID)
    end

    local function removepid(processID)
        sm.scrapcomputers.PIDHandler.removeProcess(processID)
    end

    local function pid(processID, processValue, setValue, p, i, d, deltatime_i, deltatime_d)
        sm.scrapcomputers.PIDHandler.setProcess(processID, processValue, setValue, p, i, d, deltatime_i, deltatime_d)

        local pidData = sm.scrapcomputers.PIDHandler.getProcess(processID)
        return pidData.PIDOut
    end

    local environmentVariables = {
        print = function (...)
            local n = select("#", ...)
            local parts = {}

            for i = 1, n do
                table.insert(parts, sm.scrapcomputers.toString(select(i, ...)))
            end

            local message = table.concat(parts, " ")
            message = message:gsub("\\n", "\n"):gsub("\\t", "\t")

            self.network:sendToClients("cl_chatMessage", "[#3A96DDS#3b78ffC#eeeeee]: " .. message)
        end,

        debug = function(...)
            print("[SC]:", ...)
        end,

        tostring = sm.scrapcomputers.toString,

        tonumber = tonumber,
        type = type,
        enumType = enumType,
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
            pid = pid,
            createpid = createpid,
            removepid = removepid
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

        setmetatable = sm.scrapcomputers.metatable.setmetatable,
        getmetatable = sm.scrapcomputers.metatable.getmetatable,

        rawget = sm.scrapcomputers.metatable.rawget,
        rawset = sm.scrapcomputers.metatable.rawset,
        rawlen = sm.scrapcomputers.metatable.rawlen,
        rawequal = sm.scrapcomputers.metatable.rawequal,

        ---Loads a string and lets you execute it
        ---@param code string The code to execute
        ---@param env table The environment variables it can use
        ---@param bytecodeMode boolean? If it should execute bytecode or not.
        ---@return function?
        ---@return string?
        loadstring = function (code, env, bytecodeMode)
            sm.scrapcomputers.errorHandler.assertArgument(code, 1, {"string"})
            sm.scrapcomputers.errorHandler.assertArgument(env, 2, {"table"})
            sm.scrapcomputers.errorHandler.assertArgument(bytecodeMode, 3, {"boolean", "nil"})

            sm.scrapcomputers.errorHandler.assert(luaVM, nil, "This enviroment has no assigned LuaVM, cannot execute code!")

            if bytecodeMode then
                return luaVM:loadstringBytecode(code, env)
            end

            return luaVM:loadstring(code, env, "@input", true)
        end,

        sc = {
            getDisplays = function () return sm.scrapcomputers.componentManager.getComponentsSimplified("Displays", self.interactable) end,
            getDrives = function () return sm.scrapcomputers.componentManager.getComponentsSimplified("Harddrives", self.interactable) end,
            getHolograms = function () return sm.scrapcomputers.componentManager.getComponentsSimplified("Holograms", self.interactable) end,
            getTerminals = function () return sm.scrapcomputers.componentManager.getComponentsSimplified("Terminals", self.interactable) end,
            getRadars = function () return sm.scrapcomputers.componentManager.getComponentsSimplified("Radars", self.interactable) end,
            getNetworkPorts = function () return sm.scrapcomputers.componentManager.getComponentsSimplified("NetworkPorts", self.interactable) end,
            getCameras = function () return sm.scrapcomputers.componentManager.getComponentsSimplified("Cameras", self.interactable) end,
            getSpeakers = function () return sm.scrapcomputers.componentManager.getComponentsSimplified("Speakers", self.interactable) end,
            getKeyboards = function () return sm.scrapcomputers.componentManager.getComponentsSimplified("Keyboards", self.interactable) end,
            getMotors = function () return sm.scrapcomputers.componentManager.getComponentsSimplified("Motors", self.interactable) end,
            getLasers = function () return sm.scrapcomputers.componentManager.getComponentsSimplified("Lasers", self.interactable) end,
            getGPSs = function () return sm.scrapcomputers.componentManager.getComponentsSimplified("GPSs", self.interactable) end,
            getSeatControllers = function () return sm.scrapcomputers.componentManager.getComponentsSimplified("SeatControllers", self.interactable) end,
            getLights = function () return sm.scrapcomputers.componentManager.getComponentsSimplified("Lights", self.interactable) end,
            getGravityControllers = function () return sm.scrapcomputers.componentManager.getComponentsSimplified("GravityControllers", self.interactable) end,
            getRadarWarningReceivers = function () return sm.scrapcomputers.componentManager.getComponentsSimplified("RadarWarningReceivers", self.interactable) end,
            getCollisionDetectors = function () return sm.scrapcomputers.componentManager.getComponentsSimplified("CollisionDetectors", self.interactable) end,
            getPowerSources = function () return sm.scrapcomputers.componentManager.getComponentsSimplified("PowerComponents", self.interactable) end,

            getComponents = function (componentType)
                sm.scrapcomputers.errorHandler.assertArgument(componentType, 1, {"string"})
                sm.scrapcomputers.errorHandler.assert(sm.scrapcomputers.componentManager.isComponentTypeAvaliable(componentType), nil, "Component type '" .. componentType .. "' is not available!")

                return sm.scrapcomputers.componentManager.getComponentsSimplified(componentType, self.interactable)
            end,

            getAllComponents = function ()
                local output = {}
                for _, componentType in pairs(sm.scrapcomputers.componentManager.getRegisteredComponentTypes()) do
                    if not sm.scrapcomputers.componentManager.isComponentTypeAvaliable(componentType) then
                        goto continue
                    end
                    
                    do
                        local data = {}

                        local components = sm.scrapcomputers.componentManager.getComponentsSimplified(componentType, self.interactable)
                        for _, component in pairs(components) do
                            table.insert(data, component)
                        end

                        output[componentType] = data
                    end

                    ::continue::
                end

                return output
            end,

            getReg = function (registerName)
                sm.scrapcomputers.errorHandler.assertArgument(registerName, nil, {"string"})

                local readers = sm.scrapcomputers.componentManager.getComponentsSimplified("InputRegisters", self.interactable, true)

                for _, reader in pairs(readers) do
                    if reader.name == registerName then
                        return reader.power
                    end
                end

                error("Input Register not found!")
            end,

            setReg = function (registerName, power)
                sm.scrapcomputers.errorHandler.assertArgument(registerName, 1, {"string"})
                sm.scrapcomputers.errorHandler.assertArgument(power, 2, {"number", "boolean"})

                if type(power) == "boolean" then
                    power = power and 1 or 0
                end
                
                local writers = sm.scrapcomputers.componentManager.getComponentsSimplified("OutputRegisters", self.interactable, true)

                for _, writer in pairs(writers) do
                    if writer.name == registerName then
                        sm.event.sendToInteractable(writer.SC_PRIVATE_interactable, "sv_onReceivePowerUpdate", power, sm.event.types.instant)
                        return
                    end
                end

                error("Output Register not found!")
            end,

            json = {
                isSafe = sm.scrapcomputers.json.isSafe,
                toString = function(root, prettify, indent)
                    return sm.scrapcomputers.json.toString(root, true, prettify, indent)
                end,

                toTable = sm.json.parseJsonString, -- Backwards Compatability
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
            syntax = sm.scrapcomputers.table.clone(sm.scrapcomputers.syntax),

            -- DO NOT REMVOE CLONING! They prevent you from fucking up the mod from referenced tables!

            color          = sm.scrapcomputers.table.clone(sm.scrapcomputers.color),
            util           = sm.scrapcomputers.table.clone(sm.scrapcomputers.util),
            utf8           = sm.scrapcomputers.table.clone(sm.scrapcomputers.utf8),
            vec3           = sm.scrapcomputers.table.clone(sm.scrapcomputers.vector3),
            vec2           = sm.scrapcomputers.table.clone(sm.scrapcomputers.vector2),
            audio          = sm.scrapcomputers.table.clone(sm.scrapcomputers.audio),
            base64         = sm.scrapcomputers.table.clone(sm.scrapcomputers.base64),
            base91         = sm.scrapcomputers.table.clone(sm.scrapcomputers.base91),
            lz4            = sm.scrapcomputers.table.clone(sm.scrapcomputers.lz4),
            md5            = sm.scrapcomputers.table.clone(sm.scrapcomputers.md5),
            sha256         = sm.scrapcomputers.table.clone(sm.scrapcomputers.sha256),
            table          = sm.scrapcomputers.table.clone(sm.scrapcomputers.table),
            bitstream      = sm.scrapcomputers.table.clone(sm.scrapcomputers.bitstream),
            string         = sm.scrapcomputers.table.clone(sm.scrapcomputers.string),
            virtualdisplay = sm.scrapcomputers.table.clone(sm.scrapcomputers.virtualdisplay),
            multidisplay   = sm.scrapcomputers.table.clone(sm.scrapcomputers.multidisplay),
            midi           = sm.scrapcomputers.table.clone(sm.scrapcomputers.midi),
            aes256         = sm.scrapcomputers.table.clone(sm.scrapcomputers.aes256),
            time           = sm.scrapcomputers.table.clone(sm.scrapcomputers.time),
            qrcode         = sm.scrapcomputers.table.clone(sm.scrapcomputers.qrcode),

            nbs = {
                loadNBS = sm.scrapcomputers.nbs.loadNBS,
                createPlayer = sm.scrapcomputers.nbs.createPlayer
            },

            config = {
                getConfigNames = function ()
                    local list = {}
                    for _, config in pairs(sm.scrapcomputers.config.configurations) do
                        table.insert(list, config.id)
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

            power = {
                getConsumtion = function ()
                    return self.sv and (self.sv.totalPPTNeeded or 0) or 0
                end,

                getReceivingPower = function ()
                    return self.sv and (self.sv.receivingPower or 0) or 0
                end
            },

            component = {
                getAvaliableComponentTypes = sm.scrapcomputers.componentManager.getRegisteredComponentTypes,
            },

            isUnsafeEnvEnabled = function ()
                return isUnsafeENV
            end
        },

        sm = {
            version = sm.version,            
            types = sm.scrapcomputers.table.clone(sm.scrapcomputers.types),
            vec3 = sm.scrapcomputers.table.clone(sm.vec3),
            util = {
                easingFunctionIds = sm.scrapcomputers.table.clone(sm.util.easingFunctionIds),
                axesToQuat = sm.util.axesToQuat,
                bezier2 = sm.util.bezier2,
                bezier3 = sm.util.bezier3,
                clamp = sm.util.clamp,
                clampUtf8String = sm.util.clampUtf8String,
                easing = sm.util.easing,
                geometricMedian = sm.util.geometricMedian,
                hash = sm.util.hash,
                lerp = sm.util.lerp,
                positiveModulo = sm.scrapcomputers.util.positiveModulo,
                smootherstep = sm.util.smootherstep,
                smoothstep = sm.util.smoothstep,
            },
            quat = sm.scrapcomputers.table.clone(sm.quat),
            noise = sm.scrapcomputers.table.clone(sm.noise),
            color = sm.scrapcomputers.table.clone(sm.color),
            uuid = sm.scrapcomputers.table.clone(sm.uuid),
            item = {
                getBuoyancyRating = sm.item.getBuoyancyRating,
                getCharacterShape = sm.item.getCharacterShape,
                getDensityRating = sm.item.getDensityRating,
                getDurabilityRating = sm.item.getDurabilityRating,
                getEdible = sm.item.getEdible,
                getFeatureData = sm.item.getFeatureData,
                getFrictionRating = sm.item.getFrictionRating,
                getMaterial = sm.item.getMaterial,
                getMaterialId = sm.item.getMaterialId,
                getPlantable = sm.item.getPlantable,
                getQualityLevel = sm.item.getQualityLevel,
                getShapeDefaultColor = sm.item.getShapeDefaultColor,
                getShapeOffset = sm.item.getShapeOffset,
                getShapeRotation = sm.item.getShapeRotation,
                getShapeSize = sm.item.getShapeSize,
                getStackSize = sm.item.getStackSize,
                isBlock = sm.item.isBlock,
                isFlammable = sm.item.isFlammable,
                isHarvestablePart = sm.item.isHarvestablePart,
                isJoint = sm.item.isJoint,
                isPart = sm.item.isPart,
                isTool = sm.item.isTool,
                isMultiShape = sm.item.isMultiShape,
            },
            game = {
                getDifficulty = sm.game.getDifficulty,
                getEnableAggro = sm.game.getEnableAggro,
                getEnableAmmoConsumption = sm.game.getEnableAmmoConsumption,
                getEnableFuelConsumption = sm.game.getEnableFuelConsumption,
                getLimitedInventory = sm.game.getLimitedInventory,
                getRecipesEnabled = sm.game.getRecipesEnabled,
                getTick = sm.game.getServerTick,
                getTimeOfDay = sm.game.getTimeOfDay,
            },
            json = {
                open = function (path)
                    return sm.json.open(path, false)
                end,

                parseJsonString = sm.json.parseJsonString,
                writeJsonString = function(root, prettified)
                    sm.scrapcomputers.errorHandler.assertArgument(root, 1, {"table", "string", "number", "boolean", "nil"})
                    sm.scrapcomputers.errorHandler.assertArgument(prettified, 2, {"boolean", "nil"})
                    
                    assert(sm.scrapcomputers.json.isSafe(root), "Cannot write unsafe json data!")

                    return sm.json.writeJsonString(root, prettified)
                end
            },
            projectile = {
                solveBallisticArc = sm.projectile.solveBallisticArc
            },
            physics = {
                filter = sm.scrapcomputers.table.clone(sm.physics.filter)
            }
        },
    }

    environmentVariables.sleep = function (...)
        environmentVariables.sc.console.warn("sleep() is deprecated and will be removed in future updates.")
    end

    environmentVariables.alert = function (...)
        environmentVariables.sc.console.warn("alert() is deprecated and will be removed in future updates.")
    end

    environmentVariables._ENV = environmentVariables
    environmentVariables._G = environmentVariables

    if isUnsafeENV then
        environmentVariables._G = _G

        environmentVariables.self = self

        environmentVariables.sm = sm

        environmentVariables.string = string
        environmentVariables.table = table
        environmentVariables.math = math
        environmentVariables.math.pid = pid
        environmentVariables.math.createpid = createpid
        environmentVariables.math.removepid = removepid

        environmentVariables.bit = bit
        environmentVariables.os = os
    end

    local function fastMerge(dest, src)
        for key, value in pairs(src) do
            if dest[key] == nil then
                dest[key] = value
            else
                if type(dest[key]) == "table" and type(value) == "table" then
                    fastMerge(dest[key], value)
                end
            end
        end

        return dest
    end

    for _, environmentHook in pairs(sm.scrapcomputers.environmentManager.environmentHooks) do
        environmentVariables = fastMerge(environmentVariables, environmentHook(self))
    end

    return environmentVariables
end