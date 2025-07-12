-- HANDLER_WORLD.LUA
-- AUTHOR	: ALTAMURENZA


---------------------
-- # THREAD: TOGGLE #
---------------------

CreateThread(function()
	while true do
		if PlayerSettings.PauseClock and not ClockIsPaused() then
			PauseGameClock()
		end
		
		Wait(0)
	end
end)


-------------------------------------
-- # EVENT: EXPLORABLE TATTOOS SHOP #
-------------------------------------

RegisterLocalEventHandler('NativeScriptLoaded', function(Name, Env)
	local File = GetAreaFile()
	if type(File) == 'string' and Name == 'AreaScripts/'..File..'.lua' then
		SwapEnv(Env, Import, 'main')
		SetAreaFile(nil)
	end
end)