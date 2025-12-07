-- You need 2 input registers called "input1" and "input2" and you need a Output register called "output"
-- For every trick it will do: output = input1 + input2

function onUpdate()
	local input1 = sc.getReg("input1")
	local input2 = sc.getReg("input2")

	sc.setReg("output", input1 + input2) 
end
