local motor = sc.getMotors()[1]

function onLoad()
	-- Set the bearing speed and torque to random values
	motor.setBearingSpeed(math.random(100, 1000))
	motor.setTorque(math.random(100, 1000))
end