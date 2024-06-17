# Read the data.lua file.
with open("input.txt", "r") as f:
    # Read it
    data = f.read()
    
    # Do converstions. ⁄ = \\
    data = data.replace("⁄","\\")
    
    # Write the converted data to output.txt
    with open("output.lua", "w") as ff:
        ff.write(data)