--- ScrapComputers Syntax Highlighting File (This is called a Definition File)
--- This is used so you can have some syntax highlighting making coding easier!
--- 
--- We disable diagnostics because we don't need them here!
---@diagnostic disable

------------------------------------------------------------------------------------------------------------------------------
---  ██████╗ ██████╗ ███████╗    ██████╗ ███████╗███████╗██╗███╗   ██╗███████╗██████╗                                      ---
---  ██╔══██╗██╔══██╗██╔════╝    ██╔══██╗██╔════╝██╔════╝██║████╗  ██║██╔════╝██╔══██╗                                     ---
---  ██████╔╝██████╔╝█████╗█████╗██║  ██║█████╗  █████╗  ██║██╔██╗ ██║█████╗  ██║  ██║                                     ---
---  ██╔═══╝ ██╔══██╗██╔══╝╚════╝██║  ██║██╔══╝  ██╔══╝  ██║██║╚██╗██║██╔══╝  ██║  ██║                                     ---
---  ██║     ██║  ██║███████╗    ██████╔╝███████╗██║     ██║██║ ╚████║███████╗██████╔╝                                     ---
---  ╚═╝     ╚═╝  ╚═╝╚══════╝    ╚═════╝ ╚══════╝╚═╝     ╚═╝╚═╝  ╚═══╝╚══════╝╚═════╝                                      ---
---                                                                                                                        ---
---  ███████╗███████╗██╗██╗     ██████╗ ███████╗       ██╗        ██████╗██╗      █████╗ ███████╗███████╗███████╗███████╗  ---
---  ██╔════╝██╔════╝██║██║     ██╔══██╗██╔════╝       ██║       ██╔════╝██║     ██╔══██╗██╔════╝██╔════╝██╔════╝██╔════╝  ---
---  █████╗  █████╗  ██║██║     ██║  ██║███████╗    ████████╗    ██║     ██║     ███████║███████╗███████╗█████╗  ███████╗  ---
---  ██╔══╝  ██╔══╝  ██║██║     ██║  ██║╚════██║    ██╔═██╔═╝    ██║     ██║     ██╔══██║╚════██║╚════██║██╔══╝  ╚════██║  ---
---  ██║     ███████╗██║███████╗██████╔╝███████║    ██████║      ╚██████╗███████╗██║  ██║███████║███████║███████╗███████║  ---
---  ╚═╝     ╚══════╝╚═╝╚══════╝╚═════╝ ╚══════╝    ╚═════╝       ╚═════╝╚══════╝╚═╝  ╚═╝╚══════╝╚══════╝╚══════╝╚══════╝  ---
---                                                                                                                        ---
------------------------------------------------------------------------------------------------------------------------------

-- DISPLAY --

---@class TouchData This contains touch data when the user interacts with the display, also known as "touches the display."
---@field x integer The position on the x-axis
---@field y integer The position on the y-axis
---@field state integer The state of the touch: 1 for Pressed, 2 for Hold, 3 for Released.

---@class PixelTableField An instruction for a pixel table.
---@field x number The x-coordinate (floored)
---@field y number The y-coordinate (floored)
---@field color Color The color of the pixel

---@alias PixelTable PixelTableField[] Pixel tables contain pixel information used to draw on the display, similar to instructions.
---@alias MultiColorType Color|string? A Color, string, or nil.
---@alias MultiColorTypeNonNil Color|string A Color or string (cannot be nil).

-- GPS --

---@class GPSData Data received from a GPS
---@field worldPosition Vec3 The current world position
---@field worldRotation Quat The current world rotation
---@field bearing number The world position's bearing rotation
---@field velocity Vec3 The current velocity
---@field speed number The current speed (magnitude of velocity)
---@field forwardVelocity number The forward velocity
---@field horizontalVelocity number The horizontal velocity
---@field verticalVelocity number The vertical velocity
---@field angularVelocity Vec3 The angular velocity
---@field rpm number The current RPM (depends on angular velocity)
---@field acceleration number The current acceleration
---@field forwardAcceleration number The forward acceleration
---@field horizontalAcceleration number The horizontal acceleration
---@field verticalAcceleration number The vertical acceleration

-- RADAR --

---@class RadarTarget A discovered target from a radar.
---@field position Vec3 The position of the target
---@field surfaceArea number The total surface area that the radar can detect

-- SEATCONTROLLER --

---@class JointData Contains data about joints.
---@field leftSpeed integer The speed level of the joint (left side).
---@field rightSpeed integer The speed level of the joint (right side).
---@field leftLimit integer The max rotation limit on the left side.
---@field rightLimit integer The max rotation limit on the right side.
---@field bearingLock boolean If the joint is locked or not.

---@class SeatData Contains data about a connected seat.
---@field wsPower integer Power for forward or backward movement.
---@field adPower integer Power for left or right movement.
---@field characterName string The name of the seated player.

-- LASER --

---@class LaserData Data received from a laser
---@field directionWorld Vec3 The direction world
---@field fraction       number 0-1 range from the start point to the end point, The higher the value, the closer it is to the end point.
---@field normalLocal    Vec3 The normal local
---@field normalWorld    Vec3 The normmal world
---@field originWorld    Vec3 The origin world
---@field pointLocal     Vec3 The reflection direction in the local side
---@field pointWorld     Vec3 The reflection direction in the world side
---@field type           string Type of object it has hitted
---@field valid          boolean If the raycast was valid or not
---@field color          Color The color it has hitted.

