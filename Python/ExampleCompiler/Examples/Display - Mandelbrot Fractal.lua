local display = sc.getDisplays()[1]
assert(display, "Display not found! Make sure you have connected a Display to the computer!")

local width, height = display.getDimensions()

--[[
	Some recommended values to try:

	maxIterations = 1000
	zoom = 20000
	offsetX = -0.7497
	offsetY = 0.0315
]]

local maxIterations = 200 -- Maximum iterations per pixel, determines the detail and accuracy of the fractal
local zoom = 1 -- Zoom multiplier, adjusts the scale of the fractal
local offsetX = 0 -- X-axis offset for the fractal's center
local offsetY = 0 -- Y-axis offset for the fractal's center

local blackColor = sm.color.new(0, 0, 0)

-- Function to draw a Mandelbrot fractal on the display
function onLoad()
	local pixelTbl = {}
	local pixelTblIndex = 1

	for x = 1, width do
		for y = 1, height do
			-- Convert pixel coordinates (x, y) to complex plane coordinates (zx, zy)
			local zx, zy = (x - width / 2) / (0.5 * zoom * width) + offsetX, (y - height / 2) / (0.5 * zoom * height) + offsetY
			local cRe, cIm = zx, zy  -- The real and imaginary parts of the initial complex number
			local iteration = 0  -- Iteration counter

			-- Iterate to determine if the point belongs to the Mandelbrot set
			while (zx * zx + zy * zy < 4) and (iteration < maxIterations) do
				local newZx = zx * zx - zy * zy + cRe  -- Calculate the new real part
				local newZy = 2 * zx * zy + cIm  -- Calculate the new imaginary part
				zx, zy = newZx, newZy  -- Update zx and zy for the next iteration
				iteration = iteration + 1  -- Increment the iteration counter
			end

			-- Determine the color based on the number of iterations
			local brightness = iteration / maxIterations
			local color = blackColor

			-- If the point isn't in the set (reached max iterations), map the iteration count to a grayscale brightness
			if iteration ~= maxIterations then
				color = sm.color.new(brightness, brightness, brightness) * 2  -- Adjust brightness level as needed
			end

			-- Add the pixel data to the pixel table
			pixelTbl[pixelTblIndex] = {x = x, y = y, scale = {x = 1, y = 1}, color = color}
			pixelTblIndex = pixelTblIndex + 1
		end
	end
	
	display.drawFromTable(pixelTbl)
	display.update()
end
