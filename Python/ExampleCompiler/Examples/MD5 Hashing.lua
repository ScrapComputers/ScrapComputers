local message = "Hello world!"

function onLoad()
	print("Message: " .. message)
	print("MD5 Encoded: " .. sc.md5.sumhexa(message))
end