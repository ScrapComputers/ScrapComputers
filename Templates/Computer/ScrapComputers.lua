---@diagnostic disable
---This file is for Developing computer code in Visual Studio code!

---Prints a message to the Debug Console.
---@param ... any[]
debug = function(...) end

---Prints a message to the Chat
---@param ... any[]
print = function(...) end

sc = {}

---Gets all connected displays
---@return DisplayComponent[]
sc.getDisplays = function() end

---Gets all connected Harddrives
---@return DriveComponent[]
sc.getDrives = function() end

---Gets all connected Hologram's
---@return HologramComponent[]
sc.getHolograms = function() end

---Gets all connected Terminal's
---@return TerminalComponent[]
sc.getTerminals = function() end

---Gets all connected Radar's
---@return RadarComponent[]
sc.getRadars = function() end

---Gets all connected network ports
---@return NetworkPortComponent[]
sc.getNetworkPorts = function() end

---Gets all connected camera's
---@return CameraComponent[]
sc.getCameras = function() end

---Gets all connected speakers's
---@return SpeakerComponent[]
sc.getSpeakers = function() end

---Gets all connected keyboard's
---@return KeyboardComponent[]
sc.getKeyboards = function() end

---Gets all connected motors
---@return MotorComponent[]
sc.getMotors = function() end

---Gets all connected lasers
---@return LaserComponent[]
sc.getLasers = function() end

---Gets all connected GPSs
---@return GPSComponent[]
sc.getGPSs = function() end

---Gets all connected SeatControllers
---@return SeatController[]
sc.getSeatControllers = function() end

---Gets the power of a input register
---@param str string The name of the input register
---@return number power The power that it's reciving.
sc.getReg = function(str) end

---Set's the power of a output register
---@param str string The name of the output register
---@param power number The new power.
sc.setReg = function(str, power) end

---COMPONENTS --

---@class MotorComponent
local MOTOR_COMPONENT = {}

---Sets the bearing(s) speed
---@param speed number The speed to set to bearing(s)
MOTOR_COMPONENT.setBearingSpeed = function(speed) end

---Sets the piston(s) speed
---@param speed number The speed to set to piston(s)
MOTOR_COMPONENT.setPistonSpeed = function(speed) end

---Sets the bearing(s) torque
---@param torque number The torque to set to bearing(s)
MOTOR_COMPONENT.setTorque = function(torque) end

---Sets the pistin(s) length
---@param length number The length to set to piston(s)
MOTOR_COMPONENT.setLength = function(length) end

---Sets the piston(s) force
---@param force any
MOTOR_COMPONENT.setForce = function(force) end

---@class KeyboardComponent
local KEYBOARD_COMPONENT = {}

---Returns the latest keystroke that has been sended. if its "backSpace", That means the user has pressed "backSpace"
---@return "backSpace"|string keystroke The keystroke
KEYBOARD_COMPONENT.getLatestKeystroke = function() end

---Returns true if a key has been pressed.
---@return boolean keyPressed True if a key has been pressed
KEYBOARD_COMPONENT.isPressed = function() end

---@class SpeakerComponent
local SPEAKER_COMPONENT = {}

---Plays a beep sound
SPEAKER_COMPONENT.beep = function() end

---Plays a beep sound
---NOTE: This won't actually play! it is added to a queue so u have to flush the queue to play it!
---@return interger beepIndex The index where the note is located in the queue.
SPEAKER_COMPONENT.beepQueue = function() end

---Plays whatever note
---@param pitch number The pitch of the note
---@param note interger The note to play
---@param durationTicks interger The duration that it will play in ticks
SPEAKER_COMPONENT.playNote = function(pitch, note, durationTicks) end

---Plays whatever note
---NOTE: This won't actually play! it is added to a queue so u have to flush the queue to play it!
---@param pitch number The pitch of the note
---@param note interger The note to play
---@param durationTicks interger The duration that it will play in ticks
---@return interger beepIndex The index where the note is located in the queue.
SPEAKER_COMPONENT.playNoteQueue = function(pitch, note, durationTicks) end

---Plays whatever event effect you specify!
---@param name string The name of the audio to play
---@param params sc.audio.AudioParameter[] Audio parameters to use
---@param durationTicks interger The duration of how long it should play in ticks!
SPEAKER_COMPONENT.playNoteEffect = function(name, params, durationTicks) end