-- AUDIO --

---@alias AudioEffectParameterList table<string, number>

---@class AudioParamsIssues Contains information about any issues with your audio parameters
---@field hasNoParamsUsableIssue boolean Whether the audio has no usable parameters
---@field issues string[][] The list of parameter issues

---@class AudioParameter Information about a audio parameter.
---@field default number The default value of the parameter
---@field maximum number The maximum value of the parameter
---@field minimum number The minimum value of the parameter

-- FONT MANAGER --

---@class SCFont A SCFont (`SCF` in short, `ScrapComputers Font` for full name) is a font that has a fixed with and height for EVERY singular character.
---@field fontWidth integer The width of the font
---@field fontHeight integer The height of the font
---@field characters string All characters that are usable in the font
---@field errorChar string[] The character used for a gylph that doesn't exist.
---@field charset table<string, string[]> Contains all gylph data for all characters.

-- OTHER --

---@alias MultiRotationType Vec3|Quat

------------------------------------------------------------------------------------------------------------------------------------
---                                                                                                                              ---
---   ██████╗ ██╗      ██████╗ ██████╗  █████╗ ██╗         ██╗   ██╗ █████╗ ██████╗ ██╗ █████╗ ██████╗ ██╗     ███████╗███████╗  ---
---  ██╔════╝ ██║     ██╔═══██╗██╔══██╗██╔══██╗██║         ██║   ██║██╔══██╗██╔══██╗██║██╔══██╗██╔══██╗██║     ██╔════╝██╔════╝  ---
---  ██║  ███╗██║     ██║   ██║██████╔╝███████║██║         ██║   ██║███████║██████╔╝██║███████║██████╔╝██║     █████╗  ███████╗  ---
---  ██║   ██║██║     ██║   ██║██╔══██╗██╔══██║██║         ╚██╗ ██╔╝██╔══██║██╔══██╗██║██╔══██║██╔══██╗██║     ██╔══╝  ╚════██║  ---
---  ╚██████╔╝███████╗╚██████╔╝██████╔╝██║  ██║███████╗     ╚████╔╝ ██║  ██║██║  ██║██║██║  ██║██████╔╝███████╗███████╗███████║  ---
---   ╚═════╝ ╚══════╝ ╚═════╝ ╚═════╝ ╚═╝  ╚═╝╚══════╝      ╚═══╝  ╚═╝  ╚═╝╚═╝  ╚═╝╚═╝╚═╝  ╚═╝╚═════╝ ╚══════╝╚══════╝╚══════╝  ---
---                                                                                                                              ---
------------------------------------------------------------------------------------------------------------------------------------

-- Prints a message to the chat.
---@param ... any|any[] The message to send
function print(...) end

-- Prints a message to the console.
---@param ... any|any[] The message to send
function debug(...) end

-- Sends an alert message to all players in the world.
---@param message string The message to send
---@param duration number The duration before the alert message fades out
function alert(message, duration) end

-- Pauses execution for the specified duration.
-- Note that this will freeze your game during the duration, as Scrap Mechanic is single-threaded!
---@param duration number The amount of time to sleep in seconds, max is 5 seconds.
function sleep(duration) end

-- Converts a value to a string! This function is modified by ScrapComputers to be more advanced.
-- It allows you to convert tables to strings, for example.
---@param value any The value to convert to a string
---@return string str The converted string
function tostring(value) end

-- Creates a function that executes the code inside the code argument with the specified environment.
-- You can use bytecode by setting bytecodeMode to true, BUT you need to be in unsafe environment mode for that! Otherwise, an error will be raised!
---@param code string The code to run
---@param env table The environment variables for the code
---@param bytecodeMode boolean Whether to execute bytecode or not.
---@return function? function The function to execute the code. Will be nil if there's an error.
---@return string? message The bytecode of the code if successful, or the error message if failed.
function loadstring(code, env, bytecodeMode) end

-- The main area containing all ScrapComputers-related components and functions
sc = {}

-- Gets all connected Displays and returns them
---@return Display[] Displays All connected Displays
function sc.getDisplays() end

-- Gets all connected Drives and returns them
---@return Harddrive[] Drives All connected Drives
function sc.getDrives() end

-- Gets all connected Holograms and returns them
---@return Hologram[] Holograms All connected Holograms
function sc.getHolograms() end

-- Gets all connected Terminals and returns them
---@return Terminal[] Terminals All connected Terminals
function sc.getTerminals() end

-- Gets all connected Radars and returns them
---@return Radar[] Radars All connected Radars
function sc.getRadars() end

-- Gets all connected Network Ports and returns them
---@return NetworkPort[] NetworkPorts All connected Network Ports
function sc.getNetworkPorts() end

-- Gets all connected Cameras and returns them
---@return Camera[] Cameras All connected Cameras
function sc.getCameras() end

-- Gets all connected Speakers and returns them
---@return Speaker[] Speakers All connected Speakers
function sc.getSpeakers() end

-- Gets all connected Keyboards and returns them
---@return KeyboardComponent[] Keyboards All connected Keyboards
function sc.getKeyboards() end

-- Gets all connected Motors and returns them
---@return Motor[] Motors All connected Motors
function sc.getMotors() end

-- Gets all connected Lasers and returns them
---@return Laser[] Lasers All connected Lasers
function sc.getLasers() end

-- Gets all connected GPSs and returns them
---@return GPS[] GPSs All connected GPSs
function sc.getGPSs() end

