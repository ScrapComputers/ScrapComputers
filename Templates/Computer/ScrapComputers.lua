---@diagnostic disable
---This file is for Developing computer code in Visual Studio code!

---Prints text to the chat. Will be always converted to a string so you can pass in anything
---If it is a table. It will convert to be printable and you can see the contents inside.
---@param ... any[] All arguments to send to the chat
function print( ... ) end

---Same as print but sends it as a alert message
---@param ... any[] All arguments to send to the alert popup
function alert( ... ) end

---Like the normal but modified to have additional features like printing lua tables!
---@param data any The variable to convert to be a string.
function tostring( data ) end

---The debug function is basically Lua’s implementation of the print function in Scrap Mechanic.
---@param ... any[] All arguments to send to the console
function debug( ... ) end

---The main namespace for ScrapComputers
sc = {}

---Gets all connected displays from the computer
---@return Display[] displays All connected displays from the computer
function sc.getDisplays() end

---Gets all connected drives from the computer
---@return Drive[] drives All connected drives from the computer
function sc.getDrives() end

---Gets all connected holograms from the computer
---@return Hologram[] holograms All connected holograms from the computer
function sc.getHolograms() end

---Gets all connected terminals from the computer
---@return Terminal[] terminals All connected terminals from the computer
function sc.getTerminals() end

---Gets all connected radars from the computer
---@return Radar[] radars All connected radars from the computer
function sc.getRadars() end

---Gets all connected network ports from the computer
---@return NetworkPort[] networkPorts All connected network ports from the computer
function sc.getNetworkPorts() end

---Gets all connected cameras from the computer
---@return Camera[] cameras All connected cameras from the computer
function sc.getCameras() end

---Gets all connected speakers from the computer
---@return Speaker[] speakers All connected speakers from the computer
function sc.getSpeakers() end

---Gets all connected keyboards from the computer
---@return Keyboard[] keyboards All connected keyboards from the computer
function sc.getKeyboards() end

---Gets all connected motors from the computer
---@return Motor[] motors All connected motors from the computer
function sc.getMotors() end

---Gets all connected lasers from the computer
---@return Laser[] lasers All connected lasers from the computer
function sc.getLasers() end

---Gets all connected seatcontrollers from the computer
---@return SeatController[] seatcontroller All connected seatcontrollers from the computer
function sc.getSeatControllers() end

---Gets a value of a register.
---@param registerName string The name of the register to read.
---@return number power The value it’s receiving. (For things like logic gates: 0 is Off, 1 is On)
function sc.getReg( registerName ) end
---Sets a value of a register.
---@param registerName string The name of the register to write.
---@param power number The value to set it to. (This is power!)
function sc.setReg( registerName, power ) end

---The Audio Module for the computer API!
sc.audio = {}

---@class sc.audio.AudioParameter
---Results for sc.audio.getParams
---@field default number The default value
---@field maximum number The maximum value
---@field minimum number The minimum value

---@class sc.audio.ParamsIncorrectTable
---All issues that the provided parameters have.
---@field hasNoParamsUsableIssue boolean If true. that means there are no usable parameters for this audio
---@field issues string[][] A matrix of issues. The 1st array is the parameter’s name and the 2nd array is the issues it has for that parameter.

---Returns information about audio parameters in case they have any issues.
---@param name string The name of the audio to check
---@param params sc.audio.AudioParameter[] The name of the audio to check
---@return sc.audio.ParamsIncorrectTable issues All issues with those parameters.
function sc.audio.areParamsCorrect( name, params ) end

---Returns true if the audio name exists in Scrap Mechanic.
---@param name string The name of the audio to check
---@return boolean audioExists If true, the audio exists in the game. Else it doesn’t!
function sc.audio.exists( name ) end

---Gets every audio in existence in Scrap Mechanic and puts them all in a string[] you can access
---@return string[] audioNames Every singular audio in existence
function sc.audio.getAudioNames() end

---Gets all usable parameters for that audio.
---@param name string The name of the audio to get its parameters from
---@return sc.audio.AudioParameter[] params All usable parameters for that audio.
function sc.audio.getParams( name ) end

---The Base64 Module for the computer API!
sc.base64 = {}

---Converts a string to be Base64 encoded
---@param data string The data to be converted
---@return string base64data The encoded data
function sc.base64.encode( data ) end

---Decodes a base64 string
---@param data string The data to be decoded
---@return string data The decoded data
function sc.base64.decode( data ) end

---The Color Module for the computer API!
sc.color = {}

