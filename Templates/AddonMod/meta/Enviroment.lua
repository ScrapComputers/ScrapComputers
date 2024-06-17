dofile("$CONTENT_DATA/Scripts/Config.lua")

sc.envManager = {}

---@param self ShapeClass
function sc.envManager.createEnv(self)
    local env = {
        print = function (...)
            local text = ""
            
            -- Loop through text and append it to text variable
            for _, data in ipairs({...}) do
                text = text.." "..sc.toString(data)
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
		tostring = sc.toString,
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
            getDisplays        = function () return sc.getObjects(sc.filters.dataType.Displays    , self.interactable, true ) end,
            getDrives          = function () return sc.getObjects(sc.filters.dataType.Harddrives  , self.interactable, true ) end,
            getHolograms       = function () return sc.getObjects(sc.filters.dataType.Holograms   , self.interactable, true ) end,
            getTerminals       = function () return sc.getObjects(sc.filters.dataType.Terminals   , self.interactable, true ) end,
            getRadars          = function () return sc.getObjects(sc.filters.dataType.Radars      , self.interactable, true ) end,
            getParentComputers = function () return sc.getObjects(sc.filters.dataType.Computers   , self.interactable, false) end,
            getChildComputers  = function () return sc.getObjects(sc.filters.dataType.Computers   , self.interactable, true ) end,
            getNetworkPorts    = function () return sc.getObjects(sc.filters.dataType.NetworkPorts, self.interactable, true ) end,
            getCameras         = function () return sc.getObjects(sc.filters.dataType.Cameras     , self.interactable, true ) end,
            getSpeakers        = function () return sc.getObjects(sc.filters.dataType.Speakers    , self.interactable, true ) end,
            getKeyboards       = function () return sc.getObjects(sc.filters.dataType.Keyboards   , self.interactable, true ) end,
            getMotors          = function () return sc.getObjects(sc.filters.dataType.Motors      , self.interactable, true ) end,
            getLasers          = function () return sc.getObjects(sc.filters.dataType.Lasers      , self.interactable, true ) end,
            getGPSs            = function () return sc.getObjects(sc.filters.dataType.GPSs        , self.interactable, true ) end,
            
            getReg = function (str)
                assert(type(str) == "string", "bad argument #1. Expected string. Got "..type(str).." instead.")

                local readers = sc.getObjects(sc.filters.dataType.Readers, self.interactable, false)
                for i, reader in pairs(readers) do
                    if reader.name == str then
                        return reader.power
                    end
                end

                error("Register not found!")
            end,
            
            setReg = function (str, power)
                assert(type(str) == "string", "bad argument #1. Expected string. Got "..type(str).." instead.")
                assert(type(power) == "number", "bad argument #2. Expected number. Got "..type(power).." instead.")

                local writers = sc.getObjects(sc.filters.dataType.Writers, self.interactable, true, nil, true)

                for _, writer in pairs(writers) do
                    if writer.name == str then
                        sm.event.sendToInteractable(sc.dataList["WriterInters"][writer.SC_PRIVATE_id], "sv_onRecievePowerUpdate", power)
                        return
                    end
                end

                error("Register not found!")
            end,

            json = {
                isSafe = sc.json.isSafe,
                toString = function (root, prettify, indent) return sc.json.toString(root, true, prettify, indent) end,
                toTable  = function (root                  ) return sc.json.toTable (root, true                  ) end
            },
            color = {
                newSingluar = sc.color.newSingluar,
                random = sc.color.random,
                random0to1 = sc.color.random0to1
            },
            util = {
                positiveModulo = sc.util.postiveModulo
            },
            vec3 = {
                add = sc.vec3.add,
                distance = sc.vec3.distance,
                divide = sc.vec3.divide,
                mulitply = sc.vec3.mulitply,
                newSingluar = sc.vec3.newSingluar,
                subtract = sc.vec3.subtract
            },
            audio = {
                areParamsCorrect = sc.audio.areParamsCorrect,
                exists = sc.audio.exists,
                getAudioNames = sc.audio.getAudioNames,
                getParams = sc.audio.getParams
            },
            base64 = {
                encode = sc.base64.encode,
                decode = sc.base64.decode
            },
            md5 = {
                new = sc.md5.new,
                sum = sc.md5.sum,
                sumhexa = sc.md5.sumhexa,
                tohex = sc.md5.tohex
            },
            sha256 = {
                encode = sc.sha256.encode
            },
            table = {
                clone = sc.table.clone,
                getItemAt = sc.table.getItemAt,
                getTotalItems = sc.table.getTotalItems,
                getTotalItemsDict = sc.table.getTotalItemsDict,
                merge = sc.table.merge,
                toString = sc.table.toString
            },
            math = {
                clamp = sc.math.clamp
            },
            fontmanager = {
                getDefaultFont = sc.fontmanager.getDefaultFont,
                getDefaultFontName = sc.fontmanager.getDefaultFontName,
                getFont = sc.fontmanager.getFont,
                getFontNames = sc.fontmanager.getFontNames
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
                positiveModulo = sc.util.postiveModulo,
                smootherstep = sm.util.smootherstep,
                smoothstep = sm.util.smoothstep,
            },
            quat = sm.quat,
            noise = sm.noise,
            color = sm.color,
            json = {
                parseJsonString = function (str ) return sc.json.toTable (str , true       ) end,
                writeJsonString = function (root) return sc.json.toString(root, true, false) end
            }
        },
    }

    -- Safe version of the if statement on next section
    env._ENV = env
    env._G = env

    -- Check if it s unsafe env mode. If so then allow all unsafe stuff.
    if sc.config.configurations[1].selectedOption == 2 then
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

    return sc.table.merge(env, sc.additionalEnv)
end