-- Gets all connected Seat Controllers and returns them
---@return SeatController[] SeatControllers All connected Seat Controllers
function sc.getSeatControllers() end

-- Gets the power value of a register
---@param registerName string The name of the register to get the power value from
---@return number power The power value of the register
function sc.getReg(registerName) end

-- Sets the power value of a register
---@param registerName string The name of the register to set the power value for
---@param power number The power value to set
function sc.setReg(registerName, power) end

----------------------------------------------------------------------
---                                                                ---
--- ███╗   ███╗ ██████╗ ██████╗ ██╗   ██╗██╗     ███████╗███████╗  ---
--- ████╗ ████║██╔═══██╗██╔══██╗██║   ██║██║     ██╔════╝██╔════╝  ---
--- ██╔████╔██║██║   ██║██║  ██║██║   ██║██║     █████╗  ███████╗  ---
--- ██║╚██╔╝██║██║   ██║██║  ██║██║   ██║██║     ██╔══╝  ╚════██║  ---
--- ██║ ╚═╝ ██║╚██████╔╝██████╔╝╚██████╔╝███████╗███████╗███████║  ---
--- ╚═╝     ╚═╝ ╚═════╝ ╚═════╝  ╚═════╝ ╚══════╝╚══════╝╚══════╝  ---
---                                                                ---
----------------------------------------------------------------------

sc.json = {}

-- Returns true if the table is safe for JSON conversion
---@param root table The table to check
---@return boolean jsonSafe Whether the table is safe for JSON usage or not
function sc.json.isSafe(root) end

-- Converts a table to a JSON string
---@param root table The table to convert
---@param safeMode boolean? Whether to consider safety during conversion
---@param prettifyOutput boolean? Whether to prettify the output
---@param indentCharacter string The character used for indentation
---@return string jsonString The converted JSON string
function sc.json.toString(root, prettifyOutput, indentCharacter) end

-- Converts a JSON string to a table
---@param root string The JSON string to convert
---@param safeMode boolean Whether to check for corrupt data in the JSON string
---@return table The converted table
function sc.json.toTable(root, safeMode) end

-- Lets you get information about SM's built in audio's! (Does not include custom ones from SM-CustomAudioExcension DLL mod)
sc.audio = {}

-- Gets all audio names
---@return string[] audioNames All available audio names
function sc.audio.getAudioNames() end

-- Returns true if an audio name exists
---@param name string The name of the audio
---@return boolean audioExists Whether the audio name exists or not
function sc.audio.audioExists(name) end

-- Gets all available parameters for a specified audio name
---@param name string The name of the audio
---@return table<string, AudioParameter> AudioParameters All parameters associated with the audio
function sc.audio.getAvailableParams(name) end

-- Returns any issues with the specified parameters for an audio
---@param name string The name of the audio
---@param params table The parameters specified
---@return AudioParamsIssues? AudioParamsIssues The issues with the specified parameters, if any
function sc.audio.getIssuesWithParams(name, params) end

-- Base64 encoding and decoding library
sc.base64 = {}

-- Encodes a string to Base64
---@param data string The string to encode
---@return string data The encoded string
function sc.base64.encode(data) end

-- Decodes a Base64 string
---@param data string The string to decode
---@return string data The decoded string
function sc.base64.decode(data) end

-- A stream of bits. Used for networking for example.
---@class BitStream
local Bitstream = {}

-- Dumps the bitstream to a string
---@return string dumpedString The dumped string
function Bitstream:dumpString() end

-- Dumps the bitstream as Base64
---@return string dumpedString The dumped Base64 string
function Bitstream:dumpBase64() end

-- Dumps the bitstream as hex
---@return string dumpedString The dumped hex string
function Bitstream:dumpHex() end

-- Writes a bit
---@param bit boolean|number The bit value to write
function Bitstream:writeBit(bit) end

-- Reads a bit
---@return integer The bit value (0 or 1), or nil if overflow
function Bitstream:readBit() end

-- Writes a byte
---@param byte number The byte to write (must be an ASCII character)
function Bitstream:writeByte(byte) end

-- Reads a byte
---@return integer byte The byte that was read
function Bitstream:readByte() end

-- Writes a signed 8-bit integer
---@param integer integer The signed 8-bit integer to write
function Bitstream:writeInt8(integer) end

-- Reads a signed 8-bit integer
---@return integer integer The signed 8-bit integer that was read
function Bitstream:readInt8() end

-- Writes an unsigned 8-bit integer
---@param uinteger integer The unsigned 8-bit integer to write
function Bitstream:writeUInt8(uinteger) end

-- Reads an unsigned 8-bit integer
---@return integer uinteger The unsigned 8-bit integer that was read
function Bitstream:readUInt8() end

-- Writes a signed 16-bit integer
---@param integer integer The signed 16-bit integer to write
function Bitstream:writeInt16(integer) end

-- Reads a signed 16-bit integer
---@return integer integer16 The signed 16-bit integer that was read
function Bitstream:readInt16() end

-- Writes an unsigned 16-bit integer
---@param uinteger integer The unsigned 16-bit integer to write
function Bitstream:writeUInt16(uinteger) end

-- Reads an unsigned 16-bit integer
---@return integer integer The unsigned 16-bit integer that was read
function Bitstream:readUInt16() end

-- Writes a signed 24-bit integer
---@param integer integer The signed 24-bit integer to write
function Bitstream:writeInt24(integer) end

