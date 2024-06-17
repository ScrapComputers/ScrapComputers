# VeraDev's isn't bothered enough to explain the code of what this does exactly but it converts all raw audio from audio.json into audio that
# sm.effect.createEffect can see and use. Let me tell you that this is one of the WORST ways of doing it as the first time this was successfully
# generated. it was 6800+ lines. Thats how horrible it is.
import json

output = {}

with open("../../audio.json", "r", encoding="utf8") as f:
    effects = json.load(f)
    
    for effectName in effects:
        output[f"ScrapComputers - {effectName}"] =  {
                		                                "parameterList": {},
		                                                    "effectList":
		                                                    [
		                                                    	{
		                                                    		"type": "audio",
		                                                    		"name": effectName,
		                                                    		"offset": { "x": 0.0, "y": 0.0, "z": 0.0 },
		                                                    		"parameters": []
		                                                    	}
		                                                    ]
                                                    }
        if effects[effectName] != {}:
            parameters = []
            parametersWithValues = {}

            for param in effects[effectName]["Parameters"]:
                parameters.append(param)
                parametersWithValues[param] = effects[effectName]["Parameters"][param]["default"]


            output[f"ScrapComputers - {effectName}"] =  {
                		                                    "parameterList": parametersWithValues,
		                                                        "effectList":
		                                                        [
		                                                        	{
		                                                        		"type": "audio",
		                                                        		"name": effectName,
		                                                        		"offset": { "x": 0.0, "y": 0.0, "z": 0.0 },
		                                                        		"parameters": parameters
		                                                        	}
		                                                        ]
                                                             }

with open("output.json", "w", encoding="utf8") as f:
    f.write(json.dumps(output, indent=4))