---Plays whatever event effect you specify!
---NOTE: This won't actually play! it is added to a queue so u have to flush the queue to play it!
---@param name string The name of the audio to play
---@param params sc.audio.AudioParameter[] Audio parameters to use
---@param durationTicks interger The duration of how long it should play in ticks!
---@return interger beepIndex The index where the queue is located.
SPEAKER_COMPONENT.playNoteEffectQueue = function(name, params, durationTicks) end

---Flushes the queue and plays all of them whatever it's inside at ONCE!
SPEAKER_COMPONENT.flushQueue = function() end

---Removes a note from the queue
---@param noteIndex number The index where the note is located
SPEAKER_COMPONENT.removeNote = function(noteIndex) end

---Clears the entire queue
SPEAKER_COMPONENT.clearQueue = function() end

---Returns the size of the queue
---@return number queueSize The size of the queue.
SPEAKER_COMPONENT.getCurrentQueueSize = function() end

---Stops all audio that are playing
SPEAKER_COMPONENT.stopAllAudio = function() end

---@class CameraComponent
local CAMERA_COMPONENT = {}

---Takes a frame and returns it
---@param width integer The width of the frame
---@param height integer The height of the frame
---@param fovX number The FOV on x-axis
---@param fovY number The FOV on y-axis
---@param xOffset integer The applied x offset for the frame. By default it's at 0 so at the top, it would be rendered there
---@param yOffset integer The applied y offset for the frame. By default it's at 0 so at the left, it would be rendered there
---@return table PixelTable The pixels of the frame
CAMERA_COMPONENT.getFrame = function(width, height, fovX, fovY, xOffset, yOffset) end

---Takes a depth map and returns it
---@param width integer The width of the frame
---@param height integer The height of the frame
---@param fovX number The FOV on x-axis
---@param fovY number The FOV on y-axis
---@param focalLength interger The focal's length
---@param xOffset integer The applied x offset for the frame. By default it's at 0 so at the top, it would be rendered there
---@param yOffset integer The applied y offset for the frame. By default it's at 0 so at the left, it would be rendered there
---@return table PixelTable The pixels of the frame
CAMERA_COMPONENT.getDepthMap = function(width, height, fovX, fovY, focalLength, xOffset, yOffset) end

---Like getFrame but its as slices meaning you could actually make CCTV cameras without lagging a lot! Its just that
---the refresh rate would be lower.
---@param width integer The width of the frame
---@param height integer The height of the frame
---@param fovX number The FOV on x-axis
---@param fovY number The FOV on y-axis
---@param sliceWidth interger The width for each slice
---@param xOffset integer The applied x offset for the frame. By default it's at 0 so at the top, it would be rendered there
---@param yOffset integer The applied y offset for the frame. By default it's at 0 so at the left, it would be rendered there
---@return table PixelTable The pixels of the frame
CAMERA_COMPONENT.getVideo = function(width, height, fovX, fovY, sliceWidth, xOffset, yOffset) end

---Takes a frame and returns it
---
---<h3>This does raytracing! at a cost of performance!</h3>
---
---@param width integer The width of the frame
---@param height integer The height of the frame
---@param fovX number The FOV on x-axis
---@param fovY number The FOV on y-axis
---@param xOffset integer The applied x offset for the frame. By default it's at 0 so at the top, it would be rendered there
---@param yOffset integer The applied y offset for the frame. By default it's at 0 so at the left, it would be rendered there
---@return table PixelTable The pixels of the frame
CAMERA_COMPONENT.getAdvancedFrame = function(width, height, fovX, fovY, xOffset, yOffset) end

---Like getFrame but its as slices meaning you could actually make CCTV cameras without lagging a lot! Its just that
---the refresh rate would be lower.
---
---<h3>This does raytracing! at a cost of performance!</h3>
---
---@param width integer The width of the frame
---@param height integer The height of the frame
---@param fovX number The FOV on x-axis
---@param fovY number The FOV on y-axis
---@param sliceWidth interger The width for each slice
---@param xOffset integer The applied x offset for the frame. By default it's at 0 so at the top, it would be rendered there
---@param yOffset integer The applied y offset for the frame. By default it's at 0 so at the left, it would be rendered there
---@return table PixelTable The pixels of the frame
CAMERA_COMPONENT.getAdvancedVideo = function(width, height, fovX, fovY, sliceWidth, xOffset, yOffset) end

---Toggles the random pixel shader
---@param toggle boolean Enabled or disabled.
CAMERA_COMPONENT.toggleRandom = function(toggle) end

---@class AntennaComponent
local ANTENNA_COMPONENT = {}