-- Reads a signed 24-bit integer
---@return integer integer The signed 24-bit integer that was read
function Bitstream:readInt24() end

-- Writes an unsigned 24-bit integer
---@param uinteger integer The unsigned 24-bit integer to write
function Bitstream:writeUInt24(uinteger) end

-- Reads an unsigned 24-bit integer
---@return integer uinteger The unsigned 24-bit integer that was read
function Bitstream:readUInt24() end

-- Writes a signed 32-bit integer
---@param integer integer The signed 32-bit integer to write
function Bitstream:writeInt32(integer) end

-- Reads a signed 32-bit integer
---@return integer integer The signed 32-bit integer that was read
function Bitstream:readInt32() end

-- Writes an unsigned 32-bit integer
---@param uinteger integer The unsigned 32-bit integer to write
function Bitstream:writeUInt32(uinteger) end

-- Reads an unsigned 32-bit integer
---@return integer uinteger The unsigned 32-bit integer that was read
function Bitstream:readUInt32() end

-- Writes a string
---@param string string The string to write
function Bitstream:writeString(string) end

-- Reads a string
---@return string? str The string that was read
function Bitstream:readString() end

-- Lets you read and write via packet buffers. Useful for networking!
sc.BitStream = {}

-- Creates a new BitStream stream
---@param data string? Optional pre-appended binary data
---@return BitStream bitStream The created bit stream
function sc.BitStream.new(data) end

---Additional helper functions for sc.color
sc.color = {}

---Generates a random color within a specified range.
---@param from integer The starting range
---@param to integer The ending range
---@return Color color The generated color
function sc.color.random(from, to) end

---Creates a random color with values ranging from 0 to 1.
---@return Color color The generated color
function sc.color.random0to1() end

---Generates a grayscale color using a specified RGB value.
---@param rgbNumber integer The RGB value
---@return Color color The generated grayscale color
function sc.color.newSingular(rgbNumber) end

---Allows you to create an MD5 stream for generating MD5 hashes.
---@class MD5Stream
local MD5Stream = {}

-- Current position in the buffer.
MD5Stream.pos = 0

-- The current buffer data.
MD5Stream.buf = ''

---Appends new data to the MD5 stream.
---@param str string The data to append
---@return self MD5Stream The MD5 stream with updated data
function MD5Stream:update(str) end

---Finalizes the MD5 stream. After calling this, the stream can no longer be used.
---@return string md5String The final MD5 hash as a string
function MD5Stream:finish() end

-- MD5 encryption library
sc.md5 = {}

---Creates a new MD5 stream.
---@return MD5Stream The newly created MD5 stream
function sc.md5.new() end

---Converts raw bytes to hexadecimal format.
---@param rawBytes string The raw bytes
---@return string hexData The converted hexadecimal data
function sc.md5.tohex(rawBytes) end

---Converts a string to an MD5 hash.
---@param str string The string to convert
---@return string md5Data The MD5 hash of the string
function sc.md5.sum(str) end

---Converts a string to an MD5 hash in hexadecimal format.
---@param str string The string to convert
---@return string md5hexData The MD5 hash in hexadecimal format
function sc.md5.sumhexa(str) end
-- SHA256 Encryption library
sc.sha256 = {}

---Encodes a string to SHA256
---@param str string The string to encrypt
---@return string sha256String The SHA256 hash of the string
function sc.sha256.encode(str) end

-- Additional features for strings
sc.string = {}

---Splits a string into chunks.
---@param inputString string The string to split
---@param chunkSize number The size of each chunk
---@return string[] chunks The chunks of the input string
function sc.string.splitString(inputString, chunkSize) end

-- Additional functionality for tables
sc.table = {}

---Merges two tables.
---(If fullOverwrite is false) It merges the tables:
---    - If both value1 and value2 are tables, it recursively merges them.
---    - If value1 is a table but value2 is not, value1 will not be overwritten.
---    - If neither of the above checks apply, value2 will be used.
---@param table1 table The first table
---@param table2 table The second table
---@param fullOverwrite boolean? If true, table2 will overwrite any values in table1.
---@return table mergedTable The merged table
function sc.table.merge(table1, table2, fullOverwrite) end

---Clones a table.
---@param tbl table The table to clone
---@return table clonedTable The cloned table
function sc.table.clone(tbl) end

---Converts a Lua table to a string.
---@param tbl table The Lua table to convert
---@return string str The table as a string
function sc.table.toString(tbl) end

---Gets an item at a specific index, ignoring the table's actual indexing.
---@param tbl table The table to read from
---@param index integer The index to retrieve
---@return any? value The retrieved value
function sc.table.getItemAt(tbl, index) end

---Gets the size of a table. Compatible with dictionaries. (Note: Using `#dict` will always return 0!)
---@param tbl table The table
---@return integer size The total number of values in the table
function sc.table.getTableSize(tbl) end

---Shifts a table's indexes by a specified amount.
---@param tbl table The table to shift
---@param shiftAmount integer The amount to shift
---@return table shiftedTable The table with shifted indexes
function sc.table.shiftTableIndexes(tbl, shiftAmount) end

---Returns true if the table is a dictionary.
---@param tbl table The table to check
---@return boolean isDict True if the table is a dictionary, false otherwise
function sc.table.isDictionary(tbl) end

---Creates a new table ordered by numbers (linear).
---@param tbl table The table to order
---@return table orderedTable The table ordered by number
function sc.table.numberlyOrderTable(tbl) end

