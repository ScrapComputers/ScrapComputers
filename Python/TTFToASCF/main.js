// LIBRARIES
import opentype from 'opentype.js';
import earcut from 'earcut';
import fs from "fs/promises";
import fsSync from "fs";


// CONFIGURATION
let CharacterMap = "!\"#$%&'()*+,-./0123456789:<=>?@ABCDEFGHIJKLMNOPQRSTUVWXYZ[\\]^_`abcdefghijklmnopqrstuvwxyz{|}~⌂ ¡¢£¤¥¦§¨©ª«¬-®¯°±²³´µ¶·¸¹º»¼½¾¿ÀÁÂÃÄÅÆÇÈÉÊËÌÍÎÏÐÑÒÓÔÕÖ×ØÙÚÛÜÝÞßàáâãäåU+00E5æçèéêëìíîïðñòóôõö÷øùúûüýþÿĀāĂăĄąĆćĈĉĊċČčĎďĐđĒēĔĕĖėĘęĚěĜĝĞğĠġĢģĤĥĦħĨĩĪīĬĭĮįİıĲĳĴĵĶķĸĹĺĻļĽľĿŀŁłŃńŅņŇňŉŊŋŌōŎŏŐőŒœŔŕŖŗŘřŚśŜŝŞşŠšŢţŤťŦŧŨũŪūŬŭŮůŰűŲųŴŵŶŷŸŹźŻžŽžſƒơƷǺǻǼǽǾǿȘșȚțɑɸˆˇˉ˘˙˚˛˜˝;΄΅Ά·ΈΉΊΌΎΏΐΑΒΓΔΕΖΗΘΙΚΛΜΝΞΟΠΡΣΤΥΦΧΨΩΪΫάέήίΰαβγδεζηθικλμνξοπρςστυφχψωϊϋόύώϐϴЀЁЂЃЄЅІЇЈЉЊЋЌЍЎЏАБВГДЕЖЗИЙКЛМНОПРСТУФХЦЧШЩЪЫЬЭЮЯабвгдежзийклмнопрстуфхцчшщъыьэюяѐёђѓєѕіїјљњћќѝўџҐґ־אבגדהוזחטיךכלםמןנסעףפץצקרשתװױײ׳״ᴛᴦᴨẀẁẂẃẄẅẟỲỳ‐‒–—―‗‘’‚‛“”„‟†‡•…‧‰′″‵‹›‼‾‿⁀⁄⁔⁴⁵⁶⁷⁸⁹⁺⁻ⁿ₁₂₃₄₅₆₇₈₉₊₋₣₤₧₪€℅ℓ№™Ω℮⅐⅑⅓⅔⅕⅖⅗⅘⅙⅚⅛⅜⅝⅞←↑→↓↔↕↨∂∅∆∈∏∑−∕∙√∞∟∩∫≈≠≡≤≥⊙⌀⌂⌐⌠⌡─│┌┐└┘├┤┬┴┼═║╒╓╔╕╖╗╘╙╚╛╜╝╞╟╠╡╢╣╤╥╦╧╨╩╪╫╬▀▁▄█▌▐░▒▓■□▪▫▬▲►▼◄◊○●◘◙◦☺☻☼♀♂♠♣♥♦♪♫✓ﬁﬂ";
const UseASCII = false;
const BezierTotalSteps = 2;
const BezierStepSize = 1.0;


// SOURCE CODE
function distance(p1, p2) {
    const dx = p1.x - p2.x, dy = p1.y - p2.y;
    return Math.sqrt(dx * dx + dy * dy);
}

function lerp(p1, p2, t) {
    return { x: (1 - t) * p1.x + t * p2.x, y: (1 - t) * p1.y + t * p2.y };
}

function cross(p1, p2) {
    return p1.x * p2.y - p1.y * p2.x;
}

const EPSILON = 1e-6;
class Polygon {
    points = []
    /** @type {Polygon[]} */
    children = []
    area = 0.0 

