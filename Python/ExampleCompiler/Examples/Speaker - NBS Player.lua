-- Convert a NBS file into base64 and put it into the string below and it should work.
local nbsData = sc.base64.decode("RAW NBS DATA")

local speaker = sc.getSpeakers()[1]
assert(speaker, "Speaker not found! Make sure you have connected a Speaker to the computer!")

local player = sc.nbs.createPlayer(sc.nbs.loadNBS(nbsData), speaker)

function onLoad()
	player:setLooped(true)
	player:start()
end

function onUpdate()
	player:update()
end