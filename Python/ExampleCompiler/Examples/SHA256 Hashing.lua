local message = "Hello world!"

function onLoad()
	print("Message: " .. message)
	print("SHA256 Encoded: " .. sc.sha256.encode(message))
end