---Returns true if a value exists in the table.
---@param tbl table The table to search
---@param item any The value to find
---@return boolean valueExists True if the value exists, false otherwise
---@return any? valueIndex The index where the value was found, if applicable
function sc.table.valueExistsInList(tbl, item) end

---Merges two lists into one. `tbl2` is appended to `tbl1`. (Indexes will be reordered to be numerically ordered!)
---@param tbl1 table The first list
---@param tbl2 table The second list
---@return table mergedList The merged list
function sc.table.mergeLists(tbl1, tbl2) end

-- Utility functions
sc.util = {}

---Reimplementation of sm.util.positiveModulo, Uncrashable.
---@param x number The number to divide
---@param n number The amount to divide
---@return number remainder The remains that it is impossible to divide
function sm.scrapcomputers.util.positiveModulo(x, n) end

-- Additional features that `sm.vec3` does not have
sc.vec3 = {}

---A function similar to `sm.vec3.new`, but with one argument.
---Simply put, it's equivalent to `sm.vec3.new(xyzNum, xyzNum, xyzNum)`, hence the name "newSingular".
---@param xyzNum number The value for x, y, and z
---@return Vec3 vector3 The created vector3
function sc.vec3.newSingular(xyzNum) end

---Converts a vector3 to be in radians
---@param vec3 Vec3 The vector3 value for x, y and z
---@return Vec3 vec3 The created vector3
function smc.vec3.toRadians(vec3) end

---Converts a vector3 to be in degrees
---@param vec3 Vec3 The vector3 value for x, y and z
---@return Vec3 vec3 The created vector3
function sc.vec3.toDegrees(vec3) end


-- VPBS allows you to convert a Lua table to a packet buffer. Use this if you prefer to handle packets as strings rather than dealing with BitStreams.
sc.vpbs = {}

---Converts a table to a VPBS string.
---@param tbl table The table to convert
---@return string vpbsStr The converted VPBS string
function sc.vpbs.toString(tbl) end

---Converts a VPBS string to a table.
---@param data string The VPBS string
---@return table tbl The table created from the string
function sc.vpbs.toTable(data) end

---Checks if the string is in VPBS format.
---@param data string The data to check
---@return boolean isVPBS True if the string is in VPBS format, false otherwise
function sc.vpbs.isVPBSstring(data) end

-- Manages fonts and lets you get the fonts
sc.fontamanger = {}

---Gets a font
---@param fontName string The font name to get
---@return ScrapComputersFont? font The font
---@return string? errorMessage The error message (if it failed to get the font)
function sc.fontamanger.getFont(fontName) end

---Gets all font names
---@return string[] All font names
function sc.fontamanger.getFontNames() end

---Returns the default font name
---@return string defualtFontName The font name
function sc.fontamanger.getDefaultFontName() end

---Returns the default font
---@return ScrapComputersFont font The default font
function sc.fontamanger.getDefaultFont() end

----------------------------------------------------------------------------------------------------
---                                                                                              --- 
---   ██████╗ ██████╗ ███╗   ███╗██████╗  ██████╗ ███╗   ██╗███████╗███╗   ██╗████████╗███████╗  ---
---  ██╔════╝██╔═══██╗████╗ ████║██╔══██╗██╔═══██╗████╗  ██║██╔════╝████╗  ██║╚══██╔══╝██╔════╝  ---
---  ██║     ██║   ██║██╔████╔██║██████╔╝██║   ██║██╔██╗ ██║█████╗  ██╔██╗ ██║   ██║   ███████╗  ---
---  ██║     ██║   ██║██║╚██╔╝██║██╔═══╝ ██║   ██║██║╚██╗██║██╔══╝  ██║╚██╗██║   ██║   ╚════██║  ---
---  ╚██████╗╚██████╔╝██║ ╚═╝ ██║██║     ╚██████╔╝██║ ╚████║███████╗██║ ╚████║   ██║   ███████║  ---
---   ╚═════╝ ╚═════╝ ╚═╝     ╚═╝╚═╝      ╚═════╝ ╚═╝  ╚═══╝╚══════╝╚═╝  ╚═══╝   ╚═╝   ╚══════╝  ---
---                                                                                              ---
----------------------------------------------------------------------------------------------------

---The camera allows you to capture frames or even render video from the world to your display! Our camera
---performs well without the need for raytracing, using rays in a multicast fashion rather than complex
---raytracing techniques.
---
---The calculations are simple: addition, subtraction, division, and multiplication.
---@class Camera
local Camera = {}

---Captures a frame and displays it.
---@param display Display The display to draw on
---@param width   integer? The width of the frame
---@param height  integer? The height of the frame
function Camera.frame(display, width, height) end

---Captures a frame with shadows and displays it.
---@param display Display The display to draw on
---@param width   integer? The width of the frame
---@param height  integer? The height of the frame
function Camera.advancedFrame(display, width, height) end

---Captures a depth frame and displays it.
---@param display     Display The display to draw on
---@param focalLength number The focal length
---@param width       integer? The width of the frame
---@param height      integer? The height of the frame
function Camera.depthFrame(display, focalLength, width, height) end

---Captures a masked frame and displays it.
---@param display Display The display to draw on
---@param mask    string The mask to apply
---@param width   integer? The width of the frame
---@param height  integer? The height of the frame
function Camera.maskedFrame(display, mask, width, height) end

