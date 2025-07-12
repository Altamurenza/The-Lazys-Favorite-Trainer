-- HANDLER_STORYLINE.LUA
-- AUTHOR	: ALTAMURENZA


-------------------------------------
-- # EVENT: START UNLISTED MISSIONS #
-------------------------------------

local Target = 'Test/TestMissionLog.lua'
RegisterLocalEventHandler('NativeScriptLoaded', function(Name, Env)
	local File = GetMissionFile()
	
	if type(File) == 'string' and Name == Target then
		SwapEnv(Env, File, 'MissionSetup', 'MissionCleanup', 'main')
		SetMissionFile(nil)
	end
end)