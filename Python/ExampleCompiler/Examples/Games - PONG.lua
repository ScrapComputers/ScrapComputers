-- This is the game PONG, For the bare mininum, connect a display to the computer
-- A 128x128 display is recommended.
--
-- Additional components you could connect:
--	  Speaker: Connecting a speaker adds sound effects to the game.
--	  Input registers: (Connect any of these input registers to the computer with 1 of the name's bellow will add functionaility)
--		  "reset": Lets you reset the game
--		  "aiMode": Lets you toggle a gamemode where its AI vs AI.
--		  "debugMode": If enabled, it shows the ball's direction & 2 lines on the player pad to give you information if the ball's y cordinates fits in your pad.

-- SOURCE CODE --

local display = sc.getDisplays()[1]
local speaker = sc.getSpeakers()[1]

if not display then
	error("Please connect a display!")
end

local gameState = 0
local playerY = 75
local aiY = 75
local speed = 0.5
local aiSpeed1 = 0.2
local aiErrorMargin1 = 3
local aiSpeed2 = 0.2
local aiErrorMargin2 = 3
local padHeight = 16
local screenHeight, screenWidth = display.getDimensions()
local ballX = screenWidth / 2
local ballY = screenHeight / 2
local ballSpeedX = 1.25
local ballSpeedY = 1.25
local ballRadius = 2
local playerScore = 0
local aiScore = 0
local maxScore = 10
local maxBounceAngle = math.rad(85)
local clock = 0

local currentisAIvsAIMode = false

local minBallSpeed = 0.75

if not speaker then
	speaker = {beep = function() end, longBeep = function() end}
end

function getRegValue(name, defaultValue)
	local success, result = pcall(sc.getReg, name)
	if not success then
		return defaultValue
	end

	return result
end

function enforceMinimumBallSpeed()
	local ballSpeed = math.sqrt(ballSpeedX^2 + ballSpeedY^2)
	if ballSpeed < minBallSpeed then
		local scale = minBallSpeed / ballSpeed
		ballSpeedX = ballSpeedX * scale
		ballSpeedY = ballSpeedY * scale
	end
end

function reSkillAIs()
	aiSpeed1 = 0.15 + math.random() * 0.2
	aiSpeed2 = 0.15 + math.random() * 0.2
	aiErrorMargin1 = 2 + math.random() * 3
	aiErrorMargin2 = 2 + math.random() * 3
	speed = 0.1 + math.random()
end

function resetBall()
	ballX = screenWidth / 2
	ballY = screenHeight / 2
	ballSpeedX = 1.25 * ((math.random() > 0.5) and 1 or -1)
	ballSpeedY = 1.25 * ((math.random() > 0.5) and 1 or -1)
end

function checkGameOver()
	if currentisAIvsAIMode then
		if playerScore >= maxScore then return "AI #1 Wins!" elseif aiScore >= maxScore then return "AI #2 Wins!" end
		return
	end
	if playerScore >= maxScore then return "Player Wins!" elseif aiScore >= maxScore then return "AI Wins!" end
end

function modifyBounceAngle(paddleY, ballY, padHeight)
	local relativeIntersectY = (ballY - paddleY) / (padHeight / 2)
	local bounceAngle = relativeIntersectY * maxBounceAngle
	return bounceAngle
end

function updateBallDirectionAfterPaddleHit(paddleY, ballY, padHeight)
	local bounceAngle = modifyBounceAngle(paddleY, ballY, padHeight)
	local ballSpeed = math.sqrt(ballSpeedX^2 + ballSpeedY^2)
	ballSpeedX = ballSpeed * math.cos(bounceAngle)
	ballSpeedY = ballSpeed * math.sin(bounceAngle)

	speaker.beep()
end

function onLoad()
	display.enableTouchScreen(true)
	resetBall()
end

function onUpdate()
	debugMode = getRegValue("debugMode", 0) == 1

	if getRegValue("reset", 0) == 1 then
		playerScore = 0
		aiScore = 0
		aiY = 75
		playerY = 75
		resetBall()
		gameState = 0
		clock = 0
		return
	end

	if gameState == 0 then
		local width, height = display.calcTextSize("Touch to play!")
		display.clear()
		display.drawText((screenWidth / 2) - (width / 2), (screenHeight / 2) - (height / 2), "Touch to play!")
		
		if getRegValue("aiMode", 0) == 1 then
			display.drawText(4, 4, "AI vs AI Mode", "00ee00")
		end
		
		display.update()
		local touchData = display.getTouchData()
		if touchData then
			gameState = 1
			playerY = touchData.y

			playerScore = 0
			aiScore = 0
			aiY = 75
			playerY = 75

			currentisAIvsAIMode = getRegValue("aiMode", 0) == 1
			speed = 0.5
			ballSpeedX = currentisAIvsAIMode and 1.25 or 1
			ballSpeedY = currentisAIvsAIMode and 1.25 or 1
			
			if currentisAIvsAIMode then
				reSkillAIs()
			else
				aiSpeed1 = 0.2
			end
		end
	elseif gameState == 1 then
		local touchData = display.getTouchData()

		if not currentisAIvsAIMode and touchData then
			local newY = sm.util.clamp(touchData.y, padHeight / 2, screenHeight - padHeight / 2)
			playerY = playerY + (newY - playerY) * speed
		end

		if currentisAIvsAIMode then
			local targetPlayerY = ballY + aiErrorMargin2 * (math.random() - 0.5)
			playerY = playerY + (targetPlayerY - playerY) * aiSpeed2
			playerY = sm.util.clamp(playerY, padHeight / 2, screenHeight - padHeight / 2)

			local targetAiY = ballY + aiErrorMargin1 * (math.random() - 0.5)
			aiY = aiY + (targetAiY - aiY) * aiSpeed1
			aiY = sm.util.clamp(aiY, padHeight / 2, screenHeight - padHeight / 2)
		else
			local targetAiY = ballY + aiErrorMargin1 * (math.random() - 0.5)
			aiY = aiY + (targetAiY - aiY) * aiSpeed1
			aiY = sm.util.clamp(aiY, padHeight / 2, screenHeight - padHeight / 2)
		end

		ballX = ballX + ballSpeedX
		ballY = ballY + ballSpeedY
		
		if ballY - ballRadius < 0 then
			ballY = ballRadius
			ballSpeedY = -ballSpeedY
			
			if currentisAIvsAIMode then
				ballSpeedY = ballSpeedY + ((0.85 - math.random()) * 2)
			else
				ballSpeedX = ballSpeedX * 1.05
				ballSpeedY = ballSpeedY * 1.05
			end

			enforceMinimumBallSpeed()
			speaker.beep()
		elseif ballY + ballRadius > screenHeight then
			ballY = screenHeight - ballRadius
			ballSpeedY = -ballSpeedY

			if currentisAIvsAIMode then
				ballSpeedY = ballSpeedY + ((0.85 - math.random()) * 2)
			else
				ballSpeedX = ballSpeedX * 1.05
				ballSpeedY = ballSpeedY * 1.05
			end

			enforceMinimumBallSpeed()
			speaker.beep()
		end

		local playerPaddleLeft = 10
		local playerPaddleRight = playerPaddleLeft + 4
		local playerPaddleTop = playerY - padHeight / 2
		local playerPaddleBottom = playerY + padHeight / 2

		local aiPaddleLeft = screenWidth - 14
		local aiPaddleRight = aiPaddleLeft + 4
		local aiPaddleTop = aiY - padHeight / 2
		local aiPaddleBottom = aiY + padHeight / 2
		
		local ballLeft = ballX - ballRadius
		local ballRight = ballX + ballRadius
		local ballTop = ballY - ballRadius
		local ballBottom = ballY + ballRadius

		if ballRight > playerPaddleLeft and ballLeft < playerPaddleRight and ballBottom > playerPaddleTop and ballTop < playerPaddleBottom then
			updateBallDirectionAfterPaddleHit(playerY, ballY, padHeight)
			ballSpeedX = math.abs(ballSpeedX)

			if not currentisAIvsAIMode then
				ballSpeedX = ballSpeedX * 1.05
				ballSpeedY = ballSpeedY * 1.05
			end

			enforceMinimumBallSpeed()
		end
		
		if ballLeft < aiPaddleRight and ballRight > aiPaddleLeft and ballBottom > aiPaddleTop and ballTop < aiPaddleBottom then
			updateBallDirectionAfterPaddleHit(aiY, ballY, padHeight)
			ballSpeedX = -math.abs(ballSpeedX)

			if not currentisAIvsAIMode then
				ballSpeedX = ballSpeedX * 1.05
				ballSpeedY = ballSpeedY * 1.05
			end

			enforceMinimumBallSpeed()
		end
		
		if ballLeft < 0 then
			aiScore = aiScore + 1
			resetBall()
			speaker.longBeep()
		elseif ballRight > screenWidth then
			playerScore = playerScore + 1
			resetBall()
			speaker.longBeep()
		end

		local gameOverMessage = checkGameOver()
		if gameOverMessage then
			gameState = 2
		end

		display.clear()
		if debugMode then
			display.drawLine(1, playerY + (padHeight / 2), screenWidth, playerY + (padHeight / 2), "888888")
			display.drawLine(1, playerY - (padHeight / 2), screenWidth, playerY - (padHeight / 2), "888888")
		end
		display.drawFilledRect(10, playerY - padHeight / 2, 4, padHeight, "eeeeee")
		display.drawFilledRect(screenWidth - 14, aiY - padHeight / 2, 4, padHeight, "eeeeee")

		for i = 1, screenHeight, 1 do
			if i % 2 == 0 then
				display.drawPixel(screenWidth / 2, i, "eeeeee")
			end
		end

		if debugMode then
			local lineEndX = ballX
			local lineEndY = ballY
		
			if ballSpeedX < 0 then
				local timeToPaddle = (10 - (ballX - ballRadius)) / ballSpeedX
				lineEndX = 10
				lineEndY = ballY + ballSpeedY * timeToPaddle
		
			elseif ballSpeedX > 0 then
				local timeToPaddle = (screenWidth - 14 - (ballX + ballRadius)) / ballSpeedX
				lineEndX = screenWidth - 14
				lineEndY = ballY + ballSpeedY * timeToPaddle
			end
		
			display.drawLine(ballX, ballY, lineEndX, lineEndY, "eeee00")
		end

		display.drawFilledRect(ballX - ballRadius, ballY - ballRadius, ballRadius * 2, ballRadius * 2, "ee0000")
		display.drawText(10, 5, tostring(playerScore))
		display.drawText(screenWidth - 14, 5, tostring(aiScore))

		display.update()
	elseif gameState == 2 then
		local gameOverMessage = checkGameOver()
		local width, height = display.calcTextSize(gameOverMessage)
		display.clear()
		display.drawText((screenWidth / 2) - (width / 2), (screenHeight / 2) - (height / 2), gameOverMessage)
		display.update()
		
		clock = clock + 1
		if clock == 5 * 50 then
			clock = 0
			gameState = 0
		end
	end
end

-- Please scroll to the top for information!