    moveTo(p) {
        this.points.push(p);
    }
    lineTo(p) {
        this.points.push(p);
    }
    close() {
        let cur = this.points[this.points.length - 1];
        this.points.forEach(next => {
            this.area += 0.5 * cross(cur, next);
            cur = next;
        });
    }
    conicTo(p, p1) {
        const p0 = this.points[this.points.length - 1];
        const dist = distance(p0, p1) + distance(p1, p);
        const steps = Math.max(2, Math.min(BezierTotalSteps, dist / BezierStepSize));

        for (let i = 1; i <= steps; ++i) {
            const t = i / steps;

            this.points.push(lerp(lerp(p0, p1, t), lerp(p1, p, t), t));
        }
    }
    cubicTo(p, p1, p2) {
        const p0 = this.points[this.points.length - 1];
        const dist = distance(p0, p1) + distance(p1, p2) + distance(p2, p);
        const steps = Math.max(2, Math.min(BezierTotalSteps, dist / BezierStepSize));

        for (let i = 1; i <= steps; ++i) {
            const t = i / steps;
            const a = lerp(lerp(p0, p1, t), lerp(p1, p2, t), t);
            const b = lerp(lerp(p1, p2, t), lerp(p2, p, t), t);

            this.points.push(lerp(a, b, t));
        }
    }
    inside(p) {
        let count = 0, cur = this.points[this.points.length - 1];
        this.points.forEach(next => {
            const p0 = (cur.y < next.y ? cur : next);
            const p1 = (cur.y < next.y ? next : cur);

            if (p0.y < p.y + EPSILON && p1.y > p.y + EPSILON) {
                if ((p1.x - p0.x) * (p.y - p0.y) > (p.x - p0.x) * (p1.y - p0.y)) {
                    count += 1;
                }
            }
            cur = next;
        });
        return (count % 2) !== 0;
    }
}

// Adjust character map if using ASCII
if (UseASCII)
    CharacterMap = Array.from({ length: 256 }, (_, i) => String.fromCharCode(i)).join('');

const RoundNumbersInObject = (Obj) => {
    for (const Key in Obj) {
        if (typeof Obj[Key] === 'number')
            Obj[Key] = Math.round(Obj[Key] * 100) / 100;
        else if (typeof Obj[Key] === 'object' && Obj[Key] !== null)
            RoundNumbersInObject(Obj[Key]);
    }

    return Obj;
};

const ReplaceFileExtension = (Filename, NewExtension) => {
    const LastDotIndex = Filename.lastIndexOf(".");
    return LastDotIndex !== -1 ? `${Filename.slice(0, LastDotIndex)}.${NewExtension}` : `${Filename}.${NewExtension}`;
};