---Captures a frame and displays it. Allows for a custom drawer function to modify the result.
---@param display Display The display to draw on
---@param drawer  function The custom drawer function
---@param width   integer? The width of the frame
---@param height  integer? The height of the frame
function Camera.customFrame(display, drawer, width, height) end

---Captures a frame and displays it. Designed for video rendering.
---@param display    Display The display to draw on
---@param sliceWidth integer The slice width. Larger values render frames faster but may impact performance.
---@param width      integer? The width of the video
---@param height     integer? The height of the video
function Camera.video(display, sliceWidth, width, height) end

---Captures a frame and displays it. Designed for video rendering with shadows.
---@param display    Display The display to draw on
---@param sliceWidth integer The slice width. Larger values render frames faster but may impact performance.
---@param width      integer? The width of the video
---@param height     integer? The height of the video
function Camera.advancedVideo(display, sliceWidth, width, height) end

---Captures a frame and displays it. Allows for a custom drawer function to modify the result. Designed for video rendering.
---@param display    Display The display to draw on
---@param drawer     function The custom drawer function
---@param sliceWidth integer The slice width. Larger values render frames faster but may impact performance.
---@param width      integer? The width of the frame
---@param height     integer? The height of the frame
function Camera.customVideo(display, drawer, sliceWidth, width, height) end

---Sets the range of the camera. The larger the range, the further you can see.
---@param range integer The range to set
function Camera.setRange(range) end

---Sets the shadow range of the camera. The larger the range, the larger the shadows can be.
---@param range integer The range to set
function Camera.setShadowRange(range) end

---Sets the field of view (FOV) of the camera.
---@param fov integer The FOV to set
function Camera.setFov(fov) end

---Sets the x position offset for rendering.
---@param xOffset integer The x offset
function Camera.setOffsetX(xOffset) end

---Sets the y position offset for rendering.
---@param yOffset integer The y offset
function Camera.setOffsetY(yOffset) end

---@class Display The display functions like a monitor in Scrap Mechanic, allowing you to draw anything on it using a computer.
local Display = {}

---Draws a pixel on the screen.
---@param x number The x-coordinate
---@param y number The y-coordinate
---@param color MultiColorTypeNonNil The color (cannot be nil!)
function Display.drawPixel(x, y, color) end

---Draws pixels from a table.
---@param tbl PixelTable The table of pixels
function Display.drawFromTable(tbl) end

---Clears the display.
---@param color MultiColorType The new background color (defaults to "#000000")
function Display.clear(color) end

---Draws a line from point A to point B.
---@param x number The first point on the x-axis
---@param y number The first point on the y-axis
---@param x1 number The second point on the x-axis
---@param y1 number The second point on the y-axis
---@param color MultiColorType The color of the line
function Display.drawLine(x, y, x1, y1, color) end

---Draws a circle.
---@param x number The x-coordinate
---@param y number The y-coordinate
---@param radius number The radius of the circle
---@param color MultiColorType The color of the circle
function Display.drawCircle(x, y, radius, color) end

---Draws a filled circle.
---@param x number The x-coordinate
---@param y number The y-coordinate
---@param radius number The radius of the circle
---@param color MultiColorType The color of the filled circle
function Display.drawFilledCircle(x, y, radius, color) end

---Draws a rectangle.
---@param x number The x-coordinate
---@param y number The y-coordinate
---@param width number The width of the rectangle
---@param height number The height of the rectangle
---@param color MultiColorType The color of the rectangle
function Display.drawRect(x, y, width, height, color) end

---Draws a filled rectangle.
---@param x number The x-coordinate
---@param y number The y-coordinate
---@param width number The width of the rectangle
---@param height number The height of the rectangle
---@param color MultiColorType The color of the filled rectangle
function Display.drawFilledRect(x, y, width, height, color) end

---Draws text on the display.
---@param x number The x-coordinate
---@param y number The y-coordinate
---@param text string The text to display
---@param color MultiColorType The color of the text
---@param fontName string The font to use
function Display.drawText(x, y, text, color, fontName) end

---Draws a image on the screen.  Images are loaded from the DisplayImages folder in the mods directory, you can generate your own images with the use of our PNG to pixel data python conveter in the mod.
---@param width integer The width of the image
---@param height integer The height of the image
---@param path string The path of the image. Put `example.json` here to load a example image (256x256 image)
function Display.loadImage( width, height, path ) end

---Returns the dimensions of the display.
---@return number width The width of the display
---@return number height The height of the display
function Display.getDimensions() end

---Hides the display, making it invisible to all players.
function Display.hide() end

---Shows the display, making it visible to all players.
function Display.show() end

---Sets the render distance for the display. If the user goes beyond this range, the display will automatically hide itself, otherwise, it will remain visible.
---@param distance number The new render distance to set
function Display.setRenderDistance(distance) end

---Enables or disables touchscreen functionality, allowing the user to interact with the display.
---@param bool boolean If true, touchscreen mode is enabled, and the end user can interact with it.
function Display.enableTouchScreen(bool) end

---Retrieves the latest touch data. An error will occur if the touchscreen is disabled.
---@return TouchData? touchData The touch data, or nil if the display has not been touched.
function Display.getTouchData() end

---Renders the pixels to the display.
function Display.update() end

---Automatically updates the display. This is not recommended, as it can be very laggy.
---@param bool boolean Toggles the auto-update system.
function Display.autoUpdate(bool) end

