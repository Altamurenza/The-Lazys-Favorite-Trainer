-- TATTOOS.LUA
-- AUTHOR	: ALTAMURENZA

function main()
	DATLoad('SP_Trailer.dat', 0)
	DATLoad('Tattoos.dat', 0)
	
	F_PreDATInit()
	DATInit()
	
	shared.gAreaDataLoaded = true
	shared.gAreaDATFileLoaded[16] = true
	
	repeat
		Wait(0)
	until AreaGetVisible() ~= 16 or SystemShouldEndScript()
	DATUnload(0)
	
	shared.gAreaDataLoaded = false
	shared.gAreaDATFileLoaded[16] = false
end