replaceList = [
    ["\n"  , "\\n" ],
    ["\t"  , "\\t" ],
    ["    ", "\\t" ],
    ["\""  , "\\\""],
]

with open("input.txt", "r", encoding="utf8") as f:
    data = f.read()
    for replaceData in replaceList:
        data = data.replace(replaceData[0], replaceData[1])
        
with open("output.txt", "w", encoding="utf8") as ff:
    ff.write(data)