---Creates a new color from 1 value. Whatever rgbNum’s value has will be set on R, G, and B.
---
---This means it’s grayscale only!
---@param rgbNum number The color value that will be set on R, G, and B
---@return Color color The generated color
function sc.color.newSingluar( rgbNum ) end

---Generates a random color from whatever range you want
---@param from number The starting range
---@param to number The ending range
---@return Color color The generated color
function sc.color.random( from, to ) end

---Generates a random color from 0 to 1
---@return Color color The generated color
function sc.color.random0to1() end

---The font manager allows you to, of course, manage fonts. You can get font information, get all font names you can use, etc.
---
---<i>The font manager is NOT a module so please do not identify this as a module</i>
sc.fontmanager = {}

---@class sc.fontmanager.SCFont
---A SCFont (SCF in short, ScrapComputers Font for full name) is a font that has a fixed with and height for EVERY singular character. This is in Lua so expect a massive font file size.
---@param fontWidth integer The width of the font
---@param fontHeight integer The height of the font
---@param characters string All characters used on the font
---@param errorChar string[] The error character font
---@param charset string[][] All character’s gylphs. On the first array. The index is the character! The second is the row number!

---Gets a font
---@param fontName string The name of the font to get
---@return sc.fontmanager.SCFont? font  The font it has recieved. Nil if there is an error.
---@return string? errMsg The error message it has received. Nil if there wasn’t an error.
function sc.fontmanager.getFont( fontName ) end

---Gets all fonts the font manager has access to
---@return string[] fontNames Every font name the font manager has access to.
function sc.fontmanager.getFontNames() end

---Gets the default font that the font manager uses. This is hard coded so you will require to hook this if you want to modify it.
---@return string defaultFontName The default font name used.
function sc.fontmanager.getDefaultFontName() end

---Like sc.fontmanager.getDefaultFontName but calls sc.fontmanager.getFont automaticly.
---@return sc.fontmanager.SCFont defaultFont The default font used.
function sc.fontmanager.getDefaultFont() end

---The JSON Module for the computer API!
sc.json = {}

---Returns true if a tlua table is safe to convert to JSON.
---@param root table The lua table to check
---@return boolean isSafe If true, That means it’s safe to convert. else not!
function sc.json.isSafe( root ) end

---Converts a lua tble to a JSON string.
---@param root table The lua table to convert to a string
---@param prettify boolean If true, The JSON string would be prettier. Use this when you want to display it.
---@param indent string? The indentation character. Defaults to “\t”
---@return string jsonString The JSON string from a Lua table
function sc.json.toString( root, prettify, indent ) end

---Converts a JSON string to a Lua table
---@param root string The JSON string to convert
---@return table The converted Lua table
function sc.json.toTable( root ) end

---A helper module for your needs that are math-related
sc.math = {}

---Clamps a number value to be ranged from the min argument to the max argument.
---@param value number The value to clamp
---@param min number The minimum for the value.
---@param max number The maximum for the value.
---@return number clampedNumber The clamped value
function sc.math.clamp( value, min, max ) end

---An encryption module for MD5 only! (Even tho it’s no longer recommended to use this for encryption! )
sc.md5 = {}

---@class sc.md5.MD5Stream
local sc_md5_md5stream = {}
sc_md5_md5stream.a = 0x67452301 ---Unknown. The Default Value is 0x67452301 (Number form: 1732584193)
sc_md5_md5stream.b = 0xefcdab89 ---Unknown. The default value is 0xefcdab89 (Number form: 4023233417)
sc_md5_md5stream.c = 0x98badcfe ---Unknown. The default value is 0x98badcfe (Number form: 2562383102)
sc_md5_md5stream.d = 0x10325476 ---Unknown. The default value is 0x10325476 (Number form: 271733878)
sc_md5_md5stream.pos = 0 ---The current position
sc_md5_md5stream.buf = "" ---The buffer data

---Adds additional data to the stream
---@param data string The data to add.
function sc_md5_md5stream.update( data ) end

---Finishes a buffer and returns its output data
---@return string data The stream's data
function sc_md5_md5stream.finish() end

---Creates a new MD5 Stream
---@return sc.md5.MD5Stream md5stream The new MD5 stream
function sc.md5.new() end

---Converts a string to a MD5 string (NOTE: Pure raw bytes!)
---@param str string The string to convert
---@return string md5rawbytes The string in a MD5 string in raw bytes format
function sc.md5.sum( str ) end

---Converts a string to an MD5-encrypted string
---@param str string The string to convert
---@return string md5encrypted The MD5-Encrypted string
function sc.md5.sumhexa( str ) end

