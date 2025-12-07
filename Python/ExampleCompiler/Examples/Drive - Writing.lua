local drive = sc.getDrives()[1]
assert(drive, "Drive not found! Make sure you have connected a Drive to the computer!")

local data = {
    hello = "world!"
}

function onLoad()
	drive.save(data)

	print("Saved contents to the drive!")
end