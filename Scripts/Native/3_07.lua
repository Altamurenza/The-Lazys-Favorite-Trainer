-- 3_07.LUA
-- AUTHOR	: ALTAMURENZA


function MissionSetup()
	DATLoad('3_07.DAT', 2)
	DATInit()
	
	LoadAnimationGroup('Hang_Talking')
	AreaTransitionXYZ(14, -507.0, 317.7, 31.4)
end

function MissionCleanup()
	UnLoadAnimationGroup('Hang_Talking')
	DATUnload(2)
end

local function WaitSpeech(Speaker, Pedro, Justin, Trevor)
	repeat
		Wait(0)
		local IsDisturbed = PedIsHit(Pedro, 2, 1000)
			or PedIsHit(Justin, 2, 1000)
			or PedIsHit(Trevor, 2, 1000)
		
		if IsDisturbed or AreaGetVisible() ~= 14 then
			return true
		end
	until not SoundSpeechPlaying(Speaker)
	return false
end

function main()
	local Pedro = PedCreatePoint(69, POINTLIST._3_07_Pedro)
	local Justin = PedCreatePoint(34, POINTLIST._3_07_Justin)
	local Trevor = PedCreatePoint(73, POINTLIST._3_07_Trevor)
	
	PedSetActionNode(Pedro, '/Global/Animations/Listening', 'Act/Conv/3_07.act')
	PedSetActionNode(Justin, '/Global/Animations/Talking', 'Act/Conv/3_07.act')
	PedSetActionNode(Trevor, '/Global/Animations/Listening', 'Act/Conv/3_07.act')
	
	local Failed = false
	local Line = 0
	local Speaker = {
		Justin,
		Pedro,
		Trevor,
		Justin,
		Pedro,
		Justin,
	}
	
	repeat
		Wait(0)
		Line = Line + 1
		
		SoundPlayScriptedSpeechEvent(Speaker[Line], 'M_3_07', Line, 'xtralarge')
		local Time = (Line == 4 or Line == 5) and 5 or 3
		TextPrint('3_07_Speech0'..Line, Time, 2)
		
		Failed = WaitSpeech(Speaker[Line], Pedro, Justin, Trevor)
	until Failed or Line >= 6
	
	if Line >= 6 then
		Wait(3000)
	end
	
	for _, Ped in ipairs({Pedro, Justin, Trevor}) do
		PedSetActionNode(Ped, '/Global', 'Globals.act')
		PedSetAITree(Ped, '/Global/AI', 'Act/AI/AI.act')
		PedMakeAmbient(Ped)
	end
	MissionSucceed(false, false, false)
end