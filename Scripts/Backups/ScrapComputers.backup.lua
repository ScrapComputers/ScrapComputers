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
---@param params sm.scrapcomputers.audio.AudioParameter[] Audio parameters to use
---@param durationTicks interger The duration of how long it should play in ticks!
SPEAKER_COMPONENT.playNoteEffect = function(name, params, durationTicks) end

---Plays whatever event effect you specify!
---NOTE: This won't actually play! it is added to a queue so u have to flush the queue to play it!
---@param name string The name of the audio to play
---@param params sm.scrapcomputers.audio.AudioParameter[] Audio parameters to use
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
---@param xOffset integer? The applied x offset for the frame. By default it's at 0 so at the top, it would be rendered there
---@param yOffset integer? The applied y offset for the frame. By default it's at 0 so at the left, it would be rendered there
---@return table PixelTable The pixels of the frame
CAMERA_COMPONENT.getFrame = function(width, height, fovX, fovY, xOffset, yOffset) end

---Takes a depth map and returns it
---@param width integer The width of the frame
---@param height integer The height of the frame
---@param fovX number The FOV on x-axis
---@param fovY number The FOV on y-axis
---@param focalLength interger The focal's length
---@param xOffset integer? The applied x offset for the frame. By default it's at 0 so at the top, it would be rendered there
---@param yOffset integer? The applied y offset for the frame. By default it's at 0 so at the left, it would be rendered there
---@return table PixelTable The pixels of the frame
CAMERA_COMPONENT.getDepthMap = function(width, height, fovX, fovY, focalLength, xOffset, yOffset) end

---Like getFrame but its as slices meaning you could actually make CCTV cameras without lagging a lot! Its just that
---the refresh rate would be lower.
---@param width integer The width of the frame
---@param height integer The height of the frame
---@param fovX number The FOV on x-axis
---@param fovY number The FOV on y-axis
---@param sliceWidth interger The width for each slice
---@param xOffset integer? The applied x offset for the frame. By default it's at 0 so at the top, it would be rendered there
---@param yOffset integer? The applied y offset for the frame. By default it's at 0 so at the left, it would be rendered there
---@return table PixelTable The pixels of the frame
CAMERA_COMPONENT.getVideo = function(width, height, fovX, fovY, sliceWidth, xOffset, yOffset) end

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

---@class RadarComponent.Results.Shape
local RADAR_COMPONENT_RESULTS_SHAPE = {}

RADAR_COMPONENT_RESULTS_SHAPE.id = 0                          ---ID of the Shape
RADAR_COMPONENT_RESULTS_SHAPE.uuid = sm.uuid.generateRandom() ---UUID of the Shape

---Gets the Shape's Material
---@return string shapeMaterial The material of the shape
RADAR_COMPONENT_RESULTS_SHAPE.getMaterial = function() end

---Gets the Shape's Material ID
---@return interger shapeMaterialID The material ID of the shape
RADAR_COMPONENT_RESULTS_SHAPE.getMaterialId = function() end

---Gets the bounding box of that shape
---@return Vec3 shapeBounds The bounds of the shape
RADAR_COMPONENT_RESULTS_SHAPE.getBounds = function() end

---Gets the color of the shape
---@return Color shapeColor The color of the shape
RADAR_COMPONENT_RESULTS_SHAPE.getColor = function() end

---Gets the mass of the shape
---@return number shapeMass The mass of the shape
RADAR_COMPONENT_RESULTS_SHAPE.getMass = function() end

---Gets the local position of the shape
---@return Vec3 shapeLocalPos The local position of the shape
RADAR_COMPONENT_RESULTS_SHAPE.getLocalPosition = function() end

---Gets the local rotation of the shape
---@return Quat shapeLocalRot The local rotation of the shape
RADAR_COMPONENT_RESULTS_SHAPE.getLocalRotation = function() end

---Gets the world position of the shape
---@return Vec3 shapeWorldPos The world position of the shape
RADAR_COMPONENT_RESULTS_SHAPE.getWorldPosition = function() end

---Gets the world rotation of the shape
---@return Quat shapeWorldRot The world rotation of the shape
RADAR_COMPONENT_RESULTS_SHAPE.getWorldRotation = function() end

