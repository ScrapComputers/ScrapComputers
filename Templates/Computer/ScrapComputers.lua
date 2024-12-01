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

---@alias TouchTable table<string, TouchData> This is a table that contains all touch data from every player interacting with the screen. The index is the player's name/

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
---@field localPosition Vec3 The current local position
---@field localRotation Quat The current local rotation
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
---@field degreeRotation Vec3 The world's roation as a euler.

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

-- ASCFONT MANAGER --

---@class ASCFont Represents a font and its associated metadata, glyphs, and other properties
---@field metadata ASCFont.Metadata The metadata related to the font
---@field glyphs table<string, ASCFont.Glyph> A table mapping glyph names to their corresponding glyph data

---@class ASCFont.Metadata Metadata related to the font, such as its names, ascender/descender values, and bounding box
---@field names table<string, string> A table containing font names (e.g., fullname, PostScript name)
---@field ascender number The ascender value for the font, the height of the highest point of any character
---@field descender number The descender value for the font, the depth of the lowest point of any character
---@field underLinePosition number The vertical position where the underline is drawn
---@field underLineThickness number The thickness of the underline
---@field boundingBox ASCFont.BoundingBox The overall bounding box for the font containing the max and min coordinates
---@field resolution number The resolution (typically in DPI) for the font

---@class ASCFont.BoundingBox Represents the bounding box for a font, defining the minimum and maximum x and y coordinates
---@field xMin number The minimum x-coordinate of the font's bounding box
---@field xMax number The maximum x-coordinate of the font's bounding box
---@field yMin number The minimum y-coordinate of the font's bounding box
---@field yMax number The maximum y-coordinate of the font's bounding box

---@class ASCFont.Glyph Represents a single glyph in the font, including its width, metrics, and triangle data
---@field advanceWidth number The width of the glyph, which determines the spacing between it and the next character
---@field metrics ASCFont.Metrics The metrics associated with the glyph, including its bounding box and left bearing
---@field triangles table<ASCFont.Triangle> A table of triangles that define the shape of the glyph

---@class ASCFont.Metrics : ASCFont.BoundingBox Represents the metrics for a glyph, extending from the bounding box with additional properties like left bearing
---@field leftBearing number The horizontal distance from the origin to the leftmost edge of the glyph's bounding box

---@class ASCFont.Triangle Represents a triangle used to define the geometry of a glyph
---@field v1 ASCFont.Coordinate The first vertex of the triangle
---@field v2 ASCFont.Coordinate The second vertex of the triangle
---@field v3 ASCFont.Coordinate The third vertex of the triangle

---@class ASCFont.Coordinate Represents a 2D coordinate, typically used for defining the vertices of a triangle
---@field [1] number The x-coordinate of the point
---@field [2] number The y-coordinate of the point

-- CONFIG API --

---@class Configuration A configuration for ScrapComputers
---@field id string The id of the config, recommended to be in the format `[MOD_NAME].[COMPONENT_NAME].[CONFIG_NAME]`
---@field name string The name of the config
---@field description string The description of the config
---@field selectedOption integer The current config's selected option
---@field hostOnly boolean If the configuration is host-only accessible
---@field options string[] A list of usable options for the config

-- EXAMPLE MANAGER --

---@class Example Represents an example with a name and a script
---@field name string The name of the example
---@field script string The script in the example

-- LANGUAGE MANAGER --

---@class Language Represents a language from the language manager
---Each element inside it is a translation, where the index and value are strings.
---@field [string] string A table of translations where each element is a string translation

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

-- Gets all connected Lights and returns them
---@return Light[] Lights All connected Lights
function sc.getLights() end

-- Gets the power value of a register
---@param registerName string The name of the register to get the power value from
---@return number power The power value of the register
function sc.getReg(registerName) end

-- Sets the power value of a register
---@param registerName string The name of the register to set the power value for
---@param power number The power value to set
function sc.setReg(registerName, power) end

-- Returns true if unsafe env is enabled, else false for safe env.
---@return boolean isUnsafeENV If its in unsafe env or not.
function sc.isUnsafeEnvEnabled() end

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

---The example module for ScrapComputers
sc.example = {}

---Gets the loaded examples
---@return Example[] examples A table of all loaded examples
function sc.example.getExamples() end

---Gets the total number of examples currently loaded
---@return integer totalExamples The total number of loaded examples
function sc.example.getTotalExamples() end

