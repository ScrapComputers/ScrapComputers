import os

for file in os.listdir("Fonts"):
    open(f"Fonts/{file.replace(".ttf", ".txt")}", "a").close()