---Gets the current UV index of the shape
---@return integer shapeUVIndex The UV index of the shape
RADAR_COMPONENT_RESULTS_SHAPE.getUvFrameIndex = function() end

---@class RadarComponent.Results.Shape.States
local RADAR_COMPONENT_RESULTS_SHAPE_STATES = {}

RADAR_COMPONENT_RESULTS_SHAPE_STATES.Buildable = true            ---True if buildable
RADAR_COMPONENT_RESULTS_SHAPE_STATES.Connectable = true          ---True if connectable
RADAR_COMPONENT_RESULTS_SHAPE_STATES.ConvertibleToDynamic = true ---True if convertable to Dyamic
RADAR_COMPONENT_RESULTS_SHAPE_STATES.Destructable = true         ---True if destructable
RADAR_COMPONENT_RESULTS_SHAPE_STATES.Erasable = true             ---True if Erasable
RADAR_COMPONENT_RESULTS_SHAPE_STATES.Liftable = true             ---True if Liftable
RADAR_COMPONENT_RESULTS_SHAPE_STATES.Paintable = true            ---True if Paintable
RADAR_COMPONENT_RESULTS_SHAPE_STATES.Usable = true               ---True if Usable

---Gets the states of the shape
---@return RadarComponent.Results.Shape.States shapeStates The states of the shape
RADAR_COMPONENT_RESULTS_SHAPE.getState = function() end

---@class RadarComponent.Results.Harvestable
local RADAR_COMPONENT_RESULTS_HARVESTABLE = {}

RADAR_COMPONENT_RESULTS_HARVESTABLE.id = 0                                ---ID of the Harvestable
RADAR_COMPONENT_RESULTS_HARVESTABLE.type = "INSERT_HARVESTABLE_TYPE_HERE" ---Type of Harvestable
RADAR_COMPONENT_RESULTS_HARVESTABLE.uuid = sm.uuid.generateRandom()       ---UUID of Harvestable

---Returns true if its Kinematic
---@return boolean harvestableIsKinematic True if Kinematic
RADAR_COMPONENT_RESULTS_HARVESTABLE.isKinematic = function() end

---Get the material of the Harvestable
---@return string harvestableMaterial The name of the material
RADAR_COMPONENT_RESULTS_HARVESTABLE.getMaterial = function() end

---Get the material ID of the Harvestable
---@return string harvestableMaterialId The ID of the material
RADAR_COMPONENT_RESULTS_HARVESTABLE.getMaterialId = function() end

---Get the Aabb of the Harvestable
---@return Vec3 harvestableAABB The Aabb of the harvestable.
RADAR_COMPONENT_RESULTS_HARVESTABLE.getAabb = function() end

---Gets the color of the Harvestable
---@return Color harvestableColor The color of the harvestable
RADAR_COMPONENT_RESULTS_HARVESTABLE.getColor = function() end

---Gets the mass of the Harvestable
---@return number harvestableMass The mass of the Harvestable
RADAR_COMPONENT_RESULTS_HARVESTABLE.getMass = function() end

---Gets the name of the Harvestable
---@return string harvestableName The name of the Harvestable
RADAR_COMPONENT_RESULTS_HARVESTABLE.getName = function() end

---Gets the position of the harvestable
---@return Vec3 harvestablePosition The position of the harvestable
RADAR_COMPONENT_RESULTS_HARVESTABLE.getPosition = function() end

---Gets the rotation of the harvestable
---@return Quat harvestableRotation The rotation of the harvestable
RADAR_COMPONENT_RESULTS_HARVESTABLE.getRotation = function() end

---Gets the scale of the harvestable
---@return Vec3 harvestableScale The scale of the harvestable
RADAR_COMPONENT_RESULTS_HARVESTABLE.getScale = function() end

---Gets the type of the harvestable
---@return Vec3 harvestableType The type of harvestable
RADAR_COMPONENT_RESULTS_HARVESTABLE.getType = function() end

---Gets the UV index of the harvestable
---@return interger harvestableUVIndex The index of the current UV.
RADAR_COMPONENT_RESULTS_HARVESTABLE.getUvFrameIndex = function() end

---@class RadarComponent.Results.Lift
local RADAR_COMPONENT_RESULTS_LIFT = {}
RADAR_COMPONENT_RESULTS_LIFT.id = 0 ---ID of the lift

