import os
import json

data = []

for file in os.listdir("Fonts"):
    if file.endswith(".txt"):
        data.append(file.removesuffix(".txt"))

print(json.dumps(data))