---The syntax highlighting module for Lua code
sc.syntax = {}

---Adds syntax highlighting to the source and returns it
---You can also mark exception lines, with the first line being where the actual error happened,
---and the rest are code that leads to that error. If you don't want this, set the exceptionLines to an empty table.
---@param source string The Lua source code to highlight
---@param exceptionLines integer[] A table of line numbers where exceptions occurred (empty table if none)
---@return string highlightedCode The source code with syntax highlighting applied
function sc.syntax.highlightCode(source, exceptionLines) end

---The language manager module for ScrapComputers
sc.language = {}

---Gets all loaded languages and returns them
---@return Language[] languages A table of all loaded languages
function sc.language.getLanguages() end

---Gets the total number of loaded languages
---@return integer totalLanguages The total number of loaded languages
function sc.language.getTotalLanguages() end

---Gets the currently selected language
---@return string selectedLanguage The selected language
function sc.language.getSelectedLanguage() end

---Translates the provided text
---@param text string The text to translate
---@param ... any|any[] The parameters to pass to the translated text (optional)
---@return string translatedText The translated text, or the same as `text` if not found
function sc.language.translatable(text, ...) end

--- The configuration module for ScrapComputers
sc.config = {}

---Converts a name to an id
---@param name string The name of the config
---@return string? id The id of the config, or nil if not found
function sc.config.nameToId(name) end

---Gets a configuration by index (not id!)
---Will error if not found
---@param index integer The index to search for
---@return Configuration config The configuration found at the index
function sc.config.getConfigByIndex(index) end

---Gets the total number of configurations
---@return integer totalConfigurations The total amount of configurations
function sc.config.getTotalConfigurations() end

---Gets a configuration by id
---Will error if not found
---@param id string The ID of the config
---@return Configuration config The configuration found with the given id
function sc.config.getConfig(id) end

---Returns true if a configuration exists via ID
---@param id string The ID of the configuration
---@return boolean exists Whether the configuration exists or not
function sc.config.configExists(id) end

-- Extended JSON Library
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

---Dumps the buffer
---@return string buffer The dumped buffer
function self:dumpString() end

---Dumps the buffer (As Base64)
---@return string buffer The dumped buffer
function self:dumpBase64() end

---Dumps the buffer (As Hex)
---@return string buffer The dumped buffer
function self:dumpHex() end

---Reads a number from the bit stream (Big Endian)
---@param byteSize integer Size of the number in bytes
---@return integer number The read number
function self:readNumberBE(byteSize) end

---Reads a number from the bit stream (Little Endian)
---@param byteSize integer Size of the number in bytes
---@return integer number The read number
function self:readNumberLE(byteSize) end

--- Writes a float using IEEE 754 standard (Big Endian)
---@param value number The float value to encode
---@return integer encodedFloat The encoded float as integer
function self:encodeFloat(value) end

--- Reads a float using IEEE 754 standard (Big Endian)
---@param bytes integer The 4-byte integer representation of the float
---@return number decodedFloat The decoded float
function self:decodeFloat(bytes) end

--- Reads a double using IEEE 754 standard (Big Endian)
---@param bytes integer The 8-byte integer representation of the double
---@return number decodedDouble The decoded double
function self:decodeDouble(bytes) end

--- Writes a double using IEEE 754 standard (Big Endian)
---@param value number The double value to encode
---@return integer encodedDouble The encoded double as integer
function self:encodeDouble(value) end

---Reads a byte from the bit stream
---@return integer byte The read byte
function self:readByte() end

---Writes a byte to the bit stream
---@param byte string The byte to write
function self:writeByte(byte) end

---Reads a string of a given size from the bit stream
---@param size integer The size of the string
---@param stopNulByte boolean? If it should stop by a nul byte
---@return string str The read string
function self:readStringEx(size, stopNulByte) end

---Writes a float to the bit stream (Big Endian)
---@param value number The float value to write
function self:writeFloatBE(value) end

---Reads a float from the bit stream (Big Endian)
---@return number value The read float value
function self:readFloatBE() end

---Writes a double to the bit stream (Big Endian)
---@param value number The double value to write
function self:writeDoubleBE(value) end

---Reads a double from the bit stream (Big Endian)
---@return number value The read double value
function self:readDoubleBE() end