---Optimizes the display for performance. Optimization can be costly at first, but will significantly improve performance afterward.
function Display.optimize() end

---Sets the optimization threshold. Lower values provide better quality but less optimization, while higher values provide better optimization at the cost of quality. The value should be set in decimals. The default optimization threshold is 0.05.
---@param threshold number The new threshold
function Display.setOptimizationThreshold(threshold) end

---Returns the display's ID.
---@return integer id The display's shape ID.
function Display.getId() end

---Returns the current optimization threshold (0 - 1).
---@return number threshold The current optimization threshold
function Display.getOptimizationThreshold() end

---Calculates the size of the text.
---@param text string The text to be calculated
---@param font string The font to use
---@return number width The width of the text
---@return number height The height of the text
function Display.calcTextSize(text, font) end

---@class GPS A GPS allows you to get rotation, position, velocities, and more!
local GPS = {}

---Gets GPS data and returns it.
---@return GPSData gpsData The GPS data it has received
function GPS.getGPSData() end

---@class Harddrive A drive allows you to store anything* inside it. You can also interact with it to modify its data directly without using code.
local Harddrive = {}

---Loads data from the hard drive and returns it.
---@return table contents The hard drive's contents
function Harddrive.load() end

---Saves data to the hard drive. Must be JSON compatible.
---@param data table The data to save
function Harddrive.save(data) end

---@class HologramObject A 3D hologram object
local HologramObject = {}

---Gets the ID of the object.
---@return number id The ID of the object
function HologramObject.getId() end

---Gets the UUID of the object.
---@return Uuid uuid The UUID of the object
function HologramObject.getUUID() end

---Gets the position of the object.
---@return Vec3 position The position of the object
function HologramObject.getPosition() end

---Gets the rotation of the object.
---@return Quat rotation The rotation of the object
function HologramObject.getRotation() end

---Gets the scale of the object.
---@return Vec3 scale The scale of the object
function HologramObject.getScale() end

---Gets the color of the object.
---@return Color color The color of the object
function HologramObject.getColor() end

---Sets the object's UUID to the given value.
---@param value string|Uuid The new UUID
function HologramObject.setUUID(value) end

---Sets the object's position to the given value.
---@param value Vec3 The new position
function HologramObject.setPosition(value) end

---Sets the object's rotation to the given value.
---@param value MultiRotationType The new rotation
function HologramObject.setRotation(value) end

---Sets the object's scale to the given value.
---@param value Vec3 The new scale
function HologramObject.setScale(value) end

---Sets the object's color to the given value.
---@param value MultiColorType The new color
function HologramObject.setColor(value) end

---Deletes this hologram object. You will no longer be able to use any of its functions, except `isDeleted`.
function HologramObject.delete() end

---Returns true if the object has been deleted.
---@return boolean isDeleted If true, the object is deleted. Otherwise, it is not deleted.
function HologramObject.isDeleted() end

---@class Hologram A hologram that lets you show 3D objects!
local Hologram = {}

---Creates a cube object.
---@param position Vec3 The position of the object
---@param rotation Vec3 The rotation of the object
---@param scale Vec3 The scale of the object
---@param color MultiColorTypeNonNil The color of the object
---@return integer id The ID of the object
function Hologram.createCube(position, rotation, scale, color) end

---Creates a sphere object.
---@param position Vec3 The position of the object
---@param rotation Vec3 The rotation of the object
---@param scale Vec3 The scale of the object
---@param color MultiColorTypeNonNil The color of the object
---@return integer id The ID of the object
function Hologram.createSphere(position, rotation, scale, color) end

---Creates a custom object.
---@param uuid Uuid The UUID of the object
---@param position Vec3 The position of the object
---@param rotation Vec3 The rotation of the object
---@param scale Vec3 The scale of the object
---@param color MultiColorTypeNonNil The color of the object
---@return integer id The ID of the object
function Hologram.createCustomObject(uuid, position, rotation, scale, color) end

---Gets the object by object ID and returns a table containing the data of that object, or nil if it doesn't exist.
---@param index number The object you want to retrieve
---@return HologramObject? object Returns a table (if the object exists) or nil (if the object does not exist)
function Hologram.getObject(index) end

---@class Keyboard A virtual keyboard that allows you to type. The computer can read one character at a time.
local Keyboard = {}

---Returns the latest keystroke that has been pressed. If it returns "backSpace" (capitalization matters!), the user pressed the backspace key.
---Note that Scrap Computers cannot detect all characters!
---@return "backSpace"|string keystroke The pressed keystroke
function Keyboard.getLatestKeystroke() end

---Returns true if a key has been pressed.
---@return boolean isPressed Returns true if a key has been pressed, false otherwise
function Keyboard.isPressed() end

---@class Laser A laser is like a sensor in Scrap Mechanic, but it works with a computer and has more features than a normal one.
local Laser = {}

---Sets the laser's distance.
---@param distance integer The distance to set for the laser
function Laser.setDistance(distance) end

---Gets laser data and returns it.
---@return boolean hit If the laser has hit something
---@return LaserData data The laser data
function Laser.getLaserData() end

---Toggles the laser's beam visiblity.
---@param bool boolean Enable or disable the laser beam visibility
function Laser.toggleLaser(bool) end

---Returns true if the laser beam is visible, false if invisible.
---@return boolean bool If the laser beam is visible or invisible
function Laser.isBeamEnabled() end