---Gets the level of the lift
---@return number liftLevel The level of the lift
RADAR_COMPONENT_RESULTS_LIFT.getLevel = function() end

---Gets the position of the lift
---@return Vec3 liftPosition The position of the lift
RADAR_COMPONENT_RESULTS_LIFT.getPosition = function() end

---Returns true if it has any bodies attached.
---@return boolean liftHasBodies True if it has any bodies attached
RADAR_COMPONENT_RESULTS_LIFT.hasBodies = function() end

---@class RadarComponent.Results.Body
local RADAR_COMPONENT_RESULTS_BODY = {}

RADAR_COMPONENT_RESULTS_BODY.id = 0         ---ID of the Body
RADAR_COMPONENT_RESULTS_BODY.creationId = 0 ---Creation ID of the Body
RADAR_COMPONENT_RESULTS_BODY.mass = 0       ---Mass of the Body

---Gets the position of the body
---@return Vec3 bodyPosition The position of the body
RADAR_COMPONENT_RESULTS_BODY.getPosition = function() end

---Gets the rotation of the body
---@return Vec3 bodyRotation The rotation of the body
RADAR_COMPONENT_RESULTS_BODY.getRotation = function() end

---Gets the Center of mass position of the body
---@return Vec3 bodyCenterOfMass The Centor of mass of the body
RADAR_COMPONENT_RESULTS_BODY.getCOMPosition = function() end

---Gets its Linear velocity
---@return Vec3 bodyLinearVelocity The Linear Velocity of the body
RADAR_COMPONENT_RESULTS_BODY.getLinearVelocity = function() end

---Gets its Angular velocity
---@return Vec3 bodyLinearVelocity The Angular Velocity of the body
RADAR_COMPONENT_RESULTS_BODY.getAngularVelocity = function() end

---Gets the AABB of the body.
---@return Vec3,Vec3 bodyAABB the AABB of the Body
RADAR_COMPONENT_RESULTS_BODY.getAABB = function() end

---Gets all shapes from the body
---@return RadarComponent.Results.Shape[] shapes All shapes from the body
RADAR_COMPONENT_RESULTS_BODY.getShapes = function() end

---Gets all shapes from the creation
---@return RadarComponent.Results.Shape[] creationShapes All shapes from the creation
RADAR_COMPONENT_RESULTS_BODY.getCreationShapes = function() end

---Gets all bodies from the creation
---@return RadarComponent.Results.Body[] creationBodies All creation bodies from the creation.
RADAR_COMPONENT_RESULTS_BODY.getCreationBodies = function() end

---@class RadarComponent.Results.Body.States
local RADAR_COMPONENT_RESULTS_BODY_STATES = {}

RADAR_COMPONENT_RESULTS_BODY_STATES.Buildable = true ---True if its buildable
RADAR_COMPONENT_RESULTS_BODY_STATES.Connectable = true ---True if its Connectable
RADAR_COMPONENT_RESULTS_BODY_STATES.ConvertibleToDynamic = true ---True if its Convertible To Dynamic
RADAR_COMPONENT_RESULTS_BODY_STATES.Destructable = true ---True if its Destructable
RADAR_COMPONENT_RESULTS_BODY_STATES.Dynamic = true ---True if its Dyamic
RADAR_COMPONENT_RESULTS_BODY_STATES.Erasable = true ---True if its Erasable
RADAR_COMPONENT_RESULTS_BODY_STATES.Liftable = true ---True if its Liftable
RADAR_COMPONENT_RESULTS_BODY_STATES.OnLift = true ---True if its on a lift
RADAR_COMPONENT_RESULTS_BODY_STATES.Paintable = true ---True if its Paintable
RADAR_COMPONENT_RESULTS_BODY_STATES.Static = true ---True if its Static
RADAR_COMPONENT_RESULTS_BODY_STATES.Usable = true ---True if its Usable

---Gets the states of the body
---@return RadarComponent.Results.Body.States bodyStates The states of the body
RADAR_COMPONENT_RESULTS_BODY.getState = function() end

---@class RadarComponent.Results.Character
local RADAR_COMPONENT_RESULTS_CHARACTER = {}

