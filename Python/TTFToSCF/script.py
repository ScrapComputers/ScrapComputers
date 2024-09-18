import sys, os
from slpp import slpp as lua
from PIL import Image, ImageFont, ImageDraw

FontCharacters = " !\"#$%&'()*+,-./0123456789:;<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~⌂ ¡¢£¤¥¦§¨©ª«¬-®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåU+00E5æçèéêëìíîïðñòóôõö÷øùúûüýþÿĀāĂăĄąĆćĈĉĊċČčĎďĐđĒēĔĕĖėĘęĚěĜĝĞğĠġĢģĤĥĦħĨĩĪīĬĭĮįİıĲĳĴĵĶķĸĹĺĻļĽľĿŀŁłŃńŅņŇňŉŊŋŌōŎŏŐőŒœŔŕŖŗŘřŚśŜŝŞşŠšŢţŤťŦŧŨũŪūŬŭŮůŰűŲųŴŵŶŷŸŹźŻżŽžſƒơƷǺǻǼǽǾǿȘșȚțɑɸˆˇˉ˘˙˚˛˜˝;΄΅Ά·ΈΉΊΌΎΏΐΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩΪΫάέήίΰαβγδεζηθικλμνξοπρςστυφχψωϊϋόύώϐϴЀЁЂЃЄЅІЇЈЉЊЋЌЍЎЏАБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдежзийклмнопрстуфхцчшщъыьэюяѐёђѓєѕіїјљњћќѝўџҐґ־אבגדהוזחטיךכלםמןנסעףפץצקרשתװױײ׳״ᴛᴦᴨẀẁẂẃẄẅẟỲỳ‐‒–—―‗‘’‚‛“”„‟†‡•…‧‰′″‵‹›‼‾‿⁀⁄⁔⁴⁵⁶⁷⁸⁹⁺⁻ⁿ₁₂₃₄₅₆₇₈₉₊₋₣₤₧₪€℅ℓ№™Ω℮⅐⅑⅓⅔⅕⅖⅗⅘⅙⅚⅛⅜⅝⅞←↑→↓↔↕↨∂∅∆∈∏∑−∕∙√∞∟∩∫≈≠≡≤≥⊙⌀⌂⌐⌠⌡─│┌┐└┘├┤┬┴┼═║╒╓╔╕╖╗╘╙╚╛╜╝╞╟╠╡╢╣╤╥╦╧╨╩╪╫╬▀▁▄█▌▐░▒▓■□▪▫▬▲►▼◄◊○●◘◙◦☺☻☼♀♂♠♣♥♦♪♫✓ﬁﬂ�"

def CreateErrorCharacter(FontWidth, FontHeight):
    output = "{"

    for x in range(FontHeight):
        if x == 0 or x == (FontHeight - 1):
            output = f"{output}\n\t\"{"#" * FontWidth}\","
        else:
            output = f"{output}\n\t\"#{"." * (FontWidth - 2)}#\","

    return output[:-1] + "\n}"

def CreateMap(FontPath, FontName, FontWidth, FontHeight, AdditionalPadding, OutputFilename):
    output = {}
    characters = list(FontCharacters)

    font = ImageFont.truetype(FontPath, size=FontHeight)

    for char in characters:
        image = Image.new("1", (FontWidth, FontHeight), color=0)
        draw = ImageDraw.Draw(image)

        draw.text((0, 0), char, fill=255, font=font)

        bitmap = [[1 if image.getpixel((x, y)) > 0 else 0 for x in range(image.width)] for y in range(image.height)]
        hex_strings = [''.join([f'0x{bitmap[y][x]:02X}' for x in range(len(bitmap[y]))]) for y in range(len(bitmap))]

        contents = []

        # Print the result for the current character
        for index, character in enumerate(hex_strings):
            cols = character.replace("0x", " ").split(" ")
            cols.pop(0)

            newCols = []

            for col in cols:
                newCols.append(col.removeprefix("0"))

            rowData = ("".join(newCols).replace("1", "#").replace("0", "."))

            contents.append(rowData + ("." * AdditionalPadding))

        output[char.replace("\\", "\\\\").replace("\"", "\\\"")] = contents


    result = lua.encode(output).replace("\n		", "").replace("\n	},", "},").replace("\n	}\n}", "}\n}")

    with open(OutputFilename, "w", encoding="utf8") as f:
        f.write("local data = {}\n\n")
        f.write(f"data.fontWidth = {FontWidth + AdditionalPadding}\n")
        f.write(f"data.fontHeight = {FontHeight}\n")
        f.write(f"data.characters = \"{FontCharacters.replace("\\", "\\\\").replace("\"", "\\\"")}\"\n")
        f.write(f"data.errorChar = {CreateErrorCharacter(FontWidth + AdditionalPadding, FontHeight)}\n\n")
        f.write(f"data.charset = {result}\n")
        f.write(f"sm.scrapcomputers.fontManager.fonts[\"{FontName}\"] = data")

def main():
    if len(sys.argv) > 1 and sys.argv[1].lower() == "--auto":
        for file in os.listdir("Fonts"):
            if not file.endswith(".txt"):
                with open(f"Fonts/{file.removesuffix(".ttf")}.txt", "r") as f:
                    lines = f.readlines()

                    FontWidth, FontHeight = map(int, lines[0].split("x"))

                    CreateMap(f"Fonts/{file}", file.removesuffix(".ttf"), FontWidth, FontHeight, int(lines[1]), f"Generated/{file.removesuffix(".ttf")}.lua")

                    print(f"Generated Font: \"{file.removesuffix(".ttf")}\"")
        return
    
    print("The seletected font would be the font.tff on the directory where this script.py file is located.")

    FontName = input("Font name: ")

    while True:
        FontSize = input("Font size (width x height): ")
        try:
            FontWidth, FontHeight = map(int, FontSize.split('x'))
            break
        except ValueError:
            print("Invalid input format. Please enter width and height separated by 'x'. (Example: 5x6)")

    while True:
        AdditionalPadding = input("Additional Padding (x only!): ")
        try:
            AdditionalPadding, AdditionalPadding = int(AdditionalPadding)
            break
        except ValueError:
            print("Not a number!")
    

    CreateMap("font.ttf", FontName, FontWidth, FontHeight, AdditionalPadding, "GeneratedFont.lua")

    print("Generated font!")

if __name__ == "__main__":
    main()