---Sets whether the laser ignores the current body it is placed on.
---@param bool boolean If true, the laser will ignore the current body
function Laser.ignoreCurrentBody(bool) end

---@class Motor Allows you to control velocities and lengths of bearings and pistons!
local Motor = {}

---Sets the speed of the bearing(s).
---@param speed number The speed to set for the bearing(s)
function Motor.setBearingSpeed(speed) end

---Sets the angle of the bearing(s).
---@param angle number The angle to set for the bearing(s)
function Motor.setBearingAngle(angle) end

---Sets the speed of the piston(s).
---@param speed number The speed to set for the piston(s)
function Motor.setPistonSpeed(speed) end

---Sets the torque of the bearing(s).
---@param torque number The torque to set for the bearing(s)
function Motor.setTorque(torque) end

---Sets the length of the piston(s).
---@param length number The length to set for the piston(s)
function Motor.setLength(length) end

---Sets the force of the piston(s).
---@param force number The force to set for the piston(s)
function Motor.setForce(force) end

---@class Radar The radar allows you to scan objects around it.
local Radar = {}

---Gets its targets and returns them.
---@return RadarTarget[] targets The list of detected targets
function Radar.getTargets() end

---Sets the vertical scan angle.
---@param angle number The vertical scan angle (range: 10 to 90 degrees)
function Radar.setVerticalScanAngle(angle) end

---Sets the horizontal scan angle.
---@param angle number The horizontal scan angle (range: 10 to 90 degrees)
function Radar.setHorizontalScanAngle(angle) end

---@class SeatController Allows you to control seats.
local SeatController = {}

---Gets the seat data and returns it.
---@return SeatData? data The seat data. Nil if no seat has been connected
function SeatController.getSeatData() end

---Gets data for all connected joints and returns it.
---@return JointData[]? data The connected joints' data. Nil if no seat has been connected
function SeatController.getJointData() end

---Presses a button.
---@param index integer The index of the button to press.
---@return boolean? success Whether the button press succeeded. Nil if no seat has been connected
function SeatController.pressButton(index) end

---Releases a button.
---@param index integer The index of the button to release.
---@return boolean? success Whether the button release succeeded. Nil if no seat has been connected
function SeatController.releaseButton(index) end

---@class Speaker The speaker allows you to play any kind of sound, and we mean anything!
local Speaker = {}

---Plays a beep sound.
function Speaker.beep() end

---Plays a long beep sound.
function Speaker.longBeep() end

---Plays a custom note.
---@param pitch number The pitch of the note.
---@param note number The note value.
---@param durationTicks number The duration of the note in ticks.
function Speaker.playNote(pitch, note, durationTicks) end

---Plays a custom sound effect.
---@param name string The name of the sound effect.
---@param params AudioEffectParameterList The parameters for the sound effect.
---@param durationTicks number The duration the sound will play in ticks.
function Speaker.playSound(name, params, durationTicks) end

---Stops all currently playing audio.
function Speaker.stopAllAudio() end

---@class Terminal A terminal is like a display but with a keyboard attached. It is an easy method for creating consoles.
local Terminal = {}

---Sends a message to the terminal.
---@param message string The message to send.
function Terminal.send(message) end

---Clears the terminal display.
function Terminal.clear() end

---Clears the input history.
function Terminal.clearInputHistory() end

---Checks if there are any pending inputs.
---@return boolean hasReceivedInputs Whether inputs have been received.
function Terminal.receivedInputs() end

---Gets the user's input and returns it. Will error if there are no inputs.
---@return string input The user's inputted message.
function Terminal.getInput() end

---@class Antenna The antenna component is connected to a network port. If connected, you can send data to other antennas wirelessly.
local Antenna = {}

---Gets the name of the antenna.
---@return string name The name of the antenna.
function Antenna.getName() end

---Sets the name of the antenna.
---@param name string The new name of the antenna.
function Antenna.setName(name) end

---Returns true if the antenna has a connection with another antenna.
---@return boolean hasConnection Whether the antenna is connected to another antenna with the same name.
function Antenna.hasConnection() end

---Scans for all antennas in the world and returns them.
---@return string[] discoveredAntennas A list of all discovered antennas.
function Antenna.scanAntennas() end

---@class NetworkPort The network port is used to send and receive data, and can be connected to an antenna.
local NetworkPort = {}

---Gets the connected antenna and returns it.
---@return Antenna? antenna The connected antenna, or nil if no antenna is connected.
function NetworkPort.getAntenna() end

---Returns true if the network port has a connection to another network port. Note that if an antenna is connected, this always returns true. For antenna connections, use `Antenna.hasConnection` instead.
---@return boolean hasConnection Whether the network port is connected to another port.
function NetworkPort.hasConnection() end

---Sends a packet to the connected network port or antenna.
---@param data any The data to send.
function NetworkPort.sendPacket(data) end

---Sends a packet to a specified antenna. The name does not have to match the connected antenna's name.
---@param name string The name of the antenna to send the packet to.
---@param data any The data to send.
function NetworkPort.sendPacketToAntenna(name, data) end

---Returns the total number of unread packets in the buffer.
---@return integer totalPackets The number of unread packets.
function NetworkPort.getTotalPackets() end

---Reads the next packet from the buffer and returns its data. Ensure there are packets to read, or this will cause an error.
---@return any data The received packet data.
function NetworkPort.receivePacket() end

---Clears all unread packets from the buffer.
function NetworkPort.clearPackets() end