---Converts an MD5 Raw bytes string to a Proper MD5 string that is readable
---@param str string The string to convert
---@return string md5encrypted The MD5-Encrypted string
function sc.md5.tohex( str ) end

---The SHA256 Module for the computer API!
---
---You can only encode. Nothing else…
sc.sha256 = {}

---Encodes a string to be SHA256
---@param str string The string to convert to SHA256
---@return string sha256str The converted string
function sc.sha256.encode( str ) end

---The Table Module for the computer API!
sc.table = {}

---Clones a table
---@param tbl table The table to clone
---@return table clonedTable The cloned table
function sc.table.clone( tbl ) end

---Gets an item from a table via the index. Unlike doing `tbl[index]`. This will not care if the index numbers aren’t in order.
---@param tbl table The table
---@param index integer The item to get
---@return any data Whatever data it has received from the index
function sc.table.getItemAt( tbl, index ) end

---Gets all items via a ipairs loop.
---
---Unlike doing #tbl, If the indexing was weird, #tbl would return 0. This function does not care if the indexing system is weird. Will give you the same result as if the indexing system was normal.
---
---For dictionaries. Use sc.table.getTotalItemsDict
---@param tbl table The table
---@return integer totalItems The total items in the table
function sc.table.getTotalItems( tbl ) end

---Gets all items via a pairs loop. This is used for dictionaries. else use sc.table.getTotalItems
---
---Unlike doing #tbl, If the indexing was weird, #tbl would return 0. This function does not care if the indexing system is weird. Will give you the same result as if the indexing system was normal.
---@param tbl table The table
---@return integer totalItems The total items in the table
function sc.table.getTotalItemsDict( tbl ) end

---Merges 2 tables in 1.
---
---**Important:** The order that you put the sc.table.merge matters! `tbl2` will override/overwrite anything inside `tbl1`!
---@param bl1 table The 1st table
---@param tbl2 table The 2nd table
---@param fullOverwrite boolean? This will make it so the merged value will be always from tbl2. Will not care about anything else. The default is false
---@return table tbl The merged table
function sc.table.merge( tbl1, tbl2, fullOverwrite ) end

---Converts a table to the same thing but as a string. If you were to try doing this with Lua’s tostring. You would just get “table: 00A59928”. Not the actual contents of the table itself!
---@param tbl table The table
---@return string tableStr The converted lua as a string
function sc.table.toString( tbl ) end

---Gets the remainder of the division.
---@param a number The number to divide and get its remainder
---@param b number The division by number
---@return number remainder The remainder of a divided number.
function sc.util.positiveModulo( a, b ) end

---The Vector3 Module for the computer API!
sc.vec3 = {}

---Adds a vec3 by **X, Y and Z**
---@param vec3 Vec3 The vector3 to modify
---@param x number Vec3’s x value to be added by
---@param y number Vec3’s y value to be added by
---@param z number Vec3’s z value to be added by
---@return Vec3 newVec3 The new vector3
function sc.vec3.add( vec3, x, y, z ) end

---Divides a vec3 by **X, Y and Z**
---@param vec3 Vec3 The vector3 to modify
---@param x number Vec3’s x value to be divided by
---@param y number Vec3’s y value to be divided by
---@param z number Vec3’s z value to be divided by
---@return Vec3 newVec3 The new vector3
function sc.vec3.divide( vec3, x, y, z ) end

---Multiplies a vec3 by **X, Y and Z**
---@param vec3 Vec3 The vector3 to modify
---@param x number Vec3’s x value to be multiplied by
---@param y number Vec3’s y value to be multiplied by
---@param z number Vec3’s z value to be multiplied by
---@return Vec3 newVec3 The new vector3
function sc.vec3.mulitply( vec3, x, y, z ) end

---Subtracts a vec3 by **X, Y and Z**
---@param vec3 Vec3 The vector3 to modify
---@param x number Vec3’s x value to be subtracted by
---@param y number Vec3’s y value to be subtracted by
---@param z number Vec3’s z value to be subtracted by
---@return Vec3 newVec3 The new vector3
function sc.vec3.subtract( vec3, x, y, z ) end

---Calculates the distance between 2 vectors
---@param vec1 Vec3 The 1st vector3
---@param vec2 Vec3 The 2nd vector3
---@return number The distance between the 2 vectors
function sc.vec3.distance( vec1, vec2 ) end

---Creates a vector3 by 1 number for xyz
---@param xyz number The value for the X, Y and Z
---@return Vec3 newVec3 The new vector3
function sc.vec3.newSingluar( xyz ) end

