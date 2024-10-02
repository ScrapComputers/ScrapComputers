import re

# Read the data.lua file.
with open("input.lua", "r") as f:
    # Read it
    data = f.read()
    
    # Do converstions. \n = \\n, \t = \\t, \\\"
    data = data.replace("\n","\\n").replace("\t", "\\t").replace("\"", "\\\"").replace("    ", "\\t")
    data = re.sub(r'(#\w{6})', r'#\1', data)

    # Write the converted data to output.txt
    with open("output.txt", "w") as ff:
        ff.write(data)