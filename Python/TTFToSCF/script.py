import sys, os
from slpp import slpp as lua
from PIL import Image, ImageFont, ImageDraw
from fontTools.ttLib import TTFont

FontCharacters = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~⌂ ¡¢£¤¥¦§¨©ª«¬-®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåU+00E5æçèéêëìíîïðñòóôõö÷øùúûüýþÿ..."

def get_supported_characters(font):
    """ Cache supported characters for fast lookup. """
    supported_chars = set()
    for cmap in font['cmap'].tables:
        if cmap.isUnicode():
            supported_chars.update(cmap.cmap.keys())
    return supported_chars

def CreateErrorCharacter(FontWidth, FontHeight):
    """ Generate a placeholder 'error' character. """
    output = ["{"]

    for x in range(FontHeight):
        if x == 0 or x == (FontHeight - 1):
            output.append(f"\t\"{'#' * FontWidth}\",")
        else:
            output.append(f"\t\"#{"." * (FontWidth - 2)}#\",")
    
    output.append("}")
    return "\n".join(output)

def CreateMap(FontPath, FontName, FontWidth, FontHeight, AdditionalPadding, OutputFilename):
    output = {}
    characters = list(FontCharacters)
    actualCharacters = ""

    # Load font and cache supported characters
    ttfFont = TTFont(FontPath)
    supported_chars = get_supported_characters(ttfFont)
    
    # Create the ImageFont object once
    font = ImageFont.truetype(FontPath, size=FontHeight)

    # Pre-create the image and drawing context, reusing them
    image = Image.new("1", (FontWidth, FontHeight), color=0)
    draw = ImageDraw.Draw(image)

    for char in characters:
        if ord(char) not in supported_chars:
            continue  # Skip unsupported characters

        # Clear the image before drawing the new character
        draw.rectangle([(0, 0), (FontWidth, FontHeight)], fill=0)

        # Draw character and extract bitmap
        draw.text((0, 0), char, fill=255, font=font)

        bitmap = [[1 if image.getpixel((x, y)) > 0 else 0 for x in range(image.width)] for y in range(image.height)]
        contents = ["".join("#" if bit else "." for bit in row) + "." * AdditionalPadding for row in bitmap]

        # Check if the character is blank
        blankRow = "." * (FontWidth + AdditionalPadding)
        if all(row == blankRow for row in contents) and char != " ":
            continue  # Skip blank characters except space

        actualCharacters += char
        output[char.replace("\\", "\\\\").replace("\"", "\\\"")] = contents

    # Write the result to file
    result = lua.encode(output).replace("\n\t\t", "").replace("\n\t},", "},").replace("\n\t}\n}", "}\n}")
    with open(OutputFilename, "w", encoding="utf8") as f:
        f.write("local data = {}\n\n")
        f.write(f"data.fontWidth = {FontWidth + AdditionalPadding}\n")
        f.write(f"data.fontHeight = {FontHeight}\n")
        f.write(f"data.characters = \"{actualCharacters.replace('\\', '\\\\').replace('\"', '\\\"')}\"\n")
        f.write(f"data.errorChar = {CreateErrorCharacter(FontWidth + AdditionalPadding, FontHeight)}\n\n")
        f.write(f"data.charset = {result}\n")
        f.write(f"sm.scrapcomputers.fontManager.fonts[\"{FontName}\"] = data")

def main():
    if len(sys.argv) > 1 and sys.argv[1].lower() == "--auto":
        for file in os.listdir("Fonts"):
            if not file.endswith(".txt"):
                with open(f"Fonts/{file.removesuffix('.ttf')}.txt", "r") as f:
                    lines = f.readlines()

                    FontWidth, FontHeight = map(int, lines[0].split("x"))
                    AdditionalPadding = int(lines[1])

                    CreateMap(f"Fonts/{file}", file.removesuffix(".ttf"), FontWidth, FontHeight, AdditionalPadding, f"Generated/{file.removesuffix('.ttf')}.lua")

                    print(f"Generated Font: \"{file.removesuffix('.ttf')}\"")
        return
    
    print("The selected font would be the font.ttf in the directory where this script.py file is located.")
    
    FontName = input("Font name: ")

    while True:
        try:
            FontWidth, FontHeight = map(int, input("Font size (width x height): ").split('x'))
            break
        except ValueError:
            print("Invalid input format. Please enter width and height separated by 'x'. (Example: 5x6)")

    while True:
        try:
            AdditionalPadding = int(input("Additional Padding (x only!): "))
            break
        except ValueError:
            print("Not a number!")

    CreateMap("font.ttf", FontName, FontWidth, FontHeight, AdditionalPadding, "GeneratedFont.lua")

    print("Generated font!")

if __name__ == "__main__":
    main()
