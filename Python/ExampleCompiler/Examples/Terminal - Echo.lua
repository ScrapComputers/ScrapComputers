local terminal = sc.getTerminals()[1]
assert(terminal, "Terminal not found! Make sure you have connected a Terminal to the computer!")

function onLoad()
	terminal.clear()
	terminal.send("#3A96DDComputer: Send a input and il echo it back to you!")
end

function onUpdate()
	if terminal.receivedInputs() then
		local text = terminal.getInput()
		terminal.send("> " .. text)
	end
end

function onDestroy()
	terminal.clear()
	terminal.clearInputHistory()
end