import json
from pathlib import Path

def processLuaFiles(directory, orderFile):
    results = []

    # Read the order file with the list of filenames (without .lua extension)
    with open(orderFile, 'r', encoding='utf-8') as f:
        filenames = json.load(f)

    for name in filenames:
        file_path = Path(directory) / f"{name}.lua"
        if not file_path.exists():
            print(f"Warning: File \"{file_path}\" does not exist. Skipping.")
            continue

        with open(file_path, 'r', encoding='utf-8') as f:
            lines = f.readlines()
        
        if not lines:
            continue
        
        scriptContent = ''.join(lines).rstrip('\n').replace("    ", "\t")
        
        results.append({
            "name": name,
            "script": scriptContent
        })
        
        print(f"Processed \"{name}\"")
    return results

def saveToJson(data, outputFile):
    with open(outputFile, 'w', encoding='utf-8') as f:
        json.dump(data, f, indent=4)

if __name__ == "__main__":
    directory = "Examples"
    orderFile = "ExamplesOrder.json"
    outputFile = "../../JSON/examples.json"

    scripts = processLuaFiles(directory, orderFile)
    saveToJson(scripts, outputFile)
    print(f"Processed {len(scripts)} scripts and saved to {outputFile}")