const ConvertFont = async (FontName) => {
    const Font = await opentype.load(`Fonts/${FontName}`);
    const Scale = ((1000 * 100) / (Font.unitsPerEm * 72));

    const Glyphs = {};
    
    for (const Character of CharacterMap) {
        const Glyph = Font.charToGlyph(Character);
        if (!Glyph) continue;
        const Unicodes = [];

        if (Glyph.unicode !== undefined) Unicodes.push(Glyph.unicode);
        for (const Unicode of Glyph.unicodes)
            if (!Unicodes.includes(Unicode))
                Unicodes.push(Unicode);
        

        const GlyphMetrics = Glyph.getMetrics();
        const Output = {
            advanceWidth: Glyph.advanceWidth * Scale,
            metrics: {
                xMin: GlyphMetrics.xMin * Scale,
                xMax: GlyphMetrics.xMax * Scale,
                yMin: GlyphMetrics.yMin * Scale,
                yMax: GlyphMetrics.yMax * Scale,
                leftBearing: GlyphMetrics.leftSideBearing * Scale
            },
            triangles: []
        };

        if(Font.unitsPerEm > 1000)
            Output.advanceWidth = Glyph.advanceWidth * ((1000 * 100) / ((1000 + (Font.unitsPerEm - 1000) / 3) * 72))

        const Commands = Glyph.path.commands;
        const Polygons = []

        for (const Command of Commands) {
            const x = Command.x
            const y = Command.y
            const x1 = Command.x1
            const y1 = Command.y1
            const x2 = Command.x2
            const y2 = Command.y2

            switch (Command.type) {
                case 'M':
                    Polygons.push(new Polygon())
                    Polygons[Polygons.length - 1].moveTo({ x, y })
                    break;
                case 'L':
                    Polygons[Polygons.length - 1].moveTo({ x, y })
                    break;
                case 'C':
                    Polygons[Polygons.length - 1].cubicTo({ x, y }, { x: x1, y: y1 }, { x: x2, y: y2 });
                    break;
                case 'Q':
                    Polygons[Polygons.length - 1].conicTo({ x, y }, { x: x1, y: y1 });
                    break;
                case 'Z':
                    Polygons[Polygons.length - 1].close();
                    break;
            }
        }

        Polygons.sort((a, b) => Math.abs(b.area) - Math.abs(a.area));

        const RootPolygons = []
        for (let i = 0; i < Polygons.length; ++i) {
            let Parent = null;

            for (let j = i - 1; j >= 0; --j) {
                if (Polygons[j].inside(Polygons[i].points[0]) && Polygons[i].area * Polygons[j].area < 0) {
                    Parent = Polygons[j];
                    break;
                }
            }

            if (Parent)
                Parent.children.push(Polygons[i]);
            else
                RootPolygons.push(Polygons[i]);
        }

        const Triangles = []
        const TotalPoints = Polygons.reduce((sum, p) => sum + p.points.length, 0)
        const VertexData = new Float32Array(TotalPoints * 2)

        let VertexCount = 0
        /**
        * @param {Polygon} Polygon
        */
        const ProcessPolygon = (Polygon) => {
            const Coordinates = []; // x, y pairs for earcut
            const Holes = [];       // Starting indices for holes
            const Vertices = [];    // Final list of vertices for triangle output
            const Indices = [];     // Indices of the vertices forming triangles

            // Fill Coordinates and process any holes
            Polygon.points.forEach(({ x, y }) => Coordinates.push(x, y));
            Polygon.children.forEach(Child => {
                Child.children.forEach(ProcessPolygon);  // Recursive for nested children

                Holes.push(Coordinates.length / 2);      // Start of new hole in coordinates

                Child.points.forEach(({ x, y }) => Coordinates.push(x, y));
            });
            
            // Add coordinates to VertexData for all points in this polygon
            VertexData.set(Coordinates, VertexCount * 2);

            // Perform triangulation using earcut
            const ResultIndices = earcut(Coordinates, Holes);
            ResultIndices.forEach(Index => Indices.push(Index + VertexCount));
            VertexCount += Coordinates.length / 2;

            // Convert indices to triangles for output
            for (let i = 0; i < Indices.length; i += 3) {
                Triangles.push([
                    Indices[i],       // First vertex index of the triangle
                    Indices[i + 1],   // Second vertex index of the triangle
                    Indices[i + 2]    // Third vertex index of the triangle
                ]);
            }
        };
        RootPolygons.forEach(ProcessPolygon);

        // At this stage, Triangles array contains triangle definitions.
        for (let i = 0; i < Triangles.length; i++) {
            const [i1, i2, i3] = Triangles[i];
            Output.triangles.push([
                [VertexData[i1 * 2], VertexData[i1 * 2 + 1]],
                [VertexData[i2 * 2], VertexData[i2 * 2 + 1]],
                [VertexData[i3 * 2], VertexData[i3 * 2 + 1]],
            ]);
        }

        for (const Unicode of Unicodes)
            Glyphs[String.fromCodePoint(Unicode)] = Output;
    }

    const OutputData = {
        metadata: {
            names: {},
            ascender: Font.ascender * Scale,
            descender: Font.descender * Scale,
            underLinePosition: Font.tables.post.underlinePosition * Scale,
            underLineThickness: Font.tables.post.underlineThickness * Scale,
            boundingBox: {
                xMin: Font.tables.head.xMin * Scale,
                yMin: Font.tables.head.yMin * Scale,
                xMax: Font.tables.head.xMax * Scale,
                yMax: Font.tables.head.yMax * Scale
            },
            resolution: Font.unitsPerEm
        },
        glyphs: Glyphs
    };

    for (const [Key, Value] of Object.entries(Font.names))
        if (Value["en"])
            OutputData.metadata.names[Key] = Value["en"];
    
    const RoundedOutput = RoundNumbersInObject(OutputData);
    const OutputPath = `Generated/${ReplaceFileExtension(FontName, "ascf")}`;

    // Ensure the directory exists
    await fs.mkdir("Generated", { recursive: true });
    await fs.writeFile(OutputPath, JSON.stringify(RoundedOutput));
    console.log(`Font converted: ${FontName}`);
};

// Load fonts and convert each one
const Fonts = await fs.readdir("Fonts");
const FontNames = []

for (const Font of Fonts) {
    await ConvertFont(Font);

    FontNames.push(ReplaceFileExtension(Font, "ascf").replace(".ascf", ""))
}

const FontNamesLuaTable = `\{${JSON.stringify(FontNames).slice(1, -1)}\}`
const Data = `This file is not useful for you unless your a ScrapComputers Developer, Add this to the ASCFManager's font list:\n\nlocal installedFonts = ${FontNamesLuaTable}`

await fs.writeFile("generatedFonts.txt", Data, "utf8")