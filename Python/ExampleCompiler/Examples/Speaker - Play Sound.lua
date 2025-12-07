local speaker = sc.getSpeakers()[1]
assert(speaker, "Speaker not found! Make sure you have connected a Speaker to the computer!")

function onLoad()
	-- See https://github.com/Vajdani/sm_docs/blob/master/Lists/Audio.json for full list
	speaker.playSound("event:/music/robotheads/dance/dancebass")
end