---Gets the name of the antenna
---@return string antennaName The name of the antenna
ANTENNA_COMPONENT.getName = function() end

---Sets the name of the antenna
---@param name string The new name of the antenna
ANTENNA_COMPONENT.setName = function(name) end

---Returns true if theres a connection with another antenna.
---@return boolean antennaHasConnection True if it has a connection
ANTENNA_COMPONENT.hasConnection = function() end

---Gets all antenna's of the entire world
---@return string[] scannedAntennas All discovered antennas
ANTENNA_COMPONENT.scanAntennas = function() end

---@class NetworkPortComponent
local NETWORKPORT_COMPONENT = {}

---Gets the connected antenna
---@return AntennaComponent? antenna The antenna if it is connected, else nil
NETWORKPORT_COMPONENT.getAntenna = function() end

---Returns true if theres a connection.
---@return boolean networkPortHasConnection True if it has a connection.
NETWORKPORT_COMPONENT.hasConnection = function() end

---Sends a packet to a Antenna or Network Port
---@param data any The contents of the packet. Doesn't matter what the data is. can be a number or even a function!
NETWORKPORT_COMPONENT.sendPacket = function(data) end

---Sends a packet to a specified antenna. (Antenna needs to be connected!)
---@param name string The antenna name.
---@param data any The contents of the packet. Doesn't matter what the data is. can be a number or even a function!
NETWORKPORT_COMPONENT.sendPacketToAntenna = function(name, data) end

---Gets the total packets.
---@return integer totalPackets The total packets it has to read through.
NETWORKPORT_COMPONENT.getTotalPackets = function() end

---Reads a packet
---
---NOTE: Please check if theres any packets! If there are none and you execute this, It will error!
---@return any packetData The content's of the packet
NETWORKPORT_COMPONENT.receivePacket = function() end

---Clears the packets that it has to read through.
NETWORKPORT_COMPONENT.clearPackets = function() end

---@class RadarComponent.Target
local RADAR_COMPONENT_TARGET = {}

RADAR_COMPONENT_TARGET.position = sm.vec3.zero() ---The position of the target
RADAR_COMPONENT_TARGET.surfaceArea = 0 ---The total surface area that the radar can see

---@class RadarComponent
local RADAR_COMPONENT = {}

---Gets all targets it has detected
---@return RadarComponent.Target[] All targets it has found
RADAR_COMPONENT.getTargets = function() end

---Set's it's vertical angle from 10 to 90.
---@param angle number The angle to set
RADAR_COMPONENT.setVerticalScanAngle = function(angle) end

---Set's it's horizontal angle from 10 to 90.
---@param angle number The angle to set
RADAR_COMPONENT.setHorizontalScanAngle = function(angle) end

---@class TerminalComponent
local TERMINAL_COMPONENT = {}

---Sends a message to the terminal.
---@param msg string
TERMINAL_COMPONENT.send = function(msg) end

---Clears all data.
TERMINAL_COMPONENT.clear = function() end

---Clears the userinput.
TERMINAL_COMPONENT.clearInputHistory = function() end

---Returns true if theres available inputs.
---@return boolean hasInputs If true, then there are inputs you can read from.
TERMINAL_COMPONENT.receivedInputs = function() end

---Gets the latest user input.
---
---**NOTE: Please check if theres any inputs before using this, It will cause a error if theres no user inputs available!**
---@return string inputString The input that the user has entered.
TERMINAL_COMPONENT.getInput = function() end

---@class HologramObject
local HOLOGRAM_COMPONENT_OBJECT = {}

---Gets the ID of the object
---@return number id The ID of the object
HOLOGRAM_COMPONENT_OBJECT.getId = function() end

---Gets the UUID of the object
---@return Uuid uuid The UUID of the object
HOLOGRAM_COMPONENT_OBJECT.getUUID = function() end

---Gets the Position of the object
---@return Vec3 position The Position of the object
HOLOGRAM_COMPONENT_OBJECT.getPosition = function() end

---Gets the Rotation of the object
---@return Quat rotation The Rotation of the object
HOLOGRAM_COMPONENT_OBJECT.getRotation = function() end

---Gets the Scale of the object
---@return Vec3 scale The Scale of the object
HOLOGRAM_COMPONENT_OBJECT.getScale = function() end

---Gets the Color of the object
---@return Color color The Color of the object
HOLOGRAM_COMPONENT_OBJECT.getColor = function() end

---Sets the object's UUID to be the argument.
---@param value string|Uuid The new UUID
HOLOGRAM_COMPONENT_OBJECT.setUUID = function(value) end

