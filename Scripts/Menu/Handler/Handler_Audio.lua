-- HANDLER_AUDIO.LUA
-- AUTHOR	: ALTAMURENZA


-------------------
-- # THREAD: MUTE #
-------------------

local function ToggleMute(Ped)
	if not PedIsValid(Ped) or Ped == gPlayer then
		return
	end
	if not PedGetFlag(Ped, 129) then
		PedSetFlag(Ped, 129, true)
	end
end

CreateThread(function()
	while true do
		if NPCSettings.Mute then
			for Ped in AllPeds() do
				ToggleMute(Ped)
			end
		end
		
		Wait(0)
	end
end)


---------------------------
-- # EVENT: SPEECH VOLUME #
---------------------------

local HackSpeechVolume = function(Env)
	local SetVolume = function(Func, Args)
		Args[4] = GetSpeechVolumeName()[NPCSettings.SpeechVolume]
		Args[4] = Args[4] == 'Extralarge' and 'xtralarge' or string.lower(Args[4])
		
		Func(unpack(Args))
	end
	
	if Env.SoundPlayScriptedSpeechEvent then
		Env.SoundPlayScriptedSpeechEvent = function(...)
			SetVolume(_G.SoundPlayScriptedSpeechEvent, arg)
		end
	end
	if Env.SoundPlayScriptedSpeechEventWrapper then
		Env.SoundPlayScriptedSpeechEventWrapper = function(...)
			SetVolume(_G.SoundPlayScriptedSpeechEventWrapper, arg)
		end
	end
end

RegisterLocalEventHandler('NativeScriptLoaded', function(Name, Env)
	if NPCSettings.SpeechVolume > 0 then
		HackSpeechVolume(Env)
	end
end)