---Writes a float to the bit stream (Little Endian)
---@param value number The float value to write
function self:writeFloatLE(value) end

---Reads a float from the bit stream (Little Endian)
---@return number value The read float value
function self:readFloatLE() end

---Writes a double to the bit stream (Little Endian)
---@param value number The double value to write
function self:writeDoubleLE(value) end

---Reads a double from the bit stream (Little Endian)
---@return number value The read double value
function self:readDoubleLE()  end

---Reads a string from the bit stream
---@param isLittleEndian boolean? If it is in little endian or big endian, Defaults to little endian.
---@param stopNulByte boolean? If it should stop by a nul byte
---@return string str The read string
function self:readString(isLittleEndian, stopNulByte) end

---Skips bytes
---@param bytes integer The amount of bytes to skip
function self:skipBytes(bytes) end

---Seeks to a new position
---@param newPosition integer The new position
function self:seek(newPosition) end

-- Lets you read and write via packet buffers. Useful for networking!
sc.bitstream = {}

-- Creates a new BitStream stream
---@param data string? Optional pre-appended binary data
---@return BitStream bitStream The created bit stream
function sc.bitstream.new(data) end

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

---This generates an interpolated gradient between the colors provided and is dependent on the ammount of gradient specified.
---@param colors Color[] The table of colors to generate the gradient from.
---@param numColors integer The ammount of blending each color gets in the gradient table.
---@return Color[] colorGradient The generated gradient table.
function sc.color.generateGradient(colors, numColors) end

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
function sc.util.positiveModulo(x, n) end

---This generates an interpolated gradient between the numbers provided and is dependent on the ammount of gradient specified.
---@param numbers number[] The table of numbers to generate the gradient from.
---@param numNumbers integer The ammount of blending each number gets in the gradient table.
---@return number[] numberGradient The generated gradient table.
function sc.util.generateNumberGradient(numbers, numNumbers) end

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

---@class VirtualDisplay : Display A emulated display
local VirtualDisplay = {}

---This function cannot be used by Virtual Displays!
---@deprecated
function VirtualDisplay.hide() end

---This function cannot be used by Virtual Displays!
---@deprecated
function VirtualDisplay.show() end

---This function cannot be used by Virtual Displays!
---@deprecated
function VirtualDisplay.setRenderDistance(distance) end

---This function cannot be used by Virtual Displays!
---@deprecated
function VirtualDisplay.enableTouchScreen(bool) end

---This function cannot be used by Virtual Displays!
---@deprecated
function VirtualDisplay.getTouchData() end

---This function cannot be used by Virtual Displays! (Use render instead!)
---@deprecated
function VirtualDisplay.update() end

---This function cannot be used by Virtual Displays!
---@deprecated
function VirtualDisplay.autoUpdate(bool) end

---This function cannot be used by Virtual Displays!
---@deprecated
function VirtualDisplay.setOptimizationThreshold(int) end

---This function cannot be used by Virtual Displays!
---@deprecated
function VirtualDisplay.getOptimizationThreshold() end

---Generates a frame and returns a PixelTable to be rendered on a Display. Use offsets to offset where it should render
---@param xOffset number? The x offset, Defaults to 0 (Left)
---@param yOffset number? The y offset, Defaults to 0 (Top)
---@return PixelTable pixelTable The rendered frame
function VirtualDisplay.render(xOffset, yOffset) end

---Sets the virtual display's resolution
---@param newWidth integer The new display width
---@param newHeight integer The new display height
function VirtualDisplay.setDimensions(newWidth, newHeight) end

---Virtual displays enable the emulation of additional screens, allowing you to create fake displays in any resolution.
sc.virtualdisplay = {}

---Creates a virtual display
---@param displayWidth integer The width of the virtual display
---@param displayHeight integer The height of the virtual display
---@return VirtualDisplay virtualDisplay The new created display
function sc.virtualdisplay.new(displayWidth, displayHeight) end

-- Lets you group up displays into 1 massive display
sc.multidisplay = {}

---Creates a multidisplay
---@param displays Display[] Displays.
---@param columns integer Total columns
---@param rows integer Total rows
---@return Display display A Multidisplay instance. (Display type because its 100% compattable)
function sc.multidisplay.new(displays, columns, rows) end

---The font manager module for handling TrueType fonts
sc.ascfont = {}