---Sets the object's Position to be the argument.
---@param value Vec3 The new Position
HOLOGRAM_COMPONENT_OBJECT.setPosition = function(value) end

---Sets the object's Position to be the argument.
---@param value Quat The new Position
HOLOGRAM_COMPONENT_OBJECT.setRotation = function(value) end

---Sets the object's Position to be the argument.
---@param value Vec3 The new Position
HOLOGRAM_COMPONENT_OBJECT.setScale = function(value) end

---Sets the object's Color to be the argument.
---@param value Color The new Color
HOLOGRAM_COMPONENT_OBJECT.setColor = function(value) end

---Deletes the object
HOLOGRAM_COMPONENT_OBJECT.delete = function() end

---Returns true if the object has been de;eted
---@return boolean beenDeleted If true, the object is deleted. else its false and its NOT deleted.
HOLOGRAM_COMPONENT_OBJECT.isDeleted = function() end

---@class HologramComponent
local HOLOGRAM_COMPONENT = {}

---Creates a cube object
---@param position Vec3 The position of the object
---@param rotation Vec3 The rotation of the object
---@param scale Vec3 The scale of the object
---@param color Color|string The color of the object
---@return integer id The id of the object
HOLOGRAM_COMPONENT.createCube = function(position, rotation, scale, color) end

---Creates a sphere object
---@param position Vec3 The position of the object
---@param rotation Vec3 The rotation of the object
---@param scale Vec3 The scale of the object
---@param color Color|string The color of the object
---@return integer id The id of the object
HOLOGRAM_COMPONENT.createSphere = function(position, rotation, scale, color) end

---Like createCube or createSphere but u can pass any kind of object from whatever loaded mod! (Via UUID)
---@param uuid Uuid The uuid of the object
---@param position Vec3 The position of the object
---@param rotation Vec3 The rotation of the object
---@param scale Vec3 The scale of the object
---@param color Color|string The color of the object
---@return integer id The id of the object
HOLOGRAM_COMPONENT.createCustomObject = function(uuid, position, rotation, scale, color) end

---Gets the object via Object id and returns a table containing the data of that object or nil since it dosen't exist.
---@param index number The object u wanna get its data.
---@return HologramObject? object Ether u get a table (so the object exists) or nil (so the object dose NOT exist)
HOLOGRAM_COMPONENT.getObject = function(index) end

---@class DriveComponent
local DRIVE_COMPONENT = {}
---Receive data from the drive
---@return table driveContents The contents of the drive.
DRIVE_COMPONENT.load = function() end

---Saves data to the drive
---@param data table The new data
DRIVE_COMPONENT.save = function(data) end

---@class DisplayComponent
local DISPLAY_COMPONENT = {}

----Draws a single pixel at the specified coordinates with the given color.
---@param x number The x-coordinate of the pixel.
---@param y number The y-coordinate of the pixel.
---@param color string|Color The color of the pixel in hexadecimal format.
DISPLAY_COMPONENT.drawPixel = function(x, y, color) end

----Draws shapes and text based on data provided in a table.
---@param tbl table A table containing drawing commands and parameters.
DISPLAY_COMPONENT.drawFromTable = function(tbl) end

----Clears the display with the specified color.
---@param color string|Color? The color to clear the display with, in hexadecimal format. (If nil, It will clear the screen with defualt color)
DISPLAY_COMPONENT.clear = function(color) end

----Draws a line between two points with the specified color.
---@param x number The x-coordinate of the starting point.
---@param y number The y-coordinate of the starting point.
---@param x1 number The x-coordinate of the ending point.
---@param y1 number The y-coordinate of the ending point.
---@param color string|Color The color of the line in hexadecimal format.
DISPLAY_COMPONENT.drawLine = function(x, y, x1, y1, color) end

----Draws a circle with the specified center coordinates, radius, and color.
---@param x number The x-coordinate of the center of the circle.
---@param y number The y-coordinate of the center of the circle.
---@param radius number The radius of the circle.
---@param color string|Color The color of the circle in hexadecimal format.
DISPLAY_COMPONENT.drawCircle = function(x, y, radius, color) end

----Draws a filled circle with the specified center coordinates, radius, and color.
---@param x number The x-coordinate of the center of the circle.
---@param y number The y-coordinate of the center of the circle.
---@param radius number The radius of the circle.
---@param color string|Color The color of the circle in hexadecimal format.
DISPLAY_COMPONENT.drawFilledCircle = function(x, y, radius, color) end

