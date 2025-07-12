-- HEADER_STORYLINE.LUA
-- AUTHOR	: ALTAMURENZA


local MissionFile = nil
local MissionCode = {
	"1_01","1_02A","1_02B","1_02C","1_03","1_04","1_05","1_06_01","1_E01","1_07","1_08",
	"1_09","1_G1","1_11x1","1_11xp","1_11x2","1_10","1_B","Chapt1Trans","2_01","2_02","2_06",
	"2_G2","2_03","2_04","2_07","2_08","2_05","2_09","2_B","Chapt2Trans","3_01A","3_01D",
	"3_01","3_02","3_03","3_01C","3_07","3_08_Launch","3_08","3_XM","3_S10","3_G3","3_05",
	"3_04","3_06","3_B","Chapt3Trans","4_02","4_B1","4_01","4_03","4_G4","4_04","4_05",
	"4_06","4_B2","Chapt4Trans","5_09","5_01","5_02","5_04","5_03","5_05","6_01_Launch","6_01",
	"5_06","5_07a","5_B","6_02","6_03","6_B","2_S04","2_S07","2_S06","1_S01","2_S05",
	"2_S02","2_S05B","3_S11","3_R05B","4_S12","3_S03","3_R07","3_S08","5_G5","C_Chem_1","C_Chem_2",
	"C_Chem_3","C_Chem_4","C_Chem_5","C_Biology_1","C_Biology_2","C_Biology_3","C_Biology_4","C_Biology_5","C_ART_1","C_ART_2","C_ART_3",
	"C_ART_4","C_ART_5","C_Math_1","C_Math_2","C_Math_3","C_Math_4","C_Math_5","C_WRESTLING_1","C_WRESTLING_2","C_WRESTLING_3","C_WRESTLING_4",
	"C_WRESTLING_5","C_English_1","C_English_2","C_English_3","C_English_4","C_English_5","C_Photography_2","C_Photography_1","C_Photography_3","C_Photography_4","C_Photography_5",
	"C_Shop_1","C_Shop_2","C_Shop_3","C_Shop_4","C_Shop_5","C_Geography_1","C_Geography_2","C_Geography_3","C_Geography_4","C_Geography_5","C_Music_1",
	"C_Music_2","C_Music_3","C_Music_4","C_Music_5","C_Dodgeball_1","C_Dodgeball_2","C_Dodgeball_3","C_Dodgeball_4","C_Dodgeball_5","1_06_02","1_06_03",
	"1_06_04","1_06_07","1_06_08","3_R08_Rich1","3_R08_Rich2","3_R08_Rich3","3_R08_Rich4","3_R08_Rich5","3_R08_Rich6","3_R08_Rich7","3_R08_Business1",
	"3_R08_Business2","3_R08_Business3","3_R08_Business4","3_R08_Poor1","3_R08_Poor2","3_R08_School1","GoKart_GP1","GoKart_GP2","GoKart_GP3","GoKart_GP4","GoKart_GP5",
	"GoKart_SR1","GoKart_SR2","GoKart_SR3","LawnMowing1a","LawnMowing1b","LawnMowing1c","LawnMowing2a","LawnMowing2b","LawnMowing2c","LawnMowing3a","LawnMowing3b",
	"LawnMowing3c","P_Snow1","P_Snow2","P_Snow3","P_Snow4","P_Snow5","P_Snow6","2_R03","2_R03_X","JobLawnMowing1a","JobLawnMowing1b",
	"JobLawnMowing1c","JobLawnMowing2a","JobLawnMowing2b","JobLawnMowing2c","Coaster","Squid","FerrisWheel","MGCarniStriker","MGDunkTank","MGShooting","MGBaseballToss",
	"MGHackySack","SoccerPen","2_R11_Chad","2_R11_Bryce","2_R11_Justin","2_R11_Parker","2_R11_Random","MGFling","MGFend","TrainASumo","ArcadeRace",
	"ArcadeRace3D","Lockpick","BMXRUMBLE","ArcadeGame","LunarLander","MissileCommand","AG_SO","MGGandG","MGSmash","MGNuclearRain",
}

function IsMissionRegistered(Code)
--[[
	NOTE:
	
	These missions return -1, but they are listed here purely for mapping purposes.
	This helps identify which mission scripts need to be included in the "Natives" folder.
]]
	local Exception = {
		['3_03'] = true,
		['3_07'] = true,
	}
	if Exception[Code] then
		return false
	end
	return MissionGetIndex(Code) >= 0
end

function GetCurrentMissionIndex()
	if not MissionActive() then
		return
	end
	
	local Code = nil
	for _, Mission in ipairs(MissionCode) do
		if MissionActiveSpecific(Mission) then
			Code = Mission
			break
		end
	end
	
	return Code and MissionGetIndex(Code) or -1
end

function GetMissionFile()
	return MissionFile
end

function SetMissionFile(Code)
	MissionFile = Code
end

function ForceStartMissionFile(Code)
	MissionFile = Code
	ForceStartMissionIndex(459)
	
	local Name = GetLocalizedText(Code..'_TITLE')
	Name = string.len(Name) >= 2 and Name or 'Unnamed Mission'
	ReplaceLocalizedText('TML01', Name)
end