RADAR_COMPONENT_RESULTS_CHARACTER.id = 0                    ---ID of the character
RADAR_COMPONENT_RESULTS_CHARACTER.nickname = "EXAMPLE_NAME" ---Player's name

---Returns Male if its a male, else Female
---@return "Male"|"Female"
RADAR_COMPONENT_RESULTS_CHARACTER.getGender = function() end

---Gets the position of the character
---@return Vec3 characterPos The position of the character
RADAR_COMPONENT_RESULTS_CHARACTER.getPosition = function() end

---Gets the looking direction of the character
---@return Vec3 characterDirection The looking direction of the character
RADAR_COMPONENT_RESULTS_CHARACTER.getLookingDirection = function() end

---Gets the current movement speed of the character.
---@return number movementSpeed The speed that the character is moving
RADAR_COMPONENT_RESULTS_CHARACTER.getMovementSpeed = function() end

---Gets the noise radius of the movement of the character
---@return number movementNoiseRadius The radius of the movement noise
RADAR_COMPONENT_RESULTS_CHARACTER.getMovementNoiseRadius = function() end

---Gets the color of the character
---@return Color characterColor The color of the character
RADAR_COMPONENT_RESULTS_CHARACTER.getColor = function() end

---@class RadarComponent.Results.Character.States
local RADAR_COMPONENT_RESULTS_CHARACTER_STATES = {}

RADAR_COMPONENT_RESULTS_CHARACTER_STATES.Aiming       = true ---True if aiming
RADAR_COMPONENT_RESULTS_CHARACTER_STATES.Climbing     = true ---True if Climbing
RADAR_COMPONENT_RESULTS_CHARACTER_STATES.Crouching    = true ---True if Crouching
RADAR_COMPONENT_RESULTS_CHARACTER_STATES.DefaultColor = true ---True if its a default color.
RADAR_COMPONENT_RESULTS_CHARACTER_STATES.Diving       = true ---True if its Diving
RADAR_COMPONENT_RESULTS_CHARACTER_STATES.Downed       = true ---True if Downed
RADAR_COMPONENT_RESULTS_CHARACTER_STATES.OnGround     = true ---True if its on the ground
RADAR_COMPONENT_RESULTS_CHARACTER_STATES.Player       = true ---True if its a player
RADAR_COMPONENT_RESULTS_CHARACTER_STATES.Sprinting    = true ---True if its sprinting
RADAR_COMPONENT_RESULTS_CHARACTER_STATES.Swimming     = true ---True if its swimming
RADAR_COMPONENT_RESULTS_CHARACTER_STATES.Tumbling     = true ---True if its nocked out or Tumbling.

---Gets the states of the character
---@return RadarComponent.Results.Character.States characterStates The states of the character
RADAR_COMPONENT_RESULTS_CHARACTER.getState = function() end

---@class RadarComponent
local RADAR_COMPONENT = {}
---Returns the range that it can detect
---@return number radarRange The range of the radar
RADAR_COMPONENT.getRange = function() end

---Sets the range
---@param radius number The new radius
RADAR_COMPONENT.setRange = function(radius) end

---Detected object's result from a scan
---@class RadarComponent.Result
---@field [1] string The type of object it is
---@field [2] RadarComponent.Results.Character|RadarComponent.Results.Body|RadarComponent.Results.Lift|RadarComponent.Results.Harvestable The data

---Get the objects inside range
---@return RadarComponent.Result[] objects All objects it has detected
RADAR_COMPONENT.getObjects = function() end

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
---@param fontName string? The font to use. (defaults to whatever the default font the fontmanager is using)
---@param string string The text to draw.
---@param color string|Color The color of the text in hexadecimal format.
DISPLAY_COMPONENT.drawText = function(x, y, fontName, string, color) end

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

---SC MODULES --

---Additional JSON features that sm.json dosen't have.
sm.scrapcomputers.json = {}

---Returns a boolean to see if the root (table) is vaild and dosent cause a crash when u use it in functions
---@param root table
---@return boolean
sm.scrapcomputers.json.isSafe = function(root) end

---Converts a lua table to a json string. This is the reccommended function as it provides more features and security
---@param root table         The table to be converted to.
---@param prettify boolean   If true, The output would have indentation.
---@param indent string?     The character used for the indentation. Default is a tab.
---@return string JSONString The JSON string generated from the table
sm.scrapcomputers.json.toString = function (root, prettify, indent) end