----Draws a triangle with the specified vertices and color.
---@param x1 number The x-coordinate of the first vertex.
---@param y1 number The y-coordinate of the first vertex.
---@param x2 number The x-coordinate of the second vertex.
---@param y2 number The y-coordinate of the second vertex.
---@param x3 number The x-coordinate of the third vertex.
---@param y3 number The y-coordinate of the third vertex.
---@param color string|Color The color of the triangle in hexadecimal format.
DISPLAY_COMPONENT.drawTriangle = function(x1, y1, x2, y2, x3, y3, color) end

----Draws a filled triangle with the specified vertices and color.
---@param x1 number The x-coordinate of the first vertex.
---@param y1 number The y-coordinate of the first vertex.
---@param x2 number The x-coordinate of the second vertex.
---@param y2 number The y-coordinate of the second vertex.
---@param x3 number The x-coordinate of the third vertex.
---@param y3 number The y-coordinate of the third vertex.
---@param color string|Color The color of the triangle in hexadecimal format.
DISPLAY_COMPONENT.drawFilledTriangle = function(x1, y1, x2, y2, x3, y3, color) end

----Draws a rectangle with the specified position, width, height, and color.
---@param x number The x-coordinate of the top-left corner of the rectangle.
---@param y number The y-coordinate of the top-left corner of the rectangle.
---@param width number The width of the rectangle.
---@param height number The height of the rectangle.
---@param color string|Color The color of the rectangle in hexadecimal format.
DISPLAY_COMPONENT.drawRect = function(x, y, width, height, color) end

----Draws a filled rectangle with the specified position, width, height, and color.
---@param x number The x-coordinate of the top-left corner of the rectangle.
---@param y number The y-coordinate of the top-left corner of the rectangle.
---@param width number The width of the rectangle.
---@param height number The height of the rectangle.
---@param color string|Color The color of the rectangle in hexadecimal format.
DISPLAY_COMPONENT.drawFilledRect = function(x, y, width, height, color) end

----Draws text at the specified position with the specified color.
---@param x number The x-coordinate of the text.
---@param y number The y-coordinate of the text.
---@param string string The text to draw.
---@param color string|Color The color of the text in hexadecimal format.
---@param fontName string? The font to use. (defaults to whatever the default font the fontmanager is using)
DISPLAY_COMPONENT.drawText = function(x, y, string, color, fontName) end

----Optimizes the display.
DISPLAY_COMPONENT.optimize = function() end

----Retrieves the dimensions of the display.
---@return number,number displayDimensions A table containing the width and height of the display.
DISPLAY_COMPONENT.getDimensions = function() end

----Hides the display.
DISPLAY_COMPONENT.hide = function() end

----Shows the display.
DISPLAY_COMPONENT.show = function() end

----Sets the render distance of the display.
---@param distance number The render distance to set.
DISPLAY_COMPONENT.setRenderDistance = function(distance) end

----Enables or disables the touch screen functionality.
---@param bool boolean True to enable touch screen, false to disable.
DISPLAY_COMPONENT.enableTouchScreen = function(bool) end

---Data for touchscreen
---@class DisplayComponent.TouchData
---@field x number The position on the x-axis.
---@field y number The position on the y-axis.
---@field state 1|2|3 The state that it has been pressed. 1 is Pressed, 2 is Hold, 3 is Released.

----Retrieves touch data from the touch screen.
---@return DisplayComponent.TouchData touchData A table containing touch data such as coordinates and touch state.
DISPLAY_COMPONENT.getTouchData = function() end

----Updates the display to the extreme.
DISPLAY_COMPONENT.update = function() end

----Sets whether the display should automatically update.
---@param bool boolean True to enable auto-update, false to disable.
DISPLAY_COMPONENT.autoUpdate = function(bool) end

----Sets the optimization threshold for the display.
---@param int number The optimization threshold to set.
DISPLAY_COMPONENT.setOptimizationThreshold = function(int) end

---Calculates the size that the string would use
---@param text string The text to calculate it's size.
---@return number, number
DISPLAY_COMPONENT.calcTextSize = function(text) end

---@class LaserComponent
local LASER_COMPONENT = {}

---Sets the distance
---@param distance number The new distance
LASER_COMPONENT.setDistance = function(distance) end

