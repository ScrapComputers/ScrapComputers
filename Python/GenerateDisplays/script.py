# days_wasted_working_on_this = 9
from jsonc_parser.parser import JsoncParser as jsonc
import json
import uuid

InputFile = open("Input.json", "r")
InputJson = jsonc.parse_str(InputFile.read())
InputFile.close()

ShapesetJson = {"partList": []}
InventoryDescriptionsJson = {}

# DON'T TOUCH IT
# - VeraDev afther wasting weeks of his life time
def calculate_scale(x, y, width, height):
    if width > height:
        return y / 4

    return x / 4 # return y / 4 would work aswell

for resolution in InputJson["resolutions"]:
    res, size = resolution
    
    width  = int(str(res).split("x")[0])
    height = int(str(res).split("x")[1])
    
    x = int(str(size).split("x")[0])
    y = int(str(size).split("x")[1])
    
    scale = calculate_scale(x, y, width, height)
    
    uuid4 = str(uuid.uuid4())
    ShapesetJson.get("partList").append({
            "box": { "x": 1, "y": y, "z": x },
            "color": "323232",
            "physicsMaterial": "Mechanical",
            "renderable": f"$CONTENT_DATA/Objects/Renderables/Displays/Display{size}.rend",
            "rotationSet": "PropNegY",
            "scripted": { "classname": "Display", "filename": "$CONTENT_DATA/Scripts/Display.lua", "data": { "width": width, "height": height, "scale": scale } },
            "sticky": "-X+X-Y+Y-Z+Z",
            "uuid": uuid4
        })
    
    InventoryDescriptionsJson[uuid4] = {
        "title": f"[#3A96DDS#3b78ffC#eeeeee] {res} Display ({size} Size)",
        "description": f"A display where u can show anything on it! Text, Circles, Rectangles and etc!\n\n#f9f1a5Resolution: {res}\nObject Size: {size}\n\n#e6d927Scripter: #eeeeeeBen Bingo, VeraDev"
    }
    
    print(f"[ScrapComputers - Display Generator]: Generated {res} (Model size: {size}) Display!")

with open("Shapeset.json", "w") as f:
    f.write(json.dumps(ShapesetJson, indent=4))
    
with open("InventoryDescriptions.json", "w") as f:
    f.write(json.dumps(InventoryDescriptionsJson, indent=4))