---Gets information about the font
---@param fontName string The name of the font
---@return ASCFont fontData The font data
---@return string? error The error message, if any
function sc.ascfont.getFontInfo(fontName) end

---Calculates the size of a given text using a specified font
---@param fontName string The name of the font
---@param text string The text to measure
---@param fontSize number The font size
---@param rotation number The rotation of the text
---@return number width The width of the text
---@return number height The height of the text
function sc.ascfont.calcTextSize(fontName, text, fontSize, rotation) end

---Draws text to a display
---@param display Display The display to draw on
---@param xOffset number The x-coordinate offset
---@param yOffset number The y-coordinate offset
---@param text string The text to draw
---@param fontName string The font name to use
---@param color string|Color The color of the text
---@param rotation number? The rotation of the text (optional)
---@param fontSize number The size of the font to use
---@param colorToggled boolean? Whether the text color can change dynamically (optional)
function sc.ascfont.drawText(display, xOffset, yOffset, text, fontName, color, rotation, fontSize, colorToggled) end

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

-- Draws a filled triangle
---@param x1 number The 1st point on X-axis
---@param y1 number The 1st point on Y-axis
---@param x2 number The 2nd point on X-axis
---@param y2 number The 2nd point on Y-axis
---@param x3 number The 3rd point on X-axis
---@param y3 number The 3rd point on Y-axis
---@param color MultiColorType The color of the triangle
function Display.drawTriangle(x1, y1, x2, y2, x3, y3, color) end

-- Draws a filled triangle
---@param x1 number The 1st point on X-axis
---@param y1 number The 1st point on Y-axis
---@param x2 number The 2nd point on X-axis
---@param y2 number The 2nd point on Y-axis
---@param x3 number The 3rd point on X-axis
---@param y3 number The 3rd point on Y-axis
---@param color MultiColorType The color of the triangle
function Display.drawFilledTriangle(x1, y1, x2, y2, x3, y3, color) end

---Draws text on the display.
---@param x number The x-coordinate
---@param y number The y-coordinate
---@param text string The text to show
---@param color MultiColorType the color of the text
---@param fontName string? The name of the font to use
---@param maxWidth integer? The max width before it wraps around
---@param wordWrappingEnabled boolean? If it should do word wrapping or not.
function Display.drawText(x, y, text, color, fontName, maxWidth, wordWrappingEnabled) end

---Draws a image on the screen.  Images are loaded from the DisplayImages folder in the mods directory, you can generate your own images with the use of our PNG to pixel data python conveter in the mod.
---@param width integer The width of the image
---@param height integer The height of the image
---@param path string The path of the image. Put `example.json` here to load a example image (256x256 image)
---@param localSearch boolean If loadImage searches $CONTENT_DATA when looking for the image file
function Display.loadImage( width, height, path, localSearch ) end

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

---Retrieves touch table from the display.
---@return TouchTable touchTable A table containing all of the touch data from every player interacting with the display.
function Display.getTouchTable() end

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
---@param maxWidth integer? The max width before it wraps around
---@param wordWrappingEnabled boolean? If it should do word wrapping or not.
---@param dynamicHeight boolean? If the height should be dynamic towards the actual text instead of the font's height. Only works if word wrapping is disabled.
---@return number width The width of the text
---@return number height The height of the text
function Display.calcTextSize(text, font, maxWidth, wordWrappingEnabled, dynamicHeight) end

---Draws ASCF text to a display
---@param xOffset number The x-coordinate
---@param yOffset number The y-coordinate
---@param text string The text to draw
---@param fontName string The name of the font
---@param color string|Color The color of the text to set
---@param rotation number? The rotation
---@param fontSize number The size of the font to use
---@param colorToggled boolean? If it should support colors or not in text.
function Display.drawASCFText( xOffset, yOffset, text, fontName, color, rotation, fontSize, colorToggled ) end

---Calculates text size.
---@param fontName string THe name of the font
---@param text string The text
---@param fontSize number The size of the font
---@param rotation number? The rotation
---@return number width The width the font consumes
---@return number hegiht The height the font consumes
function Display.calcASCFTextSize( fontName, text, fontSize, rotation ) end

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

---@class Light A component which lets you set/get the color of it's own component.
local Light = {}

---Gets the color
---@return MultiColorTypeNonNil color The current color
function Light.getColor() end

---Sets the color
---@param color MultiColorTypeNonNil The new color
function Light.setColor(color) end