---Data for laser
---@class LaserComponent.LaserData
---@field directionWorld Vec3 The direction vector of the raycast
---@field fraction number The fraction (0-1) of the distance reached until collision divided by the ray's length
---@field normalLocal Vec3 The normal vector of the surface that was hit, relative to the tarGets rotation.
---@field normalWorld Vec3 The normal vector of the hit surface
---@field originWorld Vec3 The starting world position of the raycast.
---@field pointLocal Vec3 The world position of the point that was hit, relative to the tarGets position.
---@field pointWorld Vec3 The world position of the point that was hit.
---@field type string The physics type of the target that was hit. (See [sm.physics.types])
---@field valid boolean Is true if the raycast was even valid.

---Gets the data of the laser (Will send a raycast!)
---@return boolean hit Is True if it hitted someting.
---@return LaserComponent.LaserData laserData The laser data
LASER_COMPONENT.getLaserData = function() end 

---@class GPSComponent
local GPS_COMPONENT = {}

---Data for GPS
---@class GPSComponent.GPSData
---@field worldPosition Vec3 The world position
---@field worldRotation Quat The world rotation
---@field bearing number The bearing rotation (Degrees!)
---@field velocity Vec3 The velocity
---@field speed number The speed
---@field forwardVelocity number The forwards velocity
---@field horizontalVelocity number The horizontal velocity
---@field verticalVelocity number The vertical velocity
---@field acceleration number The acceleration
---@field forwardAcceleration number The forwards acceleration
---@field horizontalAcceleration number The horizontal acceleration
---@field verticalAcceleration number The vertical acceleration

---Gets GPS Data
---@return GPSComponent.GPSData gpsData The GPS Data
GPS_COMPONENT.getGPSData = function() end

---@class SeatController
local SEATCONTROLLER_COMPONENT = {}

---@class SeatController.SeatData
---@field wsPower 1|0|-1 The power for WS. 1 = Forwards, 0 = None, -1 = Backwards
---@field adPower 1|0|-1 The power for AD. 1 = Left, 0 = None, -1 = Right
---@field characterName string? The character's name that is sitting.

---Gets data from the connected seat
---@return SeatController.SeatData
SEATCONTROLLER_COMPONENT.getSeatData = function() end

---@class SeatController.JointData
---@field leftSpeed number The left angle speed.
---@field rightSpeed number The right angle speed.
---@field leftLimit number The left angle limit.
---@field rightLimit number The right angle limit.
---@field bearingLock boolean Whether the joint is unlocked or not.

-- Gets data from connected joints from the seat
---@return SeatController.JointData[]
SEATCONTROLLER_COMPONENT.getJointData = function() end

---Presses a button connected from the seat
---@param index number The button to press (0 to 9)
SEATCONTROLLER_COMPONENT.pressButton = function (index) end

---Releases a button connected from the seat
---@param index number The button to release (0 to 9)
SEATCONTROLLER_COMPONENT.releaseButton = function (index) end

---@deprecated This function is planned to be implemented however SM sucks! At the time we think that its because 2 scripts are slaughtering them together. 1 wants to make a variable like this and other like this. Its like Battleroyal but with Lua and its handeled like actual dog poop!
---@deprecated
---@deprecated When it was implemented, afther 1 commit. The next commit was named: `Removed WS and AD power set because sm is dumb`. We hate this!
---Sets the power for AD movement
---@param power 1|0|-1 The power for AD to set. 1 = Left, 0 = None, -1 = Right
SEATCONTROLLER_COMPONENT.setADPower = function (power) end

---@deprecated This function is planned to be implemented however SM sucks! At the time we think that its because 2 scripts are slaughtering them together. 1 wants to make a variable like this and other like this. Its like Battleroyal but with Lua and its handeled like actual dog poop!
---@deprecated
---@deprecated When it was implemented, afther 1 commit. The next commit was named: `Removed WS and AD power set because sm is dumb`. We hate this!
---Sets the power for WS movement
---@param power 1|0|-1 The power for WS. 1 = Forwards, 0 = None, -1 = Backwards
SEATCONTROLLER_COMPONENT.setWSPower = function (power) end

---SC MODULES --

---Additional JSON features that sm.json dosen't have.
sc.json = {}

---Returns a boolean to see if the root (table) is vaild and dosent cause a crash when u use it in functions
---@param root table
---@return boolean
sc.json.isSafe = function(root) end

---Converts a lua table to a json string. This is the reccommended function as it provides more features and security
---@param root table         The table to be converted to.
---@param prettify boolean   If true, The output would have indentation.
---@param indent string?     The character used for the indentation. Default is a tab.
---@return string JSONString The JSON string generated from the table
sc.json.toString = function (root, prettify, indent) end

