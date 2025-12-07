local drive = sc.getDrives()[1]
assert(drive, "Drive not found! Make sure you have connected a Drive to the computer!")

function onLoad()
	print(drive.load())
end