---Converts a json string to a lua table. This is the reccommended function as it provides more features and security
---@param root string The JSON string
---@return table TableFromJSONString The table that was generated from the JSON string
sm.scrapcomputers.json.toTable = function (root) end

---Additional features that sm.color dosen't have
sm.scrapcomputers.color = {}

---Generates a random color.
---@param from number The starting range
---@param to number The ending range
---@return Color color The generated color
sm.scrapcomputers.color.random = function(from, to) end

---Generates a random color. (0 to 1 as a float)
---@return Color color The generated color
sm.scrapcomputers.color.random0to1 = function() end

---A function like sm.color.new but its 1 argument.
---Its just simply sm.color.new(rgbNum, rgbNum, rgbNum) and also why its called "newSingluar".
---@param rgbNum number The value to be on R, G and B.
---@return Color color The generated color
sm.scrapcomputers.color.newSingluar = function(rgbNum) end

---This is a manager for the Audio json file for ScrapComputers
sm.scrapcomputers.audio = {}

---Returns all audio's that u can use.
---@return string[]
function sm.scrapcomputers.audio.getAudioNames() end

---Returns true if the name exists.
---
---<h2>NOTE: The name must be full path! else it will NOT work!</h2>
---@param name string The name of the audio (FULL ONLY!)
---@return boolean audioExists If true, the name that was passed did exist as audio. else false (Doesn't exist)
function sm.scrapcomputers.audio.exists(name) end

---@class sm.scrapcomputers.audio.AudioParameter
---@field default number The default value of the Parameter
---@field maximum number The maximum value of the Parameter
---@field minimum number The minimum value of the Parameter

---This will return the parameters you can set by the audio name
---@param name string The name of the audio to get it's paramters
---@return sm.scrapcomputers.audio.AudioParameter[]?
function sm.scrapcomputers.audio.getParams(name) end

---@class sm.scrapcomputers.audio.ParamsIncorrectTable
---@field hasNoParamsUsableIssue boolean If true, then this audio doesn't have any paramaters.
---@field issues string[][] Contains all issues that have issue with the parameters

---This will return the parameters you can set by the audio name
---@param name string The name of the audio to get it's paramters
---@param params sm.scrapcomputers.audio.AudioParameter[] The paramaters of the audio that it will contain
---@return sm.scrapcomputers.audio.ParamsIncorrectTable? validAudioParamaters If nil, then all of your paramters are valid. Else its a table that will contain the issues
function sm.scrapcomputers.audio.areParamsCorrect(name, params) end

---Base64 Encoder/Decoder module
sm.scrapcomputers.base64 = {}

---Convert's a string to base64 string.
---@param data string The data to be converted to.
---@return string base64Data The data in base64

sm.scrapcomputers.base64.encode = function(data) end
---Convert's a base64 string to raw string.
---@param data string The data to be converted to.
---@return string base64Data The data from the conversion.
sm.scrapcomputers.base64.decode = function(data) end

---MD5 Encryption module
sm.scrapcomputers.md5 = {}

---@class sm.scrapcomputers.md5.Stream
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
---@return sm.scrapcomputers.md5.Stream MD5Stream The stream
function sm.scrapcomputers.md5.new() end

---Converts MD5-Raw-Bytes String to a MD5-Encrypted String
---@param rawBytes string The raw bytes
---@return string MD5EncryptedString The MD5-Encrypted string
function sm.scrapcomputers.md5.tohex(rawBytes) end

---Converts a string to a MD5-Raw-Bytes String
---@param str string The string
---@return string MD5RawBytes The MD5-Raw-Bytes String string
function sm.scrapcomputers.md5.sum(str) end

---Converts string to a MD5-Encrypted String
---@param str string The string
---@return string MD5EncryptedString The MD5-Encrypted string
function sm.scrapcomputers.md5.sumhexa(str) end

---SHA256 Encryption Module
sm.scrapcomputers.sha256 = {}

---Converts a string to a SHA256 string
---@param str string The string to be converted
---@return string base64String The string in Base64
function sm.scrapcomputers.sha256.encode(str) end

---Math Module
sm.scrapcomputers.math = {}

---Clamps value.
---@param value number The value to be clamped
---@param min number The lowest allowed number
---@param max number The highest allowed number
---@return number clampedValue The clamped value.
sm.scrapcomputers.math.clamp = function (value, min, max) end

--Additonal features for table's.
sm.scrapcomputers.table = {}

---Clones a table
---@param tbl table The table to clone
---@return table clonedTable The cloned table
sm.scrapcomputers.table.clone = function (tbl) end

---Gets a element from table, Unlike `tbl[index]` If like the starting element has index 2, doing `tbl[1]` won't work. This fixes that issue.
---@param tbl table The table
---@param index number The index to look at
---@return any item The item from the table. nil if it wasen't found or is like that
sm.scrapcomputers.table.getItemAt = function(tbl, index) end

---Gets the total elements from a table. Unlike doing #tbl, If the table wasen't using number's as index. the # wouldn't get anything but return 0. This fixes that issue.
---@param tbl table The table
---@return number tableSize The size of the table
sm.scrapcomputers.table.getTotalItems = function(tbl) end

---Like sm.scrapcomputers.table.getTotalItems but works with dictonaries.
---@param tbl table The dictionary table
---@return number dictionaryTableSize The size of the dictionary
sm.scrapcomputers.table.getTotalItemsDict = function(tbl) end

---Merges 2 tables into 1
---@param table1 table The 1st table
---@param table2 table The 2nd table
---@return table mergedTable The merged table
sm.scrapcomputers.table.merge = function(table1, table2) end

---Converts a table to a lua table string
---@param tbl table The table
---@return string luaTableStr The lua table as string.
sm.scrapcomputers.table.toString = function(tbl) end

---Additional features that sm.util dosen't have.
sm.scrapcomputers.util = {}

---Gets the remainder of division. This function is more safer than sm.util.postiveModule as for some reason, Scrap Mechanic
---dosent handle division by 0 for sm.util.postiveModule so it crashes.
---@param a number Number to divide
---@param b number The amount to divide
---@return number The divided number
sm.scrapcomputers.util.postiveModulo = function (a, b) end

---Additional features that sm.vec3 dosen't have
sm.scrapcomputers.vec3 = {}

---A function like sm.vec3.new but its 1 argument.
---
---Its just simply sm.vec3.new(xyzNum, xyzNum, xyzNum) and also why its called "newSingluar".
---@param xyzNum number The value for xyz.
---@return Vec3 newVec3 The new vector3
sm.scrapcomputers.vec3.newSingluar = function (xyzNum) end

---Returns a new vector3 with the added numbers
---@param vec3 Vec3 The vector to modify
---@param x number The value to add for vec3.x
---@param y number The value to add for vec3.y
---@param z number The value to add for vec3.z
---@return Vec3 newVec3 The new vector3
sm.scrapcomputers.vec3.add = function(vec3, x, y, z) end

---Returns a new vector3 with the subtracted numbers
---@param vec3 Vec3 The vector to modify
---@param x number The value to subtract for vec3.x
---@param y number The value to subtract for vec3.y
---@param z number The value to subtract for vec3.z
---@return Vec3 newVec3 The new vector3
sm.scrapcomputers.vec3.subtract = function(vec3, x, y, z) end

---Returns a new vector3 with the divided numbers
---@param vec3 Vec3 The vector to modify
---@param x number The value to divide for vec3.x
---@param y number The value to divide for vec3.y
---@param z number The value to divide for vec3.z
---@return Vec3 newVec3 The new vector3
sm.scrapcomputers.vec3.divide = function(vec3, x, y, z) end

---Returns a new vector3 with the multiplied numbers
---@param vec3 Vec3 The vector to modify
---@param x number The value to mulitply for vec3.x
---@param y number The value to mulitply for vec3.y
---@param z number The value to mulitply for vec3.z
---@return Vec3 newVec3 The new vector3
sm.scrapcomputers.vec3.mulitply = function(vec3, x, y, z) end

---Gets the distance between 2 vector's.
---@param vec1 Vec3 The first point
---@param vec2 Vec3 The seccond point
---@return number distance The distance between the 2 vector3's.
sm.scrapcomputers.vec3.distance = function (vec1, vec2) end