---Converts a json string to a lua table. This is the reccommended function as it provides more features and security
---@param root string The JSON string
---@return table TableFromJSONString The table that was generated from the JSON string
sc.json.toTable = function (root) end

---Additional features that sm.color dosen't have
sc.color = {}

---Generates a random color.
---@param from number The starting range
---@param to number The ending range
---@return Color color The generated color
sc.color.random = function(from, to) end

---Generates a random color. (0 to 1 as a float)
---@return Color color The generated color
sc.color.random0to1 = function() end

---A function like sm.color.new but its 1 argument.
---Its just simply sm.color.new(rgbNum, rgbNum, rgbNum) and also why its called "newSingluar".
---@param rgbNum number The value to be on R, G and B.
---@return Color color The generated color
sc.color.newSingluar = function(rgbNum) end

---This is a manager for the Audio json file for ScrapComputers
sc.audio = {}

---Returns all audio's that u can use.
---@return string[]
function sc.audio.getAudioNames() end

---Returns true if the name exists.
---
---<h2>NOTE: The name must be full path! else it will NOT work!</h2>
---@param name string The name of the audio (FULL ONLY!)
---@return boolean audioExists If true, the name that was passed did exist as audio. else false (Doesn't exist)
function sc.audio.exists(name) end

---@class sc.audio.AudioParameter
---@field default number The default value of the Parameter
---@field maximum number The maximum value of the Parameter
---@field minimum number The minimum value of the Parameter

---This will return the parameters you can set by the audio name
---@param name string The name of the audio to get it's paramters
---@return sc.audio.AudioParameter[]?
function sc.audio.getParams(name) end

---@class sc.audio.ParamsIncorrectTable
---@field hasNoParamsUsableIssue boolean If true, then this audio doesn't have any paramaters.
---@field issues string[][] Contains all issues that have issue with the parameters

---This will return the parameters you can set by the audio name
---@param name string The name of the audio to get it's paramters
---@param params sc.audio.AudioParameter[] The paramaters of the audio that it will contain
---@return sc.audio.ParamsIncorrectTable? validAudioParamaters If nil, then all of your paramters are valid. Else its a table that will contain the issues
function sc.audio.areParamsCorrect(name, params) end

---Base64 Encoder/Decoder module
sc.base64 = {}

---Convert's a string to base64 string.
---@param data string The data to be converted to.
---@return string base64Data The data in base64

sc.base64.encode = function(data) end
---Convert's a base64 string to raw string.
---@param data string The data to be converted to.
---@return string base64Data The data from the conversion.
sc.base64.decode = function(data) end

---MD5 Encryption module
sc.md5 = {}

---@class sc.md5.Stream
local MD5_Module_Stream = {}
MD5_Module_Stream.a = 0x67452301
MD5_Module_Stream.b = 0xefcdab89
MD5_Module_Stream.c = 0x98badcfe
MD5_Module_Stream.d = 0x10325476
MD5_Module_Stream.pos = 0
MD5_Module_Stream.buf = ''

---Adds additonal data to the stream
---@param data string The additional data
MD5_Module_Stream.update = function(data) end

---Finishes the stream.
---@return string streamResult The output of the stream of the buffer
MD5_Module_Stream.finish = function() end

---Creates a fresh strean.
---@return sc.md5.Stream MD5Stream The stream
function sc.md5.new() end

---Converts MD5-Raw-Bytes String to a MD5-Encrypted String
---@param rawBytes string The raw bytes
---@return string MD5EncryptedString The MD5-Encrypted string
function sc.md5.tohex(rawBytes) end

---Converts a string to a MD5-Raw-Bytes String
---@param str string The string
---@return string MD5RawBytes The MD5-Raw-Bytes String string
function sc.md5.sum(str) end

---Converts string to a MD5-Encrypted String
---@param str string The string
---@return string MD5EncryptedString The MD5-Encrypted string
function sc.md5.sumhexa(str) end

---SHA256 Encryption Module
sc.sha256 = {}

---Converts a string to a SHA256 string
---@param str string The string to be converted
---@return string base64String The string in Base64
function sc.sha256.encode(str) end

---Math Module
sc.math = {}

---Clamps value.
---@param value number The value to be clamped
---@param min number The lowest allowed number
---@param max number The highest allowed number
---@return number clampedValue The clamped value.
sc.math.clamp = function (value, min, max) end

--Additonal features for table's.
sc.table = {}

---Clones a table
---@param tbl table The table to clone
---@return table clonedTable The cloned table
sc.table.clone = function (tbl) end

---Gets a element from table, Unlike `tbl[index]` If like the starting element has index 2, doing `tbl[1]` won't work. This fixes that issue.
---@param tbl table The table
---@param index number The index to look at
---@return any item The item from the table. nil if it wasen't found or is like that
sc.table.getItemAt = function(tbl, index) end

---Gets the total elements from a table. Unlike doing #tbl, If the table wasen't using number's as index. the # wouldn't get anything but return 0. This fixes that issue.
---@param tbl table The table
---@return number tableSize The size of the table
sc.table.getTotalItems = function(tbl) end

---Like sc.table.getTotalItems but works with dictonaries.
---@param tbl table The dictionary table
---@return number dictionaryTableSize The size of the dictionary
sc.table.getTotalItemsDict = function(tbl) end

---Merges 2 tables into 1
---@param table1 table The 1st table
---@param table2 table The 2nd table
---@return table mergedTable The merged table
sc.table.merge = function(table1, table2) end

---Converts a table to a lua table string
---@param tbl table The table
---@return string luaTableStr The lua table as string.
sc.table.toString = function(tbl) end

---Additional features that sm.util dosen't have.
sc.util = {}

---Gets the remainder of division. This function is more safer than sm.util.postiveModule as for some reason, Scrap Mechanic
---dosent handle division by 0 for sm.util.postiveModule so it crashes.
---@param a number Number to divide
---@param b number The amount to divide
---@return number The divided number
sc.util.postiveModulo = function (a, b) end

---Additional features that sm.vec3 dosen't have
sc.vec3 = {}

---A function like sm.vec3.new but its 1 argument.
---
---Its just simply sm.vec3.new(xyzNum, xyzNum, xyzNum) and also why its called "newSingluar".
---@param xyzNum number The value for xyz.
---@return Vec3 newVec3 The new vector3
sc.vec3.newSingluar = function (xyzNum) end

---Returns a new vector3 with the added numbers
---@param vec3 Vec3 The vector to modify
---@param x number The value to add for vec3.x
---@param y number The value to add for vec3.y
---@param z number The value to add for vec3.z
---@return Vec3 newVec3 The new vector3
sc.vec3.add = function(vec3, x, y, z) end

---Returns a new vector3 with the subtracted numbers
---@param vec3 Vec3 The vector to modify
---@param x number The value to subtract for vec3.x
---@param y number The value to subtract for vec3.y
---@param z number The value to subtract for vec3.z
---@return Vec3 newVec3 The new vector3
sc.vec3.subtract = function(vec3, x, y, z) end

---Returns a new vector3 with the divided numbers
---@param vec3 Vec3 The vector to modify
---@param x number The value to divide for vec3.x
---@param y number The value to divide for vec3.y
---@param z number The value to divide for vec3.z
---@return Vec3 newVec3 The new vector3
sc.vec3.divide = function(vec3, x, y, z) end

---Returns a new vector3 with the multiplied numbers
---@param vec3 Vec3 The vector to modify
---@param x number The value to mulitply for vec3.x
---@param y number The value to mulitply for vec3.y
---@param z number The value to mulitply for vec3.z
---@return Vec3 newVec3 The new vector3
sc.vec3.mulitply = function(vec3, x, y, z) end

---Gets the distance between 2 vector's.
---@param vec1 Vec3 The first point
---@param vec2 Vec3 The seccond point
---@return number distance The distance between the 2 vector3's.
sc.vec3.distance = function (vec1, vec2) end

-- This manages SCF (ScrapComputers Font) font's. They are used in displays.
sc.fontmanager = {}

-- Gets a font.
---@return SCFont? font The font
---@return string? errorMsg Tells you a error message if there is a error
function sc.fontmanager.getFont(fontName) end

-- Gets all fonts and return's there names
---@return string[] fontNames All font name's
function sc.fontmanager.getFontNames() end

-- Returns the default font name used.
---@return string font The font name that is used by default.
function sc.fontmanager.getDefaultFontName() end

-- Returns the default font used.
---@return SCFont font The font that is used by default.
function sc.fontmanager.getDefaultFont() end

---@class SCFont
---@field fontWidth integer The width of the font
---@field fontHeight integer The height of the font
---@field characters string All characters used on the font
---@field errorChar string[] The error character font
---@field charset string[][] All character's gylphs. On the first array. The index is the character! The seccond is the row number!
