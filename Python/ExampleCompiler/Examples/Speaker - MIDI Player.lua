-- Put ur converted MIDI data in this string! Don't convert the " to ' or else you will get lua parser errors!
local data = 'YOUR MIDI DATA'

local speaker = sc.getSpeakers()[1]
assert(speaker, "Speaker not found! Make sure you have connected a Speaker to the computer!")

local player = sc.midi.createPlayer(sm.json.parseJsonString(data), speaker)

function onLoad()
	player:toggleLoop(true)
	player:start()
end

function onUpdate()
	player:update()
end