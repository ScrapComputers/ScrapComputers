local keyboard = sc.getKeyboards()[1]
assert(keyboard, "Keyboard not found! Make sure you have connected a Keyboard to the computer!")

local display = sc.getDisplays()[1]
assert(display, "Display not found! Make sure you have connected a Display to the computer!")

local text = ""
local lastKeystroke = ""
local pressClock = nil
local notPress = true

function onUpdate()
	local keystroke = keyboard.getLatestKeystroke()
	local pressed = keyboard.isPressed()
	local clock = os.clock()

	local rapidPress = false

	-- Key handle logic
	if pressed then
		if keystroke == lastKeystroke then
			if not pressClock then
				pressClock = clock -- Set the pressClock
			end

			if pressClock + 0.3 <= clock then
				rapidPress = true
			end
		else
			pressClock = nil -- Reset
		end
	else
		pressClock = nil -- Reset
		notPress = true
	end

	-- Check if a key was pressed
	if (pressed and notPress or keystroke ~= lastKeystroke) or rapidPress then
		lastKeystroke = keystroke
		notPress = false

		-- If backspace, then we have to remove a character
		if keystroke == "backSpace" then
			text = text:sub(1, #text - 1)
		else
			text = text .. keystroke
		end

		-- Update the display
		display.clear()
		display.drawText(2, 2, text, "eeeeee")
		display.update()
	end
end

function onDestroy()
	display.clear()
	display.update()
end
