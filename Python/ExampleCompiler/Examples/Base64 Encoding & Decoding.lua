local message = "Hello World!"

function onLoad()
	print("Message: " .. message)

	local encodedMessage = sc.base64.encode(message)
	print("Encoded: " .. encodedMessage)

	local decodedMessage = sc.base64.decode(encodedMessage)
	print("Decoded: " .. decodedMessage)
end