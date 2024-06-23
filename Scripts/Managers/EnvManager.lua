sm.scrapcomputers.envManager = {}
sm.scrapcomputers.envManager.envHooks = {}

---@param self ShapeClass
function sm.scrapcomputers.envManager.createEnv(self)
    local env = {
        print = function (...)
            local text = ""
            
            -- Loop through text and append it to text variable
            for _, data in ipairs({...}) do
                text = text.." "..sm.scrapcomputers.toString(data)
            end

            -- Create the format and send it to the clients
            local format = text:gsub("⁄n", "\n"):gsub("⁄t", "\t"):sub(2)
            self.network:sendToClients("cl_chatMessage", "[#3A96DDS#3b78ffC#eeeeee]: "..format)
        end,
        alert = function(string, duration)
            assert(type(string) == "string", "bad argument #1, string expected. Got "..type(string).." instead")

            if duration then
                assert(type(duration) == "number", "bad argument #2, number expected. Got "..type(duration).." instead")
            end 

            self.network:sendToClients("cl_alert", {string, duration})
        end,
		debug = function (...)
            -- Print it out.
            print("[SC]: ", unpack({...}))
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
		math =  {
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
            tanh = math.tanh
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

        sc = {
            -- All getComponent functions for all components in ScrapComputers
            getDisplays        = function () return sm.scrapcomputers.components.getComponents(sm.scrapcomputers.filters.dataType.Displays       , self.interactable, true ) end,
            getDrives          = function () return sm.scrapcomputers.components.getComponents(sm.scrapcomputers.filters.dataType.Harddrives     , self.interactable, true ) end,
            getHolograms       = function () return sm.scrapcomputers.components.getComponents(sm.scrapcomputers.filters.dataType.Holograms      , self.interactable, true ) end,
            getTerminals       = function () return sm.scrapcomputers.components.getComponents(sm.scrapcomputers.filters.dataType.Terminals      , self.interactable, true ) end,
            getRadars          = function () return sm.scrapcomputers.components.getComponents(sm.scrapcomputers.filters.dataType.Radars         , self.interactable, true ) end,
            getNetworkPorts    = function () return sm.scrapcomputers.components.getComponents(sm.scrapcomputers.filters.dataType.NetworkPorts   , self.interactable, true ) end,
            getCameras         = function () return sm.scrapcomputers.components.getComponents(sm.scrapcomputers.filters.dataType.Cameras        , self.interactable, true ) end,
            getSpeakers        = function () return sm.scrapcomputers.components.getComponents(sm.scrapcomputers.filters.dataType.Speakers       , self.interactable, true ) end,
            getKeyboards       = function () return sm.scrapcomputers.components.getComponents(sm.scrapcomputers.filters.dataType.Keyboards      , self.interactable, true ) end,
            getMotors          = function () return sm.scrapcomputers.components.getComponents(sm.scrapcomputers.filters.dataType.Motors         , self.interactable, true ) end,
            getLasers          = function () return sm.scrapcomputers.components.getComponents(sm.scrapcomputers.filters.dataType.Lasers         , self.interactable, true ) end,
            getGPSs            = function () return sm.scrapcomputers.components.getComponents(sm.scrapcomputers.filters.dataType.GPSs           , self.interactable, true ) end,
            getSeatControllers = function () return sm.scrapcomputers.components.getComponents(sm.scrapcomputers.filters.dataType.SeatControllers, self.interactable, false ) end,
            
            getReg = function (str)
                assert(type(str) == "string", "bad argument #1. Expected string. Got "..type(str).." instead!")

                local readers = sm.scrapcomputers.components.getComponents(sm.scrapcomputers.filters.dataType.Readers, self.interactable, false)
                for i, reader in pairs(readers) do
                    if reader.name == str then
                        return reader.power
                    end
                end

                error("Register not found!")
            end,
            
            setReg = function (str, power)
                assert(type(str) == "string", "bad argument #1. Expected string. Got "..type(str).." instead!")
                assert(type(power) == "number", "bad argument #2. Expected number. Got "..type(power).." instead!")

                local writers = sm.scrapcomputers.components.getComponents(sm.scrapcomputers.filters.dataType.Writers, self.interactable, true, nil, true)

                for _, writer in pairs(writers) do
                    if writer.name == str then
                        sm.event.sendToInteractable(sm.scrapcomputers.dataList["WriterInters"][writer.SC_PRIVATE_id], "sv_onRecievePowerUpdate", power)
                        return
                    end
                end

                error("Register not found!")
            end,

            json = {
                isSafe = sm.scrapcomputers.json.isSafe,
                toString = function (root, prettify, indent) return sm.scrapcomputers.json.toString(root, true, prettify, indent) end,
                toTable  = function (root                  ) return sm.scrapcomputers.json.toTable (root, true                  ) end
            },
            color = {
                newSingluar = sm.scrapcomputers.color.newSingluar,
                random = sm.scrapcomputers.color.random,
                random0to1 = sm.scrapcomputers.color.random0to1
            },
            util = {
                positiveModulo = sm.scrapcomputers.util.postiveModulo
            },
            vec3 = {
                add = sm.scrapcomputers.vec3.add,
                distance = sm.scrapcomputers.vec3.distance,
                divide = sm.scrapcomputers.vec3.divide,
                mulitply = sm.scrapcomputers.vec3.mulitply,
                newSingluar = sm.scrapcomputers.vec3.newSingluar,
                subtract = sm.scrapcomputers.vec3.subtract
            },
            audio = {
                areParamsCorrect = sm.scrapcomputers.audio.areParamsCorrect,
                exists = sm.scrapcomputers.audio.exists,
                getAudioNames = sm.scrapcomputers.audio.getAudioNames,
                getParams = sm.scrapcomputers.audio.getParams
            },
            base64 = {
                encode = sm.scrapcomputers.base64.encode,
                decode = sm.scrapcomputers.base64.decode
            },
            md5 = {
                new = sm.scrapcomputers.md5.new,
                sum = sm.scrapcomputers.md5.sum,
                sumhexa = sm.scrapcomputers.md5.sumhexa,
                tohex = sm.scrapcomputers.md5.tohex
            },
            sha256 = {
                encode = sm.scrapcomputers.sha256.encode
            },
            table = {
                clone = sm.scrapcomputers.table.clone,
                getItemAt = sm.scrapcomputers.table.getItemAt,
                getTotalItems = sm.scrapcomputers.table.getTotalItems,
                getTotalItemsDict = sm.scrapcomputers.table.getTotalItemsDict,
                isDictonary = sm.scrapcomputers.table.isDictonary,
                itemExistsInList = sm.scrapcomputers.table.itemExistsInList,
                merge = sm.scrapcomputers.table.merge,
                numberlyOrderTable = sm.scrapcomputers.table.numberlyOrderTable,
                shiftTableIndexes = sm.scrapcomputers.table.shiftTableIndexes,
                toString = sm.scrapcomputers.table.toString
            },
            math = {
                clamp = sm.scrapcomputers.math.clamp
            },
            fontmanager = {
                getDefaultFont = sm.scrapcomputers.fontmanager.getDefaultFont,
                getDefaultFontName = sm.scrapcomputers.fontmanager.getDefaultFontName,
                getFont = sm.scrapcomputers.fontmanager.getFont,
                getFontNames = sm.scrapcomputers.fontmanager.getFontNames
            },
            bitstream = {
                new = sm.scrapcomputers.BitStream.new
            },
            vpbs = {
                isVPBSstring = sm.scrapcomputers.VPBS.isVPBSstring,
                tostring = sm.scrapcomputers.VPBS.tostring,
                totable = sm.scrapcomputers.VPBS.totable
            }
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
                positiveModulo = sm.scrapcomputers.util.postiveModulo,
                smootherstep = sm.util.smootherstep,
                smoothstep = sm.util.smoothstep,
            },
            quat = sm.quat,
            noise = sm.noise,
            color = sm.color,
            json = {
                parseJsonString = function (str ) return sm.scrapcomputers.json.toTable (str , true       ) end,
                writeJsonString = function (root) return sm.scrapcomputers.json.toString(root, true, false) end
            }
        },
    }

    -- Safe version of the if statement on next section
    env._ENV = env
    env._G = env

    -- Load config if not found
    if not sm.scrapcomputers.config.getConfig then
        sm.scrapcomputers.config.initConfig()
    end

    -- Check if it s unsafe env mode. If so then allow all unsafe stuff.
    if sm.scrapcomputers.config.getConfig("scrapcomputers.computer.safe_or_unsafe_env").selectedOption == 2 then
        env._G = _G
        env.self = self
        env.sm = sm

        -- Since its unsafe. make it so that it can use stuff from dll mods incase it changes that table.
        env.string = string
        env.table = table
        env.math = math
        env.bit = bit
        env.os = os
    end

    for _, envHook in pairs(sm.scrapcomputers.envManager.envHooks) do
        local contents = envHook(self)
        
        env = sm.scrapcomputers.table.merge(env, contents)
    end

    return env
end