---@class Antenna
---The antenna component is connected to a network port. If connected, You would be able to send data to other antenna’s wireless!
local Antenna = {}

---Gets the name of the antenna
---@return string antennaName The name of the antenna
function Antenna.getName() end

---Sets the name of the antenna
---@param name string The new name of the antenna
function Antenna.setName( name ) end

---Returns true if there's a connection with anotehr antenna.
---@return boolean hasConnection True if it has a connection
function Antenna.hasConnection() end

---Gets all the antenna’s of the entire world
---@return string[] discoveredAntennas All discovered antennas
function Antenna.scanAntennas() end

---@class Camera
---The camera allows you to take screenshots or even render video from the world to your display! Our camera looks great while not even touching the raytracing. There’s no raytracing happening! just rays going everywhere as a multicast!
---
---This doesn't even touch the complicated math! Just addition, subtraction, division, and multiplication.
local Camera = {}

---Takes a frame (aka a screenshot)
---@param width integer The width of the frame
---@param height integer The height of the frame
---@param fovX number The FOV on x-axis
---@param fovY number The FOV on y-axis
---@param xOffset integer The applied x offset for the frame. By default, it’s at 0 so at the top, it would be rendered there
---@param yOffset integer The applied y offset for the frame. By default, it’s at 0 so at the left, it would be rendered there
---@return Display.DisplayPixelTable frame The pixels of the frame
function Camera.getFrame( width, height, fovX, fovY, xOffset, yOffset ) end

---Takes a depth map frame (aka a screenshot) and returns it
---@param width integer The width of the frame
---@param height integer The height of the frame
---@param fovX number The FOV on x-axis
---@param fovY number The FOV on y-axis
---@param focalLength integer The focal’s length
---@param xOffset integer The applied x offset for the frame. By default, it’s at 0 so at the top, it would be rendered there
---@param yOffset integer The applied y offset for the frame. By default, it’s at 0 so at the left, it would be rendered there
---@return Display.DisplayPixelTable frame The pixels of the frame
function Camera.getDepthMap( width, height, fovX, fovY, focalLength, xOffset, yOffset ) end

---Takes a depth map frame (aka a screenshot) and returns it
---@param width integer The width of the frame
---@param height integer The height of the frame
---@param fovX number The FOV on x-axis
---@param fovY number The FOV on y-axis
---@param sliceWidth  integer The width for each slice
---@param xOffset integer The applied x offset for the frame. By default, it’s at 0 so at the top, it would be rendered there
---@param yOffset integer The applied y offset for the frame. By default, it’s at 0 so at the left, it would be rendered there
---@return Display.DisplayPixelTable frame The pixels of the frame
function Camera.getVideo( width, height, fovX, fovY, sliceWidth , xOffset, yOffset ) end

---Takes a frame (aka a screenshot)
---@param width integer The width of the frame
---@param height integer The height of the frame
---@param fovX number The FOV on x-axis
---@param fovY number The FOV on y-axis
---@param xOffset integer The applied x offset for the frame. By default, it’s at 0 so at the top, it would be rendered there
---@param yOffset integer The applied y offset for the frame. By default, it’s at 0 so at the left, it would be rendered there
---@return Display.DisplayPixelTable frame The pixels of the frame
function Camera.getFrame( width, height, fovX, fovY, xOffset, yOffset ) end

---Takes a frame (aka a screenshot)
---@param width integer The width of the frame
---@param height integer The height of the frame
---@param fovX number The FOV on x-axis
---@param fovY number The FOV on y-axis
---@param focalLength integer The focal’s length
---@param xOffset integer The applied x offset for the frame. By default, it’s at 0 so at the top, it would be rendered there
---@param yOffset integer The applied y offset for the frame. By default, it’s at 0 so at the left, it would be rendered there
---@return Display.DisplayPixelTable frame The pixels of the frame
function Camera.getAdvancedFrame( width, height, fovX, fovY, focalLength, xOffset, yOffset ) end

---Like getFrame but it’s as slices meaning you could make CCTV cameras without lagging a lot! It’s just that the refresh rate would be lower.
---@param width integer The width of the frame
---@param height integer The height of the frame
---@param fovX number The FOV on x-axis
---@param fovY number The FOV on y-axis
---@param sliceWidth  integer The width for each slice
---@param xOffset integer The applied x offset for the frame. By default, it’s at 0 so at the top, it would be rendered there
---@param yOffset integer The applied y offset for the frame. By default, it’s at 0 so at the left, it would be rendered there
---@return Display.DisplayPixelTable frame The pixels of the frame
function Camera.getAdvancedVideo( width, height, fovX, fovY, sliceWidth , xOffset, yOffset ) end

---Toggles the randomization shader. This is very simple but adds a lot of detail to the frame at a cost of performance when used in displays as the optimization would be gone.
---
---This randomization of the colors of a frame’s pixels a tiny bit.
---@param toggle boolean To enable or disable the randomization shader
function Camera.toggleRandom( toggle ) end

---@class Display
local Display = {}

---@class Display.TouchData
---This contains touch data when the user interacts with the display AKA "touches the display"
---@param x number The position on the x-axis.
---@param y number The position on the y-axis.
---@param state 1|2|3 The state that it has been pressed. 1 is Pressed, 2 is Hold, 3 is Released.

---@class Display.PixelTable
---A pixel table is an array of pixels. Each item inside it contains the data below. Each value inside has a use case
---@field x number The position of the pixel on the X-axis
---@field y number The position of the pixel on the Y-axis
---@field scale {x : number, y : number} The size of the pixel itself.
---@field color Color The color of the pixel

---Draws a single pixel at the specified coordinates with the given color.
---@param x number The x-coordinate of the pixel.
---@param y number The y-coordinate of the pixel.
---@param color Color|string? The color of the pixel in hexadecimal format.
function Display.drawPixel( x, y, color ) end

---Draws shapes and text based on data provided in a table.
---@param tbl [PixelTable](#pixeltable)[] All instructions to run through
function Display.drawFromTable( tbl ) end

---Clears the display with the specified color.
---@param color Color|string? The color to clear the display with, in hexadecimal format. (If nil, It will clear the screen with the default color)
function Display.clear( color ) end

---Draw a line between two points with the specified color.
---@param x number The x-coordinate of the starting point.
---@param y number The y-coordinate of the starting point.
---@param x1 number The x-coordinate of the ending point.
---@param y1 number The y-coordinate of the ending point.
---@param color Color|string? The color of the line in hexadecimal format.
function Display.drawLine( x, y, x1, y1, color ) end

---Draws a circle with the specified center coordinates, radius, and color.
---@param x number The x-coordinate of the center of the circle.
---@param y number The y-coordinate of the center of the circle.
---@param radius number The radius of the circle.
---@param color Color|string? The color of the circle in hexadecimal format.
function Display.drawCircle( x, y, radius, color ) end

---Draws a filled circle with the specified center coordinates, radius, and color.
---@param x number The x-coordinate of the center of the circle.
---@param y number The y-coordinate of the center of the circle.
---@param radius number The radius of the circle.
---@param color Color|string? The color of the circle in hexadecimal format.
function Display.drawFilledCircle( x, y, radius, color ) end

---Draws a triangle with the specified vertices and color.
---@param x1 number The x-coordinate of the first vertex.
---@param y1 number The y-coordinate of the first vertex.
---@param x2 number The x-coordinate of the second vertex.
---@param y2 number The y-coordinate of the second vertex.
---@param x3 number The x-coordinate of the third vertex.
---@param y3 number The y-coordinate of the third vertex.
---@param color Color|string? The color of the triangle in hexadecimal format.
function Display.drawTriangle( x1, y1, x2, y2, x3, y3, color ) end

---Draws a filled triangle with the specified vertices and color.
---@param x1 number The x-coordinate of the first vertex.
---@param y1 number The y-coordinate of the first vertex.
---@param x2 number The x-coordinate of the second vertex.
---@param y2 number The y-coordinate of the second vertex.
---@param x3 number The x-coordinate of the third vertex.
---@param y3 number The y-coordinate of the third vertex.
---@param color Color|string? The color of the triangle in hexadecimal format.
function Display.drawFilledTriangle( x1, y1, x2, y2, x3, y3, color ) end

---Draws a rectangle with the specified position, width, height, and color.
---@param x number The x-coordinate of the top-left corner of the rectangle.
---@param y number The y-coordinate of the top-left corner of the rectangle.
---@param width number The width of the rectangle.
---@param height number The height of the rectangle.
---@param color Color|string? The color of the rectangle in hexadecimal format.
function Display.drawRect( x, y, width, height, color ) end

---Draws a filled rectangle with the specified position, width, height, and color.
---@param x number The x-coordinate of the top-left corner of the rectangle.
---@param y number The y-coordinate of the top-left corner of the rectangle.
---@param width number The width of the rectangle.
---@param height number The height of the rectangle.
---@param color Color|string? The color of the rectangle in hexadecimal format.
function Display.drawFilledRect( x, y, width, height, color ) end

---Draws text at the specified position with the specified color.
---@param x number The x-coordinate of the text.
---@param y number The y-coordinate of the text.
---@param string string The text to draw.
---@param color Color|string? The color of the text in hexadecimal format.
---@param fontName string? The font to use. (defaults to whatever the default font the font manager is using)
function Display.drawText( x, y, string, color, fontName ) end

---This optimizes the display but more at the extreme bound.
---**NOTE:** This is only meant to be called when you're not planning to update the display for a long time. Use it when it's generally going to be static.
function Display.optimize() end

---Retrieves the dimensions of the display.
---@return number width The width of the display
---@return number height The height of the display
function Display.getDimensions() end

---Hides the display.
function Display.hide() end

---Shows the display.
function Display.show() end

---Sets the render distance of the display.
---@param distance number The render distance to set.
function Display.setRenderDistance( distance ) end

---Enables or disables the touchscreen functionality.
---@param bool boolean True to enable touch screen, false to disable.
function Display.enableTouchScreen( bool ) end

---Retrieves touch data from the touch screen.
---@return Display.TouchData touchData A table containing touch data such as coordinates and touch state.
function Display.getTouchData() end

---Updates the display.
function Display.update() end

---Sets whether the display should automatically update.
---**Performance Note:** If you let's say draw a lot of things like rectangles, text, etc with this enabled. Your game would lag a LOT! And the network would be spammed with network requests! So please only use this when you're not going to draw a lot and your display doesn't get updated a lot!
---@param bool boolean True to enable auto-update, false to disable.
function Display.autoUpdate( bool ) end

---This function sets the optimization threshold of the display. Our displays optimize the effect count by grouping similar-colored pixels together into one larger effect. The integer (ranging between 0 and 1) dictates how similar the neighboring pixels' colors have to be, with 0 requiring them to be exactly the same RGB value and 1 allowing any RGB value.
---@param int number The optimization threshold to set.
function Display.setOptimizationThreshold( int ) end

---Calculate the text's bounding box
---@param text string The text to calculate its size.
---@return number The width that the text would consume
---@return number The height that the text would consume
function Display.calcTextSize( text ) end

---@class Drive
---A drive allows you to store anything* inside it. You can also go interact with it to modify its data there without doing it via code.
local Drive = {}

---Receive data from the drive
---@return table driveContents The contents of the drive
function Drive.load() end

---Saves data to the drive
---
---**NOTE:** You can only store data that JSON supports!
---@param data table The new data
function Drive.save( data ) end

---@class Hologram
---The hologram are like Displays but instead of being in 2D, its in 3D. You can show objects in 3D with this
local Hologram = {}

---@class Hologram.Object
local HologramObject = {}

---Gets the ID of the object
---@return integer id The ID of the object
function HologramObject.getId() end

---Gets the UUID of the object
---@return Uuid uuid The UUID of the object
function HologramObject.getUUID() end

---Gets the position of the object
---@return Vec3 position The position of the object
function HologramObject.getPosition() end

---Gets the rotation of the object
---@return Vec3 rotation The rotation of the object
function HologramObject.getRotation() end

---Gets the scale of the object
---@return Vec3 scale The scale of the object
function HologramObject.getScale() end

---Gets the color of the object
---@return Color color The color of the object
function HologramObject.getColor() end

---Sets the object’s UUID to be the argument.
---@param value string|Uuid The new UUID
function HologramObject.setUUID( value ) end

---Sets the object’s Position to be the argument.
---@param value Vec3 The new Position
function HologramObject.setPosition( value ) end

---Sets the object’s Rotation to be the argument.
---@param value Vec3 The new Rotation
function HologramObject.setRotation( value ) end

---Sets the object’s Scale to be the argument.
---@param value Vec3 The new Scale
function HologramObject.setScale( value ) end

---Sets the object’s Color to be the argument.
---@param value Color The new Color
function HologramObject.setColor( value ) end

---Deletes the object
function HologramObject.delete() end

---Returns true if the object has been deleted
---@return boolean isDeleted If true, the object is deleted and else it's false and it's NOT deleted.
function HologramObject.isDeleted() end

---Creates a cube object
---@param position Vec3 The position of the object
---@param rotation Vec3 The rotation of the object
---@param scale Vec3 The scale of the object
---@param color Color|string The color of the object
---@return Hologram.Object
function Hologram.createCube( position, rotation, scale, color ) end

---Creates a sphere object
---@param position Vec3 The position of the object
---@param rotation Vec3 The rotation of the object
---@param scale Vec3 The scale of the object
---@param color Color|string The color of the object
---@return Hologram.Object
function Hologram.createSphere( position, rotation, scale, color ) end

---Like createCube or createSphere but u can pass any kind of object from whatever loaded mod! (Via UUID)
---@param uuid Uuid The uuid of the object
---@param position Vec3 The position of the object
---@param rotation Vec3 The rotation of the object
---@param scale Vec3 The scale of the object
---@param color Color|string The color of the object
---@return Hologram.Object
function Hologram.createSphere( uuid, position, rotation, scale, color ) end

---@class Keyboard
---It’s like a virtual keyboard! You can interact with it and then type anything and the computer will be able to read it!
local Keyboard = {}

---Returns the latest keystroke that has been sent. If it is “backSpace”, that means the user has pressed “backSpace”
---@return "backSpace"|string keystroke The keystroke
function Keyboard.getLatestKeystroke() end

---Returns true if a key is being pressed.
---@return boolean isPressed True if a key is being pressed.
function Keyboard.isPressed() end

---@class Laser
---The Laser is like a normal scrap mechanic sensor but instead of ON or OFF, It provides more information which could be useful for things like Robot kinematics (More like Sensor-Enhanced Kinematics)
---
---Advanced users: This uses a ray cast for object detection, But this also means that there is an offset between the raycast’s starting point and the object itself. it’s small but this could cause issues with your math!
local Laser = {}

---@class Laser.LaserData
---This structure contains data that the laser has received
---@field directionWorld Vec3 The direction vector of the ray cast
---@field fraction number The fraction (0-1) of the distance reached until collision divided by the ray’s length
---@field normalLocal Vec3 The normal vector of the surface that was hit, relative to the target’s rotation.
---@field normalWorld Vec3 The normal vector of the hit surface
---@field originWorld Vec3 The starting world position of the raycast.
---@field pointLocal Vec3 The world position of the point that was hit, relative to the target’s position.
---@field pointWorld Vec3 The world position of the point that was hit.
---@field type string The physics type of the target that was hit. (See sm.physics.types)
---@field valid boolean Is true if the ray cast was even valid.

---Sets the distance
---@param distance number The new distance (In Meters!)
function Laser.setDistance( distance ) end

---Gets the data of the laser (Will send a ray cast!)
---@return boolean hit Is True if it hit something.
---@return Laser.LaserData data The laser data
function Laser.getLaserData() end

---@class Motor
---The motor allows you to control what the bearings and pistons should do.
local Motor = {}

---Sets the bearing(s) speed
---@param speed number The speed to set to bearing(s)
function Motor.setBearingSpeed( speed ) end

---Sets the piston(s) speed
---@param speed number The speed to set to piston(s)
function Motor.setPistonSpeed( speed ) end

---Sets the bearing(s) torque 
---@param torque number The torque  to set to bearing(s)
function Motor.setTorque( torque ) end

---Sets the piston(s) length
---@param length number The length to set to piston(s)
function Motor.setLength( length ) end

---Sets the piston(s) force
---@param force number The force to set to piston(s)
function Motor.setForce( force ) end

---@class NetworkPort
---The network port allows you to send data to other network ports.
local NetworkPort = {}

---Gets the connected antenna
---@return Antenna antenna The antenna if it is connected, else nil
function NetworkPort.getAntenna() end

---Returns true if there’s a connection.
---@return boolean hasConnection True if it has a connection
function NetworkPort.hasConnection() end

---Sends a packet to an Antenna or Network Port
---@param data any The contents of the packet. Doesn’t matter what the data is. can be a number or even a functio
function NetworkPort.sendPacket( data ) end

---Sends a packet to a specified antenna. (Antenna needs to be connected!)
---@param name string The antenna name.
---@param data any The contents of the packet. Doesn’t matter what the data is. can be a number or even a function!
function NetworkPort.sendPacketToAntenna( name, data ) end

---Gets the total packets.
---@return integer totalPackets The total packets it has to read through.
function NetworkPort.getTotalPackets() end

---Reads a packet
---**NOTE:** Check if there are any packets first! If there are none and you execute this, It will error!
---@return any packetData The content of the packet
function NetworkPort.receivePacket() end

---Clears the packets that it has to read through.
function NetworkPort.clearPackets() end

---@class Radar
---A target is an object detected from the radar
local Radar = {}

---@class Radar.Target
---A target is an object detected from the radar
---@field position Vec3 The position of the target
---@field surfaceArea number The total surface area that the radar can see

---Gets all the targets it has detected
---@return Radar.Target[] All targets it has found
function Radar.getTargets() end

---Sets its vertical angle from 10 to 90.
---@param angle number The angle to set
function Radar.setVerticalScanAngle( angle ) end

---Sets its horizontal  angle from 10 to 90.
---@param angle number The angle to set
function Radar.setHorizontalScanAngle( angle ) end

---@class SeatController
local SeatController = {}

---@class SeatController.SeatData
---Contains data on the seat.
---@field wsPower 1|0|-1 The power for WS. 1 = Forwards, 0 = None, -1 = Backwards
---@field adPower 1|0|-1 The power for AD. 1 = Left, 0 = None, -1 = Right
---@field characterName string? The characters name that is sitting.

---@class SeatController.JointData
---Contains data of a joint.
---@field leftSpeed number The left angle speed.
---@field rightSpeed number The right angle speed.
---@field leftLimit number The left angle limit.
---@field rightLimit number The right angle limit.
---@field bearingLock boolean Whether the joint is unlocked or not.

---Gets data from the connected seat
---@return SeatController.SeatData seatData The data of the seat
function SeatController.getSeatData() end

---Gets data from connected joints from the seat
---@return SeatController.JointData[] jointData The data of multiple joints
function SeatController.getJointData() end

---Presses a button connected to the seat
---@param index integer The button to press (0 to 9)
function SeatController.pressButton( index ) end

---Releases a button connected to the seat
---@param index integer The button to release  (0 to 9)
function SeatController.releaseButton( index ) end

---@deprecated This function is planned to be implemented but at the time is unusable!
---Sets the power for AD movement
---@param power 1|0|-1 The power for AD to set. 1 = Left, 0 = None, -1 = Right
function SeatController.setADPower( power ) end

---@deprecated This function is planned to be implemented but at the time is unusable!
---Sets the power for WS movement
---@param power 1|0|-1 power [ 1|0|-1 ] The power for WS. 1 = Forwards, 0 = None, -1 = Backwards
function SeatController.setWSPower( power ) end

---@class Speaker
---The speaker allows you to play ANY kind of sound and we mean ANYTHING!
local Speaker = {}

--- Play’s a beep sound
function Speaker.beep() end

--- Play’s a beep sound
---
---**NOTE:** This is going to be sent to the queue, Flush the queue to play it!
---@return integer index The index where the note is located in the queue.
function Speaker.beepQueue() end

---Play’s whatever note
---
---@param pitch number The pitch of the note
---@param note integer The note to play
---@param durationTicks integer The duration that it will play in ticks
function Speaker.playNote( pitch, note, durationTicks ) end

---Play’s whatever note
---
---**NOTE:** This is going to be sent to the queue, Flush the queue to play it!
---@param pitch number The pitch of the note
---@param note integer The note to play
---@param durationTicks integer The duration that it will play in ticks
---@return integer index The index where the note is located in the queue.
function Speaker.playNoteQueue( pitch, note, durationTicks ) end

---Plays whatever event effect you specify!
---@param name string The name of the audio to play
---@param params sc.audio.AudioParameter[] Audio parameters to use
---@param durationTicks integer The duration of how long it should play in ticks!
function Speaker.playNoteEffect( name, params, durationTicks ) end

---Plays whatever event effect you specify!
---
---**NOTE:** This is going to be sent to the queue, Flush the queue to play it!
---@param name string The name of the audio to play
---@param params sc.audio.AudioParameter[] Audio parameters to use
---@param durationTicks integer The duration of how long it should play in ticks!
---@return integer index The index where the note is located in the queue.
function Speaker.playNoteEffectQueue( name, params, durationTicks ) end

---Flushes the queue and plays all of them whatever it’s inside at ONCE!
function Speaker.flushQueue() end

---Remove a note from the queue
---@param noteIndex integer The index where the note is located
function Speaker.removeNote( noteIndex ) end

---Clears the entire queue
function Speaker.clearQueue() end

---Returns the size of the queue
---@return integer queueSize The size of the queue.
function Speaker.getCurrentQueueSize() end

---@class Terminal
---The terminal is like a display but more like a console you can write to, Instead of effects, it uses via GUI.
local Terminal = {}

---Sends a message to the terminal
---@param msg string The message to send
function Terminal.send( msg ) end

---Clears all data.
function Terminal.clear() end

---Clears the user's input history
function Terminal.clearInputHistory() end

---Returns true if there are available inputs.
---@return boolean hasReceivedInputs If true, then there are inputs you can read from.
function Terminal.receivedInputs() end

---Gets the latest user input
---@return string inputText The input that the user has entered.
function Terminal.getInput() end